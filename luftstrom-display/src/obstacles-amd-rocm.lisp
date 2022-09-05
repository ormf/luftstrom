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
  (let ((command-queue (first (command-queues win)))
        (bs (first (systems win)))
        (width (float luftstrom-display::*gl-width*))
        (height (float luftstrom-display::*gl-height*))
        (result '()))
    (if (and bs obstacles)
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-boardoffs-maxidx
                     gl-obst-pos
                     gl-obst-radius
                     gl-obst-type)
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
                         (push
                          (list
                           type
                           player
                           (float x) (float y)
                           radius
                           brightness)
                          result))))
            (finish command-queue))))
    (values (reverse result))))

(defun gl-set-obstacles (win obstacles &key bs)
  "set obstacles in gl-buffer in the order specified by
obstacles (they should be sorted by type)."
  (let ((command-queue (first (command-queues win)))
        (bs (or bs (first (systems win))))
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
          (setf num-obstacles (min len maxobstacles))
          (loop for obst in obstacles
                for i below num-obstacles
                do (progn
                     (with-bound-mapped-buffer (p-obst-pos :array-buffer :write-only) gl-obst-pos
                       (set-array-vals p-obst-pos (* i 4) (float (* *gl-width* (first (luftstrom-display::obstacle-pos obst))) 1.0)
                                       (float (* *gl-height* (second (luftstrom-display::obstacle-pos obst))) 1.0) 0.0 0.0))
                     (with-bound-mapped-buffer (p-obst-radius :array-buffer :write-only) gl-obst-radius
                       (setf (cffi:mem-aref p-obst-radius :int i) (round (luftstrom-display::obstacle-radius obst))))
                     (with-bound-mapped-buffer (p-obst-board-offs-maxidx :array-buffer :write-only) gl-obst-boardoffs-maxidx
                       (setf (cffi:mem-aref p-obst-board-offs-maxidx :int i) (get-board-offs-maxidx (* (luftstrom-display::obstacle-radius obst)
                                                                                                  (val (obstacles-lookahead *bp*))))))
                     (with-bound-mapped-buffer (p-obst-type :array-buffer :write-only) gl-obst-type
                       (setf (cffi:mem-aref p-obst-type :int i) (round (luftstrom-display::obstacle-type obst))))
                     (with-bound-mapped-buffer (p-obst-lookahead :array-buffer :write-only) gl-obst-lookahead
                       (setf (cffi:mem-aref p-obst-lookahead :float i) (luftstrom-display::obstacle-lookahead obst)))
                     (with-bound-mapped-buffer (p-obst-multiplier :array-buffer :write-only) gl-obst-multiplier
                       (setf (cffi:mem-aref p-obst-multiplier :float i) (luftstrom-display::obstacle-multiplier obst)))))
          num-obstacles))))



;; (update-get-active-obstacles *win*)
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

(defun get-obstacle-pos (player window)
  (let ((bs (first (systems window))))
    (with-bound-mapped-buffer
        (p-obst-pos :array-buffer :read-only) (gl-obst-pos bs)
        (let ((offset (* 4 (get-obstacle-ref player))))
          (values (round (cffi:mem-aref p-obst-pos :float offset))
                  (round (cffi:mem-aref p-obst-pos :float (1+ offset))))))))

;;; (get-obstacle-pos 0 *win*)

(defun set-obstacle-position (window player x y)
  (let* ((bs (first (systems window)))
         (mouse-obstacle (and player (luftstrom-display::obstacle player))))
    (if (and bs mouse-obstacle)
        (with-bound-mapped-buffer
            (p-obst-pos :array-buffer :write-only) (gl-obst-pos bs)
            (let ((offset (* 4 (luftstrom-display::obstacle-ref mouse-obstacle))))
              (setf (cffi:mem-aref p-obst-pos :float offset) (float (* *gl-width* x) 1.0))
;;;              (format t "~&~a, ~a, ~a~%" x y (luftstrom-display::obstacle-ref mouse-obstacle))
              (setf (cffi:mem-aref p-obst-pos :float (1+ offset)) (float (* *gl-height* y) 1.0)))
            (list (float (* *gl-width* x) 1.0)
                  (float (* *gl-height* y) 1.0))))))
