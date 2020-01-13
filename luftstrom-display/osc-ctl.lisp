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
(defparameter *tabletctl* nil)

(defun osc-start ()
  (setf *osc-obst-ctl*
        (incudine.osc:open :direction :input
                           :host *ip-local* :port 3089))
  (setf *osc-obst-ctl-echo*
        (incudine.osc:open :direction :output
                           :host *ip-galaxy*  :port 3090))
  (recv-start *osc-obst-ctl*)
  (if *tabletctl* (clear-refs *tabletctl*))
  (setf *tabletctl* (make-instance 'obstacle-ctl-tablet
                                   :osc-in *osc-obst-ctl*
                                   :osc-out *osc-obst-ctl-echo*)))



;;; (setf (obstacle-x (aref *obstacles* 0)) (* 0.5 *gl-width*))

(defclass obstacle-ctl-tablet ()
  ((osc-in :initarg :osc-in :initform nil :accessor osc-in)
   (osc-out :initarg :osc-out :initform nil :accessor osc-out)
   (num-to-add :initarg :num-to-add :initform (make-instance 'value-cell) :accessor num-to-add)
   (add-time :initarg :add-time :initform (make-instance 'value-cell) :accessor add-time)
   (add-toggle :initarg :add-toggle :initform (make-instance 'value-cell) :accessor add-toggle)
   (o1-pos :initarg :o1-pos :initform (make-instance 'value-cell :val '(0.5 0.5)) :accessor o1-pos)
   (o1-type :initarg :o1-type :initform (make-instance 'value-cell) :accessor o1-type)
   (o1-brightness :initarg :o1-brightness :initform (make-instance 'value-cell) :accessor o1-brightness)
   (o1-active :initarg :o1-active :initform (make-instance 'value-cell) :accessor o1-active)
   (o2-pos :initarg :o2-pos :initform (make-instance 'value-cell :val '(0.5 0.5)) :accessor o2-pos)
   (o2-type :initarg :o2-type :initform (make-instance 'value-cell) :accessor o2-type)
   (o2-brightness :initarg :o2-brightness :initform (make-instance 'value-cell) :accessor o2-brightness)
   (o2-active :initarg :o2-active :initform (make-instance 'value-cell) :accessor o2-active)
   (o3-pos :initarg :o3-pos :initform (make-instance 'value-cell :val '(0.5 0.5)) :accessor o3-pos)
   (o3-type :initarg :o3-type :initform (make-instance 'value-cell) :accessor o3-type)
   (o3-brightness :initarg :o3-brightness :initform (make-instance 'value-cell) :accessor o3-brightness)
   (o3-active :initarg :o3-active :initform (make-instance 'value-cell) :accessor o3-active)
   (o4-pos :initarg :o4-pos :initform (make-instance 'value-cell :val '(0.5 0.5)) :accessor o4-pos)
   (o4-type :initarg :o4-type :initform (make-instance 'value-cell) :accessor o4-type)
   (o4-brightness :initarg :o4-brightness :initform (make-instance 'value-cell) :accessor o4-brightness)
   (o4-active :initarg :o4-active :initform (make-instance 'value-cell) :accessor o4-active)))

(defun string->function (str)
  (symbol-function (intern (string-upcase str))))

(defun osc-pos-out (instance player)
  "control obstacle position of player on tablet."
  (lambda (pos)
;;;    (format t "~&pos:~a" pos)
    (if (osc-out instance)
        (destructuring-bind (x y) pos
          (incudine.osc:message
           (osc-out instance)
           (format nil "/xy~d" player) "ff" (float x) (float y))))))

(defun osc-pos-in (instance player)
  "react to incoming pos of player."
  (make-osc-responder (osc-in instance) (format nil "/xy~d" player) "ff"
                      (lambda (x y)
;;;                        (format t "~&pos-in: ~a" (list x y))
                        (let ((x x) (y y))
                          (setf (val (funcall (string->function (format nil "o~d-pos" player)) instance))
                                (list x y))))))
 
(defun osc-active-out (instance player)
  "control obstacle active toggle of player on tablet."
  (lambda (active)
    (if (osc-out instance)
        (incudine.osc:message
         (osc-out instance)
         (format nil "/obstactive~d" player) "f" (float (if active 1 0))))))

(defun osc-active-in (instance player)
  "react to incoming activation info of player."
  (make-osc-responder (osc-in instance) (format nil "/obstactive~d" player) "f"
   (lambda (active)
;;;     (format t "active: ~a (not (zerop active)): ~a" active (not (zerop active)))
     (setf (val (funcall (string->function (format nil "o~d-active" player)) instance))
           (not (zerop active))))))

(defun osc-brightness-out (instance player)
  "control obstacle brightness of player on tablet."
  (lambda (brightness)
    (if (osc-out instance)
        (incudine.osc:message
         (osc-out instance)
         (format nil "/obstvolume~d" player) "f" (float brightness)))))

(defun osc-brightness-in (instance player)
  "react to incoming brightness of player obstacle."
  (make-osc-responder (osc-in instance) (format nil "/obstvolume~d" player) "f"
   (lambda (brightness)
;;;     (format t "active: ~a (not (zerop active)): ~a" active (not (zerop active)))
     (setf (val (funcall (string->function (format nil "o~d-brightness" player)) instance))
           brightness))))

(defun osc-type-out (instance player)
  "control obstacle type of player on tablet."
  (lambda (type)
    (if (osc-out instance)
        (incudine.osc:message
         (osc-out instance)
         (format nil "/obsttype~d" player) "f" (float type)))))

(defun osc-type-in (instance player)
  "react to incoming type of player obstacle."
  (make-osc-responder (osc-in instance) (format nil "/obsttype~d" player) "f"
   (lambda (type)
;;;     (format t "type: ~a" type)
     (setf (val (funcall (string->function (format nil "o~d-type" player)) instance))
           type))))

;;; (val (funcall (string->function (format nil "o~d-pos" 1)) *tabletctl*))
;;; (val (funcall (string->function (format nil "o~d-active" 1)) *tabletctl*))
;;; (val (funcall (string->function (format nil "o~d-brightness" 1)) *tabletctl*))
;;; (val (funcall (string->function (format nil "o~d-type" 1)) *tabletctl*))

;;; (setf (val (funcall (string->function (format nil "o~d-active" 1)) *tabletctl*)) nil)

;;; (osc-in *tabletctl*)

(defun gl-normalize-pos (pos)
  (destructuring-bind (x y) pos
    (list (/ x cl-boids-gpu::*real-width*) (/ y cl-boids-gpu::*height*))))

(defun gl-denormalize-pos (pos)
  (destructuring-bind (x y) pos
    (list (* x cl-boids-gpu::*real-width*) (* y cl-boids-gpu::*height*))))




(defmethod initialize-instance :after ((instance obstacle-ctl-tablet) &rest args)
  (declare (ignore args))
  (set-refs instance))

(defmethod set-refs ((instance obstacle-ctl-tablet))
  (dotimes (p 4)
    (let* ((player (1+ p))
           (pos (intern (string-upcase (format nil "o~d-pos" player))))
           (active (intern (string-upcase (format nil "o~d-active" player))))
           (brightness (intern (string-upcase (format nil "o~d-brightness" player))))
           (type (intern (string-upcase (format nil "o~d-type" player)))))

      (if (osc-in instance) (osc-pos-in instance player))
      (setf (ref-set-hook (slot-value instance pos))
            (osc-pos-out instance player))
      (set-ref (slot-value instance pos)
               (slot-value (aref *obstacles* (1- player)) 'pos)
               :map-fn #'gl-denormalize-pos
               :rmap-fn #'gl-normalize-pos)

      (if (osc-in instance) (osc-active-in instance player))
      (setf (ref-set-hook (slot-value instance active))
            (osc-active-out instance player))
      (set-ref (slot-value instance active) (slot-value (aref *obstacles* (1- player)) 'active))

      (if (osc-in instance) (osc-brightness-in instance player))
      (setf (ref-set-hook (slot-value instance brightness))
            (osc-brightness-out instance player))
      (set-ref (slot-value instance brightness) (slot-value (aref *obstacles* (1- player)) 'brightness))

      (if (osc-in instance) (osc-type-in instance player))
      (setf (ref-set-hook (slot-value instance type))
            (osc-type-out instance player))
      (set-ref (slot-value instance type) (slot-value (aref *obstacles* (1- player)) 'type)))))

(defmethod clear-refs ((instance obstacle-ctl-tablet))
  (dotimes (p 4)
    (let* ((player (1+ p))
           (pos (intern (string-upcase (format nil "o~d-pos" player))))
           (active (intern (string-upcase (format nil "o~d-active" player))))
           (brightness (intern (string-upcase (format nil "o~d-brightness" player))))
           (type (intern (string-upcase (format nil "o~d-type" player)))))
      (set-ref (slot-value instance pos) nil)
      (set-ref (slot-value instance active) nil)
      (set-ref (slot-value instance brightness) nil)
      (set-ref (slot-value instance type) nil))))

(defun osc-stop ()
  (when *osc-obst-ctl*
    (recv-stop *osc-obst-ctl*)
    (remove-all-responders *osc-obst-ctl*)
    (incudine.osc:close *osc-obst-ctl*)
    (clear-refs *tabletctl*)
    )
  (when *osc-obst-ctl-echo*
    (incudine.osc:close *osc-obst-ctl-echo*)))

(defmacro ensure-osc-echo-msg (&body body)
  `(if *osc-obst-ctl-echo*
       (incudine.osc:message
        *osc-obst-ctl-echo*
        ,@body)))

(defun obst-active (player active)
  (ensure-osc-echo-msg
   (format nil "/obstactive~d" (1+ player)) "f" (float active)))

(defun obst-amp (player amp)
  (ensure-osc-echo-msg
   (format nil "/obstvolume~d" (1+ player)) "f" (float amp)))


(defun obst-xy (player x y)
  (setf luftstrom-display::*last-xy* (list x y))
  (setf (obstacle-pos (aref *obstacles* player)) (list x y)))

(defun obst-type (player type)
  (ensure-osc-echo-msg
   (format nil "/obsttype~d" (1+ player)) "f" (float type)))

;;; (osc-stop)
;;; (osc-start)

#|
(setf *tabletctl*
  (make-instance 'obstacle-ctl-tablet :osc-in *osc-obst-ctl* :osc-out *osc-obst-ctl-echo*))
(setf *tablectl* nil)                                      ;


                                      ;

(ensure-osc-echo-msg                    ;
(format nil "/xy~d" (1+ player)) "ff" (float x) (float y)) ;

(setf (slot-value (aref *obstacles* 0) 'brightness) 
(make-instance 'value-cell :val 0.5))                                ; ; ;

                                ; ; ;

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




|#