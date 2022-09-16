;;; 
;;; luftstrom-display-intel-beignet.lisp
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

(in-package #:cl-boids-gpu)

(defun get-all-gpu-data (bs command-queue state)
  (with-slots (bs-num-boids bs-positions bs-velocities bs-life bs-retrig bs-color bs-obstacles)
      state
;;; *obstacles* (ou:ucopy *obstacles*)
    (with-slots (count boid-coords-buffer velocity-buffer life-buffer retrig-buffer) bs
      (setf bs-num-boids count)
      ;;    (setf *positions* (boid-coords-buffer bs))
      (setf bs-positions (if (and (> (val (num-boids *bp*)) 0)
                                  (> count 0))
                             (enqueue-read-buffer command-queue boid-coords-buffer
                                                  (* 16 count))))
      (setf bs-velocities (if (and (> (val (num-boids *bp*)) 0)
                                   (> count 0))
                              (enqueue-read-buffer command-queue velocity-buffer
                                                   (* 4 count))))
      (setf bs-life (if (and (> (val (num-boids *bp*)) 0)
                             (> count 0))
                        (enqueue-read-buffer command-queue life-buffer
                                             count)))

      (setf bs-retrig (if (and (> (val (num-boids *bp*)) 0)
                               (> count 0))
                          (enqueue-read-buffer command-queue retrig-buffer
                                               (* 4 count)
                                               :element-type '(signed-byte 32))))
      (setf bs-obstacles *obstacles*)
      (finish command-queue))))

(defun reshuffle-life (win &key (regular nil))
  (let* ((bs (first (systems win)))
         (command-queue (first (command-queues win)))
         (life-buffer (life-buffer bs))
         (count (boid-count bs)))
    (ocl:with-mapped-buffer (p3 command-queue life-buffer count :write t)
      (loop
        for k below count
        do (setf (cffi:mem-aref p3 :float k)
                 (float
                  (if regular
                      (max 0.01 (* (val (maxlife *bp*)) (/ k count)))
                      (max 0.01 (* (random 1.0) (val (maxlife *bp*)))))
                  1.0))))))

(defun add-to-boid-system (origin count win
                           &key (maxcount *boids-maxcount*) (length (val (len *bp*)))
                             (trig *trig*))
  (let* ((bs (first (systems win)))
         (vbo (gl-coords bs))
         (vel (velocity-buffer bs))
         (life-buffer (life-buffer bs))
         (retrig-buffer (retrig-buffer bs))
         (boid-count (boid-count bs))
         (vertex-size 2)  ;;; size of boid-coords
         (command-queue (first (command-queues win))))
    (setf count (min count (- maxcount (boid-count bs))))
;;;    (break "vbo: ~a" vbo)
    (unless (or (zerop vbo) (zerop count))
      (with-model-slots (num-boids lifemult speed maxlife) *bp*
        (let ((maxspeed (speed->maxspeed speed)))
          (gl:bind-buffer :array-buffer vbo)
          (gl:with-mapped-buffer (p1 :array-buffer :read-write)
            (ocl:with-mapped-buffer (p2 command-queue vel (* 4 (+ boid-count count)) :write t)
              (ocl:with-mapped-buffer (p3 command-queue life-buffer (+ boid-count count) :write t)
                (ocl:with-mapped-buffer (p4 command-queue retrig-buffer (+ boid-count count) :write t)
;;;                  (break "origin: ~a~%" origin)
                  (loop repeat count
                        for i from (* 4 (* 2 vertex-size) boid-count) by (* 4 (* 2 vertex-size))
                        for j from (* 4 boid-count) by 4
                        for k from boid-count
                        for a = (float (random +twopi+) 1.0)
                        for v = (float (+ 0.1 (random 0.8)) 1.0) ;; 1.0
                        do (let ()
                             (set-array-vals p2 j (float (* v maxspeed (sin a))) (float (* v maxspeed (cos a))) 0.0 0.0)
                             (apply #'set-array-vals p1 (+ i 0) origin)
                             (apply #'set-array-vals p1 (+ i 8) origin)
                             (let ((color (if (zerop i) *first-boid-color* *fg-color*)))
                               (apply #'set-array-vals p1 (+ i 4) color)
                               (apply #'set-array-vals p1 (+ i 12) color))
                             (setf (cffi:mem-aref p3 :float k)
                                   (float (if trig ;;; do we trigger on creation of a boid?
                                              (max 0.01 (* (random (max 0.01 (float lifemult))) (* count 0.12)))
                                              (max 0.01 (* (+ 0.7 (random 0.2)) maxlife))
                                              )
                                          1.0))
                             (setf (cffi:mem-aref p4 :int (* k 4)) 0) ;;; retrig
                             (setf (cffi:mem-aref p4 :int (+ (* k 4) 1)) -1) ;;; obstacle-idx for next trig
                             (setf (cffi:mem-aref p4 :int (+ (* k 4) 2))
                                   (if trig 0 20)) ;;; frames since last trig
                             (setf (cffi:mem-aref p4 :int (+ (* k 4) 3)) 0) ;;; time since last obstacle-induced trigger
                             ))))))
          (incf (boid-count bs) count)
          (setf num-boids (boid-count bs))
          (luftstrom-display::bp-set-value :num-boids num-boids))))
    bs))

(defun restore-bs-from-preset (idx)
  (let* (;;; (bs (first (systems win)))
         (win *win*)
         (bs *bs*)
         (vbo (gl-coords bs))
         (vel (velocity-buffer bs))
         (life-buffer (life-buffer bs))
         (retrig-buffer (retrig-buffer bs))
         (command-queue (first (command-queues win))))
;;;    (break "vbo: ~a" vbo)
    (unless (or (zerop vbo) (unbound (elt luftstrom-display::*bs-presets* idx)))
      (with-slots (bs-num-boids bs-positions bs-velocities bs-life bs-retrig)
          (elt luftstrom-display::*bs-presets* idx)
        (gl:bind-buffer :array-buffer vbo)
        (gl:with-mapped-buffer (p-pos :array-buffer :read-write)
          (copy-vector bs-positions p-pos))
        (ocl:enqueue-write-buffer command-queue vel bs-velocities)
        (ocl:enqueue-write-buffer command-queue life-buffer bs-life)
        (ocl:enqueue-write-buffer command-queue retrig-buffer bs-retrig)
        (finish command-queue)
        (setf (boid-count bs) bs-num-boids)))))
