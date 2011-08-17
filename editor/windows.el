;(windmove-default-keybindings)
(windmove-default-keybindings 'meta)

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

