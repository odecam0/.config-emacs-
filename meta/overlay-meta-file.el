;;  «.activate_meta_file»	(to "activate_meta_file")
;;  «.insert_position»	        (to "insert_position")
;;  «.walk-through-buffer»	(to "walk-through-buffer")
;;  «.overlays»	                (to "overlays")
;;  «.group-cicle»	        (to "group-cicle")
;;  «.color-things»	        (to "color-things")

;; (find-dailyfile "16-02-2024.org")

;; I need a way to have different behaviour when pressing a key stroke multiple times, and when pressing
;; it for the first time. The first time the 'follow link functionality' is called, it should go to a link
;; on a group, based on its prefix argument. When called repeatedly after that, it should cicle  trough the
;; groups links.
;; 
;; (find-node "(elisp)Keymaps")

;; A function that inserts the current link in the right place based on the prefix number passed when calling
;; it with the region active over somewhere.

;; Also a global file that holds sexps that loads and open meta files.
;; This global file could be grouped the same way, and accessed the same way.
;; In this way, there is a tree like structure to accessing every point of the computer, with context.

;; (find-dailyfile "28-02-2024~link-position-code.org")
;; (find-dailycaps "16-02-2024.org" "ideia sobre como navegar o computador")

(load "meta-file-double-link")

(defvar brnm-index-to-meta-files-file nil
  "Path to file that holds links to meta-files across the system.")
(setq brnm-index-to-meta-files-file "~/index_to_meta_files.el")

;; «activate_meta_file»  (to ".activate_meta_file")

(defun brnm-activate-meta-file (num)
  (interactive "P")
  "Acess the n'th sexp in the file held by brnm-index-to-meta-files-file variable,
   and sets it as the current meta-file.
  (find-evariable '_mc-current-meta-file)
  "
  (if (not num)
      (find-file brnm-index-to-meta-files-file)
    (save-window-excursion
      (mc-meta-file-follow-link-generic num brnm-index-to-meta-files-file)
      (mc-set-current-buffer-as-meta-file "")
      )))

;; (eek "C-u 1 M-x brnm-activate-meta-file RET")
;; (eek "C-h v _mc-current-meta-file")
;; (eek "C-u 2 M-x brnm-activate-meta-file RET")
;; (eek "C-h v _mc-current-meta-file")

(define-key global-map (kbd "M-a") #'brnm-activate-meta-file)

(defun brnm-add-meta-file-to-index ()
  (interactive)
  (save-window-excursion
    (save-excursion
      (eeklf)
      (find-file brnm-index-to-meta-files-file)
      (goto-char (point-max))
      (insert "\n\n\n")
      (yank))))

(defalias 'bamt 'brnm-activate-meta-file)

;; (find-efunction 'mc-meta-file-follow-link)
;; (find-efunction 'mc-meta-file-follow-link-generic)



;; (find-metafile "meta-file-double-link.el" "defun brnm-find-element-in-nth-paragraph")
;; (find-metadefun "meta-file-double-link.el" "brnm-find-element-in-nth-paragraph")



;; «insert_position»  (to ".insert_position")
;; INSERt LINK IN RIGHT POSITION

(defun brnm-insert-string-in-nth-position (num string)
  (interactive "P")
  (save-excursion
    (save-window-excursion
      (if (not num)
	  (progn
	    (goto-char (point-max))
	    (search-backward-regexp "." nil 1)
	    (forward-char 1)
	    (insert (concat "\n" string)))
      (brnm-find-element-in-nth-paragraph num "^(")
      ;; (find-efunction 'brnm-find-element-in-nth-paragraph)
      (backward-char 1)
      (insert string)))))

;; test:
(defun tt (num)
  (interactive "P")
  (find-wset "13o__o"
  '(find-file _mc-current-meta-file)
  '(brnm-insert-string-in-nth-position num (concat "(message \"TESTE" (number-to-string num) "\")"))))

(defun brnm-insert-link-in-position-in-meta-file (num)
  (interactive "P")
  (if mark-active
      (eeklfs)
    (eeklf))
  (save-window-excursion
    (find-file _mc-current-meta-file)
    (brnm-insert-string-in-nth-position num
					(substring-no-properties (car kill-ring)))))

(define-key global-map (kbd "M-s") #'brnm-insert-link-in-position-in-meta-file)


;; «walk-through-buffer»  (to ".walk-through-buffer")
(defun brnm-get-regexp-positions-numbered (regexp)
  ()
  "Returns the positions of the matches of regexp in the current buffer.
   The position returned are structured as in:
         (find-efunction 'mc-meta-file-follow-link-generic)
  "
  (let ((break-parag-pos t) (regexp-pos t)
	(group-num 1)   (num 0)
	(anchor (point-min))
	(return-value nil)
	(count 1))

    (while (and (or break-parag-pos regexp-pos) (< count 100))
      (setq count (+ 1 count))
      (if (search-forward "\n\n\n" nil t)
	  (setq break-parag-pos `(,(match-beginning 0) . ,(match-end 0)))
	(setq break-parag-pos nil))

      (goto-char anchor) ;; taking care, for we dont know wich happens first
      (if (search-forward-regexp regexp nil t)
	  (setq regexp-pos `(,(match-beginning 0) . ,(match-end 0)))
	(setq regexp-pos nil))

      (if (and break-parag-pos regexp-pos)
	  (if (< (car break-parag-pos) (car regexp-pos))
	      (progn
		(setq group-num (+ 1 group-num))
		(setq       num              0)
		(setq anchor    (cdr break-parag-pos))
		)
	    (setq return-value (cons `(,(substring-no-properties (match-string 0)) .
				       ,(+ (* 100 group-num) num)                    )
				     return-value))
	    (setq num (+ 1 num))
	    (setq anchor (cdr regexp-pos))
	    )))

    ;; (message (prin1-to-string return-value))
    return-value
    ))

;; (eek "C-u 1 M-x brnm-activate-meta-file RET")
;; (find-wset "13o___o" '(find-file _mc-current-m\\eta-file) '(brnm-get-regexp-positions-numbered "^(.+)") '(find-ebuffer "*Messages*"))


;; EXAMPLE: return-value
;; 
;;     (("(find-crmfscfile \"kambam.js\" \"function getCardsFromObjectList(\")" . 502)
;;      ("(find-crmfscfile \"kambam.js\" 0 ’(swiper \"console.log\"))" . 501)
;;      ("(find-crmfscfile \"kambam.js\" \"export default function Kambam\")" . 500)
;;      ("(find-crmfscfile \"kambam.js\" 0 ’(swiper \"getObjectsFromColumnId(\"))" . 404)
;;      ("(find-crmfscfile \"kambam.js\" 0 ’(swiper \"getCardsFromObjectList(\"))" . 403)
;;      ("(find-crmfscfile \"kambam.js\" \"id={\\\"card\\\" + x._id}\")" . 402)
;;      ("(find-crmfscfile \"kambam.js\" \"const [activeID, setActiveID]\")" . 401)
;;      ("(find-crmfscfile \"kambam.js\" 0 ’(swiper \"activeID\"))" . 400)
;;      ("(message \"not yet\")" . 300)
;;      ("(find-crmfscfile \"kambam.js\" \"’data’: {’columnID’: columnID}\")" . 200)
;;      ("(message \"not yet\")" . 101) ("(message \"TESTE1\")" . 100))


;; «overlays»                                   (to ".overlays")
;; (brnm-get-regexp-positions-numbered "^(.+)")

(defun brnm-put-overlay-trough-sexp-and-number-position (sexp-number)
  ()
  (save-excursion
    (save-window-excursion
      (let ((overlay-list nil) ovl color)
	(eval (read (car sexp-number)))
	(setq        ovl (make-overlay (match-beginning 0) (match-end 0)))

	(setq color (nth (- (mod (/ (cdr sexp-number) 100) (list-length brnm-color-sequence)) 1) brnm-color-sequence))
	(message color)

	(overlay-put ovl 'after-string (propertize (concat " [" (number-to-string (cdr sexp-number)) "]") 'face `(:height 0.7 :underline ,color))) ;; :background color
	(overlay-put ovl 'face `(:underline ,color))
	ovl
	)))
  )

;; (brnm-put-overlay-trough-sexp-and-number-position '("(find-crmfscfile \"kambam.js\" \"function getCardsFromObjectList(\")" . 502))
;; (find-2a nil '(find-crmfscfile "kambam.js" "function getCardsFromObjectList("))

(defun brnm-iterate-over-list-of-sexps-with-number-position (list)
  ()
  (mapcar #'brnm-put-overlay-trough-sexp-and-number-position list))

;; (brnm-get-regexp-positions-numbered "^(.+)")
;; (eek "C-u 2 M-x brnm-activate-meta-file RET")
;; (brnm-iterate-over-list-of-sexps-with-number-position (progn (find-file _mc-current-meta-file) (brnm-get-regexp-positions-numbered "^(.+)")))
;; (debug-on-entry #'brnm-iterate-over-list-of-sexps-with-number-position)
;; (cancel-debug-on-entry #'brnm-iterate-over-list-of-sexps-with-number-position)
;; (find-file _mc-current-meta-file)

(defun brnm-helpfull-overlays ()
  (interactive)
  (save-window-excursion
    (save-excursion
      (brnm-iterate-over-list-of-sexps-with-number-position
       (progn
	 (find-file _mc-current-meta-file)
	 (brnm-get-regexp-positions-numbered "^(.+)"))))))
(define-key global-map (kbd "M-d") #'brnm-helpfull-overlays)

;;              OVERLAYS
(defun tt ()
  (interactive)
  (let (ovl)
    (setq ovl (make-overlay 0 100))
    (overlay-put ovl 'after-string (propertize " [101]" 'face '(:height 0.7 :underline "red")))
    (overlay-put ovl 'face '(:underline "red")))
  )

;; (remove-overlays)

;;          (find-node "(elisp)Overlays")
;; (find-node "(elisp)Managing Overlays" "Function: make-overlay")
;;          (find-node "(elisp)Overlay Properties")
;;          (find-node "(elisp)Overlay Properties" "Function: overlay-put")
;;          (find-node "(elisp)Overlay Properties" "\n‘face’")
;;          (find-node "(elisp)Overlay Properties" "‘after-string’")

;; (find-node "(elisp)Faces")
;; (find-node "(elisp)Faces" "property list of attributes")

;; (find-node "(elisp)Changing Properties" "Function: put-text-property")


; «group-cicle»  (to ".group-cicle")
; (find-dailyfile "03-03-2024.org")

(defun brnm-cycle-meta-groups-links ()
  (interactive)
  "Will cicle through all the links, executing them, in a group in the meta file."
  (find-file _mc-current-meta-file)
  (let (original-pos group-separator-pos link-position)
    (setq original-pos (point))
    (if (search-forward "\n\n\n" nil t)
	(setq group-separator-pos (match-beginning 0))
      (setq group-separator-pos (- (point-max) 1)))
    (goto-char original-pos)
    (if (search-forward-regexp "^(.+)" nil t)
	(setq link-position (match-end 0))
      (setq link-position (point-max)))
    (goto-char original-pos)

    (if (> link-position group-separator-pos)
	(search-backward "\n\n\n" nil 1))

    (search-forward-regexp "^(.+)" nil t)
    (eval (read (match-string 0))
	  )))


(define-key global-map (kbd "M-f") #'brnm-cycle-meta-groups-links)
(define-key eev-mode-map (kbd "M-D") nil)
(defun brnm-remove-overlays () (interactive) (remove-overlays))
(define-key global-map (kbd "M-D") #'brnm-remove-overlays)

;; «color-things»  (to ".color-things")

(defvar brnm-color-sequence nil
  "Defines the cicle of colors to be used for each group in the meta overlay functionality")
(setq brnm-color-sequence '("red" "blue" "green" "yellow" "gray" "purple" "orange" "brown" "pink"))
;; (find-meta "overlay-meta-file.el" "overlays")
;; (find-meta "overlay-meta-file.el" "overlays" "setq color")
;; (find-meta "overlay-meta-file.el" "overlays" "(cdr sexp-number)")
