;;; 
;;; obstacle-ctl-tablet.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2020 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
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

(defparameter *tabletctl* nil)

(defclass obstacle-ctl-tablet (osc-controller)
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

;;; (remove-osc-controller :tab1)
;;; (if *tabletctl* (clear-refs *tabletctl*))

;;; (setf (obstacle-x (aref *obstacles* 0)) (* 0.5 *gl-width*))

(defun string->function (str)
  (symbol-function (intern (string-upcase str))))

(defun osc-pos-out (instance player)
  "control obstacle position of player on tablet."
  (lambda (pos)
;;;    (format t "~&pos:~a" pos)
    (if (osc-out instance)
        (destructuring-bind (x y) pos
          (at (now)
            (lambda ()
              (incudine.osc:message
               (osc-out instance)
               (format nil "/xy~d" player) "ff" (float x) (float y))))))))

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
         (format nil "/obstvolume~d" player) "f" (float (funcall (n-lin-rev-fn 0.2 1) brightness))))))

(defun osc-brightness-in (instance player)
  "react to incoming brightness of player obstacle."
  (make-osc-responder
   (osc-in instance) (format nil "/obstvolume~d" player) "f"
   (lambda (brightness)
;;;     (format t "~&brightness: ~a, ~a" brightness (funcall (n-lin-rev-fn 0.2 1) brightness))
     (setf (val (funcall
                 (string->function (format nil "o~d-brightness" player))
                 instance))
           (funcall (n-lin-fn 0.2 1) brightness)))))

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
;;     (format t "type: ~a" type)
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
    (list (/ x cl-boids-gpu::*real-width*) (/ y cl-boids-gpu::*real-height*))))

(defun gl-denormalize-pos (pos)
  (destructuring-bind (x y) pos
    (list (* x cl-boids-gpu::*real-width*) (* y cl-boids-gpu::*real-height*))))

(defmethod register-osc-responders ((instance obstacle-ctl-tablet))
  (with-slots (osc-in responders) instance
    (format t "~&registering tablet responders for ~a~%" osc-in)
    (push (make-osc-responder
           osc-in "/addremove" "f"
           (lambda (state)
             (if (= state 1)
                 (format t "~&add-remove")
                 (if (zerop (round (val (add-toggle *tabletctl*))))
                     (cl-boids-gpu::timer-add-boids
                      (val (cl-boids-gpu::boids-per-click cl-boids-gpu::*bp*))
                      1
                      :origin (list
                               (* *gl-width* (val (cl-boids-gpu::boids-add-x cl-boids-gpu::*bp*)))
                               (* -1 *gl-height* (val (cl-boids-gpu::boids-add-y cl-boids-gpu::*bp*))))
                      :fadetime (val (add-time *tabletctl*)))
                     (cl-boids-gpu::timer-remove-boids
                      (val (cl-boids-gpu::boids-per-click cl-boids-gpu::*bp*))
                      1
                      :origin (list
                               (val (cl-boids-gpu::boids-add-x cl-boids-gpu::*bp*))
                               (val (cl-boids-gpu::boids-add-y cl-boids-gpu::*bp*)))
                      :fadetime (val (add-time *tabletctl*)))))))
          responders)
    (push
     (make-osc-responder
      osc-in "/addtime" "f"
      (lambda (addtime-val)
        (let ((time (m-exp-zero addtime-val 0.01 100)))
          (setf (val (add-time *tabletctl*)) time)
          (format t "~&addtime: ~,2f~%" time))))
     responders)
    (push
     (make-osc-responder
      osc-in "/numtoadd" "f"
      (lambda (num)
        (setf (val (num-to-add *tabletctl*)) num)
        (format t "~&numtoadd: ~a~%" (funcall (m-exp-rd-fn 1 500) num))))
     responders)
    (push
     (make-osc-responder
      osc-in "/addtgl" "f"
      (lambda (num)
        (setf (val (add-toggle *tabletctl*)) num)
        (format t "~&addtoggle: ~a~%" num)))
     responders)
    (dotimes (player-ref 4)
      (let ((player (1+ player-ref)))
        (if (osc-in instance)
            (map nil (lambda (fn) (push (funcall fn instance player) responders))
                 (list #'osc-pos-in #'osc-active-in #'osc-brightness-in #'osc-type-in)))))))

(defgeneric set-refs (instance)
  (:documentation "set the refs of value cells in instance.")
  (:method ((instance obstacle-ctl-tablet))
    (dotimes (p 4)
      (let* ((player (1+ p))
             (pos (intern (string-upcase (format nil "o~d-pos" player))))
             (active (intern (string-upcase (format nil "o~d-active" player))))
             (brightness (intern (string-upcase (format nil "o~d-brightness" player))))
             (type (intern (string-upcase (format nil "o~d-type" player)))))
        (setf (ref-set-hook (slot-value instance pos))
              (osc-pos-out instance player))
        (set-ref (slot-value instance pos)
                 (slot-value (aref *obstacles* (1- player)) 'pos))
        (setf (ref-set-hook (slot-value instance active))
              (osc-active-out instance player))
        (set-ref (slot-value instance active)
                 (slot-value (aref *obstacles* (1- player)) 'active))
        (setf (ref-set-hook (slot-value instance brightness))
              (osc-brightness-out instance player))
        (set-ref (slot-value instance brightness)
                 (slot-value (aref *obstacles* (1- player)) 'brightness))
        (setf (ref-set-hook (slot-value instance type))
              (osc-type-out instance player))
        (set-ref (slot-value instance type) (slot-value (aref *obstacles* (1- player)) 'type)
                 :map-fn #'map-type
                 :rmap-fn #'rmap-type)))
    (set-ref (slot-value instance 'add-toggle) nil)
    (set-ref (slot-value instance 'add-time) nil)
    (set-ref (slot-value instance 'num-to-add)
             (cl-boids-gpu::boids-per-click cl-boids-gpu::*bp*)
             :map-fn (m-exp-rd-fn 1 500)
             :rmap-fn (m-exp-rd-rev-fn 1 500))
    (setf (ref-set-hook (slot-value instance 'num-to-add))
          (lambda (num)
            (if (osc-out instance)
                (incudine.osc:message
                 (osc-out instance)
                 "/numtoadd" "f" (float num)))))
    (setf (ref-set-hook (slot-value instance 'add-time))
          (lambda (num)
            (if (osc-out instance)
                (incudine.osc:message
                 (osc-out instance)
                 "/addtime" "f" (float num)))))
    (setf (ref-set-hook (slot-value instance 'add-toggle))
          (lambda (num)
            (if (osc-out instance)
                (incudine.osc:message
                 (osc-out instance)
                 "/addtoggle" "f" (float num)))))))

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
      (set-ref (slot-value instance type) nil))
    (set-ref (slot-value instance 'add-toggle) nil)
    (set-ref (slot-value instance 'add-time) nil)
    (set-ref (slot-value instance 'num-to-add) nil)))


(defmethod initialize-instance :after ((instance obstacle-ctl-tablet) &rest args)
  (declare (ignore args))
  (format t "~&init-instance-specific~%")
  (set-refs instance))

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

;;; (obstacle-pos (aref *obstacles* 0))

(defun obst-type (player type)
  (ensure-osc-echo-msg
    (format nil "/obsttype~d" (1+ player)) "f" (float type)))

