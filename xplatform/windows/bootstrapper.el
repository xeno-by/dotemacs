(if (or (not (stringp (getenv "APPDATA"))) (string= "" (getenv "APPDATA"))) (error "environment variable APPDATA not set"))

(setq emacs-root (concat (getenv "APPDATA") "\\.emacs.d"))
(setq xplatform-root (file-name-directory load-file-name))

(load-all-files-from-dir (file-name-directory load-file-name) :exclude '("bootstrapper.el"))
