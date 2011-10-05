;; -*- mode: emacs-lisp  -*-

(add-project "hwk" "/media/XENO/Dropbox/Projects/Advanced Algorithms/Homeworks" nil)
(add-project "desktop" "/media/XENO/Dropbox/Software/Emacs/desktops/aa" nil)
(add-project ".emacs" "/media/XENO/Dropbox/Software/Emacs" nil)

(setq tool-buffers-autofollow nil)
(setq tool-buffers-display-in-bottom-window t)
(setq tool-buffers-display-in-right-window nil)
                                                                                        
(defun my-compile-project (name-or-path &optional file-name) 
  (let ((project-name (project-name name-or-path)))
  (let ((file-name (if file-name file-name (buffer-file-name))))
  (when (and project-name file-name)
    (if (equal file-name (buffer-file-name)) (save-buffer))
    (my-tex-compile project-name file-name)))))

(defun my-rebuild-project (name-or-path &optional file-name) 
  (let ((project-name (project-name name-or-path)))
  (let ((file-name (if file-name file-name (buffer-file-name))))
  (when (and project-name file-name)
    (if (equal file-name (buffer-file-name)) (save-buffer))
    (my-tex-compile project-name file-name)))))

(defun my-run-project (name-or-path &optional file-name)
  (let ((project-name (project-name name-or-path)))
  (let ((file-name (if file-name file-name (buffer-file-name))))
  (when (and project-name file-name)
    (if (equal file-name (buffer-file-name)) (save-buffer))
    (my-tex-compile project-name file-name)))))

(defun my-test-project (name-or-path &optional filename)
  (let ((project-name (project-name name-or-path)))
  (let ((file-name (if file-name file-name (buffer-file-name))))
  (when (and project-name file-name)
    (if (equal file-name (buffer-file-name)) (save-buffer))
    (my-tex-compile project-name file-name)))))
