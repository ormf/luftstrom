;;; 
;;; probe-18-10.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2018 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
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

(in-package :cl-user)

(((3 7)
              (with-exp-midi (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (set-value :maxspeed (* speedf 1.05))
                  (set-value :maxforce (* speedf 0.09)))))
             ((3 70)
              (with-lin-midi (1 8)
                (set-value :sepmult (float (funcall ipfn d2)))))
             ((3 65)
              (with-lin-midi (1 8)
                (set-value :cohmult (float (funcall ipfn d2)))))
             ((3 100)
              (with-lin-midi (1 8)
                (set-value :alignmult (float (funcall ipfn d2)))))
             ((0 4)
              (with-lin-midi (100 2000)
                (set-value :lifemult (float (funcall ipfn d2)))))
             ((0 21)
              (with-exp-midi (0.001 1.0)
                (set-value :bg-amp (float (funcall ipfn d2))))))


(in-package :luftstrom-display)

;;; preset: 17

(progn
  (setf *curr-preset*
        (copy-list
         (append
          '(:boid-params
            (:num-boids 900
             :boids-per-click 100
             :clockinterv 0
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles nil
             :curr-kernel "boids"
             :bg-amp 1
             :maxspeed 0.96417606
             :maxforce 0.08264367
             :maxidx 317
             :length 5
             :sepmult 5.51
             :alignmult 3.97
             :cohmult 749/127
             :predmult 1
             :maxlife 60000.0
             :lifemult 142500/127
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (n-exp y 0.4 1.2)
             :ampfn (+ (m-exp (aref *cc-state* 0 7) 0.1 4) (* (m-exp (aref *cc-state* 3 7) 0.1 4) (sign) (+ 0.1 (random 0.1))))
             :durfn (n-exp y 0.8 0.16)
             :suswidthfn 0.1
             :suspanfn 0.3
             :decay-startfn 0.001
             :decay-endfn 0.02
             :lfo-freqfn (*
                          (expt (round (* 16 y))
                                (n-lin x 1 (n-lin (/ (aref *cc-state* 3 70) 127) 1 1.2)))
                          (m-exp (aref *notes* 0) 100 200))
             :x-posfn x
             :y-posfn y
             :wetfn (m-lin (aref *cc-state* 0 23) 0 1)
             :filt-freqfn (n-exp y 200 10000))
            :midi-cc-fns
            (((3 7)
              (with-exp-midi (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (set-value :maxspeed (* speedf 1.05))
                  (set-value :maxforce (* speedf 0.09)))))
             ((3 70)
              (with-lin-midi (1 8)
                (set-value :sepmult (float (funcall ipfn d2)))))
             ((3 65)
              (with-lin-midi (1 8)
                (set-value :cohmult (float (funcall ipfn d2)))))
             ((3 100)
              (with-lin-midi (1 8)
                (set-value :alignmult (float (funcall ipfn d2)))))
             ((0 4)
              (with-lin-midi (100 2000)
                (set-value :lifemult (float (funcall ipfn d2)))))
             ((0 21)
              (with-exp-midi (0.001 1.0)
                (set-value :bg-amp (float (funcall ipfn d2)))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 17)

(aref)

#|

TODO:

1. Relative Steuerung (up/down/left/right)
2. "Hold" von Werten (Selection which one)
3. "Portamento" zwischen Positionen


|#
