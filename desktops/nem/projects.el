;; -*- mode: emacs-lisp  -*-

(add-project "ncc" "/home/xeno_by/Projects/Nemerle/ncc" nil)
(add-project "macros" "/home/xeno_by/Projects/Nemerle/macros" nil)
(add-project "linq" "/home/xeno_by/Projects/Nemerle/linq/Macro" nil)
(add-project "tests" "/home/xeno_by/Projects/Nemerle/linq/Tests" nil)
(add-project "play" "/home/xeno_by/Projects/Playground/Nemerle" nil)
(add-project "desktop" "/media/XENO/Dropbox/Software/Emacs/desktops/nem" nil)
(add-project ".emacs" "/media/XENO/Dropbox/Software/Emacs" nil)

(setq tool-buffers-autofollow nil)
(setq tool-buffers-display-in-bottom-window t)
(setq tool-buffers-display-in-right-window nil)
                                                                                        
(defun my-repl-project (name-or-path) 
  (let ((project-name (project-name name-or-path)))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    (sbt-invoke "*repl*" "play" "repl"))))
                                                                                        
(defun my-compile-project (name-or-path) 
  (let ((project-name (project-name name-or-path)))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    (sbt-invoke "*compile*" "play" "compile"))))

(defun my-rebuild-project (name-or-path) 
  (let ((project-name (project-name name-or-path)))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    (sbt-invoke "*compile*" "play" "compile"))))

(defun my-run-project (name-or-path)
  (let ((project-name (project-name name-or-path)))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    (sbt-invoke "*run*" "play" "run"))))

(defun my-test-project (name-or-path)
  (let ((project-name (project-name name-or-path)))
  (when project-name
    (if (buffer-file-name) (save-buffer))
    (sbt-invoke "*run*" "play" "test"))))

