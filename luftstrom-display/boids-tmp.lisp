(in-package :luftstrom-display)

;;; preset: 5

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 100
             :boids-per-click 100
             :trig nil
             :clockinterv 0
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles ((4 25) (4 25) (4 25) (4 25))
             :curr-kernel "boids"
             :bg-amp 0.001
             :maxidx 317
             :length 5
             :predmult 1
             :maxlife 60000.0
             :lifemult 381.88977
             :max-events-per-tick 10)
            :audio-args
            (:default (apr 17)
             :player1 (apr 37)
             :player2 (apr 37)
             :player3 (apr 37))
            :midi-cc-fns
            (:nk2 :nk2-std2-noreset
             :player1 :obst-ctl1
             :player2 :obst-ctl1
             :player3 :obst-ctl1
             :player4 :boid-ctl1-noreset))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 5)

(save-presets)
