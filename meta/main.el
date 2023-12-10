;; ( This file is going to be the implementation of the meta-content specification
;; ( There are going to be 2 git branches, one of the called meta.
;; ( A command to switch to the regular branch, if on a meta branch.
;; (
;; ( All functions in this package will be prepended by "mc" as in "meta-content"
;; (
;; ( A command to switch to the meta branch, creating one if it does not exist.

(defvar _mc-original-branch "main" "Holds the value of the original branch's name")
(defvar _mc-meta-branch     "meta" "Holds the value of the meta branch's name")
(setq _mc-original-branch "master")

(defun mc-switch-to-meta-branch ()
  (interactive)
  (if (_mc-check-if-meta-branch-exists)
      (_mc-switch-to-branch _mc-meta-branch)
    (_mc-create-meta-branch)))

(defun mc-switch-to-original-branch ()
  (interactive)
  (_mc-switch-to-branch _mc-original-branch))

;; (find-sh "git branch --help")
;; (find-sh "git branch --help" "-l, --list")
;; (find-sh "cd ~/ic/; git branch -l")
;; ( 
(defun _mc-get-list-of-branches () ()
       ;; ( considerando que está numa pasta num repositório git
       (shell-command "git branch --list")
       (-filter (lambda (x) (> (length x) 0))
	(s-split "[\s+\n]\n?"
		 (string-replace "*" ""
				 (ee-buffer-contents0 shell-command-buffer-name)))))
;; (_mc-get-list-of-branches)

(defun _mc-check-if-meta-branch-exists () ()
       (-contains-p (_mc-get-list-of-branches) _mc-meta-branch))
;; (_mc-check-if-meta-branch-exists)

(defun _mc-create-meta-branch () ()
       (shell-command "git branch meta"))

(defun _mc-switch-to-branch (branch-name) ()
       (shell-command (concat "git checkout " branch-name)))

(defun _mc-stage-files (files)
  ()
  (dolist (f files)
    (shell-command (concat "git add " f))))

(defun _mc-commit-with-message (message)
  ()
  (shell-command (concat "git commit -m \"" message "\"")))


;; (find-fline "./overlay-hide.el")

