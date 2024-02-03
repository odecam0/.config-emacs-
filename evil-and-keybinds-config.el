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


(evil-define-key '(normal insert visual replace) global-map (kbd "C-x 1") 'delete-other-windows)
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x 2") 'split-window-below)
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x 3") 'split-window-right)
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x 0") 'delete-window)

(evil-define-key '(normal insert visual replace) global-map (kbd "C-x i") 'toggle-index-buffer)
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x l") 'brnm-toggle-link-buffer)
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x L") 'brnm-run-link)

(evil-define-key '(normal insert visual replace) global-map (kbd "C-x b") 'switch-to-buffer)

(evil-define-key '(normal insert visual replace) global-map (kbd "C-x o") 'other-window)
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x c") 'toggle-chromium-buffer)

(evil-define-key '(normal insert visual replace) global-map (kbd "C-x j") 'next-buffer)
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x k") 'previous-buffer)
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x K") 'kill-this-buffer)

(evil-define-key '(normal insert visual replace) global-map (kbd "C-x t") 'brnm-toggle-vterm-buffer)
;;
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x -") 'shrink-window)
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x _") 'shrink-window-horizontally)

(evil-define-key '(normal insert visual replace) global-map (kbd "C-x r") 'exwm-reset)
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x w") 'exwm-workspace-switch)
(evil-define-key '(normal insert visual replace) global-map (kbd "C-x &") '(lambda (command)
									     (interactive (list (read-shell-command "$ ")))
									     (start-process-shell-command command nil command)))

(evil-define-key '(normal insert visual replace) global-map (kbd "M-p") #'daily-find-previous-note)
(evil-define-key '(normal insert visual replace) global-map (kbd "M-n") #'daily-find-next-note)
(evil-define-key '(normal insert visual replace) evil-mc-key-map (kbd "M-p") #'daily-find-previous-note)
(evil-define-key '(normal insert visual replace) evil-mc-key-map (kbd "M-n") #'daily-find-next-note)
