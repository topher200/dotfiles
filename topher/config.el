;; make evil jump words like Vim
(defun underscores-in-words ()
  (modify-syntax-entry ?_ "w" (syntax-table)))
(add-hook 'python-mode-hook 'underscores-in-words)
(add-hook 'shell-mode-hook 'underscores-in-words)
(add-hook 'ruby-mode-hook 'underscores-in-words)
(add-hook 'c-mode-common-hook 'underscores-in-words)
(add-hook 'html-mode-hook 'underscores-in-words)
(add-hook 'json-mode-hook 'underscores-in-words)
(add-hook 'sql-mode-hook 'underscores-in-words)
(add-hook 'web-mode-hook 'underscores-in-words)
(add-hook 'perl-mode-hook 'underscores-in-words)
(add-hook 'text-mode-hook 'underscores-in-words)

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

(defun after-load-python ()
  (defun python-fill-string (&optional justify)
    (let* ((str-start-pos
            (set-marker
             (make-marker)
             (or (python-syntax-context 'string)
                 (and (equal (string-to-syntax "|")
                             (syntax-after (point)))
                      (point)))))
           (num-quotes (python-syntax-count-quotes
                        (char-after str-start-pos) str-start-pos))
           (str-end-pos
            (save-excursion
              (goto-char (+ str-start-pos num-quotes))
              (or (re-search-forward (rx (syntax string-delimiter)) nil t)
                  (goto-char (point-max)))
              (point-marker)))
           (multi-line-p
            ;; Docstring styles may vary for oneliners and multi-liners.
            (> (count-matches "\n" str-start-pos str-end-pos) 0))
           (delimiters-style
            (pcase python-fill-docstring-style
              ;; delimiters-style is a cons cell with the form
              ;; (START-NEWLINES .  END-NEWLINES). When any of the sexps
              ;; is NIL means to not add any newlines for start or end
              ;; of docstring.  See `python-fill-docstring-style' for a
              ;; graphic idea of each style.
              (`django (cons 1 1))
              (`onetwo (and multi-line-p (cons 1 2)))
              (`pep-257 (and multi-line-p (cons nil 2)))
              (`pep-257-nn (and multi-line-p (cons nil 1)))
              (`symmetric (and multi-line-p (cons 1 1)))))
           (docstring-p (save-excursion
                          ;; Consider docstrings those strings which
                          ;; start on a line by themselves.
                          (python-nav-beginning-of-statement)
                          (and (= (point) str-start-pos))))
           (paragraph-start "[ \t\f]*\"*$\\|[ \t\f]*@[a-z]+:")
           (paragraph-separate "[ \t\f]*\"*$"))
      (save-excursion
        (goto-char (+ str-start-pos num-quotes))
        (delete-region (point) (progn
                                 (skip-syntax-forward "> ")
                                 (point)))
        (newline-and-indent)
        (insert "    "))
      (fill-paragraph justify))))
(with-eval-after-load 'python (after-load-python))
