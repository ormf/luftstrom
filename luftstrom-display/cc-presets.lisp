;;; 
;;; cc-presets.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2019 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
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

(in-package :luftstrom-display)

(defparameter *cc-presets* (make-hash-table))

;;; a cc-preset contains bindings for the *cc-fns* array. It is a list
;;; of key/value pairs, the keys being an index pair for a location in
;;; *cc-fns* and the value being a function of one argument, to be
;;; stored at this location. The actual storage is executed with the
;;; function #'digest-midi-cc-fns. The functions serve as callback
;;; functions to be called, when a cc-value is received from any of
;;; the attached midi controllers. Most of the functions in this file
;;; basically return the templates of the lists in their bodies using
;;; the midi-channel as arg to be filled into the pairs at the
;;; appropiate places.


(defmacro with-cc-def-bound ((fn reset) cc-def &rest body)
  "cc-def either is a function or a list with a function as first
element and the second argument determining, whether the cc-def should
get exectued on definition with the old cc-value stored in the
preset. If cc-def is just a function, reset defaults to t."
  `(if (functionp ,cc-def)
       (let ((,fn ,cc-def)
             (,reset t))
         ,@body)
       (let ((,fn (first ,cc-def))
             (,reset (second ,cc-def)))
         ,@body)))

(defun init-cc-presets ())

#|
(defun nk-std-noreset-nolength (player)
  `((,player 8)
    (,(with-exp-midi-fn (0.1 20)
             (let ((speed (float (funcall ipfn d2))))
               (bp-set-value :speed speed)))
      t)
    (,player 9)
    (,(with-lin-midi-fn (1 8)
        (bp-set-value :sepmult (float (funcall ipfn d2))))
      t)
    (,player 10)
    (,(with-lin-midi-fn (1 8)
        (bp-set-value :cohmult (float (funcall ipfn d2))))
      t)
    (,player 11)
    (,(with-lin-midi-fn (1 8)
        (bp-set-value :alignmult (float (funcall ipfn d2))))
      t)
    (,player 12)
    (,(with-exp-midi-fn (1 500)
        (bp-set-value :boids-per-click (round (funcall ipfn d2))))
      t)
    (,player 13)
    (,(with-lin-midi-fn (0 500)
        (bp-set-value :lifemult (float (funcall ipfn d2))))
      t)
    (,player 14)
    (,(with-lin-midi-fn (0 50)
        (bp-set-value :clockinterv (round (funcall ipfn d2))))
      t)))


|#

(defun set-nk2-std ()
  (set-ref (aref (cuda-gui::param-boxes (find-gui :nk2)) 7)
           (cl-boids-gpu::len *bp*)
           :map-fn (m-lin-fn 5 250)
           :rmap-fn (m-lin-rev-fn 5 250))

  (set-ref (aref (cuda-gui::param-boxes (find-gui :nk2)) 8)
           (cl-boids-gpu::bp-speed *bp*)
           :map-fn (m-exp-fn 0.1 20)
           :rmap-fn (m-exp-rev-fn 0.1 20))

  (set-ref (aref (cuda-gui::param-boxes (find-gui :nk2)) 9)
           (cl-boids-gpu::sepmult *bp*)
           :map-fn (m-lin-fn 1 8)
           :rmap-fn (m-lin-rev-fn 1 8))

  (set-ref (aref (cuda-gui::param-boxes (find-gui :nk2)) 10)
           (cl-boids-gpu::cohmult *bp*)
           :map-fn (m-lin-fn 1 8)
           :rmap-fn (m-lin-rev-fn 1 8))

  (set-ref (aref (cuda-gui::param-boxes (find-gui :nk2)) 11)
           (cl-boids-gpu::alignmult *bp*)
           :map-fn (m-lin-fn 1 8)
           :rmap-fn (m-lin-rev-fn 1 8))

  (set-ref (aref (cuda-gui::param-boxes (find-gui :nk2)) 12)
           (cl-boids-gpu::boids-per-click *bp*)
           :map-fn (m-lin-rd-fn 1 500)
           :rmap-fn (m-lin-rd-rev-fn 1 500))

  (set-ref (aref (cuda-gui::param-boxes (find-gui :nk2)) 13)
           (cl-boids-gpu::lifemult *bp*)
           :map-fn (m-lin-fn 0 500)
           :rmap-fn (m-lin-rev-fn 0 500))

  (set-ref (aref (cuda-gui::param-boxes (find-gui :nk2)) 14)
           (cl-boids-gpu::clockinterv *bp*)
           :map-fn (m-lin-rd-fn 0 50)
           :rmap-fn (m-lin-rd-rev-fn 0 500)))


(defun nk2-std ())
