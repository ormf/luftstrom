(in-package #:qt-gui)

;;; (export 'start-gui 'qt-gui)

#|
(def-exporting-class nanoktrlstrip (qtwidget)
  ((m-button :accessor m-button :initarg :m-button :export t)
   (s-button :accessor s-button :initarg :s-button :export t)
   (r-button :accessor r-button :initarg :r-button :export t)
   (dial :accessor dial :initarg :dial :export t)
   (dial-label :accessor dial-label :initarg :dial-label :export t)
   (dial-vlabel :accessor dial-vlabel :initarg :dial-vlabel :export t)
   (slider :accessor slider :initarg :slider :export t)
   (slider-label :accessor slider-label :initarg :slider-label :export t)
   (slider-vlabel :accessor slider-vlabel :initarg :slider-vlabel :export t)))
|#

(define-widget nanokontrol-panel (QMainWindow)
  ((id :initarg :id :accessor id)
   (rcv-hook :initarg :rcv-hook :accessor rcv-hook)
   (slider-count :initarg :slider-count :reader slider-count)
   (kontrol-surface :initarg :kontrol-surface :accessor kontrol-surface)
   (namehash :initarg :namehash :accessor namehash)
   (strips :initarg :strips :accessor strips))
  (:default-initargs
      :slider-count 8
    :kontrol-surface (merge-pathnames "nanokontrol-toggle.ui" *here*)))

(def-exporting-class qtlbldial (qtwidget)
  ((idx :accessor idx :initarg :idx :export t)
   (dial :accessor dial :initarg :dial :export t)
   (label :accessor label :initarg :label :export t)
   (vlabel :accessor vlabel :initarg :vlabel :export t)))

(define-signal (nanokontrol-panel show) (int))

(define-slot (nanokontrol-panel show) ((value int))
  (declare (connected
            nanokontrol-panel
            (show int)))
  (format t "show: ~a~%" value))

(define-initializer (nanokontrol-panel setup)
  (setf (q+:window-title nanokontrol-panel)
        (format nil "~a" (id nanokontrol-panel)))
  (push nanokontrol-panel *guis*))

(defun init-kontrols (nanokontrol-panel nanokontrol-surface)
  (loop
     for x below 8
     do (let ((slidername (format nil "slider_~d" x)))
          (setf (gethash slidername (namehash nanokontrol-panel))
                (make-instance 'qtlblslider
                               :idx x
                               :slider (first (find-by-name nanokontrol-surface slidername))
                               :label (first (find-by-name nanokontrol-surface (format nil "namelbl_~d" x)))
                               :vlabel (first (find-by-name nanokontrol-surface (format nil "valuelbl_~d" x)))))))
  (loop
     for x from 16 to 23
     do (let ((dialname (format nil "dial_~d" x)))
          (setf (gethash dialname (namehash nanokontrol-panel))
                (make-instance 'qtlbldial
                               :idx x
                               :dial (first (find-by-name nanokontrol-surface dialname))
                               :label (first (find-by-name nanokontrol-surface (format nil "namelbl_~d" x)))
                               :vlabel (first (find-by-name nanokontrol-surface (format nil "valuelbl_~d" x))))))))

(define-subwidget (nanokontrol-panel container) (q+:make-qwidget)
  (setf (q+:central-widget nanokontrol-panel) container)
  (let ((layout (q+:make-qhboxlayout container))
        (nanokontrol-surface (load-from-ui-file kontrol-surface container)))
    (setf (kontrol-surface nanokontrol-panel) nanokontrol-surface)
    (setf (namehash nanokontrol-panel) (make-hash-table :test 'equal))
    (setf (rcv-hook nanokontrol-panel) nil)
    (format t "~a" nanokontrol-surface)
    (init-kontrols nanokontrol-panel nanokontrol-surface)
    (q+:add-widget layout nanokontrol-surface)))

(define-slot (nanokontrol-panel change) ((value int))
  (declare (connected
            (find-children nanokontrol-panel "QSlider")
            (value-changed int))
           (connected
            (find-children nanokontrol-panel "QDial")
            (value-changed int)))
  (let* ((item (gethash (q+:object-name (q+:sender nanokontrol-panel))
                       (namehash nanokontrol-panel))))
    (setf (q+:text (vlabel item))
          (format nil "~3d" (round (* value 127/99))))
    (if (rcv-hook nanokontrol-panel)
        (funcall rcv-hook (id nanokontrol-panel) (idx item) value))))

(define-slot (nanokontrol-panel button-pressed) ()
  (declare
   (connected
    (find-children nanokontrol-panel "QPushButton")
    (released)))
  (let* ((idx (q+:object-name (q+:sender nanokontrol-panel)))
         (value (q+:is-checked (q+:sender nanokontrol-panel))))
    (format t "~3d: ~a~%" idx value)))

(defun start-nanoktrl-gui ()
  (with-main-window (main (make-instance 'nanokontrol-panel
                :id :nanoktl01) :blocking NIL)
    (setf *main* main)))

;;; (q+:checked (first (find-by-name *main* "M_Button_0")))

;;; (start-nanoktrl-gui)

#|
(signal! *main* (show int) 1)

(signal! *main* (hide int) 1)
|#


#|
(defun my-nanoctl-receiver (name idx value)
  (format t "~a: ~a ~a~%" name idx value))

(set-receiver! :nanoctl01 #'my-nanoctl-receiver)

(stop-receiver! :nanoctl01)

(q+:is-checked (first (find-by-name *main* "M_Button_0")))

(q+:set-checked (first (find-by-name *main* "M_Button_0")) t)
(q+:set-checked (first (find-by-name *main* "M_Button_0")) nil)

(q+:toggle (first (find-by-name *main* "M_Button_0")))

(q+:set-checkable (first (find-by-name *main* "M_Button_0")) nil)
(q+:set-checkable (first (find-by-name *main* "M_Button_0")) t)
|#
