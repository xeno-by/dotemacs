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
(global-set-key (kbd "C-c <f1>") 'my-ecb-omni-rename) ;; win + f2
(global-set-key (kbd "C-c <f2>") 'my-ecb-omni-create-directory) ;; win + shift + insert
(global-set-key (kbd "C-c <f3>") 'my-ecb-omni-create-file) ;; win + insert
(global-set-key (kbd "C-c <f4>") 'my-ecb-omni-delete) ;; win + delete
(global-set-key (kbd "C-c <f5>") 'my-unbury-buffer) ;; win + escape
(global-set-key (kbd "C-c <f6>") 'move-buffer-to-other-frame) ;; win + `
(global-set-key (kbd "C-c <f7>") 'eval-expression) ;; win + :
(global-set-key (kbd "C-c <f8>") 'describe-key) ;; win + /
(global-set-key (kbd "C-c <f9>") 'my-ecb-omni-diff) ;; win + =
(global-set-key (kbd "C-c <f10>") 'my-ecb-create-directory) ;; win + +
(global-set-key (kbd "C-c <f11>") 'other-frame) ;; win + tab
(global-set-key (kbd "C-c <f12>") 'my-bury-buffer) ;; ctrl + escape
(global-set-key (kbd "C-c <f13>") 'my-ecb-omni-rename) ;; win + shift + f6
