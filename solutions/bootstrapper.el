(load-file (concat emacs-root "/libraries/cedet-1.0/common/cedet.el"))
(add-to-list 'load-path (concat emacs-root "/libraries/ecb-2.40"))
(require 'ecb)

(load-all-files-from-dir (file-name-directory load-file-name) :exclude '("bootstrapper.el"))

(load-file (concat emacs-root "/" "desktops" "/" "current.el"))
(setq desktop-root (concat emacs-root "/" "desktops" "/" my-current-desktop))
(load-all-files-from-dir desktop-root)
(load-file (concat emacs-root "/" "desktops" "/" "desktop.el"))

(setq ecb-auto-activate t)
(ecb-activate)

