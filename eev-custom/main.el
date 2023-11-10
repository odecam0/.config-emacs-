;; Para que os hyperlinks sejam case sensitive
(setq-default case-fold-search nil)


;; Criando mais facilmente variáveis locais para que eeklf e eeklfs
;; funcionem.
(defun brnm-create-local-variable-for-eev (name)
  (interactive "sQual o nome pra essa pasta?")
  "This function create a local dir variable for automatic eev codecd'ing"
  (shell-command
   (concat "echo \"((nil . ((ee-preferred-c . \\\""
	   name
	   "\\\"))))\" >> .dir-locals.el"))
  (let ((my-code-cd (ee-wrap-code-c-d name default-directory)))
    (ee-eval-string my-code-cd)
    (kill-new my-code-cd))
  (save-window-excursion
    (find-eevcfile "code-c-ds.el" 0 '(goto-char (point-max)))
    (evil-paste-after 1)
    (save-buffer)))


;; Customizando o eejump mais facilmente
(defun brnm-create-eejump-to-string-hyperlink (number)
  (interactive "P")
  (if mark-active
      (eeklfs)
    (eeklf))
  (with-temp-buffer
    (insert (concat "(defun eejump-" (number-to-string number) " () "))
    (evil-paste-after 1)
    (insert ")")
    (ee-eval-sexp-eol)))
(defalias 'bcee 'brnm-create-eejump-to-string-hyperlink)

(defun brnm-set-default-eejump-values ()
  (interactive)
  (defun eejump-1 () (find-fline "~/.config/emacs/init.el"))
  (defun eejump-2 () (mfdf))

  (defun eejump-106 () (set-frame-font "Iosevka  6" nil t))
  (defun eejump-108 () (set-frame-font "Iosevka  8" nil t))
  (defun eejump-110 () (set-frame-font "Iosevka 10" nil t))
  (defun eejump-112 () (set-frame-font "Iosevka 12" nil t))
  (defun eejump-114 () (set-frame-font "Iosevka 14" nil t))
  (defun eejump-116 () (set-frame-font "Iosevka 16" nil t))
  (defun eejump-118 () (set-frame-font "Iosevka 18" nil t))
  (defun eejump-120 () (set-frame-font "Iosevka 20" nil t)))

(brnm-set-default-eejump-values)

(defvar brnm-eejump-save-file nil "File where config of eejump will be saved and loaded")
(setq brnm-eejump-save-file "~/eejump-save-file.el")
(defun brnm-save-current-eejump-settings ()
  (interactive)
  (save-window-excursion
   (find-eejumps)
   (let ((eejump-content (buffer-substring-no-properties (point-min) (point-max))))
     (find-file brnm-eejump-save-file)
     (erase-buffer)
     (insert eejump-content)
     (save-buffer))))

(defun brnm-load-eejump-settings-from-file ()
  (interactive)
  (load brnm-eejump-save-file))
