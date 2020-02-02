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

(defun rmap-type (type)
  (aref #(0 2 1 4 3) (round type)))

(defparameter *osc-in1* nil)
(defparameter *osc-out1* nil)
(defparameter *osc-debug* nil)


;;; central registry for osc controllers

(defparameter *osc-controllers* (make-hash-table :test #'equal)
  "hash-table which stores all currently active osc controllers by id
  and an entry for all used osc-ins of the active controllers by
  pushing the controller instance to the 'osc-in entry of this
  hash-table. Maintenance of *osc-controllers* is done within the
  midi-controller methods.")

(defclass osc-controller ()
  ((id :initform nil :initarg :id :accessor id)
   (gui :initform nil :initarg :gui :accessor gui)
   (osc-in :initform *osc-in1* :initarg :osc-in :accessor osc-in)
   (osc-out :initform *osc-out1* :initarg :osc-out :accessor osc-out)
   (remote-ip :initform "192.168.1.1" :initarg :remote-ip :accessor remote-ip)
   (remote-port :initform 3000 :initarg :remote-port :accessor remote-port)
   (responders :initform nil :initarg :responders :accessor responders))
  (:documentation "generic class for osc-controllers. An instance
  should get initialized with #'add-osc-controller and get removed
  with #'remove-osc-controller, using its id as argument in order to
  close the gui and remove its handler functions from
  *osc-controllers*."))

#|
(defgeneric init-osc-in (osc-controller)
  (:documentation "set up osc responders")
  (:method ((instance osc-controller))
    (declare (ignore instance))))
|#

(defgeneric (setf osc-input) (new-osc-in instance)
  (:documentation "(re)set the osc input of controller instance.")
  (:method (new-osc-in (instance osc-controller))
    (if (member instance (gethash (osc-in instance) *osc-controllers*))
        (setf (gethash (osc-in instance) *osc-controllers*)
              (delete instance (gethash (osc-in instance) *osc-controllers*)))
        (warn "couldn't remove osc-controller ~a" instance))
    (setf (slot-value instance 'osc-in) new-osc-in)
    (push instance (gethash new-osc-in *osc-controllers*))
    (remove-osc-responders instance)))

(defgeneric remove-osc-responders (instance)
  (:documentation "unregister the receiver fns of osc-responders.")
  (:method ((instance osc-controller))
    (dolist (responder (responders instance))
      (remove-responder responder))))

(defgeneric register-osc-responders (instance)
  (:documentation
   "define osc-handlers and register them in the 'responders slot.")
  (:method ((instance osc-controller))
    (declare (ignore instance))))

;;; (make-instance 'osc-controller)

(defmethod init-gui-callbacks ((instance osc-controller) &key (echo t))
  (declare (ignore instance echo)))

(defmethod initialize-instance :after ((instance osc-controller) &rest args)
  (declare (ignorable args))
;;  (break "init-instance :after ~a" instance)
  (with-slots (id remote-ip remote-port osc-out) instance
    (setf osc-out (incudine.osc:open
                   :direction :output
                   :host remote-ip
                   :port remote-port))
    (format t "~&general init-instance, oscctl-id: ~a ~%" id)
    (if (gethash id *osc-controllers*)
        (warn "id already used: ~a" id)
        (progn
          (push instance (gethash (osc-in instance) *osc-controllers*))
          (setf (gethash id *osc-controllers*) instance)
          (register-osc-responders instance)))))

(defgeneric clear-refs (instance)
  (:documentation "clear the refs of value cells in instance.")
  (:method ((instance osc-controller))
    (declare (ignore instance))))


(defun add-osc-controller (class &rest args)
  "register osc-controller by id and additionally by pushing it onto
the hash-table entry of its osc-input."
  (let ((instance (apply #'make-instance class args)))
    (with-slots (id) instance
      (if (gethash id *osc-controllers*)
          (warn "id already used: ~a" id)
          (progn
            (push instance (gethash (osc-in instance) *osc-controllers*))
            (setf (gethash id *osc-controllers*) instance))))))

(defun remove-osc-controller (id)
  (let ((instance (gethash id *osc-controllers*)))
    (if instance
        (with-slots (osc-in osc-out) instance
          (format t "~&removing: ~a~%" id)
          (if (member instance (gethash osc-in *osc-controllers*))
              (progn
                (setf (gethash osc-in *osc-controllers*)
                      (delete instance (gethash osc-in *osc-controllers*)))
                (remhash id *osc-controllers*))
              (warn "osc-controller not registered in osc-in ~a" instance))
          (when osc-out
            (recv-stop osc-out)
            (incudine.osc:close osc-out))
          (remove-osc-responders instance)
          (clear-refs instance)
;;;          (remove-all-responders osc-out))
)
        (warn "osc-controller ~S not registered!" id))))

(defun find-osc-controller (id)
  (gethash id *osc-controllers*))

(defun ensure-osc-controller (id)
  (let ((controller (gethash id *osc-controllers*)))
    (if controller
        controller
        (error "controller ~S not found!" id))))

;;; (ensure-osc-controller :ewi1)
;;; (setf *osc-debug* nil)

(defun osc-start ()
  (unless *osc-obst-ctl*
    (setf *osc-obst-ctl*
          (incudine.osc:open :direction :input
                             :host *ip-local* :port 3089)))
  (unless *osc-obst-ctl-echo*
    (setf *osc-obst-ctl-echo*
          (incudine.osc:open :direction :output
                             :host *ip-galaxy*  :port 3090)))
  (recv-start *osc-obst-ctl*))

(defun osc-stop ()
  (when *osc-obst-ctl*
    (recv-stop *osc-obst-ctl*)
    (remove-all-responders *osc-obst-ctl*)
    (incudine.osc:close *osc-obst-ctl*)
    (clear-refs *tabletctl*)
    )
  (when *osc-obst-ctl-echo*
    (incudine.osc:close *osc-obst-ctl-echo*)))

;;; start tabletctl

(defparameter *tabletctl* nil)

(defun start-osc-receive (input)
  "general receiver/dispatcher for all osc input of input arg. On any
osc input it scans all elems of *osc-controllers* and calls their
handle-osc-in method in case the event's osc channel matches the
controller's channel."
  (set-receiver!
     (lambda (st d1 d2)
       (if *osc-debug*
           (format t "~&~S ~a ~a ~a~%" (status->opcode st) d1 d2 (status->channel st)))
       (let ((chan (status->channel st)))
         (dolist (controller (gethash input *osc-controllers*))
           (if (= chan (chan controller))
               (handle-osc-in controller (status->opcode st) d1 d2)))))
     input
     :format :raw))


  
;;; (setf (obstacle-x (aref *obstacles* 0)) (* 0.5 *gl-width*))

#|
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
    (list (/ x cl-boids-gpu::*real-width*) (/ y cl-boids-gpu::*real-height*))))

(defun gl-denormalize-pos (pos)
  (destructuring-bind (x y) pos
    (list (* x cl-boids-gpu::*real-width*) (* y cl-boids-gpu::*real-height*))))

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
               (slot-value (aref *obstacles* (1- player)) 'pos))
      (if (osc-in instance) (osc-active-in instance player))
      (setf (ref-set-hook (slot-value instance active))
            (osc-active-out instance player))
      (set-ref (slot-value instance active)
               (slot-value (aref *obstacles* (1- player)) 'active))
      (if (osc-in instance) (osc-brightness-in instance player))
      (setf (ref-set-hook (slot-value instance brightness))
            (osc-brightness-out instance player))
      (set-ref (slot-value instance brightness)
               (slot-value (aref *obstacles* (1- player)) 'brightness))
      (if (osc-in instance) (osc-type-in instance player))
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
               "/addtoggle" "f" (float num))))))

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



(defmacro ensure-osc-echo-msg (&body body)
  `(if *osc-obst-ctl-echo*
       (incudine.osc:message
        *osc-obst-ctl-echo*
        ,@body)))

;;; end Tabletctl
|#

;;; (osc-stop)
;;; (osc-start)

#|
(setf *tabletctl*
  (make-instance 'obstacle-ctl-tablet))
(setf *tablectl* nil)                                      
(setf (val (slot-value *tabletctl* 'num-to-add)) 70)
(setf (val (slot-value *tabletctl* 'add-time)) 0)


(set-refs *tabletctl*)0

(clear-refs *tabletctl*)

(setf (slot-value *tabletctl* 'add-time) (make-instance 'cellctl::value-cell))
(setf (slot-value *tabletctl* 'num-to-add) (make-instance 'cellctl::value-cell))
(obstacle-pos (aref *obstacles* 0))                                      ; ;

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
