;;;; classes.lisp
;;;;
;;;; Copyright (c) 2017-18 Orm Finnendahl
;;;; <orm.finnendahl@selma.hfmdk-frankfurt.de>
 
(in-package #:cl-boids-gpu)

(defparameter *program-sources*
  '(
;;;    "boids_reflection"
;;;    "boids_reflection3"
;;;    "boids_reflection2"
    "boids"
    "calc_weight"
    "clear_board"
    ))

(defclass opencl-boids-window (glut:window)
  ((device :initarg :device :reader device)
   (command-queues :initarg :command-queues :initform nil :accessor command-queues)
   (kernel :initform nil :accessor kernel)
   (calc-weight-kernel :initform nil :accessor calc-weight-kernel)
   (clear-board-kernel :initform nil :accessor clear-board-kernel)
   (systems :initform nil :accessor systems)
   (gl-width :initform 1600 :accessor gl-width)
   (gl-height :initform 900 :accessor gl-height)
   (gl-aspect :initform 16/9 :accessor gl-aspect)
   (gl-scale :initform 1.0 :accessor gl-scale)
   (gl-valign :initform :center :accessor gl-valign)
   (gl-halign :initform :center :accessor gl-halign)
   (viewport :initform nil :accessor viewport)
   (mouse-gl-fn :initform (lambda (x y) (list (float x) (float y) 0.0 0.0)) :accessor mouse-gl-fn)
   (show-fps :initform nil :accessor show-fps)
   (show-frame :initform nil :accessor show-frame)
   (mouse-x :initform 0 :accessor mouse-x)
   (mouse-y :initform 0 :accessor mouse-y)) 
  (:default-initargs :width 640 :height 480 :title "OpenCL Boids"
                     :mode '(:double :rgb :depth :multisample)))

(defclass bp-slot (model-slot)
  ((pvbox :initarg :pvbox :initform nil :accessor pvbox)))

(defclass boid-params ()
  ((num-boids :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :num-boids :accessor num-boids)
   (clockinterv :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :clockinterv :accessor clockinterv)
   (obstacles-lookahead :type bp-slot :initform (make-instance 'bp-slot :val 2.5) :initarg :obstacles-lookahead :accessor obstacles-lookahead)
   (speed :type bp-slot :initform (make-instance 'bp-slot :val 2.0) :initarg :speed :accessor bp-speed)
;;;   (maxspeed :type bp-slot :initform (make-instance 'bp-slot :val 0.3) :initarg :maxspeed :accessor maxspeed)
;;;   (maxforce :type bp-slot :initform (make-instance 'bp-slot :val 0.0009) :initarg :maxforce :accessor maxforce)
   (maxidx :type bp-slot :initform (make-instance 'bp-slot :val 317) :initarg :maxidx :accessor maxidx)
   (length :type bp-slot :initform (make-instance 'bp-slot :val 5) :initarg :length :accessor len)
   (sepmult :type bp-slot :initform (make-instance 'bp-slot :val 1) :initarg :sepmult :accessor sepmult)
   (alignmult :type bp-slot :initform (make-instance 'bp-slot :val 1) :initarg :alignmult :accessor alignmult)
   (cohmult :type bp-slot :initform (make-instance 'bp-slot :val 3) :initarg :cohmult :accessor cohmult)
   (predmult :type bp-slot :initform (make-instance 'bp-slot :val 2) :initarg :predmult :accessor predmult)
   (maxlife :type bp-slot :initform (make-instance 'bp-slot :val 60000.0) :initarg :maxlife :accessor maxlife)
   (lifemult :type bp-slot :initform (make-instance 'bp-slot :val 100.0) :initarg :lifemult :accessor lifemult)
;;;
   (boids-per-click :type bp-slot :initform (make-instance 'bp-slot :val 1) :initarg :boids-per-click :accessor boids-per-click)
   (boids-add-time :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :boids-add-time :accessor boids-add-time)
   (boids-add-x :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :boids-add-x :accessor boids-add-x)
   (boids-add-remove :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :boids-add-remove :accessor boids-add-remove)
   (boids-add-y :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :boids-add-y :accessor boids-add-y)
   (master-amp :type bp-slot :initform (make-instance 'bp-slot :val 1.0) :initarg :master-amp :accessor master-amp)
   (auto-apr :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :auto-apr :accessor auto-apr)
   (auto-amp :type bp-slot :initform (make-instance 'bp-slot :val 1.0) :initarg :auto-amp :accessor auto-amp)
   (pl1-apr :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :pl1-apr :accessor pl1-apr)
   (pl1-amp :type bp-slot :initform (make-instance 'bp-slot :val 1.0) :initarg :pl1-amp :accessor pl1-amp)
   (pl2-apr :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :pl2-apr :accessor pl2-apr)
   (pl2-amp :type bp-slot :initform (make-instance 'bp-slot :val 1.0) :initarg :pl2-amp :accessor pl2-amp)
   (pl3-apr :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :pl3-apr :accessor pl3-apr)
   (pl3-amp :type bp-slot :initform (make-instance 'bp-slot :val 1.0) :initarg :pl3-amp :accessor pl3-amp)
   (pl4-apr :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :pl4-apr :accessor pl4-apr)
   (pl4-amp :type bp-slot :initform (make-instance 'bp-slot :val 1.0) :initarg :pl4-amp :accessor pl4-amp)
   (default-apr :type bp-slot :initform (make-instance 'bp-slot :val 0) :initarg :default-apr :accessor default-apr)
   (bs-preset-change-subscribers :initform nil :accessor bs-preset-change-subscribers)))

(defmacro model-slot-register-setf-method (slot-reader class-name)
  `(progn
     (warn "~&redefining setf for (~a ~a)" ',slot-reader ',class-name)
     (defgeneric (setf ,slot-reader) (val ,class-name)
       (:method (val (instance boid-params))
         (set-cell (,slot-reader instance) val)))))

(defun class-get-model-slot-readers (class-name)
  (let ((tmp (make-instance class-name))
         (class (find-class class-name)))
     (c2mop:ensure-finalized class)
     (loop for slot-def in (c2mop:class-direct-slots class)
           for slot-name = (c2mop:slot-definition-name slot-def)
           if (typep (slot-value tmp slot-name) 'model-slot)
             collect (first (c2mop:slot-definition-readers slot-def)))))

(defun class-get-model-slot-reader-defs (class-name)
  (loop for reader in (class-get-model-slot-readers class-name)
        collect `(model-slot-register-setf-method ,reader ,class-name)))

;;; (class-get-model-slot-reader-defs 'boid-params)

(defmacro class-redefine-model-slots-setf (class-name)
  `(progn
     ,@(class-get-model-slot-reader-defs class-name)))

(defstruct obstacle-targets
  (dx 0 :type integer)
  (dy 0 :type integer)
  (x-steps 0 :type integer)
  (y-steps 0 :type integer)
  (x-clip nil :type boolean)
  (y-clip nil :type boolean))

(defclass boid-system-state2 ()
  ((bs-num-boids :initarg :bs-num-boids :initform nil :accessor bs-num-boids)
   (bs-positions :initarg :bs-positions :initform nil :accessor bs-positions)
   (bs-velocities :initarg :bs-velocities :initform nil :accessor bs-velocities)
   (bs-life :initarg :bs-life :initform nil :accessor bs-life)
   (bs-retrig :initarg :bs-retrig :initform nil :accessor bs-retrig)
   (bs-obstacles :initarg :bs-obstacles :initform nil :accessor bs-obstacles)
   (bs-pixelsize :initarg :bs-pixelsize :initform 5 :accessor bs-pixelsize)
   (bs-preset :initarg :bs-preset :initform 0 :accessor bs-preset)
   (speed  :initarg :speed :initform 0 :accessor bp-speed)
   (len :initarg :len :initform 0 :accessor len)
   (sepmult :initarg :sepmult :initform 0 :accessor sepmult)
   (cohmult :initarg :cohmult :initform 0 :accessor cohmult)
   (alignmult :initarg :alignmult :initform 0 :accessor alignmult)
   (predmult :initarg :predmult :initform 0 :accessor predmult)
   (maxlife :initarg :maxlife :initform 60000 :accessor maxlife)
   (lifemult :initarg :lifemult :initform 0 :accessor lifemult)
   (start-time :initarg :start-time :initform 0 :reader start-time)
   (last-update :initarg :last-update :initform () :reader last-update-time)
   (note-states :initarg :note-states :initform nil :accessor note-states)
   (midi-cc-state :initarg :midi-cc-state :initform nil :accessor midi-cc-state)
   (midi-cc-fns :initarg :midi-cc-fns :initform nil :accessor midi-cc-fns)
   (audio-args :initarg :audio-args :initform nil :accessor audio-args)))

(defclass boid-system-state3 ()
  ((bs-num-boids :initarg :bs-num-boids :initform nil :accessor bs-num-boids)
   (bs-positions :initarg :bs-positions :initform nil :accessor bs-positions)
   (bs-velocities :initarg :bs-velocities :initform nil :accessor bs-velocities)
   (bs-life :initarg :bs-life :initform nil :accessor bs-life)
   (bs-retrig :initarg :bs-retrig :initform nil :accessor bs-retrig)
   (bs-obstacles :initarg :bs-obstacles :initform nil :accessor bs-obstacles)
   (bs-pixelsize :initarg :bs-pixelsize :initform 5 :accessor bs-pixelsize)
   (bs-preset :initarg :bs-preset :initform 0 :accessor bs-preset)
   (boids-per-click :initarg :boids-per-click :initform 1 :accessor boids-per-click)
   (boids-add-time :initarg :boids-add-time :initform 0 :accessor boids-add-time)
   (clock-interval :initarg :clock-interval :initform 0 :accessor clock-interval)
   (speed  :initarg :speed :initform 0 :accessor bp-speed)
   (len :initarg :len :initform 0 :accessor len)
   (sepmult :initarg :sepmult :initform 0 :accessor sepmult)
   (cohmult :initarg :cohmult :initform 0 :accessor cohmult)
   (alignmult :initarg :alignmult :initform 0 :accessor alignmult)
   (predmult :initarg :predmult :initform 0 :accessor predmult)
   (maxlife :initarg :maxlife :initform 60000 :accessor maxlife)
   (lifemult :initarg :lifemult :initform 0 :accessor lifemult)
   (start-time :initarg :start-time :initform 0 :reader start-time)
   (last-update :initarg :last-update :initform () :reader last-update-time)
   (note-states :initarg :note-states :initform nil :accessor note-states)
   (midi-cc-state :initarg :midi-cc-state :initform nil :accessor midi-cc-state)
   (midi-cc-fns :initarg :midi-cc-fns :initform nil :accessor midi-cc-fns)
   (audio-args :initarg :audio-args :initform nil :accessor audio-args)))

(defclass boid-system-state ()
  ((bs-num-boids :initarg :bs-num-boids :initform nil :accessor bs-num-boids)
   (bs-positions :initarg :bs-positions :initform nil :accessor bs-positions)
   (bs-velocities :initarg :bs-velocities :initform nil :accessor bs-velocities)
   (bs-life :initarg :bs-life :initform nil :accessor bs-life)
   (bs-retrig :initarg :bs-retrig :initform nil :accessor bs-retrig)
   (bs-obstacles :initarg :bs-obstacles :initform nil :accessor bs-obstacles)
   (bs-pixelsize :initarg :bs-pixelsize :initform 5 :accessor bs-pixelsize)
   (bs-preset :initarg :bs-preset :initform 0 :accessor bs-preset)
   (maxforce  :initarg :bs-preset :initform 0 :accessor maxforce)
   (maxspeed  :initarg :bs-preset :initform 0 :accessor maxspeed)
   (len :initarg :len :initform 0 :accessor len)
   (sepmult :initarg :sepmult :initform 0 :accessor sepmult)
   (cohmult :initarg :cohmult :initform 0 :accessor cohmult)
   (alignmult :initarg :alignmult :initform 0 :accessor alignmult)
   (predmult :initarg :predmult :initform 0 :accessor predmult)
   (maxlife :initarg :maxlife :initform 60000 :accessor maxlife)
   (lifemult :initarg :lifemult :initform 0 :accessor lifemult)
   (start-time :initform (now) :reader start-tqime)
   (last-update :initform () :reader last-update-time)
   (note-states :initform nil :accessor note-states)
   (midi-cc-state :initform nil :accessor midi-cc-state)
   (midi-cc-fns :initform nil :accessor midi-cc-fns)
   (audio-args :initform nil :accessor audio-args)))



(defun cp-bstate (src dest)
  (loop
    for src-slot in '(bs-positions bs-num-boids bs-velocities bs-life bs-retrig bs-obstacles bs-pixelsize
                      bs-preset maxspeed len sepmult cohmult alignmult
                      predmult maxlife lifemult start-time last-update note-states
                      midi-cc-state midi-cc-fns audio-args)
    do (case src-slot
         ('maxspeed
          (setf (slot-value dest 'speed) (/ (slot-value src 'maxspeed) 1.05)))
         (otherwise
          (setf (slot-value dest src-slot) (slot-value src src-slot)))))
  (unless (numberp (slot-value dest 'bs-preset))
    (let* ((bs-preset (slot-value dest 'bs-preset))
           (boid-params (getf bs-preset :boid-params))
           (maxspeed (getf boid-params :maxspeed)))
      (when maxspeed (setf (getf boid-params :speed) (/ maxspeed 1.05)))
      (remf boid-params :maxspeed)
      (remf boid-params :maxforce)))
  dest)
