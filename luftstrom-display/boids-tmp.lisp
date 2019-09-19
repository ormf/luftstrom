(in-package :luftstrom-display)

;;; preset: 0

(progn
  (setf *curr-preset*
        `(:boid-params
          (:num-boids 1
           :boids-per-click 1
           :trig t
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 3.0
           :obstacles ((2 25) (2 25) (2 25) (0 25))
           :curr-kernel "boids"
           :bg-amp 0.001
           :maxspeed 0.105
           :maxforce 0.009000001
           :maxidx 317
           :length 5
           :sepmult 4.913386
           :alignmult 6.7322836
           :cohmult 1.0
           :predmult 10
           :maxlife 60000.0
           :lifemult 11.811024
           :max-events-per-tick 10)
          :audio-args
          (:default (apr 94)
                    )
          :midi-cc-fns
          (:nk2 #'nk2-std-noreset
           :player1 #'obst-ctl1)
          :midi-note-fns
          (:arturia #'boid-num-ctl
           :player3 #'boid-state-save)
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 0)

(save-presets)
