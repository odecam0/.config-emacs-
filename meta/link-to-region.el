;; ( Oque falta nessa funcionalidade?

;; ( O objetivo é ter um arquivo meta que me ajuda a agrupar coisas que estão relacionadas.

;; ( Gostaria que fosse possivel determinar comandos para cada arquivo do código fonte, sem que,
;; ( ao acessar o link, fosse para um local predeterminado do buffer.

;; ( O objetivo também é ser possivel criar um arquivo com código letrado, se aproveitando das
;; ( regiões que são definidas pelos links para regiões, e criando links reais para as regiões no
;; ( código fonte, de forma que mostre o contexto daquele código fonte.

;; (  Nesta questão aqui haverão alguns desafios de design.
;; (  O link deve ser feito para o código fonte que não está com os meta comentários.
;; (  Este link pode ser recuperado utilizando o .meta-sync-log-file algo assim..
;; (find-metafile "parallel-commit.el" "defvar _mc-sync-log-file-name" '(mp 3))

(defun mark-paragraph-to-next-double-blank-line (&optional number)
  (interactive "P")
  (mark-paragraph)
  (forward-char)
  (exchange-point-and-mark)
  (search-forward "\n\n\n" nil t number)
  (goto-char (match-beginning 0))
  (exchange-point-and-mark)
  (beginning-of-line))

;; (mus "exchange")
(defun mark-until-search (search)
  (interactive "Msearch:")
  (beginning-of-line)
  (push-mark)
  (forward-line)
  (search-forward search)
  (end-of-line)
  (exchange-point-and-mark))

(defun mark-line ()
  (interactive)
  (end-of-line)
  (push-mark)
  (beginning-of-line)
  (activate-mark))

(defalias 'mpdbl 'mark-paragraph-to-next-double-blank-line)
(defalias 'mp    'mark-paragraph)
(defalias 'mus   'mark-until-search)
(defalias 'ml    'mark-line)

(advice-add 'mark-paragraph :after (lambda (&rest r) (goto-char (+ (point) 1)) '((name "test"))))
