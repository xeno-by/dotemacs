(defun add-project (name path &rest metadata)
  (if (not (boundp 'projects)) (setq projects ()))
  (when (not (memq t (mapcar (lambda (project) (string= (car project) name)) projects)))
    (let ((project (list name path metadata)))
      (setq projects (append projects (list project)))
      (if (not (boundp 'ecb-source-path)) (setq ecb-source-path ()))
      (setq ecb-source-path (append ecb-source-path (list (list (cadr project) (car project))))
      project))))

(defun project-name (name-or-path)
  (let ((result nil))
    (when (file-name-directory name-or-path)
      (dolist (project projects)
        (let ((project-path (directory-file-name (file-truename (cadr project)))))
        (let ((path (file-truename name-or-path)))
          (when (starts-with path project-path)
            (setq result (car project)))))))
    (when (not (file-name-directory name-or-path))    
      (dolist (project projects)
        (let ((name name-or-path))
          (if (string= (car project) name)
            (setq result (car project))))))
    result))

(defun project-path (name-or-path)
  (let ((result nil))
    (when (file-name-directory name-or-path)
      (dolist (project projects)
        (let ((project-path (directory-file-name (file-truename (cadr project)))))
        (let ((path (file-truename name-or-path)))
          (when (starts-with path project-path)
            (setq result (cadr project)))))))
    (when (not (file-name-directory name-or-path))
      (dolist (project projects)
        (let ((name name-or-path))
          (when (string= (car project) name)
            (setq result (cadr project))))))
    result))

(defun project-metadata (name-or-path)
  (let ((result nil))
    (when (file-name-directory name-or-path)
      (dolist (project projects)
        (let ((project-path (directory-file-name (file-truename (cadr project)))))
        (let ((path (file-truename name-or-path)))
          (when (starts-with path project-path)
            (setq result (caddr project)))))))
    (when (not (file-name-directory name-or-path))    
      (dolist (project projects)
        (let ((name name-or-path))
          (when (string= (car project) name)
            (setq result (caddr project))))))
    result))

