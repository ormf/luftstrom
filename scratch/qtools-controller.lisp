(in-package #:qt-gui)
(in-readtable :qtools)

(defvar *controller* NIL)

(define-widget controller (QObject)
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

#|
;;; From the REPL
(with-main-window (controller 'controller
                              :show NIL :main-thread T
                              :blocking NIL)
  (q+:qapplication-set-quit-on-last-window-closed NIL)
  (setf *controller* controller))

(define-widget levelmeter (QWidget)
  ((level :initarg :level :initform 50 :accessor level)))

(define-override (levelmeter paint-event) (ev)
  (declare (ignore ev))
  (with-finalizing ((painter (q+:make-qpainter levelmeter)))
    (setf (q+:pen painter) (q+:qt.no-pen))
    (cond
      ((> level 90)
       (setf (q+:brush painter) (q+:make-qbrush (q+:qt.red) (q+:qt.solid-pattern))))
      ((> level 80)
       (setf (q+:brush painter) (q+:make-qbrush (q+:qt.yellow) (q+:qt.solid-pattern))))
      (t
       (setf (q+:brush painter) (q+:make-qbrush (q+:qt.green) (q+:qt.solid-pattern)))))
    (q+:draw-rect painter 10 120 10 (- 0 level))))

(define-initializer (levelmeter setup)
  (setf (q+:window-title levelmeter) "meters")
  (setf *test* levelmeter))

(defparameter *test* nil)

(with-controller ()
  (q+:show (make-instance 'levelmeter)))

(define-signal (nanokontrol-panel show) (int))

(define-slot (nanokontrol-panel show) ((value int))
  (declare (connected
            nanokontrol-panel
            (show int)))
  (format t "show: ~a~%" value)
  (case value
    (0 (q+:hide nanokontrol-panel))
    (1 (q+:show nanokontrol-panel))
    ))

(define-signal (levelmeter set-level) (int))

(define-slot (levelmeter set-level) ((value int))
  (declare (connected
            levelmeter
            (set-level int)))
   (setf (level levelmeter) value)
;;   (format t "set-level! ~a" value)
   (q+:repaint levelmeter)
)

(defun change-level (levelmeter value)
  (setf (level levelmeter) value)
  (signal! levelmeter (set-level int) value))

(change-level *test* (random 100))

(setf (level *test*) (random 100))

(signal! *test* (set-level int) (random 100))

(signal! *test* (show int) 1)

(level *test*)

(signal! *main* (show int) 0)

(define-slot)

(progn
 (setf (level *test*) (random 100))
;; (signal! *test* (repaint))

;; (q+:repaint *test*)
 (q+:repaint *test*))

(with-controller ()
  (q+:show (q+:make-qpushbutton "Hey")))

(defun meters ()
  (with-controller ()
  (q+:show (q+:make-qwidget))))

(meters)

(with-controller ()
  (q+:show (make-instance 'nanokontrol-panel :id :nanoktrl01)))

(signal)

(signal! (first *guis*) (show int) 1)

(untrace)

(with-controller ()
  (q+:show (make-instance 'nanokontrol-panel :id :nanoktrl02)))

(with-controller ()
  (q+:show (make-instance 'multislider-panel :slider-count 16
                                         :id :nanoktl05)))

(set-receiver! :nanoktrl01 #'my-nanoctl-receiver)
(set-receiver! :nanoktrl02 #'my-nanoctl-receiver)

(defun my-nanoctl-receiver (name idx value)
  (format t "~a: ~a ~a~%" name idx value))

(find-by-name (first *guis*) "M_Button_2")

(setf *guis* nil)
*controller*
|#

