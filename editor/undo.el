(add-to-list 'load-path (concat emacs-root "/libraries/undo-tree-0.3.1"))
(require 'undo-tree)
(global-undo-tree-mode)

(global-set-key (kbd "C-z") 'undo-tree-undo)
(global-set-key (kbd "C-y") 'undo-tree-redo)


