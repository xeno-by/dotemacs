(add-to-list 'load-path (concat emacs-root "/libraries/scala-mode_2.9.0-1"))
(require 'scala-mode-auto)

(add-to-list 'load-path (concat emacs-root "/libraries/ensime-2.9.0-1-0.6.1/elisp"))
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

