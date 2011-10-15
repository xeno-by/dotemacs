(require 'desktop)

(desktop-save-mode 1)
(setq history-length 10000)

(setq desktop-path (list desktop-root))
(setq desktop-base-file-name "desktop")
(setq desktop-base-lock-name "desktop.lock")

(add-to-list 'desktop-globals-to-save 'file-name-history)
(add-to-list 'desktop-globals-to-save 'ielm-history-size)
(add-to-list 'desktop-globals-to-save 'ielm-history)
(add-to-list 'desktop-globals-to-save 'goto-definition-bookmark-stack)
(add-to-list 'desktop-globals-to-save 'goto-definition-bookmark-backup)
(add-to-list 'desktop-globals-to-save 'my-solution-grep-prev-string)
(add-to-list 'desktop-globals-to-save 'my-solution-grep-prev-flavor)
(add-to-list 'desktop-globals-to-save 'my-solution-grep-prev-filter)
(add-to-list 'desktop-globals-to-save 'my-sbt-run-prev-main-class)

;; unused at the moment. possibly, will be helpful in the future
;(setq desktop-buffers-not-to-save (concat 
;  "\\("
;  "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
;  "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
;  "\\)$"))
;(add-to-list 'desktop-modes-not-to-save 'dired-mode)
;(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)
;(add-to-list 'desktop-modes-not-to-save 'ecb-minor-mode)

;; autosave for desktop
(defun my-desktop-save ()
  (interactive)
  ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
  (if (eq (desktop-owner) (emacs-pid))
      (desktop-save desktop-dirname)))
(add-hook 'auto-save-hook 'my-desktop-save)
(add-to-list 'kill-emacs-query-functions (lambda () (my-desktop-save) t))

