;; ( For now, when sepia is enabled, the other comments wich are not meta content
;; ( are left un modified by font-lock. Because of font-lock-keywords-only variable.
;; ( and also strings.. 

;; ( turn this variable into buffer local
(defface mc-sepia '((t :foreground "#b8a88a")) "A sepia face for mc-fontlock things")

(setq _mc-sepia-regexps '(("\"\"\"\n\\(.*\n\\)+\"\"\"" 0 'mc-sepia)
			    ("^\\(\s\\|	\\)*#+\s*(.*$" 0 'mc-sepia)
			    ("/\\*\n\\(.*\n\\)+\\*/" 0 'mc-sepia)
			    ("^\\(\s\\|	\\)*/+\s+(.*$" 0 'mc-sepia)
			    ("^\"\n\\(.*\n\\)+\"\s*" 0 'mc-sepia)
			    ("^\\(\s\\|	\\)*;+\s+(.*$" 0 'mc-sepia)))

(defun _mc-add-sepia-fontlock ()
  ()
  (setq font-lock-keywords-only t)
  (font-lock-add-keywords nil _mc-sepia-regexps)
  (font-lock-update))
;; (_mc-add-sepia-fontlock)

(defun _mc-remove-sepia-fontlock ()
  ()
  (setq font-lock-keywords-only nil)
  (font-lock-remove-keywords nil _mc-sepia-regexps)
  (font-lock-update))
;; (_mc-remove-sepia-fontlock)

(defvar-local _mc-sepiap nil "Wheter sepia highlighting for meta content is enabled")

(defun mc-toggle-sepia ()
  (interactive)
  (if _mc-sepiap
      (progn
	(setq _mc-sepiap nil)
	(_mc-remove-sepia-fontlock))
    (setq _mc-sepiap t)
    (_mc-add-sepia-fontlock)))

"
// ( bjalgjlasgjçla
"
