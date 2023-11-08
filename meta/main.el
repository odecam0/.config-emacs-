;; ( This file is going to be the implementation of the meta-content specification
;; ( There are going to be 2 git branches, one of the called meta.
;; ( A command to switch to the regular branch, if on a meta branch.
;; (
;; ( All functions in this package will be prepended by "mc" as in "meta-content"
;; (
;; ( A command to switch to the meta branch, creating one if it does not exist.
(defun mc-switch-to-meta-branch ()
  (interactive)
  (if (_mc-check-if-meta-branch-exists)
      (_mc-switch-to-branch "meta")
    (_mc-create-meta-branch)))

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
       (-contains-p (_mc-get-list-of-branches) "meta"))
;; (_mc-check-if-meta-branch-exists)

(defun _mc-create-meta-branch () ()
       (shell-command "git branch meta"))

(defun _mc-switch-to-branch (branch-name) ()
       (shell-command (concat "git checkout " branch-name)))


;; (find-fline "./overlay-hide.el")

