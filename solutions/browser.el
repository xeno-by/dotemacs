(defun my-omni-diff ()
  (interactive)
  (cond
   ((eq major-mode 'dired-mode) (my-diff dired-directory))
   ((buffer-file-name) (my-diff (buffer-file-name)))))
(defun my-diff (file)
  (cond
   ((and file (file-directory-p file)) (vc-dir file))
   ((and file (not (file-directory-p file))) (with-temp-buffer
     (find-file file)
     (call-interactively 'vc-diff)))))
(global-set-key (kbd "s-=") 'my-omni-diff)
(global-set-key (kbd "C-=") 'my-omni-diff)

(defun my-omni-delete ()
  (interactive)
  (cond
   ((eq major-mode 'dired-mode) (my-delete dired-directory))
   ((buffer-file-name) (my-delete (buffer-file-name)))))
(defun my-delete (file)
  (cond
   ((and file (file-directory-p file)) 
    (when (yes-or-no-p (concat "Really delete directory" dir "? "))
      (let ((prefix (if (string= "/" (substring dir (- (length dir) 1) (length dir))) dir (concat dir "/"))))
        (dolist (b (buffer-list))
          (with-current-buffer b
            (let ((file (buffer-file-name)))
              (if (and (stringp file)
                       (> (length file) (length prefix))
                       (string= (substring file 0 (length prefix)) prefix))
                (kill-buffer))))))
      (delete-directory file t)))
   ((and file (not (file-directory-p file)))
    (when (yes-or-no-p (concat "Really delete " (file-name-nondirectory file) "? "))
      (when (get-file-buffer file)
        ;; if there is an open buffer for this source then we kill them - this
        ;; ensures also that if there are indirect-buffers to this base-buffer
        ;; these buffers will be killed too by Emacs and the called
        ;; kill-buffer-hook is called for each indirect-buffer - so all
        ;; history-nodes for these are removed.
        (kill-buffer (get-file-buffer file)))
      (delete-file file)))))
(global-set-key (kbd "<s-delete>") 'my-omni-delete)

(defun my-omni-create-directory ()
  (interactive)
  (my-create-directory (read-from-minibuffer "Directory name: ")))
(defun my-create-directory (file)
  (make-directory file))
(global-set-key (kbd "s-+") 'my-omni-create-directory)
(global-set-key (kbd "<s-S-insert>") 'my-omni-create-directory)

(defun my-omni-create-file ()
  (interactive)
  (my-create-file (read-from-minibuffer "File name: ")))
(defun my-create-file (file)
  (find-file file)
  (when (= (point-min) (point-max))
    (set-buffer-modified-p t)
    (save-buffer)))
(global-set-key (kbd "<s-insert>") 'my-create-file)

(defun my-rename-file-on-disk (old-name new-name)
  (let ((first-existing-parent (file-name-directory (directory-file-name new-name))))
    (loop while (not (file-exists-p first-existing-parent)) do
      (setq first-existing-parent (file-name-directory (directory-file-name first-existing-parent))))
    (when (not (string= first-existing-parent (file-name-directory (directory-file-name new-name))))
      (let ((fragments (split-string (substring (directory-file-name (file-name-directory (directory-file-name new-name))) (length (file-name-as-directory first-existing-parent))) "/")))
        (dolist (fragment fragments)
          (setq first-existing-parent (concat first-existing-parent "/" fragment))
          (make-directory first-existing-parent)))))

  (if (vc-state old-name)
    (progn
      ;; xeno.by: copy/pasted vc-rename-file and made some corrections
      (let ((old-base (file-name-nondirectory old-name)))
        (when (and (not (string= "" old-base))
                   (string= "" (file-name-nondirectory new-name)))
          (setq new (concat new-name old-base))))
      (let ((oldbuf (get-file-buffer old-name)))
        (when (and oldbuf (buffer-modified-p oldbuf))
          (error "Please save files before moving them"))
        (when (get-file-buffer new-name)
          (error "Already editing new file name"))
        (when (file-exists-p new-name)
          (error "New file already exists"))
        (let ((state (vc-state old-name)))
          ;; xeno.by: added the "added" state here => it should work for Git
          ;; if I witness any problems with this later, I'll address that
          ;;(unless (memq state '(up-to-date edited))
          (unless (memq state '(up-to-date added edited))
            (error "Please %s files before moving them" (if (stringp state) "check in" "update"))))
        ;; xeno.by: wrapped in temporary default-directory change
        ;; otherwise, git does not work with arguments provided by vc-do-command
        (let ((current-directory (getenv "PWD")))
          (let ((repository-directory (file-name-directory old-name)))
            (let ((default-directory repository-directory))
              ;; xeno.by: wrapped in temporary pwd change
              ;; otherwise, git does not work
              (setenv "PWD" repository-directory)
              (vc-call rename-file old-name new-name)
              (setenv current-directory))))
        (vc-file-clearprops old-name)
        ;; Move the actual file (unless the backend did it already)
        (when (file-exists-p old-name) (rename-file old-name new-name))
        ;; ?? Renaming a file might change its contents due to keyword expansion.
        ;; We should really check out a new copy if the old copy was precisely equal
        ;; to some checked-in revision.  However, testing for this is tricky....
        (when oldbuf
          (with-current-buffer oldbuf
            (let ((buffer-read-only buffer-read-only))
              (set-visited-file-name new-name))
            (vc-mode-line new-name (vc-backend new-name))
            (set-buffer-modified-p nil)))))
    (rename-file old-name new-name)))

(defun my-rename-file (file)
  (let ((old-name (if (string= "/" (substring file (- (length file) 1) (length file))) (substring file 0 (- (length file) 1)) file)))
  (let ((old-name-dir (file-name-directory old-name)))
  (let ((old-name-name (file-name-nondirectory old-name)))
  (let ((new-name-name (read-from-minibuffer "New name: " old-name-name)))
  (let ((new-name (concat old-name-dir new-name-name)))
  ;; xeno.by: automatic replace after rename is hard, since we must handle lots of cases and might still fail
  ;; that's why I just crash and let the user handle the conflict by him/herself
  ;; (let ((ok (or (not (file-exists-p new-name))
  ;;               (yes-or-no-p (concat "File " new-name-name " exists. Really rename? ")))))
  (let ((ok (progn (if (file-exists-p new-name) (message (concat "File " new-name-name " already exists."))) (not (file-exists-p new-name)))))
  (when ok
    ;; xeno.by: added integration with VC framework
    ;;(rename-file old-name new-name))
    (my-rename-file-on-disk old-name new-name)

    (let ((buffer (get-file-buffer file)))
    (when buffer
      (with-current-buffer buffer
        (let ((was-modified (buffer-modified-p)))
          (rename-buffer new-name-name)
          (set-visited-file-name new-name)
          (if (not was-modified) (set-buffer-modified-p nil))))))))))))))

(defun my-rename-directory-on-disk (old-name new-name)
  (let ((first-existing-parent (file-name-directory (directory-file-name new-name))))
    (loop while (not (file-exists-p first-existing-parent)) do
      (setq first-existing-parent (file-name-directory (directory-file-name first-existing-parent))))
    (when (not (string= first-existing-parent (file-name-directory (directory-file-name new-name))))
      (let ((fragments (split-string (substring (directory-file-name (file-name-directory (directory-file-name new-name))) (length (file-name-as-directory first-existing-parent))) "/")))
        (dolist (fragment fragments)
          (setq first-existing-parent (concat first-existing-parent "/" fragment))
          (make-directory first-existing-parent)))))

  ;; xeno.by: renaming directories does not work for git
  ;; that's why I implemented manual rename of all descendant files
  ;; if this messes things up for other VCS, I'm sorry for that
  (when (file-directory-p old-name)
    (dolist (child-file (directory-files old-name))
      (when (and
             (not (string= "." child-file))
             (not (string= ".." child-file)))
        (let ((old-name (concat old-name "/" child-file)))
        (let ((new-name (concat new-name "/" child-file)))
          (if (not (file-directory-p old-name))
            (ecb-rename-source-on-disk old-name new-name)
            (ecb-rename-directory-on-disk old-name new-name))))))

    (if (not (file-exists-p new-name)) (make-directory new-name))
    (delete-directory old-name)))

(defun my-rename-directory (file)
  (let ((old-name (if (string= "/" (substring file (- (length file) 1) (length file))) (substring file 0 (- (length file) 1)) file)))
  (let ((old-name-dir (file-name-directory old-name)))
  (let ((old-name-name (file-name-nondirectory old-name)))
  (let ((new-name-name (read-from-minibuffer "New name: " old-name-name)))
  (let ((new-name (concat old-name-dir new-name-name)))
  ;; xeno.by: automatic replace after rename is hard, since we must handle lots of cases and might still fail
  ;; that's why I just crash and let the user handle the conflict by him/herself
  ;; (let ((ok (or (not (file-exists-p new-name))
  ;;               (yes-or-no-p (concat "Directory " new-name-name " exists. Really rename? ")))))
  (let ((ok (progn (if (file-exists-p new-name) (message (concat "Directory " new-name-name " already exists."))) (not (file-exists-p new-name)))))
  (when ok
    ;; xeno.by: added integration with VC framework
    ;; (rename-file old-name new-name)
    (my-rename-directory-on-disk old-name new-name)

    (let ((prefix (if (string= "/" (substring old-name (- (length old-name) 1) (length old-name))) old-name (concat old-name "/"))))
      (dolist (buffer (buffer-list))
        (with-current-buffer buffer
          (let ((file-name (buffer-file-name)))
            (if (and (stringp file-name)
                     (> (length file-name) (length prefix))
                     (string= (substring file-name 0 (length prefix)) prefix))
              (let ((postfix (substring file-name (length prefix))))
              (let ((new-file-name (concat new-name "/" postfix)))
                (let ((was-modified (buffer-modified-p)))
                (set-visited-file-name new-file-name)
                (if (not was-modified) (set-buffer-modified-p nil))))))))))))))))))

(defun my-omni-rename ()
  (interactive)
  (cond
   ((eq major-mode 'dired-mode) (my-rename dired-directory))
   (t (my-rename (buffer-file-name)))))
(defun my-rename (file)
  (cond
   ((and file (file-directory-p file)) (my-rename-directory file))
   ((and file (not (file-directory-p file))) (my-rename-file file))))
(global-set-key (kbd "<s-S-f6>") 'my-omni-rename)
(global-set-key (kbd "<s-f2>") 'my-omni-rename)
