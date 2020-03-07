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
             (if (eq slot 'ewi-type)
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

(defun inc-obst-type (instance)
  (cuda-gui::emit-signal (cuda-gui::ewi-type instance) "incValue(int)" 1))

(defun dec-obst-type (instance)
  (cuda-gui::emit-signal (cuda-gui::ewi-type instance) "incValue(int)" -1))

(defmethod init-gui-callbacks ((instance ewi-gui) &key (echo nil))
  (declare (ignore echo))
;;;  (format t "~&init-gui-callbacks: ~a" instance)
  (setf (callback (l6-a instance))
        (lambda () (dec-obst-type instance)))
  (setf (cuda-gui::callback (l6-b instance))
        (lambda () (inc-obst-type instance)))
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
;;  (format t "~&clear-gui-callbacks: ~a" instance)
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
   (player :initarg :player :initform :player1 :accessor player)
   (angle :initarg :angle :initform 0 :accessor angle)
   (steering :initarg :steering :initform 0 :accessor steering)
   (speedfactor :initarg :speed :initform 1 :accessor speedfactor)
   (minspeed :initarg :minspeed :initform 1 :accessor minspeed)
   (maxspeed :initarg :maxspeed :initform 400 :accessor maxspeed)
   
   (direction :initarg :direction :initform 1 :accessor direction)
   (moving :initarg :moving :initform nil :accessor moving)))


;;; steering-fn wird aktiviert/deaktiviert durch Knopf)
;;; Bewegung hängt am Luft-Regler
;;; Steering hängt an gl-up/dwn
;;; Winkel wird durch steering automatisch upgedated (in der steering fn, d.h. kein Update bei nicht-Bewegung!)

(defmacro with-registering-osc-responder ((osc-string player) &rest forms)
  `(push (make-osc-responder
          osc-in (format nil ,osc-string ,player) "f"
          (lambda (val)
            ,@forms))
         responders))

(defgeneric ewi-register-osc-responders (instance)
  (:documentation "for ewi controllers, the osc responders have to get
  registered after the refs have been set in the initialize-instance
  :after method.")
  (:method ((instance ewi-controller))
    (with-slots (player osc-in gui responders) instance
      (if gui
          (with-slots (cuda-gui::ewi-luft
                       cuda-gui::ewi-biss
                       cuda-gui::ewi-gl-up
                       cuda-gui::ewi-gl-dwn
                       cuda-gui::ewi-glide
                       cuda-gui::ewi-hold
                       cuda-gui::ewi-trans
                       cuda-gui::ewi-key
                       cuda-gui::l6-a
                       cuda-gui::l6-b
                       cuda-gui::l6-c
                       cuda-gui::l6-d
                       cuda-gui::l6-vol)
              gui
            (let ((obstacle (aref *obstacles* (1- player))))
              (with-slots (brightness radius active)
                  obstacle
                (push (make-osc-responder
                       osc-in (format nil "/pl~d-luft" player) "f"
                       (lambda (val)
                         ;; (format t "~&pl~d-luft: ~a~%" player val)
                         (setf (val cuda-gui::ewi-luft) (round val))
                         (when (and (numberp val) (val active))
                           (let ((ipfn (ip-exp 2.5 10.0 128)))
                             (set-lookahead player (float (funcall ipfn val))))
                           (let ((ipfn (ip-exp 1 1.0 128)))
                             (set-multiplier player (float (funcall ipfn val))))
                           (let ((ipfn (ip-lin 0.2 1.0 128)))
                             (setf (val brightness) (funcall ipfn val))))))
                      responders)))
            (with-registering-osc-responder ("/pl~d-biss" player)
              (setf (val cuda-gui::ewi-biss) (round val)))
            (with-registering-osc-responder ("/pl~d-glide" player)
              (setf (val cuda-gui::ewi-glide) (round val)))
            ;;               (break "~a ~a" gui (slot-value gui 'cuda-gui::ewi-luft))
            (let ((move-fn (make-retrig-move-fn
                            (1- player)
                            :dir :up :max 400
                            :ref (slot-value gui 'cuda-gui::ewi-luft)
                            :clip nil)))
              (with-registering-osc-responder ("/pl~d-gl-up" player)
                (setf (val cuda-gui::ewi-gl-up) (round val))
                (funcall move-fn val)))
            (let ((move-fn (make-retrig-move-fn
                            (1- player)
                            :dir :down :max 400
                            :ref (slot-value gui 'cuda-gui::ewi-luft)
                            :clip nil)))
              (with-registering-osc-responder ("/pl~d-gl-dwn" player)
                (setf (val cuda-gui::ewi-gl-dwn) (round val))
                (funcall move-fn val)))
            (let ((move-fn (make-retrig-move-fn
                            (1- player)
                            :dir :left :max 400
                            :ref (slot-value gui 'cuda-gui::ewi-luft)
                            :clip nil)))
              (with-registering-osc-responder ("/pl~d-hold" player)
                (if (zerop val)
                    (cuda-gui::emit-signal cuda-gui::ewi-hold "changeValue(int)" 0)
                    (cuda-gui::emit-signal cuda-gui::ewi-hold "changeValue(int)" 127))
                (funcall move-fn val)))
            (let ((move-fn (make-retrig-move-fn
                            (1- player)
                            :dir :right :max 400
                            :ref (slot-value gui 'cuda-gui::ewi-luft)
                            :clip nil)))
              (with-registering-osc-responder ("/pl~d-trans" player)
                (if (zerop val)
                    (cuda-gui::emit-signal cuda-gui::ewi-trans "changeValue(int)" 0)
                    (cuda-gui::emit-signal cuda-gui::ewi-trans "changeValue(int)" 127))
                (funcall move-fn val)))
            (with-registering-osc-responder ("/pl~d-toggle-active" player)
              (unless (zerop val) (toggle-obstacle (1- player))))
            (with-registering-osc-responder ("/pl~d-l6-a" player)
              (unless (zerop val)
                (cuda-gui::emit-signal cuda-gui::l6-a "pressed()")))
            (with-registering-osc-responder ("/pl~d-l6-b" player)
              (unless (zerop val)
                (cuda-gui::emit-signal cuda-gui::l6-b "pressed()")))
            (with-registering-osc-responder ("/pl~d-l6-c" player)
              (unless (zerop val)
                (cuda-gui::emit-signal cuda-gui::l6-c "pressed()")))
            (with-registering-osc-responder ("/pl~d-l6-d" player)
              (unless (zerop val)
                (cuda-gui::emit-signal cuda-gui::l6-d "pressed()")))
            (with-registering-osc-responder ("/pl~d-l6-vol" player)
              (setf (val cuda-gui::l6-vol) (round val)))
            (with-registering-osc-responder ("/pl~d-key" player)
              (setf (val cuda-gui::ewi-key) (round val))))))))

(defgeneric ewi-register-osc-steering-responders (instance)
  (:documentation "for ewi controllers, the osc responders have to get
  registered after the refs have been set in the initialize-instance
  :after method.")
  (:method ((instance ewi-controller))
    (with-slots (player osc-in gui responders) instance
      (if gui
          (with-slots (cuda-gui::ewi-luft
                       cuda-gui::ewi-biss
                       cuda-gui::ewi-gl-up
                       cuda-gui::ewi-gl-dwn
                       cuda-gui::ewi-glide
                       cuda-gui::ewi-hold
                       cuda-gui::ewi-trans
                       cuda-gui::ewi-key
                       cuda-gui::l6-a
                       cuda-gui::l6-b
                       cuda-gui::l6-c
                       cuda-gui::l6-d
                       cuda-gui::l6-vol)
              gui
            (let ((move-fn (make-retrig-steering-fn instance :min (minspeed instance) :max (maxspeed instance) :clip nil)))
              (let ((obstacle (aref *obstacles* (1- player))))
                (with-slots (brightness radius active)
                    obstacle
                  (with-registering-osc-responder ("/pl~d-luft" player)
                        ;; (format t "~&pl~d-luft: ~a~%" player val)
                    (setf (val cuda-gui::ewi-luft) (round val))
                    (when (and (numberp val) (val active))
                      (let ((ipfn (ip-exp 2.5 10.0 128)))
                        (set-lookahead player (float (funcall ipfn val))))
                      (let ((ipfn (ip-exp 1 1.0 128)))
                        (set-multiplier player (float (funcall ipfn val))))
                      (let ((ipfn (ip-lin 0.2 1.0 128)))
                        (setf (val brightness) (funcall ipfn val)))
                      (funcall move-fn)))))
              (with-registering-osc-responder ("/pl~d-biss" player)
                (setf (val cuda-gui::ewi-biss) (round val)))
              (with-registering-osc-responder ("/pl~d-glide" player)
                (setf (val cuda-gui::ewi-glide) (round val)))
              ;;               (break "~a ~a" gui (slot-value gui 'cuda-gui::ewi-luft))
              (with-registering-osc-responder ("/pl~d-gl-up" player)
                (setf (val cuda-gui::ewi-gl-up) (round val)))
              (with-registering-osc-responder ("/pl~d-gl-dwn" player)
                (setf (val cuda-gui::ewi-gl-dwn) (round val)))
              (with-registering-osc-responder ("/pl~d-hold" player)
                (if (zerop val)
                    (cuda-gui::emit-signal cuda-gui::ewi-hold "changeValue(int)" 0)
                    (progn
                      (setf (moving instance) (not (moving instance)))
                      (cuda-gui::emit-signal cuda-gui::ewi-hold "changeValue(int)" 127)))
)
              (with-registering-osc-responder ("/pl~d-trans" player)
                (if (zerop val)
                    (progn
                      (setf (direction instance) 1)
                      (cuda-gui::emit-signal cuda-gui::ewi-trans "changeValue(int)" 0))
                    (progn
                      (setf (direction instance) -1)
                      (cuda-gui::emit-signal cuda-gui::ewi-trans "changeValue(int)" 127))))
              (with-registering-osc-responder ("/pl~d-toggle-active" player)
                (unless (zerop val) (toggle-obstacle (1- player))))
              (with-registering-osc-responder ("/pl~d-l6-a" player)
                (unless (zerop val)
                  (cuda-gui::emit-signal cuda-gui::l6-a "pressed()")))
              (with-registering-osc-responder ("/pl~d-l6-b" player)
                (unless (zerop val)
                  (cuda-gui::emit-signal cuda-gui::l6-b "pressed()")))
              (with-registering-osc-responder ("/pl~d-l6-c" player)
                (unless (zerop val)
                  (cuda-gui::emit-signal cuda-gui::l6-c "pressed()")))
              (with-registering-osc-responder ("/pl~d-l6-d" player)
                (unless (zerop val)
                  (cuda-gui::emit-signal cuda-gui::l6-d "pressed()")))
              (with-registering-osc-responder ("/pl~d-l6-vol" player)
                (setf (val cuda-gui::l6-vol) (round val)))
              (with-registering-osc-responder ("/pl~d-key" player)
                (setf (val cuda-gui::ewi-key) (round val)))))))))

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

(defmethod initialize-instance :before ((instance ewi-controller) &rest args
                                        &key (x-pos 0) (y-pos 0) (width 750) (height 60)
                                          (id :ewi)
                                        &allow-other-keys)
  (declare (ignorable x-pos y-pos width height))
  (with-slots (gui) instance
    (setf gui (apply #'cuda-gui::make-ewi-gui :id id args))
    (setf (cuda-gui::cleanup-fn gui)
          (let ((id id))
            (lambda ()
              (remove-osc-controller id)
              (cuda-gui::remove-model-refs gui)
              (luftstrom-display::remove-osc-responders instance)
              (cuda-gui::clear-gui-callbacks gui))))))

(defmethod initialize-instance :after ((instance ewi-controller) &rest args &key
                                       &allow-other-keys)
  (declare (ignore args))
  (at (+ (now) 1) (lambda ()
                    (set-refs instance)
;;;                    (ewi-register-osc-responders instance)
                    (ewi-register-osc-steering-responders instance)
                    ;;                      (init-ewi-controller-gui-callbacks instance)
                    )))

(defun make-retrig-move-fn (player &key (dir :up) (num-steps 10) (max 100) (ref nil) (clip nil))
  "return a function moving the obstacle of a player in a direction
specified by :dir which can be bound to be called each time, a new
event (like a cc value) is received. If ref is specified it points to
a cc value stored in *cc-state* which is used for exponential interpolation
of the boid's stepsize between 0 and :max pixels."
  (let* ((clip clip)
         (obstacle (obstacle player))
;;         (gl-ref player)
         (retrig? nil)
         (val -1))
;;;    (format t "ref: ~a" ref)

    (lambda (d2)
      (let ((gl-ref (obstacle-ref obstacle)))
        (labels ((retrig (time)
                   "recursive function (with time delay between calls)
simulating a repetition of keystrokes after a key is depressed (once)
until it is released."
                   (if (and retrig? (obstacle-active obstacle))
                       (let ((next (+ time 0.1)))
                         (progn
;;                           (format t "~&moving ~a, ~a by ~a" dir val (ou:m-exp-zero (val ref) 1 max))
                           (case dir
                             (:left (set-obstacle-dx
                                     gl-ref
                                     (float (* -1 (if ref (ou:m-exp-zero (val ref) 10 max) 10.0)))
                                     num-steps clip))
                             (:right (set-obstacle-dx
                                      gl-ref
                                      (float (* 1 (if ref (ou:m-exp-zero (val ref) 10 max) 10.0)))
                                      num-steps clip))
                             (:down (set-obstacle-dy
                                     gl-ref
                                     (float (* -1 (if ref (ou:m-exp-zero (* (m-lin val 0.1 2) (val ref)) 10 max) 10.0)))
                                     num-steps clip))
                             (:up (set-obstacle-dy
                                   gl-ref
                                   (float (if ref (ou:m-exp-zero (* (m-lin val 0.1 2) (val ref)) 10 max) 10.0))
                                   num-steps clip))))
                         ;;                       (format t "~&retrig, act: ~a" (obstacle-moving obstacle))
                         (at next #'retrig next))
                       ;;                     (format t "~&movement ~a stopped~%" dir)
                       )))
;;; lambda-function entry point
          ;;        (format t "~&me-received: ~a" d2)
          (setf val d2)
          (cond
            ((numberp d2)
             (if (obstacle-active obstacle)
                 (if (> d2 0)
                     (unless retrig?
                       (setf retrig? t)
                       (retrig (now)))
                     (setf retrig? nil))))
            ((eq d2 'stop)
             (setf retrig? nil))
            (:else (warn "arg ~a not handled by make-retrig-move-fn." d2))))))))

;;; (find-osc-controller :ewi1)

(defun make-retrig-steering-fn (instance &key 
                                           (num-steps 10)
                                           (min 1)
                                           (max 100)
                                           (clip nil))
  "return a function moving the obstacle of a player in a direction
specified by an angle which can be bound to be called each time, a new
event (like a cc value) is received. The air pressure of the ewi is
used for exponential interpolation of the boid's stepsize between 0
and :max pixels."
  (with-slots (player moving gui angle direction) instance
    (let* ((player-idx (1- player))
           (clip clip)
           (obstacle (obstacle player-idx))
           ;;         (gl-ref player)
           (retrig? nil))
;;;    (format t "ref: ~a" ref)

      (with-slots (cuda-gui::ewi-luft cuda-gui::ewi-gl-up cuda-gui::ewi-gl-dwn) gui
        (lambda ()
          (let ((gl-ref (obstacle-ref obstacle)))
            (labels ((retrig (time)
                       "recursive function (with time delay between calls)
simulating a repetition of keystrokes after a key is depressed (once)
until it is released."
                       (if (and retrig? (obstacle-active obstacle) moving)
                           (let ((next (+ time 0.1))
                                 (speed-factor (* direction (ou:m-exp-zero (val cuda-gui::ewi-luft) min max))))
                             (setf angle
                                   (mod
                                    (+ angle (* direction (ou:m-lin (+ (val cuda-gui::ewi-gl-dwn)
                                                                        (* -1 (val cuda-gui::ewi-gl-up)))
                                                                     0 0.3)))
                                           incudine::+twopi+))
                             (progn
                               (set-obstacle-dx
                                gl-ref
                                (float (* speed-factor (cos angle)))
                                num-steps clip)
                               (set-obstacle-dy
                                gl-ref
                                (float (* speed-factor (sin angle)))
                                num-steps clip))
                             (at next #'retrig next))
                           (setf retrig? nil))))
;;; lambda-function entry point
              ;;        (format t "~&me-received: ~a" d2)
              (if (and (obstacle-active obstacle) moving)
                  (unless retrig? ;;; only restart the retrig fn if it isn't already running
                    (setf retrig? t)
                    (retrig (now)))))))))))

(defgeneric reinit-osc-controller (instance)
  (:method ((instance ewi-controller))
    (with-slots (gui) instance
      (cuda-gui::remove-model-refs gui)
      (luftstrom-display::remove-osc-responders instance)
      (at (+ (now) 1) (lambda ()
                        (set-refs instance)
                        (ewi-register-osc-responders instance))))))

(defun reinit-ewi-controllers ()
    (dolist (id '(:ewi1 :ewi2 :ewi3 :ewi))
      (let ((controller (find-osc-controller id)))
        (if controller
            (reinit-osc-controller (find-osc-controller :ewi2))))))

;;; (reinit-ewi-controllers)
;;; (untrace)
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
 
