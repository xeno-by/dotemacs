(setq ecb-windows-width 0.15)
(setq ecb-layout-name "left13") ;only directory treeview
;(setq ecb-layout-name "left14") ;directory treeview and history

(defun my-ecb-auto-redraw-layout ()
  (interactive)
  (run-with-timer 0 0.25 (lambda ()
    (setq my-curr-frame-height (cdr (assoc 'height (frame-parameters))))
    (setq my-curr-frame-width (cdr (assoc 'width (frame-parameters))))
    (if (not (boundp 'my-prev-frame-height)) (setq my-prev-frame-height my-curr-frame-height))
    (if (not (boundp 'my-prev-frame-width)) (setq my-prev-frame-width my-curr-frame-width))

    (when (or (not (eq my-curr-frame-width my-prev-frame-width))
              (not (eq my-curr-frame-height my-prev-frame-height)))
      (ecb-redraw-layout))

    (setq my-prev-frame-height my-curr-frame-height)
    (setq my-prev-frame-width my-curr-frame-width))))
(add-hook 'ecb-activate-hook 'my-ecb-auto-redraw-layout)

;; makes cursor follow currently selected file or directory when switching to *ECB Directories*
(defun my-ecb-goto-window-directories ()
  (interactive)
    (if (eq major-mode 'dired-mode)
      (progn
        (let ((dir dired-directory))
          (ecb-goto-window-directories)
          (let ((short-dir (substring dir 0 (- (length dir) 1))))
          (let ((expanded-dir (expand-file-name short-dir)))
          (let ((node (tree-buffer-find-displayed-node-by-data/name expanded-dir)))
            (when node            
              (ecb-set-selected-directory expanded-dir)
              (let ((line (count-lines 1 (tree-buffer-get-node-name-start-point node))))
                (tree-buffer-goto-line line)
                (beginning-of-line)
                (re-search-forward tree-buffer-incr-searchpattern-indent-prefix nil t))))))))
      (progn
        (ecb-goto-window-directories)
        (let ((node (tree-buffer-find-displayed-node-by-data/name (car (ecb-path-selected-source)))))
          (when node            
            (let ((line (count-lines 1 (tree-buffer-get-node-name-start-point node))))
              (tree-buffer-goto-line line)
              (beginning-of-line)
              (re-search-forward tree-buffer-incr-searchpattern-indent-prefix nil t)))))))
(global-set-key (kbd "<M-f1>") 'my-ecb-goto-window-directories)

(defun my-ecb-goto-window-edit-last ()
  (interactive)
  (ecb-goto-window-edit-last))
(global-set-key (kbd "<M-f2>") 'my-ecb-goto-window-edit-last)

