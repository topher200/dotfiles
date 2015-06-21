; global keybindings
(define-key global-map (kbd "C-<tab>") 'evil-window-next)
(define-key global-map (kbd "C-S-<tab>") 'evil-window-prev)
(define-key global-map (kbd "C-s") 'save-buffer)
(define-key global-map (kbd "C-c s") 'topher-named-shell)
(define-key global-map (kbd "C-c k") 'kill-this-buffer)

; evil mode defines
(define-key evil-normal-state-map (kbd "C-j") 'evil-scroll-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-scroll-up)
(define-key evil-normal-state-map (kbd "Y") "y$")
(define-key evil-normal-state-map (kbd "M-;") 'topher-comment-dwim-line)

; flycheck bindings
(define-key flycheck-mode-map (kbd "C-c n") 'flycheck-next-error)
(define-key flycheck-mode-map (kbd "C-c p") 'flycheck-previous-error)

; comint-mode bindings
(define-key comint-mode-map [up] 'comint-previous-input)
(define-key comint-mode-map [down] 'comint-next-input)
