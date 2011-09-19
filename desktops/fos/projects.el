;; -*- mode: emacs-lisp; coding: emacs-mule; -*-

(add-project "scratchpad" "/media/XENO/Dropbox/Projects/Foundations of Software/Scratchpad/src" "scratchpad" "scratchpad")
(add-project "desktop" "/media/XENO/Dropbox/Software/Emacs/desktops/fos" nil)
(add-project ".emacs" "/media/XENO/Dropbox/Software/Emacs" nil)

(setq tool-buffers-autofollow nil)
(setq tool-buffers-display-in-bottom-window t)
(setq tool-buffers-display-in-right-window nil)
                                                                                        
(defun my-compile-project (name-or-path)
  (if (eq major-mode 'scala-mode)
    (let ((sbt-name (car (project-metadata name-or-path))))
    (let ((sbt-path (sbt-project-root (project-path name-or-path))))
      (save-buffer)
      (sbt-invoke sbt-name sbt-path "compile")))))

(defun my-compile-master-project (name-or-path)
  (if (eq major-mode 'scala-mode)
    (let ((sbt-master-name (cadr (project-metadata name-or-path))))
    (let ((sbt-path (sbt-project-root (project-path name-or-path))))
      (save-buffer)
      (sbt-invoke sbt-master-name sbt-path "compile")))))

(defun my-run-project (name-or-path)
  (if (eq major-mode 'scala-mode)
    (let ((sbt-name (car (project-metadata name-or-path))))
    (let ((sbt-path (sbt-project-root (project-path name-or-path))))
      (save-buffer)
      (sbt-invoke sbt-name sbt-path "run")))))

(defun my-test-project (name-or-path)
  (if (eq major-mode 'scala-mode)
    (let ((sbt-name (car (project-metadata name-or-path))))
    (let ((sbt-path (sbt-project-root (project-path name-or-path))))
      (save-buffer)
      (sbt-invoke sbt-name sbt-path "test")))))
