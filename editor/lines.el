(setq line-number-mode t)
(setq column-number-mode t)

;; causes a SIGNIFICANT performance hit on large files, but is useful anyways
;;(global-linum-mode 1)
(add-hook 'find-file-hook (lambda ()
  (if (and (not (equal major-mode 'doc-view-mode))
           (not (and (fboundp 'myke-command) (myke-command))))
    (linum-mode 1))))
(global-set-key (kbd "C-l") 'goto-line)
(global-set-key (kbd "C-g") 'goto-line)

(global-set-key (kbd "<home>") 'beginning-of-visual-line)
(global-set-key (kbd "<end>") 'end-of-visual-line)