(global-set-key (kbd "<s-S-return>") (lambda () 
  (interactive)
  (when (eq major-mode 'compilation-mode)
    (recompile))
  (unless (eq major-mode 'compilation-mode)
    (if (fboundp 'my-test-project) 
      (my-test-project (buffer-file-name (current-buffer)))
      (message "my-test-project is not implemented")))))