;;; 
;;; osc-ctl.lisp
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

(defparameter *osc-obst-ctl* nil)
(defparameter *osc-obst-ctl-echo* nil)

;;; local-comenius: "192.168.67.19"
;;; galaxy-comenius: "192.168.67.20"

;;; (defparameter *ip-galaxy* "192.168.1.15")
;;; (defparameter *ip-local* "192.168.1.14")

;;; (defparameter *ip-galaxy* "192.168.2.20")
;;; (defparameter *ip-local* "192.168.2.35")

;;; (defparameter *ip-galaxy* "192.168.67.20")
;;; (defparameter *ip-galaxy* "192.168.67.21")
;;; (defparameter *ip-local* "192.168.67.19")

;;; (defparameter *ip-galaxy* "192.168.1.200")
;;; (defparameter *ip-local* "192.168.1.188")

(defun map-type (type)
  (aref #(0 2 1 4 3) (round type)))

(defun osc-start ()
  (setf *osc-obst-ctl*
        (incudine.osc:open :direction :input
                           :host *ip-local* :port 3089))
  (setf *osc-obst-ctl-echo*
        (incudine.osc:open :direction :output
                           :host *ip-galaxy*  :port 3090))
  (recv-start *osc-obst-ctl*)
  (when *tabletctl* (set-refs *tabletctl*))
  (make-osc-responder *osc-obst-ctl* "/xy1" "ff"
                      (lambda (x y)
                        (let ((x x) (y y))
                          (set-cell (cl-boids-gpu::boids-add-x cl-boids-gpu::*bp*) x)
                          (set-cell (cl-boids-gpu::boids-add-y cl-boids-gpu::*bp*) (- 1 y))
                          (cl-boids-gpu::gl-enqueue
                           (lambda () 
                             (cl-boids-gpu::set-obstacle-position
                              cl-boids-gpu::*win* 0
                              (* cl-boids-gpu::*real-width* x) (* *height* (- 1 y))))))))
  (make-osc-responder *osc-obst-ctl* "/xy2" "ff"
                      (lambda (x y)
                        (let ((x x) (y y))
                          (set-cell (cl-boids-gpu::boids-add-x cl-boids-gpu::*bp*) x)
                          (set-cell (cl-boids-gpu::boids-add-y cl-boids-gpu::*bp*) (- 1 y))
                          (cl-boids-gpu::gl-enqueue
                           (lambda () 
                             (cl-boids-gpu::set-obstacle-position
                              cl-boids-gpu::*win* 1
                              (* cl-boids-gpu::*real-width* x) (* *height* (- 1 y))))))))
  (make-osc-responder *osc-obst-ctl* "/xy3" "ff"
                      (lambda (x y)
                        (let ((x x) (y y))
                          (set-cell (cl-boids-gpu::boids-add-x cl-boids-gpu::*bp*) x)
                          (set-cell (cl-boids-gpu::boids-add-y cl-boids-gpu::*bp*) (- 1 y))
                          (cl-boids-gpu::gl-enqueue
                           (lambda () 
                             (cl-boids-gpu::set-obstacle-position
                              cl-boids-gpu::*win* 2
                              (* cl-boids-gpu::*real-width* x) (* *height* (- 1 y))))))))
  (make-osc-responder *osc-obst-ctl* "/xy4" "ff"
                      (lambda (x y)
                        (let ((x x) (y y))
                          (set-cell (cl-boids-gpu::boids-add-x cl-boids-gpu::*bp*) x)
                          (set-cell (cl-boids-gpu::boids-add-y cl-boids-gpu::*bp*) (- 1 y))
                          (cl-boids-gpu::gl-enqueue
                           (lambda () 
                             (cl-boids-gpu::set-obstacle-position
                              cl-boids-gpu::*win* 3
                              (* cl-boids-gpu::*real-width* x) (* *height* (- 1 y))))))))
  (make-osc-responder *osc-obst-ctl* "/obsttype1" "f"
                      (lambda (type)
                        (cl-boids-gpu::gl-set-obstacle-type 0 (map-type type))))
  (make-osc-responder *osc-obst-ctl* "/obstactive1" "f"
                      (lambda (obstactive)
                        (case obstactive
                          (0.0 (deactivate-obstacle 0))
                          (otherwise (activate-obstacle 0)))))
  (make-osc-responder *osc-obst-ctl* "/obstvolume1" "f"
                      (lambda (amp)
                        (let* ((player 0)
                               (obstacle (aref *obstacles* player)))
                          (with-slots (brightness radius)
                              obstacle
                            (set-lookahead player (float (n-exp amp 2.5 10.0)))
                            (set-multiplier player (float (n-exp amp 1 1.0)))
                            (setf brightness (n-lin amp 0.2 1.0))))))

  (make-osc-responder *osc-obst-ctl* "/obsttype2" "f"
                      (lambda (type)
                        (cl-boids-gpu::gl-set-obstacle-type 1 (map-type type))))
  (make-osc-responder *osc-obst-ctl* "/obstactive2" "f"
                      (lambda (obstactive)
                        (case obstactive
                          (0.0 (deactivate-obstacle 1))
                          (otherwise (activate-obstacle 1)))))
  (make-osc-responder *osc-obst-ctl* "/obstvolume2" "f"
                      (lambda (amp)
                        (let* ((player 1)
                               (obstacle (aref *obstacles* player)))
                          (with-slots (brightness radius)
                              obstacle
                            (set-lookahead player (float (n-exp amp 2.5 10.0)))
                            (set-multiplier player (float (n-exp amp 1 1.0)))
                            (setf brightness (n-lin amp 0.2 1.0))))))
  
  (make-osc-responder *osc-obst-ctl* "/obsttype3" "f"
                      (lambda (type)
                        (cl-boids-gpu::gl-set-obstacle-type 2 (map-type type))))
  (make-osc-responder *osc-obst-ctl* "/obstactive3" "f"
                      (lambda (obstactive)
                        (case obstactive
                          (0.0 (deactivate-obstacle 2))
                          (otherwise (activate-obstacle 2)))))
  (make-osc-responder *osc-obst-ctl* "/obstvolume3" "f"
                      (lambda (amp)
                        (let* ((player 2)
                               (obstacle (aref *obstacles* player)))
                          (with-slots (brightness radius)
                              obstacle
                            (set-lookahead player (float (n-exp amp 2.5 10.0)))
                            (set-multiplier player (float (n-exp amp 1 1.0)))
                            (setf brightness (n-lin amp 0.2 1.0))))))

  (make-osc-responder *osc-obst-ctl* "/obsttype4" "f"
                      (lambda (type)
                        (cl-boids-gpu::gl-set-obstacle-type 3 (map-type type))))
  (make-osc-responder *osc-obst-ctl* "/obstactive4" "f"
                      (lambda (obstactive)
                        (case obstactive
                          (0.0 (deactivate-obstacle 3))
                          (otherwise (activate-obstacle 3)))))
  (make-osc-responder *osc-obst-ctl* "/obstvolume4" "f"
                      (lambda (amp)
                        (let* ((player 3)
                               (obstacle (aref *obstacles* player)))
                          (with-slots (brightness radius)
                              obstacle
                            (set-lookahead player (float (n-exp amp 2.5 10.0)))
                            (set-multiplier player (float (n-exp amp 1 1.0)))
                            (setf brightness (n-lin amp 0.2 1.0))))))
  (make-osc-responder *osc-obst-ctl* "/addtime" "f"
                      (lambda (time)
                        (setf (add-time *tabletctl*) time)))
  (make-osc-responder *osc-obst-ctl* "/numtoadd" "f"
                      (lambda (num)
                        (setf (num-to-add *tabletctl*) num)))
  (make-osc-responder *osc-obst-ctl* "/addtgl" "f"
                      (lambda (num)
                        (setf (add-toggle *tabletctl*) num)))
  (make-osc-responder *osc-obst-ctl* "/addremove" "f"
                      (lambda (state)
                        (if (= state 1)
                            (format t "~&add-remove")
                            (if (zerop (round (add-toggle *tabletctl*)))
                                (cl-boids-gpu::timer-add-boids
                                 (val (cl-boids-gpu::boids-per-click cl-boids-gpu::*bp*))
                                 1
                                 :origin (list
                                          (val (cl-boids-gpu::boids-add-x cl-boids-gpu::*bp*))
                                          (val (cl-boids-gpu::boids-add-y cl-boids-gpu::*bp*)))
                                 :fadetime (add-time *tabletctl*))
                                (cl-boids-gpu::timer-remove-boids
                                 (val (cl-boids-gpu::boids-per-click cl-boids-gpu::*bp*))
                                 1
                                 :origin (list
                                          (val (cl-boids-gpu::boids-add-x cl-boids-gpu::*bp*))
                                          (val (cl-boids-gpu::boids-add-y cl-boids-gpu::*bp*)))
                                 :fadetime (add-time *tabletctl*)))))))

(defmacro ensure-osc-echo-msg (&body body)
  `(if *osc-obst-ctl-echo*
       (incudine.osc:message
        *osc-obst-ctl-echo*
        ,@body)))

(defun osc-add-time (time)
  (ensure-osc-echo-msg
    "/addtime" "f" (float time)))

(defun osc-num-to-add (num-to-add)
  (ensure-osc-echo-msg
    "/numtoadd" "f" (float num-to-add)))

(defun osc-add-toggle (val)
  (ensure-osc-echo-msg
    "/addtgl" "f" (float val)))

(defun obst-active (player active)
  (ensure-osc-echo-msg
   (format nil "/obstactive~d" (1+ player)) "f" (float active)))

(defun obst-amp (player amp)
  (ensure-osc-echo-msg
   (format nil "/obstvolume~d" (1+ player)) "f" (float amp)))


(defun obst-xy (player x y)
  (setf luftstrom-display::*last-xy* (list x y))
  (ensure-osc-echo-msg
   (format nil "/xy~d" (1+ player)) "ff" (float x) (float y)))

(defun obst-type (player type)
  (ensure-osc-echo-msg
    (format nil "/obsttype~d" (1+ player)) "f" (float type)))

(defclass obstacle-ctl-tablet ()
  ((num-to-add :initarg :num-to-add :initform (make-instance 'value-cell) :accessor num-to-add)
   (add-time :initarg :add-time :initform (make-instance 'value-cell) :accessor add-time)
   (add-toggle :initarg :add-toggle :initform (make-instance 'value-cell) :accessor add-toggle)))

(defmethod (setf val) (value (instance obstacle-ctl-tablet))
  (setf (val (num-to-add instance)) value)
  (osc-num-to-add value))

;; (setf (num-to-add *tabletctl*) 100)

(defmethod (setf num-to-add) (value (instance obstacle-ctl-tablet))
;;  (format t "~&value: ~a" value)
  (setf (val (slot-value instance 'num-to-add)) value))

(defmethod (setf add-time) (value (instance obstacle-ctl-tablet))
  (setf (val (slot-value instance 'add-time)) value)
  (osc-add-time value))

(defmethod (setf add-toggle) (value (instance obstacle-ctl-tablet))
  (setf (val (slot-value instance 'add-toggle)) value)
  (osc-add-toggle value))

(defgeneric num-to-add (instance)
  (:method ((instance obstacle-ctl-tablet))
    (val (slot-value instance 'num-to-add))))

(defgeneric add-time (instance)
  (:method ((instance obstacle-ctl-tablet))
    (val (slot-value instance 'add-time))))

(defgeneric add-toggle (instance)
  (:method ((instance obstacle-ctl-tablet))
    (val (slot-value instance 'add-toggle))))

;;; (set-refs *tabletctl*)

;;; (val (cl-boids-gpu::maxlife cl-boids-gpu::*bp*))

(defmethod initialize-instance :after ((instance obstacle-ctl-tablet) &rest args)
  (declare (ignore args))
  (set-refs instance)
  (setf (ref-set-fn (slot-value instance 'num-to-add))
        #'osc-num-to-add))


(defgeneric set-refs (instance)
  (:method ((instance obstacle-ctl-tablet))
    (set-ref (slot-value instance 'num-to-add) (cl-boids-gpu::boids-per-click cl-boids-gpu::*bp*)
             :map-fn (m-exp-rd-fn 1 500)
             :rmap-fn (m-exp-rd-rev-fn 1 500))
    (set-ref (slot-value instance 'add-time) (cl-boids-gpu::boids-add-time cl-boids-gpu::*bp*)
             :map-fn (m-lin-rd-fn 1 100)
             :rmap-fn (m-lin-rd-rev-fn 1 100))))

(defgeneric remove-refs (instance)
  (:method ((instance obstacle-ctl-tablet))
    (set-ref (slot-value instance 'num-to-add) nil)
    (set-ref (slot-value instance 'add-time) nil)))

;;; (remove-refs *tabletctl*)



;;; (setf (val (num-to-add *tabletctl*)) 1)

(defparameter *tabletctl*
  (make-instance 'obstacle-ctl-tablet))


(defun osc-stop ()
  (when *tabletctl* (remove-refs *tabletctl*))
  (when *osc-obst-ctl*
    (recv-stop *osc-obst-ctl*)
    (remove-all-responders *osc-obst-ctl*)
    (incudine.osc:close *osc-obst-ctl*))
  (when *osc-obst-ctl-echo*
    (incudine.osc:close *osc-obst-ctl-echo*)))



;;; (osc-stop)
;;; (osc-start)
#|



;;; (setf (num-to-add *tabletctl*) 30)

;;; (add-time 34)

;;; (add-toggle 0)

;;; (num-to-add 27)


(cl-boids-gpu::boids-add-x cl-boids-gpu::*bp*)

(obst-active 0 0)
(obst-xy 0 0.1 0.8)
(obst-amp 0 0.6)
(obst-type 0 2)

(progn
  (recv-stop *osc-obst1-ctl*)
  (remove-all-responders *osc-obst1-ctl*)
  (incudine.osc:close *osc-obst1-ctl*))

(incudine.osc:close *osc-obst-ctl-echo*)

(defun obst-xy (player x y)
  "stub when no osc connection"
  (declare (ignore player x y)))



(incudine.osc:message *osc-obst-ctl-echo* "/xy1" "ff" 0.5 0.5)


(cl-boids-gpu::timer-add-boids 2000 20 :origin '(0.5 0.5))

(untrace)

|#
