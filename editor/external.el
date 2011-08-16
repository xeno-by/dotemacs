;(global-auto-revert-mode 1)
(defun ask-user-about-supersession-threat (fn) "blatantly ignore files that changed on disk")
(run-with-timer 0 2 'my-check-external-modifications)
(add-hook 'after-save-hook 'my-check-external-modifications)
(add-hook 'after-revert-hook 'my-check-external-modifications)

(defun my-load-external-modifications ()
  (interactive)
  (if (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (refresh-ecb)
    (if (buffer-modified-p)
      (revert-buffer) ; ask for confirmation
      (revert-buffer t t)) ; don't ask for confirmation - it's unnecessary, since the buffer hasn't been modified
    (my-check-external-modifications))) 
(global-set-key (kbd "<f5>") 'my-load-external-modifications)

(defun my-overwrite-external-modifications ()
  (interactive)
  (clear-visited-file-modtime)
  (set-buffer-modified-p (current-buffer))
  (save-buffer)
  (my-check-external-modifications))

(defun my-check-external-modifications ()
  (unless (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (if (verify-visited-file-modtime (current-buffer))
      (progn
        (global-set-key (kbd "<f5>") 'my-load-external-modifications)
        (global-set-key (kbd "C-s") 'save-buffer)
        (setq header-line-format tabbar-header-line-format))
      (progn
        (global-set-key (kbd "<f5>") 'my-load-external-modifications)
        (global-set-key (kbd "C-s") 'my-overwrite-external-modifications)
        (setq header-line-format (format "%s. Press F5 to load external changes, C-s to overwrite them"
          (propertize "This file has been changed externally" 'face '(:foreground "#f00"))))))))

