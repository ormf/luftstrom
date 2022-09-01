;;;; classes.lisp
;;;;
;;;; Copyright (c) 2017-18 Orm Finnendahl
;;;; <orm.finnendahl@selma.hfmdk-frankfurt.de>
 
(in-package #:cl-boids-gpu)

(defparameter *program-sources*
  '(
    "boids_reflection"
    "boids_reflection3"
    "boids_reflection2"
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

(defclass boid-system ()
  ((gl-coords :initarg :gl-coords :accessor gl-coords)
   (gl-vel :initarg :gl-vel :accessor gl-vel)
   (gl-life :initarg :gl-life :accessor gl-life)
   (gl-retrig :initarg :gl-retrig :accessor gl-retrig)
   (boid-coords-buffer :initarg :boid-coords-buffer :accessor boid-coords-buffer)
   (velocity-buffer :initarg :velocity-buffer :accessor velocity-buffer)
   (force-buffer :initarg :force-buffer :accessor force-buffer)
   (bidx-buffer :initarg :bidx-buffer :accessor bidx-buffer) ;;; board-idx of boid-pos (+ (/ x pixelsize) (* (/ y pixelsize) board-width))
   (life-buffer :initarg :life-buffer :accessor life-buffer)
   (retrig-buffer :initarg :retrig-buffer :accessor retrig-buffer)
   (color-buffer :initarg :color-buffer :accessor color-buffer)

   (weight-board :initarg :weight-board :initform nil :accessor weight-board) ;;; board accumulating num of boids in each tile
   (align-board :initarg :align-board :initform nil :accessor align-board) ;;; board accumulating average alignment of boids in each tile
   (board-dx :initarg :board-dx :initform nil :accessor board-dx)
   (board-dy :initarg :board-dy :initform nil :accessor board-dy)
   (board-dist :initarg :board-dist :initform nil :accessor board-dist)
   (board-sep :initarg :board-sep :initform nil :accessor board-sep)
   (board-coh :initarg :board-coh :initform nil :accessor board-coh)
   (obstacle-board :initarg :obstacle-board :initform nil :accessor obstacle-board) ;;; board containing obstacles within reach of each tile
   
   (num-obstacles :initarg :num-obstacles :initform 0 :accessor num-obstacles)
   (obstacle-target-posns :initarg :obstacle-target-posns :initform nil :accessor obstacle-target-posns) ;;; used for automatic interpolation of obstacle movement.
   (obstacles-pos :initarg :obstacles-pos :initform nil :accessor obstacles-pos) ;;; pos of each obstacle
   (obstacles-type :initarg :obstacles-type :initform nil :accessor obstacles-type) ;;; type of each obstacle
   (obstacles-radius :initarg :obstacles-radius :initform nil :accessor obstacles-radius) ;;; radius of each obstacle
   (obstacles-lookahead :initarg :obstacles-lookahead :initform 1.0 :accessor obstacles-lookahead) ;;; lookahead of each obstacle
   (obstacles-multiplier :initarg :obstacles-multiplier :initform 1.0 :accessor obstacles-multiplier) ;;; multiplier of each obstacle
   (obstacles-boardoffs-maxidx :initarg :obstacles-boardoffs-maxidx :initform nil :accessor obstacles-boardoffs-maxidx)
   (maxobstacles :initarg :maxobstacles :initform 0 :accessor obstacles)
   (pixelsize :initarg :pixelsize :initform 5 :accessor pixelsize)
   (count :initarg :count :accessor boid-count)
   (start-time :initform (now) :reader start-time)
   (last-update :initform () :reader last-update-time)
   (x :initform 0.0 :initarg :x :reader x)
   (y :initform 0.0 :initarg :y :reader y)
   (z :initform 0.0 :initarg :z :reader z)))

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

;;;  (class-redefine-model-slots-setf cl-boids-gpu::boid-params)

;;; (make-instance 'boid-params)
;;; (class-redefine-model-slots-setf boid-params)

#|
(defun all-direct-slots (class)
  (append (closer-mop:class-direct-slots class)
          (alexandria:mappend #'all-direct-slots
                   (closer-mop:class-direct-superclasses class))))

(defun all-slot-readers (class)
  (alexandria:mappend #'closer-mop:slot-definition-readers
                      (all-direct-slots class)))

(all-slot-readers (find-class 'boid-params))

(type-of ())

(typep (slot-value 
        (first (let ((class (find-class 'boid-params)))
                 (c2mop:ensure-finalized class)
                 (c2mop:class-direct-slots class)))
        'sb-pcl::%type)
       'bp-slot)

(c2mop:slot-definition-name
        (first (let ((class (find-class 'boid-params)))
                 (c2mop:ensure-finalized class)
                 (c2mop:class-direct-slots class))))

(class-redefine-model-slots-setf boid-params)



(model-slot-register-setf-method slot-reader class-name)

(dolist)
(model-slot-register-setf-method num-boids boid-params)




(class-define-model-slot-setf-methods boid-params)

(defparameter *tbp* (make-instance 'boid-params))

(setf (num-boids *tbp*) 14)



(defmacro model-slot-register-setf-method (slot-reader class-name)
  `(progn
     (warn "~&redefining setf for (~a ~a)" ',slot-reader ',class-name)
     (defgeneric (setf ,slot-reader) (val ,class-name)
       (:method (val (instance boid-params))
         (set-cell (,slot-reader instance) val)))))

(slot-value (make-instance 'boid-params) 'length)

(c2mop:slot-definition-type
 (first (let ((class (find-class 'boid-params)))
          (c2mop:ensure-finalized class)
          (c2mop:class-direct-slots class))))

(typep (make-instance (find-class 'bp-slot)) 'model-slot)


(typep (boids-per-click *bp*) 'bp-slot)


(typep (make-instance 'bp-slot) 'model-slot)

(slot-value
 (first (let ((class (find-class 'boid-params)))
          (c2mop:ensure-finalized class)
          (c2mop:class-slots class)))
 'c2mop::type)

(subtypep)



 model-slot-register-setf-method

(defgeneric (setf boids-per-click) (val boid-params)
  (:method (val (instance boid-params))
    (set-cell instance val)))

(defgeneric (setf boids-add-time) (val boid-params)
  (:method (val (instance boid-params))
    (set-cell instance val)))

(defgeneric (setf boids-add-x) (val boid-params)
  (:method (val (instance boid-params))
    (set-cell instance val)))

(defgeneric (setf boids-add-y) (val boid-params)
  (:method (val (instance boid-params))
    (set-cell instance val)))

(defgeneric (setf load-audio) (val boid-params)
  (:method (val (instance boid-params))
    (set-cell instance val)))

(defgeneric (setf load-boids) (val boid-params)
  (:method (val (instance boid-params))
    (set-cell instance val)))

(defgeneric (setf load-obstacles) (val boid-params)
  (:method (val (instance boid-params))
    (set-cell instance val)))

|#

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
   (start-time :initform 0 :reader start-time)
   (last-update :initform () :reader last-update-time)
   (note-states :initform nil :accessor note-states)
   (midi-cc-state :initform nil :accessor midi-cc-state)
   (midi-cc-fns :initform nil :accessor midi-cc-fns)
   (audio-args :initform nil :accessor audio-args)))

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


#|


;;; (defparameter *test* (cp-bstate (aref luftstrom-display::*bs-presets* 0) (make-instance 'boid-system-state2)))

(defparameter *bs-presets-new* (make-array 128 :initial-contents (loop repeat 128 collect (make-instance 'boid-system-state2))))

;;; (loop for i below 100 do (cp-bstate (aref luftstrom-display::*bs-presets* i) (aref *bs-presets-new* i)))

;;; (setf luftstrom-display::*bs-presets* *bs-presets-new*)

|#
