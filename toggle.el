(winner-mode 1)
;; Função que vai ou cria buffer de navegador
(defun toggle-chromium-buffer (arg) (interactive "P")
       (let ((buffer-name
	      (if arg
		  (concat "Chromium<" (number-to-string arg) ">")
		"Chromium")))
       (if (string= buffer-name (buffer-name (current-buffer)))
	   (winner-undo)
	 (if (not (get-buffer buffer-name))
	     (start-process-shell-command "chromium" nil "chromium")
	   (find-ebuffer buffer-name)))))

;; Aux file functionality
(defun set-this-as-aux-file () (interactive)
       (setq my-aux-buffer-name (buffer-name))
       (setq my-aux-file-path (buffer-file-name)))
(defun toggle-aux-buffer () (interactive)
       (if (string= my-aux-buffer-name (buffer-name (current-buffer)))
           (winner-undo)
         (find-file my-aux-file-path)))
(defalias 'tab 'toggle-aux-buffer)

(defvar my-index-previous-buffer)
(defun toggle-index-buffer () (interactive)
       (if (string= "index.el" (buffer-name (current-buffer)))
           (call-interactively 'ibuffer)
         (if (string= "*Ibuffer*" (buffer-name (current-buffer)))
             (find-ebuffer my-index-previous-buffer)
           (progn
             (setq my-index-previous-buffer (current-buffer))
             (find-file "~/index.el")
             ))))

(defun brnm-toggle-vterm-buffer () (interactive)
       (if (string= "*vterm*" (buffer-name (current-buffer)))
	   (winner-undo)
	 (vterm)))
