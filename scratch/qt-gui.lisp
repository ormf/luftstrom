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

(defgeneric set-label (widget text))

(defmethod set-label ((obj qtlabel) text)
  (setf (q+:text obj) text))

(defmethod set-label ((obj qtlblslider) text)
  (setf (q+:text (label obj)) text))

(defgeneric set-value (widget value))

(defmethod set-value ((obj qtlblslider) value)
  (setf (q+:value (slider obj)) value))

(define-widget multislider-panel (QMainWindow)
  ((id :initarg :id :accessor id)
   (rcv-hook :initarg :rcv-hook :accessor rcv-hook)
   (slider-count :initarg :slider-count :reader slider-count)
   (slider-file :initarg :slider-file :reader slider-file)
   (sliders :initarg :sliders :accessor sliders))
  (:default-initargs
      :slider-count 8
    :slider-file (merge-pathnames "label-slider-label.ui" *here*)))

(define-initializer (multislider-panel setup)
  (setf (q+:window-title multislider-panel) (format nil "~a" (id multislider-panel)))
  (push multislider-panel *guis*))

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

(defun start-gui ()
  (with-main-window (main (make-instance 'multislider-panel :slider-count 16
                                         :id :nanoctl01) :blocking NIL)
    (setf *main* main)))


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

(define-slot (multislider-panel change) ((value int))
  (declare (connected
            (find-children multislider-panel "QSlider")
            (value-changed int)))
  (let* ((idx (read-from-string (q+:object-name (q+:sender multislider-panel)))))
    (setf (q+:text (vlabel (aref (sliders multislider-panel) idx)))
          (format nil "~3d" (round (* value 127/99))))
    (if (rcv-hook multislider-panel)
        (funcall rcv-hook (id multislider-panel) idx value))))

(defun find-gui (id)
  (loop for gui in *guis*
     do (if (eql id (id gui))
            (return gui))))

;;; (find-gui :nanoctl01)

;;; (set-value (aref (sliders (find-gui :nanoctl01)) 0) 10)

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
|#
