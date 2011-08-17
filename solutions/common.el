;; that's how one selects a node in ECB directories tree
;(ecb-set-selected-directory "/home/xeno_by/Projects/Delite/Delite Pages")
;(ecb-set-selected-source "/home/xeno_by/Projects/Delite/Delite Pages/using_blas.html" 1 nil)

;; that's how one finds out what's selected (i.e. highlighted, not the current position of cursor)
;(ecb-path-selected-source)
;ecb-path-selected-directory
;(tree-buffer-find-displayed-node-by-data/name (car (ecb-path-selected-source)))

;; that's how one finds out what's under cursor
;(tree-buffer-get-node-at-point) ; do not evaluate this in ielm verbatimly => it will hang when trying to print the result
;(tree-node->data (tree-buffer-get-node-at-point)) ; returns name of file under cursor

;; that's how one manipulates the cursor
;(progn
;  (ecb-goto-window-directories) ; that's mandatory! ielm current buffer won't work!!
;  (let ((node (tree-buffer-find-displayed-node-by-data/name "/home/xeno_by/Projects/Delite/Delite/scripts/delitecfg")))
;    (let ((line (count-lines 1 (tree-buffer-get-node-name-start-point node))))
;      (tree-buffer-goto-line line)
;      (beginning-of-line)
;      (re-search-forward tree-buffer-incr-searchpattern-indent-prefix nil t))))

(load-file (concat emacs-root "/libraries/cedet-1.0/common/cedet.el"))
(add-to-list 'load-path (concat emacs-root "/libraries/ecb-2.40"))
(require 'ecb)

(setq ecb-tip-of-the-day nil)
(setq ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
(setq ecb-basic-buffer-sync 'always) ;; eats lots of CPU, but provides more pleasant UX
(setq ecb-add-path-for-not-matching-files (quote (nil))) ;; essential for performance
(setq ecb-vc-enable-support nil) ;; having icons is nice, but having them fucked up 80% of the time is not!

(load-file (concat (file-name-directory load-file-name) "/" "layout.el"))
(load-file (concat (file-name-directory load-file-name) "/" "browser.el"))
(load-file (concat (file-name-directory load-file-name) "/" "project.el"))

(setq ecb-auto-activate t)
(ecb-activate)

