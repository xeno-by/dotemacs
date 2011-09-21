;; -*- mode: emacs-lisp; -*-

(add-project "scratchpad" "/media/XENO/Dropbox/Projects/Foundations of Software/Scratchpad/src" "scratchpad" "scratchpad")
(add-project "nb" "/media/XENO/Dropbox/Projects/Foundations of Software/P1 - Numbers and Booleans/src" "nb" "nb")
(add-project "desktop" "/media/XENO/Dropbox/Software/Emacs/desktops/fos" nil)
(add-project ".emacs" "/media/XENO/Dropbox/Software/Emacs" nil)

(setq tool-buffers-autofollow nil)
(setq tool-buffers-display-in-bottom-window t)
(setq tool-buffers-display-in-right-window nil)
                                                                                        
(defun my-repl-project (name-or-path)
  (let ((project-name (project-name name-or-path)))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    ;;(sbt-invoke "*repl*" project-name ("compile" "console")))))
    (sbt-invoke "*repl*" project-name "compile" (lambda ()
      (insert "\n")
      (compilation-shell-minor-mode -1)
      (cd (sbt-project-root (sbt-invoke-project)))
      ;; todo. infer the correct scala and classpath
      (comint-exec (current-buffer) "scala" "scala" nil '("-classpath" "./target/scala-2.9.1.final/classes")))))))
                                                                                        
(defun my-compile-project (name-or-path)
  (let ((project-name (project-name name-or-path)))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    ;;(sbt-invoke "*compile*" project-name "compile" (lambda () (run-at-time 0 nil (lambda () (bury-buffer))))))))
    (sbt-invoke "*compile*" project-name "compile"))))
                                                                                        
(defun my-rebuild-project (name-or-path)
  (let ((project-name (project-name name-or-path)))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    ;;(sbt-invoke "*compile*" project-name '("clean" "compile") (lambda () (run-at-time 0 nil (lambda () (bury-buffer))))))))
    (sbt-invoke "*compile*" project-name '("clean" "compile")))))
                                                                                        
(defun my-run-project (name-or-path)
  (let ((project-name (project-name name-or-path)))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    ;;(sbt-invoke "*run*" project-name ("compile" "run")))))
    (sbt-invoke "*run*" project-name "compile" (lambda ()
      (insert "\n")
      (compilation-shell-minor-mode -1)
      (cd (sbt-project-root (sbt-invoke-project)))
      ;; todo. infer the correct scala, main class and classpath
      (comint-exec (current-buffer) "scala" "scala" nil '("-classpath" "./target/scala-2.9.1.final/classes" "fos.Arithmetic")))))))
                                                                                        
(defun my-test-project (name-or-path)
  (let ((project-name (project-name name-or-path)))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    ;;(sbt-invoke "*test*" project-name "test" (lambda () (run-at-time 0 nil (lambda () (bury-buffer))))))))
    (sbt-invoke "*test*" project-name "test"))))

