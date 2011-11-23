(require 'cl)

;;(setq stack-trace-on-error t)
(setq debug-on-error t)

(load-file (concat (file-name-directory load-file-name) "/" "bootstrapper.el"))
