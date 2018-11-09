(in-package :luftstrom-display)

;;; preset: 16

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 50
             :boids-per-click 100
             :clockinterv 0
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles (nil (0 10) (1 10) (0 10))
             :curr-kernel "boids"
             :bg-amp (m-exp (aref *cc-state* 4 21) 0.001 1)
             :maxspeed 2.955677
             :maxforce 0.25334376
             :maxidx 317
             :length 5
             :sepmult 5.5748034
             :alignmult 2.8188977
             :cohmult 1.2755905
             :predmult 1
             :maxlife 60000.0
             :lifemult 0.0
             :max-events-per-tick 10)
            :audio-args
            (:default (apr 16)
             :player1 (apr 16))
            :midi-cc-fns
            (:nk2 :nk2-std
             :player1 :obst-ctl1
             :player2 :obst-ctl1
             :player3 :obst-ctl1
             :player4 :obst-ctl1
             (:nk2 20) (with-exp-midi-fn (5 250)
                         (setf *length* (round (funcall ipfn d2))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 16)
