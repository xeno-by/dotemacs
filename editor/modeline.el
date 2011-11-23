(setq default-mode-line-format (quote(
  "-"
  mode-line-mule-info
  mode-line-modified
  (:eval (propertize (concat " "
    (if (buffer-file-name)
      (if (fboundp 'solution-abbrev-string)
        (solution-abbrev-string (file-truename (buffer-file-name)))
        (buffer-file-name))
      (buffer-name))
  " ") 'face 'bold))
  (line-number-mode "-- (%l, %c)")
  " -- "
  mode-line-modes
  (which-func-mode ("" which-func-format "--" 0 2))
  (global-mode-string ("" global-mode-string "--" 0 2))
  "-%-"
)))
