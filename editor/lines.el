(setq line-number-mode t)
(setq column-number-mode t)

;; unfortunately, linum slows down scrolling considerably
(global-linum-mode 1)
(add-hook 'find-file-hook (lambda () (if (not (equal major-mode 'doc-view-mode)) (linum-mode 1))))
(global-set-key (kbd "C-l") 'goto-line)

(global-set-key (kbd "<home>") 'beginning-of-visual-line)
(global-set-key (kbd "<end>") 'end-of-visual-line)