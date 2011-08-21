(if (or (not (stringp (getenv "APPDATA"))) (string= "" (getenv "APPDATA"))) (error "environment variable APPDATA not set"))
(if (or (not (stringp (getenv "CYGROOT"))) (string= "" (getenv "CYGROOT"))) (error "environment variable CYGROOT not set"))
(if (or (not (stringp (getenv "CYGHOME"))) (string= "" (getenv "CYGHOME"))) (error "environment variable CYGHOME not set"))

(setq emacs-root (concat (getenv "APPDATA") "\\.emacs.d"))
(setq xplatform-root (file-name-directory load-file-name))

(defun maximize-frame ()
  (w32-send-sys-command 61488)
  (sit-for 0))

(defun swap-monitor ()
  (let ((script (concat xplatform-root "/" "swapmonitor.vbs")))
  (call-process "Wscript.exe" nil t nil script "%L")))
  
(setq my-default-font "-outline-Consolas-normal-r-normal-normal-14-90-96-96-c-*-utf-8")
(set-default-font my-default-font)

(add-to-list 'load-path (concat emacs-root "/libraries/cygwin-mount-1.4.8"))
(require 'cygwin-mount)
(setq cygwin-mount-cygwin-bin-directory (concat (getenv "CYGROOT") "/" "bin"))
(cygwin-mount-activate)

(defun desktop-save-postprocess-paths ()
  (let ((cygroot (replace-regexp-in-string (regexp-quote "\\") (regexp-quote "/") (getenv "CYGROOT"))))
  (replace-string cygroot ""))

  (let ((emacs-home (replace-regexp-in-string (regexp-quote "\\") (regexp-quote "/") (getenv "EMACS_HOME"))))
  (replace-string emacs-home "/usr/share/emacs")))

(defadvice desktop-save (around strip-off-cygwin-prefix-when-saving-history activate)
  ad-do-it
  
  (let ((file (concat (car desktop-path) "/" desktop-base-file-name)))
    (with-temp-buffer
     (insert-file-contents file)
     (goto-char (point-min))
     (desktop-save-postprocess-paths)
     (set-visited-file-name file)
     (save-buffer)
     (setq desktop-file-modtime (nth 5 (file-attributes file))))))

(setq w32-pass-lwindow-to-system nil)
(setq w32-lwindow-modifier 'super)
(setq w32-pass-rwindow-to-system nil)
(setq w32-rwindow-modifier 'super)
(setq w32-pass-apps-to-system t)
(global-set-key (kbd "<apps>") 'execute-extended-command)
(global-set-key (kbd "<M-f4>") 'save-buffers-kill-emacs)

;; define substitutions for hotkeys that are/might be overriden by standard windows hotkeys
;; later, you can call this substitutions by a tool like Autohotkey
(global-set-key (kbd "C-c 1") 'my-goto-favorite-1) ;; win + 1
(global-set-key (kbd "C-c 2") 'my-goto-favorite-2) ;; win + 2
(global-set-key (kbd "C-c 3") 'my-goto-favorite-3) ;; win + 3
(global-set-key (kbd "C-c 4") 'my-goto-favorite-4) ;; win + 4
(global-set-key (kbd "C-c 5") 'my-goto-favorite-5) ;; win + 5
(global-set-key (kbd "C-c 6") 'my-goto-favorite-6) ;; win + 6
(global-set-key (kbd "C-c 7") 'my-goto-favorite-7) ;; win + 7
(global-set-key (kbd "C-c 8") 'my-goto-favorite-8) ;; win + 8
(global-set-key (kbd "C-c 9") 'my-goto-favorite-9) ;; win + 9
(global-set-key (kbd "C-c 0") 'my-goto-favorite-10) ;; win + 10
(global-set-key (kbd "C-c <f1>") 'my-omni-rename) ;; win + f2
(global-set-key (kbd "C-c <f2>") 'my-omni-create-directory) ;; win + shift + insert
(global-set-key (kbd "C-c <f3>") 'my-omni-create-file) ;; win + insert
(global-set-key (kbd "C-c <f4>") 'my-omni-delete) ;; win + delete
(global-set-key (kbd "C-c <f5>") 'my-unbury-buffer) ;; win + escape
(global-set-key (kbd "C-c <f6>") 'move-buffer-to-other-frame) ;; win + `
(global-set-key (kbd "C-c <f7>") 'eval-expression) ;; win + :
(global-set-key (kbd "C-c <f8>") 'describe-key) ;; win + /
(global-set-key (kbd "C-c <f9>") 'my-ecb-omni-diff) ;; win + =
(global-set-key (kbd "C-c <f10>") 'my-ecb-create-directory) ;; win + +
(global-set-key (kbd "C-c <f11>") 'other-frame) ;; win + tab
(global-set-key (kbd "C-c <f12>") 'my-bury-buffer) ;; ctrl + escape
(global-set-key (kbd "C-c <f13>") 'my-omni-rename) ;; win + shift + f6
