(defun my-latex-show-preview ()
  (when (not (my-latex-previewing))
    (let ((source-window (cond
      ((left-window) (left-window))
      ((right-window) (active-window))
      (t nil))))
    (let ((source-filename (with-current-buffer (window-buffer source-window) (buffer-file-name))))
    (let ((result-filename (my-latex-result source-filename)))
    (when (and (my-latex-source-p source-filename) result-filename (file-exists-p result-filename))
      (let ((result-window (cond
        ((left-window) (active-window))
        ((right-window) (right-window))
        (t (split-window-horizontally)))))
      (select-window result-window)
      (when (not (equal (buffer-file-name) result-filename))
        (find-file result-filename)
        (run-at-time 0.25 nil (lambda () (image-set-window-hscroll 10)))))))))))

(defun my-latex-result (filename)
  (if filename
    (let ((raw (substring filename 0 (- (length filename) (length (file-name-extension filename))))))
    (let ((pdf (concat raw "pdf")))
    (let ((pdf-modtime (if (file-exists-p pdf) (nth 5 (file-attributes pdf)) nil)))
    (let ((dvi (concat raw "dvi")))
    (let ((dvi-modtime (if (file-exists-p dvi) (nth 5 (file-attributes pdf)) nil)))
    (let ((filename (cond
      ((and pdf-modtime dvi-modtime) pdf) ;; todo. pick the newest file
      ((and pdf-modtime (not dvi-modtime)) pdf)
      ((and (not pdf-modtime) dvi-modtime) dvi)
      (t nil))))

    (when (not filename)
      (let ((master-filename nil))
        (dolist (file (directory-files (file-name-directory raw)))
           (if (or (string-match "HW\\([[:digit:]][[:digit:]]\\).*\\.tex" file)
                   (string-match "Test\\([[:digit:]][[:digit:]]\\).*\\.tex" file))
               (setq master-filename (concat (file-name-directory raw) file))))
        (when (and master-filename (not (string= filename master-filename)))
          (setq filename (my-latex-result master-filename)))))

    filename))))))
   nil))
