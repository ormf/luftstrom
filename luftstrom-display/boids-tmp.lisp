(in-package :luftstrom-display)

;;; preset: 11

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 10
             :boids-per-click 5
             :clockinterv 2
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles ((4 25) (4 25) (4 25) (4 25))
             :curr-kernel "boids"
             :bg-amp 0.001
             :maxspeed 1.0859671
             :maxforce 0.093082905
             :maxidx 317
             :length 5
             :sepmult 2.488189
             :alignmult 5.850394
             :cohmult 2.8740158
             :predmult 1
             :maxlife 60000.0
             :lifemult 0.0
             :max-events-per-tick 10)
            :audio-args
            (:default (apr 0)
             :player1 (apr 1)
             :player2 (apr 2)
             :player3 (apr 3)
             :player4 (apr 4))
            :midi-cc-fns
            (:nk2 :nk2-std
             :player1 :obst-ctl1
             :player2 :obst-ctl1
             :player3 :obst-ctl1
             :player4 :life-ctl1))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 11)

(save-presets)
