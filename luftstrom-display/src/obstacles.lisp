;;; 
;;; obstacles.lisp
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

(in-package :cl-boids-gpu)



;;; *obstacles*

;;; (elt (systems *win*) 0)

(defun local-to-global (x y)
  (list
   (round (* x luftstrom-display::*gl-width*))
   (round (* y luftstrom-display::*gl-height*))))

(defun values-local-to-global (x y)
  (values
   (round (* x luftstrom-display::*gl-width*))
   (round (* y luftstrom-display::*gl-height*))))

(defun global-to-local (x y)
  (list
   (float (/ x luftstrom-display::*gl-width*) 1.0)
   (float (/ y luftstrom-display::*gl-height*) 1.0)))

(defun values-global-to-local (x y)
  (values
   (float (/ x luftstrom-display::*gl-width*) 1.0)
   (float (/ y luftstrom-display::*gl-height*) 1.0)))

(defmacro update-coords (loc x-global y-global)
  `(multiple-value-bind (x y)
       (values-global-to-local ,x-global ,y-global)
     (setf (first ,loc) x)
     (setf (second ,loc) y)
     ,loc))

#|
;;; (update-coords (luftstrom-display::obstacle-pos (aref *obstacles* 0)) 100 100)
;;; (setf (luftstrom-display::obstacle-pos (aref *obstacles* 0)) (luftstrom-display::obstacle-pos (aref *obstacles* 0)))
;; (setf (luftstrom-display::obstacle-pos (aref *obstacles* 0)) '(0.5 0.5))
;; (setf (first (val (slot-value (aref *obstacles* 0) 'luftstrom-display::pos))) 0.1)



(set-cell (slot-value (aref *obstacles* 0) 'luftstrom-display::pos)
          (luftstrom-display::obstacle-pos (aref *obstacles* 0)))



(map nil #'(lambda (cell)
             (ref-set-cell cell '(0.5 0.5)))
     (dependents (slot-value (aref *obstacles* 0) 'luftstrom-display::pos)))
|#



(defun make-obstacle-mask ()
  (loop
     for o across *obstacles*
     for active = (luftstrom-display::obstacle-active o)
;;     for player below 4
     with res = 0
     if (and active (luftstrom-display::obstacle-exists? o))
       do (setf res (logior res (ash 1 (luftstrom-display::obstacle-ref o))))
     finally (return res)))

;;; (make-obstacle-mask)

;;; (setf (luftstrom-display::obstacle-active (aref *obstacles* 0)) t)

;;; (setf (luftstrom-display::obstacle-exists? (aref *obstacles* 0)) t)

;;; *obstacles*
;;; (make-obstacle-mask)


;;; luftstrom-display related code

(in-package :luftstrom-display)


;;; (activate-obstacle)

#|
(defstruct obstacle
  (exists? nil :type boolean)
  (type 0 :type integer)
  (radius 15 :type integer)
  (ref 0 :type integer) ;;; reference of OpenCL array
  (brightness 0.5 :type float)
  (lookahead 2.5 :type float)
  (multiplier 2.5 :type float)
  (moving nil :type boolean)
  (target-dx 0.0 :type float)
  (target-dy 0.0 :type float)
  (x 0.0 :type float)
  (y 0.0 :type float)
  (dtime 0.0 :type float)
  (active nil :type boolean))
|#

#|
(defclass obstacle ()
  ((idx :initform 0 :initarg :idx :reader idx)
   (exists? :initform (make-instance 'model-slot :val nil) :type model-slot :accessor obstacle-exists?)
   (type :initform (make-instance 'model-slot :val 0) :type model-slot :accessor obstacle-type)
   (radius :initform (make-instance 'model-slot :val 15) :type model-slot :accessor obstacle-radius)
   (ref :initform (make-instance 'model-slot :val 0) :type model-slot :accessor obstacle-ref)
   (brightness :initform (make-instance 'model-slot :val 0.5) :type model-slot :accessor obstacle-brightness)
   (lookahead :initform (make-instance 'model-slot :val 2.5) :type model-slot :accessor obstacle-lookahead)
   (multiplier :initform (make-instance 'model-slot :val 2.5) :type model-slot :accessor obstacle-multiplier)
   (moving :initform (make-instance 'model-slot :val nil) :type model-slot :accessor obstacle-moving)
   (target-dx :initform (make-instance 'model-slot :val 0.0) :type model-slot :accessor obstacle-target-dx)
   (target-dy :initform (make-instance 'model-slot :val 0.0) :type model-slot :accessor obstacle-target-dy)
   (target-pos :initform (make-instance 'model-slot :val '(0.5 0.5)) :type model-slot :accessor target-pos)
   (pos :initform (make-instance 'model-slot :val '(0.5 0.5)) :type model-slot :accessor pos)
   (x :initform (make-instance 'model-slot :val 0.5) :type model-slot :accessor obstacle-x)
   (y :initform (make-instance 'model-slot :val 0.5) :type model-slot :accessor obstacle-y)
   (dtime :initform (make-instance 'model-slot :val 0.0) :type model-slot :accessor obstacle-dtime)
   (active :initform (make-instance 'model-slot :val nil) :type model-slot :accessor obstacle-active)))

(defclass obstacle ()
  ((idx :initform 0 :initarg :idx :reader idx)
   (exists? :initform (make-instance 'model-slot :val nil) :type model-slot :accessor obstacle-exists?)
   (type :initform (make-instance 'model-slot :val 0) :type model-slot :accessor obstacle-type)
   (radius :initform (make-instance 'model-slot :val 15) :type model-slot :accessor obstacle-radius)
   (ref :initform (make-instance 'model-slot :val 0) :type model-slot :accessor obstacle-ref)
   (brightness :initform (make-instance 'model-slot :val 0.5) :type model-slot :accessor obstacle-brightness)
   (lookahead :initform (make-instance 'model-slot :val 2.5) :type model-slot :accessor obstacle-lookahead)
   (multiplier :initform (make-instance 'model-slot :val 2.5) :type model-slot :accessor obstacle-multiplier)
   (moving :initform (make-instance 'model-slot :val nil) :type model-slot :accessor obstacle-moving)
   (target-dpos :initform (make-instance 'model-slot :val '(0.5 0.5)) :type model-slot :accessor target-dpos)
   (pos :initform (make-instance 'model-slot :val '(0.5 0.5)) :type model-slot :accessor pos)
   (dtime :initform (make-instance 'model-slot :val 0.0) :type model-slot :accessor obstacle-dtime)
   (active :initform (make-instance 'model-slot :val nil) :type model-slot :accessor obstacle-active)))
|#



(defclass obstacle ()
  ((idx :initform 0 :initarg :idx :reader idx)
   (exists? :initform nil :accessor obstacle-exists?)
   (type :initform 0 :accessor obstacle-type)
   (radius :initform 15 :accessor obstacle-radius)
   (ref :initform 0 :accessor obstacle-ref)
   (brightness :initform 0.5 :accessor obstacle-brightness)
   (lookahead :initform 2.5 :accessor obstacle-lookahead)
   (multiplier :initform 2.5 :accessor obstacle-multiplier)
   (moving :initform nil :accessor obstacle-moving)
   (target-dpos :initform '(0.0 0.0) :accessor target-pos)
   (pos :initform '(0.5 0.5) :accessor pos)
   (dtime :initform 0.0 :accessor obstacle-dtime)
   (active :initform nil :accessor obstacle-active)))

(defclass obstacle2 ()
  ((idx :initform 0 :initarg :idx :reader idx)
   (exists? :initform (make-instance 'model-slot :val nil) :type model-slot :accessor obstacle-exists?)
   (type :initform (make-instance 'model-slot :val 0) :type model-slot :accessor obstacle-type)
   (radius :initform (make-instance 'model-slot :val 25) :type model-slot :accessor obstacle-radius)
   (ref :initform (make-instance 'model-slot :val 0) :type model-slot :accessor obstacle-ref)
   (brightness :initform (make-instance 'model-slot :val 0.5) :type model-slot :accessor obstacle-brightness)
   (lookahead :initform (make-instance 'model-slot :val 2.5) :type model-slot :accessor obstacle-lookahead)
   (multiplier :initform (make-instance 'model-slot :val 2.5) :type model-slot :accessor obstacle-multiplier)
   (moving :initform (make-instance 'model-slot :val nil) :type model-slot :accessor obstacle-moving)
   (target-dpos :initform (make-instance 'model-slot :val '(0.5 0.5)) :type model-slot :accessor target-pos)
   (pos :initform (make-instance 'model-slot :val '(0.5 0.5)) :type model-slot :accessor pos)
   (dtime :initform (make-instance 'model-slot :val 0.0) :type model-slot :accessor obstacle-dtime)
   (active :initform (make-instance 'model-slot :val nil) :type model-slot :accessor obstacle-active)))

#|
(defmethod initialize-instance :after ((instance obstacle2) &rest args)  (declare (ignore args))
  (with-slots (idx pos brightness radius type ref) instance
    (setf (set-cell-hook (slot-value instance 'pos))
          (lambda (new-pos)
            (destructuring-bind (x y) pos
              (cl-boids-gpu::gl-enqueue
               (lambda () 
                 (cl-boids-gpu::set-obstacle-position
                  cl-boids-gpu::*win* idx
                  x y)))
              (setf (val (slot-value cl-boids-gpu::*bp* 'cl-boids-gpu::boids-add-x)) x)
              (setf (val (slot-value cl-boids-gpu::*bp* 'cl-boids-gpu::boids-add-y)) (- 1 y))
              )))
    (setf (set-cell-hook (slot-value instance 'type))
          (lambda (type)
            (declare (ignore type))
            (reset-obstacles)))))
|#



(defmethod initialize-instance :after ((instance obstacle2) &rest args)
  (declare (ignore args))
  (with-slots (pos brightness radius type ref) instance
      (setf (set-cell-hook (slot-value instance 'pos))
            (lambda (new-pos)
              (destructuring-bind (old-x old-y) (val pos)
                (destructuring-bind (new-x new-y) new-pos
                  (set-obstacle-dx (val ref) (round (* cl-boids-gpu::*gl-width* (- new-x old-x))) 1 t)
                  (set-obstacle-dy (val ref) (round (* cl-boids-gpu::*gl-height* (- new-y  old-y))) 1 t)
                  ;; (format t "~&cell-hook: old: ~a, new: ~a, ~a, ~a~%"
                  ;;         (list old-x old-y (* old-x cl-boids-gpu::*real-width*)
                  ;;               (* old-y cl-boids-gpu::*real-height*))
                  ;;         (append new-pos
                  ;;                 (list (* (first new-pos) cl-boids-gpu::*real-width*)
                  ;;                       (* (second new-pos) cl-boids-gpu::*real-height*)))
                  ;;         (round (* cl-boids-gpu::*real-width* (- new-x old-x)))
                  ;;         (round (* cl-boids-gpu::*real-height* (- new-y  old-y))))
;;;                (setf (obstacle-pos instance) new-pos)
                  (setf (slot-value (slot-value instance 'pos) 'val) new-pos)
                  (setf (val (slot-value cl-boids-gpu::*bp* 'cl-boids-gpu::boids-add-x)) new-x)
                  (setf (val (slot-value cl-boids-gpu::*bp* 'cl-boids-gpu::boids-add-y)) (- 1 new-y))
                  ))))
    (setf (set-cell-hook (slot-value instance 'type))
          (lambda (type)
            (setf (slot-value (slot-value instance 'type) 'val) type) ;;; set type without triggering dependents before resetting obstacles
            (reset-obstacles)))))

;;; (obstacle-pos (obstacle 0))

#|
(setf (obstacle-brightness (aref *obstacles* 0)) 0.8)
(setf (obstacle-radius (aref *obstacles* 0)) 40)
(setf (obstacle-pos (aref *obstacles* 0)) '(0.1 0.2))
(setf (obstacle-pos (aref *obstacles* 0)) '(0.8 0.2))
(setf (obstacle-active (aref *obstacles* 0)) t)
(obstacle-x (aref *obstacles* 0))
(obstacle-y (aref *obstacles* 0))

    (setf (set-cell-hook type)
          (lambda (type)
            (cl-boids-gpu::gl-set-obstacle-type idx (map-type type))))
    (setf (set-cell-hook brightness)
          (lambda (brightness)
            (let* ((player (val idx)))
              (cl-boids-gpu::set-obstacle-lookahead (val ref) (float brightness))
              (set-lookahead player (float (n-exp brightness 2.5 10.0)))
              (set-multiplier player (float (n-exp brightness 1 1.0)))
              (setf brightness (n-lin brightness 0.2 1.0)))))
    (setf (set-cell-hook radius)
          (lambda (radius)
            ))



(let ((test (make-instance 'obstacle)))
  (with-slots (ref radius) test
    (list radius ref))
  )




  (make-osc-responder *osc-obst-ctl* "/obsttype2" "f"
                      (lambda (type)
                        (cl-boids-gpu::gl-set-obstacle-type idx (map-type type))))
  (make-osc-responder *osc-obst-ctl* "/obstactive2" "f"
                      (lambda (obstactive)
                        (case obstactive
                          (0.0 (deactivate-obstacle 1))
                          (otherwise (activate-obstacle 1)))))
    (make-osc-responder *osc-obst-ctl* "/obstvolume2" "f"
                      (lambda (amp)
                        (let* ((player 1)
                               (obstacle (aref *obstacles* player)))
                          (with-slots (brightness radius)
                              obstacle
                            (set-lookahead player (float (n-exp amp 2.5 10.0)))
                            (set-multiplier player (float (n-exp amp 1 1.0)))
                            (setf brightness (n-lin amp 0.2 1.0))))))
  (make-osc-responder *osc-obst-ctl* "/xy1" "ff"
                      (lambda (x y)
                        (let ((x x) (y y))
                          (cl-boids-gpu::gl-enqueue
                           (lambda () 
                             (cl-boids-gpu::set-obstacle-position
                              cl-boids-gpu::*win* 0
                              (* cl-boids-gpu::*real-width* x) (* *height* (- 1 y))))))))

(let ((test (make-instance 'obstacle)))
  (with-slots (pos) test
    (setf (set-cell-hook pos) (lambda (v) (+ v 3))))
  test)
|#

(defgeneric obstacle-exists?
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'exists?))))
(defgeneric (setf obstacle-exists?)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'exists?) value)))
(defgeneric obstacle-type
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'type))))
(defgeneric (setf obstacle-type)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'type) value)))
(defgeneric obstacle-radius
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'radius))))
(defgeneric (setf obstacle-radius)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'radius) value)))
(defgeneric obstacle-ref
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'ref))))
(defgeneric (setf obstacle-ref)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'ref) value)))
(defgeneric obstacle-brightness
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'brightness))))
(defgeneric (setf obstacle-brightness)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'brightness) value)))
(defgeneric obstacle-lookahead
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'lookahead))))
(defgeneric (setf obstacle-lookahead)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'lookahead) value)))
(defgeneric obstacle-multiplier
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'multiplier))))
(defgeneric (setf obstacle-multiplier)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'multiplier) value)))
(defgeneric obstacle-moving
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'moving))))
(defgeneric (setf obstacle-moving)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'moving) value)))
(defgeneric obstacle-pos
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'pos))))
(defgeneric (setf obstacle-pos)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'pos) value)))
(defgeneric obstacle-target-dpos
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'target-dpos))))
(defgeneric (setf obstacle-target-dpos)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'target-dpos) value)))

(defun inc-type (player)
  (let* ((ref (1- player))
         (type (map-type (obstacle-type (aref *obstacles* ref)))))
    (if (< type 4)
        (setf (obstacle-type (aref *obstacles* ref)) (map-type (1+ type))))))

(defun dec-type (player)
  (let* ((ref (1- player))
         (type (map-type (obstacle-type (aref *obstacles* ref)))))
    (if (> type 0)
        (setf (obstacle-type (aref *obstacles* ref)) (map-type (1- type))))))

;;; (obstacle-type (aref *obstacles* 1))

;;; (inc-type 1)

;;; (dec-type 1)

#|
(defgeneric obstacle-target-dx
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'target-dx))))
(defgeneric (setf obstacle-target-dx)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'target-dx) value)))
(defgeneric obstacle-target-dy
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'target-dy))))
(defgeneric (setf obstacle-target-dy)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'target-dy) value)))
(defgeneric obstacle-x
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'x))))
(defgeneric (setf obstacle-x)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'x) value)))
|#
(defgeneric obstacle-target-pos
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'target-pos))))
(defgeneric (setf obstacle-target-pos)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'target-pos) value)))
(defgeneric obstacle-pos
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'pos))))
(defgeneric (setf obstacle-pos)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'pos) value)))
(defgeneric obstacle-y
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'y))))
(defgeneric (setf obstacle-y)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'y) value)))
(defgeneric obstacle-dtime
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'dtime))))
(defgeneric (setf obstacle-dtime)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'dtime) value)))
(defgeneric obstacle-active
    (instance)
  (:method ((instance obstacle2)) (val (slot-value instance 'active))))
(defgeneric (setf obstacle-active)
    (value obstacle)
  (:method (value (instance obstacle2))
    (set-cell (slot-value instance 'active) value)))

#|
(defmacro model-slot-define-accessors (slot-name class-name)
  (let ((slot-reader (intern (string-upcase (format nil "obstacle-~a" 'exists?)))))
    `(progn
       (defgeneric ,slot-reader (instance)
         (:method ((instance ,class-name))
           (val (slot-value instance ',slot-name))))
       (defgeneric (setf ,slot-reader) (value ,class-name)
         (:method (value (instance ,class-name))
           (set-cell (slot-value instance ',slot-name) value))))))

(defun class-get-model-slot-names (class-name)
  (let ((tmp (make-instance class-name))
         (class (find-class class-name)))
     (c2mop:ensure-finalized class)
     (loop for slot-def in (c2mop:class-direct-slots class)
           for slot-name = (c2mop:slot-definition-name slot-def)
           if (typep (slot-value tmp slot-name) 'model-slot)
             collect (c2mop:slot-definition-name slot-def))))

(defun model-slot-define-accessors (slot-name class-name)
  (let ((slot-reader (intern (string-upcase (format nil "obstacle-~a" slot-name)))))
    `((defgeneric ,slot-reader (instance)
        (:method ((instance ,class-name))
          (val (slot-value instance ',slot-name))))
      (defgeneric (setf ,slot-reader) (value ,class-name)
        (:method (value (instance ,class-name))
          (set-cell (slot-value instance ',slot-name) value))))))

;;; (model-slot-define-accessors 'exists? 'obstacles-new)

(defun class-get-model-slot-accessor-defs (class-name)
  (loop for name in (class-get-model-slot-names class-name)
        append (model-slot-define-accessors name class-name)))

;;; (class-get-model-slot-reader-defs 'obstacle-new)

(class-get-model-slot-accessor-defs 'obstacle-new)




(defmacro class-redefine-model-slot-accessors (class-name)
  `(progn
     ,@(class-get-model-slot-accessor-defs class-name)))

;;; (class-redefine-model-slot-accessors obstacle-new)


(defparameter *obtest* (make-instance 'obstacle-new))

(obstacle-active? *obtest*)

(setf (obstacle-exists? *obtest*) t)

(with-slots (exists?) *obtest*
  (setf exists (make-instance 'model-slot :val t))
  )
|#
;;; obstacles ist immer sortiert nach playern, d.h. (aref *obstacles*
;;; 0) ist immer das Obstacle von Player 1!

(defun obst-brightness-hook (player)
  (lambda (brightness)
    (let ((amp (funcall (n-lin-rev-fn 0.2 1.0) brightness)))
      (set-lookahead player (float (n-exp amp 2.5 10.0)))
      (set-multiplier player (float (n-exp amp 1 1.0))))))

(defparameter *obstacles*
  (make-array '(16) :element-type 'obstacle2 :initial-contents
              (loop for idx below 16 collect (make-instance 'obstacle2 :idx idx))))

(defun init-player-obstacles ()
  (dotimes (i 4)
    (setf (set-cell-hook (slot-value (aref *obstacles* i) 'brightness))
          (obst-brightness-hook i))
    (setf (obstacle-active (aref *obstacles* i)) nil)
    (setf (val (slot-value (aref *obstacles* i) 'exists?)) t)
    (setf (slot-value (pos (aref *obstacles* i)) 'val) '(0.5 0.5))))

;;; (init-player-obstacles)

(defparameter *player-audio-idx* (make-array '(17) :initial-contents '(0 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil)))

(defparameter *mouse-ref* 0) ;;; reference of mouse-pointer into *obstacles*

(defun keynum->coords (keynum)
  (let ((kn (- (max 24 (min 107 keynum)) 24)))
    (multiple-value-bind (y x) (floor kn 12)
      (values (round (* (/ (+ 0.5 x) 12) *gl-width*))
              (round (* (- 1 (/ (+ 0.5 y) 7)) *gl-height*))))))

(defun tidx->player (tidx)
  (elt *player-audio-idx* tidx))

;;; (setf (player-idx 2) 1)

;;; (keynum->coords 107)

;;; (coords->keynum 1467 0)

;;; (floor 61 12)
#|

tiefster Ton: 22
h??chster Ton: 110

mapping: 24 107

(/ (- 108 24) 12)

(- (floor 107 12) 2)
|#

(defun coords->keynum (x y)
  (+ 24
     (round (* (/ x *gl-width*) 12))
     (* 12 (round (* (- 1 (/ y *gl-height*)) 7)))))

(defun predator-sort (seq)
  (sort seq #'> :key #'first))

(defun obstacle (player)
  (elt *obstacles* player))

(defun maxobstacles ()
  (length *obstacles*))

(defun clear-obstacle-ref (player)
  (setf (obstacle-ref (obstacle player)) 0))

(defun clear-player-audio-idx (idx)
  (setf (elt *player-audio-idx* idx) nil))

(defun set-player-audio-idx (idx val)
  (setf (elt *player-audio-idx* idx) val))

(defun obstacle-idx (obstacle)
  (loop
     for o across *obstacles*
     for idx from 0
     if (eq o obstacle) return idx))

(defun reset-obstacle-ref (obstacles)
  "Update the obstacle ref after predator sorting 
and set all player's audio-ref to
the obstacle idx in the gl buffer."
  (dotimes (idx (maxobstacles))
    (clear-obstacle-ref idx)
    (clear-player-audio-idx (1+ idx)))
  (loop
     for o in obstacles ;;; caution: 'obstacles are in (predator)
                        ;;; sorted order on the gl-buffer, but we
                        ;;; reference the elems of *obstacles*, which
                        ;;; are in player-order!
     for idx from 0
     do (progn
          (setf (obstacle-ref (aref *obstacles* (obstacle-idx o))) idx)
          (set-player-audio-idx (1+ idx) (1+ (obstacle-idx o))))))

(defun clear-obstacle (o)
  (setf (obstacle-exists? o) nil)
  (setf (obstacle-active o) nil))

(defun clear-all-obstacles ()
  (dotimes (idx (length *obstacles*))
    (clear-obstacle (obstacle idx))))

;;;(clear-all-obstacles)

(defun reset-obstacles ()
  "reset the *obstacles* in the gl window after sorting in predator
oder."
  (let ((win cl-boids-gpu::*win*))
    (if win
        (let ((new-obstacles
                (predator-sort
                 (loop
                   for o across *obstacles*
                   if (obstacle-exists? o)
                     collect (list (obstacle-type o) (obstacle-idx o))))))
          (clear-obstacles win)
          (let ((new-order (loop
                             for (type idx) in new-obstacles
                             collect (aref *obstacles* idx))))
            (gl-enqueue (lambda () (gl-set-obstacles win new-order)))
            (reset-obstacle-ref new-order)
            )
;;;         (reset-obstacle-types)
          ))))


;;;           (reset-obstacle-types)

(defun reset-obstacle-types ()
  (dotimes (i 4)
    (let* ((instance (slot-value (elt *obstacles* i) 'type))
           (value (slot-value instance 'val)))
;;      (funcall (set-cell-hook instance) value)
          (map nil #'(lambda (cell) (ref-set-cell cell value))
               (dependents instance)))))

(defun reset-obstacles-from-preset (val state)
  "reset *obstacles* according to preset values (a list of (type
radius) pairs while preserving the state of previous obstacles by
reinserting their state infos and pushing them onto window after
sorting in predator order. If state is nil use default values."
  (declare (ignorable state))
;;;  (break "reset-obstacles-from-preset val: ~a, state: ~a" val state)
  (clear-all-obstacles)
  (loop for (type radius) in val
     for idx from 0
        for old-state = (and (getf state :obstacles-state) (elt (getf state :obstacles-state) idx))
     for o = (obstacle idx)
     do (if type
            (progn
;;;              (break "o: ~a, state: ~a" o state)
              (destructuring-bind (old-pos old-brightness old-radius old-active old-lookahead old-multiplier)
                  (or old-state '(nil nil nil nil nil nil))
                (declare (ignore old-radius))
                (setf (obstacle-type o) type)
                (setf (obstacle-lookahead o) (or old-lookahead 2.5))
                (setf (obstacle-multiplier o) (or old-multiplier 2.5))
                (setf (obstacle-radius o) radius)
                (setf (obstacle-exists? o) t)
                (setf (obstacle-pos o) (or old-pos '(0.5 0.5)))
                (setf (obstacle-brightness o) (or old-brightness 0.2))
                (setf (obstacle-active o) (if old-state old-active nil))))
            (clear-obstacle o)))
  (reset-obstacles)
  )

;;; (reset-obstacles-from-preset '((4 25) (4 25)) (get-system-state))
#|
(defun reset-obstacles-from-bs-preset (saved-obstacles obstacle-protect)
  "reset *obstacles* according to bs-preset value (*obstacles* at the
time of bs-preset capture). obstacle-protect can have the following values:

   nil - all saved-obstacles are restored.

   t   - the current state of obstacles is not altered.

   a list of player keywords or their idx - the obstacles of all
                                            listed players are not restored.
"
  (if (listp obstacle-protect) ;;; this is also t if obstacle-protect is nil!
      (let ((protected-chans (mapcar #'player-aref obstacle-protect)))
        (dotimes (i 1)
          (unless (member (slot-value (aref saved-obstacles i) 'ref) protected-chans)
            (let ((src (aref saved-obstacles i))
                  (dest (aref *obstacles* i)))
;;;              (break "set cells of obstacle ~d~%" i)
;;;              (format t "set cells of obstacle ~d~%" i)
              (dolist (slot '(pos))
                (case slot
                   ;;; don't trigger (reset-obstacles) yet!
                  (otherwise (set-cell (slot-value dest slot) (slot-value src slot) :src src)))))))
        (reset-obstacles))))
|#

(defun reset-obstacles-from-bs-preset (saved-obstacles obstacle-protect)
  "reset *obstacles* according to bs-preset value (*obstacles* at the
time of bs-preset capture). obstacle-protect can have the following values:

   nil - all saved-obstacles are restored.

   t   - the current state of obstacles is not altered.

   a list of player keywords or their idx - the obstacles of all
                                            listed players are not restored.
"
  (if (listp obstacle-protect) ;;; this is also t if obstacle-protect is nil!
      (let ((protected-chans (mapcar #'player-aref obstacle-protect)))
        (dotimes (i (length saved-obstacles))
          (unless (member (slot-value (aref saved-obstacles i) 'ref) protected-chans)
            (let ((src (aref saved-obstacles i))
                  (dest (aref *obstacles* i)))
;;;              (break "set cells of obstacle ~d~%" i)
;;;              (format t "set cells of obstacle ~d~%" i)
              (dolist (slot '(active brightness dtime exists?
                              lookahead moving multiplier radius
                              ref target-dpos type pos))
                (case slot
                  (type (setf (slot-value (slot-value dest slot) 'val) (slot-value src slot))) ;;; don't trigger (reset-obstacles) yet!
                  (pos (let ((new-value (slot-value src slot)))
                         (setf (slot-value (slot-value dest slot) 'val) new-value)
                         (map nil #'(lambda (cell)
                                      (unless (eql cell src) (ref-set-cell cell new-value)))
                              (dependents (slot-value dest slot)))))
                  (otherwise (set-cell (slot-value dest slot) (slot-value src slot) :src src)))))))
;;        (break "before reset-obstacles")
        (reset-obstacles))))



;;; (slot-value (aref (slot-value (aref *bs-presets* 0) 'cl-boids-gpu::bs-obstacles) 0) 'ref)
;;; (reset-obstacles-from-bs-preset (slot-value (aref *bs-presets* 0) 'cl-boids-gpu::bs-obstacles) nil)

#|


(setf (val (slot-value (aref *obstacles* 0) 'lookahead)) 2.5)

(reset-obstacles-from-bs-preset (slot-value (aref *bs-presets* 0) 'cl-boids-gpu::bs-obstacles) nil)

(slot-value (aref (slot-value (aref *bs-presets* 0) 'cl-boids-gpu::bs-obstacles) 0) 'active)

(setf (val (slot-value (aref *obstacles* 0) 'active)) t)


(let ((old (aref (slot-value (aref *bs-presets* 0) 'cl-boids-gpu::bs-obstacles) 0)))

)

(length *bs-presets*)

(loop for preset across *bs-presets*
      do (if (and preset (slot-value preset 'cl-boids-gpu::bs-obstacles))
             (setf (slot-value preset 'cl-boids-gpu::bs-obstacles)
                   (obstacles->new-defs
                    (slot-value  preset 'cl-boids-gpu::bs-obstacles)))))


(loop for preset across *bs-presets*
      do (if (and preset (slot-value preset 'cl-boids-gpu::bs-obstacles))
             (setf (slot-value preset 'cl-boids-gpu::bs-obstacles)
                   (obstacles->new-defs
                    (slot-value  preset 'cl-boids-gpu::bs-obstacles)))))


|#

(defun obstacles->new-defs (old)
  (coerce
   (loop
     for src across old
     collect (obstacle->new-obstacle src))
   'vector))

(defun obstacle->new-obstacle (src)
  (let ((dest (make-instance 'obstacle)))
    (dolist (slot '(active brightness dtime exists?
                    lookahead moving multiplier radius
                    ref target-dx target-dy type x y))
      (setf (val (slot-value dest slot)) (slot-value src slot)))
    dest))

;;; (obstacles->new-defs (slot-value (aref *bs-presets* 0) 'cl-boids-gpu::bs-obstacles))

;;; (slot-value (aref *bs-presets* 1) 'cl-boids-gpu::bs-obstacles)

(defun activate-obstacle (player)
  (setf (obstacle-active (obstacle player)) t))

(defun deactivate-obstacle (player)
  (setf (obstacle-active (obstacle player)) nil)
  ;; (obst-active player 0)
  )

(defun toggle-obstacle (player)
  (if (and player (obstacle-exists? (obstacle player)))
      (if (obstacle-active (obstacle player))
          (progn
            (deactivate-obstacle player)
;;;            (obst-active player 0)
            )
          (progn
            (activate-obstacle player)
;;;            (obst-active player 1)
            ))))

(defun inc-obst-x (obstacle val &key clip)
  (destructuring-bind (x y) (val (pos obstacle))
    (setf (val (pos obstacle)) (list (if clip
                                         (float (clip (+ x (/ val *gl-width*)) 0.0 1.0) 1.0)
                                         (mod (+ x (/ val *gl-width*)) 1.0))
                                     y))))

(defun inc-obst-y (obstacle val &key clip)
  (destructuring-bind (x y) (val (pos obstacle))
    (setf (val (pos obstacle)) (list x
                                     (if clip
                                         (float (clip (+ y (/ val *gl-height*)) 0.0 1.0) 1.0)
                                         (mod (+ y (/ val *gl-height*)) 1.0))))))


;;; (toggle-obstacle 0)
;;; (setf (obstacle-exists? (obstacle 0)) t)

(defun set-lookahead (player value)
  (let ((o (obstacle player)))
    (setf (obstacle-lookahead o) (float value))
    (cl-boids-gpu::set-obstacle-lookahead (obstacle-ref o) (float value))))


;;; (setf (obstacle-lookahead (aref *obstacles* 0)) 5)
;;; (set-lookahead 0 2.5)

(defun set-multiplier (player value)
  (let ((o (obstacle player)))
    (setf (obstacle-multiplier o) (float value))
    (cl-boids-gpu::set-obstacle-multiplier (obstacle-ref o) (float value))))

(defun player-cc (tidx cc)
  (if (= tidx -1)
       (aref *cc-state* (player-aref :nk2) cc)
       (aref *cc-state* (player-aref (tidx->player tidx)) cc)))

(defun player-note (tidx)
  (if (= tidx -1)
      60
      (aref *note-states* (player-aref (tidx->player tidx)))))

(defun obstacle-x (obstacle)
  (first (obstacle-pos obstacle)))

(defun obstacle-y (obstacle)
  (second (obstacle-pos obstacle)))

(defun o-x (tidx)
  (if (= tidx -1)
      0.5
      (/ (obstacle-x (aref *obstacles* (tidx->player tidx))) cl-boids-gpu::*width*)))

(defun o-y (tidx)
  (if (= tidx -1)
      0.5
      (/ (obstacle-y (aref *obstacles* (tidx->player tidx))) cl-boids-gpu::*height*)))

;;; (player-cc 1 7)

(defun obst-xy (player x y)
  (setf luftstrom-display::*last-xy* (list x y))
  (setf (obstacle-pos (aref *obstacles* player)) (list x y)))


(defun obst-amp-ctl (player)
  (let ((obstacle (aref *obstacles* player)))
    (lambda (amp)
      (with-slots (brightness radius)
          obstacle
        (set-lookahead player (float (n-exp amp 2.5 10.0)))
        (set-multiplier player (float (n-exp amp 1 1.0)))
        (setf brightness (n-lin amp 0.2 1.0))))))

#|(elt *obstacles* 0)

(setf (obstacle-exists? (elt *obstacles* 0)) t)
(setf (obstacle-active (elt *obstacles* 0)) t)
(setf (obstacle-ref (elt *obstacles* 0)) 0)
|#
;;; (set-multiplier 0 10)


;;; (obstacle 0)
;; (load-preset 0)



;;; (setf (obstacle-brightness (obstacle 0)) 0.2)

;;; (tidx->player 0)

;;; (in-package :luftstrom-display)


;;; (get-obstacles)

