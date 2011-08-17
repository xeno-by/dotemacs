(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-create-new-buffer 'always)
(ido-mode 1)

(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

;; http://stackoverflow.com/questions/900372/in-emacs-how-do-i-change-the-minibuffer-completion-list-window
(add-to-list 'special-display-buffer-names '("*Completions*" my-display-completions))
(defun my-display-completions (buffer)
  (when (sole-window)
    (select-window (sole-window))
    (split-window-horizontally))
  (let ((target-window (window-at (- (frame-width) 2) 0))
        (pop-up-windows t))
    (set-window-buffer target-window buffer)
    target-window))

;; no need to advice kill-buffer since it calls bury-buffer internally
(defadvice bury-buffer (around auto-kill-completions-window-on-bury activate)
  (let ((buffer-being-buried (buffer-name)))
  (let ((sole-window (sole-window)))
    (when (string= buffer-being-buried "*Completions*")
      (when (not sole-window) 
        (kill-buffer-and-window))
      (when sole-window
        ad-do-it))
    (when (not (string= buffer-being-buried "*Completions*"))
      ad-do-it))))
