; (find-dailycaps "10-01-2024.org" "isto aqui seria um anchor")
(defun ee-code-c-d-:caps (c d &rest rest)
  (concat (ee-template0 "
    (defun find-{c}caps (str &rest pos-spec-list)
    (interactive (list \"\"))
    (apply 'find-fline (ee-{c}file str) (cons (upcase (car pos-spec-list)) (cdr pos-spec-list))))
") (ee-code-c-d-rest c d rest)))

;; (find-eevfile "eev-code.el" "(defun ee-code-c-d-base (c d)")
(defun ee-code-c-d-base (c d)
  (ee-template0 "\
   ;; {(ee-S `(find-code-c-d ,c ,d ,@rest))} 
   ;; {(ee-S `(ee-code-c-d-base ,c ,d))} 
   ;; See: (find-eev-quick-intro \"9.1. `code-c-d'\")
   ;;      (find-elisp-intro \"5. Variables\")
   ;;      (find-elisp-intro \"5. Variables\" \"setq\")
   ;;      (find-elisp-intro \"6. Defining functions\")
   ;;      (find-elisp-intro \"6. Defining functions\" \"defun\")
   ;;      (find-elisp-intro \"11. Byte-compiled functions\")
   ;;      (eek \"M-h M-f  apply\")
   ;;      (eek \"M-h M-f  interactive\")
   ;;
   (setq ee-{c}dir \"{d}\")
   (defun ee-{c}file (str)
     (concat (ee-expand ee-{c}dir) str))
   (defun find-{c}file (str &rest pos-spec-list)
     (interactive \"s\") ;; Modifiquei essa linha para conseguir acessar arquivo iterativamente
     (apply 'find-fline (ee-{c}file str) pos-spec-list))
   (defun find-{c}sh (command &rest pos-spec-list)
     (apply 'find-sh-at-dir ee-{c}dir command pos-spec-list))
   (defun find-{c}sh0 (command)
     (funcall 'ee-find-xxxsh0 ee-{c}dir command))
   (defun find-{c}sh00 (command)
     (funcall 'ee-find-xxxsh00 ee-{c}dir command))
   (defun find-{c}grep (grep-command-args &rest pos-spec-list)
     (apply 'ee-find-grep ee-{c}dir grep-command-args pos-spec-list))
     "))



(code-c-d "~" "~/" :caps)
(code-c-d "notes" "~/notes/" :caps)
(code-c-d "daily" "~/notes/daily/" :caps)


(code-c-d "p" "~/p/")
(code-c-d "tccsuci" "~/p/ic/src/split_loso_uci_har/" :caps)

(code-c-d "tcc" "~/p/ic/" :caps)
(code-c-d "tccs" "~/p/ic/src/" :caps)
(code-c-d "tccdalstm" "~/p/ic/src/lstm_time_warping/" :caps)

(code-c-d "pdfc" "~/p/pdf-contabilidade/" :caps)
(code-c-d "glsl" "~/p/glsl/" :caps)

(code-c-d "crm" "~/p/chronos-crm/" :caps)
(code-c-d "crmfs" "~/p/chronos-crm/chronos-front/src/" :caps)
(code-c-d "crmfsc" "~/p/chronos-crm/chronos-front/src/components/" :caps)
(code-c-d "crmb" "~/p/chronos-crm/flaskr/" :caps)

(code-c-d "soil" "~/p/odecamsoil/" :caps)
(code-c-d "soilc" "~/p/odecamsoil/src/components/" :caps)


(code-c-d "meta" "~/.config/emacs/meta/" :caps)
(code-c-d "eevc" "~/.config/emacs/eev-custom/" :caps)
(code-c-d "config" "~/.config/emacs/" :caps)

(code-c-d "eev" "~/.emacs.d/straight/repos/eev/")
(code-c-d "cncrs" "~/p/concursos/" :anchor)
;; (find-cncrsfile "")
