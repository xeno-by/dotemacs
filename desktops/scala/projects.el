;; -*- mode: emacs-lisp; -*-

(add-project "scratchpad" "/media/XENO/Dropbox/Scratchpad/Scala/src" "scratchpad" "scratchpad")
(add-project "desktop" "/media/XENO/Dropbox/Software/Emacs/desktops/scala" nil)
(add-project ".emacs" "/media/XENO/Dropbox/Software/Emacs" nil)

(setq tool-buffers-autofollow nil)
(setq tool-buffers-display-in-bottom-window t)
(setq tool-buffers-display-in-right-window nil)
                                                                                        
(defun my-repl-project (name-or-path)
  (let ((project-name "scratchpad"))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    ;;(sbt-invoke "*repl*" project-name ("compile" "console")))))
    (sbt-invoke "*repl*" project-name "compile" (lambda ()
      (insert "\n")
      (compilation-shell-minor-mode -1)
      (cd (sbt-project-root (sbt-invoke-project)))
      ;; todo. infer the correct scala and classpath
      (comint-exec (current-buffer) "scala" "scala" nil '("-classpath" "./target/scala-2.9.1/classes")))))))
                                                                                        
(defun my-compile-project (name-or-path)
  (let ((project-name "scratchpad"))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    ;;(sbt-invoke "*compile*" project-name "compile" (lambda () (run-at-time 0 nil (lambda () (bury-buffer))))))))
    (sbt-invoke "*compile*" project-name "compile"))))
                                                                                        
(defun my-rebuild-project (name-or-path)
  (let ((project-name "scratchpad"))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    ;;(sbt-invoke "*compile*" project-name '("clean" "compile") (lambda () (run-at-time 0 nil (lambda () (bury-buffer))))))))
    (sbt-invoke "*compile*" project-name '("clean" "compile")))))
                                                                                        
(defun my-run-project (name-or-path)
  (let ((main-class (read-from-minibuffer
    (concat "Main class"
      (if (and (boundp 'my-sbt-run-prev-main-class) 
               (stringp my-sbt-run-prev-main-class)
               (not (string= my-sbt-run-prev-main-class "")))
        (concat " (default " my-sbt-run-prev-main-class ")")
        "")
      ": "))))
    (if (and (string= main-class "")
             (boundp 'my-sbt-run-prev-main-class) 
             (stringp my-sbt-run-prev-main-class))
      (setq main-class my-sbt-run-prev-main-class))
    (setq my-sbt-run-prev-main-class main-class))

  (if (and (boundp 'my-sbt-run-prev-main-class) 
           (stringp my-sbt-run-prev-main-class)
           (not (string= my-sbt-run-prev-main-class "")))
    (let ((project-name "scratchpad"))
    (when project-name
      (if (buffer-file-name) (save-buffer))
      (sbt-invoke "*run*" project-name "compile" (lambda ()
        (insert "\n")
        (compilation-shell-minor-mode -1)
        (cd (sbt-project-root (sbt-invoke-project)))
        ;; todo. infer the correct scala and classpath
        (insert (concat "Running " my-sbt-run-prev-main-class "...\n"))
        (comint-exec (current-buffer) "scala" "scala" nil (list "-classpath" "./target/scala-2.9.1/classes" my-sbt-run-prev-main-class))))))))
                                                                                        
(defun my-test-project (name-or-path)
  (let ((project-name "scratchpad"))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    ;;(sbt-invoke "*test*" project-name "test" (lambda () (run-at-time 0 nil (lambda () (bury-buffer))))))))
    (sbt-invoke "*test*" project-name "test"))))

