(add-hook 'ecb-directories-buffer-after-create-hook (lambda () (local-set-key (kbd "<f3>") 'isearch-repeat-forward)))
(add-hook 'ecb-directories-buffer-after-create-hook (lambda () (local-set-key (kbd "<C-f3>") 'isearch-repeat-backward)))
(add-hook 'ecb-directories-buffer-after-create-hook (lambda () (local-set-key (kbd "<S-f3>") 'isearch-repeat-backward)))

(global-set-key (kbd "<f9>") 'ecb-toggle-ecb-windows)

(defun my-ecb-refresh ()
  (interactive)
  ;; note the "with-current-buffer" part
  ;; it's very important - all manipulations with tree must be performed in the context of its buffer
  (with-current-buffer (get-buffer ecb-directories-buffer-name)
    (dolist (n tree-buffer-displayed-nodes)
      (when (tree-node->expanded n)
        (ecb-update-directory-node n)
        (tree-buffer-update)))))
(global-set-key (kbd "C-r") 'my-ecb-refresh)

(defun my-ecb-diff ()
  (interactive)
  (let ((node (tree-buffer-get-node-at-point)))
  (when node
  (let ((file (tree-node->data node)))
    (if (file-directory-p file)
      (progn
        (vc-dir file))
      (progn
        (with-temp-buffer
          (find-file file)
          (call-interactively 'vc-diff))))))))
(defun my-ecb-omni-diff ()
  (interactive)
  (if (eq (current-buffer) (get-buffer ecb-directories-buffer-name))
    (my-ecb-delete)
    (progn
      (my-ecb-goto-window-directories)
      (my-ecb-diff)
      (my-ecb-goto-window-edit-last))))
(global-set-key (kbd "s-=") 'my-ecb-omni-diff)
(global-set-key (kbd "C-=") 'my-ecb-omni-diff)
(add-hook 'ecb-directories-buffer-after-create-hook (lambda () (local-set-key (kbd "=") 'my-ecb-diff)))

(defun my-ecb-delete () 
  (interactive)
  (let ((node (tree-buffer-get-node-at-point)))
  (when node
  (let ((parent (tree-node->parent node)))
  (let ((file (tree-node->data node)))
    (if (file-directory-p file)
      (progn
        (if (not (eq tree-buffer-root parent))
          (ecb-delete-directory node)
          (ecb-delete-source-path node)))
      (progn
        (ecb-delete-source node))))))))
(defun my-ecb-omni-delete ()
  (interactive)
  (if (eq (current-buffer) (get-buffer ecb-directories-buffer-name))
    (my-ecb-delete)
    (progn
      (my-ecb-goto-window-directories)
      (my-ecb-delete)
      (my-ecb-goto-window-edit-last))))
(global-set-key (kbd "<s-delete>") 'my-ecb-omni-delete)
(add-hook 'ecb-directories-buffer-after-create-hook (lambda () (local-set-key (kbd "<delete>") 'my-ecb-delete)))

(defun my-ecb-create-directory ()
  (interactive)
  (let ((node (tree-buffer-get-node-at-point)))
  (when node
  (let ((parent (tree-node->parent node)))
  (let ((file (tree-node->data node)))
    (if (file-directory-p file)
      (progn
        (ecb-create-directory node))
      (progn
        (ecb-create-directory parent))))))))
(defun my-ecb-omni-create-directory ()
  (interactive)
  (if (eq (current-buffer) (get-buffer ecb-directories-buffer-name))
    (my-ecb-create-directory)
    (progn
      (my-ecb-goto-window-directories)
      (my-ecb-create-directory))))
(global-set-key (kbd "s-+") 'my-ecb-omni-create-directory)
(global-set-key (kbd "<s-S-insert>") 'my-ecb-omni-create-directory)
(add-hook 'ecb-directories-buffer-after-create-hook (lambda () (local-set-key (kbd "+") 'my-ecb-create-directory)))
(add-hook 'ecb-directories-buffer-after-create-hook (lambda () (local-set-key (kbd "<S-insert>") 'my-ecb-create-directory)))

(defun my-ecb-create-file ()
  (interactive)
  (let ((node (tree-buffer-get-node-at-point)))
  (when node
  (let ((parent (tree-node->parent node)))
  (let ((file (tree-node->data node)))
    (if (file-directory-p file)
      (progn
        (ecb-create-source node))
      (progn
        (ecb-create-source parent))))))))
(defun my-ecb-omni-create-file ()
  (interactive)
  (if (eq (current-buffer) (get-buffer ecb-directories-buffer-name))
    (my-ecb-create-directory)
    (progn
      (my-ecb-goto-window-directories)
      (my-ecb-create-file))))
(global-set-key (kbd "<s-insert>") 'my-ecb-omni-create-file)
(add-hook 'ecb-directories-buffer-after-create-hook (lambda () (local-set-key (kbd "<insert>") 'my-ecb-create-file)))

(defun my-ecb-rename ()
  (interactive)
  (let ((node (tree-buffer-get-node-at-point)))
  (when node
  (let ((parent (tree-node->parent node)))
  (let ((file (tree-node->data node)))
    (if (file-directory-p file)
      (progn
        (if (not (eq tree-buffer-root parent))
          (ecb-rename-directory node)
          (ecb-rename-source-path node)))
      (progn
        (ecb-rename-source node))))))))
(defun my-ecb-omni-rename ()
  (interactive)
  (if (eq (current-buffer) (get-buffer ecb-directories-buffer-name))
    (my-ecb-rename)
    (progn
      (my-ecb-goto-window-directories)
      (my-ecb-rename)
      (my-ecb-goto-window-edit-last))))
(global-set-key (kbd "<s-S-f6>") 'my-ecb-omni-rename)
(global-set-key (kbd "<s-f2>") 'my-ecb-omni-rename)
(add-hook 'ecb-directories-buffer-after-create-hook (lambda () (local-set-key (kbd "<S-f6>") 'my-ecb-rename)))
(add-hook 'ecb-directories-buffer-after-create-hook (lambda () (local-set-key (kbd "<f2>") 'my-ecb-rename)))

;; makes cursor follow currently selected file or directory when switching to *ECB Directories*
(defun my-ecb-goto-window-directories ()
  (interactive)
    (if (eq major-mode 'dired-mode)
      (progn
        (let ((dir dired-directory))
          (ecb-goto-window-directories)
          (let ((short-dir (substring dir 0 (- (length dir) 1))))
          (let ((expanded-dir (expand-file-name short-dir)))
          (let ((node (tree-buffer-find-displayed-node-by-data/name expanded-dir)))
            (when node            
              (ecb-set-selected-directory expanded-dir)
              (let ((line (count-lines 1 (tree-buffer-get-node-name-start-point node))))
                (tree-buffer-goto-line line)
                (beginning-of-line)
                (re-search-forward tree-buffer-incr-searchpattern-indent-prefix nil t))))))))
      (progn
        (ecb-goto-window-directories)
        (let ((node (tree-buffer-find-displayed-node-by-data/name (car (ecb-path-selected-source)))))
          (when node            
            (let ((line (count-lines 1 (tree-buffer-get-node-name-start-point node))))
              (tree-buffer-goto-line line)
              (beginning-of-line)
              (re-search-forward tree-buffer-incr-searchpattern-indent-prefix nil t)))))))
(global-set-key (kbd "<M-f1>") 'my-ecb-goto-window-directories)

(defun my-ecb-goto-window-edit-last ()
  (interactive)
  (ecb-goto-window-edit-last))
(global-set-key (kbd "<M-f2>") 'my-ecb-goto-window-edit-last)

