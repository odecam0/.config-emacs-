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

(load "~/meta-package/main.el")

(defvar _mc-original-branch "main" "Holds the value of the previous branch before meta")
(defvar _mc-regexp-for-filtering '("^\"\"\"\n\\(.*\n\\)+?\"\"\"" "^\s*;+\s+(.*\n")
  "Regexps used to filter out of files content")

(setq _mc-original-branch "main")
(setq _mc-regexp-for-filtering '("^\"\"\"\n\\(.*\n\\)+?\"\"\"" "^\s*#\s*(.*\n"))
(setq _mc-regexp-for-filtering '("^\"\"\"\n\\(.*\n\\)+?\"\"\"" "^\s*;\s*(.*\n"))

(defun _mc-get-staged-files-names () ()
       (shell-command "git diff --name-only --cached")
       (-filter (lambda (x) (> (length x) 0))
		(s-split "[\s+\n]\n?" (ee-buffer-contents0 shell-command-buffer-name))))

(defun _mc-commit-with-message (message) ()
       (shell-command (concat "git commit -m \"" message "\"")))

(defun _mc-get-file-filtered-content (file-path) ()
	     (save-window-excursion
	       (find-file file-path)
	       (let ((_mc-filtered-content
		      (substring-no-properties (ee-buffer-contents0 (current-buffer)))))
	 (dolist (var _mc-regexp-for-filtering _mc-filtered-content)
	   (setq _mc-filtered-content (replace-regexp-in-string var "" _mc-filtered-content))))))
;; (_mc-get-file-filtered-content "./aux.el")
;; (_mc-get-file-filtered-content "~/teste/a.el")

;; (create-file-buffer "~/teste/a.el")
     
(defun _mc-get-all-files-names-with-filtered-content (files)
  "This function will return a list of lists in the following form
   ((file-name file-content-filtered) (file-name file-content-filtered))"
  ()
  (let ((return-list '()))
    (dolist (var files return-list)
      (setq return-list
	    (-concat return-list `((,var . ,(_mc-get-file-filtered-content var))))))))
;; (_mc-get-all-files-names-with-filtered-content)

(defun _mc-apply-change (files-with-filtered-content)
  "This function acess all files listed from the function above,
   wipe all of its contents, and put all the contents from the meta
   branch filtered."
  ()
  (let ((_mc-path default-directory))
    (dolist (var files-with-filtered-content)
      (find-file (concat _mc-path (car var)))
      (erase-buffer)
      (message (cdr var))
      (insert (cdr var))
      (save-buffer))))
;; ( !CUIDADO! (_mc-apply-change (_mc-get-all-files-names-with-filtered-content))

(defun _mc_commit-with-message (message)
  ()
  (shell-command (concat "git commit -m \"" message "\"")))

(defun mc-parallel-meta-commit (message)
  (interactive "sCommit message: ")
  (let ((files-and-filtered-content
	 (_mc-get-all-files-names-with-filtered-content (_mc-get-staged-files-names))))
    (_mc-commit-with-message message)
    (_mc-switch-to-branch _mc-original-branch)
    (_mc-apply-change files-and-filtered-content)))

"
 (eepitch-kill)
 (eepitch-vterm)
sudo rm -r ~/teste
mkdir -p ~/teste
cd ~/teste
git init
echo -e 'blah blah\nblah blei' >> a.el
echo -e 'blah bling\nblah blong' >> b.el
git add *; git commit -m "commit"
git branch
 (setq _mc-original-branch "master")
 (setq _mc-regexp-for-filtering '("^\"\"\"\n\\(.*\n\\)+?\"\"\"" "^\s*;+\s*(.*\n"))
git branch meta
git checkout meta
echo -e 'blah blah\n;; ( blah blei' >> a.el
echo -e 'blah bling\n;; ( blah blong' >> b.el
git add *
git status
 (debug-on-entry #'mc-parallel-meta-commit)
 (let ((default-directory "~/teste/")) (mc-parallel-meta-commit "commit"))
 (cancel-debug-on-entry #'mc-parallel-meta-commit)
 (debug-on-entry #'_mc-get-all-files-names-with-filtered-content)
 (let ((default-directory "~/teste/")) (mc-parallel-meta-commit "commit"))
 (cancel-debug-on-entry #'_mc-get-all-files-names-with-filtered-content)
 (debug-on-entry #'_mc-get-file-filtered-content)
 (let ((default-directory "~/teste/")) (mc-parallel-meta-commit "commit"))
 (cancel-debug-on-entry #'_mc-get-file-filtered-content)
"
