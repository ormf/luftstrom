;;; 
;;; utils.lisp
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

(defparameter *compile-debug* t)
(defparameter *debug* nil)

(defun rand (max)
  "random value between [min..max] with linear distribution."
  (r-lin 0 max))

(defun parse-ip (ip)
  (mapcar #'read-from-string (uiop:split-string ip :separator ".")))

(defmacro with-debugging (&body body)
  (if *compile-debug*
      `(if *debug* ,@body)))

(defun bs-full-path (relative-path)
  (merge-pathnames relative-path *basedir*))

(defun in-place-array-cp (src target)
  "copy src to target in place."
  (let ((total-size (array-total-size src)))
    (unless (= total-size
               (array-total-size target))
      (error "~a and ~a not of equal size" src target))
    (dotimes (i total-size)
      (setf (row-major-aref target i)
            (row-major-aref src i)))))

(defmacro with-array-mapped ((i array) &rest body)
  `(let ((total-size (array-total-size ,array)))
    (dotimes (,i total-size)
      ,@body)))

(defmacro do-array ((i array) &rest body)
  `(let ((total-size (array-total-size ,array)))
    (dotimes (,i total-size)
      ,@body)))

#|

(let ((arr (make-array '(3 10) :initial-element nil)))
  (with-array-mapped (i arr)
    (setf (row-major-aref arr i) 3))
  arr)

|#

(defun get-interpol (cc-state &key (player 0))
  (let ((curr-state (get-player-cc-state player)))
    (loop
      for idx from 0
      for old across curr-state
      for new across cc-state
      if (/= old new) collect (list idx old new))))

(defun schedule-interpolation (interpol time &key (player 0) (dtime 1/60))
  (destructuring-bind (idx curr target) interpol
    (let ((dval (/ (- target curr) (/ time dtime)))
          (a-idx (+ idx (ash player 4)))
          (end-time (+ (now) time)))
      (labels ((schedule (curr-time)
                   (if (>= curr-time end-time)
                       (set-cell (elt *audio-preset-ctl-model* a-idx) target)
                       (let ((next (+ curr-time dtime)))
                         (if (/= (round curr) (incf curr dval))
                             (set-cell (elt *audio-preset-ctl-model* a-idx) (round curr)))
                         (cm::at next #'schedule next)))))
        (schedule (now))))))

(defun interpolate-audio (time cc-state &key (player 0) (dtime 1/60))
  (dolist (evt (get-interpol cc-state :player player))
    (funcall #'schedule-interpolation evt time :player player :dtime dtime)))
