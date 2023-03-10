(defun edit-preset (str ref)
  (progn
    (find-file "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/boids-tmp.lisp")
    (delete-region (point-min) (point-max))
    (insert "(in-package :luftstrom-display)\n\n;;; preset: ")
    (insert (format "%s\n\n" ref))
    (insert str)
    (insert (format "\n\n(state-store-curr-preset %s)" ref))
    (insert (format "\n\n(save-presets)"))
    (delete-region (point) (point-max))
    (goto-char 34)
    (forward-line)
    (forward-line)
    (slime-reindent-defun)
    (save-buffer)))
