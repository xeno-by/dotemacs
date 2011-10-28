(defun after-revert-docview () 
  (doc-view-goto-page (my-docview-page))
  (image-set-window-hscroll 10)
  (image-set-window-vscroll (my-docview-vscroll)))
