(in-package :luftstrom-display)

;;; preset: 0

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 0
             :boids-per-click 1
             :trig t
             :clockinterv 4
             :speed 2.0
             :obstacles-lookahead 3.0
             :obstacles ((2 25) (2 25) (2 25) (0 25))
             :curr-kernel "boids"
             :bg-amp 0.001
             :maxspeed 0.105
             :maxforce 0.009000001
             :maxidx 317
             :length 5
             :sepmult 1.0
             :alignmult 1.0
             :cohmult 1.0
             :predmult 10
             :maxlife 60000.0
             :lifemult 0.0
             :max-events-per-tick 10)
            :audio-args
            (:default (apr 94)
                      )
            :midi-cc-fns
            (:nk2 :nk2-std
             :player1 :obst-ctl1
             :player2 :obst-ctl1
             :player3 :obst-ctl1
             :player4 :life-ctl3))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 0)

(save-presets)
