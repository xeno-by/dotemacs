(cua-mode t)

(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

(setq x-select-enable-primary nil)  ; stops killing/yanking interacting with primary X11 selection
(setq x-select-enable-clipboard t)  ; makes killing/yanking interact with clipboard X11 selection
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value) ;; to make yanking use the clipboard too

(setq mouse-drag-copy-region nil)  ;; stops selection with a mouse being immediately injected to the kill ring
(global-set-key (kbd "<mouse-2>") 'mouse-set-mark)
;; copy-pasted from mouse-set-mark and adjusted a bit
(global-set-key (kbd "<S-down-mouse-1>") (lambda (click) 
  (interactive "e")
  (mouse-minibuffer-check click)
  (select-window (posn-window (event-start click)))
	(push-mark nil t t)
	(mouse-set-point click)
	(or transient-mark-mode (sit-for 1))))

(global-set-key (kbd "C-S-c") 'cua-copy-region)
(global-set-key (kbd "C-S-v") 'cua-paste)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
