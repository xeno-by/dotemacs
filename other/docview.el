(setq doc-view-continuous t)

(defadvice my-after-detected-external-modifications (around disable-modifications-detected-dialog-for-doc-view activate)
  (if (equal major-mode 'doc-view-mode) 
    (revert-buffer t t)
    ad-do-it))

(defadvice revert-buffer (around remember-position-when-reverting-doc-view activate)
  (let ((bookmark (concat "docview-saved-position-before-revert" (number-to-string (random)))))
  (bookmark-set bookmark)
  ad-do-it
  (bookmark-jump bookmark)
  (bookmark-delete bookmark)))

