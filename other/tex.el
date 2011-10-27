(global-set-key (kbd "<f11>") (lambda () (interactive) (my-latex-toggle-preview)))

(defun my-latex-source-p (filename)
  (if filename (or
    (equal (file-name-extension filename) "tex"))
    nil))

(defun my-latex-source (filename)
  (if filename
    (let ((raw (substring filename 0 (- (length filename) (length (file-name-extension filename))))))
    (let ((tex (concat raw "tex")))
    (let ((filename (if (file-exists-p tex) tex nil)))
    filename)))
   nil))

(defun my-latex-result-p (filename)
  (if filename (or 
    (equal (file-name-extension filename) "pdf")
    (equal (file-name-extension filename) "dvi"))
    nil))

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
    filename))))))
   nil))

(defun my-latex-previewing ()
  (cond
   ((left-window)
    (let ((wannabe-result (buffer-file-name)))
    (let ((wannabe-source (with-current-buffer (window-buffer (left-window)) (buffer-file-name))))
    (and wannabe-source wannabe-result (equal wannabe-source (my-latex-source wannabe-result))))))
   ((right-window)
    (let ((wannabe-source (buffer-file-name)))
    (let ((wannabe-result (with-current-buffer (window-buffer (right-window)) (buffer-file-name))))
    (and wannabe-source wannabe-result (equal wannabe-result (my-latex-result wannabe-source))))))
   (t nil)))
  
(defun my-latex-toggle-preview ()
  (if (my-latex-previewing) (my-latex-hide-preview) (my-latex-show-preview)))

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

(defun my-latex-hide-preview ()
  (when (my-latex-previewing)
    (let ((source-window (cond
      ((left-window) (left-window))
      ((right-window) (active-window))
      (t nil))))
    (let ((source-filename (with-current-buffer (window-buffer source-window) (buffer-file-name))))
    (when (my-latex-source-p source-filename)
      (let ((result-window (cond 
        ((left-window) (active-window))
        ((right-window) (right-window))
        (t nil))))
      (let ((result-filename (with-current-buffer (window-buffer result-window) (buffer-file-name))))
      (when (or (equal result-filename (my-latex-result source-filename)) (equal source-filename (my-latex-source result-filename)))
        (delete-window result-window)))))))))
