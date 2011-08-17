(defvar emacs-root 
  (if (or (eq system-type 'cygwin) (eq system-type 'gnu/linux) (eq system-type 'linux)) (concat "/home/" (getenv "USER") "/.emacs.d")
  (if (eq system-type 'darwin) (concat "/Users/" (getenv "USER") "/.emacs.d") 
  (concat "c:/Users/" (getenv "USER") "/.emacs.d"))))

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

(load-all-files-from-dir (concat emacs-root "/" "editor"))
(load-all-files-from-dir (concat emacs-root "/" "other"))
(load-file (concat emacs-root "/" "solutions" "/" "bootstrapper.el"))

