;; ( This code is faulty, when I set the center thing in a buffer and change
;; ( to another buffer wich is also centered, the centering parameters such as
;; ( margin size are of the previous centered buffer.. These are not being buffer
;; ( local.

(straight-use-package 'olivetti)
(require 'olivetti)
(straight-use-package 'hide-mode-line)

(defun brnm--find-max-column () ()
       "Vai de linha em linha pelo buffer, mantendo o valor da
	  maior linha na variável brnm-column-max"
       (save-excursion
	 (goto-char (point-min))
	 (setq brnm-column-max 0)
	 (while (not (eobp))
	   (end-of-line)
	   (setq brnm-column-max (max brnm-column-max
				      (current-column)))
	   (forward-line 1)))
       brnm-column-max)

(defun brnm--center-text-horizontally (&rest r) ()
       "Seta o olivetti-body-width como um pouco maior que
	  a maior linha do buffer"
       (setq-default olivetti-body-width
		     (+ (brnm--find-max-column) 2)))

(defun brnm--last-line () ()
       "Retorna quantas linhas estão vizíveis, a altura"
       (save-excursion (goto-char (point-max)) (evil-ex-current-line)))
(defun brnm--count-lines () ()
       "Retorna quanto de espaço branco deve ser adcionado no inicio"
       (max 0
	    (/ (- (window-height) (brnm--last-line)) 2)))

(defvar-local brnm-center-overlay nil "")
(make-variable-buffer-local 'brnm-center-overlay)

(defun brnm-overlay-center-vertically () (interactive)
       "Função que cria o overlay com os espaços em branco.
	  Caso já esteja no modo olivetti, remove o overlay.
	  Caso contrário, cria o overlay no buffer inteiro, e adcionar linhas vazias
	  no inicio do overlay, utilizando brnm--count-lines"
       (if olivetti-mode		;
	   (delete-overlay brnm-center-overlay)
	 (setq brnm-center-overlay (make-overlay (point-min) (point-max) (current-buffer)))
	 (overlay-put brnm-center-overlay 'before-string (make-string (brnm--count-lines) ?\n))))

(defvar-local brnm-stuff-centered nil "")
(make-variable-buffer-local 'brnm-stuff-centered)
(defun brnm-center-stuff () (interactive)
       (brnm-overlay-center-vertically)
       (if brnm-stuff-centered
	   (progn
	     (olivetti-mode 0)
	     (setq brnm-stuff-centered nil))
	 (brnm--center-text-horizontally)
	 (olivetti-mode 1)
	 (setq brnm-stuff-centered t)))
