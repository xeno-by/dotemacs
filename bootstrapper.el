;; todo. implement include and exclude
(defun load-all-files-from-dir (dir &optional include exclude) 
  (dolist (f (directory-files dir))
    (when (and 
      (file-directory-p (concat dir "/" f))
      (not (string= "." f))
      (not (string= ".." f)))
    (load-all-files-from-dir (concat dir "/" f)))
    (when (and 
      (not (file-directory-p (concat dir "/" f)))
      (not (string= "bootstrapper.el" f))
      (string= ".el" (substring f (- (length f) 3))))
    (load-file (concat dir "/" f)))))

;; http://stackoverflow.com/questions/1817257/how-to-determine-operating-system-in-elisp
(setq windows nil mac nil linux nil)
(cond ((eq system-type 'windows-nt) (setq windows t)) ((eq system-type 'darwin) (setq mac t)) (t (setq linux t)))

(cond (windows (load-file (concat (file-name-directory load-file-name) "/" "xplatform" "/" "windows" "/" "bootstrapper.el")))
(mac (load-file (concat (file-name-directory load-file-name) "/" "xplatform" "/" "mac" "/" "bootstrapper.el")))
(linux (load-file (concat (file-name-directory load-file-name) "/" "xplatform" "/" "linux" "/" "bootstrapper.el")))
(t (error "unsupported operating system")))

(load-all-files-from-dir (concat emacs-root "/" "utils")) ;; this is okay for performance, nothing top-level here
(load-all-files-from-dir (concat emacs-root "/" "editor")) ;; this is okay for performance, i only had to disable linum-mode
(load-all-files-from-dir (concat emacs-root "/" "other")) ;; scala-mode lags, but only once per buffer. i believe, this has to do with syntax coloring
(load-file (concat emacs-root "/" "solutions" "/" "bootstrapper.el"))

