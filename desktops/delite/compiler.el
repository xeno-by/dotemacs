(defun sbt-project-root (path)
  (while (and (not (file-exists-p (concat path "/project/build.properties")))
              (not (equal path (file-truename (concat path "/..")))))
    (setf path (file-truename (file-truename (concat path "/..")))))
  (if (file-exists-p (concat path "/project/build.properties")) path nil))

;; partially copy/pasted from ensime-sbt.el
(defun sbt-compile (sbt-name sbt-path)
  (when (and sbt-name sbt-path)
    (let ((target-buffer (get-buffer "*sbt*")))
    (if target-buffer (kill-buffer target-buffer))
    (setq target-buffer (get-buffer-create "*sbt*"))
    (set-buffer target-buffer)
    
    ;; todo. this does not work. why?!
    ;;(set (make-local-variable 'sbt-compile-name) sbt-name)
    ;;(set (make-local-variable 'sbt-compile-path) sbt-path)
    ;;(set (make-local-variable 'sbt-compile-status) nil)
    (setq sbt-compile-name sbt-name)
    (setq sbt-compile-path sbt-path)
    (setq sbt-compile-status nil)

    (let ((target-window 
      (cond 
        ((and (boundp 'tool-buffers-display-in-bottom-window) tool-buffers-display-in-bottom-window)
         (if (top-window) (active-window)
         (if (bottom-window) (bottom-window) 
         (split-window-vertically))))
        ((and (boundp 'tool-buffers-display-in-right-window) tool-buffers-display-in-right-window)
         (if (left-window) (left-window)
         (if (right-window) (right-window) 
         (split-window-horizontally))))
        (t
         (active-window)))))
    (let ((pop-up-windows t)) (set-window-buffer target-window target-buffer))
    (select-window target-window)))

    (comint-mode)
    (set (make-local-variable 'comint-process-echoes) t)
    (set (make-local-variable 'comint-scroll-to-bottom-on-output) t)
    (set (make-local-variable 'comint-prompt-read-only) t)
    (set (make-local-variable 'ansi-color-for-comint-mode) t)
    (set (make-local-variable 'comint-output-index) 0)
    (set (make-local-variable 'comint-output-history) "")
    (set (make-local-variable 'comint-output-filter-functions) '(ansi-color-process-output comint-postoutput-scroll-to-bottom (lambda (chunk)
      (while (string-match ansi-color-regexp chunk)
        (setq chunk (replace-match "" nil t chunk)))
      (setq comint-output-history (concat comint-output-history chunk))

      (when (string-match "[ \t\r\n\v\f]+> $" comint-output-history)
        (let ((raw (replace-match "" nil t comint-output-history)))
        (let ((lines ()))
          (with-temp-buffer
            (insert raw)
            (goto-char (point-min))
            (while (not (eobp))
              (setq lines (append lines (list (chomp (thing-at-point 'line)))))
              (forward-line)))
          ;;(princ lines)
          ;;(princ (length lines))
          ;;(message (number-to-string comint-output-index))
          (setq comint-output-index (+ comint-output-index 1))
          (setq comint-output-history "")
          (if (and (boundp 'sbt-output-callback) (functionp sbt-output-callback)) (funcall sbt-output-callback lines))))))))

    (set (make-local-variable 'compilation-error-regexp-alist)
         '(("^\\[error\\] \\([_.a-zA-Z0-9/-]+[.]scala\\):\\([0-9]+\\):"
            1 2 nil 2 nil)))
    (set (make-local-variable 'compilation-mode-font-lock-keywords)
         '(("^\\[error\\] Error running compile:"
            (0 compilation-error-face))
           ("^\\[warn\\][^\n]*"
            (0 compilation-warning-face))
           ("^\\(\\[info\\]\\)\\([^\n]*\\)"
            (0 compilation-info-face)
            (1 compilation-line-face))
           ("^\\[success\\][^\n]*"
            (0 compilation-info-face))))
    (compilation-shell-minor-mode t)

    (defvar sbt-minor-mode-map (make-keymap) "sbt-minor-mode keymap.")
    (define-key sbt-minor-mode-map (kbd "<tab>") 'compilation-next-error)
    (define-key sbt-minor-mode-map (kbd "<backtab>") 'compilation-previous-error)
    (define-key sbt-minor-mode-map (kbd "<return>") (lambda ()
      (interactive)
      (if (and (get-buffer-process (current-buffer)) (eq (point) (point-max)))
        (comint-send-input)
        (compile-goto-error))))
    (define-key sbt-minor-mode-map (kbd "<C-S-return>") (lambda ()
      (interactive)
      (if (and (get-buffer-process (current-buffer)) (eq (point) (point-max)))
        (comint-send-input)
        (progn
          (let ((name nil))
            (dolist (project projects)
              (when (string= sbt-compile-name (car (project-metadata (car project))))
                (setq name (car project))))
            (my-run-project name))))))
    (define-key sbt-minor-mode-map (kbd "C-S-b") (lambda () 
      (interactive) 
      (sbt-compile sbt-compile-name sbt-compile-path)))
    (define-key sbt-minor-mode-map (kbd "q") (lambda () 
      (interactive)
      (if (and (get-buffer-process (current-buffer)) (eq (point) (point-max)))
        (insert "q")
        (bury-buffer))))
    (define-key sbt-minor-mode-map (kbd "g") (lambda () 
      (interactive)
      (if (and (get-buffer-process (current-buffer)) (eq (point) (point-max)))
        (insert "g")
        (sbt-compile sbt-compile-name sbt-compile-path))))

    (define-minor-mode sbt-minor-mode "Hosts keybindings for sbt interactions" nil " sbt" 'sbt-minor-mode-map :global nil)
    (sbt-minor-mode 1)
    (defun my-minibuffer-setup-hook () (sbt-minor-mode 0))
    (add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

    ;; hello node.js => omg, I wish comint-send-input was synchronous!
    ;; todo. find out why making these variables local does not work
    (setq sbt-compile-next-step (lambda (&optional previous-step-output)
      ;;(message "sbt-compile-next-step")
      (let ((failed nil))
        (dolist (line previous-step-output) (if (string-match "^\\[error\\]" line) (setq failed t)))
        (when failed
          (setq sbt-compile-status 'failed)
          ;; I don't kill SBT here, since it might be useful to leverage its Scala console
          (setq sbt-output-callback nil)
          (setq sbt-compile-next-step nil)
          (goto-char (point-min))
          ;;(next-error 1))
          (next-error-no-select 1))
        (unless failed 
          (let ((next-step (car sbt-compilation-steps)))
            (setq sbt-compilation-steps (cdr sbt-compilation-steps))
            (when next-step 
              (insert next-step)
              (comint-send-input))
            (unless sbt-compilation-steps 
              (setq sbt-compile-status 'success)
              (setq sbt-output-callback nil)
              (setq sbt-compile-next-step nil)
              (comint-send-eof)
              ;;(run-at-time 0 nil (lambda () (bury-buffer)))))))))
              ))))))
    (setq sbt-output-callback sbt-compile-next-step)

    (setq sbt-compilation-steps 
      (list
        (concat "project " sbt-name)
        "update"
        "compile"
        (if (string= sbt-name "virtualization-lms-core") "publish-local" nil)))
    (cd (sbt-project-root sbt-path))
    (comint-exec (current-buffer) "sbt" "sbt" nil nil)))

(defadvice recompile (around override-recompile-for-sbt activate)
  (if (string= (buffer-name) "*sbt*")
    (sbt-compile sbt-compile-name sbt-compile-path)
    ad-do-it))

(defadvice revert-buffer (around override-revert-for-sbt activate)
  (if (string= (buffer-name) "*sbt*")
    (sbt-compile sbt-compile-name sbt-compile-path)
    ad-do-it))

;; no need to advice kill-buffer since it calls bury-buffer internally
(defadvice bury-buffer (around auto-kill-dedicated-sbt-window-on-bury activate)
  (let ((buffer-being-buried (buffer-name)))
  (let ((sole-window (sole-window)))
    (when (string= buffer-being-buried "*sbt*")
      (when (not sole-window)
        (message (buffer-name (current-buffer)))
        (delete-window))
      (when sole-window 
        ad-do-it))
    (when (not (string= buffer-being-buried "*sbt*"))
      ad-do-it))))
