;; (find-fline "./main.el")
;; ( A command to hide meta-content using overlays
(load "meta/major-mode-regexp-mapping.el")
;; (find-fline "./major-mode-regexp-mapping.el")

(defvar _mc-overlays '() "A list of overlays that hide meta content")
(defvar _mc-overlays-activep nil "Wether meta content is hidden or not")

(defun _mc-kill-overlays (overlays)
  ()
  (dolist (var overlays)
    (delete-overlay var))
  (setq _mc-overlays nil))
;; (_mc-kill-overlays _mc-overlays)

(defun _mc-list-matches (regexp)
  ()
  "Will return a list with the matches in the buffer, from REGEXP"
  (let ((_mc-match-beg t) (string-match-beg 1) (matches))
    (while _mc-match-beg
      (setq _mc-match-beg
	    (string-match regexp (buffer-substring-no-properties
				  string-match-beg (point-max))))
      ;; ( somo o string-match parar refletir a posição correta no buffer
      (if _mc-match-beg
	  (setq matches
		(cons `(,(+ string-match-beg _mc-match-beg)
			,(+ string-match-beg (match-end 0))) matches)))
      (setq string-match-beg (+ string-match-beg (match-end 0))))
    matches))
;; (cancel-debug-on-entry #'_mc-list-matches)
;; (debug-on-entry #'_mc-list-matches)
;; (_mc-list-matches "^\\(\s\\|	\\)*;+\s+.*\n\\(\n?\n?\\(\s\\|	\\)+*;+\s+(.*\n\\)*")

(defun _mc-overlay-matches (matches)
  ()
  "Receives a list with '(start end) as elements, specifying match regions"
  (mapcar
   (lambda (arr) (make-overlay (car arr) (car (cdr arr))))
   matches))
;; (debug-on-entry #'_mc-overlay-matches)
;; (_mc-overlay-matches (_mc-list-matches "^\\(\s\\|	\\)*;+\s+.*\n\\(\n?\n?\\(\s\\|	\\)+*;+\s+(.*\n\\)*"))

(defun _mc-make-overlays-invisible (overlays)
  ()
  "Just make all overlays listed in OVERLAYS invisible"
  (mapcar (lambda (x) (overlay-put x 'invisible t)) overlays))
;; (debug-on-entry #'_mc-make-overlays-invisible)
;; (_mc-make-overlays-invisible (_mc-overlay-matches (_mc-list-matches "^\\(\s\\|	\\)*;+\s+.*\n\\(\n?\n?\\(\s\\|	\\)+*;+\s+(.*\n\\)*")))

(defun _mc-correct-regexps-for-buffer  ()
  ()
  "Given the current buffer's major mode, return the list of regexps associated
   stored in _mc-major-mode-regexp-mapping"
  (cdr (assoc major-mode _mc-major-mode-regexp-mapping)))
;; (_mc-correct-regexps-for-buffer)
;; (let ((major-mode #'js-mode)) (_mc-correct-regexps-for-buffer))

;; ( I just want to isolate the implementation of the do-list loop in a function
(defun _mc-overlays-4-each-regexp (regexps)
  ()
  ""
  (_mc-overlay-matches (reduce #'-concat (mapcar #'_mc-list-matches regexps))))
;; (debug-on-entry #'_mc-overlays-4-each-regexp)
;; (_mc-overlays-4-each-regexp (_mc-get-major-modes-regexp))

(defun _mc-turn-on-overlays (&rest args)
  ()
  (_mc-make-overlays-invisible
   (setq _mc-overlays (_mc-overlays-4-each-regexp
		       (_mc-get-major-modes-regexp))))
  (setq _mc-overlays-activep t))

(defun _mc-turn-off-overlays (&rest args)
  ()
  (_mc-kill-overlays _mc-overlays)
  (setq _mc-overlays-activep nil)
  )

(defun mc-toggle-hide-meta ()
  (interactive)
  (save-excursion
    (if _mc-overlays-activep
	(_mc-turn-off-overlays)
      (_mc-turn-on-overlays))))
;; (debug-on-entry #'mc-toggle-hide-meta)
;; (cancel-debug-on-entry #'mc-toggle-hide-meta)
