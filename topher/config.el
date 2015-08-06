;; make evil jump words like Vim
(defun underscores-in-words ()
  (modify-syntax-entry ?_ "w" (syntax-table)))
(add-hook 'python-mode-hook 'underscores-in-words)
(add-hook 'shell-mode-hook 'underscores-in-words)
(add-hook 'ruby-mode-hook 'underscores-in-words)
(add-hook 'c-mode-common-hook 'underscores-in-words)
(add-hook 'html-mode-hook 'underscores-in-words)

;; save the desktop periodically
(add-hook 'projectile-idle-timer-hook 'desktop-save-in-desktop-dir)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/private"))
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)

;; Use "; " to comment out .ini files
(add-hook 'conf-space-mode-hook
          (lambda () (setq comment-start "; " comment-end "")))
(add-to-list 'auto-mode-alist '("\\.ini$" . conf-windows-mode))

;; Try to do case-sensitive matching with just hippie expand
;; From http://stackoverflow.com/a/8723712/131159
(defadvice hippie-expand (around hippie-expand-case-fold)
  "Try to do case-sensitive matching (not effective with all functions)."
  (let ((case-fold-search nil))
    ad-do-it))
(ad-activate 'hippie-expand)
