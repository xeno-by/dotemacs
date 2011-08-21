;;(add-to-list 'load-path (concat emacs-root "/libraries/dos-2.16"))
;;(require 'dos)
;;(add-to-list 'auto-mode-alist '("\\.bat$" . dos-mode))
;;(add-to-list 'auto-mode-alist '("\\.cmd$" . dos-mode))

(add-to-list 'load-path (concat emacs-root "/libraries/ntcmd-1.0"))
(require 'ntcmd)
(add-to-list 'auto-mode-alist '("\\.bat$" . ntcmd-mode))
(add-to-list 'auto-mode-alist '("\\.cmd$" . ntcmd-mode))