(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-create-new-buffer 'always)
(ido-mode 1)

(global-set-key (kbd "C-o") 'find-file)
(global-set-key (kbd "C-n") 'new-empty-buffer) ;; now that's evil!
(global-set-key (kbd "C-b") 'switch-to-buffer)

