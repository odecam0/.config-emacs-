;; ( A command to get all staged file names, commit the changes in the meta branch
;; (   , get the content of the changed files, filter the meta contents, change to
;; (     the main branch again, apply the changes, and commit with the same message.

;; ( TODO: Change find-file in _mc-get-file-filtered-content for something that does
;; (       not ask for permission when acessing already opened buffer that has changed
;; (       in disk

;; ( TODO: Partimentalizar algumas funções, por exemplo, deve ser possível chamar uma função
;; (       para commitar no meta, sem passar para o regular.

;; ( TODO: Fazer filtrar apenas os arquivos com determinada extensão. tipo .py e .js

;; ( TODO: Fazer usar mesmo alist que overlay-hide..
;; (       Pode haver um probleme (find-metafile "overlay-hide.el" "ESQUEMA INTERNO")
;; (       Outro problema será testar esse tipo de coisa, pois o teste é bem invasivo.

;; (defun eejump-3 () () (swiper "(defun"))
;; (defun eejump-33 () () (swiper ";;\\W\\w"))

(load "main.el")
;; (find-fline "~/.config/emacs/meta/main.el")

(load "major-mode-regexp-mapping.el")
;; (find-file "./major-mode-regexp-mapping.el")

;; ;;;;;;;;;;;;; ;;
;; GETTING FILES ;;
;; ;;;;;;;;;;;;; ;;

;; ( When getting files, I should always ignore the _mc-sync-log-file-name file.
;; ( Now it is already being ignored because meta_sync_log is not added to
;; ( _mc-file-extensions-to-filter list.

(defvar _mc-sync-log-file-name ".meta_sync_log"
  "Holds the name of the file that will be stored in the meta branch, and will store a history
   of the commit-hashes of the parallel commits, and the merges from original-branch to meta
   branch, wich will be useful when choosing wich files to filter for the parallel commit.

   The file will be structured as multiple lines like the following example:
   original: <commit-hash> | meta: <commit-hash> | type: <parallel-commit|merge>

   The lines will be added always at the beginning of the file, the first line being representing
   the latest sync.")

(defun _mc-get-last-sync-meta-hash ()
  ()
  "Acess file with name _mc-sync-log-file-name, and extract the meta hash from its first line,
   the line being formated as:
   \"original: <hash> | meta: <hash_to_be_returned> | type: <parallel-commit|merge>\""
  (save-window-excursion 
    (find-file (concat (_mc-get-git-root-dir) _mc-sync-log-file-name))
    (string-match "original:\s.+\s|\smeta:\s+\\([^\s]+\\)\s"
		  (buffer-substring-no-properties
		   (line-beginning-position)
		   (line-end-position)))
    (buffer-substring-no-properties (+ (match-beginning 1) 1) (+ (match-end 1) 1))))
;; (_mc-get-last-sync-meta-hash)


(defvar _mc-file-extensions-to-filter '("el" "py" "js" "gitignore")
  "Only filter file if it got one of these file extensions.")

(defun _mc-get-files-that-changed-since-commit (commit-hash)
  ()
  "Will return a list of files that change since the commit passed as argument.
   It will compare the current commit from the current branch to the commit passed as parameter
   from the current branch."
  (shell-command (concat "git diff --name-only " commit-hash))
  (save-window-excursion
  (-filter (lambda (x) (> (length x) 0))
	   (s-split "[\s+\n]\n?"
		    (with-current-buffer shell-command-buffer-name
		      (buffer-substring-no-properties (point-min) (point-max)))))))
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


;; ;;;;;;;;;;;;;; ;;;
;; FILTERING DATA ;;;
;; ;;;;;;;;;;;;;; ;;;
;;
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


;; ( ;; ;;;;;;;;;;;;;;;;;;;;;;;;;; ;;
;; ( ;; COPYING NOT FILTERED FILES ;;
;; ( ;; ;;;;;;;;;;;;;;;;;;;;;;;;;; ;;
;; ( ;;
;; (      There is something else to be taken into consideration here. When I develop in the meta branch
;; (      I might add some files that should not be filtered, but nonetheless should be added to the original
;; (      branch when parallel commiting.

;; (      To do that, I figure I should make a temporary directory with this files that do not have an extension
;; (      that matches any of the _mc-file-extensions-to-filter elements, and when changing to original branch
;; (      copy them over to the repository.

;; (      I will call this activity 'Copying not filtered files'
(defun _mc-getting-not-filtered-files-names (files)
  ()
  "This function will get all the files that changed since last sync commit. And filter
   the file names to get only those whose extension does not match the _mc-file-extensions-to-filter
   extensions. It is complementary to the _mc-filter-list-of-files-by-file-extension function."
  (let ((filtered-list nil) (does-not-match-any-extension t))
    (dolist (current-file-name files filtered-list)
      (dolist (current-file-extension _mc-file-extensions-to-filter)
	(string-match "^.*\\.\\(.+\\)$" current-file-name)
	(if (string= (substring current-file-name (match-beginning 1) (match-end 1)) current-file-extension)
	    (setq does-not-match-any-extension nil)))
      (if (and does-not-match-any-extension
	       ;; ( Should not add the meta-sync-log file..
	       (not (string= current-file-name _mc-sync-log-file-name))) 
	  (setq filtered-list (cons current-file-name filtered-list)))
      (setq does-not-match-any-extension t))))
;; (_mc-getting-not-filtered-files-names (_mc-get-files-that-changed-since-commit "b97bc78d669e6eaea794eb36f2d9f4cb9ff94a45"))
;; (let ((default-directory "~/chronos-crm/")) (_mc-get-files-that-changed-since-commit (_mc-get-last-sync-meta-hash)))
;; (let ((default-directory "~/chronos-crm/")) (_mc-getting-not-filtered-files-names (_mc-get-files-that-changed-since-commit (_mc-get-last-sync-meta-hash))))

(defvar _mc-directory-for-copying-not-filtered-files "~/.meta-temporary-not-filtered-files/"
  "This directory should not conflict with any other directory already created, and with contents in
   your filesystem. This directory will be created and removed on a parallel commit, if there are files
   changed that should not be filtered.")

;; ( In mc-parallel-commit-1, just before switching to original branch, a decision should be made.
;; ( If _mc-getting-not-filtered-files-names is not nil, then the _mc-directory-for-copying-not-filtered-files
;; ( should be created, and the files with those names should be copied there. This decision making will
;; ( be implemented here.
;; (find-metafile "parallel-commit.el" "defun mc-parallel-commit-1 ()")

(defun _mc-get-dir-structure-from-files (files)
  ()
  "This function will get the paths of the files, removing their file names, just to get the directories
   in which they are disposed."
  (let ((dir-paths nil))
    (dolist (f files dir-paths)
      (if
	  (string-match "^\\(.+/\\)+[^/]*$" f)
	  (if (not (-contains? dir-paths (match-string 1 f)))
	      (add-to-list 'dir-paths (match-string 1 f)))))))
;; (_mc-get-files-that-changed-since-commit "b97bc78d669e6eaea794eb36f2d9f4cb9ff94a45")
;; (_mc-get-dir-structure-from-files (_mc-get-files-that-changed-since-commit "b97bc78d669e6eaea794eb36f2d9f4cb9ff94a45"))
;; (let ((default-directory "~/chronos-crm/")) (_mc-get-dir-structure-from-files (_mc-get-files-that-changed-since-commit (_mc-get-last-sync-meta-hash))))

(defun _mc-create-directory-structure (where directories)
  ()
  "This function will create the DIRECTORIES in WHERE
   WHERE must have the final / and directories should not have an initial /"
  (dolist (dir directories)
    (shell-command (concat "mkdir -p " where dir))))
;; (_mc-create-directory-structure "~/_mc-teste/" (_mc-get-dir-structure-from-files (_mc-get-files-that-changed-since-commit "b97bc78d669e6eaea794eb36f2d9f4cb9ff94a45")))
;; (find-file "~/_mc-teste/")
;; (shell-command "rm -r ~/_mc-teste/")

;; ( Alguma decisão de design foi encontrada novamente aqui agora.
;; ( Essa próxima função que está escrita aqui embaixo, que que tem ela? Tem o seguinte,
;; ( ela vai copiar os arquivos que não serão filtrados para uma pasta temporária,
;; ( para isso, irá criar uma estrutura de pastas.
;; ( Essa mesma estrutura de pastas tem que ser criada no original branch.

;; (     Bah, a solução é simples pô, a estrutura de pastas será recuperada da pasta temporária
;; (     da mesma maneira que foi recuperada o meta branch....


;; (find-metafile "parallel-commit.el" "let* ((files-that-changed-since-last-sync-commit")
(defun _mc-copy-not-filtered-files-from-meta-to-temp (files)
  ()
  "Gets a list of file-names as parameter and filter them to get only those that will not be filtered, get what directories should
   be created, create them in the temporary directory defined above and copy the files"
  (let ((not-filtered-files-names (_mc-getting-not-filtered-files-names files)))
    (_mc-create-directory-structure _mc-directory-for-copying-not-filtered-files (_mc-get-dir-structure-from-files not-filtered-files-names))
    (dolist (file not-filtered-files-names)
      (shell-command (concat "cp " (_mc-get-git-root-dir) file " " _mc-directory-for-copying-not-filtered-files file))
      (message       (concat "cp " (_mc-get-git-root-dir) file " " _mc-directory-for-copying-not-filtered-files file)))))
;; (_mc-copy-not-filtered-files-from-meta-to-temp (_mc-get-files-that-changed-since-commit "b97bc78d669e6eaea794eb36f2d9f4cb9ff94a45"))
;; (let ((default-directory "~/chronos-crm/")) (_mc-get-files-that-changed-since-commit (_mc-get-last-sync-meta-hash)))
;; (let ((default-directory "~/chronos-crm/")) (_mc-copy-not-filtered-files-from-meta-to-temp (_mc-get-files-that-changed-since-commit (_mc-get-last-sync-meta-hash))))
;; (find-file _mc-directory-for-copying-not-filtered-files)


;; ( X.1. META TO ORIGINAL
;; (      Aqui algumas coisas serão re-estruturadas mais para frente.
;; (      mas isso não importa agora.
;; (          O importante é se manter relaxado e gastar pouca energia fazendo bastante coisa.
;; (      Este próximo trecho é sobre copiar os arquivos da pasta temporária para a pasta original

;; (find-man "find")
;; (find-man "find" "-type")
;; (find-man "find" "-type" "f")
;; ( find ./ -type f
(defun _mc-get-all-files-from-directory (dir)
  ()
  "Returns all files inside a directory without the absolute path to that directory,
   (also withou the relative path to that directory (?!) i don't know how to write what I mean,
    run it and find out... )"
  ;; ( This works because we are not inside a git repository, inside a git repository, this command
  ;; ( would return a lot of files internal to git, inside .git folder.
  (shell-command (concat "find " dir " -type f -printf \"%P\\n\""))
  (save-window-excursion
    (let ((return-list nil))
      (dolist (file
	       (-filter (lambda (x) (> (length x) 0))
			(s-split "[\s+\n]\n?"
				 (with-current-buffer shell-command-buffer-name
				   (buffer-substring-no-properties (point-min) (point-max)))))
	       return-list)
	(add-to-list 'return-list (s-replace-regexp (regexp-quote dir) "" file))))))
;; (_mc-get-all-files-from-directory _mc-directory-for-copying-not-filtered-files)
;; (_mc-get-dir-structure-from-files (_mc-get-all-files-from-directory _mc-directory-for-copying-not-filtered-files))
;; (_mc-create-directory-structure "~/chronos-crm/" (_mc-get-dir-structure-from-files (_mc-get-all-files-from-directory _mc-directory-for-copying-not-filtered-files)))

(defun _mc-copy-not-filtered-files-from-temp-to-original (files)
  ()
  ""
  (dolist (f files)
    (shell-command (concat "cp " _mc-directory-for-copying-not-filtered-files f " " (_mc-get-git-root-dir) f))))
;; (let ((default-directory "~/chronos-crm/")) (_mc-copy-not-filtered-files-from-temp-to-original (_mc-get-all-files-from-directory _mc-directory-for-copying-not-filtered-files)))
;; (find-file "~/chronos-crm/")

;; ;;;;;;;;;;;;;;;; ;;
;; APPLYING CHANGES ;;
;; ;;;;;;;;;;;;;;;; ;;
;;
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


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;
;; PUTTING THE PIECES TOGETHER ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;
;;
;; ( Falta atualizar o sync-log-file depois de fazer commit no original branch. Mas isso será feito em uma segunda função.
(defun mc-parallel-commit-1 ()
  (interactive)
  "This function will get whatever changed since last sincronization between the original and meta branhces,
   signalized by the _mc-sync-log-file-name file, adding the value of the last commit-hash. Filter these files
   removing the meta content, change to the original branch, apply the changes, stage all files."
  (let* ((files-that-changed-since-last-sync-commit
	  (_mc-get-files-that-changed-since-commit
	   (_mc-get-last-sync-meta-hash)))
	 (files-with-contents
	  ;; ( Filtering files contents
	  (_mc-get-all-files-names-with-filtered-content
	   ;; ( Getting files to filter, will get files changed since most recent sync
	   (_mc-filter-list-of-files-by-file-extension
	    files-that-changed-since-last-sync-commit)) ))
    (_mc-write-meta-hash-to-sync-log-file)
    (_mc-stage-files `(,(concat (_mc-get-git-root-dir) _mc-sync-log-file-name)))
    (if (= (_mc-commit-with-message "Updating meta-sync-file") 1)
	(shell-command (concat "git restore --staged " _mc-sync-log-file-name)))
    
    (_mc-copy-not-filtered-files-from-meta-to-temp files-that-changed-since-last-sync-commit)

    ;; ( Change to original branch
    (if (= (mc-switch-to-original-branch) 0)
	(progn
	  ;; ( Create directories structure
	  (_mc-create-directory-structure (_mc-get-git-root-dir) (_mc-get-dir-structure-from-files files-that-changed-since-last-sync-commit))
	  (_mc-copy-not-filtered-files-from-temp-to-original (_mc-get-all-files-from-directory _mc-directory-for-copying-not-filtered-files))
	  (_mc-apply-change files-with-contents)
	  (_mc-stage-files '("*")))
      (switch-to-buffer shell-command-buffer-name))))
;; (shell-command "sudo rm -r ~/config-backup/; cp -r ~/.config/emacs ~/config-backup/")
;; (shell-command "cd ~/config-backup/; git checkout meta")
;; (find-file "~/config-backup/")
;; (let ((default-directory "~/config-backup/")) (mc-parallel-commit-1))

;; (debug-on-entry 'mc-parallel-commit-1)
