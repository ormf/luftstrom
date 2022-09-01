;;; 
;;; config-window-gui.lisp
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
;;; sie hier nur instantieert, aber noch nicht einem Layout
;;; zugewiesen. Das passiert dann in param-view-grid.

(defparameter *param-view-box-style*
  "border: 1px solid #838383; 
background-color: #dddddd;
selection-color: black;
cursor-color: red;
border-radius: 2px;
selection-background-color: white")

(defclass config-window (cudagui-tl-mixin)
  ((rows :initform 5 :initarg :rows :accessor rows)
   (cols :initform 5 :initarg :cols :accessor cols)
   (cancel-button :initform (#_new QPushButton "Cancel") :accessor cancel-button)
   (save-button :initform (#_new QPushButton "Save") :accessor save-button))
  (:metaclass qt-class)
  (:qt-superclass "QDialog")
  (:slots
   ("saveAction()" do-save-action)
   ("cancelAction()" do-cancel-action))
  (:signals)
  (:override
   ("closeEvent" close-event)))

(defmethod initialize-instance :after ((instance config-window) &key parent)
  (if parent
      (new instance parent)
      (new instance))
  (let ((*background-color* "background-color: #ffffff;"))
    (with-slots (id cancel-button save-button) instance
      (#_setWindowTitle instance (format-title id))
      (#_setStyleSheet instance *background-color*)
      (#_setGeometry instance 50 50 100 100)
      (let ((main (#_new QVBoxLayout instance))
            (grid (#_new QGridLayout instance))
            (cb-layout (#_new QHBoxLayout)))
        (#_addStretch cb-layout)
        (#_addWidget cb-layout cancel-button)
        (#_addWidget cb-layout save-button)
        (#_addLayout main grid)
        (#_addStretch main)
        (#_addLayout main cb-layout))
      (connect cancel-button "released()" instance "cancelAction()")
      (connect save-button "released()" instance "saveAction()"))))

(defmethod close-event ((instance config-window) ev)
  (declare (ignore ev))
  (do-cancel-action instance))

(defun do-cancel-action (config-window)
  (#_hide config-window)
  (format t "~&Canceled."))

(defun do-save-action (config-window)
  (format t "~&Save Config.")
  (#_hide config-window))


;;; (gui-funcall (create-dialog-widget 'config-window :config1))
