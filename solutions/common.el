(setq ecb-tip-of-the-day nil)
(setq ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
(setq ecb-add-path-for-not-matching-files (quote (nil))) ;; essential for performance
(setq ecb-vc-enable-support nil) ;; having icons is nice, but having them fucked up 80% of the time is not!
(setq ecb-auto-update-methods-after-save nil) ;; otherwise ECB throws exceptions after Ctrl+S when the tree widget is hidden

(setq ecb-basic-buffer-sync 'always) ;; 'always eats lots of CPU, but provides more pleasant UX
(setq ecb-analyse-buffer-sync nil)
(setq ecb-eshell-buffer-sync nil)
(setq ecb-speedbar-buffer-sync nil)
(setq ecb-symboldef-buffer-sync nil))
