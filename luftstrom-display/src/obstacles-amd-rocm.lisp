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
                     obstacles-boardoffs-maxidx)
            bs
          (loop
            for o across obstacles
            for player from 0
            if (luftstrom-display::obstacle-exists? o)
              do ;; (let* ((i (luftstrom-display::obstacle-ref o))
                 ;;        (radius (luftstrom-display::obstacle-radius o))
                 ;;        (brightness (luftstrom-display::obstacle-brightness o)))
                 ;;   (ocl:with-mapped-buffer (p-pos command-queue obstacles-pos (* 4 maxobstacles) :write t)
                 ;;     (ocl:with-mapped-buffer (p-radius command-queue obstacles-radius maxobstacles :write t)
                 ;;       (ocl:with-mapped-buffer (p-type command-queue obstacles-type maxobstacles :read t)
                 ;;         (with-slots (dx dy x-steps y-steps x-clip y-clip) (aref (obstacle-target-posns bs) i)
                 ;;           (let* (
                 ;;                  (pos (luftstrom-display::obstacle-pos o))
                 ;;                  ;;                                   (x (round (* width (first pos))))
                 ;;                  ;;                                   (y (round (* height (second pos))))
                 ;;                  (x (round (recalc-pos (cffi:mem-aref p-pos :float (+ (* i 4) 0)) dx x-steps x-clip width)))
                 ;;                  (y (round (recalc-pos (cffi:mem-aref p-pos :float (+ (* i 4) 1)) dy y-steps y-clip height)))
                 ;;                  )
                 ;;             ;;                              (break)
                 ;;             ;;
                 ;;   
                 ;;             (unless (equal (apply #'local-to-global pos) (list x y))
                 ;;               ;; (format t "~&~a, ~a: ~a~%" (apply #'local-to-global pos) (list x y)
                 ;;               ;;         (equal (apply #'local-to-global pos) (list x y)))
                 ;;               (update-coords (luftstrom-display::obstacle-pos o) (float x) (float y))
                 ;;               (let ((coords (luftstrom-display::obstacle-pos o)))
                 ;;                 (map nil #'(lambda (cell)
                 ;;                              (ref-set-cell cell coords))
                 ;;                      (dependents (slot-value o 'luftstrom-display::pos)))))
                 ;;             (if (luftstrom-display::obstacle-active o)
                 ;;                 (push
                 ;;                  (list
                 ;;                   (cffi:mem-aref p-type :int i) ;;; type
                 ;;                   player
                 ;;                   (float x) (float y)
                 ;;                   (setf (cffi:mem-aref p-radius :int i) (round radius))
                 ;;                   brightness)
                 ;;                  result)))))))
                 ;;   )
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
                     obstacles-boardoffs-maxidx)
            bs
          (setf num-obstacles (min len maxobstacles))
          (ocl:with-mapped-buffer (p1 command-queue obstacles-pos (* 4 maxobstacles) :write t)
            (ocl:with-mapped-buffer (p2 command-queue obstacles-radius maxobstacles :write t)
              (ocl:with-mapped-buffer (p3 command-queue obstacles-boardoffs-maxidx maxobstacles :write t)
                (ocl:with-mapped-buffer (p4 command-queue obstacles-type maxobstacles :write t)
                  (ocl:with-mapped-buffer (p5 command-queue obstacles-lookahead maxobstacles :write t)
                    (ocl:with-mapped-buffer (p6 command-queue obstacles-multiplier maxobstacles :write t)
                      (loop for obst in obstacles
                         for i below num-obstacles
                            do (progn
                                 (set-array-vals p1 (* i 4) (float (* *gl-width* (first (luftstrom-display::obstacle-pos obst))) 1.0)
                                                 (float (* *gl-height* (second (luftstrom-display::obstacle-pos obst))) 1.0) 0.0 0.0)
                                 (setf (cffi:mem-aref p2 :int i) (round (luftstrom-display::obstacle-radius obst)))
                              ;;;; check! obstacles-lookahead from *bp*????
                                 (setf (cffi:mem-aref p3 :int i) (get-board-offs-maxidx (* (luftstrom-display::obstacle-radius obst)
                                                                                           (val (obstacles-lookahead *bp*)))))
                                 (setf (cffi:mem-aref p4 :int i) (round (luftstrom-display::obstacle-type obst)))
;;;                                 (format t "~&gl-set-obstacles-type ~a to: ~a" i (round (luftstrom-display::obstacle-type obst)))
                                 (setf (cffi:mem-aref p5 :float i) (luftstrom-display::obstacle-lookahead obst))
                                 (setf (cffi:mem-aref p6 :float i) (luftstrom-display::obstacle-multiplier obst))))))))))
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
      (values (round (cffi:mem-aref p1 :float 0))
              (round (cffi:mem-aref p1 :float 1))))))

;;; (get-obstacle-pos 0 *win*)
