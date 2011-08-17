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

