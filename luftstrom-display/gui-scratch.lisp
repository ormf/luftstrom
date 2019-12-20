(in-package #:incudine-gui)
(named-readtables:in-readtable :qt)

;;; Zusammenfassung von Parameter und seinem Label. Da Label und
;;; parameter in einem globalen Grid angeordnet werden sollen, werden
;;; sie hier nur instantieert, aber noc nihct einem Layout
;;; zugewiesen. Das passiert dann in param-view-grid.

(defclass param-view-box ()
  ((label :initform "" :initarg :label :accessor label)
   (text :initform "" :initarg :text :accessor text)
   (label-box :initform (#_new QLabel) :accessor label-box)
   (text-box :initform (make-instance 'textbox) :accessor text-box))
  (:metaclass qt-class)
  (:qt-superclass "QDialog")
  (:signals
   ("setText(QString)")
   ("setLabel(QString)")))

(defmethod initialize-instance :after ((instance param-view-box) &key parent)
  (if parent
      (new instance parent)
      (new instance))
  (with-slots (text-box label-box label text) instance
    (#_setStyleSheet text-box (style text-box))
    ;;    (#_setFixedWidth instance 45)
    (#_setFixedHeight text-box 25)
    (#_setAlignment text-box (#_AlignLeft "Qt"))
    (#_setText text-box text)
    (#_setReadOnly text-box t)
    (#_setText label-box label)
    (connect instance "setText(QString)" text-box "setText(QString)")
    (connect instance "setLabel(QString)" label-box "setText(QString)")))

(defclass param-view-grid (cudagui-tl-mixin)
  ((rows :initform 10 :initarg :rows :accessor rows)
   (cols :initform 5 :initarg :cols :accessor cols)
   (param-boxes :initform (make-array 128) :accessor param-boxes))
  (:metaclass qt-class)
  (:qt-superclass "QWidget")
  (:override
   ("closeEvent" close-event)))

(defmethod initialize-instance :after ((instance param-view-grid) &key parent)
  (if parent
      (new instance parent)
      (new instance))
  (let ((*background-color* "background-color: #999999;"))
    (cudagui-tl-initializer instance))
  (with-slots (param-boxes) instance
    (let ((layout (#_new QGridLayout instance)))
      (loop for row below rows
         do (loop for column below (* 2 cols) by 2
               do (let ((new-box (make-instance 'param-view-box :label
                                                (format nil "r~ac~a:" row column) :text "--")))
                    (setf (aref param-boxes (+ (* row 5) column)) new-box)
                    (#_addWidget layout (label-box new-box) row column)
                    (let  ((txtlayout (#_new QHBoxLayout)))
                      (#_addWidget txtlayout (text-box new-box))
                      (#_addStretch txtlayout)
                      (#_addLayout layout txtlayout row (1+ column)))))))))

(defmethod initialize-instance :after ((instance param-view-grid) &key parent)
  (if parent
      (new instance parent)
      (new instance))
  (let ((*background-color* "background-color: #999999;"))
    (cudagui-tl-initializer instance))
  (with-slots (param-boxes) instance
    (let ((layout (#_new QGridLayout instance)))
      (loop for row below 10
         do (loop for column below 5
               do (let (
   (label-box :initform (#_new QLabel) :accessor label-box)
   (text-box :initform (make-instance 'textbox) :accessor text-box)



                        (new-box (make-instance 'label-textbox :label (format nil "r~ac~a:" row column) :text "jawoll")))
                    (setf (aref param-boxes (+ (* row 5) column)) new-box)
                    (#_addWidget layout new-box row column)))))))

(defmethod close-event ((instance param-view-grid) ev)
  (declare (ignore ev))
  (remove-gui (id instance))
  (stop-overriding))

;;; (gui-funcall (create-tl-widget 'param-view-grid "pv9"))

