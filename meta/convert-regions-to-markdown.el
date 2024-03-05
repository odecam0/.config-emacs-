;; This file will implement the conversion of a file that has prose and hyperlinks to regions
;; into a markdown file with source blocks, and links to regions of files in source code.

;; For links to be implemented, I need somehow to specify the hash of the commit the file is pointing
;; to, and where the repository is hosted on the web.
;; 2 Lines in the beginning of the file:
;; remote_repo: <remote_repo_url>
;; commit_hash: <commit-hash-to-be-used>

;; I will use prefix crtm (convert region to markdown)

(defun crtm-scan-buffer (search dispatch)
  ()
  "Implement the stepping forward trhough the buffer, always searching
   on the remaining buffer after a match."
  (save-excursion
    (goto-char 0)
    (let ((acc nil))
      (while (funcall search)
	(setq acc (cons (funcall dispatch) acc)))
      (message "%s" (apply 'concat (reverse acc))))))
;; (debug-on-entry 'crtm-scan-buffer)
;; (cancel-debug-on-entry 'crtm-scan-buffer)

(defun crtm-select-region ()
  ()
  "Implements the search for a pattern"
  (search-forward-regexp "\\(;;.*?\n\\)+\\|\\(^(.+)$\\)\\|\\(\n\n\n\\)" nil t))

(defun crtm-discriminate-region (&rest rest)
  ()
  "Must be called imediatelly after the crtm-select-region.
   REST is a list with functions,
   each will be called with the nth group matched by crtm-select-region"
  (let ((index 0) my-match)
    (dolist (proc rest)
      (setq index (+ 1 index))
      (if (match-string index)
	  (cl-return (funcall proc (substring-no-properties (match-string 0))))))))
;; (debug-on-entry 'crtm-discriminate-region)
;; (cancel-debug-on-entry 'crtm-discriminate-region)

(defun crtm-convert-buffer (&optional filename)
  (interactive)
  "It goes through a buffer using crtm-scan-buffer, and for each pattern matched
   by crtm-select-region, it discriminates it using a dispatch function.
   The dispatch function is implemented using crtm-discriminate-region, which
   calls the nth function passed to it if the patter was matched by nth group in
   crtm-select-region"
  (let ((converted-text (crtm-scan-buffer
			 #'crtm-select-region
			 (lambda () (crtm-discriminate-region
				     #'crtm-deal-with-prose
				     #'crtm-deal-with-region-links
				     #'(lambda (x) x))))))
    (if (not filename)
	(converted-text)
      (find-file filename)
      (insert converted-text))))


(defun crtm-deal-with-prose (text)
  ()
  "Will just filter out the beginning ';; ' of each line.
   It will also remove the last \n. Because of the regexp built."
  (concat (s-replace-regexp "^;;\\ " "" text) "\n"))

(defvar crtm-major-mode-to-src-block-type nil
  "Defines wich name of language to use in the source block of the markdown file")
(setq crtm-major-mode-to-src-block-type
      '((python-mode . "python")
	(js-mode     . "js")
	(emacs-lisp-mode . "elisp")
	(css-mode . "css")))

(defun crtm-deal-with-region-links (text)
  ()
  "Will copy the text that the link to region points to, encolsing
   it with markdown syntax for source code, and adding line break at
   the end."
  (save-window-excursion
    (eval (read text))
    (concat
     "[Region on original file](" (crtm-get-github-link-to-region) ")\n"
     "``` "
     (cdr (assoc major-mode crtm-major-mode-to-src-block-type))
     "\n"
     (buffer-substring-no-properties (point) (mark))
     "\n```\n\n")))

(defvar crtm-remote-repo-url nil
  "Holds the URL for the remote repo.
   Ex: github.com/odecam0/chronos-crm/")
(setq crtm-remote-repo-url "https://github.com/odecam0/.config-emacs-/")

(defun crtm-get-github-link-to-region ()
  ()
  "Will generate a github hyperlink to the region active in the buffer."
  (concat crtm-remote-repo-url
	  "blob/"
	  (_mc-get-last-commit-hash)
	  "/" 
	  (file-relative-name (buffer-file-name) (_mc-get-git-root-dir))
	  "#L" (number-to-string (line-number-at-pos (region-beginning)))
	  "-L" (number-to-string (line-number-at-pos (region-end)))
	  ))
  
;; (buffer-file-name)
;; (_mc-get-git-root-dir)
;; (file-relative-name (buffer-file-name) (_mc-get-git-root-dir))


; (find-efunction-links 'file-relative-name)
  
;; (find-metagrep "grep -n \"root\" ./*")
;; (find-metagrep "grep -n \"file\" ./*")
;; (find-metagrep "grep -n current ./*")
;; (find-metafile "parallel-commit.el" "defun _mc-get-last-commit-hash")
  
;; (find-node "(elisp)The Region")
;; (find-efunction 'line-number-at-pos)
