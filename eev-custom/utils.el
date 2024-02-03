;; «.pdf»	(to "pdf")




;; «pdf»  (to ".pdf")

(defun brnm-toggle-page-text ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (search-forward " ")
    (let ((which-hlink (buffer-substring (- (point) 5) (- (point) 1))))
      (delete-region (- (point) 5) (- (point) 1))
      (backward-char)
      (message which-hlink)
      (if (string= which-hlink "page") (insert "text"))
      (if (string= which-hlink "text") (insert "page")))))

(evil-define-key 'normal global-map (kbd "M-b") 'brnm-toggle-page-text)
