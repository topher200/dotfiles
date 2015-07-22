; global keybindings
(define-key global-map (kbd "C-<tab>") 'evil-window-next)
(define-key global-map (kbd "C-S-<tab>") 'evil-window-prev)
(define-key global-map (kbd "C-s") 'save-buffer)
(define-key global-map (kbd "C-c s") 'topher-named-shell)
(define-key global-map (kbd "C-c k") 'kill-this-buffer)
(define-key global-map (kbd "C-c e") 'erase-buffer)
(define-key global-map (kbd "C-c r") 'revert-buffer)

; evil mode defines
(define-key evil-normal-state-map (kbd "C-j") 'evil-scroll-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-scroll-up)
(define-key evil-normal-state-map (kbd "Y") "y$")
(define-key evil-normal-state-map (kbd "M-;") 'topher-comment-dwim-line)

; comint-mode bindings
(add-hook 'comint-mode-hook
          (function (lambda ()
                      (local-set-key [up] 'comint-previous-input)
                      (local-set-key [down] 'comint-next-input))))

;; add keybinding to find related file
(define-key global-map (kbd "C-c f") 'ff-find-other-file)
