(setq line-number-mode t)
(setq column-number-mode t)

;;(global-linum-mode 1)
(add-hook 'find-file-hook (lambda ()
  (if (and (not (equal major-mode 'doc-view-mode))
           (not (and (fboundp 'myke-command) (myke-command))))
    (linum-mode 1))))
(global-set-key (kbd "C-l") 'goto-line)

(global-set-key (kbd "<home>") 'beginning-of-visual-line)
(global-set-key (kbd "<end>") 'end-of-visual-line)