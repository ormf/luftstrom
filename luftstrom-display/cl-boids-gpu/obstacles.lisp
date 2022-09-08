;;;; obstacles.lisp
;;;;
;;;; Copyright (c) 2017-18 Orm Finnendahl
;;;; <orm.finnendahl@selma.hfmdk-frankfurt.de>
;;;

;;; run cl-boids-gpu:boids, click to add boids (right click for new
;;; system), 'c' to clear running systems, esc to quit. Might need to
;;; adjust *boids-per-click* depending on hardware performance

(in-package #:cl-boids-gpu)

(unless (boundp '+no-interact-type+)
  (defconstant +no-interact-type+ 0))

(unless (boundp '+standard-type+)
  (defconstant +standard-type+ 1))

(unless (boundp '+plucker-type+)
  (defconstant +plucker-type+ 2))

(unless (boundp '+attractor-type+)
  (defconstant +attractor-type+ 3))

(unless (boundp '+predator-type+)
  (defconstant +predator-type+ 4))

(defun new-obstacle (win pos-x pos-y radius &key bs)
  (let ((*command-queues* (command-queues win))
        (bs (or bs (first (systems win)))))
    (with-slots (num-obstacles
                 maxobstacles
                 obstacles-pos
                 obstacles-radius
                 obstacles-lookahead
                 obstacles-type
                 obstacles-boardoffs-maxidx)
        bs
      (if (< num-obstacles maxobstacles)
          (progn
            (ocl:with-mapped-buffer (p1 (car *command-queues*) obstacles-pos (* 4 maxobstacles) :write t)
              (ocl:with-mapped-buffer (p2 (car *command-queues*) obstacles-radius maxobstacles :write t)
                (ocl:with-mapped-buffer (p3 (car *command-queues*) obstacles-boardoffs-maxidx maxobstacles :write t)
                  (ocl:with-mapped-buffer (p4 (car *command-queues*) obstacles-type maxobstacles :write t)
                    (ocl:with-mapped-buffer (p5 (car *command-queues*) obstacles-lookahead maxobstacles :write t)
                      (set-array-vals p1 (* num-obstacles 4) (float pos-x 1.0) (float pos-y 1.0) 0.0 0.0)
                      (setf (cffi:mem-aref p2 :int num-obstacles) (round radius))
                      (setf (cffi:mem-aref p3 :int num-obstacles) (get-board-offs-maxidx (* radius *obstacles-lookahead*)))
                      (setf (cffi:mem-aref p4 :int num-obstacles) +standard-type+)
                      (setf (cffi:mem-aref p5 :float num-obstacles) 2.5))))))
            (incf (num-obstacles bs)))))))

(defun new-predator (win pos-x pos-y radius &key bs)
  "predators are added to the head of all obstacles."
  (let ((*command-queues* (command-queues win))
        (bs (or bs (first (systems win)))))
    (with-slots (num-obstacles
                 maxobstacles
                 obstacles-pos
                 obstacles-radius
                 obstacles-lookahead
                 obstacles-type
                 obstacles-boardoffs-maxidx)
        bs
      (if (< num-obstacles maxobstacles)
          (progn
            (ocl:with-mapped-buffer (p1 (car *command-queues*) obstacles-pos (* 4 maxobstacles) :write t)
              (ocl:with-mapped-buffer (p2 (car *command-queues*) obstacles-radius maxobstacles :write t)
                (ocl:with-mapped-buffer (p3 (car *command-queues*) obstacles-boardoffs-maxidx maxobstacles :write t)
                  (ocl:with-mapped-buffer (p4 (car *command-queues*) obstacles-type maxobstacles :write t)
                    (ocl:with-mapped-buffer (p5 (car *command-queues*) obstacles-lookahead maxobstacles :write t)
                      (dotimes (i num-obstacles)
                        (let ((pos-x (cffi:mem-aref p1 :float (+ (* (- num-obstacles i 1) 4) 0)))
                              (pos-y (cffi:mem-aref p1 :float (+ (* (- num-obstacles i 1) 4) 1)))
                              (radius (cffi:mem-aref p2 :int (- num-obstacles i 1)))
                              (maxidx (cffi:mem-aref p3 :int (- num-obstacles i 1)))
                              (type (cffi:mem-aref p4 :int (- num-obstacles i 1)))
                              (lookahead (cffi:mem-aref p5 :float (- num-obstacles i 1))))
                          (set-array-vals p1 (* (- num-obstacles i) 4) (float pos-x 1.0) (float pos-y 1.0) 0.0 0.0)
                          (setf (cffi:mem-aref p2 :int (- num-obstacles i)) (round radius))
                          (setf (cffi:mem-aref p3 :int (- num-obstacles i)) maxidx)
                          (setf (cffi:mem-aref p4 :int (- num-obstacles i)) type)
                          (setf (cffi:mem-aref p5 :float (- num-obstacles i)) lookahead)))
                      (set-array-vals p1 0 (float pos-x 1.0) (float pos-y 1.0) 0.0 0.0)
                      (setf (cffi:mem-aref p2 :int 0) (round radius))
                      (setf (cffi:mem-aref p3 :int 0) (get-board-offs-maxidx (* radius *obstacles-lookahead*)))
                      (setf (cffi:mem-aref p4 :int 0) 1)
                      (setf (cffi:mem-aref p5 :float 0) 2.5))))))
            (incf (num-obstacles bs)))))))

;;; (new-predator *win* 150 350 30)

;; (num-obstacles (first (systems *win*)))

;;; (delete-obstacle *win* 0)

;;; (get-obstacles *win*)

(defun new-attractor (win pos-x pos-y radius &key bs)
  "attractors are inserted after the predators."
  (let ((*command-queues* (command-queues win))
        (bs (or bs (first (systems win)))))
    (with-slots (num-obstacles
                 maxobstacles
                 obstacles-pos
                 obstacles-radius
                 obstacles-type
                 obstacles-lookahead
                 obstacles-boardoffs-maxidx)
        bs
      (if (< num-obstacles maxobstacles)
          (progn
            (ocl:with-mapped-buffer (p1 (car *command-queues*) obstacles-pos (* 4 maxobstacles) :write t)
              (ocl:with-mapped-buffer (p2 (car *command-queues*) obstacles-radius maxobstacles :write t)
                (ocl:with-mapped-buffer (p3 (car *command-queues*) obstacles-boardoffs-maxidx maxobstacles :write t)
                  (ocl:with-mapped-buffer (p4 (car *command-queues*) obstacles-type maxobstacles :write t)
                    (ocl:with-mapped-buffer (p5 (car *command-queues*) obstacles-lookahead maxobstacles :write t)
                      (let ((attractor-idx
                             (dotimes (i num-obstacles) ;;; shift all obstacles to pos+1 starting at end until a
                                                        ;;; predator is found. return the idx at which to insert new obstacle.
                               (let ((pos-x (cffi:mem-aref p1 :float (+ (* (- num-obstacles i 1) 4) 0)))
                                     (pos-y (cffi:mem-aref p1 :float (+ (* (- num-obstacles i 1) 4) 1)))
                                     (radius (cffi:mem-aref p2 :int (- num-obstacles i 1)))
                                     (maxidx (cffi:mem-aref p3 :int (- num-obstacles i 1)))
                                     (type (cffi:mem-aref p4 :int (- num-obstacles i 1)))
                                     (lookahead (cffi:mem-aref p5 :float (- num-obstacles i 1))))
                                 (if (< type +predator-type+)
                                     (progn
                                       (set-array-vals p1 (* (- num-obstacles i) 4) (float pos-x 1.0) (float pos-y 1.0) 0.0 0.0)
                                       (setf (cffi:mem-aref p2 :int (- num-obstacles i)) (round radius))
                                       (setf (cffi:mem-aref p3 :int (- num-obstacles i)) maxidx)
                                       (setf (cffi:mem-aref p4 :int (- num-obstacles i)) type)
                                       (setf (cffi:mem-aref p5 :float (- num-obstacles i)) lookahead))
                                     (return (- num-obstacles i)))))))
                        (set-array-vals p1 attractor-idx (float pos-x 1.0) (float pos-y 1.0) 0.0 0.0)
                        (setf (cffi:mem-aref p2 :int attractor-idx) (round radius))
                        (setf (cffi:mem-aref p3 :int attractor-idx) (get-board-offs-maxidx (* radius *obstacles-lookahead*)))
                        (setf (cffi:mem-aref p4 :int attractor-idx) +attractor-type+)
                        (setf (cffi:mem-aref p5 :float attractor-idx) 2.5)))))))
            (incf (num-obstacles bs)))))))

#|
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
                     do (destructuring-bind (o pos-x pos-y) obst
                          (with-slots (luftstrom-display::radius luftstrom-display::type) o
                            (set-array-vals p1 (* i 4) (float pos-x 1.0) (float pos-y 1.0) 0.0 0.0)
                            (setf (cffi:mem-aref p2 :int i) (round luftstrom-display::radius))
                            (setf (cffi:mem-aref p3 :int i) (get-board-offs-maxidx (* luftstrom-display::radius *obstacles-lookahead*)))
                            (setf (cffi:mem-aref p4 :int i) luftstrom-display::type))))))))
          num-obstacles))))
|#

(defun delete-obstacle (win idx)
  (let ((*command-queues* (command-queues win))
        (bs (first (systems win))))
    (with-slots (num-obstacles
                 maxobstacles
                 obstacles-pos
                 obstacles-radius
                 obstacles-type
                 obstacles-boardoffs-maxidx)
        bs
      (if (< idx num-obstacles)
          (progn
            (ocl:with-mapped-buffer (p1 (car *command-queues*) obstacles-pos (* 4 maxobstacles) :write t)
              (ocl:with-mapped-buffer (p2 (car *command-queues*) obstacles-radius maxobstacles :write t)
                (ocl:with-mapped-buffer (p3 (car *command-queues*) obstacles-boardoffs-maxidx maxobstacles :write t)
                  (ocl:with-mapped-buffer (p4 (car *command-queues*) obstacles-type maxobstacles :write t)
                    (dotimes (i (- num-obstacles idx))
                      (let ((pos-x (cffi:mem-aref p1 :float (+ (* (+ idx i 1) 4) 0)))
                            (pos-y (cffi:mem-aref p1 :float (+ (* (+ idx i 1) 4) 1)))
                            (radius (cffi:mem-aref p2 :int (+ idx i 1)))
                            (maxidx (cffi:mem-aref p3 :int (+ idx i 1)))
                            (type (cffi:mem-aref p4 :int (+ idx i 1))))
                        (set-array-vals p1 (* (+ idx i) 4) (float pos-x 1.0) (float pos-y 1.0) 0.0 0.0)
                        (setf (cffi:mem-aref p2 :int (+ idx i)) (round radius))
                        (setf (cffi:mem-aref p3 :int (+ idx i)) maxidx)
                        (setf (cffi:mem-aref p4 :int (+ idx i)) type)))))))
            (decf (num-obstacles bs)))))))

;;; (delete-obstacle *win* 0)

#|
(defun clear-obstacles (win)
  (dotimes (idx (num-obstacles (first (systems win))))
    (delete-obstacle win idx)))
|#

(defun clear-obstacles (win)
  (if (first (systems win))
      (setf (num-obstacles (first (systems win))) 0)))

;;; (clear-obstacles *win*)

(defmacro recalc-pos (old-pos delta steps-remain clip max)
  `(if (> ,steps-remain 0)
       (setf ,old-pos
             (let ((incr (round (/ ,delta ,steps-remain))))
               (decf ,delta incr)
               (decf ,steps-remain)
               (if ,clip
                   (max 0.0 (min ,max (+ ,old-pos incr)))
                   (mod (+ ,old-pos incr) ,max))))
       ,old-pos))

(defun global->local-pos (pos)
  (destructuring-bind (x y) pos
    (list (/ x *gl-width*)
          (/ y *gl-height*))))

(defun local->global-pos (pos)
  (destructuring-bind (x y) pos
    (list (* x *gl-width*)
          (* y *gl-height*))))

(defun get-obstacles (win)
  (let ((command-queue (first (command-queues win)))
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
                     obstacles-lookahead
                     obstacles-boardoffs-maxidx)
            bs
          (dotimes (i num-obstacles)
             (ocl:with-mapped-buffer (p1 command-queue obstacles-pos (* 4 maxobstacles) :write t)
              (ocl:with-mapped-buffer (p2 command-queue obstacles-radius maxobstacles :read t)
                (ocl:with-mapped-buffer (p3 command-queue obstacles-boardoffs-maxidx maxobstacles :read t)
                  (ocl:with-mapped-buffer (p4 command-queue obstacles-type maxobstacles :read t)
                    (ocl:with-mapped-buffer (p5 command-queue obstacles-lookahead maxobstacles :read t)
                      (with-slots (dx dy x-steps y-steps x-clip y-clip) (aref (obstacle-target-posns bs) i)
                        (push
                         (list
                          (cffi:mem-aref p4 :int i)               ;;; type
                          (recalc-pos (cffi:mem-aref p1 :float (+ (* i 4) 0)) dx x-steps x-clip width) ;;; x
                          (recalc-pos (cffi:mem-aref p1 :float (+ (* i 4) 1)) dy y-steps y-clip height) ;;; y
                          (cffi:mem-aref p2 :int i)               ;;; radius
                          (cffi:mem-aref p5 :float i)               ;;; lookaead
                          ;;                       :maxidx (cffi:mem-aref p3 :int i)
                          )
                         result))))))))))
    (values (reverse result))))

;;; (get-obstacles *win*)

;; (aref (obstacle-target-posns (first (systems *win*))) 0)

(defun set-obstacle-dx (gl-idx delta steps clip)
  "to smooth the movement of obstacles, we set a delta value in the
obstacle-target struct of the obstacle and let the gl loop take care
of the interpolation. The idx is *not* the idx of the player
obstacle (stored in *obstacles*), as the obstacles are sorted in
predator order in the gl context. The gl idx value is stored in the
'ref slot of the obstacles stored in *obstacles*."
  (let* ((bs (first (systems *win*)))
         (obstacle-target-posns (aref (obstacle-target-posns bs) gl-idx)))
    (with-slots (dx x-steps x-clip) obstacle-target-posns
      (setf dx (round delta))
      (setf x-steps steps)
      (setf x-clip clip))))

;;; (set-obstacle-dx 0 -40 1 nil)
;;; (set-obstacle-dy 0 50 10 nil)

(defun set-obstacle-dy (gl-idx delta steps clip)
  "to smooth the movement of obstacles, we set a delta value in the
obstacle-target struct of the obstacle and let the gl loop take care
of the interpolation (done in 'steps number of picture frames). The
idx is *not* the idx of the player obstacle (stored in *obstacles*),
as the obstacles are sorted in predator order in the gl context. This
gl idx value is stored in the 'ref slot of the obstacles stored in
*obstacles*."
  (let* ((bs (first (systems *win*)))
         (obstacle-target-posns (aref (obstacle-target-posns bs) gl-idx)))
    (with-slots (dy y-steps y-clip) obstacle-target-posns
      (setf dy (round delta))
      (setf y-steps steps)
      (setf y-clip clip ))))

#|
(let* ((window *win*)
       (bs (first (systems window)))
       (command-queue (first (command-queues window))))
  (with-slots (obstacles-lookahead maxobstacles) bs
    (ocl:with-mapped-buffer (p1 command-queue obstacles-lookahead maxobstacles :read t)
      (loop for i below maxobstacles
           collect (cffi:mem-aref p1 :float i)))))
|#
(defun set-obstacle-lookahead (idx value)
  "set the lookahead in the opencl-array."
  (unless (< idx 0)
      (let* ((window *win*)
             (bs (if window (first (systems window))))
             (command-queue (if window (first (command-queues window)))))
        (if bs
            (with-slots (obstacles-lookahead maxobstacles) bs
              (ocl:with-mapped-buffer (p1 command-queue obstacles-lookahead maxobstacles :write t)
                (setf (cffi:mem-aref p1 :float idx) value)))))))

(defun set-obstacle-multiplier (idx value)
  "set the obstacle multiplier in the opencl-array."
  (let* ((window *win*)
         (bs (if window (first (systems window))))
         (command-queue (if window (first (command-queues window)))))
    (if bs
        (with-slots (obstacles-multiplier maxobstacles) bs
          (ocl:with-mapped-buffer (p1 command-queue obstacles-multiplier maxobstacles :write t)
            (setf (cffi:mem-aref p1 :float idx) value))))))


#|

*obstacles*
(aref (obstacle-target-posns (first (systems *win*))) 0)

(with-slots (dx dy x-steps y-steps)
    (aref (obstacle-target-posns (first (systems *win*))) 0)
  (set-syntax-from-char dx 100)
  (setf x-steps 10)
  (setf dy -100)
  (setf y-steps 10))

(defparameter *test* (make-obstacle-targets))

(with-slots (x-steps dx) *test*
  (setf x-steps 10)
  (setf dx 10)
  (recalc-pos 5 dx x-steps)
  )


(with-slots (x-steps dx) *test*
  (recalc-pos 5 dx x-steps)
  )
|#
