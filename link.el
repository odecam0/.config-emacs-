;; Link file functionality
(defvar brnm-save-link-file "Path to file where links will be saved automatically")
(defvar brnm-save-automaticallyp "Wether it is to save links automatically or not")

(setq brnm-save-link-file "~/links.el")
(setq brnm-save-automaticallyp t)

(defun brnm-toggle-this-as-link-save-file () (interactive)
       (if (eq (current-buffer) (get-file-buffer brnm-save-link-file))
	   (setq brnm-save-link-file "~/links.el")
	 (setq brnm-save-link-file (buffer-file-name (current-buffer)))))
(defalias 'bttalsf 'brnm-toggle-this-as-link-save-file)

(defun brnm-paste-link-in-save-file () ()
       "Supposed to be used as an advice to a function
          that generates a link. Goes to a desired place and
          paste the link in the last line."
       (if brnm-save-automaticallyp
  	 (save-window-excursion
  	   (save-excursion
  	     (find-file brnm-save-link-file)
  	     (goto-char (point-max))
  	     (yank)
  	     (save-buffer)
	     (kill-buffer)))))

(advice-add 'eeklf :after 'brnm-paste-link-in-save-file)
(advice-add 'eeklfs :after 'brnm-paste-link-in-save-file)

(defun brnm-toggle-auto-link-save ()
  (interactive)
  "Toggle wether should save automatically links copied throwgh
     eeklf and eeklfs"
  (setq brnm-save-automaticallyp (not brnm-save-automaticallyp))
  (if brnm-save-automaticallyp
      (message "Turned on")
    (message "Turned off")))
(defalias 'tals 'brnm-toggle-auto-link-save)

(defun brnm-toggle-link-buffer ()
  (interactive)
  "Toggle buffer where links are stored"
  (let ((link-file-buffer (get-file-buffer brnm-save-link-file)))
    (if (eq link-file-buffer (current-buffer))
        (winner-undo)
      (find-file brnm-save-link-file))))

(defun brnm-save-line-link () (interactive)
       (save-excursion
	 (end-of-line)
	 (push-mark)
	 (beginning-of-line)
	 (activate-mark)
	 (eeklfs)
	 (deactivate-mark)))
(defalias 'bsll 'brnm-save-line-link)

(defun brnm-run-link (arg)
  (interactive "P")
  "Run the link on nth line in link file"
  (find-file brnm-save-link-file)
  (if (>= arg 100)
      (progn (goto-char (point-max)) (previous-line (+ (% arg 100) 1)) (ee-eval-sexp-eol))
    (goto-char (point-min))
    (forward-line (- arg 1))
    (ee-eval-sexp-eol)))
