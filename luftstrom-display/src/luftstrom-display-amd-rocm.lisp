;;; 
;;; luftstrom-display-amd-rocm.lisp
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

(defun get-all-gpu-data (bs)
  (progn
    (setf bs-positions (get-gl-data (gl-coords bs) 16 (boid-count bs)))
    (setf bs-velocities (get-gl-data (gl-vel bs) 4 (boid-count bs)))
    (setf bs-life (get-gl-data (gl-life bs) 1 (boid-count bs)))
    (setf bs-retrig (get-gl-data (gl-retrig bs) 4 (boid-count bs) :element-type '(signed-byte 32)))))

(defun reshuffle-life (win &key (regular nil))
  (let* ((bs (first (systems win)))
         (count (boid-count bs)))
    (with-slots (gl-life boid-count) bs
      (with-bound-mapped-buffer
          (p-life :array-buffer :write-only) gl-life
          (loop
            for k below count
            do (setf (cffi:mem-aref p-life :float k)
                     (float
                      (if regular
                          (max 0.01 (* (val (maxlife *bp*)) (/ k count)))
                          (max 0.01 (* (random 1.0) (val (maxlife *bp*)))))
                      1.0)))))))

(defun add-to-boid-system (origin count win
                           &key (maxcount *boids-maxcount*) (length (val (len *bp*)))
                             (trig *trig*))
  (let* ((bs (first (systems win)))
         (boid-count (boid-count bs))
         (origin (list (first origin) (+ (gl-height win) (second origin))))
;;;         (vertex-size 2) ;;; size of boid-coords
         )
;;;    (break "origin: ~a" origin)
    (setf count (min count (- maxcount boid-count)))
    (with-slots (gl-coords gl-vel gl-life gl-retrig) bs
      (unless (or (zerop gl-coords) (zerop count))
        (let ((angles (loop repeat count collect (float (random +twopi+) 1.0))))
;;;          (break "gl-coords: ~a" gl-coords)
          (with-model-slots (num-boids lifemult speed maxlife) *bp*
            (let ((maxspeed (speed->maxspeed speed)))
              (with-bound-mapped-buffer
                  (p-coords :array-buffer :write-only) gl-coords
                  (loop repeat count
                        for i from (* 16 boid-count) by 16
                        for angle in angles
                        do (let ((color (if (zerop i) *first-boid-color* *fg-color*)))
                             (apply #'set-array-vals p-coords (+ i 0) origin)
                             (apply #'set-array-vals p-coords (+ i 4) color)
                             (apply #'set-array-vals p-coords (+ i 8)
                                    (mapcar #'+ origin
                                            (list (* -1 length (sin angle))
                                                  (* -1 length (cos angle)) 0.0 1.0)))
                             (apply #'set-array-vals p-coords (+ i 12) color))))
              (with-bound-mapped-buffer
                  (p-vel :array-buffer :write-only) gl-vel
                  (loop repeat count
                        for j from (* 4 boid-count) by 4
                        for angle in angles
                        for v = (float (+ 0.1 (random 0.8)) 1.0) ;; 1.0
                        do (set-array-vals p-vel j
                                           (float (* v maxspeed (sin angle)))
                                           (float (* v maxspeed (cos angle))) 0.0 0.0)))
              (with-bound-mapped-buffer
                  (p-life :array-buffer :write-only) gl-life
                  (loop repeat count
                        for k from boid-count
                        do (setf (cffi:mem-aref p-life :float k)
                                 (float (if trig ;;; do we trigger on creation of a boid?
                                            (max 0.01 (* (random (max 0.01 (float lifemult))) (* count 0.12)))
                                            (max 0.01 (* (+ 0.7 (random 0.2)) maxlife))
                                            )
                                        1.0))))
              (with-bound-mapped-buffer
                  (p-retrig :array-buffer :write-only) gl-retrig
                  (loop repeat count
                        for k from (* 4 boid-count) by 4
                        do (setf (cffi:mem-aref p-retrig :int k) 0) ;;; retrig
                           (setf (cffi:mem-aref p-retrig :int (+ k 1)) -1) ;;; obstacle-idx for next trig
                           (setf (cffi:mem-aref p-retrig :int (+ k 2)) (if trig 0 20)) ;;; frames since last trig
                           (setf (cffi:mem-aref p-retrig :int (+ k 3)) 0)))
;;; time since last obstacle-induced trigger
              (incf (boid-count bs) count)
              (setf num-boids (boid-count bs))
              (luftstrom-display::bp-set-value :num-boids num-boids)
              )))))
    bs))

(defun vector->vbo (vector vbo &key (element-type :float))
  (gl:bind-buffer :array-buffer vbo)
  (gl:with-mapped-buffer (p :array-buffer :read-write)
    (copy-vector vector p element-type))
  (gl:bind-buffer :array-buffer 0))

(defun restore-bs-from-preset (idx)
  (let* ((bs *bs*))
;;;    (break "gl-coords: ~a" gl-coords)
;;;    (break "bs: ~a" (boid-coords-buffer bs))
      (with-slots (gl-coords gl-vel gl-life gl-retrig) bs
        (unless (or (zerop gl-coords) (unbound (elt luftstrom-display::*bs-presets* idx)))
        (with-slots (bs-num-boids bs-positions bs-velocities bs-life bs-retrig)
            (elt luftstrom-display::*bs-presets* idx)
          (vector->vbo bs-positions gl-coords)
          (vector->vbo bs-velocities gl-vel)
          (vector->vbo bs-life gl-life)
          (vector->vbo bs-retrig gl-retrig :element-type :int)
          (setf (boid-count bs) bs-num-boids))))))
