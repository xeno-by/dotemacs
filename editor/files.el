(global-set-key (kbd "C-o") 'find-file)
(global-set-key (kbd "C-b") 'switch-to-buffer)

(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-S-s") (lambda () 
  (interactive) 
  (dolist (b (tabbar-buffer-list))
    (with-current-buffer b 
      (when (buffer-file-name) (save-buffer))))))
(global-set-key (kbd "C-S-a") 'write-file)
