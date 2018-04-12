(defpackage #:qt-gui
  (:use #:cl+qt)
  (:export #:start-gui
           #:find-gui
           #:set-receiver!
           #:stop-receiver!))


(in-package #:qt-gui)

;;; (export 'start-gui 'qt-gui)

(in-readtable :qtools)

(defparameter *main* nil)
(defparameter *guis* nil)

;; Adjust to the folder where the UI files reside if necessary.
(defparameter *here* (merge-pathnames "ui-design/"
                                      #.(or *compile-file-pathname* *load-pathname*
                                                        *default-pathname-defaults*)))

(defun load-from-ui-file (pathname &optional (parent (null-qobject "QWidget")))
  (with-finalizing ((ui-loader (q+:make-quiloader))
                    (ui-file (q+:make-qfile (uiop:native-namestring pathname))))
    (q+:open ui-file (q+:qiodevice.read-only))
    (q+:load ui-loader ui-file parent)))

(defun find-by-name (widget name)
  "Find all children that have the object-name name"
  (let ((found ()))
    (labels ((test (widget)
               (unless (null-qobject-p widget)
                 (if (string= name (q+:object-name widget))
                     (push widget found))))
             (recurse (widget)
               (dolist (child (#_children widget))
                 (test child)
                 (recurse child))))
      (recurse widget))
    (nreverse found)))

(defun init-slider (layout slider name label)
  (let ((lbl (first (find-by-name slider "namelbl")))
        (vlbl (first (find-by-name slider "valuelbl")))
        (inner-slider (first (find-by-name slider "slider"))))
    (setf (q+:object-name inner-slider) name)
    (setf (q+:object-name lbl) (format nil "~a-lbl" name))
    (setf (q+:object-name vlbl) (format nil "~a-vlbl" name))
    (setf (q+:text lbl) label)  
    (q+:add-widget layout slider)))

(defmacro def-exporting-class (name (&rest superclasses) (&rest slot-specs)
                                 &optional class-option)
    (let ((exports (mapcan (lambda (spec)
                             (when (getf (cdr spec) :export)
                               (let ((name (or (getf (cdr spec) :accessor)
                                               (getf (cdr spec) :reader)
                                               (getf (cdr spec) :writer))))
                                 (when name (list name)))))
                           slot-specs)))
      `(progn
         (defclass ,name (,@superclasses)
           ,(append 
             (mapcar (lambda (spec)
                       (let ((export-pos (position :export spec)))
                         (if export-pos
                             (append (subseq spec 0 export-pos)
                                     (subseq spec (+ 2 export-pos)))
                             spec)))
                     slot-specs)
             (when class-option (list class-option))))
         ,@(mapcar (lambda (name) `(export ',name))
                   exports))))


(def-exporting-class qtwidget ()
  ((widget :accessor widget :initarg :widget :export t)))

(def-exporting-class qtlabel (qtwidget)
  ((text :accessor text :initarg :text :export t)))

(def-exporting-class qtslider (qtwidget)
  ((slider :accessor slider :initarg :slider :export t)))

(def-exporting-class qtlblslider (qtwidget)
  ((idx :accessor idx :initarg :idx :export t)
   (slider :accessor slider :initarg :slider :export t)
   (label :accessor label :initarg :label :export t)
   (vlabel :accessor vlabel :initarg :vlabel :export t)))

(def-exporting-class qtlbldial (qtwidget)
  ((idx :accessor idx :initarg :idx :export t)
   (dial :accessor dial :initarg :dial :export t)
   (label :accessor label :initarg :label :export t)
   (vlabel :accessor vlabel :initarg :vlabel :export t)))


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

(defgeneric set-label (widget text))

(defmethod set-label ((obj qtlabel) text)
  (setf (q+:text obj) text))

(defmethod set-label ((obj qtlblslider) text)
  (setf (q+:text (label obj)) text))

(defgeneric set-value (widget value))

(defmethod set-value ((obj qtlblslider) value)
  (setf (q+:value (slider obj)) value))

(define-signal)

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

(define-initializer (nanokontrol-panel setup)
  (setf (q+:window-title nanokontrol-panel) (format nil "~a" (id nanokontrol-panel)))
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

(defun start-gui ()
  (with-main-window (main (make-instance 'nanokontrol-panel
                                         :id :nanoktl01) :blocking NIL)
    (setf *main* main)))

(q+:checked (first (find-by-name *main* "M_Button_0")))

;;; (start-gui)


#|
Im Bezug auf Signale und Slots gibt es leider ein Problem in CL wenn
man UI Files braucht. Normalerweise in C++ könnte man die findChild
methode gebrauchen um ein gewünschtes Widget aufzufinden und es mit
einem Slot zu verbinden. Allerdings ist findChild eine
Template-Methode und kann deshalb nicht in C (und somit CL) übertragen
werden. Um dies trotzdem zu ermöglichen ist eine handgemachte Funktion
notwendig, die ich nun zu Qtools hinzugefügt habe. Nun kann man slots
definieren: 
|#

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

(defun find-gui (id)
  (loop for gui in *guis*
     do (if (eql id (id gui))
            (return gui))))

;;; (find-gui :nanoktl01)

;;; (set-value (aref (sliders (find-gui :nanoktl01)) 0) 10)

(defun set-receiver! (gui hook)
  (let ((guiobj (find-gui gui)))
    (if guiobj
        (progn
          (setf (rcv-hook (find-gui gui)) hook)
          (format t "~a receiving!" gui))
        (warn "qtgui ~a not found" gui))))

(defun stop-receiver! (gui)
  (setf (rcv-hook (find-gui gui)) nil))

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
