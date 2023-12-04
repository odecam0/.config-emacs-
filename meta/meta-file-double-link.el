;; (find-dailyfile "29-11-2023.org" "I have a meta file.")
;; ( É sobre criar uma função que cria o link entre um arquivo que contém meta
;; ( contéudo e links com uma posição num arquivo atual.

;; ( Função cria arquivo perguntando nome pro usuário. Será nome do arquivo meta.
;; ( e define arquivo como meta-arquivo atual.
;; ( Função colocar link para meta-arquivo atual perguntando nome para ser usado no link.
;;
(load "parallel-commit")

(defun mc-create-meta-file (file-name)
  (interactive "MThe file's name:")
  ""
  (let ((file-full-path (concat (_mc-get-git-root-dir) "meta/" file-name ".el")))
    (setq _mc-current-meta-file file-full-path)
    (find-file file-full-path)))

(defun mc-set-current-buffer-as-meta-file ()
  (interactive)
  (setq _mc-current-meta-file (buffer-file-name)))

;; ( Enquanto eu estiver em um projeto, find-mfile deve apontar para a pasta correta.
(defun _mc-associate-m-code-cd ()
  (interactive)
  ""
  (eval (read (ee-template00 "(code-c-d \"m\" \"{(f-dirname _mc-current-meta-file)}/\")"))))
;; ( Esta função deve ser chamada após a variável _mc-current-meta-file estar definida

(advice-add 'mc-set-current-buffer-as-meta-file :after #'_mc-associate-m-code-cd)

(defun mc-create-double-link (link-name)
  (interactive "MThe link's name")
  ""
  (insert (concat "(find-mfile \"" (f-filename _mc-current-meta-file) "\" \"" link-name "\")"))
  (beginning-of-line)
  (push-mark)
  (end-of-line)
  (eeklfs)
  (save-window-excursion
    (find-file _mc-current-meta-file)
    (goto-char (point-max))
    (yank)
    (save-buffer)
    (close-buffer)))

(defun mc-meta-file-follow-link (num)
  (interactive "P")
  (if num
      (let (paragraph-num link-num link)
	(if (< num 100)
	    (progn
	      (setq paragraph-num num)
	      (setq link-num 0))
	  (setq paragraph-num (/ num 100))
	  (setq link-num (mod num 100)))

	(find-file _mc-current-meta-file)
	(goto-char (point-min))

	(search-forward "\n\n\n" nil nil (- paragraph-num 1))
	(search-forward-regexp "^(" nil nil (+ link-num 1))

	(setq link (buffer-substring-no-properties (line-beginning-position) (line-end-position)))

	(save-buffer)
	(kill-buffer)

	(eval (read link)))
    (find-file _mc-current-meta-file)))

(evil-define-key '(normal insert replace visual) global-map (kbd "M-L") #'mc-meta-file-follow-link)

(defun mc-goto-meta-folder ()
  (interactive)
  (find-file (concat (_mc-get-git-root-dir) "meta/")))
    
