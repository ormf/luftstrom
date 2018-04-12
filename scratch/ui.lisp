(in-package)

(ql:quickload '(qtools qtcore qtgui qtuitools))

(defpackage #:slidertest
  (:use #:cl+qt)
  (:export #:test))

(in-package #:slidertest)
(in-readtable :qtools)

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


(defun make-multislider-widget (&key (count 8)
                                (main-file (merge-pathnames "mainwindow.ui" *here*))
                                (slider-file (merge-pathnames "label-slider-label.ui" *here*)))
  (let* ((mainwidget (q+:make-qwidget))
          (hboxlayout (q+:make-qhboxlayout mainwidget))
         (main (load-from-ui-file main-file)))
    (loop for i below count
       for slider = (load-from-ui-file slider-file mainwidget)
       do (init-slider hboxlayout slider (format nil "slider~2,'0d" i)(format nil "label~2,'0d" i)))
    (setf (q+:central-widget main) mainwidget)
    (setf (q+:window-title main) "Slidertest")
    main))

(defparameter *main* nil)

(defun test01 ()
  (with-main-window (main (make-slider-widget :count 4) :blocking NIL)
    (setf *main* main)))

;;; (test01)

;;; idiomatischer

(define-widget slider-panel (QMainWindow)
  ((slider-count :initarg :slider-count :reader slider-count)
   (slider-file :initarg :slider-file :reader slider-file))
  (:default-initargs
      :slider-count 8
    :slider-file (merge-pathnames "label-slider-label.ui" *here*)))

(define-initializer (slider-panel setup)
  (setf (q+:window-title slider-panel) "Slidertest")
  (setf (gethash slider-panel *obj-hash*)
        slider-panel))

(define-subwidget (slider-panel container) (q+:make-qwidget)
  (setf (q+:central-widget slider-panel) container)
  (let ((layout (q+:make-qhboxlayout container)))
    (loop for count below slider-count
          for slider = (load-from-ui-file slider-file container)
       do (init-slider layout slider
                       (format nil "slider~2,'0d" count)
                       (format nil "s~2,'0d" count)))))

(defun test02 ()
  (with-main-window (main (make-instance 'slider-panel :slider-count 16) :blocking NIL)
    (setf *main* main)))


;;; neu


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
  ((id :accessor id :initarg :id :export t)
   (slider :accessor slider :initarg :slider :export t)
   (label :accessor label :initarg :label :export t)
   (vlabel :accessor vlabel :initarg :vlabel :export t)))


#|
(def-exporting-class qtmultislider (qtwidget)
  ((id :accessor id :initarg :id :export t)
   (numsliders :accessor numsliders :initarg :numsliders :export t)
   (sliders :accessor sliders :initarg :sliders :export t)))
|#

(defgeneric set-label (widget text))

(defmethod set-label ((obj qtlabel) text)
  (setf (q+:text obj) text))

(defmethod set-label ((obj qtlblslider) text)
  (setf (q+:text (label obj)) text))

(defgeneric set-value (widget value))

(defmethod set-value ((obj qtlblslider) value)
  (setf (q+:value (slider obj)) value))

(define-widget multislider-panel (QMainWindow)
  ((slider-count :initarg :slider-count :reader slider-count)
   (slider-file :initarg :slider-file :reader slider-file)
   (sliders :initarg :sliders :accessor sliders))
  (:default-initargs
      :slider-count 8
    :slider-file (merge-pathnames "label-slider-label.ui" *here*)))

(define-initializer (multislider-panel setup)
  (setf (q+:window-title multislider-panel) "Slidertest"))

(defun init-lblslider (layout slider count)
  (let ((slidername (format nil "~2,'0d-msl" count))
        (lbl (first (find-by-name slider "namelbl")))
        (vlbl (first (find-by-name slider "valuelbl")))
        (inner-slider (first (find-by-name slider "slider"))))
    ;;; we use the arrayidx as name for the value-change method.
    (setf (q+:object-name inner-slider) (format nil "~d" count))
    (setf (q+:object-name lbl) (format nil "~a-lbl" slidername))
    (setf (q+:object-name vlbl) (format nil "~a-vlbl" slidername))
    (setf (q+:text lbl) (format nil "~2,'0d-msl" count))  
    (q+:add-widget layout slider)
    (make-instance 'qtlblslider
                   :widget slider
                   :label lbl
                   :vlabel vlbl
                   :slider inner-slider)))

(define-subwidget (multislider-panel container) (q+:make-qwidget)
  (setf (q+:central-widget multislider-panel) container)
  (let ((layout (q+:make-qhboxlayout container)))
    (setf (sliders multislider-panel)
          (make-array (list slider-count)
                      :initial-element (make-instance 'qtlblslider)
                      :element-type 'qtlblslider))
    (loop for count below slider-count
       for slider = (load-from-ui-file slider-file container)
       do (setf (aref (sliders multislider-panel) count)
                (init-lblslider layout slider count)))))

(defun test02 ()
  (with-main-window (main (make-instance 'slider-panel :slider-count 16) :blocking NIL)
    (setf *main* main)))

;;; (test02)


(defun test03 ()
  (with-main-window (main (make-instance 'multislider-panel :slider-count 16) :blocking NIL)
    (setf *main* main)))

(make-instance 'multislider-panel :slider-count 16)

;;; (test03)

;;; (untrace)

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

(define-slot (slider-panel change) ((value int))
  (declare (connected
            (find-children slider-panel "QSlider")
            (value-changed int)))
  (let* ((name (q+:object-name (q+:sender slider-panel)))
         (vlbl (first (find-by-name slider-panel (format nil "~a-vlbl" name)))))
    (if vlbl
        (setf (q+:text vlbl)
              (format nil "~3d" (round (* value 127/99)))))

;;    (format T "~&~s changed value to ~a~%" name value)
    ))
#|
(define-slot (multislider-panel change) ((value int))
  (declare (connected
            (find-children multislider-panel "QSlider")
            (value-changed int)))
  (let* ((name (q+:object-name (q+:sender multislider-panel)))
         (vlbl (first (find-by-name multislider-panel (format nil "~a-vlbl" name)))))
    (if vlbl
        (setf (q+:text vlbl)
              (format nil "~3d" (round (* value 127/99)))))

    (format T "~&~s changed value to ~a ~a~%" name value (q+:sender multislider-panel))
    ))
|#
(define-slot (multislider-panel change) ((value int))
  (declare (connected
            (find-children multislider-panel "QSlider")
            (value-changed int)))
  (let* ((idx (read-from-string (q+:object-name (q+:sender multislider-panel)))))
    (setf (q+:text (vlabel (aref (sliders multislider-panel) idx)))
          (format nil "~3d" (round (* value 127/99))))
;;     (format T "~&~s changed value to ~a ~a~%" idx value (q+:sender multislider-panel))
    ))



(setf (q+:value (first (find-by-name *main* "00-msl"))) 20)

(set-value (aref (sliders *main*) 0) 10)

(defparameter *obj-hash* (make-hash-table))

#|
Das Setzen der Werte funktioniert wie gewohnt über die angemessenen Qt
Methoden wie setValue. Jede set* Funktion kann man in Q+ auch mit setf
gebrauchen:
|#

;;; (setf (q+:value slider) (random 100))

#|
Wie das Zeugs mit den Signalen und Slots sonst so funktioniert ist in
den Beispielen [1] und der Dokumentation [2] meiner Meinung nach
ausführlich demonstriert.

Ja, ich studiere im Moment Informatik an der ETH Zürich.
|#
