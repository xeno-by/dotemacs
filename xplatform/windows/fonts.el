(setq my-default-font "-outline-Consolas-normal-r-normal-normal-14-90-96-96-c-*-utf-8")
;;(setq my-default-font "-outline-Consolas-normal-r-normal-normal-36-90-96-96-c-*-utf-8")
(set-frame-font my-default-font)

(add-hook 'after-make-frame-functions (lambda (frame)
  (modify-frame-parameters frame (list (cons 'font my-default-font)))
  (run-hooks 'after-setting-font-hook 'after-setting-font-hooks)))