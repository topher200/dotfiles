; global keybindings
(define-key global-map (kbd "C-<tab>") 'evil-window-next)
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-<tab>") 'evil-window-next))
(define-key global-map (kbd "C-S-<tab>") 'evil-window-prev)
(define-key global-map (kbd "C-s") 'save-buffer)
(define-key global-map (kbd "C-c s") 'topher-named-shell)
(define-key global-map (kbd "C-c k") 'kill-this-buffer)
(define-key global-map (kbd "C-c e") 'erase-buffer)
(define-key global-map (kbd "C-x C-S-f") 'helm-projectile-find-file-in-known-projects)
(define-key global-map (kbd "C-c a") 'evil-numbers/inc-at-pt)
(define-key global-map (kbd "C-c d") 'evil-numbers/dec-at-pt)

; make the minimize and close shortcuts a no-op
(define-key global-map (kbd "C-x C-z") nil)
(define-key global-map (kbd "C-x C-c") nil)

; revert buffer without confirmation
(define-key global-map (kbd "C-c r")
  (lambda () (interactive) (revert-buffer t t)))

; evil mode defines
(define-key evil-normal-state-map (kbd "M-;") 'topher-comment-dwim-line)
(define-key evil-normal-state-map (kbd "Q") (kbd "@a"))
(define-key evil-insert-state-map (kbd "C-n") 'hippie-expand)

;; add keybinding to find related file
(define-key global-map (kbd "C-c f") 'ff-find-other-file)

;; run yas on 'C-c y'
(define-key yas-minor-mode-map (kbd "C-c y") #'yas-expand)

;; Make insert mode text manipulation more like OSX
(define-key evil-insert-state-map [M-backspace]
  (lambda () (interactive) (kill-line 0)))
(define-key evil-insert-state-map [A-backspace] 'backward-kill-word)

;; run my 'add import' function on command
(define-key global-map (kbd "C-c i") 'add-import)

;; open my notes file on request
(spacemacs/set-leader-keys "o n" (lambda() (interactive)(find-file "~/notes.org")))

;; open a junk buffer on request
(spacemacs/set-leader-keys "o j" (lambda() (interactive)(spacemacs/open-junk-file)))

;; work around bug that was making the 'SPC SPC' command go away
(spacemacs/set-leader-keys "SPC" 'helm-M-x)
