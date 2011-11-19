;; -*- mode: emacs-lisp  -*-

(add-project "library" "/home/xeno_by/Projects/Kepler/src/library/scala" nil)
(add-project "compiler" "/home/xeno_by/Projects/Kepler/src/compiler/scala" nil)
(add-project "playground-internal" "/home/xeno_by/Projects/Kepler/src/library/scala" nil)
(add-project "playground-external" "/home/xeno_by/Projects/Reflection/src" nil)
(add-project "tests" "/home/xeno_by/Projects/Kepler/src/compiler/test/files" nil)
(add-project "desktop" "/media/XENO/Dropbox/Software/Emacs/desktops/kep" nil)
(add-project ".emacs" "/media/XENO/Dropbox/Software/Emacs" nil)

(setq tool-buffers-autofollow nil)
(setq tool-buffers-display-in-bottom-window t)
(setq tool-buffers-display-in-right-window nil)

(defun my-compile-project (name-or-path)
  (compile-kepler (list "build")))

(defun my-rebuild-project (name-or-path)
  (compile-kepler (list "all.clean" "build")))

(defun my-run-project (name-or-path)
  (compile-kepler (list "build" "pack") (lambda ()
    (insert "\n")
    (compile-reflection (lambda ()
      (insert "\n")
      (run-reflection))))))

(defun my-test-project (name-or-path)
  (compile-kepler (list "build")) (lambda ()
    (insert "\n")
    (test-kepler (list "printf"))))
