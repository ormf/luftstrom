;;; 
;;; obstacles-amd-rocm.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2022 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
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

;;; position, radius, type, obstacles-boardoffs-maxidx, obstacles-lookahead, obstacles-multiplier
;;; (with-mapped-svm-buffer)

;;; moving obstacles is tricky: as the player movements might be
;;; relocating a position quickly, we smooth the change of position by
;;; interpolating between the last and the next position during a
;;; number of frames. This interpolation is done in the host in the
;;; update-get-active-obstacles routine which is called in the display
;;; routine for every frame, updating the obstacles, storing their
;;; state in gpu memory to be used by the board/boid calculations and
;;; returning their updated state.

(defun update-get-active-obstacles (win &key (obstacles *obstacles*))
  "get the current (type x y radius brightness) of all active
obstacles, updating their location in case they are moving."
  (let ((bs (first (systems win)))
        (width (float luftstrom-display::*gl-width*))
        (height (float luftstrom-display::*gl-height*))
        (result '()))
    (if (and bs obstacles)
        (with-slots (num-obstacles maxobstacles obstacles-pos obstacles-radius obstacles-type obstacles-boardoffs-maxidx
                     gl-obst-pos gl-obst-radius gl-obst-type)
            bs
          (loop
            for o across obstacles
            for player from 0
            if (luftstrom-display::obstacle-exists? o)
              do (let* ((i (luftstrom-display::obstacle-ref o))
                        (radius (round (luftstrom-display::obstacle-radius o)))
                        (brightness (luftstrom-display::obstacle-brightness o))
                        (pos (luftstrom-display::obstacle-pos o))
                        (type (with-bound-mapped-buffer (p-type :array-buffer :read-only) gl-obst-type
                                                        (cffi:mem-aref p-type :int i)))
                        x y)
;;;                   (format t "~&~a~%" o)
                   (with-slots (dx dy x-steps y-steps x-clip y-clip) (aref (obstacle-target-posns bs) i)
                     (with-bound-mapped-buffer (p-pos :array-buffer :write-only) gl-obst-pos
                       (setf x (round (recalc-pos (cffi:mem-aref p-pos :float (+ (* i 4) 0)) dx x-steps x-clip width)))
                       (setf y (round (recalc-pos (cffi:mem-aref p-pos :float (+ (* i 4) 1)) dy y-steps y-clip height))))
                     (with-bound-mapped-buffer (p-radius :array-buffer :write-only) gl-obst-radius
                       (setf (cffi:mem-aref p-radius :int i) radius))
                     (unless (equal (apply #'local-to-global pos) (list x y))
                       (update-coords (luftstrom-display::obstacle-pos o) (float x) (float y))
                       (let ((coords (luftstrom-display::obstacle-pos o)))
                         (map nil #'(lambda (cell)
                                      (ref-set-cell cell coords))
                              (dependents (slot-value o 'luftstrom-display::pos)))))
                     (if (luftstrom-display::obstacle-active o)
                         (progn
                           (push
                            (list
                             type
                             player
                             (float x) (float y)
                             radius
                             brightness)
                            result))))))))
;;;    (format t "~&~a~%" result)
    (values (reverse result))))

(defun gl-set-obstacles (win obstacles &key bs)
  "set obstacles in gl-buffer in the order specified by
obstacles (they should be sorted by type)."
  (let ((bs (or bs (first (systems win))))
        (len (length obstacles)))
    (if bs
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-lookahead
                     obstacles-multiplier
                     obstacles-boardoffs-maxidx
                     gl-obst-pos
                     gl-obst-radius
                     gl-obst-boardoffs-maxidx
                     gl-obst-type
                     gl-obst-lookahead
                     gl-obst-multiplier)
            bs
;;;          (format t "gl-set-obstacles~%")
          (setf num-obstacles (min len maxobstacles))
          (loop for obst in obstacles
                for i below num-obstacles
                do (progn
                     (with-bound-mapped-buffer
                         (p-obst-pos :array-buffer :write-only) gl-obst-pos
                         (set-array-vals p-obst-pos (* i 4)
                                         (float (* *gl-width* (first (luftstrom-display::obstacle-pos obst))) 1.0)
                                         (float (* *gl-height* (second (luftstrom-display::obstacle-pos obst))) 1.0) 0.0 0.0))
                     (with-bound-mapped-buffer (p-obst-radius :array-buffer :write-only) gl-obst-radius
                       (setf (cffi:mem-aref p-obst-radius :int i) (round (luftstrom-display::obstacle-radius obst))))
                     (with-bound-mapped-buffer (p-obst-board-offs-maxidx :array-buffer :write-only) gl-obst-boardoffs-maxidx
                       (setf (cffi:mem-aref p-obst-board-offs-maxidx :int i) (get-board-offs-maxidx (* (luftstrom-display::obstacle-radius obst)
                                                                                                       (val (obstacles-lookahead *bp*))))))
                     
;;;                     (setf (obstacles-type bs) (ocl:create-from-gl-buffer *context* :read-write (gl-obst-type bs)))
                     (format t "type: ~a~%" (round (luftstrom-display::obstacle-type obst)))
                     (with-bound-mapped-buffer (p-obst-type :array-buffer :write-only) gl-obst-type
                       (setf (cffi:mem-aref p-obst-type :int i) (round (luftstrom-display::obstacle-type obst))))
                     (with-bound-mapped-buffer (p-obst-lookahead :array-buffer :write-only) gl-obst-lookahead
                       (setf (cffi:mem-aref p-obst-lookahead :float i) (luftstrom-display::obstacle-lookahead obst)))
                     (with-bound-mapped-buffer (p-obst-multiplier :array-buffer :write-only) gl-obst-multiplier
                       (setf (cffi:mem-aref p-obst-multiplier :float i) (luftstrom-display::obstacle-multiplier obst)))))
          num-obstacles))))



;; (gl-enqueue (lambda () (update-get-active-obstacles *win*)))
;;; (untrace)
;;;(trace '(setf obstacle-pos))

#|
(let* ((window *win*)
       (bs (first (systems window)))
       (command-queue (first (command-queues window))))
  (with-slots (obstacles-lookahead maxobstacles) bs
    (ocl:with-mapped-buffer (p1 command-queue obstacles-lookahead maxobstacles :read t)
      (loop for i below maxobstacles
           collect (cffi:mem-aref p1 :float i)))))

|#

(defun move-obstacle-rel (player direction window &key (delta 1) (clip nil))
  (let ((bs (first (systems window))))
    (if bs
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-boardoffs-maxidx
                     gl-obst-pos)
            bs
          (with-bound-mapped-buffer
              (p-obst-pos :array-buffer :read-write) gl-obst-pos
              (let* ((offset (* 4 (get-obstacle-ref player)))
                     (x (cffi:mem-aref p-obst-pos :float offset))
                     (y (cffi:mem-aref p-obst-pos :float (1+ offset))))
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
                (setf (cffi:mem-aref p-obst-pos :float 0) (float x 1.0))
                (setf (cffi:mem-aref p-obst-pos :float 1) (float y 1.0))))))))

(defun move-obstacle-rel-xy (player dx dy window &key (clip nil))
  (let ((bs (first (systems window))))
    (if bs
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-boardoffs-maxidx
                     gl-obst-pos)
            bs
          (progn
            (with-bound-mapped-buffer
                (p-obst-pos :array-buffer :read-write) gl-obst-pos
                (let* ((offset (* 4 (get-obstacle-ref player)))
                       (x (cffi:mem-aref p-obst-pos :float offset))
                       (y (cffi:mem-aref p-obst-pos :float (1+ offset))))
                (setf x (if clip
                            (min (max 0 (+ x dx)) (glut:width window))
                            (mod (+ x dx) (glut:width window))))
                (setf y (if clip
                            (min (max 0 (+ y dy)) (glut:height window))
                            (mod (+ y dy) (glut:height window))))
                (setf (cffi:mem-aref p-obst-pos :float 0) (float x 1.0))
                (setf (cffi:mem-aref p-obst-pos :float 1) (float y 1.0)))))))))

(defun get-obstacle-position (player window)
  (let ((bs (first (systems window))))
    (with-bound-mapped-buffer
        (p-obst-pos :array-buffer :read-only) (gl-obst-pos bs)
        (let ((offset (* 4 (get-obstacle-ref player))))
          (values (/ (cffi:mem-aref p-obst-pos :float offset) *gl-width*)
                  (/ (cffi:mem-aref p-obst-pos :float (1+ offset)) *gl-height*))))))

;;; (gl-enqueue (lambda () (multiple-value-bind (x y) (get-obstacle-position 0 *win*) (format t "~&~a, ~a~%" x y))))

(defun set-obstacle-position (window player x y)
  (let* ((bs (first (systems window)))
         (mouse-obstacle (and player (luftstrom-display::obstacle player))))
    (if (and bs mouse-obstacle)
        (with-bound-mapped-buffer
            (p-obst-pos :array-buffer :write-only) (gl-obst-pos bs)
            (let ((offset (* 4 (luftstrom-display::obstacle-ref mouse-obstacle))))
              (setf (cffi:mem-aref p-obst-pos :float offset) x)
              (setf (cffi:mem-aref p-obst-pos :float (1+ offset)) y))
;;;            (setf (obstacles-pos bs) (ocl:create-from-gl-buffer *context* :read-write (gl-obst-pos bs)))
            (list x y)))))

;;; (gl-enqueue (lambda () (set-obstacle-position *win* 0 0.2 0.5)))

;;; (setf (val (slot-value (luftstrom-display::obstacle 0) 'luftstrom-display::brightness)) 1.0)

(defparameter *ob-board* nil)

(defun get-obstacle-board ()
  (gl-enqueue
   (lambda ()
     (let* ((bs (first (systems *win*)))
            (command-queue (first (command-queues *win*)))
            (count (* *gl-width* *gl-height* (pixelsize (first (systems *win*))))))
       (setf *ob-board* (enqueue-read-buffer command-queue (obstacle-board bs) count))))))

(defun get-obstacle-board ()
  (gl-enqueue
   (lambda ()
     (let* ((bs (first (systems *win*)))
            (command-queue (first (command-queues *win*)))
            (count (* *gl-width* *gl-height* (pixelsize (first (systems *win*))))))
       (setf *ob-board* (enqueue-read-buffer command-queue (obstacles-pos bs) 64))))))

;; (get-obstacle-board)
;; (count (first (systems *win*)))

(defun set-obstacle-positions (bs x y)
  (let* ((maxobstacles (maxobstacles bs)))
    (with-bound-mapped-buffer
        (p :array-buffer :write-only) (gl-obst-pos bs)
        (loop repeat maxobstacles
              for i from 0 by 2 ;;; as i indexes floats, we increase the float-count and *not* the byte-count!
              do (progn
                   (setf (cffi:mem-aref p :float i) (float x))
                   (setf (cffi:mem-aref p :float (1+ i)) (float y)))))
    (setf (obstacles-pos bs) (ocl:create-from-gl-buffer *context* :read-write (gl-obst-pos bs)))))

(defun set-obstacle-positions-vector (bs val)
  (let* ((pos (make-array 32 :element-type 'single-float :initial-element (float val))))
    (vector->vbo pos (gl-obst-pos bs))))

(defun get-obstacle-position (window player)
  (let* ((bs (first (systems window)))
         (mouse-obstacle (and player (luftstrom-display::obstacle player))))
    (with-bound-mapped-buffer
        (p-obst-pos :array-buffer :read-only) (gl-obst-pos bs)
        (let ((offset (* 4 (luftstrom-display::obstacle-ref mouse-obstacle))))
          (list (cffi:mem-aref p-obst-pos :float offset)
                (cffi:mem-aref p-obst-pos :float (1+ offset)))))))

(defun ocl-get-obstacle-position (window player)
  (let* ((bs (first (systems window)))
         (maxobstacles 16)
         pos
         (mouse-obstacle (and player (luftstrom-display::obstacle player)))
         (command-queue (first (command-queues window))))
    (ocl:with-mapped-buffer (p-pos command-queue (obstacles-pos bs) (* 4 maxobstacles) :read t)
      (let ((offset (* 4 (luftstrom-display::obstacle-ref mouse-obstacle))))
        (setf pos (list (cffi:mem-aref p-pos :float (+ offset 0))
              (cffi:mem-aref p-pos :float (+ offset 1)))))
      (finish command-queue))
    pos))

(defun ocl-set-obstacle-position (window player x y)
  (let* ((bs (first (systems window)))
         (maxobstacles 16)
         (mouse-obstacle (and player (luftstrom-display::obstacle player)))
         (command-queue (first (command-queues window))))
    (ocl:with-mapped-buffer (p-pos command-queue (obstacles-pos bs) (* 4 maxobstacles) :write t)
      (let ((offset (* 4 (luftstrom-display::obstacle-ref mouse-obstacle))))
        (setf (cffi:mem-aref p-pos :float (+ offset 0)) (float x))
        (setf (cffi:mem-aref p-pos :float (+ offset 1)) (float y))
        (finish command-queue)))))

(defun ocl-get-obstacle-type (window player)
  (let* ((bs (first (systems window)))
         (maxobstacles 16)
         type
         (mouse-obstacle (and player (luftstrom-display::obstacle player)))
         (command-queue (first (command-queues window))))
    (ocl:with-mapped-buffer (p-type command-queue (obstacles-type bs) maxobstacles :read t)
      (let ((offset (luftstrom-display::obstacle-ref mouse-obstacle)))
        (setf type (list (cffi:mem-aref p-type :int offset))))
      (finish command-queue))
    type))

;; (gl-enqueue (lambda () (format t "~a~%" (get-obstacle-position *win* 1))))
;; (gl-enqueue (lambda () (format t "~a~%" (get-obstacle-type *win* 1))))
;; (gl-enqueue (lambda () (format t "~a~%" (set-obstacle-positions (first (systems *win*)) 130 200))))
;;; (gl-enqueue (lambda () (set-obstacle-positions-vector *win*)))
;;; (gl-enqueue (lambda () (set-obstacle-position *win* 1 0.3 0.5)))

;; (ocl-get-obstacle-position *win* 1)
;; (ocl-get-obstacle-type *win* 1)
;; (set-obstacle-position
;; (bs (first (systems *win*)))
;; (ocl-set-obstacle-position *win* 1 150 200)

