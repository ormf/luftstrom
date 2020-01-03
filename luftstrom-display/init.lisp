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

#|
(setf *presets-file* "presets/schwarm-video.lisp")
(setf *audio-presets-file* "presets/schwarm-audio-presets-video.lisp")
(setf *presets-file* "presets/schwarm-18-12-06.lisp")
(setf *audio-presets-file* "presets/schwarm-audio-presets-18-12-06.lisp")

;;; (load-presets)
;;; (load-audio-presets)
|#

(defparameter *ip-galaxy* "192.168.1.200")
(defparameter *ip-local* "192.168.1.188")

(setf *curr-boids-state* (make-instance 'cl-boids-gpu::boid-system-state))

(defun init-flock ()
  (setf *basedir*  (pathname "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/"))
  (cd *basedir*)
;;  (setf *presets-file* (bs-full-path "presets/up-to-three-19-07-31.lisp"))
;;  (setf *audio-presets-file* (bs-full-path "presets/up-to-three-audio-19-07-31.lisp"))
;;  (setf *bs-presets-file* (bs-full-path "presets/up-to-three-bs-presets-19-07-31.lisp"))
  (setf *presets-file* (bs-full-path "presets/kukuki-2019-11-05-presets.lisp"))
  (setf *audio-presets-file* (bs-full-path "presets/kukuki-2019-11-05-audio.lisp"))
;;;  (setf *bs-presets-file* (bs-full-path "presets/kukuki-2019-11-05b-bs.lisp"))
  (setf *bs-presets-file* (bs-full-path "presets/salzburg-2020-01-23-02-bs.lisp"))
  (init-cc-presets)
;;;  (set-fixed-cc-fns (find-controller :nk2))
  (load-audio-presets)
  (init-emacs-display-fns)
  (load-presets)
;;  (load-preset 0)
  (restore-bs-presets)
;;;  (load-preset 1)
  (gui-set-preset 1)
  (dotimes (i 4) (setf (obstacle-active (aref *obstacles* i)) nil)))


(boid-init-gui)
(set-boid-gui-refs *bp*)
(init-flock)



;;;
;;; (init-beatstep)
;; (setf (aref *cc-fns* *art-chan* 0)
;;       (lambda (val) (format t "~&cb-val: ~a~%" val)))
;; 
;; (setf (aref *cc-fns* *art-chan* 1)
;;       (lambda (val) (format t "~&hallo Tobi: ~a~%" val)))

(start-midi-receive *midi-in1*)
;;; (sleep 2)
(make-instance 'beatstep :id :bs1 :chan (controller-chan :bs1)
                         :cc-state (sub-array *cc-state* (controller-chan :bs1))
                         :cc-fns (sub-array *cc-fns* (controller-chan :bs1)))

(reinit-beatstep (find-controller :bs1) 0)

(make-instance 'nanokontrol :id :nk2 :chan (controller-chan :nk2)
                            :cc-state (sub-array *cc-state* (controller-chan :nk2))
                            :cc-fns (sub-array *cc-fns* (controller-chan :nk2)))

(set-nk2-std)
;;; (osc-start)

(cl-boids-gpu:boids :width 1600 :height 900 :pos-x 1920)
;;; (cl-boids-gpu:boids :width 800 :height 450)
;;; (set-fader (find-gui :nk2) 0 28)
