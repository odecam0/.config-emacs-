;; ( This is making inpossible to save buffer when it has the overlays
;; ( on...
;; This should be made toggleble
;; make search-forward skip invisible overlay text
(defun brnm-make-skip-invisible (&rest r)
  ()
  (if (not (string-equal (substring (car r) 0 1) "("))
      (while (invisible-p (point))
	(apply 'search-forward r))))
(advice-add 'search-forward :after 'brnm-make-skip-invisible)
;; (advice-remove 'search-forward 'brnm-make-skip-invisible)


(advice-add 'ee-goto-position :before '_mc-turn-on-overlays)
(advice-add 'find-fline :after '_mc-turn-off-overlays)
;;(advice-remove 'ee-goto-position '_mc-turn-on-overlays)
;;(advice-remove 'find-fline '_mc-turn-off-overlays)
