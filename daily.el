;; I want this function to find the file with the correct date, but it could also
;; have another metadata on the name, separated by ~. Like this: 04-11-2023~blah~bleh~bluh.org
;;  1. List files names.
;;  1. Find file name matching regexp.

(straight-use-package 'ts)
(require 'ts)
;; (ts-now)
;; (ts-format "%d-%m-%Y" (ts-now))
;; (ts-format "%d-%m-%Y" (ts-dec 'day 1 (ts-now)))

(defun daily-get-current-filenames-date-string ()
  ()
  (let ((filename (f-filename (buffer-file-name))))
    (substring filename 0
	       (if (string-match "~" filename)
		   (match-beginning 0)
		 (string-match "\.org" filename)))))
(defun daily-gcfds-year  () () (substring (daily-get-current-filenames-date-string) -4))
(defun daily-gcfds-day   () () (substring (daily-get-current-filenames-date-string) 0 2))
(defun daily-gcfds-month () () (substring (daily-get-current-filenames-date-string) 3 5))
;; (daily-get-current-filenames-date-string)
;; (daily-gcfds-year)
;; (daily-gcfds-day)
;; (daily-gcfds-month)

(defun daily-get-current-files-date ()
  ()
  (ts-parse
   (concat (daily-gcfds-year)  "-"
	   (daily-gcfds-month) "-"
	   (daily-gcfds-day))))
;; (daily-get-current-files-date)
;; (ts-format "%d-%m-%Y" (daily-get-current-files-date))
;; (ts-format "%d-%m-%Y" (ts-dec 'day 1 (daily-get-current-files-date)))

(defvar my-daily-folder "~/notes/daily/" "Where is the folder where I store my jounals?")
(defun daily-find-file-name (date)
  ()
  "Uses the bash find command to find a file that matches a given date.
   Date must be in the format \"%Y-%m-%d\".
   Returns nil if no file was found"
  (shell-command (concat "find " my-daily-folder "/" date "* | grep \"\\.org$\""))
  (if (with-current-buffer shell-command-buffer-name
	(= (point-max) 1))
      nil
    (let ((file-name (with-current-buffer shell-command-buffer-name
		       (buffer-substring (point-min) (- (point-max) 1)))))
      (if (string= (car (s-split "\s" file-name)) "find:")
	  nil
	file-name))))

;; Todays file functionality
(setq brnm-daily-mode-map (make-sparse-keymap))
(with-eval-after-load 'evil
  (define-key brnm-daily-mode-map (kbd "M-n") #'daily-find-next-note)
  (define-key brnm-daily-mode-map (kbd "M-p") #'daily-find-previous-note))
(define-minor-mode brnm-daily-mode
  "Defines a keymap for interacting and modifying pdf hyperlinks with simple commands.")


(defun my-find-daily-file ()
  "Gets today's date using shell's date command,
     getting shell's output buffers content,
     and find a file with <todays-date>.org,
     in folder <my-daily-folder>"
  (interactive)
  (let*
      ((today-date (ts-format "%d-%m-%Y" (ts-now)))
       (file-name (daily-find-file-name today-date)))
    (if (not file-name) ;; Não encontrou arquivo nenhum
	(setq file-name (concat my-daily-folder "/" today-date ".org")))
    (find-file file-name)
    (brnm-daily-mode 1)))
(defalias 'mfdf 'my-find-daily-file)

;; movement
(defun daily-find-previous-note ()
  (interactive)
  (let ((current-note-date (daily-get-current-files-date)) ;; a ts object
	(previous-note-name nil)
	(count-previous 1))                            ;; will increase to search notes further back
    (while (and (not previous-note-name) (< count-previous 1000))
      (setq previous-note-name (daily-find-file-name
				(ts-format "%d-%m-%Y"
					   (ts-dec 'day count-previous current-note-date))))
      (setq count-previous (+ 1 count-previous)))
    (if previous-note-name
	(find-file previous-note-name)
      (message "No previous note"))
    (brnm-daily-mode 1)))

(defun daily-find-next-note ()
  (interactive)
  (let ((current-note-date (daily-get-current-files-date)) ;; a ts object
	(next-note-name nil)
	(count-next 1))  
    (while (and (not next-note-name) (< count-next 1000))
      (setq next-note-name (daily-find-file-name
				(ts-format "%d-%m-%Y"
					   (ts-inc 'day count-next current-note-date))))
      (setq count-next (+ 1 count-next)))
    (if next-note-name
	(find-file next-note-name)
      (message "No next note"))
    (brnm-daily-mode 1)))
