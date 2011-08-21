(global-set-key (kbd "<C-f1>") (lambda ()
  (interactive)
  (ielm)))
(global-set-key (kbd "<C-f2>") (lambda ()
  (interactive)
  (switch-to-buffer "*Messages*")))

;; C-h is rebound to replace
(global-set-key (kbd "C-?") 'help-command)
(define-key undo-tree-map (kbd "C-?") 'help-command)
(global-set-key (kbd "C-/") 'describe-function)
(define-key undo-tree-map (kbd "C-/") 'describe-function)
(global-set-key (kbd "s-/") 'describe-key)
(define-key undo-tree-map (kbd "s-/") 'describe-key)

(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)

;; so that it works even if I miss M in "M-:"
(global-set-key (kbd "s-:") 'eval-expression)
(global-set-key (kbd "C-:") 'eval-expression)

(defun my-bookmark-set ()
  (let ((bookmark (if (buffer-file-name)
    (progn
      (let ((bookmark (concat "goto-definition-bookmark." (number-to-string (random)))))
      (bookmark-set bookmark)
      bookmark))
    (progn
      (buffer-name)))))
    bookmark))

(defun my-bookmark-jump (bookmark)
  (if (string-match "^goto-definition-bookmark\\.[[:digit:]]+$" bookmark)
    (bookmark-jump bookmark)
    (let ((buffer (get-buffer bookmark)))
      (when buffer
        (let ((current-frame (window-configuration-frame (current-window-configuration))))
        (let ((current-window (frame-selected-window current-frame)))
          (set-window-buffer current-window buffer)))))))

(global-set-key (kbd "C-.") (lambda () 
  (interactive) 
  (let ((bookmark (my-bookmark-set)))
    (if (not (boundp 'goto-definition-bookmark-stack)) (setq goto-definition-bookmark-stack ()))
    (setq goto-definition-bookmark-stack (cons bookmark goto-definition-bookmark-stack)))
    (setq goto-definition-bookmark-backup nil)
  (find-function (function-called-at-point))))

(global-set-key (kbd "C-,") (lambda ()
  (interactive)
  (when (boundp 'goto-definition-bookmark-stack)
    (let ((bookmark (car goto-definition-bookmark-stack)))
    (let ((backup (my-bookmark-set)))
      (setq goto-definition-bookmark-stack (cdr goto-definition-bookmark-stack))
      (setq goto-definition-bookmark-backup backup)
      (my-bookmark-jump bookmark))))))

(global-set-key (kbd "C-<") (lambda ()
  (interactive)
  (when (boundp 'goto-definition-bookmark-stack)
    (let ((bookmark goto-definition-bookmark-backup))
    (let ((backup (my-bookmark-set)))
      (when bookmark
        (setq goto-definition-bookmark-backup backup)
        (my-bookmark-jump bookmark)))))))

;; set in ~/project/sessions.el
;(add-to-list 'desktop-globals-to-save 'ielm-history)
(defun load-ielm-history ()
  (dolist (b (buffer-list))
    (with-current-buffer b
      (when (eq major-mode 'inferior-emacs-lisp-mode)
        (when (boundp 'ielm-history-size) (setq comint-input-ring-size ielm-history-size))
        (when (boundp 'ielm-history) (setq comint-input-ring ielm-history))))))
(defun save-ielm-history ()
  (dolist (b (buffer-list))
    (with-current-buffer b
      (when (eq major-mode 'inferior-emacs-lisp-mode)
        (setq ielm-history-size comint-input-ring-size)
        (setq ielm-history comint-input-ring)))))

(add-hook 'ielm-mode-hook 'load-ielm-history)
(add-hook 'auto-save-hook 'save-ielm-history)
(add-to-list 'kill-emacs-query-functions (lambda () (save-ielm-history) t))

