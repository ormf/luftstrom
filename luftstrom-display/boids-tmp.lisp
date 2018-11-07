(in-package :luftstrom-display)

;;; preset: 1

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 50
             :boids-per-click 5
             :clockinterv 2
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles ((4 25))
             :curr-kernel "boids"
             :bg-amp 0.001
             :maxspeed 1.0859671
             :maxforce 0.093082905
             :maxidx 317
             :length 5
             :sepmult 1.496063
             :alignmult 3.480315
             :cohmult 1.2755905
             :predmult 1
             :maxlife 60000.0
             :lifemult 394.6614
             :max-events-per-tick 10)
            :audio-args
            (:default (apr 0)
             :player1 (apr 1))
            :midi-cc-fns
            (,@(cc-preset :nk2 :nk2-std)
             ,@(cc-preset :player1 :obst-ctl1)))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 1)





