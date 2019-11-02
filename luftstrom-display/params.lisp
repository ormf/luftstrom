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

(in-package #:luftstrom-display)

(defparameter *basedir* nil)

(defparameter *presets-file* nil)
(defparameter *audio-presets-file* nil)
(defparameter *bs-presets-file* nil)

(defparameter *curr-boid-state* (make-instance 'cl-boids-gpu::boid-system-state))
(defparameter *clockinterv* 2) ;;; speedlim for successive events (in pictureframes)
(defparameter *bg-amp* 1)

(defparameter *audio-ref* 0) ;;; current player ref (determined by beatstep button).

(setf cl-boids-gpu::*trig* nil)

(setf *num-boids* 0)
(setf *show-fps* nil)
(setf *platform* nil)
(setf *context* nil)
(setf *programs* nil)
(setf *kernels* nil)

(setf *obstacles* nil)

(setf *command-queues* nil)
(setf *buffers* nil)
(setf *width* 720)
(setf *height* 405)
(setf *gl-scale* 0.45)
(setf *pixelsize* 5)

(setf *boids-per-click* 100)
;;; (setf *curr-kernel* "boids_reflection2")
(setf *curr-kernel* "boids")
(setf *boids-per-click* 5000)
(setf *boids-per-click* 1000)
(setf *boids-per-click* 150)
(setf *boids-per-click* 1000)
(setf *boids-per-click* 10)
;;(setf *boids-per-click* 1)
(setf *boids-maxcount* 20000)
(setf *max-obstacles* 16)
(setf *obstacles-lookahead* 4.0)
(setf *speed* 2.0)
(setf *positions* nil)
(setf *obstacle-board* nil)
(setf *obstacles-type* nil)
(setf *obstacles-pos* nil)
(setf *obstacles-radius* nil)
(setf *board* nil)
(setf *colors* nil)
(setf *align-board* nil)
(setf *board-dx* nil)
(setf *board-dy* nil)
(setf *board-dist* nil)
(setf *board-sep* nil)
(setf *board-coh* nil)
(setf *weight-board* nil)
(setf *bidx* nil)
(setf *velocities* nil)
(setf *forces* nil)
(setf *life* nil)
(setf *retrig* nil)
(setf *update* t)
(setf *fg-color* '(0.6 0.6 0.6 0.6))
(setf *first-boid-color* '(1.0 0.0 0.0 0.6))

(let ((fac 15.5))
  (setf *maxspeed* (* fac 0.1))
  (setf *maxforce* (* fac 0.003)))
(setf *maxidx* 317)
(setf *length* 5)

(setf *sepmult* 2)
(setf *alignmult* 1)
(setf *cohmult* 1)
(setf *predmult* 10)
(setf *platform* nil)
(setf *maxlife* 60000.0)
(setf *lifemult* 100.0)
(setf *max-events-per-tick* 10)

#|
(loop for param in
     '(*speed* *obstacles-lookahead*
       *maxspeed* *maxforce* *maxidx* *length*
       *sepmult* *alignmult* *cohmult* *predmult* *maxlife*
       *lifemult* *max-events-per-tick*)
   do (format t "~&(setf cl-boids-gpu::~a ~a)~%" param (symbol-value param)))
|#

;;;; Audio Parameter: die ...fn* Parameter enthalten die Funktionen,
;;;; die ...tmpl* Parameter die Templates mit den Funktionsbodys, für
;;;; die gilt, dass x und y bereits in der umgebenden closure an dei
;;;; jeweiligen normalisierten x/y Koordinaten des boids gebunden
;;;; sind. Die Umwandlung der Templates mit den bodies in die
;;;; Funktionen geschieht mit dem param-templates->function Macro.

;;; the fn parameters are set below with (param-templates->functions)

(defparameter *p1* nil)
(defparameter *p2* nil)
(defparameter *p3* nil)
(defparameter *p4* nil)
(defparameter *pitchfn* nil)
(defparameter *ampfn* nil)
(defparameter *durfn* nil)
(defparameter *suswidthfn* nil)
(defparameter *suspanfn*  nil)
(defparameter *decay-startfn*  nil)
(defparameter *decay-endfn*  nil)
(defparameter *lfo-freqfn* nil)
(defparameter *x-posfn* nil)
(defparameter *y-posfn* nil)
(defparameter *ioffsfn* nil)
(defparameter *wetfn* nil)
(defparameter *filt-freqfn* nil)
(defparameter *head* 200)

(defparameter *pitchtmpl* '(+ 0.2 (* 0.6 y)))
(defparameter *amptmpl* 0.8)
(defparameter *durtmpl* 0.5)
(defparameter *suswidthtmpl* 0)
(defparameter *suspantmpl*  0)
(defparameter *decay-starttmpl* 0.001)
(defparameter *decay-endtmpl*  0.0035)
(defparameter *lfo-freqtmpl* 1)
(defparameter *x-postmpl* 0.5)
(defparameter *y-postmpl* 0.6)
(defparameter *ioffstmpl* 0)
(defparameter *wettmpl* 1)
(defparameter *filt-freqtmpl* 20000)

(defmacro expand-param-fn (name def)
  `(setf ,name
         (lambda (x y)
           (declare (ignorable x y))
           ,(symbol-value def))))

#|
(mapcar 
     (lambda (elem)
       (destructuring-bind (param-template function-name) elem
         (format t "~&~a -> ~a~%" param-template function-name)
         `(setf ,function-name
                (lambda (x y)
                  (declare (ignorable x y))
                  ,(symbol-value param-template)))))
     '((*pitchtmpl* *pitchfn*)
       (*amptmpl* *ampfn*)
       (*durtmpl* *durfn*)
       (*suswidthtmpl* *suswidthfn*)
       (*suspantmpl* *suspanfn*)
       (*decay-starttmpl* *decay-startfn*)
       (*decay-endtmpl* *decay-endfn*)
       (*lfo-freqtmpl* *lfo-freqfn*)
       (*x-postmpl* *x-posfn*)
       (*y-postmpl* *y-posfn*)
       (*ioffstmpl* *ioffsfn*)
       (*wettmpl* *wetfn*)
       (*filt-freqtmpl* *filt-freqfn*))) 
|#

