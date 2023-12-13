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
      acc)))

(defun crtm-select-region ()
  ()
  "Implements the search for a pattern"
  (search-forward-regexp "\\(;;.*\n\\)+\\|\\(^(.+)$\\)\\|\\(\n\n\n\\)"))

(defun crtm-discriminate-region (&rest rest)
  ()
  "Must be called imediatelly after the crtm-select-region.
   REST is a list with functions,
   each will be called with the nth group matched by crtm-select-region"
  (let ((index 0) my-match)
    (dolist (proc rest)
      (setq index (+ 1 index))
      (if (match-string index)
	  (return (funcall proc (substring-no-properties (match-string 0))))))))
;; (debug-on-entry 'crtm-discriminate-region)
;; (cancel-debug-on-entry 'crtm-discriminate-region)

(defun crtm-convert-buffer ()
  (interactive)
  (crtm-scan-buffer
   #'crtm-select-region
   (lambda () (crtm-discriminate-region #'message #'message #'message))))


;; Onde implemento a parte que diz onde as coisas devem ser copiadas para?

(defun crtm-deal-with-prose (text)
  ()
  "Will just filter out the beginning ';; ' of each line.
   It will also remove the last \n. Because of the regexp built."
  )

(defun crtm-deal-with-region-links (text)
  ()
  "Will copy the text that the link to region points to")
  
