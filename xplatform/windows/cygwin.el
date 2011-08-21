(if (or (not (stringp (getenv "CYGROOT"))) (string= "" (getenv "CYGROOT"))) (error "environment variable CYGROOT not set"))
(if (or (not (stringp (getenv "CYGHOME"))) (string= "" (getenv "CYGHOME"))) (error "environment variable CYGHOME not set"))

(add-to-list 'load-path (concat emacs-root "/libraries/cygwin-mount-1.4.8"))
(require 'cygwin-mount)
(setq cygwin-mount-cygwin-bin-directory (concat (getenv "CYGROOT") "/" "bin"))
(cygwin-mount-activate)
