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
                  ewi-gl-up ewi-gl-dwn ewi-glide ewi-hold ewi-trans
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
   (ewi-trans :initform nil :initarg :ewi-trans :accessor ewi-trans)
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
               ewi-gl-up ewi-gl-down ewi-glide ewi-type ewi-hold ewi-trans
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
        for slot in '(l6-a l6-b l6-c l6-d nil ewi-hold ewi-trans)
        for idx from 1
        for col =  (* 2 (mod idx 8))
        for row = (1+ (floor idx 8))
        do (if slot (let ((new-label-pb
                            (make-instance
                             (if (member slot '(ewi-hold ewi-trans))
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
      ))
  (init-gui-callbacks instance))

(defgeneric init-gui-callbacks (instance &key echo)
  (:documentation "init the gui callbacks."))

(defmethod init-gui-callbacks ((instance ewi-gui) &key (echo nil))
  (declare (ignore echo))
  (format t "~&init-gui-callbacks: ~a" instance)
  (setf (callback (l6-a instance))
        (lambda () (cuda-gui::emit-signal (ewi-type instance) "incValue(int)" -1)))
  (setf (cuda-gui::callback (l6-b instance))
        (lambda () (cuda-gui::emit-signal (ewi-type instance) "incValue(int)" 1)))
  (setf (callback (l6-c instance))
        (lambda () (cuda-gui::emit-signal (ewi-apr instance) "incValue(int)" -1)))
  (setf (callback (l6-d instance))
        (lambda () (cuda-gui::emit-signal (ewi-apr instance) "incValue(int)" 1))))

(defmethod close-event ((instance ewi-gui) ev)
  (declare (ignore ev))
  (remove-gui (id instance))
  (funcall (cleanup-fn instance))
  (stop-overriding))

(defun clear-gui-callbacks (instance &key echo)
  "clear the gui callback functions specific for the controller type."
  (declare (ignore echo))
  (format t "~&clear-gui-callbacks: ~a" instance)
  (setf (callback (l6-a instance)) #'empty-fn)
  (setf (callback (l6-b instance)) #'empty-fn)
  (setf (callback (l6-c instance)) #'empty-fn)
  (setf (callback (l6-d instance)) #'empty-fn))

(defun make-ewi-gui (&rest args)
  (let ((id (getf args :id :ewi1)))
    (if (find-gui id) (progn (close-gui id) (sleep 1)))
    (apply #'create-tl-widget 'ewi-gui id args)))

#|
cleanup-fn ewi-luft ewi-biss
          ewi-gl-up ewi-gl-dwn ewi-glide ewi-hold ewi-trans
          l6-a l6-b l6-c l6-d l6-vol

(export '(ewi-gui cleanup-fn ewi-luft ewi-biss
          ewi-gl-up ewi-gldwn ewi-glide ewi-hold ewi-trans
          l6-a l6-b l6-c l6-d l6-vol)
        'cuda-gui)
|#



(defmethod remove-model-refs ((instance ewi-gui))
  "cleanup: removes the refs in the model of the gui's labelboxes"
  (loop
    for slot in '(ewi-luft ewi-biss ewi-gl-up ewi-gl-dwn ewi-glide ewi-apr ewi-type)
    do (set-ref (slot-value instance slot) nil)
       (setf (slot-value (slot-value instance slot) 'ref-set-hook) #'identity)))

#|
(export '(make-ewi-gui cleanup-fn ewi-luft ewi-biss
          ewi-gl-up ewi-gl-dwn ewi-glide ewi-hold ewi-trans
          l6-a l6-b l6-c l6-d l6-vol)
        'incudine-gui)
|#


;;; 
(in-package :luftstrom-display)

(defclass ewi-controller (osc-controller)
  ((gui :initarg :gui :accessor gui)
   (player :initarg :player :initform :player1 :accessor player)))

(defmethod register-osc-responders ((instance ewi-controller))
  (with-slots (player osc-in gui responders) instance
    (with-slots (cuda-gui::ewi-luft) gui
      (push (make-osc-responder
             osc-in (format nil "/pl~d-luft" player) "f"
             (lambda (val)
               ;; (format t "~&pl~d-luft: ~a~%" player val)
             (setf (val (slot-value gui 'cuda-gui::ewi-luft)) (round val)))
             )
            responders))
    (push (make-osc-responder
           osc-in (format nil "/pl~d-biss" player) "f"
           (lambda (val)
             ;; (format t "~&pl~d-biss: ~a~%" player val)
             (setf (val (slot-value gui 'cuda-gui::ewi-biss)) (round val))))
          responders)
    (push (make-osc-responder
           osc-in (format nil "/pl~d-gl-up" player) "f"
           (lambda (val)
             ;; (format t "~&pl~d-gl-up: ~a~%" player val)
             (setf (val (slot-value gui 'cuda-gui::ewi-gl-up)) (round val))))
          responders)
    (push
     (make-osc-responder
      osc-in (format nil "/pl~d-gl-dwn" player) "f"
      (lambda (val)
        ;; (format t "~&pl~d-gl-dwn: ~a~%" player val)
        (setf (val (slot-value gui 'cuda-gui::ewi-gl-dwn)) (round val))))
     responders)
    (push
     (make-osc-responder
      osc-in (format nil "/pl~d-glide" player) "f"
      (lambda (val)
        ;; (format t "~&pl~d-glide: ~a~%" player val)
        (setf (val (slot-value gui 'cuda-gui::ewi-glide)) (round val))))
     responders)
    (with-slots (cuda-gui::ewi-hold) gui
      (push (make-osc-responder
             osc-in (format nil "/pl~d-hold" player) "f"
             (lambda (val)
               ;; (format t "~&pl~d-hold: ~a~%" player val)
               (if (zerop val)
                   (cuda-gui::emit-signal (cuda-gui::ewi-hold gui) "changeValue(int)" 0)
                   (cuda-gui::emit-signal (cuda-gui::ewi-hold gui) "changeValue(int)" 127))))
          
            responders))
    (with-slots (cuda-gui::ewi-trans) gui
    (push (make-osc-responder
           osc-in (format nil "/pl~d-trans" player) "f"
           (lambda (val)
             ;; (format t "~&pl~d-trans: ~a~%" player val)
             (if (zerop val)
                 (cuda-gui::emit-signal (cuda-gui::ewi-trans gui) "changeValue(int)" 0)
                 (cuda-gui::emit-signal (cuda-gui::ewi-trans gui) "changeValue(int)" 127))))
          responders))
    (push (make-osc-responder
           osc-in (format nil "/pl~d-l6-a" player) "f"
           (lambda (val)
             ;; (format t "~&pl~d-l6-a: ~a~%" player val)
             (unless (zerop val)
               (cuda-gui::emit-signal (slot-value gui 'cuda-gui::l6-a) "pressed()"))))
          responders)
    (push (make-osc-responder
           osc-in (format nil "/pl~d-l6-b" player) "f"
           (lambda (val)
             ;; (format t "~&pl~d-l6-b: ~a~%" player val)
             (unless (zerop val)
               (cuda-gui::emit-signal (slot-value gui 'cuda-gui::l6-b) "pressed()"))))
          responders)
    (push (make-osc-responder
           osc-in (format nil "/pl~d-l6-c" player) "f"
           (lambda (val)
             ;; (format t "~&pl~d-l6-c: ~a~%" player val)
             (unless (zerop val)
               (cuda-gui::emit-signal (slot-value gui 'cuda-gui::l6-c) "pressed()"))))
          responders)
    (push (make-osc-responder
           osc-in (format nil "/pl~d-l6-d" player) "f"
           (lambda (val)
             ;; (format t "~&pl~d-l6-d: ~a~%" player val)
             (unless (zerop val)
               (cuda-gui::emit-signal (slot-value gui 'cuda-gui::l6-d) "pressed()"))))
          responders)
    (push (make-osc-responder
           osc-in (format nil "/pl~d-l6-vol" player) "f"
           (lambda (val)
             ;; (format t "~&pl~d-l6-vol: ~a~%" player val)
             (setf (val (slot-value gui 'cuda-gui::l6-vol)) (round val))))
          responders)
    (push (make-osc-responder
           osc-in (format nil "/pl~d-key" player) "f"
           (lambda (val)
             ;; (format t "~&pl~d-key: ~a~%" player val)
             (setf (val (slot-value gui 'cuda-gui::ewi-key)) (round val))))
          responders)))

(defmethod set-refs ((instance ewi-controller))
  (with-slots (gui player) instance
;;;    (break "set-refs.")
    (let ((player-ref (player-aref player)))
      (loop
        for slot in '(cuda-gui::ewi-luft
                      cuda-gui::ewi-biss
                      cuda-gui::ewi-gl-up
                      cuda-gui::ewi-gl-dwn
                      cuda-gui::ewi-glide
                      cuda-gui::ewi-key
                      cuda-gui::l6-vol)
        with cc-offs = (ash player-ref 4)
        for idx from cc-offs
        do (progn
             (set-ref (slot-value gui slot)
                      (aref *audio-preset-ctl-model* idx))))
      (set-ref (slot-value gui 'cuda-gui::ewi-apr)
               (apr-model player-ref))
      (setf (slot-value (slot-value gui 'cuda-gui::ewi-apr) 'ref-set-hook)
            (lambda (val)
              (at (now)
                (lambda () (incudine.osc:message
                            (osc-out instance)
                            (format nil "/presetno") "f" (float val))))))
      (setf (slot-value (slot-value gui 'cuda-gui::ewi-type) 'ref-set-hook)
            (lambda (val)
              (at (now)
                (lambda () (incudine.osc:message
                            (osc-out instance)
                            (format nil "/type") "f" (float val))))))
      (set-ref (slot-value gui 'cuda-gui::ewi-type)
               (slot-value (aref *obstacles* (1- player-ref)) 'type)
               :map-fn #'map-type
               :rmap-fn #'rmap-type))))

(defmethod initialize-instance :after ((instance ewi-controller) &key (x-pos 0) (y-pos 0)
                                       &allow-other-keys)
  (with-slots (gui id) instance
    (setf gui (cuda-gui::make-ewi-gui
               :id id
               :x-pos x-pos
               :y-pos y-pos))
    (setf (cuda-gui::cleanup-fn gui)
          (let ((id id))
            (lambda ()
              (remove-osc-controller id)
              (cuda-gui::remove-model-refs gui)
              (luftstrom-display::remove-osc-responders instance)
              (cuda-gui::clear-gui-callbacks gui))))
    (at (+ (now) 1) (lambda () (set-refs instance)
;;                      (init-ewi-controller-gui-callbacks instance)
                      ))
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



;;; (luftstrom-display::dec-type 1)

;;; (luftstrom-display::inc-type 1)



#|
(val (slot-value (find-gui :ewi1) 'cuda-gui::ewi-biss))
|#
