(in-package :luftstrom)

(boids)
(qt-gui:start-gui)
(cm:rts)

(defun my-nanoctl-receiver (name idx value)
  (format t "~a: ~a ~a~%" name idx value))



(qt-gui:set-receiver!
 :nanoctl01
 (lambda (name idx value)
   (case name
     (:nanoctl01
      (case idx
        (0 (setf *sepmult* (/ value 25)))
        (1 (setf *alignmult* (/ value 25)))
        (2 (setf *cohmult* (/ value 25)))
        (3 (if (< value 50)
               (setf cl-boids-gpu::*curr-kernel* "boids")
               (setf cl-boids-gpu::*curr-kernel* "boids_reflection2")))
        (4 (setf *length* (max 1 (/ value 1))))
        (5 (setf *length* (max 1 (/ value 1))))
        (6 (setf *length* (max 1 (/ value 1))))
        (7 (setf *length* (max 1 (/ value 1))))
        (8 (setf *length* (max 1 (/ value 1))))
        (9 (setf *length* (max 1 (/ value 1))))
        (10 (setf *length* (max 1 (/ value 1))))
        (11 (setf *length* (max 1 (/ value 1))))
        (12 (setf *length* (max 1 (/ value 1))))
        (13 (setf *length* (max 1 (/ value 1))))
        (14 (setf *maxforce* (max 0.01 (/ value 100))))
        (15 (setf *maxspeed* (max 0.5 (/ value 25))))))))                     
                      )

(defparameter *sepmult* 1.5)
(defparameter *alignmult* 1)
(defparameter *cohmult* 1)


(qt-gui:stop-receiver! :nanoctl01)


(set-receiver!
   (lambda (st d1 d2)
     (case (status->opcode st)
       (:cc (if (<= d1 8)
                (qt-gui::set-value (aref (qt-gui::sliders (qt-gui::find-gui :nanoctl01)) d1) (round (* d2 99/127)))
                (qt-gui::set-value (aref (qt-gui::sliders (qt-gui::find-gui :nanoctl01)) (- d1 8)) (round (* d2 99/127)))
              ))))              
   *midi-in1*
   :format :raw)

;;;;
;;;;
;;;;
;;;;
;;;;
;;;;
;;;; qtools Beispiel:
;;;;
;;;;
;;;;
;;;;
;;;;


(defvar *controller* NIL)

(define-object controller (QObject)
  ((queue :initform NIL :accessor queue)))

(define-signal (controller process-queue) ())

(define-slot (controller process-queue) ()
  (declare (connected controller (process-queue)))
  (loop for function = (pop (queue controller))
        while function
        do (funcall function)))

(defun call-with-controller (function &optional (controller *controller*))
  (push function (queue controller))
  (signal! controller (process-queue)))

(defmacro with-controller ((&optional (controller '*controller*)) &body
body)
  `(call-with-controller (lambda () ,@body) ,controller))
(defmacro with-controller ((&optional (controller '*controller*)) &body
body)
  `(call-with-controller (lambda () ,@body) ,controller))

;;; From the REPL
(with-main-window (controller 'controller :show NIL :main-thread T
:blocking NIL)
  (q+:qapplication-set-quit-on-last-window-closed NIL)
  (setf *controller* controller))

(with-controller ()
  (q+:show (q+:make-qwidget)))

(with-controller ()
  (q+:show (q+:make-qpushbutton "Hey")))


