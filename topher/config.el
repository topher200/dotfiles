;; make evil jump words like Vim
(defun underscores-in-words ()
  (modify-syntax-entry ?_ "w" (syntax-table)))
(add-hook 'prog-mode-hook 'underscores-in-words)

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

(defun after-load-eyebrowse ()
  (defun eyebrowse--load-window-config (slot)
    "Restore the window config from SLOT."
    (-when-let (match (assq slot (eyebrowse--get 'window-configs)))
      ;; KLUDGE: workaround for #36
      ;; see also http://debbugs.gnu.org/cgi/bugreport.cgi?bug=20848
      (when (version< emacs-version "25")
        (delete-other-windows)
        (set-window-dedicated-p nil nil))
      ;; KLUDGE: workaround for visual-fill-column foolishly
      ;; setting the split-window parameter
      (let ((ignore-window-parameters t)
            (window-config (eyebrowse--fixup-window-config (cadr match))))
        ;; (with-demoted-errors
            ;; (window-state-put window-config (frame-root-window) 'safe)
            (window-state-put window-config (frame-root-window))
          ;; )
            )))

  (defun golden-ratio (&optional arg)
    "Resizes current window to the golden-ratio's size specs."
    (interactive "p")
    (unless (or (and (not golden-ratio-mode) (null arg))
                (window-minibuffer-p)
                (one-window-p)
                (golden-ratio-exclude-major-mode-p)
                (member (buffer-name)
                        golden-ratio-exclude-buffer-names)
                (and golden-ratio-exclude-buffer-regexp
                  (loop for r in golden-ratio-exclude-buffer-regexp
                          thereis (string-match r (buffer-name))))
                (and golden-ratio-inhibit-functions
                    (loop for fun in golden-ratio-inhibit-functions
                          thereis (funcall fun))))
      (let ((dims (golden-ratio--dimensions))
            (golden-ratio-mode nil))
        ;; Always disable `golden-ratio-mode' to avoid
        ;; infinite loop in `balance-windows'.
        (balance-windows)
        (golden-ratio--resize-window dims)
        (when golden-ratio-recenter
          (scroll-right)
          (condition-case err
              recenter
            (message "config.el is catching recenter error: '%s'"
                     (error-message-string err)))
          )))))
(with-eval-after-load 'eyebrowse (after-load-eyebrowse))

(add-hook 'eyebrowse-pre-window-switch-hook
          (lambda ()
            (setq using-golden-ratio golden-ratio-mode)
            (spacemacs/toggle-golden-ratio-off)
            ))
(add-hook 'eyebrowse-post-window-switch-hook
          (lambda ()
            (if using-golden-ratio
                (spacemacs/toggle-golden-ratio-on))
            ))

(defun balance-windows-2 (window horizontal)
  "Subroutine of `balance-windows-1'.
WINDOW must be a vertical combination (horizontal if HORIZONTAL
is non-nil)."
  (let* ((char-size (if window-resize-pixelwise
			1
		      (frame-char-size window horizontal)))
	 (first (window-child window))
	 (sub first)
	 (number-of-children 0)
	 (parent-size (window-new-pixel window))
	 (total-sum parent-size)
	 failed size sub-total sub-delta sub-amount rest)
    (while sub
      (setq number-of-children (1+ number-of-children))
      (when (window-size-fixed-p sub horizontal)
	(setq total-sum
	      (- total-sum (window-size sub horizontal t)))
	(set-window-new-normal sub 'ignore))
      (setq sub (window-right sub)))

    (setq failed t)
    (while (and failed (> number-of-children 0))
      (setq size (/ total-sum number-of-children))
      (setq failed nil)
      (setq sub first)
      (while (and sub (not failed))
	;; Ignore child windows that should be ignored or are stuck.
	(unless (window--resize-child-windows-skip-p sub)
	  (setq sub-total (window-size sub horizontal t))
	  (setq sub-delta (- size sub-total))
	  (setq sub-amount
		(window-sizable sub sub-delta horizontal nil t))
	  ;; Register the new total size for this child window.
	  (set-window-new-pixel sub (+ sub-total sub-amount))
	  (unless (= sub-amount sub-delta)
	    (setq total-sum (- total-sum sub-total sub-amount))
	    (setq number-of-children (1- number-of-children))
	    ;; We failed and need a new round.
	    (setq failed t)
	    (set-window-new-normal sub 'skip)))
	(setq sub (window-right sub))))

    ;; How can we be sure that `number-of-children' is NOT zero here ?
    (setq rest (% total-sum number-of-children))
    ;; Fix rounding by trying to enlarge non-stuck windows by one line
    ;; (column) until `rest' is zero.
    (setq sub first)
    (while (and sub (> rest 0))
      (unless (window--resize-child-windows-skip-p window)
	(set-window-new-pixel sub (min rest char-size) t)
	(setq rest (- rest char-size)))
      (setq sub (window-right sub)))

    ;; Fix rounding by trying to enlarge stuck windows by one line
    ;; (column) until `rest' equals zero.
    (setq sub first)
    (while (and sub (> rest 0))
      (unless (eq (window-new-normal sub) 'ignore)
	(set-window-new-pixel sub (min rest char-size) t)
	(setq rest (- rest char-size)))
      (setq sub (window-right sub)))

    (setq sub first)
    (while sub
      ;; Record new normal sizes.
      (set-window-new-normal
       sub (/ (if (eq (window-new-normal sub) 'ignore)
		  (window-size sub horizontal t)
		(window-new-pixel sub))
	      (float parent-size)))
      ;; Recursively balance each window's child windows.
      (balance-windows-1 sub horizontal)
      (setq sub (window-right sub)))))

(defun balance-windows-1 (window &optional horizontal)
  "Subroutine of `balance-windows'."
  (if (window-child window)
      (let ((sub (window-child window)))
	(if (window-combined-p sub horizontal)
	    (balance-windows-2 window horizontal)
	  (let ((size (window-new-pixel window)))
	    (while sub
	      (set-window-new-pixel sub size)
	      (balance-windows-1 sub horizontal)
	      (setq sub (window-right sub))))))))

(defun balance-windows (&optional window-or-frame)
  "Balance the sizes of windows of WINDOW-OR-FRAME.
WINDOW-OR-FRAME is optional and defaults to the selected frame.
If WINDOW-OR-FRAME denotes a frame, balance the sizes of all
windows of that frame.  If WINDOW-OR-FRAME denotes a window,
recursively balance the sizes of all child windows of that
window."
  (interactive)
  (let* ((window
	  (cond
	   ((or (not window-or-frame)
		(frame-live-p window-or-frame))
	    (frame-root-window window-or-frame))
	   ((or (window-live-p window-or-frame)
		(window-child window-or-frame))
	    window-or-frame)
	   (t
	    (error "Not a window or frame %s" window-or-frame))))
	 (frame (window-frame window)))
    ;; Balance vertically.
    (window--resize-reset (window-frame window))

    (condition-case err
        (balance-windows-1 window)
      (arith-error (message
                    "window.el is catching balance-windows-1 error: '%s'"
                    (error-message-string err))))

    ;; (balance-windows-1 window)

    (when (window--resize-apply-p frame)
      (window-resize-apply frame)
      (window--pixel-to-total frame)
      (run-window-configuration-change-hook frame))
    ;; Balance horizontally.
    (window--resize-reset (window-frame window) t)

    (condition-case err
        (balance-windows-1 window t)
      (arith-error (message
                    "window.el is catching balance-windows-1-horizontal error: '%s'"
                    (error-message-string err))))

    ;; (balance-windows-1 window t)

    (when (window--resize-apply-p frame t)
      (window-resize-apply frame t)
      (window--pixel-to-total frame t)
      (run-window-configuration-change-hook frame))))
