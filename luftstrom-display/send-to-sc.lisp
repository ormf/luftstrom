;;; 
;;; send-to-sc.lisp
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

(in-package :luftstrom-display)

(cm:rts)
(cm::make-mt-stream cm::*mt-out1* cm::*midi-out1* '(4 0))
(cm:output (cm:new cm::midi-program-change :program 73 :channel 0) :to cm::*mt-out1*)
(cm::initialize-io cm::*mt-out1*)
(setf cm::*rts-out* cm::*mt-out1*)

(defun incudine.scratch::node-free-unprotected ()
  (dotimes (chan 4)
    (cm:output (cm:new cm::midi-control-change :controller cm::+all-notes-off+ :value 0 :channel chan)))
  (incudine:free (incudine:node 0))
  (sc::stop))

(defvar *bufout* (make-array 40000 :element-type 'single-float))

#|
(defun send-to-audio (retrig pos velo)
  (declare (ignore velo))
  (loop
     with count = 0
     for posidx from 0 by 16
     for idx from 0
     for trig across retrig
     if (= trig 1) do (progn
                        (setf (aref *bufout* count)
                              (/ (aref pos (+ 0 (* idx 16))) *width*))
;;                        (format t " ~4,2f" (aref *bufout* count))
                        (setf (aref *bufout* (incf count))
                              (/ (aref pos (+ 1 (* idx 16))) *height*))
;;                        (format t " ~4,2f" (aref *bufout* count))
                        (incf count))
     finally (if (and *net-out* (> count 0))
                 (progn
;;                   (format t "~%")
                   (cffi:with-pointer-to-vector-data (ptr *bufout*)
                     (foreign-write-float *net-out* ptr count))))))


(loop for i below (min 10 num-recv)
             do (let ((x (aref *bufin* (* i 2)))
                      (y (aref *bufin* (1+ (* i 2)))))
;;                  (format t "~&~4,2f ~4,2f " x y)
                  (at (+ (now) (* 1/60 (random 1.0)))
                      (lambda ()
                        (apply #'play-sound (list x y))))))

|#

(defun send-to-audio (retrig pos velo)
  (declare (ignore velo))
  (loop
     with count = 0
     for posidx from 0 by 16
     for idx from 0
     for trig across retrig
     while (< count 10)
     if (= trig 1) do (let ((x (/ (aref pos (+ 0 (* idx 16))) *width*))
                            (y (/ (aref pos (+ 1 (* idx 16))) *height*)))
                        (incf count)
                        (at (+ (now) (* 1/60 (random 1.0)))
                          (lambda ()
                            (apply #'play-sound (list x y)))))))

(defparameter *print* nil)
;; (setf *print* nil)

(defun sign ()
  (* 2 (- 0.5 (random 2))))

(defun play-sound (x y)
  (if *print*
      (format t "x: ~4,2f, y: ~4,2f~%" x y)))
#|
((bus-idx bus-number)
pitch amp dur (env envelope) decay-start decay-end lfo-freq x-pos y-pos)
|#

#|

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.8 y))
   :amp (* (sign) (random 0.2))
   :dur 0.2
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
   :x-pos x
   :y-pos y
   :head 200))


(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.8 y))
   :amp (* (sign) (random 0.2))
   :dur 0.2
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.8 y))
   :amp (* (sign) (random 0.02))
   :dur 0.6
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 100 (expt 1.3 (+ 2 (* (round (* 7 y))))))
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.2 y))
   :amp (* (sign) (random 0.02))
   :dur 0.6
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 50 (expt (+ 1 (* (round (* 17 y)))) 1.01))
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.7 y))
   :amp (* (sign) (random 0.02) (- 1 y))
   :dur 0.6
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 50 (expt (+ 1 (* (round (* 17 y)))) 0.9))
   :x-pos x
   :y-pos y
   :head 200))


(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.8 y))
   :amp (* (sign) (random 0.2))
   :dur 0.01
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 100 (expt 1.3 (+ 2 (* (round (* 17 y))))))
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.3 (* 0.2 y))
   :amp (* (sign) (random 0.02))
   :dur 0.2
   :suswidth 1
   :suspan 0
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 2 (expt (+ x 1.3713) (+ 2 (* (round (* 7 x))))))
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.3 (* 0.2 y))
   :amp (* (sign) (random 0.2))
   :dur 0.02
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 2 (expt (+ y 1.3713) (+ 2 (* (round (* 7 y))))))
   :x-pos x
   :y-pos y
   :head 200))


(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.7 y))
   :amp (* (sign) (random 4))
   :dur 0.002
   :suswidth 0.99
   :suspan 0.5
   :decay-start 0.001
   :decay-end 0.035
   :lfo-freq 10
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.7 y))
   :amp (* (sign) (random 4))
   :dur 0.00002
   :suswidth 0.99
   :suspan 0.5
   :decay-start 0.0000001
   :decay-end 0.0000001
   :lfo-freq 10
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch 0.5
   :amp (* (sign) 2)
   :dur 1
   :suswidth 1
   :suspan 0
   :decay-start 0.5
   :decay-end 0.06
   :lfo-freq 0.1
   :x-pos x
   :y-pos y
   :head 200))


;;; Drums:

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.5 (* 0.1 y))
   :amp (* (sign) 2)
   :dur 1
   :suswidth 1
   :suspan 0
   :decay-start 0.5
   :decay-end 0.06
   :lfo-freq 1
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.2 (* 1 y))
   :amp (* (sign) 2)
   :dur 0.002
   :suswidth 0
   :suspan 0
   :decay-start 0.0005
   :decay-end 0.002
   :lfo-freq 1
   :x-pos x
   :y-pos y
   :ioffs 0.00
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.5 (* 0.1 y))
   :amp (* (sign) 2)
   :dur 2
   :suswidth 0
   :suspan 0
   :decay-start 0.13
   :decay-end 0.2
   :lfo-freq 10
   :x-pos x
   :y-pos y
   :ioffs 0.01
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.2 (* 1 y))
   :amp (* (sign) 2)
   :dur 1
   :suswidth 0
   :suspan 0
   :decay-start 0.0005
   :decay-end 0.002
   :lfo-freq 10
   :x-pos x
   :y-pos y
   :ioffs 0.00
   :head 200))


(boids)
(/ 172.0)

(let ((x 0.5) (y 1))
  (sc-user::sc-lfo-click-2d-out
   :pitch 0.5
   :amp (* (sign) 2)
   :dur 1
   :suswidth 1
   :suspan 0
   :decay-start 0.0001
   :decay-end 0.5
   :lfo-freq 0.1
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.2 y))
   :amp (* (sign) (+ (* 0.003 (expt 16 (- 1 y))) (random 0.01)))
   :dur 1.6
   :suswidth 0.4
   :suspan 0.2
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) 0.9))
   :x-pos x
   :y-pos y
   :head 200))


(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.2 y))
   :amp (* (sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
   :dur 1.6
   :suswidth 0.4
   :suspan 0.2
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) 0.9))
   :x-pos x
   :y-pos y
   :head 200))

(progn
;;; 540 boids
  (let ((fac 3))
    (defparameter *maxspeed* (* fac 0.1))
    (defparameter *maxforce* (* fac 0.0003)))
  (defparameter *maxidx* 317)
  (defparameter *length* 5)

  (defparameter *sepmult* 1)
  (defparameter *alignmult* 1)
  (defparameter *cohmult* 3)
  (defparameter *predmult* 2)
  (defparameter *platform* nil)
  (defparameter *maxlife* 60000.0)
  (defparameter *lifemult* 1000.0)
  (defparameter *width* 640)
  (defparameter *height* 480)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.2 y))
     :amp (* (sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
     :dur 1.6
     :suswidth 0.8
     :suspan 0.5
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
     :x-pos x
     :y-pos y
;;     :filt-freq (* 2000 (expt 10 (- 1 y)))
     :head 200)))

(progn
;;; 540 boids
  (let ((fac 3))
    (defparameter *maxspeed* (* fac 0.1))
    (defparameter *maxforce* (* fac 0.0003)))
  (defparameter *maxidx* 317)
  (defparameter *length* 5)

  (defparameter *sepmult* 1)
  (defparameter *alignmult* 1)
  (defparameter *cohmult* 3)
  (defparameter *predmult* 2)
  (defparameter *platform* nil)
  (defparameter *maxlife* 60000.0)
  (defparameter *lifemult* 1000.0)
  (defparameter *width* 640)
  (defparameter *height* 480)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.2 y))
     :amp (* (sign) (+ (* 0.01 (expt 16 (- 1 y))) (random 0.003)))
     :dur 1.6
     :suswidth 0.8
     :suspan 0.5
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
     :x-pos x
     :y-pos y
     :wet (+ 0.5 (* 0.5 x))
     :filt-freq (* 2000 (expt 10 y))
     :head 200)))

(progn
;;; 540 boids
  (let ((fac 3))
    (defparameter *maxspeed* (* fac 0.1))
    (defparameter *maxforce* (* fac 0.0003)))
  (defparameter *maxidx* 317)
  (defparameter *length* 5)

  (defparameter *sepmult* 1)
  (defparameter *alignmult* 1)
  (defparameter *cohmult* 3)
  (defparameter *predmult* 2)
  (defparameter *platform* nil)
  (defparameter *maxlife* 60000.0)
  (defparameter *lifemult* 1000.0)
  (defparameter *width* 640)
  (defparameter *height* 480)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.2 y))
     :amp (* (sign) (+ (* 0.01 (expt 16 (- 1 y))) (random 0.003)))
     :dur 1.6
     :suswidth 0.8
     :suspan 0.5
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
     :x-pos x
     :y-pos y
     :wet (+ 0.5 (* 0.5 y))
     :filt-freq (* 200 (expt 10 y))
     :head 200)))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.2 y))
   :amp (* (sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
   :dur 1.6
   :suswidth 0.8
   :suspan 0.5
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
   :x-pos x
   :y-pos y
   :head 200))


(defparameter *test* t)


(progn
;;; 5400 boids in 1200x800!!! 
  
(let ((fac 1.5))
  (defparameter *maxspeed* (* fac 0.1))
  (defparameter *maxforce* (* fac 0.003)))
(defparameter *maxidx* 317)
(defparameter *length* 5)

(defparameter *sepmult* 2)
(defparameter *alignmult* 5)
(defparameter *cohmult* 5)
(defparameter *predmult* 1)
(defparameter *platform* nil)
(defparameter *maxlife* 60000.0)
(defparameter *lifemult* 200.0)
(defparameter *width* 1200)
(defparameter *height* 800)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.2 y))
     :amp (* (sign) (+ (* 0.01 (expt 16 (- 1 y))) (random 0.003)))
     :dur 1.6
     :suswidth 0.8
     :suspan 0.5
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
     :x-pos x
     :y-pos y
     :wet (+ 0.5 (* 0.5 y))
     :filt-freq (* 200 (expt 10 y))
     :head 200)))

(progn
;;; 5400 boids in 1200x800!!! 
  
(let ((fac 3))
  (defparameter *maxspeed* (* fac 0.1))
  (defparameter *maxforce* (* fac 0.001)))
(defparameter *maxidx* 317)
(defparameter *length* 5)

(defparameter *sepmult* 2)
(defparameter *alignmult* 1)
(defparameter *cohmult* 1)
(defparameter *predmult* 1)
(defparameter *platform* nil)
(defparameter *maxlife* 60000.0)
(defparameter *lifemult* 200.0)
(defparameter *width* 1200)
(defparameter *height* 800)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.2 y))
     :amp (* (sign) (+ (* 0.01 (expt 16 (- 1 y))) (random 0.003)))
     :dur 1.6
     :suswidth 0.8
     :suspan 0.5
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
     :x-pos x
     :y-pos y
     :wet (+ 0.5 (* 0.5 y))
     :filt-freq (* 200 (expt 10 y))
     :head 200)))
|#
