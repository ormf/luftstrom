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
  (setf *basedir*  (pathname "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/"))
  (cd *basedir*)
;;  (setf *presets-file* (bs-full-path "presets/up-to-three-19-07-31.lisp"))
;;  (setf *audio-presets-file* (bs-full-path "presets/up-to-three-audio-19-07-31.lisp"))
;;  (setf *bs-presets-file* (bs-full-path "presets/up-to-three-bs-presets-19-07-31.lisp"))
  (setf *presets-file* (bs-full-path "presets/up-to-three-demo.lisp"))
  (setf *audio-presets-file* (bs-full-path "presets/up-to-three-demo-audio.lisp"))
  (setf *bs-presets-file* (bs-full-path "presets/kukuki-2019-11-05.lisp"))
  (init-cc-presets)
  (set-fixed-cc-fns *nk2-chan*)
  (load-audio-presets)
  (init-emacs-display-fns)
  (load-presets)
  (load-preset 0)
  (restore-bs-presets)
;;;  (load-preset 1)
  (dotimes (i 4) (setf (obstacle-active (aref *obstacles* i)) nil)))

(defun init-beatstep ()
  (beatstep-gui :id :bs1)
  (sleep 1)
  (init-beatstep-gui-callbacks :bs1))

(boid-init-gui)
(init-flock)
(defparameter *curr-boid-state* (make-instance 'cl-boids-gpu::boid-system-state))
;;;
(init-beatstep)
(setf (aref *cc-fns* *art-chan* 0)
      (lambda (val) (format t "~&cb-val: ~a~%" val)))

(setf (aref *cc-fns* *art-chan* 1)
      (lambda (val) (format t "~&hallo Tobi: ~a~%" val)))
(start-midi-receive)
(cl-boids-gpu:boids :width 1600 :height 900)
;;; (cl-boids-gpu:boids :width 800 :height 450)

(cuda-gui::emit-signal (aref))

(cuda-gui::emit-signal
 (aref (cuda-gui::buttons (find-gui :bs1)) 2) "setState(int)" 127)

(cuda-gui::emit-signal
 (aref (cuda-gui::buttons (find-gui :bs1)) 3) "released()")




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
