;; «.pdf»	(to "pdf")




;; «pdf»  (to ".pdf")

(defun brnm-delete-first-posspec ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (search-forward "(")
    (search-forward-regexp "\\ \".+?\"")
    (delete-region (match-beginning 0) (match-end 0))))
;; (find-efunctiondescr 'delete-region)

(defun brnm-toggle-page-text ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (search-forward "(")
    (search-forward " ")
    (let ((which-hlink (buffer-substring (- (point) 5) (- (point) 1))))
      (delete-region (- (point) 5) (- (point) 1))
      (backward-char)
      (message which-hlink)
      (if (string= which-hlink "page") (insert "text"))
      (if (string= which-hlink "text") (insert "page")))))

(defun brnm-increase-page-number ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (search-forward "(")
    (search-forward " ")
    (search-forward-regexp "-?[0-9]+")
    (let (number)
      (setq number (string-to-number (match-string 0)))
      (delete-region (match-beginning 0) (match-end 0))
      (insert (number-to-string (+ 1 number))))))

(defun brnm-decrease-page-number ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (search-forward "(")
    (search-forward " ")
    (search-forward-regexp "-?[0-9]+")
    (let (number)
      (setq number (string-to-number (match-string 0)))
      (delete-region (match-beginning 0) (match-end 0))
      (insert (number-to-string (+ -1 number))))))

;; (find-node "(*Apropos*)Index for ‘emacs lisp’")
;;  (info "(elisp)Minor Modes")
;;  (find-node "(elisp)Defining Minor Modes" "Macro: define-minor-mode mode doc keyword-args... body...")
;;  (find-node "(elisp)Defining Minor Modes" ":keymap KEYMAP")

(setq page-utils-mode-map (make-sparse-keymap))

(with-eval-after-load 'evil
  (evil-define-key '(normal insert) page-utils-mode-map (kbd "M-b") #'brnm-toggle-page-text)
  (evil-define-key '(normal insert) page-utils-mode-map (kbd "M-n") #'brnm-increase-page-number)
  (evil-define-key '(normal insert) page-utils-mode-map (kbd "M-p") #'brnm-decrease-page-number)
  (evil-define-key '(normal insert) page-utils-mode-map (kbd "M-d") #'brnm-delete-first-posspec))

(define-key page-utils-mode-map (kbd "M-b") #'brnm-toggle-page-text)
(define-key page-utils-mode-map (kbd "M-n") #'brnm-increase-page-number)
(define-key page-utils-mode-map (kbd "M-p") #'brnm-decrease-page-number)
(define-key page-utils-mode-map (kbd "M-d") #'brnm-delete-first-posspec)

(define-minor-mode page-utils-mode
  "Defines a keymap for interacting and modifying pdf hyperlinks with simple commands.")

