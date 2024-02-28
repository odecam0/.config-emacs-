;; (find-dailyfile "29-11-2023.org" "I have a meta file.")
;; ( É sobre criar uma função que cria o link entre um arquivo que contém meta
;; ( contéudo e links com uma posição num arquivo atual.

;; ( Função cria arquivo perguntando nome pro usuário. Será nome do arquivo meta.
;; ( e define arquivo como meta-arquivo atual.
;; ( Função colocar link para meta-arquivo atual perguntando nome para ser usado no link.
;;
(load "parallel-commit")

(defvar _mc-current-meta-file nil
  "Holds the path to the current meta-file.")

(defun mc-create-meta-file (file-name)
  (interactive "MThe file's name:")
  "Creates a file in the <git_root>/meta/ folder, and sets it as the current meta-file"
  (let ((file-full-path (concat (_mc-get-git-root-dir) "meta/" file-name ".el")))
    (setq _mc-current-meta-file file-full-path)
    (find-file file-full-path)))

;; ( Enquanto eu estiver em um projeto, find-mfile deve apontar para a pasta correta.
(defun _mc-associate-m-code-cd ()
  (interactive)
  "Associates the find-mfile function with the folder where the meta file is currently."
  (eval (read (ee-template00 "(code-c-d \"m\" \"{(f-dirname _mc-current-meta-file)}/\")"))))
;; ( Esta função deve ser chamada após a variável _mc-current-meta-file estar definida

(defun mc-set-current-buffer-as-meta-file ()
  (interactive)
  "Sets the current buffer's visited file as the meta-file.
   And associates the files directory with the find-mfile fucntion."
  (setq _mc-current-meta-file (buffer-file-name))
  (_mc-associate-m-code-cd))


(advice-add 'mc-create-meta-file :after #'mc-set-current-buffer-as-meta-file)
;; (advice-remove 'mc-create-meta-file #'mc-set-current-buffer-as-meta-file)

(defun mc-create-double-link (link-name)
  (interactive "MThe link's name")
  "Ask for a name for the link. Insert a link with that name, in the current buffer. And another
   link that points from the meta-file, to the place where this function was called."
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
    (kill-buffer)))

(defun mc-meta-file-follow-link (num)
  (interactive "P")
  "Receives a number prefix argument N. If N is less than 100, it follows the first link
   in the N'th group of links. If N is greater than 100, than the last 2 digits inform wich
   link in the group is going to be followed, and tha number to the left informs wich group.
   3 is equivalent to 300."
  (mc-meta-file-follow-link-generic num _mc-current-meta-file))

(defun mc-meta-file-follow-link-generic (num meta-file)
  (interactive "P")
  "Receives a number prefix argument N. If N is less than 100, it follows the first link
   in the N'th group of links. If N is greater than 100, than the last 2 digits inform wich
   link in the group is going to be followed, and tha number to the left informs wich group.
   3 is equivalent to 300."
  (if num
      (let (paragraph-num link-num link)
	(if (< num 100)
	    (progn
	      (setq paragraph-num num)
	      (setq link-num 0))
	  (setq paragraph-num (/ num 100))
	  (setq link-num (mod num 100)))

	(find-file meta-file)
	(kill-buffer)
	(find-file meta-file)
	(goto-char (point-min))

	(search-forward-regexp "\n\n+\n" nil nil (- paragraph-num 1))
	(search-forward-regexp "^(" nil nil (+ link-num 1))

	(setq link (buffer-substring-no-properties (line-beginning-position) (line-end-position)))

	;; (save-buffer)
	;; (kill-buffer)

	(eval (read link)))
    (find-file meta-file)))

(evil-define-key '(normal insert replace visual) global-map (kbd "M-L") #'mc-meta-file-follow-link)
