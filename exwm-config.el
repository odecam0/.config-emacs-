;; EXWM config:
(require `exwm)
(require 'exwm-randr)
(exwm-randr-enable)

(add-hook 'exwm-update-class-hook
        (lambda ()
        (exwm-workspace-rename-buffer exwm-class-name)))

;; Line-editing shortcuts
(unless (get 'exwm-input-simulation-keys 'saved-value)
(setq exwm-input-simulation-keys
        '(([?\C-b] . [left])
        ([?\C-f] . [right])
        ([?\C-p] . [up])
        ([?\C-n] . [down])
        ([?\C-a] . [home])
        ([?\C-e] . [end])
        ([?\M-v] . [prior])
        ([?\C-v] . [next])
        ([?\C-d] . [delete])
        ([?\C-k] . [S-end delete]))))

;; Enable EXWM
(exwm-enable)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode 1)

(setq exwm-input-global-keys
`(
        ([?\M-!] . shell-command)
        ([?\s-p] . print-screen)
        ([?\s-1] . delete-other-windows)
        ([?\s-2] . split-window-below)
        ([?\s-3] . split-window-right)
        ([?\s-0] . delete-window)

        ([?\s-i] . toggle-index-buffer)
        ([?\s-l] . brnm-toggle-link-buffer)
        ([?\s-L] . brnm-run-link)

        ([?\s-b] . switch-to-buffer)

        ([?\s-o] . other-window)
        ([?\s-c] . toggle-chromium-buffer)

        ([?\s- ] . execute-extended-command)

        ([?\s-j] . next-buffer)
        ([?\s-k] . previous-buffer)
        ([?\s-K] . kill-this-buffer)

        ([?\s-t] . brnm-toggle-vterm-buffer)
        ;;
        ([?\s--] . shrink-window)
        ([?\s-_] . shrink-window-horizontally)

        ;; 's-r': Reset (to line-mode).
        ([?\s-r] . exwm-reset)
        ;; 's-w': Switch workspace.
        ([?\s-w] . exwm-workspace-switch)
        ;; 's-&': Launch application.
        ([?\s-&] . (lambda (command)
                (interactive (list (read-shell-command "$ ")))
                (start-process-shell-command command nil command)))
        ))

;; Patch to have focus issue on chromium temporarily solved
;;
(defun exwm-layout--hide (id)
"Hide window ID."
(with-current-buffer (exwm--id->buffer id)
(unless (or (exwm-layout--iconic-state-p)
                (and exwm--floating-frame
                (eq 4294967295. exwm--desktop)))
(exwm--log "Hide #x%x" id)
(when exwm--floating-frame
        (let* ((container (frame-parameter exwm--floating-frame
                                        'exwm-container))
                (geometry (xcb:+request-unchecked+reply exwm--connection
                        (make-instance 'xcb:GetGeometry
                                        :drawable container))))
        (setq exwm--floating-frame-position
                (vector (slot-value geometry 'x) (slot-value geometry 'y)))
        (exwm--set-geometry container exwm-layout--floating-hidden-position
                        exwm-layout--floating-hidden-position
                        1
                        1)))
(xcb:+request exwm--connection
        (make-instance 'xcb:ChangeWindowAttributes
                        :window id :value-mask xcb:CW:EventMask
                        :event-mask xcb:EventMask:NoEvent))
(xcb:+request exwm--connection
        (make-instance 'xcb:UnmapWindow :window id))
(xcb:+request exwm--connection
        (make-instance 'xcb:ChangeWindowAttributes
                        :window id :value-mask xcb:CW:EventMask
                        :event-mask (exwm--get-client-event-mask)))
(exwm-layout--set-state id xcb:icccm:WM_STATE:IconicState)
;; (cl-pushnew xcb:Atom:_NET_WM_STATE_HIDDEN exwm--ewmh-state)
(exwm-layout--set-ewmh-state id)
(exwm-layout--auto-iconify)
(xcb:flush exwm--connection))))
