(add-to-list 'load-path (concat emacs-root "/libraries/scala-mode_2.9.1"))
(require 'scala-mode-auto)

(add-to-list 'load-path (concat emacs-root "/libraries/ensime-2.9.1-0.7.6/elisp"))
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

