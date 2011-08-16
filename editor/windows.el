(setq pop-up-windows nil) ;; made my day

(defun active-windows ()
  (let ((ecb-window (if (boundp 'ecb-directories-buffer-name) (get-buffer-window (get-buffer ecb-directories-buffer-name)) nil)))
  (let ((minibuffer-window (minibuffer-window)))
    (delete minibuffer-window (delete ecb-window (window-list))))))

(defun active-window ()
  (let ((current-frame (window-configuration-frame (current-window-configuration))))
  (frame-selected-window current-frame)))

(defun sole-window ()
  (if (equal (length (active-windows)) 1) (car (active-windows)) nil))

(defun top-window (&optional window) 
  (let ((ecb-window (if (boundp 'ecb-directories-buffer-name) (get-buffer-window (get-buffer ecb-directories-buffer-name)) nil)))
  (let ((result (windmove-find-other-window 'up nil window)))
    (if (memq result (active-windows)) result nil))))

(defun bottom-window (&optional window) 
  (let ((ecb-window (if (boundp 'ecb-directories-buffer-name) (get-buffer-window (get-buffer ecb-directories-buffer-name)) nil)))
  (let ((result (windmove-find-other-window 'down nil window)))
    (if (memq result (active-windows)) result nil))))

(defun right-window (&optional window) 
  (let ((ecb-window (if (boundp 'ecb-directories-buffer-name) (get-buffer-window (get-buffer ecb-directories-buffer-name)) nil)))
  (let ((result (windmove-find-other-window 'right nil window)))
    (if (memq result (active-windows)) result nil))))

(defun left-window (&optional window) 
  (let ((ecb-window (if (boundp 'ecb-directories-buffer-name) (get-buffer-window (get-buffer ecb-directories-buffer-name)) nil)))
  (let ((result (windmove-find-other-window 'left nil window)))
    (if (memq result (active-windows)) result nil))))

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
