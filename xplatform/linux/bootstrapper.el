(if (or (not (stringp (getenv "HOME"))) (string= "" (getenv "HOME"))) (error "environment variable HOME not set"))

(setq emacs-root (concat (getenv "HOME") "/.emacs.d"))
(setq xplatform-root (file-name-directory load-file-name))

(load-all-files-from-dir (file-name-directory load-file-name) :exclude '("bootstrapper.el"))
