;;;; luftstrom-display.lisp

(in-package #:cl-boids-gpu)

;;; (boids :width 1200 :height 900)
;;(incudine:rt-stop)

(setf *print-case* :downcase)

(setf *lifemult* 1000.0)
(setf *lifemult* 1.0)


(defun %update-system (window bs)
  (let ((command-queue (car *command-queues*))
        (pixelsize (pixelsize bs))
        (width (glut:width window))
        (height (glut:height window))
        (pos (boid-coords-buffer bs))
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
        (obstacles-boardoffs-maxidx (obstacles-boardoffs-maxidx bs))
        (num-obstacles (num-obstacles bs))
        (dist (board-dist bs))
        (cb-kernel (clear-board-kernel window))
        (cw-kernel (calc-weight-kernel window))
        (kernel (find-kernel *curr-kernel*))
        (count (boid-count bs)))
    (set-kernel-args cb-kernel (weight-board align-board obstacle-board obstacles-pos obstacles-radius
                                             (num-obstacles :int)(*obstacles-lookahead* :float)
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

    (set-kernel-args kernel
                     (pos vel forces bidx life retrig color weight-board align-board
                          board-dx board-dy dist coh sep obstacle-board obstacles-pos obstacles-radius obstacles-type
                          obstacles-boardoffs-maxidx
                          ((round num-obstacles) :int)
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

    (Setf *boid-count* (boid-count bs))
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
                                        (boid-count bs)
                                        :element-type '(signed-byte 32)))
    (setf *bidx* (enqueue-read-buffer command-queue bidx
                                      (boid-count bs)
                                      :element-type '(signed-byte 32)))
    (setf *colors* (enqueue-read-buffer command-queue color
                                   (* 4 (boid-count bs))))
    (setf *obstacles-pos* (enqueue-read-buffer command-queue obstacles-pos
                                               (* 4 num-obstacles)))
    (setf *obstacles-radius* (enqueue-read-buffer command-queue obstacles-radius
                                                  num-obstacles
                                                  :element-type '(signed-byte 32)))
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
    (luftstrom-display::send-to-audio *retrig* *positions* *velocities*)))



;;; (luftstrom-display::netconnect)


#|
 (format t "~&display~%")
|#
