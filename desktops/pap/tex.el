(defun my-compile-project (buffer)
  (myke-invoke "compile" buffer (lambda (status command buffer)
;;    (when status
      (let ((result (my-latex-result (buffer-file-name buffer))))
      (dolist (buffer (buffer-list))
        (with-current-buffer buffer
          (when (equal (buffer-file-name) result)
            (revert-buffer t t))))))))
;;            )
