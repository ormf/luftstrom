(in-package :luftstrom-display)

;;; preset: 0

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 14
             :boids-per-click 1
             :clockinterv 4
             :speed 2.0
             :obstacles-lookahead 3.0
             :obstacles ((2 25) (2 25) (2 25) (0 25))
             :curr-kernel "boids"
             :bg-amp 0.001
             :maxspeed 0.63136166
             :maxforce 0.05411672
             :maxidx 317
             :length 5
             :sepmult 3.535433
             :alignmult 3.1496062
             :cohmult 2.5984251
             :predmult 10
             :maxlife 60000.0
             :lifemult 0.0
             :max-events-per-tick 10)
            :audio-args
            (:default (apr 0)
             :player4 (apr 0))
            :midi-cc-fns
            (:nk2 :nk2-std
             :player1 :obst-ctl1
             :player2 :obst-ctl1
             :player3 :obst-ctl1
             :player4 :life-ctl1
             (:nk2 20) (with-exp-midi-fn (5 250)
                         (setf *length* (round (funcall ipfn d2))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 0)

(save-presets)
