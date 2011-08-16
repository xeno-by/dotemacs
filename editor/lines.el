(setq line-number-mode t)
(setq column-number-mode t)
;(global-linum-mode 1)
(add-hook 'find-file-hook (lambda () (linum-mode 1)))

