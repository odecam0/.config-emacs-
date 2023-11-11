;; ( A command to get all staged file names, commit the changes in the meta branch
;; (   , get the content of the changed files, filter the meta contents, change to
;; (     the main branch again, apply the changes, and commit with the same message.

;; ( Aqui é aparente onde vai dar mais trabalho.
;; ( Aqui quero terminar de fazer funcionar para continuar o trabalho do crm.

;; ( TODO: Change find-file in _mc-get-file-filtered-content for something that does
;; (       not ask for permission when acessing already opened buffer that has changed
;; (       in disk

;; ( TODO: Partimentalizar algumas funções, por exemplo, deve ser possível chamar uma função
;; (       para commitar no meta, sem passar para o regular.

;; ( TODO: Fazer filtrar apenas os arquivos com determinada extensão. tipo .py e .js

;; ( TODO: Fazer usar mesmo alist que overlay-hide..
;; (       Pode haver um probleme (find-metafile "overlay-hide.el" "ESQUEMA INTERNO")
;; (       Outro problema será testar esse tipo de coisa, pois o teste é bem invasivo.

;; ( git diff --name-only commit-hash

(load-file "./main.el")
;; (find-fline "~/.config/emacs/meta/main.el")

(load-file "./major-mode-regexp-mapping.el")
;; (find-file "./major-mode-regexp-mapping.el")


;; GETTING FILES
;; ( When getting files, i should always ignore the _mc-sync-log-file-name file.
;; ( Now it is already being ignored because meta_sync_log is not added to _mc-file-extensions-to-filter
;; ( list.

(defvar _mc-sync-log-file-name ".meta_sync_log"
  "Holds the name of the file that will be stored in the meta branch, and will store a history
   of the commit-hashes of the parallel commits, and the merges from original-branch to meta
   branch, wich will be useful when choosing wich files to filter for the parallel commit.

   The file will be structured as multiple lines like the following example:
   original: <commit-hash> | meta: <commit-hash> | type: <parallel-commit|merge>

   The lines will be added always at the beginning of the file, the first line being representing
   the latest sync.")

(defvar _mc-file-extensions-to-filter '("el" "py" "js" "gitignore")
  "Only filter file if it got one of these file extensions.")

(defun _mc-get-last-sync-meta-hash ()
  ()
  "Acess file with name _mc-sync-log-file-name, and extract the meta hash from its first line,
   the line being formated as:
   \"original: <hash> | meta: <hash_to_be_returned> | type: <parallel-commit|merge>\""
  (save-window-excursion 
    (find-file _mc-sync-log-file-name)
    (string-match "original:\s.+\s|\smeta:\s+\\([^\s]+\\)\s"
		  (buffer-substring-no-properties
		   (line-beginning-position)
		   (line-end-position)))
    (buffer-substring-no-properties (+ (match-beginning 1) 1) (+ (match-end 1) 1))))
;; (_mc-get-last-sync-meta-hash)

(defun _mc-get-files-that-changed-since-commit (commit-hash)
  ()
  "Will return a list of files that change since the commit passed as argument.
   It will compare the current commit from the current branch to the commit passed as parameter
   from the current branch."
  (shell-command (concat "git diff --name-only " commit-hash))
  (-filter (lambda (x) (> (length x) 0))
	   (s-split "[\s+\n]\n?"
		    (with-current-buffer shell-command-buffer-name
		      (buffer-substring-no-properties (point-min) (point-max))))))
;; (_mc-get-files-that-changed-since-commit "b97bc78d669e6eaea794eb36f2d9f4cb9ff94a45")

(defun _mc-filter-list-of-files-by-file-extension (files)
  ()
  "Will return a list of files only with files that have a file extension that is in
   the _mc-file-extensions-to-filter list."
  (let ((filtered-list nil))
    (dolist (current-file-name files filtered-list)
      (dolist (current-file-extension _mc-file-extensions-to-filter)
	(string-match "^.*\\.\\(.+\\)$" current-file-name)
	(if (string= (substring current-file-name (match-beginning 1) (match-end 1)) current-file-extension)
	    (setq filtered-list (cons current-file-name filtered-list)))))))
;; (_mc-filter-list-of-files-by-file-extension (_mc-get-files-that-changed-since-commit "b97bc78d669e6eaea794eb36f2d9f4cb9ff94a45"))


;; FILTERING DATA
(defun _mc-get-git-root-dir ()
  ()
  "This function returns the root dir for this git repository."
  (shell-command "git rev-parse --show-toplevel")
  (with-current-buffer shell-command-buffer-name
    (concat (buffer-substring-no-properties (point-min) (- (point-max) 1)) "/")))
;; (_mc-get-git-root-dir)

(defun _mc-get-file-filtered-content (file-path)
  ()
  "Given a file name, this function will access the file, copy its content, filter its meta-contents
   then return the string without the meta-contents."
	     (save-window-excursion
	       (find-file file-path)
	       (let ((_mc-filtered-content
		      (substring-no-properties (ee-buffer-contents0 (current-buffer)))))
	 (dolist (var (_mc-get-major-modes-regexp) _mc-filtered-content)
	   (setq _mc-filtered-content (replace-regexp-in-string var "" _mc-filtered-content))))))
;; (_mc-get-file-filtered-content "./parallel-commit.el")

(defun _mc-get-all-files-names-with-filtered-content (files)
  "This function will return a list of lists in the following form
   ((file-name file-content-filtered) ... (file-name file-content-filtered))"
  ()
  (let ((return-list '())
        (_mc-root-dir (_mc-get-git-root-dir)))
    (dolist (var files return-list)
      (message (concat default-directory var))
      (setq return-list
	    (cons `(,var . ,(_mc-get-file-filtered-content (concat _mc-root-dir var))) return-list)))))
;; (setq my-aux (_mc-get-all-files-names-with-filtered-content (_mc-filter-list-of-files-by-file-extension (_mc-get-files-that-changed-since-commit "b97bc78d669e6eaea794eb36f2d9f4cb9ff94a45"))))
;; (switch-to-buffer "*Messages*")


;; APPLYING CHANGES
(defun _mc-apply-change (files-with-filtered-content)
  "This function acess all files from the parameter that is in the following format:
   '((<file-name> . <file-content>) ... (<file_name> . <file-content>))
   and set the file with file-name to the associated file-content then save it."
  ()
  (let ((_mc-path (_mc-get-git-root-dir)))
    (dolist (var files-with-filtered-content)
      (find-file (concat _mc-path (car var)))
      (erase-buffer)
      (insert (cdr var))
      (save-buffer))))
;; (shell-command "sudo rm -r ~/config-backup/; cp -r ~/.config/emacs ~/config-backup/")
;; (shell-command "cd ~/config-backup/; git checkout meta")
;; (let ((default-directory "~/config-backup/")) (setq my-aux (_mc-get-all-files-names-with-filtered-content '("meta/parallel-commit.el" "meta/overlay-hide.el"))))
;; (shell-command "cd ~/config-backup/; git checkout main")
;; (let ((default-directory "~/config-backup/")) (_mc-apply-change my-aux))

(defun _mc-get-last-commit-hash ()
  ()
  "Get the current commit hash"
  (shell-command "git rev-parse HEAD")
  (with-current-buffer shell-command-buffer-name
    (buffer-substring-no-properties (point-min) (- (point-max) 1))))
;; (_mc-get-last-commit-hash)

;; ( When applying changes, I need to update the _mc-sync-log-file-name file.
;; ( And commit it on the meta-branch.
(defun _mc-write-meta-hash-to-sync-log-file ()
  ()
  "This function will write the hash and type parts of _mc-sync-log-file-name file,
   while leaving the original part with a default value to be set when the user commit
   the changes in the original branch."
  (save-window-excursion
    (find-file (concat (_mc-get-git-root-dir) _mc-sync-log-file-name))
    (goto-char (point-min))
    (insert (concat "original: <original-hash> | meta: " (_mc-get-last-commit-hash) " | type: parallel-commit\n"))
    (save-buffer)))
;; (_mc-write-meta-hash-to-sync-log-file)
;; (find-file (concat (_mc-get-git-root-dir) _mc-sync-log-file-name))


;; PUTTING THE PIECES TOGETHER

(defun mc-parallel-commit-1 ()
  (interactive)
  "This function will get whatever changed since last sincronization between the original and meta branhces,
   signalized by the _mc-sync-log-file-name file, adding the value of the last commit-hash. Filter these files
   removing the meta content, change to the original branch, apply the changes, stage all files."
  (let ((files-with-contents
	 ;; ( Filtering files contents
	 (_mc-get-all-files-names-with-filtered-content
	  ;; ( Getting files to filter, will get files changed since most recent sync
	  (_mc-filter-list-of-files-by-file-extension
	   (_mc-get-files-that-changed-since-commit
	    (_mc-get-last-sync-meta-hash)))) ))
    ;; ( Change to original branch
    (mc-switch-to-original-branch)
    (_mc-apply-change files-with-contents)
    (_mc-stage-files '("*"))))
;; (shell-command "sudo rm -r ~/config-backup/; cp -r ~/.config/emacs ~/config-backup/")
;; (shell-command "cd ~/config-backup/; git checkout meta")
;; (let ((default-directory "~/config-backup/")) (setq my-aux (_mc-get-all-files-names-with-filtered-content '("meta/parallel-commit.el" "meta/overlay-hide.el"))))
;; (shell-command "cd ~/config-backup/; git checkout main")
;; (let ((default-directory "~/config-backup/")) (_mc-apply-change my-aux))
