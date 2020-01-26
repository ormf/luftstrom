;;; 
;;; ewi-ctl.lisp
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

(in-package :incudine-gui)

(defparameter *ewi-pushbutton-style*
"
QPushButton {
background-color: #dddddd;
    border-radius: 4px; 
    border-style: outset;
    border-color: #777777;
    border-width: 1px;
    min-width: 45px;
     }
")


(defun get-class-defs (slot-names)
  (dolist (name slot-names)
    (format t "~&(~a :initform nil :initarg :~a :accessor ~a)~%" name name name)))

#|

(get-class-defs '(cleanup-fn ewi-luft ewi-biss
                  ewi-glissup ewi-glissdown ewi-glide ewi-hold ewi-fwd
                  line6-a line6-b line6-c line6-d line6-vol))
|#

(defclass ewi-gui (cudagui-tl-mixin)
  (;;; (rows :initform 2 :initarg :rows :accessor rows)
;;; (cols :initform 8 :initarg :cols :accessor cols)
   (cleanup-fn :initform #'empty-fn :initarg :cleanup-fn :accessor cleanup-fn)
   (ewi-luft :initform nil :initarg :ewi-luft :accessor ewi-luft)
   (ewi-biss :initform nil :initarg :ewi-biss :accessor ewi-biss)
   (ewi-glissup :initform nil :initarg :ewi-glissup :accessor ewi-glissup)
   (ewi-glissdown :initform nil :initarg :ewi-glissdown :accessor ewi-glissdown)
   (ewi-glide :initform nil :initarg :ewi-glide :accessor ewi-glide)
   (ewi-hold :initform nil :initarg :ewi-hold :accessor ewi-hold)
   (ewi-fwd :initform nil :initarg :ewi-fwd :accessor ewi-fwd)
   (line6-a :initform nil :initarg :line6-a :accessor line6-a)
   (line6-b :initform nil :initarg :line6-b :accessor line6-b)
   (line6-c :initform nil :initarg :line6-c :accessor line6-c)
   (line6-d :initform nil :initarg :line6-d :accessor line6-d)
   (line6-vol :initform nil :initarg :line6-vol :accessor line6-vol)
   (midi-cc-fns :initform (#_new QTextEdit) :accessor midi-cc-fns)
   (midi-note-fns :initform (#_new QTextEdit) :accessor midi-note-fns))
  (:metaclass qt-class)
  (:qt-superclass "QWidget")
  (:slots)
  (:signals)
  (:override
   ("closeEvent" close-event)))

(defmethod initialize-instance :after ((instance ewi-gui) &key parent &allow-other-keys)
  (if parent
      (new instance parent)
      (new instance))
  (let ((*background-color* "background-color: #999999;"))
    (cudagui-tl-initializer instance))
  (with-slots (cleanup-fn ewi-luft ewi-biss
               ewi-glissup ewi-glissdown ewi-glide ewi-hold ewi-fwd
               line6-a line6-b line6-c line6-d line6-vol
               midi-cc-fns midi-note-fns)
      instance
    (let ((main (#_new QVBoxLayout instance))
          (grid (#_new QGridLayout)))
      (#_setStyleSheet midi-cc-fns *nanokontrol-box-style*)
      (#_setStyleSheet midi-note-fns *nanokontrol-box-style*)
      (loop
        for slot in '(ewi-luft  ewi-biss ewi-glissup ewi-glissdown ewi-glide line6-vol)
        for idx from 0
        for col =  (* 2 (mod idx 8))
        for row = (floor idx 8)
        do (let ((new-lsbox (make-instance
                             'label-spinbox
                             :label (format nil "~a:" (cl-ppcre:regex-replace "ewi-" (string-downcase (symbol-name slot)) ""))
                             :text "--"
                             :id (ou::make-keyword slot)))
                 (lsboxlayout (#_new QHBoxLayout)))
             (#_setRange (text-box new-lsbox) 0 127)
             (setf (slot-value instance slot) new-lsbox)
             (#_addWidget grid (label-box new-lsbox) row col)
             (#_addWidget lsboxlayout (text-box new-lsbox))
             (#_addStretch lsboxlayout)
             (#_addLayout grid lsboxlayout row (1+ col))))
      (loop
        for slot in '(ewi-hold ewi-fwd line6-a line6-b line6-c line6-d)
        for idx from 0
        for col =  (* 2 (mod idx 8))
        for row = (1+ (floor idx 8))
        do (let ((new-label-pb
                   (make-instance
                    'label-pushbutton
                    :label (format nil "~a:"
                                   (cl-ppcre:regex-replace
                                    "ewi-"
                                    (string-downcase (symbol-name slot)) ""))
                    :id (ou::make-keyword slot)))
                 (label-pblayout (#_new QHBoxLayout)))
             (setf (slot-value instance slot) new-label-pb)
             (#_setStyleSheet new-label-pb *ewi-pushbutton-style*)
             (#_addWidget grid new-label-pb row (1+ col))
             (#_addWidget label-pblayout (label-box new-label-pb))
;;             (#_addStretch label-pblayout)
             (#_addLayout grid label-pblayout row col)))
      (#_addLayout main grid)
      ;; (connect load-action "triggered()" instance "loadAction()")
      ;; (connect save-action "triggered()" instance "saveAction()")
      ;; (connect saveas-action "triggered()" instance "saveasAction()")
      )))

#|
(make-instance
'label-pushbutton
                    :label (format nil "~a:"
                                   (cl-ppcre:regex-replace
                                    "ewi-"
                                    (string-downcase (symbol-name slot)) ""))
                    :id (ou::make-keyword slot))

(make-instance 'pushbutton
(make-instance
'label-pushbutton
:label (format nil "blah")
:id :blah)
|#

(defmethod close-event ((instance ewi-gui) ev)
  (declare (ignore ev))
  (remove-gui (id instance))
  (funcall (cleanup-fn instance))
  (stop-overriding))

(defun ewi-gui (&rest args)
  (let ((id (getf args :id :ewi1)))
    (if (find-gui id) (progn (close-gui id) (sleep 1)))
    (apply #'create-tl-widget 'ewi-gui id args)))

(ewi-gui :id :ewi4 :x-pos 100 :y-pos 100 :width 800 :height 200)


(make-instance 'ewi-gui :id :ewi1)

(#_close (find-gui :ewi1))

(in-package :luftstrom-display)



(defclass ewi-controller (midi-controller)
  ((gui :initarg :gui :accessor gui))
   )

