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
;;; sie hier nur instantieert, aber noch nicht einem Layout
;;; zugewiesen. Das passiert dann in param-view-grid.

(defparameter *param-view-box-style*
  "border: 1px solid #838383; 
background-color: #dddddd;
selection-color: black;
border-radius: 2px;
selection-background-color: white")

(defclass custom-spinbox ()
  ()
  (:metaclass qt-class)
  (:qt-superclass "QSpinBox")
  (:signals
   ("returnPressed(int)"))
  (:override
   ("keyPressEvent" key-press-event)))

(defmethod initialize-instance :after ((instance custom-spinbox) &key parent)
  (if parent
      (new instance parent)
      (new instance)))

(defclass param-view-box ()
  ((label :initform "" :initarg :label :accessor label)
   (text :initform "" :initarg :text :accessor text)
   (label-box :initform (#_new QLabel) :accessor label-box)
   (text-box :initform (make-instance 'textbox) :accessor text-box)
   (ref :initform nil :initarg :ref :accessor ref)
   (formatter :initform "~a" :initarg :formatter :accessor pformatter)
   (map-fn :initform #'identity :initarg :map-fn :accessor map-fn)
   (rmap-fn :initform #'identity :initarg :rmap-fn :accessor rmap-fn))
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

(defmethod (setf val) (new-val (instance param-view-box))
  (format t "directly setting value-cell~%")
  (emit-signal instance "setText(QString)" (format nil (pformatter instance) new-val))
  (when (ref instance)
    (set-cell (ref instance) (funcall (map-fn instance) new-val) :src instance))
  new-val)

(defmethod ref-set-cell ((instance param-view-box) new-val)
  (with-slots (rmap-fn) instance
    (emit-signal instance "setText(QString)"
                 (format nil (pformatter instance) (funcall (rmap-fn instance) new-val)))))

(defmethod set-ref ((instance param-view-box) new-ref &key map-fn rmap-fn)
  (with-slots (ref) instance
    (when ref (setf (dependents ref) (delete instance (dependents ref))))
    (setf ref new-ref)
    (if new-ref
        (progn
          (pushnew instance (dependents new-ref))
          (if map-fn (setf (map-fn instance) map-fn))
          (if rmap-fn (setf (rmap-fn instance) rmap-fn))
          (ref-set-cell instance (slot-value new-ref 'val)))))
  new-ref)

(defmethod val ((instance param-view-box))
  (#_value instance))

(defclass param-view-grid (cudagui-tl-mixin)
  ((rows :initform 5 :initarg :rows :accessor rows)
   (cols :initform 5 :initarg :cols :accessor cols)
   (preset :initform (make-instance 'custom-spinbox) :accessor preset)
   (audio-preset :initform (#_new QSpinBox) :accessor audio-preset)
   (bs-preset :initform (make-instance 'custom-spinbox) :accessor bs-preset)
   (popup-menu :initform (make-instance 'pushbutton) :accessor popup-menu)
   (config-window :initform (make-instance 'config-window :id :config) :accessor config-window)
   (load-action :accessor load-action) ;;; the action accessors for the menu
   (save-action :accessor save-action)
   (saveas-action :accessor saveas-action)
   (config-action :accessor config-action)
   (param-boxes :initform (make-array 128) :accessor param-boxes)
   (audio-args :initform (#_new QTextEdit) :accessor audio-args)
   (midi-cc-fns :initform (#_new QTextEdit) :accessor midi-cc-fns)
   (midi-note-fns :initform (#_new QTextEdit) :accessor midi-note-fns))
  (:metaclass qt-class)
  (:qt-superclass "QWidget")
  (:slots
   ("setPreset(int)" set-preset)
   ("recallPreset(int)" recall-preset)
   ("setAudioPreset(int)" set-audio-preset)
;;;   ("setBsPreset(int)" set-bs-preset)
   ("recallBsPreset(int)" recall-bs-preset)
   ("loadAction()" do-load-action)
   ("saveAction()" do-save-action)
   ("saveasAction()" do-saveas-action)
   ("configAction()" do-config-action))
  (:signals
   ("setPresetNum(int)")
   ("setAudioPresetNum(int)")
   ("setBsPresetNum(int)")
   ("setAudioArgs(QString)")
   ("setMidiCCFns(QString)")
   ("setMidiNoteFns(QString)"))
  (:override
   ("closeEvent" close-event)))

(defmethod initialize-instance :after ((instance param-view-grid) &rest args &key parent &allow-other-keys)
  (declare (ignore args))
  (if parent
      (new instance parent)
      (new instance))
  (let ((*background-color* "background-color: #999999;"))
    (cudagui-tl-initializer instance))
  (with-slots (param-boxes preset audio-preset bs-preset popup-menu config-window rows cols audio-args midi-cc-fns midi-note-fns
               load-action save-action saveas-action config-action)
      instance
    (let ((main (#_new QVBoxLayout instance))
          (grid (#_new QGridLayout))
          (preset-label (#_new QLabel))
          (audio-preset-label (#_new QLabel))
          (bs-preset-label (#_new QLabel)))
      (add-gui (id config-window) config-window)
      (#_setText preset-label "Preset")
      (#_setText audio-preset-label "Audio-Preset")
      (#_setText bs-preset-label "BS-Preset")
      (#_setMinimum preset 0)
      (#_setMaximum preset 99)
      (#_setMinimum audio-preset 0)
      (#_setMaximum audio-preset 127)
      (#_setMinimum bs-preset 0)
      (#_setMaximum bs-preset 99)
      (make-button-menu popup-menu :actions
                        ((load-action "Load")
                         (save-action  "Save")
                         (saveas-action "Save As")
                         (config-action "Config"))
                        :label "File")
      (#_setText popup-menu "File")
      (#_setStyleSheet popup-menu *param-view-box-style*)
      (#_setStyleSheet preset *param-view-box-style*)
      (#_setStyleSheet audio-preset *param-view-box-style*)
      (#_setStyleSheet bs-preset *param-view-box-style*)
      (#_setStyleSheet audio-args *param-view-box-style*)
      (#_setMinimumHeight audio-args 100)
      ;;      (#_setStyleSheet midi-cc-fns *param-view-box-style*)
;;      (#_setStyleSheet midi-note-fns *param-view-box-style*)
      (#_addWidget grid preset-label 0 0)
      (#_addWidget grid preset 0 1)
      (#_addWidget grid audio-preset-label 0 2)
      (#_addWidget grid audio-preset 0 3)
      (#_addWidget grid bs-preset-label 0 4)
      (#_addWidget grid bs-preset 0 5)
      (#_addWidget grid popup-menu 0 9)
      (loop
        for row below rows
        do (loop
             for column below (* 2 cols) by 2
             do (let ((new-pvbox
                        (make-instance 'param-view-box :label
                                       (format nil "~a~a:" row (/ column 2)) :text "--")))
                  (setf (aref param-boxes (+ (* row 5) (/ column 2))) new-pvbox)
                  (#_setStyleSheet (text-box new-pvbox) *param-view-box-style*)
                  (let ((pvboxlayout (#_new QHBoxLayout)))
                    (#_addWidget grid (label-box new-pvbox) (1+ row)  column)
                    (#_addWidget pvboxlayout (text-box new-pvbox))
                    (#_addStretch pvboxlayout)
                    (#_addLayout grid pvboxlayout (1+ row) (1+ column))))))
      (#_addLayout main grid)
;      (#_addStretch main)
      (#_addWidget main audio-args)
;      (#_addStretch main)
;;      (#_addWidget main midi-cc-fns)
;      (#_addStretch main)
;;      (#_addWidget main midi-note-fns)
      (#_setReadOnly audio-args t)
;;      (#_setReadOnly midi-cc-fns t)
;;      (#_setReadOnly midi-note-fns t)
      )
    (connect preset "valueChanged(int)" instance "setPreset(int)")
    (connect preset "returnPressed(int)" instance "recallPreset(int)")
    ;;    (connect preset "keyPressed(int)" instance "recallPreset(int)") 
    (connect audio-preset "valueChanged(int)" instance "setAudioPreset(int)")
;;    (connect bs-preset "valueChanged(int)" instance "setBsPreset(int)")
    (connect bs-preset "returnPressed(int)" instance "recallBsPreset(int)")
    (connect instance "setPresetNum(int)" preset "setValue(int)")
    (connect instance "setAudioPresetNum(int)" audio-preset "setValue(int)")
    (connect instance "setBsPresetNum(int)" bs-preset "setValue(int)")
    (connect instance "setAudioArgs(QString)" audio-args "setText(QString)")
    (connect instance "setMidiCCFns(QString)" midi-cc-fns "setText(QString)")
    (connect instance "setMidiNoteFns(QString)" midi-note-fns "setText(QString)")
    (connect load-action "triggered()" instance "loadAction()")
    (connect save-action "triggered()" instance "saveAction()")
    (connect saveas-action "triggered()" instance "saveasAction()")
    (connect config-action "triggered()" instance "configAction()")))

(defmethod set-preset ((instance param-view-grid) presetno)
  (luftstrom-display::edit-preset presetno))

(defmethod recall-preset ((instance param-view-grid) num)
  (case num
    (0 (progn
;;         (break "~&Recall Preset: ~a~%" (#_value (preset instance)))
         (luftstrom-display::load-audio-preset :no (#_value (preset instance)))))
    (1 (format t "~&Don't Recall Preset: ~a~%" (#_value (preset instance))))))

(defmethod set-audio-preset ((instance param-view-grid) presetno)
  (luftstrom-display::edit-audio-preset presetno))

#|
(defmethod set-bs-preset ((instance param-view-grid) presetno)
  (format t "~&set-bs-preset: ~a~%" presetno)
  )

     (case (#_modifiers ev)
       (0 (progn
            (format t "~%Recalling Boid-System ~a~%" (#_value instance))
            (luftstrom-display::bs-state-recall (#_value instance))
            ))
       (100663296 (progn
                    (format t "~%Storing  Boid-System: ~a~%" (#_value instance))
                    (luftstrom-display::bs-state-save (#_value instance)))))
|#

(defmethod recall-bs-preset ((instance param-view-grid) num)
  (case num
    (0 (progn
         (format t "~&Recall BS Preset: ~a~%" (#_value (bs-preset instance)))
         (luftstrom-display::bs-state-recall (#_value (bs-preset instance)) :global-flags t)))
    (1 (progn
         (format t "~&Save BS Preset: ~a~%" (#_value (bs-preset instance)))
         (luftstrom-display::bs-state-save (#_value (bs-preset instance)) :global-flags t)))))


;;; (luftstrom-display::load-preset 0)

(defun do-load-action (param-view-grid)
  (let ((file (#_QFileDialog::getOpenFileName
               param-view-grid "Load"
               (namestring luftstrom-display::*bs-presets-file*)
               "*.lisp")))
    (if (string= file "") (format t "~&canceled.")
        (luftstrom-display::restore-bs-presets :file file))))

(defun do-save-action (param-view-grid)
  (declare (ignore param-view-grid))
  (luftstrom-display::store-bs-presets))

(defun do-saveas-action (param-view-grid)
  (let ((file (#_QFileDialog::getSaveFileName
               param-view-grid "Save As"
               (namestring luftstrom-display::*bs-presets-file*)
               "*.lisp")))
    (if (string= file "") (format t "~&canceled.")
        (luftstrom-display::store-bs-presets :file file))))

(defun do-config-action (param-view-grid)
  (#_show (config-window param-view-grid)))

(defmethod close-event ((instance param-view-grid) ev)
  (declare (ignore ev))
  (remove-gui (id (config-window instance)))
  (remove-gui (id instance))
  (stop-overriding))

(defmethod key-press-event ((instance custom-spinbox) ev)
;;;  (format t "~%~a, ~a~%" (#_key ev) (#_modifiers ev))
  (cond ;; Signal Ctl-Space pressed.
    ((= (#_key ev) 16777220)
     (case (#_modifiers ev)
       (0 (emit-signal instance "returnPressed(int)" 0))
       (100663296 (emit-signal instance "returnPressed(int)" 1))))
    ;; Delegate standard.
    (T
     (call-next-qmethod))))
