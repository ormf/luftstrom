;;; 
;;; params.lisp
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

(in-package :cl-boids-gpu)

(defparameter *sharing* t) ;;; set if khr_gl_sharing is available

(defparameter *check-state* nil)

(defparameter *clock* 0)
(defparameter *show-fps* nil)
(defparameter *platform* nil)
(defparameter *context* nil)
(defparameter *programs* nil)
(defparameter *kernels* nil)

(defparameter *max-events-per-tick* 30)
(defparameter *trig* t)
(defparameter *command-queues* nil)
(defparameter *buffers* nil)
(defparameter *width* 720)
(defparameter *height* 405)
(defparameter *real-width* 720)
(defparameter *real-height* 405)
(defparameter *zoom* 1)
(defparameter *gl-scale* 1.0)
(defparameter *gl-width* 1600)
(defparameter *gl-height* 900)
(defparameter *gl-x-aspect* 8)
(defparameter *gl-y-aspect* 5)
(defparameter *pixelsize* 5)
(defparameter *obstacle-tracked* nil)

;;; (defparameter *curr-kernel* "boids_reflection2")
(defparameter *curr-kernel* "boids")
;;(setf *curr-kernel* "boids")
(defparameter *boids-per-click* 5000)
(defparameter *boids-per-click* 1000)
(defparameter *boids-per-click* 150)
(defparameter *boids-per-click* 1000)
(defparameter *boids-per-click* 30)
;;(defparameter *boids-per-click* 1)
(defparameter *boids-maxcount* 20000)

(defparameter *max-obstacles* 16)
(defparameter *positions* nil)
(defparameter *obstacle-board* nil)
(defparameter *obstacles-type* nil)
(defparameter *obstacles-pos* nil)
(defparameter *obstacles-radius* nil)
(defparameter *board* nil)
(defparameter *colors* nil)
(defparameter *align-board* nil)
(defparameter *board-dx* nil)
(defparameter *board-dy* nil)
(defparameter *board-dist* nil)
(defparameter *board-sep* nil)
(defparameter *board-coh* nil)
(defparameter *weight-board* nil)
(defparameter *bidx* nil)
(defparameter *velocities* nil)
(defparameter *forces* nil)
(defparameter *life* nil)
(defparameter *retrig* nil)
(defparameter *update* t)
(defparameter *fg-color* '(0.6 0.6 0.6 0.6))
(defparameter *first-boid-color* '(1.0 0.0 0.0 1.0))

(defparameter *bp*
  (make-instance 'boid-params))

(class-redefine-model-slots-setf cl-boids-gpu::boid-params)

;;; (defparameter *maxidx* 317)

;;; gui params:

#|
(defparameter *num-boids* nil)
(defparameter *boids-per-click* 20000)
(defparameter *obstacles-lookahead* 2.5)
(defparameter *speed* 2.0)
(let ((fac 3))
  (defparameter *maxspeed* (* fac 0.1))
  (defparameter *maxforce* (* fac 0.0003)))
(defparameter *length* 50)
(defparameter *sepmult* 1)
(defparameter *alignmult* 1)
(defparameter *cohmult* 3)
(defparameter *predmult* 2)
(defparameter *maxlife* 60000.0)
(defparameter *lifemult* 100.0)
|#
 
;;;
;;; obsolete?
;;;
;;; (defparameter *obstacle-ref* #(nil nil nil nil nil)) ;;; player->obstacle-idx lookup


#|
(defparameter *test-cell*
  (make-instance 'value-cell
                 :ref (bp-speed *bp*)
                 :map-fn (lambda (x) (float (* 1 (expt 100 (/ x 127)))))
                 :rmap-fn (lambda (x) (round (* 127 (log x 100))))))

(setf (cellctl::val *test-cell*) 12)

(defparameter *tc2*
  (make-instance 'value-cell
                 :ref (bp-speed *bp*)
                 :map-fn (lambda (x) (float (* 1 (expt 100 (/ x 127)))))
                 :rmap-fn (lambda (x) (round (* 127 (log x 100))))))

|#

