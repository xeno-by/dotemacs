(fset 'yes-or-no-p 'y-or-n-p)

(setq confirm-kill-emacs nil)

(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (flet ((process-list ())) ad-do-it))

(add-hook 'comint-exec-hook (lambda () 
  (process-kill-without-query (get-buffer-process (current-buffer)))))
