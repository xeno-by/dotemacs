(set-default buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)
(set-default default-buffer-file-coding-system 'utf-8-unix)

(defun dos2unix ()
  "Convert a DOS formatted text buffer to UNIX format"
  (interactive)
  (message (concat "considering buffer " (buffer-name) " at " (buffer-file-name)))
  (if (or (equal buffer-file-coding-system 'undecided-unix) (equal buffer-file-coding-system 'utf-8-unix))
    (progn
      (message "no need to change coding system"))
    (progn
      (message (concat "changing coding system from " (symbol-name buffer-file-coding-system) " to utf-8-unix"))
      (set-buffer-file-coding-system 'utf-8-unix nil))))

(defun unix2dos ()
  "Convert a UNIX formatted text buffer to DOS format"
  (interactive)
  (message (concat "considering buffer " (buffer-name) " at " (buffer-file-name)))
  (if (or (equal buffer-file-coding-system 'undecided-dos) (equal buffer-file-coding-system 'utf-8-dos))
    (progn
      (message "no need to change coding system"))
    (progn
      (message (concat "changing coding system from " (symbol-name buffer-file-coding-system) " to utf-8-dos"))
      (set-buffer-file-coding-system 'utf-8-dos nil))))

(add-hook 'find-file-hook 'my-enforce-coding-system)
(add-hook 'before-save-hook 'my-enforce-coding-system)
(defun my-enforce-coding-system ()
  (if (or (equal buffer-file-coding-system 'no-conversion) (equal buffer-file-coding-system 'no-conversion-multibyte))
    (progn 
      (message (concat "coding-system for buffer " (buffer-name) " will not be enforced, since its contents are binary")))
    (progn
     (let ((coding-system (my-get-enforced-coding-system (buffer-file-name))))
       (if coding-system
         (progn
           (message (concat "coding-system for buffer " (buffer-name) " will be enforced as " (symbol-name coding-system)))
           (cond
            ((equal coding-system 'dos) (unix2dos))
            ((equal coding-system 'unix) (dos2unix))
            (t (error (concat "unsupported coding system: " (symbol-name coding-system))))))
         (progn
           (message (concat "coding-system for buffer " (buffer-name) " will not be enforced, since my-get-enforced-coding-system returned nil"))))))))

(defun my-get-enforced-coding-system (file)
  (let ((batchfile-p (and file (or (string= (file-name-extension file) "bat") (string= (file-name-extension file) "cmd")))))
  (if batchfile-p 'dos 'unix)))
    

