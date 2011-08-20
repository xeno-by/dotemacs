(fset 'yes-or-no-p 'y-or-n-p)

(setq confirm-kill-emacs nil)

(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (flet ((process-list ())) ad-do-it))

;;(defadvice yes-or-no-p (around hack-exit (prompt) activate)
;;  (cond
;;  ((string= prompt "Active processes exist; kill them and exit anyway? ") t)
;;  ((string= prompt "A compilation process is running; kill it? ") t)
;;  ((string= prompt "Buffer has a running process; kill it? ") t)
;;  (t ad-do-it)))

(add-hook 'comint-exec-hook (lambda () 
  (process-kill-without-query (get-buffer-process (current-buffer)))))
