(setq doc-view-continuous t)

(defadvice my-after-detected-external-modifications (around disable-modifications-detected-dialog-for-doc-view activate)
  (if (equal major-mode 'doc-view-mode) 
    (revert-buffer t t)
    ad-do-it))

;; todo. this does not work. why?!
;;(set (make-local-variable 'my-docview-XXX) YYY)
(if (not (boundp 'my-docview-page)) (setq my-docview-page (make-hash-table)))
(defun my-docview-page () (gethash (buffer-name) my-docview-page))
(defun set-my-docview-page (value) (puthash (buffer-name) value my-docview-page))
(if (not (boundp 'my-docview-hscroll)) (setq my-docview-hscroll (make-hash-table)))
(defun my-docview-hscroll () (gethash (buffer-name) my-docview-hscroll))
(defun set-my-docview-hscroll (value) (puthash (buffer-name) value my-docview-hscroll))
(if (not (boundp 'my-docview-vscroll)) (setq my-docview-vscroll (make-hash-table)))
(defun my-docview-vscroll () (gethash (buffer-name) my-docview-vscroll))
(defun set-my-docview-vscroll (value) (puthash (buffer-name) value my-docview-vscroll))
(if (not (boundp 'my-docview-timer)) (setq my-docview-timer (make-hash-table)))
(defun my-docview-timer () (gethash (buffer-name) my-docview-timer))
(defun set-my-docview-timer (value) (puthash (buffer-name) value my-docview-timer))

;; todo. bookmarks do not preserve scroll positions
;;(defadvice revert-buffer (around remember-position-when-reverting-doc-view activate)
;;  (let ((bookmark (concat "docview-saved-position-before-revert" (number-to-string (random)))))
;;  (bookmark-set bookmark)
;;  ad-do-it
;;  (bookmark-jump bookmark)
;;  (bookmark-delete bookmark)))

(defun before-revert-docview () 
  (set-my-docview-page (image-mode-window-get 'page))
  (set-my-docview-hscroll (image-mode-window-get 'hscroll))
  (set-my-docview-vscroll (image-mode-window-get 'vscroll)))

(defun after-revert-docview () 
  (doc-view-goto-page (my-docview-page))
  (image-set-window-hscroll (my-docview-hscroll))
  (image-set-window-vscroll (my-docview-vscroll)))

(add-hook 'before-revert-hook (lambda ()
  (when (equal major-mode 'doc-view-mode) 
    (before-revert-docview)
    (set-my-docview-timer (run-at-time 0.2 0.5 (lambda () (when (doc-view-already-converted-p)
      (cancel-timer (my-docview-timer))
      (after-revert-docview))))))))
