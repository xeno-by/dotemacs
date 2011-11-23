(require 'compile)

(global-set-key (kbd "C-S-b") (lambda ()
  (interactive)
  (if (fboundp 'my-compile-project)
    (my-compile-project (current-buffer))
    (message "my-compile-project is not implemented"))))

;; sorry, one more core emacs hotkey redefined...
(define-prefix-command 'my-compile-map)
(global-set-key (kbd "M-b") 'my-compile-map)

(define-key my-compile-map (kbd "r") (lambda ()
  (interactive)
  (if (fboundp 'my-rebuild-project)
    (my-rebuild-project (current-buffer))
    (message "my-rebuild-project is not implemented"))))

(define-key my-compile-map (kbd "M-r") (lambda ()
  (interactive)
  (if (fboundp 'my-rebuild-project)
    (my-rebuild-project (current-buffer))
    (message "my-rebuild-project is not implemented"))))

(setq next-error-highlight t)

(add-hook 'after-change-major-mode-hook (lambda ()
  (if (and (boundp 'tool-buffers-autofollow) tool-buffers-autofollow)
    (cond
     ((eq major-mode 'grep-mode)
      (next-error-follow-minor-mode 1))
     ((eq major-mode 'comint-mode)
      (next-error-follow-minor-mode 1))))))

(defadvice compilation-find-file (around customize-compilation-find-file activate)
  (message "hey yo")
  ;; xeno.by: arguable, though useful
  (when (not (sole-window)) (delete-window))

  (let ((marker (ad-get-arg 0)))
  (let ((filename (ad-get-arg 1)))
  (let ((directory (ad-get-arg 2)))
    (if (file-exists-p filename)
      (progn
        ad-do-it)
      (progn
        (let ((filename (solution-unabbrev-string filename)))
        (if (file-exists-p filename)
          (progn
            (let ((new-filename (file-name-nondirectory filename)))
            (let ((new-directory (file-name-directory filename)))
            (ad-set-arg 1 new-filename)
            (ad-set-arg 2 new-directory)
            ad-do-it)))
          (progn
            (if (file-name-directory filename)
              (progn
                ad-do-it)
              (progn
                (let ((matches (solution-abbrevd-files filename)))
                (cond
                 ((equal (length matches) 0)
                   ad-do-it)
                 ((equal (length matches) 1)
                   (let ((filename (solution-unabbrev-string (car matches))))
                   (let ((new-filename (file-name-nondirectory filename)))
                   (let ((new-directory (file-name-directory filename)))
                   (ad-set-arg 1 new-filename)
                   (ad-set-arg 2 new-directory)
                   ad-do-it))))
                 (t
                   (let ((filename (solution-unabbrev-string (ido-completing-read (concat "Find this " compilation-error " in: ") matches nil t))))
                   (let ((new-filename (file-name-nondirectory filename)))
                   (let ((new-directory (file-name-directory filename)))
                   (ad-set-arg 1 new-filename)
                   (ad-set-arg 2 new-directory)
                   ad-do-it)))))))))))))))))

;; courtesy of Trey Jackson, modified by xeno.by
;; http://stackoverflow.com/questions/2299133/emacs-grep-find-link-in-same-window
(eval-after-load "compile"
'(defun compilation-goto-locus (msg mk end-mk)
  "Jump to an error corresponding to MSG at MK.
All arguments are markers.  If END-MK is non-nil, mark is set there
and overlay is highlighted between MK and END-MK."

;; Activate buffer that we're jumping to
(let ((target-buffer (marker-buffer mk)))
(set-buffer target-buffer)

;; Infer the window we're going to draw the buffer into
(let ((compilation-buffer (marker-buffer msg)))
(let ((compilation-window (get-buffer-window compilation-buffer)))
(with-current-buffer compilation-buffer (compilation-set-window compilation-window msg))

(let ((active-window compilation-window))
(let ((top-window (top-window active-window)))
(let ((left-window (left-window active-window)))
(let ((target-window
 (cond
  ((and (boundp 'tool-buffers-display-in-bottom-window) tool-buffers-display-in-bottom-window)
   (if top-window top-window active-window))
  ((and (boundp 'tool-buffers-display-in-right-window) tool-buffers-display-in-right-window)
   (if left-window left-window active-window))
  (t
   active-window))))
(let ((pop-up-windows t)) (set-window-buffer target-window target-buffer))
(select-window target-window)
(switch-to-buffer target-buffer)

;; If narrowing gets in the way of going to the right place, widen.
(unless (eq (goto-char mk) (point)) (widen) (goto-char mk))
(if end-mk (push-mark end-mk t) (if mark-active (setq mark-active)))

;; If hideshow got in the way of seeing the right place, open permanently.
(dolist (ov (overlays-at (point))) (when (eq 'hs (overlay-get ov 'invisible)) (delete-overlay ov) (goto-char mk)))

;; Highlight the text between mk and end-mk
(let ((highlight-regexp (with-current-buffer compilation-buffer compilation-highlight-regexp)))
(when highlight-regexp
  (if (timerp next-error-highlight-timer)
      (cancel-timer next-error-highlight-timer))
  (unless compilation-highlight-overlay
    (setq compilation-highlight-overlay
      (make-overlay (point-min) (point-min)))
    (overlay-put compilation-highlight-overlay 'face 'next-error))
  (with-current-buffer target-buffer
    (save-excursion
      (if end-mk (goto-char end-mk) (end-of-line))
      (let ((end (point)))
    (if mk (goto-char mk) (beginning-of-line))
    (if (and (stringp highlight-regexp)
         (re-search-forward highlight-regexp end t))
        (progn
          (goto-char (match-beginning 0))
          (move-overlay compilation-highlight-overlay
                (match-beginning 0) (match-end 0)
                (current-buffer)))
      (move-overlay compilation-highlight-overlay
            (point) end (current-buffer)))
    (if (or (eq next-error-highlight t)
        (numberp next-error-highlight))
        ;; We want highlighting: delete overlay on next input.
        (add-hook 'pre-command-hook
              'compilation-goto-locus-delete-o)
      ;; We don't want highlighting: delete overlay now.
      (delete-overlay compilation-highlight-overlay))
    ;; We want highlighting for a limited time:
    ;; set up a timer to delete it.
    (when (numberp next-error-highlight)
      (setq next-error-highlight-timer
        (run-at-time next-error-highlight nil
                 'compilation-goto-locus-delete-o)))))))

;; Highlight the text between mk and end-mk
(when (and (eq next-error-highlight 'fringe-arrow))
  ;; We want a fringe arrow (instead of highlighting).
  (setq next-error-overlay-arrow-position
    (copy-marker (line-beginning-position))))))))))))))
