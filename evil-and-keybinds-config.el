(require 'evil)
(evil-mode 1)

(global-set-key (kbd "M-<tab>") 'tab)

(evil-define-key '(insert visual replace) global-map (kbd "M-ç") 'evil-normal-state)
(evil-define-key '(normal)        global-map (kbd "M-ç") 'save-buffer)

(evil-define-key '(normal insert visual) global-map (kbd "C-s") 'swiper)

(evil-define-key 'normal org-mode-map (kbd "<tab>") 'org-cycle)

(evil-define-key '(normal insert visual replace) global-map (kbd "M-=") 'text-scale-increase)
(evil-define-key '(normal insert visual replace) global-map (kbd "M--") 'text-scale-decrease)

(evil-define-key '(normal insert visual replace) global-map (kbd "M-l") 'brnm-center-stuff)

(evil-define-key '(normal insert visual replace) global-map (kbd "M-<SPC>") 'company-complete)

(evil-define-key 'insert global-map (kbd "C-y") 'yank)