;;; 
;;; param-view-gui.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2018 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
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

(in-package #:incudine-gui)
(named-readtables:in-readtable :qt)

;;; Zusammenfassung von Parameter und seinem Label. Da Label und
;;; parameter in einem globalen Grid angeordnet werden sollen, werden
;;; sie hier nur instantieert, aber noc nihct einem Layout
;;; zugewiesen. Das passiert dann in param-view-grid.

(defparameter *param-view-box-style*
  "border: 1px solid #838383; 
background-color: #dddddd;
selection-color: black;
cursor-color: red;
border-radius: 2px;
selection-background-color: white")

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
  ((rows :initform 5 :initarg :rows :accessor rows)
   (cols :initform 5 :initarg :cols :accessor cols)
   (preset :initform (#_new QSpinBox) :accessor preset)
   (param-boxes :initform (make-array 128) :accessor param-boxes)
   (audio-args :initform (#_new QTextEdit) :accessor audio-args)
   (midi-cc-fns :initform (#_new QTextEdit) :accessor midi-cc-fns))
  (:metaclass qt-class)
  (:qt-superclass "QWidget")
  (:slots
   ("recallPreset(int)" recall-preset))
  (:signals
   ("setPreset(int)")
   ("setAudioArgs(QString)")
   ("setMidiCCFns(QString)"))
  (:override
   ("closeEvent" close-event)))

(defmethod initialize-instance :after ((instance param-view-grid) &key parent)
  (if parent
      (new instance parent)
      (new instance))
  (let ((*background-color* "background-color: #999999;"))
    (cudagui-tl-initializer instance))
  (with-slots (param-boxes preset rows cols audio-args midi-cc-fns) instance
    (let ((main (#_new QVBoxLayout instance))
          (grid (#_new QGridLayout))
          (preset-label (#_new QLabel)))
      (#_setText preset-label "Preset")
      (#_setMinimum preset 0)
      (#_setMaximum preset 127)
      (#_setStyleSheet preset *param-view-box-style*)
      (#_setStyleSheet audio-args *param-view-box-style*)
      (#_setStyleSheet midi-cc-fns *param-view-box-style*)
      (#_addWidget grid preset-label 0 0)
      (#_addWidget grid preset 0 1)
      (loop for row below rows
         do (loop for column below (* 2 cols) by 2
               do (let ((new-box (make-instance 'param-view-box :label
                                                (format nil "~a~a:" (/ column 2) row) :text "--")))
                    (setf (aref param-boxes (+ (* row 5) (/ column 2))) new-box)
                    (#_addWidget grid (label-box new-box) (1+ row)  column)
                    (let  ((txtlayout (#_new QHBoxLayout)))
                      (#_setStyleSheet (text-box new-box) *param-view-box-style*)
                      (#_addWidget txtlayout (text-box new-box))
                      (#_addStretch txtlayout)
                      (#_addLayout grid txtlayout (1+ row) (1+ column))))))
      (#_addLayout main grid)
;      (#_addStretch main)
      (#_addWidget main audio-args)
;      (#_addStretch main)
      (#_addWidget main midi-cc-fns)
;      (#_addStretch main)
      (#_setReadOnly audio-args t)
      (#_setReadOnly midi-cc-fns t))
    (connect instance "setPreset(int)" preset "setValue(int)")
    (connect preset "valueChanged(int)" instance "recallPreset(int)")
    (connect instance "setAudioArgs(QString)" audio-args "setText(QString)")
    (connect instance "setMidiCCFns(QString)" midi-cc-fns "setText(QString)")))

(defmethod recall-preset ((instance param-view-grid) presetno)
  (setf luftstrom-display::*curr-preset-no* presetno)
  (luftstrom-display::load-preset presetno))


(defmethod close-event ((instance param-view-grid) ev)
  (declare (ignore ev))
  (remove-gui (id instance))
  (stop-overriding))
