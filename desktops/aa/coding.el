(defadvice my-get-enforced-coding-system (around disable-enforcement-for-tex-files activate)
  (let ((file (ad-get-arg 0)))
  (let ((texfile-p (and file (or (string= (file-name-extension file) "tex")))))
  (if texfile-p nil ad-do-it))))
    

