;; I want this function to find the file with the correct date, but it could also
;; have another metadata on the name, separated by ~. Like this: 04-11-2023~blah~bleh~bluh.org
;;  1. List files names.
;;  1. Find file name matching regexp.

;; Todays file functionality
(defvar my-daily-folder "~/daily/" "Where is the folder where I store my jounals?")
(defun my-find-daily-file ()
  "Gets today's date using shell's date command,
     getting shell's output buffers content,
     and find a file with <todays-date>.org,
     in folder <my-daily-folder>"
  (interactive)
  (let*
      ((today-date
	(progn
	  (shell-command "date '+%d-%m-%Y'")
	  (with-current-buffer shell-command-buffer-name
	    (buffer-substring (point-min) (- (point-max) 1)))))
       (file-name
	(progn
	  (shell-command (concat "find " my-daily-folder "/" today-date "* | grep \"\\.org$\""))
	  (with-current-buffer shell-command-buffer-name
	    (buffer-substring (point-min) (- (point-max) 1))))))
					; \_. to remove \n
    (if (string= (car (s-split "\s" file-name)) "find:") ;; Não encontrou arquivo nenhum
	(setq file-name (concat my-daily-folder "/" today-date ".org")))
    (find-file file-name)))
(defalias 'mfdf 'my-find-daily-file)
