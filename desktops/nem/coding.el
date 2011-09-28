(defadvice my-get-enforced-coding-system (around disable-enforcement-for-nemerle-files activate)
  (let ((file (ad-get-arg 0)))
  (let ((nemerlefile-p (and file (or (string= (file-name-extension file) "n")))))
  (if nemerlefile-p nil ad-do-it))))
    

