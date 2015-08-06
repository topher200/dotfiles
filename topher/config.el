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

;; python grin support for emacs. Based on ack support script from:
;; http://stackoverflow.com/questions/2322389/ack-does-not-work-when-run-from-grep-find-in-emacs-on-windows

(defcustom grin-command (or (executable-find "grin")
                            (executable-find "grin-grep"))
  "Command to use to call grin"
  :type 'file)

(defvar grin-command-line (concat grin-command " --emacs -D "))
(defvar grin-history nil)
(defvar grin-host-defaults-alist nil)

(defun grin ()
  "Like ack, but using grin as the default"
  ; Make sure grep has been initialized
  (interactive)
  (if (>= emacs-major-version 22)
      (require 'grep)
    (require 'compile))
  ; Close STDIN to keep grin from going into filter mode
  (let ((null-device (format "< %s" null-device))
        (grep-command grin-command-line)
        (grep-history grin-history)
        (grep-host-defaults-alist grin-host-defaults-alist))
    (call-interactively 'grep)
    (setq grin-history             grep-history
          grin-host-defaults-alist grep-host-defaults-alist)))
