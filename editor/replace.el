; copy/pasted from "defun replace-string" in replace.el
(global-set-key (kbd "C-h") (lambda (from-string to-string &optional delimited start end)
 (interactive
   (let ((common
	  (query-replace-read-args
	   (concat "Replace"
		   (if current-prefix-arg " word" "")
		   " string"
		   (if (and transient-mark-mode mark-active) " in region" ""))
	   nil)))
     (list (nth 0 common) (nth 1 common) (nth 2 common)
	   (if (and transient-mark-mode mark-active)
	       (region-beginning))
	   (if (and transient-mark-mode mark-active)
	       (region-end)))))
 (save-excursion
   ;; xeno.by: this is the customization I've made to default replace-string
   (goto-char (point-min))
   (replace-string from-string to-string delimited start end))))

; copy/pasted from "defun replace-regexp" in replace.el
(global-set-key (kbd "C-M-h") (lambda (from-string to-string &optional delimited start end)
  (interactive
   (let ((common
	  (query-replace-read-args
	   (concat "Replace"
		   (if current-prefix-arg " word" "")
		   " regexp"
		   (if (and transient-mark-mode mark-active) " in region" ""))
	   t)))
     (list (nth 0 common) (nth 1 common) (nth 2 common)
	   (if (and transient-mark-mode mark-active)
	       (region-beginning))
	   (if (and transient-mark-mode mark-active)
	       (region-end)))))
 (save-excursion
   ;; xeno.by: this is the customization I've made to default replace-regexp
   (goto-char (point-min))
   (replace-regexp from-string to-string delimited start end))))

; copy/pasted from "defun query-replace" in replace.el
(global-set-key (kbd "s-h") (lambda (from-string to-string &optional delimited start end)
  (interactive
   (let ((common
    (query-replace-read-args
     (concat "Query replace"
	     (if current-prefix-arg " word" "")
	     (if (and transient-mark-mode mark-active) " in region" ""))
     nil)))
     (list (nth 0 common) (nth 1 common) (nth 2 common)
     ;; These are done separately here
     ;; so that command-history will record these expressions
     ;; rather than the values they had this time.
     (if (and transient-mark-mode mark-active)
         (region-beginning))
     (if (and transient-mark-mode mark-active)
         (region-end)))))
 (save-excursion
   ;; xeno.by: this is the customization I've made to default query-replace
   (goto-char (point-min))
   (query-replace from-string to-string delimited start end))))

; copy/pasted from "defun query-replace-regexp" in replace.el
(global-set-key (kbd "s-M-h") (lambda (from-string to-string &optional delimited start end)
  (interactive
   (let ((common
	  (query-replace-read-args
	   (concat "Query replace"
		   (if current-prefix-arg " word" "")
		   " regexp"
		   (if (and transient-mark-mode mark-active) " in region" ""))
	   t)))
     (list (nth 0 common) (nth 1 common) (nth 2 common)
	   (if (and transient-mark-mode mark-active)
	       (region-beginning))
	   (if (and transient-mark-mode mark-active)
	       (region-end)))))
 (save-excursion
   ;; xeno.by: this is the customization I've made to default query-replace-regexp
   (goto-char (point-min))
   (query-replace-regexp from-string to-string delimited start end))))

