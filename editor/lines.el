(setq line-number-mode t)
(setq column-number-mode t)
;(global-linum-mode 1)
(add-hook 'find-file-hook (lambda () (if (not (equal major-mode 'doc-view-mode)) (linum-mode 1))))


