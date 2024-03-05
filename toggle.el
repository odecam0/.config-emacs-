;; ( The idea with this one is this. There should be an abstract corpus of code
;; ( that should implement the abstract idea of toggling a buffer or a functionality.

;; ( When toggling something, first we check if there is a buffer with a given name
;; ( if there is not, we call a given function that will create that buffer. This should
;; ( be a function.

;; ( Now, I also want a functionality that exchanges a buffer name into those of the kind
;; ( Buffer Buffer<1> Buffer<2> ... etc. So that if I call a function on Buffer<1>, its name
;; ( will be Buffer, and the buffer that formerly had the name Buffer will be called Buffer<1>
;; ( Swap buffer names. 

(winner-mode 1)
;; Função que vai ou cria buffer de navegador
;; (defun toggle-chromium-buffer (arg) (interactive "P")
;;        (let ((buffer-name
;; 	      (if arg
;; 		  (concat "Chromium<" (number-to-string arg) ">")
;; 		"Chromium")))
;;        (if (string= buffer-name (buffer-name (current-buffer)))
;; 	   (winner-undo)
;; 	 (if (not (get-buffer buffer-name))
;; 	     (start-process-shell-command "chromium" nil "chromium")
;; 	   (find-ebuffer buffer-name)))))

(defun toggle-chromium-buffer (arg) (interactive "P")
       (let ((buffer-name
	      (if arg
		  (concat "firefox<" (number-to-string arg) ">")
		"firefox")))
       (if (string= buffer-name (buffer-name (current-buffer)))
	   (winner-undo)
	 (if (not (get-buffer buffer-name))
	     (start-process-shell-command "firefox" nil "firefox")
	   (find-ebuffer buffer-name))))) ;

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

;; ( Aqui haverá um esquema de abrir vterms diferentes com nomes diferentes, utilizando o prefix arg
;; ( Tendo um número como prefix-arg, irá criar, ou mudar para um *vterm<n>* named buffer.
;; ( Tendo um número negativo como prefix-arg, irá trocar o buffer *vterm* com o nome pelo *vterm<n>*
;; ( se for só o valor negativo, troca o atual pelo *vterm*
(defun brnm-toggle-vterm-buffer (arg)
  (interactive "P")
  (cond
   ((or (not arg))
    (if (string= "*vterm*" (buffer-name (current-buffer)))
	(winner-undo)
      (vterm)))
   ((> arg 0)
    (if (string= (concat "*vterm*<" (number-to-string arg) ">") (buffer-name))
	(winner-undo)
      (let ((vterm-buffer-name (concat "*vterm*<" (number-to-string arg) ">")))
	(vterm))))
   ((< arg 0)
    (brnm-exchange-n-for-vterm (* arg -1)))))

(defun brnm-exchange-n-for-vterm (n)
  ()
  "This function will exchange the names of the buffers *vterm* and *vterm<n>*"
  (save-window-excursion
    (let ((vtermn (concat "*vterm*<" (number-to-string n) ">")))
    (switch-to-buffer "*vterm*")
    (rename-buffer "*aux*")
    (switch-to-buffer vtermn)
    (rename-buffer "*vterm*")
    (switch-to-buffer "*aux*")
    (rename-buffer vtermn))))


