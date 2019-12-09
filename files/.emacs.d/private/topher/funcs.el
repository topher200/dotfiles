;; When no lines are selected, comment-dwim will comment out the line (instead
;; of commenting at the end).
;; Taken from http://www.emacswiki.org/emacs/CommentingCode
(defun topher-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.

  If no region is selected and current line is not blank and we
  are not at the end of the line, then comment current line.
  Replaces default behaviour of comment-dwim, when it inserts
  comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region
       (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

(defun topher-named-shell ()
  "Named Shell: Create a shell with the name of the current buffer."
  (interactive)
  (shell (concat "shell-" (buffer-name))))

(defun toc ()
  "Poor man's table of contents for the current python/lisp buffer."
  (interactive)
  (cond
   ((eq major-mode 'c++-mode)
    (lgrep "^[A-Za-z0-9_]* \\?[A-Za-z0-9_*&]\\+ [A-Za-z0-9_]*::[A-Za-z0-9_]* \\?("
           (buffer-name) ""))
   ((eq major-mode 'emacs-lisp-mode)
    (lgrep "^ *(\\(defcustom\\|defun\\|defgroup\\) [A-Za-z0-9_-]*" (buffer-name) ""))
   ((eq major-mode 'python-mode)
    (grep (concat "grep -n \"^ *\\(def\\|class\\) [A-Za-z0-9_]*\" "
                  (buffer-name) "")))
   (t (message "Don't know how to do TOC for this buffer!"))))

(defun add-import ()
  "Search the codebase for the import for the class at point. Insert into header"
  (interactive)
  (let (
        (class-to-find (thing-at-point 'word)))
    (save-excursion
      (goto-char 0)
      (insert (shell-command-to-string (format "%s %s" "~/dev/bin/find_imports.sh" class-to-find))))))
