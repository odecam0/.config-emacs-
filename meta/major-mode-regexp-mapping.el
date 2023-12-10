(defvar _mc-major-mode-regexp-mapping nil
  "This variable store what regexps will be used depending on which major-mode is active")
(setq _mc-major-mode-regexp-mapping
      '((python-mode . ("^\\(\s\\|	\\)*#+\s+.*\n\\(\\(\s\\|	\\)+*#+.*\n\\|\n\\)*"
			"\"\"\"\n\\(.*\n\\)*?\"\"\""))
	(js-mode     . ("^\\(\s\\|	\\)*//\\(\s\\|	\\)(.+\\(\n?\\(\s\\|	\\)*//\\(\s\\|	\\)(.+\n\\)*"
			"/\\*\n\\(.*\n\\)+\\*/"))
	(emacs-lisp-mode . ("^\\(\s\\|	\\)*;+\s+.*\n\\(\n?\n?\\(\s\\|	\\)+*;+\s+(.*\n\\)*"
			    "^\\(\s|	\\)*;+\s+(.*$"))))

(defun _mc-get-major-modes-regexp  ()
  ()
  "Given the current buffer's major mode, return the list of regexps associated
   stored in _mc-major-mode-regexp-mapping"
  (cdr (assoc major-mode _mc-major-mode-regexp-mapping)))
