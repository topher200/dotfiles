;; make evil jump words like Vim
(add-hook 'python-mode-hook
          '(lambda ()
             (modify-syntax-entry ?_ "w" python-mode-syntax-table)))
(add-hook 'ruby-mode-hook
          '(lambda ()
             (modify-syntax-entry ?_ "w" ruby-mode-syntax-table)))
(add-hook 'c-mode-common-hook
          '(lambda ()
             (modify-syntax-entry ?_ "w" c-mode-syntax-table)))
(add-hook 'c-mode-common-hook
          '(lambda ()
             (modify-syntax-entry ?_ "w" c++-mode-syntax-table)))
(add-hook 'html-mode-hook
          '(lambda ()
             (modify-syntax-entry ?_ "w" html-mode-syntax-table)))

;; save the desktop periodically
(add-hook 'projectile-idle-timer-hook 'desktop-save-in-desktop-dir)
