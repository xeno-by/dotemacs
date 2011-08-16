(defun my-find-file-in-solution ()
  (interactive)
  (let ((options (solution-abbrevd-files)))
  (let ((selection (solution-unabbrev-string (ido-completing-read "Find file in solution: " options nil t))))
    (find-file selection))))

(global-set-key (kbd "C-o") 'my-find-file-in-solution)
(global-set-key (kbd "C-S-n") 'my-find-file-in-solution)

