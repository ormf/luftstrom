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

(defun get-ip-fn (v0 v1 v2 v3 v4 &key (weight '(1 1 1 1)))
  "get interpolation function for 4 sliders, interpolationg between
  v0 (all sliders 0) and their respective weights, given by
  x1..x4 (normalized values). The :weight key can be used to scale the
  weight of the 4 sliders."
  (let ((result (make-array 16)))
    (lambda (slider-vals &key (weight weight))
      (let ((sum (reduce #'+ (mapcar #'* slider-vals weight))))
        (dotimes (i 16)
          (setf (elt result i)
                (/ (reduce #'+
                          (mapcar (lambda (x v w) (* x w (n-lin x (elt v0 i) (elt v i))))
                                  slider-vals
                                  (list v1 v2 v3 v4)
                                  weight))
                   sum))))
      result)))

(defparameter *ip-fn*
  (get-ip-fn
   #(1 0 0 0 0 0 127 127 42 0 127 30 0 127 127 127)
   #(4 0 0 40 0 0 127 127 38 3 127 7 0 127 91 105)
   #(0 0 0 0 0 0 127 127 38 3 60 38 0 127 127 05)
   #(3 0 0 42 0 0 127 127 51 5 127 7 0 127 91 105)
   #(10 0 0 36.5 0 0 127 127 36.5 3 127 30 0 127 91 105)))


(defun interpolate-cc-state (player cc1 cc2)
  (let ((ip-fns (make-array 16))
        (cc-state (make-array 16)))
    (dotimes (idx 16)
      (setf (aref ip-fns idx) (n-lin-fn (elt cc1 idx) (elt cc2 idx))))
    (lambda (x) (dotimes (i 16)
             (setf (elt cc-state i) (funcall (elt ip-fns i) x)))
      (set-player-cc-state player cc-state))))

(defun get-4-forces ()
  "get the normalized values of speed, separation, coherence and
align (the mapping is hardcoded here and taken from the nanoKontrol2
faders as of 31-07-2020."
  (mapcar (lambda (prop fn) (funcall fn (val (slot-value *bp* prop))))
     '(cl-boids-gpu::speed
       cl-boids-gpu::sepmult
       cl-boids-gpu::cohmult
       cl-boids-gpu::alignmult)
     (list
      (n-exp-rev-fn 0.1 20)
      (n-lin-rev-fn 1/8 8)
      (n-lin-rev-fn 1/8 8)
      (n-lin-rev-fn 1/8 8))))

(defun 4-slider-ip-cc-state (player &key (weight '(1 1 1 1)))
  (lambda (val)
    (declare (ignore val))
    (if *ip-fn*
        (set-player-cc-state player (funcall *ip-fn* (get-4-forces) :weight weight)))))


;;; (get-4-forces)



#|

(let ((arr (make-array '(3 10) :initial-element nil)))
  (with-array-mapped (i arr)
    (setf (row-major-aref arr i) 3))
  arr)

|#
