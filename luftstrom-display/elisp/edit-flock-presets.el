(find-file-other-frame  "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/boids-tmp.lisp")
(set-window-dedicated-p (get-buffer-window "boids-tmp.lisp" t) t)
(find-file-other-frame  "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/audio-tmp.lisp")
(set-window-dedicated-p (get-buffer-window "audio-tmp.lisp" t) t)


;; (add-to-list 'display-buffer-alist
;;              '("audio-tmp.lisp" (display-buffer-reuse-window)))

;; (add-to-list 'display-buffer-alist
;;              '("boids-tmp.lisp" (display-buffer-reuse-window)))


;;;; (setq display-buffer-alist nil)



(defun edit-flock-preset (str ref)
  (set-buffer (find-file-noselect "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/boids-tmp.lisp"))
  (delete-region (point-min) (point-max))
  (insert "(in-package :luftstrom-display)\n\n;;; preset: ")
  (insert (format "%s\n\n" ref))
  (insert (replace-regexp-in-string "luftstrom-display::" ""
                                    (replace-regexp-in-string "orm-utils:" "" str)))
  (insert (format "\n\n(state-store-curr-preset %s)" ref))
  (insert "\n\n(save-presets)")
  (delete-region (point) (point-max))
  (goto-char 34)
  (forward-line)
  (forward-line)
  (slime-reindent-defun)
  (save-buffer))


;;;  (switch-buffer)



(defun edit-flock-audio-preset (str ref)
  (set-buffer (get-buffer "audio-tmp.lisp"))
  (delete-region (point-min) (point-max))
  (insert "(in-package :luftstrom-display)\n\n;;; audio-preset: ")
  (insert (format "%s\n\n" ref))
  (insert (replace-regexp-in-string "luftstrom-display::" ""
                                    (replace-regexp-in-string "orm-utils:" "" str)))
  (insert (format "\n\n(save-audio-presets)" ref))
  (delete-region (point) (point-max))
  (goto-char 34)
  (forward-line)
  (forward-line)
  (slime-reindent-defun)
  (save-buffer))


;; (defun edit-big-orchestra-audio-preset (str ref)
;;   (progn
;;     (find-file "/home/orm/work/kompositionen/big-orchestra/lisp/big-orchestra/big-orchestra-display/audio-tmp.lisp")
;;     (delete-region (point-min) (point-max))
;;     (insert "(in-package :big-orchestra-display)\n\n;;; audio-preset: ")
;;     (insert (format "%s\n\n" ref))
;;     (insert (replace-regexp-in-string "big-orchestra-display::" ""
;;              (replace-regexp-in-string "orm-utils:" "" str)))
;;     (insert (format "\n\n(save-audio-presets)" ref))
;;     (delete-region (point) (point-max))
;;     (goto-char 34)
;;     (forward-line)
;;     (forward-line)
;;     (slime-reindent-defun)
;;     (save-buffer)))

;; (defun view-big-orchestra-audio-preset (str ref)
;;   (progn
;;     (find-file "/home/orm/work/kompositionen/big-orchestra/lisp/big-orchestra/big-orchestra-display/audio-tmp.lisp")
;;     (delete-region (point-min) (point-max))
;;     (insert "(in-package :big-orchestra-display)\n\n;;; audio-preset: ")
;;     (insert (format "%s\n\n" ref))
;;     (insert (replace-regexp-in-string "big-orchestra-display::" ""
;;              (replace-regexp-in-string "orm-utils:" "" str)))
;;     (insert (format "\n\n(save-audio-presets)" ref))
;;     (delete-region (point) (point-max))
;;     (goto-char 34)
;;     (forward-line)
;;     (forward-line)
;;     (slime-reindent-defun)
;;     (save-buffer)
;;     (view-mode)))

(save-excursion
  (switch-to-buffer (get-buffer "boids-tmp.lisp"))
  )
