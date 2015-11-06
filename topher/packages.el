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
      flycheck-google-cpplint
      go-mode
      ))

;; List of packages to exclude.
(setq topher-excluded-packages '())

(defun topher/init-flycheck-google-cpplint ()
  "Tell the google style c++ checker to use cpplint"
  (use-package flycheck-google-cpplint
    :init (setq flycheck-disabled-checkers '(c/c++-gcc))
    :config (flycheck-add-next-checker 'c/c++-cppcheck 'c/c++-googlelint)))

(defun topher/init-go-mode ()
  "Turn on go-mode's gofmt"
  (use-package go-mode
    :config (add-hook 'before-save-hook #'gofmt-before-save)))

(defun topher/magit ()
  "Turn off magit warnings and dumb keybindings"
  (use-package magit
    :init (setq magit-revert-buffers t)
    :config (define-key magit-mode-map (kbd "C-<tab>") 'evil-window-next)))
