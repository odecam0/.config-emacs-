;; (find-dailycaps "10-01-2024.org" "preocupado codigo" "custom-eejump")
(defun find-filtered-eejumps (n &rest pos-spec-list)
  "See: (find-eev-quick-intro \"find-eejumps\")"
  (let ((ee-buffer-name "*(find-eejumps)*"))
    (apply 'find-estring-elisp
	   (mapconcat 'ee-defun-str-for
		      (apropos-internal
		       (ee-template0 "^eejump-{n}[0-9]*\\*?$") 'fboundp)
		      "\n")
	   pos-spec-list)))

(defun eejump (arg)
  "Execute the one-liner associated to the numeric argument ARG.
When called without an argument execute `find-eejumps', that
shows a user-friendly header followed by a not-very-user-friendly
list of all the one-liners that are currently associated to
numbers. For example, if `M-2 \\[eejump]' executes
`(find-emacs-keys-intro)' this is shown in the list as:\n
  (defun eejump-2 () (find-emacs-keys-intro))\n
See: (find-eev-quick-intro \"7.1. `eejump'\")
     (find-eev-quick-intro \"7.2. The list of eejump targets\")"
  (interactive "P")
  (if (null arg)
      (find-eejumps)			; was: (eejump-*)
    (if (< arg 0)
	(find-filtered-eejumps (* arg -1))
      (if (fboundp (intern (format "eejump-%d" arg)))
	  (funcall (intern (format "eejump-%d" arg)))
	(eejump-str* (format "%d" arg))))))
