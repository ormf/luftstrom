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
(named-readtables:in-readtable :qt)

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
                  ewi-gl-up ewi-gl-dwn ewi-glide ewi-hold ewi-fwd
                  l6-a l6-b l6-c l6-d l6-vol))
|#

(defclass ewi-gui (cudagui-tl-mixin)
  (;;; (rows :initform 2 :initarg :rows :accessor rows)
;;; (cols :initform 8 :initarg :cols :accessor cols)
   (cleanup-fn :initform #'empty-fn :initarg :cleanup-fn :accessor cleanup-fn)
   (ewi-apr :initform 0 :initarg :ewi-apr :accessor ewi-apr)
   (ewi-key :initform 0 :initarg :ewi-key :accessor ewi-key)
   (ewi-luft :initform 0 :initarg :ewi-luft :accessor ewi-luft)
   (ewi-biss :initform 0 :initarg :ewi-biss :accessor ewi-biss)
   (ewi-gl-up :initform 0 :initarg :ewi-gl-up :accessor ewi-gl-up)
   (ewi-gl-dwn :initform 0 :initarg :ewi-gl-down :accessor ewi-gl-dwn)
   (ewi-glide :initform 0 :initarg :ewi-glide :accessor ewi-glide)
   (ewi-type :initform 0 :initarg :ewi-type :accessor ewi-type)
   (l6-a :initform nil :initarg :l6-a :accessor l6-a)
   (l6-b :initform nil :initarg :l6-b :accessor l6-b)
   (l6-c :initform nil :initarg :l6-c :accessor l6-c)
   (l6-d :initform nil :initarg :l6-d :accessor l6-d)
   (l6-vol :initform nil :initarg :l6-vol :accessor l6-vol)
   (ewi-hold :initform nil :initarg :ewi-hold :accessor ewi-hold)
   (ewi-fwd :initform nil :initarg :ewi-fwd :accessor ewi-fwd)
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
               ewi-gl-up ewi-gl-down ewi-glide ewi-type ewi-hold ewi-fwd
               l6-a l6-b l6-c l6-d l6-vol
               midi-cc-fns midi-note-fns)
      instance
    (let ((main (#_new QVBoxLayout instance))
          (grid (#_new QGridLayout)))
      (#_setStyleSheet midi-cc-fns *nanokontrol-box-style*)
      (#_setStyleSheet midi-note-fns *nanokontrol-box-style*)
      (loop
        for slot in '(ewi-apr ewi-key ewi-luft
                      ewi-biss ewi-gl-up ewi-gl-dwn ewi-glide l6-vol
                      ewi-type)
        for idx from 0
        for col =  (* 2 (mod idx 8))
        for row = (floor idx 8)
        do (let ((new-lsbox
                   (make-instance
                    'label-spinbox
                    :label (format nil
                                   "~a:"
                                   (cl-ppcre:regex-replace
                                    "ewi-"
                                    (string-downcase (symbol-name slot)) ""))
                    :id (ou::make-keyword slot)))
                 (lsboxlayout (#_new QHBoxLayout)))
             (if (member slot '(ewi-type))
                 (#_setRange (text-box new-lsbox) 0 4)
                 (#_setRange (text-box new-lsbox) 0 127))
             (setf (slot-value instance slot) new-lsbox)
             (#_addWidget grid (label-box new-lsbox) row col)
             (#_addWidget lsboxlayout (text-box new-lsbox))
             (#_addStretch lsboxlayout)
             (#_addLayout grid lsboxlayout row (1+ col))))
      (loop
        for slot in '(l6-a l6-b l6-c l6-d nil ewi-hold ewi-fwd)
        for idx from 1
        for col =  (* 2 (mod idx 8))
        for row = (1+ (floor idx 8))
        do (if slot (let ((new-label-pb
                            (make-instance
                             (if (member slot '(ewi-hold ewi-fwd))
                                 'label-toggle
                                 'label-pushbutton)
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
                      (#_addLayout grid label-pblayout row col))))
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

(defun make-ewi-gui (&rest args)
  (let ((id (getf args :id :ewi1)))
    (if (find-gui id) (progn (close-gui id) (sleep 1)))
    (apply #'create-tl-widget 'ewi-gui id args)))




#|
cleanup-fn ewi-luft ewi-biss
          ewi-gl-up ewi-gl-dwn ewi-glide ewi-hold ewi-fwd
          l6-a l6-b l6-c l6-d l6-vol

(export '(ewi-gui cleanup-fn ewi-luft ewi-biss
          ewi-gl-up ewi-gldwn ewi-glide ewi-hold ewi-fwd
          l6-a l6-b l6-c l6-d l6-vol)
        'cuda-gui)
|#

(defmethod remove-model-refs ((instance ewi-gui))
  "cleanup: removes the refs in the model of the gui's labelboxes"
  (loop
    for slot in '(ewi-luft ewi-biss ewi-gl-up ewi-gl-dwn ewi-glide)
    do (set-ref (slot-value instance slot) nil)))

#|
(export '(make-ewi-gui cleanup-fn ewi-luft ewi-biss
          ewi-gl-up ewi-gl-dwn ewi-glide ewi-hold ewi-fwd
          l6-a l6-b l6-c l6-d l6-vol)
        'incudine-gui)
|#


;;; 
(in-package :luftstrom-display)

(defclass ewi-controller (midi-controller)
  ((gui :initarg :gui :accessor gui)
   (player :initarg :player :initform :player1 :accessor player)))


(defmethod set-model-refs ((instance ewi-controller))
  (with-slots (gui player) instance
    (let ((player-ref (player-aref player)))
      (loop
        for slot in '(cuda-gui::ewi-luft
                      cuda-gui::ewi-biss
                      cuda-gui::ewi-gl-up
                      cuda-gui::ewi-gl-dwn
                      cuda-gui::ewi-glide)
        with cc-offs = (ash player-ref 4)
        for idx from cc-offs
        do (set-ref (slot-value gui slot)
                    (aref *audio-preset-ctl-model* idx)))
      (set-ref (slot-value gui 'cuda-gui::ewi-apr)
               (apr-model player-ref))
      (set-ref (slot-value gui 'cuda-gui::ewi-type)
               (slot-value (aref *obstacles* (1- player-ref)) 'type)
               :map-fn #'map-type
               :rmap-fn #'rmap-type))))

      


(defun apr-model (player-ref)
  (slot-value cl-boids-gpu::*bp*
              (aref #(cl-boids-gpu::auto-apr
                      cl-boids-gpu::pl1-apr
                      cl-boids-gpu::pl2-apr
                      cl-boids-gpu::pl3-apr
                      cl-boids-gpu::pl4-apr)
                    player-ref)))


#|


(setf
(find-gui :ewi1)
(cuda-gui::ewi-gui :id :ewi1
:player :player1
                   :x-pos 0
                   :y-pos 580
                   :height 60)

(cuda-gui::emit-signal (ewi-biss (find-gui :ewi1)) "setValue(int)" 22)

(set-model-refs)                                      ;
(set-pvb-value (ewi-biss (find-gui :ewi1)) 22)
(set-pvb-value (ewi-biss (find-gui :ewi1)) 22)

|#

(defmethod initialize-instance :after ((instance ewi-controller) &key (x-pos 0) (y-pos 0)
                                       &allow-other-keys)
  (with-slots (cc-fns cc-map gui id chan midi-output) instance
    (setf cc-map
          (get-inverse-lookup-array
           '(16 17 18 19 20 21 22 23 ;;; dials
             0 1 2 3 4 5 6 7         ;;; fader
;;; transport-ctl:
             58 59                   ;;; 16 17
             46    60 61 62          ;;; 18    19 20 21
             43 44 42 41 45          ;;; 22 23 24 25 26
;;; S/M/R pushbuttons:
             32 33 34 35 36 37 38 39 ;;; 27 28 29 30 31 32 33 34
             48 49 50 51 52 53 54 55 ;;; 35 36 37 38 39 40 41 42
             64 65 66 67 68 69 70 71 ;;; 43 44 45 46 47 48 49 50
             )))
    (setf gui (cuda-gui::make-ewi-gui :id id
                       :x-pos x-pos
                       :y-pos y-pos))
    (setf (cuda-gui::cleanup-fn gui)
          (let ((id id) (gui gui))
            (lambda ()
              (remove-midi-controller id)
              (cuda-gui::remove-model-refs gui)
;;;              (remove-pushbutton-cell-hooks instance *bp*)
              )))
    (sleep 1)
    ;;    (setf cc-fns (sub-array *cc-fns* (player-ref :nk2)))
    (set-model-refs instance)
    (map nil (lambda (fn) (setf fn #'identity)) cc-fns)
             
;;;    (set-fixed-cc-fns instance)
    ;;    (init-ewi-controller-gui-callbacks instance)
    ;;             (set-pushbutton-cell-hooks instance *bp*)
    ))

;;; (load-audio-preset :no 4 :player-ref (player-aref :player1))


#|
(defmethod set-pushbutton-cell-hooks ((instance ewi-controller) ref)
  (setf (slot-value (load-audio ref) 'set-cell-hook) (lambda (val) (declare (ignore val)) (set-bs-preset-buttons instance)))
  (setf (slot-value (load-boids ref) 'set-cell-hook) (lambda (val) (declare (ignore val)) (set-bs-preset-buttons instance)))
  (setf (slot-value (load-obstacles ref) 'set-cell-hook) (lambda (val) (declare (ignore val)) (set-bs-preset-buttons instance))))

(defgeneric remove-pushbutton-cell-hooks (instance ref)
  (:documentation "remove the cell hook update-functions on state change of load-boids, load-audio or load-obstacles in *bp*")
  (:method ((instance ewi-controller) ref) 
    (setf (slot-value (load-audio ref) 'set-cell-hook) nil)
    (setf (slot-value (load-boids ref) 'set-cell-hook) nil)
    (setf (slot-value (load-obstacles ref) 'set-cell-hook) nil)))

|#

(defmethod handle-midi-in ((instance ewi-controller) opcode d1 d2)
  (with-slots (gui chan cc-map cc-fns cc-offset midi-output rec-state bs-copy-state) instance
    (case opcode
      (:cc (cond
             ((or (<= 0 d1 7) (<= 16 d1 23))
              (cuda-gui::handle-cc-in
               gui
               (aref cc-map d1) ;;; idx of numbox in gui
               d2))
             ;;; transport-controls
             ((= d1 58) (if (= d2 127) (previous-preset))) ;;; upper <-
             ((= d1 59) (if (= d2 127) (next-preset)))     ;;; upper ->
             ((= d1 46) (if (= d2 127) (edit-preset-in-emacs *curr-preset-no*))) ;;;; cycle button
             ((= d1 60) (if (= d2 127) (load-current-audio-preset))) ;;; set button
             ((= d1 61) (if (= d2 127) (previous-audio-preset))) ;;; lower <-
             ((= d1 62) (if (= d2 127) (next-audio-preset)))     ;;; lower ->
             ((= d1 43) (load-current-preset))       ;;; rewind button
             ((= d1 44) (incudine:flush-pending))    ;;; fastfwd button
             ((= d1 42) (cl-boids-gpu::reshuffle-life cl-boids-gpu::*win* :regular nil)) ;;; stop button
             ((= d1 41) ;;; Play Transport-ctl Button
              (progn
                (setf bs-copy-state (if (zerop bs-copy-state) 1 0))
                (funcall (ctl-out midi-output d1 (if (zerop bs-copy-state) 0 127) chan))))
             ((= d1 45) ;;; Rec Transport-ctl Button
              (progn
                (setf rec-state (not rec-state))
                (funcall (ctl-out midi-output d1 (if rec-state 127 0) chan))))
               ;;; S/M Pushbuttons
             ((or (<= 32 d1 39)
                  (<= 48 d1 55))
;;;              (funcall (ctl-out midi-output d1 127 chan))
              (bs-preset-button-handler instance d1))
               ;;; R Pushbuttons
             ((<= 64 d1 71)
              (setf cc-offset (* 16 (- d1 64)))
              (loop for cc from 64 to 71
                    do (funcall (ctl-out midi-output cc (if (= cc d1) 127 0) chan)))
              (set-bs-preset-buttons instance))))
      (:note-on nil)
      (:note-off nil))))

(defgeneric init-ewi-controller-gui-callbacks (instance &key midi-echo)
  (:documentation "init the gui callback functions specific for the controller type."))

(defmethod init-ewi-controller-gui-callbacks ((instance ewi-controller) &key (midi-echo t))
  (declare (ignore midi-echo))
  ;;; dials and faders, absolute (no influence of cc-offset!!!)
  (with-slots (gui note-fn cc-fns cc-state cc-offset chan midi-output) instance
    (loop for idx below 16
          do (set-encoder-callback
              gui
              idx
              (let ((idx idx))
                (lambda (val)
                  (setf (aref cc-state idx) val)
                  (funcall (aref cc-fns idx) val)))))
    (set-nk2-std gui)))


#|
(val (slot-value (find-gui :ewi1) 'cuda-gui::ewi-biss))

(find-gui :nk2)





|#
