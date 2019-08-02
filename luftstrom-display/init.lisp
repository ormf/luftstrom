;;; 
;;; init.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2018 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
;;;
;;; Revision history: See git repository.
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the Gnu Public License, version 2 or
;;; later. See https://www.gnu.org/licenses/gpl-2.0.html for the text
;;; of this agreement.
;;; 
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;; GNU General Public License for more details.
;;;
;;; **********************************************************************

(in-package :cl-user)

(defun ld ()
  (setf *package* (find-package :luftstrom-display)))

(in-package :luftstrom-display)

(setf *presets-file* "presets/schwarm-video.lisp")
(setf *audio-presets-file* "presets/schwarm-audio-presets-video.lisp")
(setf *presets-file* "presets/schwarm-18-12-06.lisp")
(setf *audio-presets-file* "presets/schwarm-audio-presets-18-12-06.lisp")

;;; (load-presets)
;;; (load-audio-presets)

(defun init-flock ()
  (set-fixed-cc-fns *nk2-chan*)
  (load-audio-presets)
  (init-emacs-display-fns)
  (load-presets)
  (load-preset 0)
;;;  (load-preset 1)
  (dotimes (i 4) (setf (obstacle-active (aref *obstacles* i)) nil)))


(boid-init-gui)
(init-flock)
(defparameter *curr-boid-state* (make-instance 'cl-boids-gpu::boid-system-state))
(cl-boids-gpu:boids :width 600 :height 400)




;; (cl-boids-gpu:boids :width 1600 :height 900)
;; (cl-boids-gpu:boids :width 1280 :height 800)
;;; (cl-boids-gpu:boids :width 1920 :height 1080)
;;; (cl-boids-gpu:boids :width 400 :height 300)
;;; (cl-boids-gpu:boids :width 1280 :height 720)
;;; (cl-boids-gpu:boids :width 1920 :height 1080)
;;; (cl-boids-gpu:boids :width 1280 :height 720)
;;; (cl-boids-gpu:boids :width 1400 :height 1050)
;;; (cl-boids-gpu:boids :width 400 :height 300)
;;; (cl-boids-gpu:boids :width 1680 :height 1050)
;;; (cl-boids-gpu:boids :width 1024 :height 768)
;;(cl-boids-gpu:boids :width 1920 :height 1080)
;;; (cl-boids-gpu:boids :width 1680 :height 1050)
;; (cl-boids-gpu:boids :width 1600 :height 900)
;;; (connect-to-ew-4 '("192.168.99.11" "192.168.99.12" "192.168.99.13" "192.168.99.14" "192.168.99.15"))

;;; (connect-to-ew-4 '("127.0.0.1"))

;;; cl-boids-gpu::*win*

#|
(defun luftstrom-display (&rest systems)
  (flet ((cmcall (fn &rest args)
           (apply (find-symbol (string fn) :cm) args))
         (cmvar (var)
           (symbol-value (find-symbol (string var) :cm))))
    (setf *package* (find-package :cm))
    (setf *readtable* (cmvar :*cm-readtable*))
    ;; add slime readtable mapping...
    (let ((swank-pkg (find-package :swank)))
      (when swank-pkg
        (let ((sym (intern (symbol-name :*readtable-alist*) swank-pkg)))
          (setf (symbol-value sym)
                (cons (cons (symbol-name :cm) (cmvar :*cm-readtable*))
                      (symbol-value sym))))))
    (let (#-sbcl (*trace-output* nil))
      (dolist (s systems) (use-system s :verbose nil)))
    (cmcall :cm-logo)))
|#
