;; -*- mode: emacs-lisp; coding: emacs-mule; -*-

(add-project "lms" "/home/xeno_by/Projects/Delite/virtualization-lms-core/src" "virtualization-lms-core" "virtualization-lms-core")
(add-project "framework" "/home/xeno_by/Projects/Delite/Delite/framework/src/ppl/delite/framework" "Delite Framework" "Delite")
(add-project "optiml" "/home/xeno_by/Projects/Delite/Delite/dsls/optiml/src/ppl/dsl/optiml" "OptiML" "Delite")
(add-project "apps" "/home/xeno_by/Projects/Delite/Delite/apps/scala/src/ppl/apps/ml" "Scala Apps" "Delite")
(add-project "runtime" "/home/xeno_by/Projects/Delite/Delite/runtime/src/ppl/delite/runtime" "runtime" "runtime")
(add-project "scripts" "/home/xeno_by/Projects/Delite/Delite/scripts" nil)
(add-project "pages" "/home/xeno_by/Projects/Delite/Delite Pages" nil)
(add-project ".emacs" "/media/XENO/Dropbox/Software/Emacs" nil)

;; todo. find out why auto-mode-alist does not work
(add-to-list 'auto-mode-alist '("delite\\'" . scala-mode))
(add-to-list 'auto-mode-alist '("delitec\\'" . scala-mode))
(add-to-list 'auto-mode-alist '("delitecfg\\'" . scala-mode))
(add-to-list 'auto-mode-alist '("delites\\'" . scala-mode))
(add-to-list 'auto-mode-alist '("shared\\'" . scala-mode))
(add-hook 'after-change-major-mode-hook (lambda ()
  (when (buffer-file-name)
    (if (or (string-match "scripts/delite$" (buffer-file-name))
            (string-match "scripts/delitec$" (buffer-file-name))
            (string-match "scripts/delitecfg$" (buffer-file-name))
            (string-match "scripts/delites$" (buffer-file-name))
            (string-match "scripts/shared$" (buffer-file-name)))
      (if (not (eq major-mode 'scala-mode))
        (scala-mode))))))

(setq tool-buffers-autofollow nil)
(setq tool-buffers-display-in-bottom-window t)
(setq tool-buffers-display-in-right-window nil)

(defun my-run-project (name-or-path)
  (let ((name (project-name name-or-path)))
  (let ((function (intern (concat "my-run-" name))))
    (funcall function))))

(defun my-compile-project (name-or-path)
  (if (eq major-mode 'scala-mode)
    (let ((sbt-name (car (project-metadata name-or-path))))
    (let ((sbt-path (sbt-project-root (project-path name-or-path))))
      (sbt-compile sbt-name sbt-path)))))

(defun my-compile-project (name-or-path)
  (if (eq major-mode 'scala-mode)
    (let ((sbt-name (car (project-metadata name-or-path))))
    (let ((sbt-path (sbt-project-root (project-path name-or-path))))
      (sbt-compile sbt-name sbt-path)))))

(defun my-compile-master-project (name-or-path)
  (if (eq major-mode 'scala-mode)
    (let ((sbt-master-name (cadr (project-metadata name-or-path))))
    (let ((sbt-path (sbt-project-root (project-path name-or-path))))
      (sbt-compile sbt-master-name sbt-path)))))

