(defun my-search-string-in-solution (string) (my-search-string-in-solution-internal string nil))

(defun my-search-regexp-in-solution (string) (my-search-string-in-solution-internal string t))

(defun my-search-string-in-solution-internal (string &optional regexp-p)
  (let ((find-command (find-files-in-solution-command)))
  (let ((grep-command (if regexp-p "egrep --color=always" "fgrep --color=always")))
  (let ((abbrev-command (solution-abbrev-string-command)))
  (let ((command (concat find-command " | xargs -0 -e " grep-command " -nH '" string "' | " abbrev-command)))
  ;; this overcomes the "xargs exited abnormally with exit code 123" error
  ;; more details here: http://superuser.com/questions/197031/grep-exits-abnormally-with-code-123-when-running-rgrep-on-emacs
  (let ((workaround (concat 
    "mkfifo /tmp/my_emacs_grep_pipe 2>/dev/null || true; " 
    command " | tee /tmp/my_emacs_grep_pipe & result=$(cat < /tmp/my_emacs_grep_pipe); "
    "if [ $(echo -n $result | grep -c '') = 0 ]; then exit 1; else exit 0; fi")))
    (compilation-start workaround 'grep-mode)))))))

(add-to-list 'special-display-buffer-names '("*grep*" my-display-grep))
(defun my-display-grep (target-buffer)
  (let ((target-window 
    (cond 
      ((and (boundp 'display-tool-buffers-in-bottom-window) display-tool-buffers-in-bottom-window)
       (if (bottom-window) (bottom-window) (split-window-vertically)))
      ((and (boundp 'display-tool-buffers-in-right-window) display-tool-buffers-in-right-window)
       (if (right-window) (right-window) (split-window-horizontally)))
      (t
       (active-window)))))
  (let ((pop-up-windows t)) (set-window-buffer target-window target-buffer))
  (select-window target-window)
  target-window))

;; no need to advice kill-buffer since it calls bury-buffer internally
(defadvice bury-buffer (around auto-kill-dedicated-grep-window-on-bury activate)
  (let ((buffer-being-buried (buffer-name)))
  (let ((sole-window (sole-window)))
    (when (string= buffer-being-buried "*grep*")
      (when (not sole-window) 
        (delete-window))
      (when sole-window
        ad-do-it))
    (when (not (string= buffer-being-buried "*grep*"))
      ad-do-it))))

;; this is an extra case, since "q" is bound directly to kill-window
;; and that cannot be handled by advicing bury-buffer
(defadvice quit-window (around auto-kill-dedicated-grep-window-on-quit activate)
  (let ((buffer-being-buried (buffer-name)))
    (when (string= buffer-being-buried "*grep*")
      (when (not (sole-window)) 
        (delete-window)))
      (when (not (string= buffer-being-buried "*grep*"))
        ad-do-it)))
