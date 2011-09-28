;;(add-to-list 'load-path (concat emacs-root "/libraries/nemerle-0.2"))
;;(require 'nemerle-mode)
(load-file (concat emacs-root "/libraries/nemerle-0.2/nemerle.el"))
(add-to-list 'auto-mode-alist '("\\.n$" . nemerle-mode))
