;;; 
;;; bs-presets.lisp
;;;
;;; Utils to store the complete state of the boid system with all
;;; positions, velocities, etc. in presets. The presets are stored in
;;; an array of 100 elems. Each array element contains an instance of
;;; a 'boid-system-state class. The parameter *curr-boid-state* is set
;;; on each frame in the gl loop. Storing the state is done with the
;;; save-boid-system-state function. It simply means copying the
;;; *curr-boid-state* into the array at the given preset idx.
;;;
;;;
;;; **********************************************************************
;;; Copyright (c) 2019 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
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

(in-package :luftstrom-display)

(cd "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/")

(defparameter *bs-preset-file* "presets/bs-presets-01.lisp")

(defparameter *bs-presets* (make-array 100
                                       :element-type
                                       'cl-boids-gpu::boid-system-state
                                       :initial-contents
                                       (loop
                                         for x below 100
                                         collect (make-instance 'cl-boids-gpu::boid-system-state))))

(defun save-boid-system-state (idx)
  "save the current state of the boid system in the *bs-presets* array
at idx."
  (let ((curr-bs-state (ou:ucopy *curr-boid-state*)))
    (setf (slot-value curr-bs-state 'cl-boids-gpu::bs-preset) *curr-preset*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::maxforce) *maxforce*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::maxspeed) *maxspeed*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::sepmult) *sepmult*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::cohmult) *cohmult*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::alignmult) *alignmult*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::predmult) *predmult*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::len) *length*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::maxlife) *maxlife*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::lifemult) *lifemult*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::note-state)
          (alexandria:copy-array *note-states*))
    (setf (slot-value curr-bs-state 'cl-boids-gpu::midi-cc-state)
          (alexandria:copy-array *cc-state*))
    (setf (slot-value curr-bs-state 'cl-boids-gpu::midi-cc-fns)
          (getf *curr-preset* :midi-cc-fns))
    (setf (slot-value curr-bs-state 'cl-boids-gpu::audio-args)
          (getf *curr-preset* :audio-args))
    (setf (aref *bs-presets* idx) curr-bs-state)))

(defun store-bs-presets (&optional (file *bs-preset-file*))
  "store the whole *bs-presets* array to disk."
  (cl-store:store *bs-presets* file))

(defun restore-bs-presets (&optional (file *bs-preset-file*))
  "restore the whole *bs-presets* array from disk."
    (setf *bs-presets* (cl-store:restore file)))

(defun bs-state-recall (num &key (audio t) (cc-state t) (cc-ctl t))
  (setf cl-boids-gpu::*switch-to-preset* num)
  (if audio
      )

  )

(restore-bs-presets)

#|
(save-boid-system-state 0)
(save-boid-system-state 1)
(save-boid-system-state 2)
(save-boid-system-state 3)
(save-boid-system-state 4)
(save-boid-system-state 5)
(save-boid-system-state 6)
(save-boid-system-state 7)
(store-bs-presets)n
(restore-bs-presets)

;;; recall preset (video only):

(setf cl-boids-gpu::*switch-to-preset* 0)
(setf *switch-to-preset* 1)
(setf *switch-to-preset* 2)
(setf *switch-to-preset* 3)
(setf *switch-to-preset* 4)
(setf *switch-to-preset* 5)
(setf *switch-to-preset* 6)



(set-value :lifemult 1500)
(setf *bs-presets* (cl-store:restore *bs-preset-file*))

(cl-store:store *bs-presets* "/tmp/test.lisp")

(setf *bs-presets* (cl-store:restore "/tmp/test.lisp"))

(cl-store:restore "/tmp/test.lisp")

(setf *bs-presets* nil)

|#
