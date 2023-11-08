(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("dc8285f7f4d86c0aebf1ea4b448842a6868553eded6f71d1de52f3dcbc960039" "dbade2e946597b9cda3e61978b5fcc14fa3afa2d3c4391d477bdaeff8f5638c5" "801a567c87755fe65d0484cb2bded31a4c5bb24fd1fe0ed11e6c02254017acb2" default))
 '(safe-local-variable-values
   '((ee-preferred-c . "crmb")
     (modes fundamental-mode lua-mode c-mode)
     (ee-preferred-c . "ssplua")
     (ee-preferred-c . "meta")
     (ee-preferred-c . "crmfsc")
     (ee-preferred-c . "crmfs")
     (ee-preferred-c . "tccsuci")
     (ee-preferred-c . "tccdalstm")
     (ee-preferred-c . "tccs")
     (ee-preferred-c . "crm")
     (ee-preferred-c . "~")
     (ee-preferred-c . "itbid")
     (ee-preferred-c . "twexp")
     (ee-preferred-c . "tcc")
     (ee-preferred-c . "jwl")
     (ee-preferred-c . "fcldd")
     (ee-preferred-c . "daily")
     (ee-preferred-c . "xgpt")
     (ee-preferred-c . "gatts")
     (ee-preferred-c . "scrd"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(set-frame-font "Iosevka 10" nil t)

;; https://github.com/radian-software/straight.el#getting-started
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq package-enable-at-startup nil)

;; https://github.com/radian-software/straight.el#install-packages

(add-to-list 'load-path default-directory)

(straight-use-package 'EXWM)
(straight-use-package 'xelb)
(load "exwm-config")
; (find-fline "./exwm-config.el")

(straight-use-package 'tao-theme)
(setq tao-theme-use-boxes nil)
(setq tao-theme-use-sepia nil)
(setq tao-theme-use-height nil)
(load-theme 'tao-yin)
;; (face-attribute 'font-lock-function-name-face :weight)
(set-face-attribute 'font-lock-function-name-face nil :weight 'bold)

(straight-use-package 'eev)
(require 'eev-load)
(eev-mode 1)

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

(code-c-d "tccsuci" "~/ic/src/split_loso_uci_har/")
(code-c-d "~" "~/")
(code-c-d "itbid" "~/itbi-dashboard2/")
(code-c-d "jwl" "~/jewels/")
(code-c-d "daily" "~/daily/")
(code-c-d "dnl" "~/faculdade/aula-danilo")
(code-c-d "fcldd" "~/faculdade/")
(code-c-d "xgpt" "~/xatgepete/")
(code-c-d "quave" "~/clones/quave-code-challenge-odecam0/")
(code-c-d "psdl" "~/clones/Projeto-sdl/")
(code-c-d "tcc" "~/ic/")
(code-c-d "scrd" "~/clones/desafio-thummi/")
(code-c-d "gatts" "~/tutorial-site/")
(code-c-d "crm" "~/crm-bernardo")
(code-c-d "tccs" "~/ic/src")
(code-c-d "tccdalstm" "~/ic/src/lstm_time_warping/")
(code-c-d "meta" "/home/brnm/meta-package/")
(code-c-d "crmfs" "/home/brnm/chronos-crm/chronos-front/src/")
(code-c-d "crmfsc" "/home/brnm/chronos-crm/chronos-front/src/components/")
(code-c-d "ssplua" "~/subset_sum_problem_LUA/")
(code-c-d "crmb" "~/chronos-crm/flaskr/")

(straight-use-package 'swiper)

; Mini-buffer completion
(straight-use-package 'orderless)
(straight-use-package 'selectrum)
(straight-use-package 'marginalia)
(require 'orderless)
(add-to-list 'orderless-matching-styles 'orderless-prefixes)
(require 'selectrum)
(selectrum-mode 1)
(setq selectrum-refine-candidates-function #'orderless-filter)
(setq selectrum-highlight-candidates-function #'orderless-highlight-matches)
(require 'marginalia)
(marginalia-mode)

;; Evil and keybinds config
(straight-use-package 'evil)
; (find-fline "./evil-and-keybinds-config.el")
(load "evil-and-keybinds-config")

; LSP-MODE
(straight-use-package 'lsp-mode)
(require 'lsp-mode)
; Javascript-Typescript
; https://emacs-lsp.github.io/lsp-mode/page/lsp-typescript/
; npm install -g typescript-language-server typescript
(straight-use-package 'origami)
(require 'origami)
(straight-use-package 'company)
(require 'company)
; company-backends
; https://github.com/tigersoldier/company-lsp
(straight-use-package 'company-lsp)
(require 'company-lsp)
(setq company-backends '(company-lsp))
(straight-use-package 'yasnippet)
(require 'yasnippet)

(straight-use-package 'vterm)
(require 'vterm)
(put 'narrow-to-region 'disabled nil)

(straight-use-package 'pdf-tools)
(require 'pdf-tools)
(pdf-tools-install)

(setq org-hide-emphasis-markers t)


;; I want this function to find the file with the correct date, but it could also
;; have another metadata on hte name, separated by ~. Like this: 04-11-2023~blah~bleh~bluh.org
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

(defvar brnm-center-overlay)
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

(defvar brnm-stuff-centered)
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

(straight-use-package 'org-transclusion)

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
  	     (save-buffer)))))

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

;; (shell-command "xrandr --output HDMI1 --rotate right; xrandr --output HDMI1 --auto")

(straight-use-package 'elpy)
(elpy-enable)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))

(straight-use-package 'evil-mc)
(global-evil-mc-mode 1)

(defun brnm-toggle-hide-emphasis-markers () (interactive)
       (if org-hide-emphasis-markers
	   (setq org-hide-emphasis-markers nil)
	 (setq org-hide-emphasis-markers t))
       (org-mode-restart))
(defalias 'bthem 'brnm-toggle-hide-emphasis-markers)

; Define oque esconder quando se utiliza o dired
(with-eval-after-load 'dired
  (require 'dired-x)
  (setq dired-omit-files "\\`[.]?#\\|\\`[.][.]?\\'\\|^\\.\\|^_"))
(add-hook 'dired-mode-hook
 (lambda () (dired-omit-mode 1) ))

;; (replace-regexp "^\"\"\"\n\\(.*\n\\)+?\"\"\"" "")
;; (replace-regexp "^\s*#\s*(.*" "")

(straight-use-package 'minimap)
(with-eval-after-load 'minimap
  ;; (set-face-attribute 'minimap-font-face nil :height 30)
  (set-face-background 'minimap-active-region-background "gray15") 
  (set-face-attribute 'minimap-font-face nil :height 15))

(load "meta/overlay-hide.el")
(load "meta/new.el")
(load "meta/sepia-fontlock.el")
(load "meta/intra-search.el")
;; (find-fline "./meta/")

(defun brnm-create-local-variable-for-eev (name)
  (interactive "sQual o nome pra essa pasta?")
  "This function create a local dir variable for automatic eev codecd'ing"
  (shell-command
   (concat "echo \"((nil . ((ee-preferred-c . \\\""
	   name
	   "\\\"))))\" >> .dir-locals.el"))
  (let ((my-code-cd (ee-wrap-code-c-d name default-directory)))
    (ee-eval-string my-code-cd)
    (kill-new my-code-cd)))

;; Para que os hyperlinks sejam case sensitive
(setq-default case-fold-search nil)

(straight-use-package 'crdt)
(setq crdt-use-tuntox t)
(setq crdt-tuntox-executable "/usr/bin/tuntox")

(straight-use-package 'lua-mode)

(defun brnm-toggle-vterm-buffer () (interactive)
       (if (string= "*vterm*" (buffer-name (current-buffer)))
	   (winner-undo)
	 (vterm)))

(straight-use-package 'glsl-mode)

(straight-use-package 'rg)


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
