(add-to-list 'load-path (concat emacs-root "/libraries/goodies-34.1"))
(require 'tabbar)
(tabbar-mode 1)
(set-face-attribute 'tabbar-default nil :background "gray90" :height 1.0)

(defun my-bury-buffer ()
  (interactive)
  (unless (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (bury-buffer)))
(defun my-unbury-buffer ()
  (interactive)
  (unless (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (unbury-buffer)))
(global-set-key (kbd "<C-escape>") 'my-bury-buffer)
(global-set-key (kbd "<s-escape>") 'my-unbury-buffer)

(global-set-key (kbd "<C-tab>") (lambda ()
  (interactive)
  (unless (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (tabbar-forward-tab))))
(global-set-key (kbd "<C-S-iso-lefttab>") (lambda ()
  (interactive)
  (unless (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (tabbar-backward-tab))))
(global-set-key (kbd "<C-S-tab>") (lambda ()
  (interactive)
  (unless (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (tabbar-backward-tab))))

(global-set-key (kbd "<C-f4>") (lambda ()
  (interactive)
  (unless (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (let ((buffer (current-buffer)))
      ;; bury works better than simply kill
      ;; since the prior activated previously active buffer
      ;; while the latter sometime does not
      (bury-buffer)
      (kill-buffer buffer)))))
(global-set-key (kbd "<S-f4>") (lambda ()
  (interactive)
  (unless (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (delete-window))))
(global-set-key (kbd "<C-S-f4>") (lambda ()
  (interactive)
  (unless (and (boundp 'ecb-directories-buffer-name) (string= (buffer-name) ecb-directories-buffer-name))
    (let ((current-frame (window-configuration-frame (current-window-configuration))))
    (let ((current-frame-index (position current-frame (frame-list))))
    (let ((current-window (frame-selected-window current-frame)))
    (let ((current-buffer (window-buffer current-window)))
    (let ((other-frame-index (- 1 current-frame-index)))
    (let ((other-frame (if (= (length (frame-list)) 1) nil (nth other-frame-index (frame-list)))))
    (let ((other-window (frame-selected-window other-frame)))
    (let ((other-buffer (window-buffer other-window)))
      (dolist (b (tabbar-buffer-list))
        (if (and (not (eq current-buffer b))
                 (not (eq other-buffer b))
                 (string=
                   (car (funcall tabbar-buffer-groups-function))
                   (car (with-current-buffer b (funcall tabbar-buffer-groups-function)))))
          (kill-buffer b)))
      (dolist (w (window-list current-frame))
        (if (and (not (eq current-window w))
                 (not (eq other-window w)))
          (delete-window w)))
      (when other-frame
        (dolist (w (window-list other-frame))
          (if (and (not (eq current-window w))
                   (not (eq other-window w)))
            (delete-window w)))))))))))))))

(setq *tabbar-ignore-buffers* '("foo" "bar")) ;; set to whatever you'll need in future

(setq tabbar-buffer-list-function (lambda ()
  (remove-if (lambda (buffer)
    (and (not (eq (current-buffer) buffer)) ; Always include the current buffer.
         (loop for name in *tabbar-ignore-buffers* ;remove buffer name in this list.
           thereis (string-equal (buffer-name buffer) name))))
    (buffer-list))))

(setq tabbar-buffer-groups-function (lambda ()
  (list
   (cond
;    ((starts-with (buffer-name) "*scratch*") "Work")
    ((starts-with (buffer-name) "*Completions*") "Work")
    ((starts-with (buffer-name) "*Help*") "Work")
    ((starts-with (buffer-name) "*ielm*") "Work")
    ((starts-with (buffer-name) "*shell*") "Work")
    ((starts-with (buffer-name) "*eshell*") "Work")
    ((starts-with (buffer-name) "*compile") "Work")
    ((starts-with (buffer-name) "*rebuild") "Work")
    ((starts-with (buffer-name) "*test") "Work")
    ((starts-with (buffer-name) "*run") "Work")
    ((starts-with (buffer-name) "*repl") "Work")
    ((starts-with (buffer-name) "*test") "Work")
    ((starts-with (buffer-name) "*commit") "Work")
    ((starts-with (buffer-name) "*logall") "Work")
    ((starts-with (buffer-name) "*logthis") "Work")
    ((starts-with (buffer-name) "*pull") "Work")
    ((starts-with (buffer-name) "*push") "Work")
    ((starts-with (buffer-name) "*Find*") "Work")
    ((starts-with (buffer-name) "*grep*") "Work")
    ((starts-with (buffer-name) "*Backtrace*") "Work")
    ((starts-with (buffer-name) "*ELP Profiling Results*") "Work")
    ((starts-with (buffer-name) "*vc") "Work")
    ((starts-with (buffer-name) "*") "Auxiliary")
    ((starts-with (buffer-name) " *") "Auxiliary")
    (t "Work")
    ))))

;; courtesy of yswzing from http://www.emacswiki.org/emacs-se/TabBarMode
(defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
  (setq ad-return-value
    (if (and (buffer-modified-p (tabbar-tab-value tab))
             (buffer-file-name (tabbar-tab-value tab)))
      (concat "*" ad-return-value)
      ad-return-value)))
(defun ztl-modification-state-change () (tabbar-set-template tabbar-current-tabset nil) (tabbar-display-update))
(defun ztl-on-buffer-modification () (set-buffer-modified-p t) (ztl-modification-state-change))
(add-hook 'after-save-hook 'ztl-modification-state-change)
;;(add-hook 'after-revert-hook 'ztl-modification-state-change)
(add-hook 'first-change-hook 'ztl-on-buffer-modification)
