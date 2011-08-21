(defun chomp (str)
  (let ((s (if (symbolp str) (symbol-name str) str)))
    (if (string-match "[ \t\r\n\v\f]+$" s) (replace-match "" nil t s) s)))

(defun slurp (file)
   (let ((lines ()))
   (when (file-readable-p file)
     (with-temp-buffer
       (insert-file-contents file)
       (goto-char (point-min))
       (while (not (eobp))
         (setq lines (append lines (list (chomp (thing-at-point 'line)))))
         (forward-line))))
   lines))

(defun starts-with (string1 string2)
  (if (or (not (stringp string1)) (not (stringp string2))) nil
    (and (>= (length string1) (length string2))
         (string= (substring string1 0 (length string2)) string2))))

(defun ends-with (string1 string2)
  (if (or (not (stringp string1)) (not (stringp string2))) nil
    (and (>= (length string1) (length string2))
         (string= (substring string1 (- (length string1) (length string2)) (length string2)) string2))))
