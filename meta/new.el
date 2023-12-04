;; ( I just had the idea that separate concerns should be separable somehow in the system.
;; ( this could be done using this package, meta.

;; ( The ideal in coding would be that some things that are written in sequence, and are related
;; ( would be all disposed together linearly. But it is not possible currently for me.
;; ( For example, when I am implementing some new functionality on a system, I have to alter a couple
;; ( of different files in different places, and as I do this, quite often the places I altered get lost
;; ( in my head, and it is not trivial to go back.

;; ( I've thought of a couple of things that can solve this.
;; ( A way to link this related stuff using the meta package.
;; ( And a way to show the different regions of altered text in a single file,
;; ( linearly, such that altering there, the alteration could be put in the right place.
;; ( but the second one is too advanced. Maybe could be more feasible if I had implemented
;; ( the SEXPS THAT DEFINE A GIVEN REGION.

;; ( Now I can think of the first solving scheme. Right now I think of using the eejump
;; ( to assign number with a given structure to define a sequence of places where changes
;; ( are happening.

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
