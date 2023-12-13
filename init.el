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
(load "my-exwm-config")
; (find-fline "./my-exwm-config.el")

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
(load "eev-custom/code-c-ds")
(load "eev-custom/main")
;; (find-fline "./eev-custom/code-c-ds.el")
;; (find-fline "./eev-custom/main.el")

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

(straight-use-package 'org-transclusion)

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

(straight-use-package 'crdt)
(setq crdt-use-tuntox t)
(setq crdt-tuntox-executable "/usr/bin/tuntox")

(straight-use-package 'lua-mode)

(straight-use-package 'glsl-mode)

(straight-use-package 'rg)


(add-to-list 'load-path "~/.config/emacs/meta/")
(load "overlay-hide.el")
(load "new.el")
(load "sepia-fontlock.el")
(load "intra-search.el")
(load "parallel-commit.el")
(load "meta-file-double-link.el")
(load "link-to-region.el")
;; (find-fline "./meta/")

(load "toggle")

(load "link")
;; (find-fline "link.el")

(load "daily")
;; (find-fline "daily.el")

(load "center")
;; (find-fline "center.el")


(setq org-hide-emphasis-markers t)

(straight-use-package 'git-gutter-fringe)

(straight-use-package 'counsel)

;; (find-dailyfile "10-12-2023.org" "(( FIND ATOMIC LINKS WITH REGEXP ))")
(defun atmn () (interactive) (rg "^\\(\\([[:space:]]([A-Z\-ÇÁÉÍÓÚÂÊÎÛÔÃÕ]+[[:space:]])+\\)\\)" "**" "~/daily"))
(defun actnbl () (interactive) (let ((rg-command-line-flags '("-U"))) (rg "^\\(!\\)([[:space:]][A-Z\-ÇÁÉÍÓÚÂÊÎÛÔÃÕ]+)+.?(\\(.+\\))?\\n.+" "*" "~/daily")))
