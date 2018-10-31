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

(defun get-obstacles-state (win)
  (if win
      (let ((*command-queues* (command-queues win))
            (bs (first (systems win))))
        (if bs
            (with-slots (num-obstacles
                         maxobstacles
                         obstacles-pos
                         obstacles-radius
                         obstacles-type
                         obstacles-boardoffs-maxidx)
                bs
              (loop
                 for o across *obstacles*
                 collect (if (luftstrom-display::obstacle-exists? o)
                             (let* ((i (luftstrom-display::obstacle-ref o)))
                               (ocl:with-mapped-buffer (p1 (car *command-queues*) obstacles-pos (* 4 maxobstacles) :read t)
                                 (with-slots (luftstrom-display::x
                                              luftstrom-display::y
                                              luftstrom-display::brightness
                                              luftstrom-display::radius
                                              luftstrom-display::active)
                                     o
                                   (setf luftstrom-display::x (cffi:mem-aref p1 :float (+ (* i 4) 0)))
                                   (setf luftstrom-display::y (cffi:mem-aref p1 :float (+ (* i 4) 1)))
                                   (list
                                    luftstrom-display::x
                                    luftstrom-display::y
                                    luftstrom-display::brightness
                                    luftstrom-display::radius
                                    luftstrom-display::active)))))))))))


(defun update-get-obstacles (win)
  (let ((*command-queues* (command-queues win))
        (bs (first (systems win)))
        (width (glut:width win))
        (height (glut:height win))
        (result '()))
    (if bs
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-boardoffs-maxidx)
            bs
          (loop
             for o across *obstacles*
             if (luftstrom-display::obstacle-active o)
             do (let* ((i (luftstrom-display::obstacle-ref o))
                       (radius (luftstrom-display::obstacle-radius o))
                       (brightness (luftstrom-display::obstacle-brightness o)))
                  (ocl:with-mapped-buffer (p1 (car *command-queues*) obstacles-pos (* 4 maxobstacles) :write t)
                    (ocl:with-mapped-buffer (p2 (car *command-queues*) obstacles-radius maxobstacles :write t)
                      (ocl:with-mapped-buffer (p4 (car *command-queues*) obstacles-type maxobstacles :read t)
                        (with-slots (dx dy x-steps y-steps x-clip y-clip) (aref (obstacle-target-posns bs) i)
                          (push
                           (list
                            (cffi:mem-aref p4 :int i)               ;;; type
                            (recalc-pos (cffi:mem-aref p1 :float (+ (* i 4) 0)) dx x-steps x-clip width) ;;; x
                            (recalc-pos (cffi:mem-aref p1 :float (+ (* i 4) 1)) dy y-steps y-clip height) ;;; y
                            (setf (cffi:mem-aref p2 :int i) (round radius))
                            brightness)
                           result)))))))))
    (values (reverse result))))

(defun gl-set-obstacles (win obstacles &key bs)
  "predators are added to the head of all obstacles."
  (let ((*command-queues* (command-queues win))
        (bs (or bs (first (systems win))))
        (len (length obstacles)))
    (if bs
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-boardoffs-maxidx)
            bs
          (setf num-obstacles (min len maxobstacles))
          (ocl:with-mapped-buffer (p1 (car *command-queues*) obstacles-pos (* 4 maxobstacles) :write t)
            (ocl:with-mapped-buffer (p2 (car *command-queues*) obstacles-radius maxobstacles :write t)
              (ocl:with-mapped-buffer (p3 (car *command-queues*) obstacles-boardoffs-maxidx maxobstacles :write t)
                (ocl:with-mapped-buffer (p4 (car *command-queues*) obstacles-type maxobstacles :write t)
                  (loop for obst in obstacles
                     for i below num-obstacles
                     do (with-slots (luftstrom-display::x luftstrom-display::y luftstrom-display::radius luftstrom-display::type) obst
                          (set-array-vals p1 (* i 4) (float luftstrom-display::x 1.0) (float luftstrom-display::y 1.0) 0.0 0.0)
                          (setf (cffi:mem-aref p2 :int i) (round luftstrom-display::radius))
                          (setf (cffi:mem-aref p3 :int i) (get-board-offs-maxidx (* luftstrom-display::radius *obstacles-lookahead*)))
                          (setf (cffi:mem-aref p4 :int i) luftstrom-display::type)))))))
          num-obstacles))))

(defun move-obstacle-rel (player direction window &key (delta 1) (clip nil))
  (let ((bs (first (systems window))))
    (if bs
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-boardoffs-maxidx)
            bs
          (progn
            (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                        :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
              (let ((x (cffi:mem-aref p1 :float 0))
                    (y (cffi:mem-aref p1 :float 1)))
                (case direction
                  (:left (setf x (if clip
                                     (max 0 (- x delta))
                                     (mod (- x delta) (glut:width window)))))
                  (:right (setf x
                                (if clip
                                    (min (+ x delta) (glut:width window))
                                    (mod (+ x delta) (glut:width window)))))
                  (:up (setf y
                             (if clip
                                 (min (+ y delta) (glut:height window))
                                 (mod (+ y delta) (glut:height window)))))
                  (:down (setf y
                             (if clip
                                 (max 0 (- y delta))
                                 (mod (- y delta) (glut:height window))))))
                (setf (cffi:mem-aref p1 :float 0) (float x 1.0))
                (setf (cffi:mem-aref p1 :float 1) (float y 1.0)))))))))

(defun move-obstacle-rel-xy (player dx dy window &key (clip nil))
  (let ((bs (first (systems window))))
    (if bs
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-boardoffs-maxidx)
            bs
          (progn
            (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                        :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
              (let ((x (cffi:mem-aref p1 :float 0))
                    (y (cffi:mem-aref p1 :float 1)))
                (setf x (if clip
                            (min (max 0 (+ x dx)) (glut:width window))
                            (mod (+ x dx) (glut:width window))))
                (setf y (if clip
                            (min (max 0 (+ y dy)) (glut:height window))
                            (mod (+ y dy) (glut:height window))))
                (setf (cffi:mem-aref p1 :float 0) (float x 1.0))
                (setf (cffi:mem-aref p1 :float 1) (float y 1.0)))))))))

(defun get-obstacle-pos (player window)
  (let ((bs (first (systems window))))
    (ocl:with-mapped-buffer
        (p1 (car (cl-boids-gpu::command-queues window))
            (cl-boids-gpu::obstacles-pos bs) 4
            :offset (* cl-boids-gpu::+float4-octets+
                       (get-obstacle-ref player)) :write t)
      (values (cffi:mem-aref p1 :float 0)
              (cffi:mem-aref p1 :float 1)))))

(defmethod glut:keyboard ((window opencl-boids-window) key x y)
  (declare (ignore x y))
  (when (eql key #\Esc)
    (glut:destroy-current-window))
  (when (eql key #\r)
    (continuable
      (reload-programs window)))
  (when (eql key #\1)
    (set-mouse-ref 0))
  (when (eql key #\2)
    (set-mouse-ref 1))
  (when (eql key #\3)
    (set-mouse-ref 2))
  (when (eql key #\4)
    (set-mouse-ref 3))
  (when (eql key #\0)
    (clear-mouse-ref))
  (when (eql key #\f)
    (setf *show-fps* (not *show-fps*)))
  (when (eql key #\k)
    (continuable
      (set-kernel window)))
  (when (eql key #\space)
    (continuable
      (toggle-update)))
  (when (eql key #\c)
    (continuable
      (clear-systems window)
;;      (luftstrom-display::set-obstacles (coerce *obstacles* 'list))
      )))

(defun make-obstacle-mask ()
  (loop
     for o across *obstacles*
     for active = (luftstrom-display::obstacle-active o)
;;     for player below 4
     with res = 0
     if (and active (luftstrom-display::obstacle-exists? o))
     do (incf res (expt 2 (luftstrom-display::obstacle-ref o)))
     finally (return res)))

;;; (make-obstacle-mask)

;;; (setf (luftstrom-display::obstacle-active (aref *obstacles* 0)) t)

;;; (setf (luftstrom-display::obstacle-exists? (aref *obstacles* 0)) t)



(in-package :luftstrom-display)

(defstruct obstacle
  (exists? nil :type boolean)
  (type 0 :type integer)
  (radius 15 :type integer)
  (ref 0 :type integer) ;;; reference of OpenCL array
  (brightness 0.5 :type float)
  (moving nil :type boolean)
  (target-dx 0.0 :type float)
  (target-dy 0.0 :type float)
  (x 0.0 :type float)
  (y 0.0 :type float)
  (dtime 0.0 :type float)
  (active nil :type boolean))

(defparameter *obstacles* (make-array '(16) :element-type 'obstacle :initial-contents
                                      (loop for idx below 16 collect (make-obstacle))))

(defparameter *mouse-ref* nil) ;;; reference of mouse-pointer into *obstacles*1234

(defun keynum->coords (keynum)
  (let ((kn (- (max 24 (min 107 keynum)) 24)))
    (multiple-value-bind (y x) (floor kn 12)
      (values (round (* (/ (+ 0.5 x) 12) *width*))
              (round (* (- 1 (/ (+ 0.5 y) 7)) *height*))))))

;;; (keynum->coords 107)

;;; (coords->keynum 1467 0)

;;; (floor 61 12)
#|

tiefster Ton: 22
höchster Ton: 110

mapping: 24 107

(/ (- 108 24) 12)

(- (floor 107 12) 2)
|#

(defun coords->keynum (x y)
  (+ 24
     (round (* (/ x *width*) 12))
     (* 12 (round (* (- 1 (/ y *height*)) 7)))))

(defun predator-sort (seq)
  (sort seq #'> :key #'(lambda (elem) (obstacle-type elem))))

(defun obstacle (player)
  (aref *obstacles* player))

(defun maxobstacles ()
  (length *obstacles*))

(defun clear-obstacle-ref (player)
  (setf (obstacle-ref (obstacle player)) -1))

(defun set-obstacle-ref (obstacles)
  (dotimes (player (maxobstacles))
    (clear-obstacle-ref player))
  (loop
     for o in obstacles
     for idx from 0
     do (setf (obstacle-ref o) idx)))

(defun clear-obstacle (o)
  (setf (obstacle-exists? o) nil)
  (setf (obstacle-active o) nil))

(defun clear-all-obstacles ()
  (dotimes (idx (length *obstacles*))
    (clear-obstacle (obstacle idx))))

(defun match-align (new old)
  (loop
     for x in new
     for idx in old)
  new)

(defun set-obstacles (val state)
  "set *obstacles* according to val, reinserting state infos of
previous obstacles and pushing them onto window after sorting."
  (declare (ignorable state))
  (clear-all-obstacles)
  (loop for (type radius) in val
     for idx from 0
     for old-state = (nth idx (getf state :obstacles-state))
     for o = (obstacle idx)
     do (if type
            (progn
;;              (break "o: ~a" o)
              (destructuring-bind (old-x old-y old-brightness old-radius old-active) (or old-state '(nil nil nil nil nil))
                (declare (ignore old-radius))
                (setf (obstacle-type o) type)
                (setf (obstacle-radius o) radius)
                (setf (obstacle-exists? o) t)
                (setf (obstacle-x o) (or old-x 50.0))
                (setf (obstacle-y o) (or old-y 50.0))
                (setf (obstacle-brightness o) (or old-brightness 0.2))
                (setf (obstacle-active o) (if old-state old-active t))
;;; (setf (obstacle-moving o) nil)
                ))
            (clear-obstacle o)))
  (let ((win cl-boids-gpu::*win*)
        (new-obstacles
         (predator-sort
          (loop
             for o across *obstacles*
             if (obstacle-exists? o)
             collect o))))
    (if win
        (progn
          (clear-obstacles win)
          (gl-set-obstacles win new-obstacles)
          (set-obstacle-ref new-obstacles)))))

(defun activate-obstacle (idx)
  (setf (obstacle-active (aref *obstacles* idx)) t))

(defun deactivate-obstacle (idx)
  (setf (obstacle-active (aref *obstacles* idx)) nil))

(defun toggle-obstacle (idx)
  (if (obstacle-active (aref *obstacles* idx))
      (deactivate-obstacle idx)
      (activate-obstacle idx)))

;;; (setf (obstacle-brightness (aref *obstacles* 0)) 0.2)
