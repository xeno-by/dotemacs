(defun my-search-string-in-solution (string) (my-solution-grep string 'plain nil))

(defun my-search-regexp-in-solution (string) (my-solution-grep string 'regexp nil))

(defun my-solution-grep (&optional string flavor filter)
  ;; xeno.by: declare locals that were parameters of `compilation-start'
  (let ((mode 'grep-mode))
  (let ((command "")) ;; xeno.by: actual command will be assembled below
  (let ((name-function nil))
  (let ((highlight-regexp nil))

  (let* ((name-of-mode
    (if (eq mode t)
        "compilation"
      (replace-regexp-in-string "-mode$" "" (symbol-name mode))))
   (thisdir default-directory)
   outwin outbuf)
    (with-current-buffer
  (setq outbuf
        (get-buffer-create
               (compilation-buffer-name name-of-mode mode name-function)))
      (let ((comp-proc (get-buffer-process (current-buffer))))
  (if comp-proc
      (if (or (not (eq (process-status comp-proc) 'run))
        (yes-or-no-p
         (format "A %s process is running; kill it? "
           name-of-mode)))
    (condition-case ()
        (progn
          (interrupt-process comp-proc)
          (sit-for 1)
          (delete-process comp-proc))
      (error nil))
        (error "Cannot have two processes in `%s' at once"
         (buffer-name)))))
      ;; first transfer directory from where M-x compile was called
      (setq default-directory thisdir)
      ;; Make compilation buffer read-only.  The filter can still write it.
      ;; Clear out the compilation buffer.
      (let ((inhibit-read-only t)
      (default-directory thisdir))
  ;; Then evaluate a cd command if any, but don't perform it yet, else
  ;; start-command would do it again through the shell: (cd "..") AND
  ;; sh -c "cd ..; make"
  (cd (if (string-match "^\\s *cd\\(?:\\s +\\(\\S +?\\)\\)?\\s *[;&\n]" command)
    (if (match-end 1)
        (substitute-env-vars (match-string 1 command))
      "~")
        default-directory))
  (erase-buffer)
  ;; Select the desired mode.
  (if (not (eq mode t))
            (progn
              (buffer-disable-undo)
              (funcall mode))
    (setq buffer-read-only nil)
    (with-no-warnings (comint-mode))
    (compilation-shell-minor-mode))
        ;; Remember the original dir, so we can use it when we recompile.
        ;; default-directory' can't be used reliably for that because it may be
        ;; affected by the special handling of "cd ...;".
        ;; NB: must be fone after (funcall mode) as that resets local variables
        (set (make-local-variable 'compilation-directory) thisdir)
  (if highlight-regexp
      (set (make-local-variable 'compilation-highlight-regexp)
     highlight-regexp))
        (if (or compilation-auto-jump-to-first-error
    (eq compilation-scroll-output 'first-error))
            (set (make-local-variable 'compilation-auto-jump-to-next) t))

  ;; xeno.by: figuring out the parameters of the search
  (let ((flavor (if flavor flavor
              (if (boundp 'my-solution-grep-local-flavor) my-solution-grep-local-flavor
              (if (boundp 'my-solution-grep-prev-flavor) my-solution-grep-prev-flavor
              nil)))))
  (setq my-solution-grep-prev-flavor flavor)
  (set (make-local-variable 'my-solution-grep-local-flavor) flavor)
  (let ((string (if (and (stringp string) (not (string= string ""))) string
                (if (boundp 'my-solution-grep-local-string) my-solution-grep-local-string
                (if (or (eq flavor 'regexp) (boundp 'my-solution-grep-prev-regex-string)) my-solution-grep-prev-regex-string
                (if (or (not (eq flavor 'regexp)) (boundp 'my-solution-grep-prev-vanilla-string)) my-solution-grep-prev-vanilla-string
                nil))))))
  (if (eq flavor 'regexp)
    (setq my-solution-grep-prev-regex-string string)
    (setq my-solution-grep-prev-vanilla-string string))
  (set (make-local-variable 'my-solution-grep-local-string) string)
  (let ((filter (if (stringp filter) filter
                (if (boundp 'my-solution-grep-local-filter) my-solution-grep-local-filter
                (if (boundp 'my-solution-grep-prev-filter) my-solution-grep-prev-filter
                nil)))))
  (setq my-solution-grep-prev-filter filter)
  (set (make-local-variable 'my-solution-grep-local-filter) filter)

  ;; xeno.by: printing the parameters of the search
  ;; Output a mode setter, for saving and later reloading this buffer.
  ;;(insert "-*- mode: " name-of-mode
  ;;  "; default-directory: " (prin1-to-string default-directory)
  ;;  " -*-\n"
  ;;  (format "%s started at %s\n\n"
  ;;    mode-name
  ;;    (substring (current-time-string) 0 19))
  ;;  command "\n")
  (insert (concat "Searching for: " (propertize string 'font-lock-face 'bold) "\n"))
  (insert (concat "Search engine is: " (propertize (if (eq flavor 'regexp) "egrep" "fgrep") 'font-lock-face 'bold) "\n"))
  (insert (concat "Searching in: " (propertize (if (and (stringp filter) (not (string= filter ""))) filter "all files") 'font-lock-face 'bold) "\n"))
  (insert (concat "Grep started at " (substring (current-time-string) 0 19) "\n"))
  (insert "\n")

  ;; xeno.by: composing the command that will perform the search
  (let ((find-command (find-files-in-solution-command filter)))
  (let ((grep-command (if (eq flavor 'regexp) "egrep -i --color=always" "fgrep -i --color=always")))
  (let ((abbrev-command (solution-abbrev-string-command)))
  ;; todo. quote search string properly
  (setq command (concat find-command " | xargs -0 -e " grep-command " -nH '" string "' | " abbrev-command))
  ;; this overcomes the "xargs exited abnormally with exit code 123" error
  ;; more details here: http://superuser.com/questions/197031/grep-exits-abnormally-with-code-123-when-running-rgrep-on-emacs
  (setq command (concat
    "pipe=\"$(mktemp)\"; "
    command " | tee \"$pipe\"; "
    "if [ $(wc -l \"$pipe\" | awk '{print $1}') = 0 ]; then exit 1; else exit 0; fi"))
  (set (make-local-variable 'my-solution-grep-local-command) command)
  ;;(insert (concat command "\n\n"))))))))
  ))))))

  (setq thisdir default-directory))
      (set-buffer-modified-p nil))
    ;; Pop up the compilation buffer.
    ;; http://lists.gnu.org/archive/html/emacs-devel/2007-11/msg01638.html
    (setq outwin (display-buffer outbuf))
    (with-current-buffer outbuf
      (let ((process-environment
       (append
        compilation-environment
        (if (if (boundp 'system-uses-terminfo) ; `if' for compiler warning
          system-uses-terminfo)
      (list "TERM=dumb" "TERMCAP="
      (format "COLUMNS=%d" (window-width)))
    (list "TERM=emacs"
          (format "TERMCAP=emacs:co#%d:tc=unknown:"
            (window-width))))
        ;; Set the EMACS variable, but
        ;; don't override users' setting of $EMACS.
        (unless (getenv "EMACS")
    (list "EMACS=t"))
        (list "INSIDE_EMACS=t")
        (copy-sequence process-environment))))
  (set (make-local-variable 'compilation-arguments)
       (list command mode name-function highlight-regexp))
  (set (make-local-variable 'revert-buffer-function)
       'compilation-revert-buffer)
  (set-window-start outwin (point-min))

  ;; Position point as the user will see it.
  (let ((desired-visible-point
         ;; Put it at the end if `compilation-scroll-output' is set.
         (if compilation-scroll-output
       (point-max)
     ;; Normally put it at the top.
     (point-min))))
    (if (eq outwin (selected-window))
        (goto-char desired-visible-point)
      (set-window-point outwin desired-visible-point)))

  ;; The setup function is called before compilation-set-window-height
  ;; so it can set the compilation-window-height buffer locally.
  (if compilation-process-setup-function
      (funcall compilation-process-setup-function))
  (compilation-set-window-height outwin)
  ;; Start the compilation.
  (if (fboundp 'start-process)
      (let ((proc
       (if (eq mode t)
           ;; comint uses `start-file-process'.
           (get-buffer-process
      (with-no-warnings
        (comint-exec
         outbuf (downcase mode-name)
         (if (file-remote-p default-directory)
             "/bin/sh"
           shell-file-name)
         nil `("-c" ,command))))
         (start-file-process-shell-command (downcase mode-name)
                   outbuf command))))
        ;; Make the buffer's mode line show process state.
        (setq mode-line-process
        (list (propertize ":%s" 'face 'compilation-warning)))
        (set-process-sentinel proc 'compilation-sentinel)
        (unless (eq mode t)
    ;; Keep the comint filter, since it's needed for proper handling
    ;; of the prompts.
    (set-process-filter proc 'compilation-filter))
        ;; Use (point-max) here so that output comes in
        ;; after the initial text,
        ;; regardless of where the user sees point.
        (set-marker (process-mark proc) (point-max) outbuf)
        (when compilation-disable-input
    (condition-case nil
        (process-send-eof proc)
      ;; The process may have exited already.
      (error nil)))
        (run-hook-with-args 'compilation-start-hook proc)
              (setq compilation-in-progress
        (cons proc compilation-in-progress)))
    ;; No asynchronous processes available.
    (message "Executing `%s'..." command)
    ;; Fake modeline display as if `start-process' were run.
    (setq mode-line-process
    (list (propertize ":run" 'face 'compilation-warning)))
    (force-mode-line-update)
    (sit-for 0)     ; Force redisplay
    (save-excursion
      ;; Insert the output at the end, after the initial text,
      ;; regardless of where the user sees point.
      (goto-char (point-max))
      (let* ((buffer-read-only nil) ; call-process needs to modify outbuf
       (status (call-process shell-file-name nil outbuf nil "-c"
           command)))
        (cond ((numberp status)
         (compilation-handle-exit
          'exit status
          (if (zerop status)
        "finished\n"
      (format "exited abnormally with code %d\n" status))))
        ((stringp status)
         (compilation-handle-exit 'signal status
                (concat status "\n")))
        (t
         (compilation-handle-exit 'bizarre status status)))))
    ;; Without async subprocesses, the buffer is not yet
    ;; fontified, so fontify it now.
    (let ((font-lock-verbose nil)) ; shut up font-lock messages
      (font-lock-fontify-buffer))
    (set-buffer-modified-p nil)
    (message "Executing `%s'...done" command)))
      ;; Now finally cd to where the shell started make/grep/...
      (setq default-directory thisdir)
      ;; The following form selected outwin ever since revision 1.183,
      ;; so possibly messing up point in some other window (bug#1073).
      ;; Moved into the scope of with-current-buffer, though still with
      ;; complete disregard for the case when compilation-scroll-output
      ;; equals 'first-error (martin 2008-10-04).
      (when compilation-scroll-output
  (goto-char (point-max))))

    ;; Make it so the next C-x ` will use this buffer.
    (setq next-error-last-buffer outbuf)))))))

(add-to-list 'special-display-buffer-names '("*grep*" my-display-grep))
(defun my-display-grep (target-buffer)
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
  (select-window target-window)
  target-window))

(defun my-solution-grep-do-research ()
  (interactive)
  (let ((string my-solution-grep-local-string))
  (let ((flavor my-solution-grep-local-flavor))
  (let ((filter my-solution-grep-local-filter))
    (my-solution-grep string flavor filter)))))
(defun my-solution-grep-do-filter ()
  (interactive)
  (let ((string my-solution-grep-local-string))
  (let ((flavor my-solution-grep-local-flavor))
  (let ((filter (read-from-minibuffer
    (concat "Search " my-solution-grep-local-string
            " in: ")
    (if (and (boundp 'my-solution-grep-local-filter)
             (stringp my-solution-grep-local-filter)
             (not (string= my-solution-grep-local-filter "")))
      my-solution-grep-local-filter
      ""))))
    (my-solution-grep string flavor filter)))))
(add-hook 'grep-setup-hook (lambda ()
  (define-key grep-mode-map (kbd "f") 'my-solution-grep-do-filter)
  (define-key grep-mode-map (kbd "n") 'my-solution-grep-do-filter))) ;; n = narrow

(defadvice recompile (around override-recompile-for-solution-grep activate)
  (if (boundp 'my-solution-grep-local-command)
    (my-solution-grep-do-research)
    ad-do-it))

(defadvice revert-buffer (around override-revert-for-solution-grep activate)
  (if (boundp 'my-solution-grep-local-command)
    (my-solution-grep-do-research)
    ad-do-it))

(add-hook 'after-change-major-mode-hook (lambda ()
  (if (and (boundp 'tool-buffers-autofollow) tool-buffers-autofollow)
    (cond
     ((eq major-mode 'grep-mode)
      (next-error-follow-minor-mode 1))
     ((eq major-mode 'comint-mode)
      (next-error-follow-minor-mode 1))))))

;; no need to advice kill-buffer since it calls bury-buffer internally
(defadvice bury-buffer (around auto-kill-dedicated-grep-window-on-bury activate)
  (let ((buffer-being-buried (buffer-name)))
  (let ((sole-window (sole-window)))
    (when (string= buffer-being-buried "*grep*")
      (when (not sole-window)
        (delete-window))
      (when sole-window
        ad-do-it))
    (when (not (string= buffer-being-buried "*grep*"))
      ad-do-it))))

;; this is an extra case, since "q" is bound directly to kill-window
;; and that cannot be handled by advicing bury-buffer
(defadvice quit-window (around auto-kill-dedicated-grep-window-on-quit activate)
  (let ((buffer-being-buried (buffer-name)))
    (when (string= buffer-being-buried "*grep*")
      (when (not (sole-window))
        (delete-window)))
      (when (not (string= buffer-being-buried "*grep*"))
        ad-do-it)))
