(defvar emacs-root 
  (if (or (eq system-type 'cygwin) (eq system-type 'gnu/linux) (eq system-type 'linux)) (concat "/home/" (getenv "USER") "/.emacs.d")
  (if (eq system-type 'darwin) (concat "/Users/" (getenv "USER") "/.emacs.d") 
  (concat "c:/Users/" (getenv "USER") "/.emacs.d"))))

(defun load-all-files-from-dir (dir) 
  (dolist (f (directory-files dir))
    (when (and 
      (file-directory-p (concat dir "/" f))
      (not (string= "." f))
      (not (string= ".." f)))
    (load-all-files-from-dir (concat dir "/" f)))
    (when (and 
      (not (file-directory-p (concat dir "/" f)))
      (string= ".el" (substring f (- (length f) 3))))
    (load-file (concat dir "/" f)))))

(defun load-all-files-from-emacs-root ()
  (dolist (f (directory-files emacs-root))
    (when (and 
           (file-directory-p (concat emacs-root "/" f))
           (not (string= "libraries" f))
           (not (string= "." f))
           (not (string= ".." f)))
      (load-all-files-from-dir (concat emacs-root "/" f)))
    (when (and 
           (not (file-directory-p (concat emacs-root "/" f)))
           (string= ".el" (substring f (- (length f) 3)))
           (not (string= "init.el" f))
           (not (string= "bootstrapper.el" f)))
      (load-file (concat emacs-root "/" f)))))
