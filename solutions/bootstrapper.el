(load-all-files-from-dir (file-name-directory load-file-name) :exclude '("bootstrapper.el"))

(if (file-exists-p (concat emacs-root "/" "desktops" "/" "current.el")) (load-file (concat emacs-root "/" "desktops" "/" "current.el")))
(if (not (boundp 'my-current-desktop)) (setq my-current-desktop nil))
(setq desktop-root (concat emacs-root "/" "desktops" "/" (if (getenv "EMACS_DESKTOP") (getenv "EMACS_DESKTOP") my-current-desktop)))
(load-all-files-from-dir desktop-root)
(load-file (concat emacs-root "/" "desktops" "/" "desktop.el"))

