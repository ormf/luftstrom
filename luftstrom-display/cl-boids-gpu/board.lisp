;;;; board.lisp
;;;;
;;;; Copyright (c) 2017 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
;;;; boid system using OpenCL and OpenGL

(in-package :cl-boids-gpu)

;;; calculate the indexes (dx and dy) relative to a current
;;; board-position within a radius of 100 px, the coh-vector and
;;; sep-vector amount and the distance. The coh-vec value is scaled by
;;; distance, the sep-vector by the square of the distance. The data
;;; is sorted by distance (closest first). *board-offsets* are used by
;;; #'get-board-offs-maxidx to determine the maximum index into the
;;; *board-offets* seq for a given radius. The different properties
;;; are each put into mapped read-only buffers (board_dx, board_dy,
;;; board_coh, board_sep, board_dist) on the gpu to be used by the
;;; parallelized routines on it.

(defparameter *board-offsets*
  (let ((pixelsize 5)
        (dist 100)
        (sep-dist 25))
    (sort
     (loop
        for dx from (* -1 (/ dist pixelsize)) to (/ dist pixelsize)
        append (loop
                  for dy from (* -1 (/ dist pixelsize)) to (/ dist pixelsize)
                  append (let ((distanz (* pixelsize (sqrt (+ (* dx dx) (* dy dy))))))
                           (if (<= distanz dist)
                               (list
                                (list :dist distanz
                                      :dx dx :dy dy
                                      :coh-vec (list
                                                (float (* dx pixelsize) 1.0)
                                                (float (* dy pixelsize) 1.0)
                                                0.0
                                                0.0)
                                      :sep-vec (if (or (zerop dx)
                                                       (> distanz sep-dist))
                                                   (list 0.0 0.0 0.0 0.0)
                                                   (list
                                                    (float (* -1 dx pixelsize (/ (* distanz distanz))) 1.0)
                                                    (float (* -1 dy pixelsize (/ (* distanz distanz))) 1.0)
                                                    0.0
                                                    0.0))))))))
     #'<
     :key (lambda (x) (getf x :dist)))))

(defun get-board-offs-maxidx (maxdist)
  (loop
     for count from 0
     for x in *board-offsets*
     while (<= (getf x :dist) maxdist)
     finally (return count)))

;;; (get-board-offs-maxidx 50)

#|
(length *board-offsets*)

maxidx
board-offs-x
board-offs-y
board-offs-dist
board-offs-coh-vec
board-offs-sep-vec
|#
