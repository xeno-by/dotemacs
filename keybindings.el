;(windmove-default-keybindings)
(windmove-default-keybindings 'meta)

;; C-h is rebound to replace
(global-set-key (kbd "C-?") 'help-command)
(define-key undo-tree-map (kbd "C-?") 'help-command)

;; so that it works even if I miss M in "M-:"
(global-set-key (kbd "s-:") 'eval-expression)
(global-set-key (kbd "C-:") 'eval-expression)

(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-S-s") (lambda () 
  (interactive) 
  (dolist (b (tabbar-buffer-list))
    (with-current-buffer b 
      (when (buffer-file-name) (save-buffer))))))
(global-set-key (kbd "C-S-a") 'write-file)

(global-set-key (kbd "<C-escape>") (lambda ()
  (interactive)
  (unless (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (bury-buffer))))
(global-set-key (kbd "<s-escape>") (lambda ()
  (interactive)
  (unless (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (unbury-buffer))))

(global-set-key (kbd "<C-f1>") (lambda ()
  (interactive)
  (ielm)))
(global-set-key (kbd "<C-f2>") (lambda ()
  (interactive)
  (switch-to-buffer "*Messages*")))

