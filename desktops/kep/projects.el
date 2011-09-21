;; -*- mode: emacs-lisp; coding: emacs-mule; -*-

(add-project "nsc" "/home/xeno_by/Projects/Scala/src/compiler/scala/tools/nsc/" nil)
(add-project "reflect" "/home/xeno_by/Projects/Scala/src/compiler/scala/reflect/" nil)

(setq tool-buffers-autofollow nil)
(setq tool-buffers-display-in-bottom-window t)
(setq tool-buffers-display-in-right-window nil)
                                                                                        
(defun my-compile-project (name-or-path)
  (if (eq major-mode 'scala-mode)
    (let ((sbt-name (car (project-metadata name-or-path))))
    (let ((sbt-path (sbt-project-root (project-path name-or-path))))
      (save-buffer)
      ()))))

(defun my-rebuild-project (name-or-path)
  (if (eq major-mode 'scala-mode)
    (let ((sbt-master-name (cadr (project-metadata name-or-path))))
    (let ((sbt-path (sbt-project-root (project-path name-or-path))))
      (save-buffer)
      ()))))

(defun my-run-project (name-or-path)
  (if (eq major-mode 'scala-mode)
    (let ((sbt-name (car (project-metadata name-or-path))))
    (let ((sbt-path (sbt-project-root (project-path name-or-path))))
      (save-buffer)
      ()))))

(defun my-test-project (name-or-path)
  (if (eq major-mode 'scala-mode)
    (let ((sbt-name (car (project-metadata name-or-path))))
    (let ((sbt-path (sbt-project-root (project-path name-or-path))))
      (save-buffer)
      ()))))
