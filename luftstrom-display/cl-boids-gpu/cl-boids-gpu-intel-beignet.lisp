;;; 
;;; cl-boids-gpu-intel-beignet.lisp
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

(defun make-boid-system (origin count win &key (maxcount *boids-maxcount*)
                                            (maxobstacles *max-obstacles*)
                                            (pixelsize *pixelsize*)
                                            (trig *trig*))
  (declare (ignore win))
  (format t "~&making, origin: ~a~%" origin)
  (let* ((max-offs-size (length *board-offsets*))
         (vbo (gl:gen-buffer)) ;;; create the Vertex Buffer Object (once)
         (vertex-size 2)                ;;; size of one boid-coord (pos color)
         ;; 4 single-floats per boid for velocity, 
         (vel (create-buffer *context* (* +float4-octets+ maxcount) :read-write)) ;;; local buffer for velocities
         (life-buffer (create-buffer *context* (* 4 maxcount) :read-write)) ;;; local buffer for life
         (retrig-buffer (create-buffer *context* (* 16 maxcount) :read-write)) ;;; local buffer for retrigger, time since last trig, obst-idx, dummy
         (force-buffer (create-buffer *context* (* +float4-octets+ maxcount) :read-write))
         (bidx-buffer (create-buffer *context* (* 4 maxcount) :read-write))
         (obstacles-pos-buffer (create-buffer *context* (* +float4-octets+ maxobstacles) :read-write))
         (obstacle-target-posns (make-array maxobstacles :element-type 'obstacle-targets
                                          :initial-contents (loop for i below maxobstacles collect (make-obstacle-targets))))
         (obstacles-radius-buffer (create-buffer *context* (* 4 maxobstacles) :read-write))
         (obstacles-lookahead-buffer (create-buffer *context* (* 4 maxobstacles) :read-write))
         (obstacles-multiplier-buffer (create-buffer *context* (* 4 maxobstacles) :read-write))
         (obstacles-type-buffer (create-buffer *context* (* 4 maxobstacles) :read-write))
         (obstacles-boardoffs-maxidx-buffer (create-buffer *context* (* 4 maxobstacles) :read-write)) 
         (color-buffer (create-buffer *context* (* +float4-octets+ maxcount) :read-write))
         (weight-board (create-buffer *context* (round (+ 0.5
                                                          (* 4 (/ *gl-width* pixelsize)
                                                             (/ *gl-height* pixelsize)))) :read-write))
         (align-board (create-buffer
                       *context*
                       (round (+ 0.5
                                 (* +float4-octets+ (/ *gl-width* pixelsize)
                                    (/ *gl-height* pixelsize)))) :read-write))
         (board-dx (create-buffer *context* (* 4 max-offs-size) :read-only))
         (board-dy (create-buffer *context* (* 4 max-offs-size) :read-only))
         (board-dist (create-buffer *context* (* 4 max-offs-size) :read-only))
         (board-sep (create-buffer *context* (* +float4-octets+ max-offs-size) :read-only))
         (board-coh (create-buffer *context* (* +float4-octets+ max-offs-size) :read-only))
         (obstacle-board-buffer (create-buffer *context* (round (* 4 (/ *gl-width* pixelsize)
                                                                   (/ *gl-height* pixelsize))) :read-write)) 
         (bs (make-instance 'boid-system :gl-coords vbo :count count
                                         :velocity-buffer vel
                                         :life-buffer life-buffer
                                         :retrig-buffer retrig-buffer
                                         :force-buffer force-buffer
                                         :obstacle-target-posns obstacle-target-posns
                                         :obstacle-board obstacle-board-buffer
                                         :obstacles-pos obstacles-pos-buffer
                                         :obstacles-radius obstacles-radius-buffer
                                         :obstacles-lookahead obstacles-lookahead-buffer
                                         :obstacles-multiplier obstacles-multiplier-buffer
                                         :obstacles-boardoffs-maxidx obstacles-boardoffs-maxidx-buffer
                                         :obstacles-type obstacles-type-buffer
                                         :maxobstacles maxobstacles
                                         :bidx-buffer bidx-buffer :color-buffer color-buffer
                                         :weight-board weight-board :align-board align-board
                                         :board-dx board-dx :board-dy board-dy :board-dist board-dist :board-sep board-sep
                                         :board-coh board-coh :pixelsize pixelsize :x (first origin) :y (second origin) :z (third origin))))
    (unless (zerop vbo)
      (with-model-slots (speed lifemult maxlife) *bp*
        (let ((maxspeed (* 1.05 speed)))
          (gl:bind-buffer :array-buffer vbo)
          (%gl:buffer-data :array-buffer (* 2 vertex-size +float4-octets+ maxcount) (cffi:null-pointer) ;;; specify buffer size; as we store the coords of start and end points for each boid, we multiply the vertex size by 2
                           :dynamic-draw)
          (gl:with-mapped-buffer (p :array-buffer :read-write)
            (setf (boid-coords-buffer bs)
                  (%cl:create-buffer
                   *context*
                   '(:write-only :use-host-ptr)
                   (* 2 vertex-size +float4-octets+ maxcount)
                   p
                   (cffi:null-pointer)))
            (unless (zerop count)
              (progn
                (loop repeat count
                      for i from 0 by (* 4 (* 2 vertex-size))
                      do (let ((color (if (zerop i) *first-boid-color* *fg-color*)))
                           (apply #'set-array-vals p (+ i 0) origin)
                           (apply #'set-array-vals p (+ i 8) origin)
                           (apply #'set-array-vals p (+ i 4) color)
                           (apply #'set-array-vals p (+ i 12) color))))
              (ocl:with-mapped-buffer (p (car *command-queues*) vel (* 4 count) :write t)
                (loop repeat count
                      for i from 0 by 4
                      for a = (float (random +twopi+) 1.0)
                      for v = (float (+ 0.1 (random 0.1)) 1.0) ;; 1.0
                      do (set-array-vals p i (* v maxspeed (sin a))(* v maxspeed (cos a)) 0.0 0.0)))
              (ocl:with-mapped-buffer (p (car *command-queues*) life-buffer count :write t)
                (dotimes (i count) (setf (cffi:mem-aref p :float i) (float (if trig
                                                                               (max 0.01 (* (random (float (max 0.01 lifemult))) 8))
                                                                               (max 0.01 (* (+ 0.7 (random 0.2)) maxlife)))
                                                                           1.0))))
              (ocl:with-mapped-buffer (p (car *command-queues*) retrig-buffer (* 4 count) :write t)
                (dotimes (i count) (progn
                                     (setf (cffi:mem-aref p :int i) 0)
                                     (setf (cffi:mem-aref p :int (+ i 1)) -2) ;;; set next trigger-type to no obstacle
                                     (setf (cffi:mem-aref p :int (+ i 2)) 0)
                                     (setf (cffi:mem-aref p :int (+ i 3)) 0))))
              ;;        (new-obstacle win 100 300 20 :bs bs)
              ;;        (new-predator win 100 300 20 :bs bs)
;;; board-offset initialization: write dx,dy,distance,sep and coh vectors 
              (ocl:with-mapped-buffer (dx (car *command-queues*) board-dx max-offs-size :write t)
                (ocl:with-mapped-buffer (dy (car *command-queues*) board-dy max-offs-size :write t)
                  (ocl:with-mapped-buffer (d (car *command-queues*) board-dist max-offs-size :write t)
                    (ocl:with-mapped-buffer (sep (car *command-queues*) board-sep (* 4 max-offs-size) :write t)
                      (ocl:with-mapped-buffer (coh (car *command-queues*) board-coh (* 4  max-offs-size) :write t)
                        (ocl:with-mapped-buffer (obst (car *command-queues*) obstacle-board-buffer max-offs-size :write t)
                          (loop
                            for i from 0 for j from 0 by 4 for elem in *board-offsets*
                            for vcoh = (getf elem :coh-vec) for dist = (getf elem :dist) for vsep = (getf elem :sep-vec)
                            do (progn
                                 ;;                            (format t "~&~a ~a ~a ~a~%" vcoh vsep (getf elem :dx) (getf elem :dy))
                                 (setf (cffi:mem-aref dx :int i) (getf elem :dx)
                                       (cffi:mem-aref dy :int i) (getf elem :dy)
                                       (cffi:mem-aref d :float i) (getf elem :dist)
                                       (cffi:mem-aref obst :int i) 0)
                                 (apply #'set-array-vals sep j vsep)
                                 (apply #'set-array-vals coh j vcoh))))))))))))))
    bs))

(defun add-to-boid-system (origin count win &key (maxcount *boids-maxcount*) (length 5))
  (format t "~&adding, origin: ~a" origin)
  (let* ((bs (first (systems win)))
         (coords (gl-coords bs))
         (vel (velocity-buffer bs))
         (life-buffer (life-buffer bs))
         (retrig-buffer (retrig-buffer bs))
         (boid-count (boid-count bs))
         (vertex-size 2)  ;;; size of boid-coords
         (command-queue (first (command-queues win))))
    (setf count (min count (- maxcount (boid-count bs))))
;;;    (break "coords: ~a" gl-coords)
    (unless (or (zerop gl-coords) (zerop count))
      (with-model-slots (num-boids maxspeed lifemult) *bp*
        (with-bound-buffer (:array-buffer gl-coords)
           (gl:with-mapped-buffer (p1 :array-buffer :read-write)
             (ocl:with-mapped-svm-buffer (command-queue vel (* 4 (+ boid-count count)) :write t)
               (ocl:with-mapped-svm-buffer (command-queue life-buffer (+ boid-count count) :write t)
                 (ocl:with-mapped-svm-buffer (command-queue retrig-buffer (+ boid-count count) :write t)
                   (loop repeat count
                         for i from (* 4 (* 2 vertex-size) boid-count) by (* 4 (* 2 vertex-size))
                         for j from (* 4 boid-count) by 4
                         for k from boid-count
                         for a = (float (random +twopi+) 1.0)
                         for v = (float (+ 0.1 (random 0.8)) 1.0) ;; 1.0
                         do (let ()
                              (set-array-vals vel j (* v maxspeed (sin a)) (* v maxspeed (cos a)) 0.0 0.0)
                              (apply #'set-array-vals p1 (+ i 0) origin)
                              (apply #'set-array-vals p1 (+ i 8) (mapcar #'+ origin
                                                                         (list (* -1 length (sin a))
                                                                               (* -1 length (cos a)) 0.0 1.0)))
                              (let ((color (if (zerop i) *first-boid-color* *fg-color*)))
                                (apply #'set-array-vals p1 (+ i 4) color)
                                (apply #'set-array-vals p1 (+ i 12) color))
                              (setf (cffi:mem-aref life-buffer :float k) (float (* 6 lifemult) 1.0))
                              (setf (cffi:mem-aref retrig-buffer :int (* k 4)) 0) ;;; retrig
                              (setf (cffi:mem-aref retrig-buffer :int (+ (* k 4) 1)) 0) ;;; frames since last trig
                              (setf (cffi:mem-aref retrig-buffer :int (+ (* k 4) 2)) -2) ;;; obstacle-idx for next trig
                              (setf (cffi:mem-aref retrig-buffer :int (+ (* k 4) 3)) 0) ;;; unused
                              )))))))
        (incf (boid-count bs) count)
        (setf num-boids (boid-count bs))))
    bs))

(defun add-to-boid-system (origin count win &key (maxcount *boids-maxcount*) (length 5))
  (declare (ignore origin count win)))
