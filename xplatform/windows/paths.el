(defun desktop-save-postprocess-paths ()
  (let ((cygroot (replace-regexp-in-string (regexp-quote "\\") (regexp-quote "/") (getenv "CYGROOT"))))
  (replace-string cygroot ""))

  (let ((emacs-home (replace-regexp-in-string (regexp-quote "\\") (regexp-quote "/") (getenv "EMACS_HOME"))))
  (replace-string emacs-home "/usr/share/emacs")))

(defadvice desktop-save (around strip-off-cygwin-prefix-when-saving-history activate)
  ad-do-it
  
  (let ((file (concat (car desktop-path) "/" desktop-base-file-name)))
    (with-temp-buffer
     (insert-file-contents file)
     (goto-char (point-min))
     (desktop-save-postprocess-paths)
     (set-visited-file-name file)
     (save-buffer)
     (setq desktop-file-modtime (nth 5 (file-attributes file))))))
