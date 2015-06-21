;;; packages.el --- topher Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq topher-packages
    '(
      flycheck
      projectile
      ))

;; List of packages to exclude.
(setq topher-excluded-packages '())

(defun topher/init-flycheck ()
  "Add flycheck keybindings"
  (use-package flycheck
    :bind (("C-c n" . flycheck-next-error)
           ("C-c p" . flycheck-previous-error))))

(defun topher/init-projectile ()
  "Remove projectile's awful default prefix"
  (use-package projectile
    :init (setq projectile-keymap-prefix (kbd "C-c C-p"))))
