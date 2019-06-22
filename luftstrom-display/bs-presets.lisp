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

(defparameter *bs-preset-file* "presets/bs-presets-01.lisp")

(defparameter *bs-presets* (make-array 100 :element-type 'boid-system-state))

(defun save-boid-system-state (idx)
  "save the current state of the boid system in the *bs-presets* array
at idx."
  (let ((curr-bs-state (ou:ucopy *curr-boid-state*)))
    (setf (slot-value curr-bs-state :bs-preset) *curr-preset*)
    (setf (aref *bs-presets* idx) curr-bs-state)))

(defun store-bs-presets (&optional (file *bs-preset-file*))
  "store the whole *bs-presets* array to disk."
  (cl-store:store *bs-presets* file))

(defun restore-bs-presets (&optional (file *bs-preset-file*))
  "restore the whole *bs-presets* array from disk."
  (setf *bs-presets* (cl-store:restore file)))

#|
(save-boid-system-state 1)

(cl-store:store *bs-presets* "/tmp/test.lisp")

(setf *bs-presets* (cl-store:restore "/tmp/test.lisp"))

(cl-store:restore "/tmp/test.lisp")

(setf *bs-presets* nil)

Contemporary and Stylish 1BR flat
Jun 28 - Jul 8, 2019 • 1 guest
46 The Priory Queensway Block 3, Flat 303, Allegro Living, Exchange Square
West Midlands, B4 7LR

Reservation Code HMAECZEPP3

|#
