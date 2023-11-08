(defun mswiper (text)
  (interactive)
  "It executes swiper on TEXT uppercased"
  (swiper (upcase text)))

(defun mswiper-bl (beginning end)
  (interactive "r")
  "It searches for mswiper's on the buffer that points to region"
  (deactivate-mark)
  (let ((text (buffer-substring beginning end)))
    (swiper (concat "(mswiper \"" (regexp-quote (downcase text)) "\")"))))
