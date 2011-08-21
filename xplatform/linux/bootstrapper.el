(if (or (not (stringp (getenv "HOME"))) (string= "" (getenv "HOME"))) (error "environment variable HOME not set"))

(setq emacs-root (concat (getenv "HOME") "/.emacs.d"))
(setq xplatform-root (file-name-directory load-file-name))

(defun maximize-frame ()
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))

(defun swap-monitor ()
  (let ((script (concat xplatform-root "/" "swapmonitor.sh")))
  (set-file-modes script #o777)
  (call-process script)))
