(define-key global-map (kbd "C-<tab>") 'evil-window-next)
(define-key global-map (kbd "C-S-<tab>") 'evil-window-prev)
(define-key global-map (kbd "C-s") 'save-buffer)
(define-key global-map (kbd "C-j") 'evil-scroll-down)
(define-key global-map (kbd "C-k") 'evil-scroll-up)

; evil mode defines
(define-key evil-normal-state-map (kbd "Y") "y$")
(define-key evil-normal-state-map (kbd "M-;") 'topher-comment-dwim-line)
