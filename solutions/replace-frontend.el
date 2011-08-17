(global-set-key (kbd "C-S-h") (lambda (from-string to-string)
  (interactive 
   (let ((from-string (read-from-minibuffer "Replace in solution: ")))
   (let ((to-string (read-from-minibuffer (concat "Replace " from-string " in solution with: "))))
     (lsit from-string to-string))))
  (if (fboundp 'my-replace-string-in-solution) 
    (my-replace-string-in-solution from-string to-string)
    (message "my-replace-string-in-solution is not implemented"))))

(global-set-key (kbd "C-S-M-h") (lambda (from-string to-string)
  (interactive 
   (let ((from-string (read-from-minibuffer "Replace regexp in solution: ")))
   (let ((to-string (read-from-minibuffer (concat "Replace " from-string " regexp in solution with: "))))
     (lsit from-string to-string))))
  (if (fboundp 'my-replace-regexp-in-solution) 
    (my-replace-regexp-in-solution from-string to-string)
    (message "my-replace-regexp-in-solution is not implemented"))))

(global-set-key (kbd "s-S-h") (lambda (from-string to-string)
  (interactive 
   (let ((from-string (read-from-minibuffer "Query replace in solution: ")))
   (let ((to-string (read-from-minibuffer (concat "Query replace " from-string " in solution with: "))))
     (lsit from-string to-string))))
  (if (fboundp 'my-query-replace-string-in-solution) 
    (my-query-replace-string-in-solution from-string to-string)
    (message "my-query-replace-string-in-solution is not implemented"))))

(global-set-key (kbd "s-S-M-h") (lambda (from-string to-string)
  (interactive 
   (let ((from-string (read-from-minibuffer "Query replace regexp in solution: ")))
   (let ((to-string (read-from-minibuffer (concat "Query replace " from-string " regexp in solution with: "))))
     (lsit from-string to-string))))
  (if (fboundp 'my-query-replace-regexp-in-solution) 
    (my-query-replace-regexp-in-solution from-string to-string)
    (message "my-query-replace-regexp-in-solution is not implemented"))))
