(defun solution-files (&optional filter)
  (split-string (shell-command-to-string (find-files-in-solution-command filter)) "\0"))

(defun solution-abbrevd-files (&optional filter)
  ;; todo. find out why this is excruciatingly slow
  ;; (mapcar (lambda (filename) (solution-abbrev-string filename)) (solution-files filter))
  (split-string (shell-command-to-string (find-abbrevd-files-in-solution-command filter)) "\0"))

(defun solution-unabbrevd-files (&optional filter)
  (solution-files filter))

(defun find-files-in-solution-command (&optional filter)
  ;; todo. quote project paths properly
  (let ((paths (mapcar (lambda (project) (project-path (car project))) projects)))
  (let ((path-argument (mapconcat (lambda (path) (concat "'" path "'")) paths " ")))
  ;; todo. quote include patterns properly
  (let ((filter (if (and (stringp filter) (not (string= filter ""))) filter "*")))
  (let ((filter (if (string-match "^*/" filter) filter (concat "*/" filter))))
  (let ((include-paths (list filter)))
  (let ((include-argument (mapconcat (lambda (pattern) (concat " -path '" pattern "'")) include-paths " ")))
  ;; todo. quote exclude patterns properly
  (let ((exclude-files (list "*~" "*.~*" "#*#" "desktop")))
  (let ((exclude-dirs (list ".git" "lib_managed" "project" "target" "Emacs/libraries")))
  (let ((exclude-argument (mapconcat (lambda (pattern) (concat " ! -name '" pattern "'")) exclude-files " ")))
  (let ((exclude-argument (concat exclude-argument " " (mapconcat (lambda (pattern) (concat " ! -path '*/" pattern "/*'")) exclude-dirs " "))))
    (concat "find " path-argument " -type f " include-argument " " exclude-argument " -print0 "))))))))))))

(defun find-abbrevd-files-in-solution-command (&optional filter)
  (let ((command (find-files-in-solution-command filter)))
  (let ((filter (solution-abbrev-string-command)))
    (concat command " | " filter))))

(defun find-unabbrevd-files-in-solution-command (&optional filter)
  (find-files-in-solution-command filter))

(defun solution-abbrev-string (string)
  (let ((abbrevs (mapcar (lambda (project) (list (concat "/" (project-name (car project))) (project-path (car project)))) projects)))
    (mapc (lambda (abbrev)
      (let ((short (car abbrev)))
      (let ((expanded (cadr abbrev)))
        (if (and (>= (length string) (length expanded))
                     (string= expanded (substring string 0 (length expanded))))
        (setq string (concat short (substring string (length expanded)))))))) abbrevs))
  string)

(defun solution-unabbrev-string (string)
  (let ((abbrevs (mapcar (lambda (project) (list (concat "/" (project-name (car project))) (project-path (car project)))) projects)))
    (mapc (lambda (abbrev)
      (let ((short (car abbrev)))
      (let ((expanded (cadr abbrev)))
        (if (and (>= (length string) (length short))
                     (string= short (substring string 0 (length short))))
        (setq string (concat expanded (substring string (length short)))))))) abbrevs))
  string)

(defun solution-abbrev-string-command ()
  ;; todo. quote regex arguments property
  (let ((abbrevs (mapcar (lambda (project) (list (project-path (car project)) (concat "/" (project-name (car project))))) projects)))
  (concat "perl -nE 'chomp; "  (mapconcat (lambda (abbrev) (concat "s#" (car abbrev) "#" (cadr abbrev) "#g;")) abbrevs " ") " say;'")))

(defun solution-unabbrev-string-command ()
  ;; todo. quote regex arguments property
  (let ((abbrevs (mapcar (lambda (project) (list (project-path (car project)) (concat "/" (project-name (car project))))) projects)))
  (concat "perl -nE 'chomp; "  (mapconcat (lambda (abbrev) (concat "s#" (cadr abbrev) "#" (car abbrev) "#g;")) abbrevs " ") " say;'")))
