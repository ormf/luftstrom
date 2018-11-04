;;;; luftstrom-display.lisp

(in-package #:cl-boids-gpu)

;;; (boids :width 1200 :height 900)
;;; (incudine:rt-stop)


(setf *print-case* :downcase)

(defun %update-system (window bs)
  (let ((command-queue (car (command-queues window)))
        (pixelsize (pixelsize bs))
        (width (glut:width window))
        (height (glut:height window))
        (vel (velocity-buffer bs))
        (forces (force-buffer bs))
        (bidx (bidx-buffer bs))
        (life (life-buffer bs))
        (retrig (retrig-buffer bs))
        (color (color-buffer bs))
        (weight-board (weight-board bs))
        (align-board (align-board bs))
        (board-dx (board-dx bs))
        (board-dy (board-dy bs))
        (coh (board-coh bs))
        (sep (board-sep bs))
        (obstacle-board (obstacle-board bs))
        (obstacles-pos (obstacles-pos bs))
        (obstacles-radius (obstacles-radius bs))
        (obstacles-type (obstacles-type bs))
        (obstacles-lookahead (obstacles-lookahead bs))
        (obstacles-boardoffs-maxidx (obstacles-boardoffs-maxidx bs))
        (num-obstacles (num-obstacles bs))
        (dist (board-dist bs))
        (cb-kernel (clear-board-kernel window))
        (cw-kernel (calc-weight-kernel window))
        (kernel (find-kernel *curr-kernel*))
        (count (boid-count bs)))
    (if (> count 0)
        (let
            ((pos (boid-coords-buffer bs)))
          (set-kernel-args cb-kernel (weight-board align-board obstacle-board obstacles-pos obstacles-radius
                                                   obstacles-lookahead
                                                   ((make-obstacle-mask) :uint)
                                                   (num-obstacles :int)
                                                   (pixelsize :int) ((round (/ width pixelsize)) :int)
                                                   ((round (/ height pixelsize)) :int)))
          (enqueue-nd-range-kernel command-queue cb-kernel (round (* (/ width pixelsize) (/ height pixelsize))))
          (finish command-queue)
          (set-kernel-args
           cw-kernel
           (pos weight-board vel align-board (pixelsize :int) (width :int) (height :int)))
          (enqueue-nd-range-kernel command-queue cw-kernel (boid-count bs))
          (finish command-queue)
          (if *test*
              (progn
                (format t "~a"
                        (list pos vel forces bidx life color weight-board align-board
                              board-dx board-dy dist coh sep obstacle-board obstacles-pos
                              obstacles-radius obstacles-boardoffs-maxidx num-obstacles

                              (round *maxidx*) (float *length* 1.0) (float *speed* 1.0)
                              (x bs) (y bs) (z bs) (float *maxspeed* 1.0) (float *maxforce* 1.0)
                              (float *alignmult* 1.0) (float *sepmult* 1.0)
                              (float *cohmult* 1.0) (float *maxlife* 1.0) (float *lifemult* 1.0)
                              (round count) (round pixelsize) (round width)(round height)))
                (setf *test* nil)))
          (decf *clock*)
          (set-kernel-args kernel
                           (pos vel forces bidx life retrig color weight-board align-board
                                board-dx board-dy dist coh sep obstacle-board obstacles-pos obstacles-radius obstacles-type
                                obstacles-boardoffs-maxidx obstacles-lookahead
                                ((round num-obstacles) :int)
                                ((if (<= *clock* 0) 1 0) :int)
                                ((round *maxidx*) :int) ((float *length* 1.0) :float) ((float *speed* 1.0) :float)
                                ((x bs) :float) ((y bs) :float) ((z bs) :float)
                                ((float *maxspeed* 1.0) :float)
                                ((float *maxforce* 1.0) :float)
                                ((float *alignmult* 1.0) :float)
                                ((float *sepmult* 1.0) :float)
                                ((float *cohmult* 1.0) :float)
                                ((float *predmult* 1.0) :float)
                                ((float *maxlife* 1.0) :float)
                                ((float *lifemult* 1.0) :float)
                                ((round count) :int)
                                ((round pixelsize) :int)
                                ((round width) :int)
                                ((round height) :int)))
          (enqueue-nd-range-kernel command-queue kernel count)
          (finish command-queue)

          (setf *num-boids* (boid-count bs))
          ;;    (setf *positions* (boid-coords-buffer bs))
          (setf *positions* (enqueue-read-buffer command-queue pos
                                                 (* 16 (boid-count bs))))
          (setf *velocities* (enqueue-read-buffer command-queue vel
                                                  (* 4 (boid-count bs))))
          (setf *obstacle-board* (enqueue-read-buffer command-queue obstacle-board
                                                      (round (* (/ width pixelsize) (/ height pixelsize)))
                                                      :element-type '(unsigned-byte 32)))
          (setf *forces* (enqueue-read-buffer command-queue forces
                                              (* 4 (boid-count bs))))
          (setf *life* (enqueue-read-buffer command-queue life
                                            (boid-count bs)))
          (setf *retrig* (enqueue-read-buffer command-queue retrig
                                              (* 4 (boid-count bs))
                                              :element-type '(signed-byte 32)))
          (setf *bidx* (enqueue-read-buffer command-queue bidx
                                            (boid-count bs)
                                            :element-type '(signed-byte 32)))
          (setf *colors* (enqueue-read-buffer command-queue color
                                              (* 4 (boid-count bs))))
          (if (> num-obstacles 0)
              (progn
                (setf *obstacles-pos* (enqueue-read-buffer command-queue obstacles-pos
                                                           (* 4 num-obstacles)))
                (setf *obstacles-radius* (enqueue-read-buffer command-queue obstacles-radius
                                                              num-obstacles
                                                              :element-type '(signed-byte 32)))))
          ;; (setf *board-dx* (enqueue-read-buffer command-queue board-dx
          ;;                                      *maxidx*
          ;;                                      :element-type '(signed-byte 32)))
          ;; (setf *board-dy* (enqueue-read-buffer command-queue board-dy
          ;;                                      *maxidx*
          ;;                                      :element-type '(signed-byte 32)))
          ;; (setf *board-dist* (enqueue-read-buffer command-queue dist
          ;;                                         *maxidx*))
          ;; (setf *board-sep* (enqueue-read-buffer command-queue sep
          ;;                                        (* 4 *maxidx*)))
          ;; (setf *board-coh* (enqueue-read-buffer command-queue coh
          ;;                                        (* 4 *maxidx*)))
          (finish command-queue)
          (luftstrom-display::send-to-audio *retrig* *positions* *velocities*)))))

(defmacro obstacle-refcopy (src target)
  `(setf (luftstrom-display::obstacle-ref (luftstrom-display::obstacle ,target))
         (luftstrom-display::obstacle-ref (luftstrom-display::obstacle ,src))))

(defmacro set-mouse-ref (player)
  `(setf luftstrom-display::*mouse-ref* ,player))

(defmacro clear-mouse-ref ()
  `(setf luftstrom-display::*mouse-ref* nil))

(defmacro get-obstacle-ref (player)
  `(luftstrom-display::obstacle-ref (luftstrom-display::obstacle ,player)))

(defun get-mouse-player-ref ()
  luftstrom-display::*mouse-ref*)

(defmethod glut:passive-motion ((window opencl-boids-window) x y)
  (let* ((bs (first (systems window)))
         (mouse-player-ref (get-mouse-player-ref))
         (mouse-obstacle (and mouse-player-ref (luftstrom-display::obstacle mouse-player-ref))))
    (setf (mouse-x window) x)
    (setf (mouse-y window) y)
;;       (format t "~a ~a ~a~%" x y mouse-obstacle)
    (if (and bs mouse-obstacle (luftstrom-display::obstacle-active mouse-obstacle))
        (progn
          (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4 :offset (* +float4-octets+ (luftstrom-display::obstacle-ref
                                                                                                                     mouse-obstacle)) :write t)
            (ocl:with-mapped-buffer (p2 (car (command-queues window)) (obstacles-type bs) 1 :read t)
              (setf (cffi:mem-aref p1 :float 0) (float x 1.0))
              (setf (cffi:mem-aref p1 :float 1) (float (- (glut:height window) y) 1.0))))))))

(defun is-active? (idx)
  (loop for o across *obstacles*
     until (= (luftstrom-display::obstacle-ref o) idx)
     finally (return (luftstrom-display::obstacle-active o))))

;;; (is-active? 0)

;; (update-get-obstacles *win*)

(defun draw-obstacles (window)
  (loop
     for obstacle in (update-get-obstacles window)
     for idx from 0
     if (is-active? idx)
     do (progn
;;          (format t "~a" (first obstacle))
          (case (first obstacle)
            (0 (apply #'no-interact-circle idx (rest obstacle)))
            (1 (apply #'obstacle-circle idx (rest obstacle)))
            (2 (apply #'plucker-circle idx (rest obstacle)))
            (3 (apply #'attractor-circle idx (rest obstacle)))
            (4 (apply #'predator-circle idx (rest obstacle)))))))

;;; (get-mouse-player-ref)

;;; (luftstrom-display::netconnect)
;;;      (luftstrom-display::set-obstacles *obstacles*)

#|

(setf *test* t)
 (format t "~&display~%")
|#


(defun move-obstacle-abs (x y player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player))
                                    :write t)
          (setf (cffi:mem-aref p1 :float 0) (float x 1.0))
          (setf (cffi:mem-aref p1 :float 1) (float (- (glut:height window) y) 1.0))))))


(defun move-obstacle-norm-x (x player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 0) (float (* x *width*) 1.0))))))

(defun move-obstacle-norm-y (y player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 1) (float (* y *height*) 1.0))))))

(defun move-obstacle-rel-y (dy player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 1)
                (float (clip (+ (cffi:mem-aref p1 :float 1) dy) 0 *height*)))))))

(defun move-obstacle-rel-x (dx player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 0)
                (float (clip (+ (cffi:mem-aref p1 :float 0) dx) 0 *width*)))))))

(defun clip (val vmin vmax)
  (min vmax (max val vmin)))
