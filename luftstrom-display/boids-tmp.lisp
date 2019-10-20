(in-package :luftstrom-display)

;;; preset: 0

(progn
  (setf *curr-preset*
        `(:boid-params
          (:num-boids 100
           :boids-per-click 10
           :trig t
           :clockinterv 2
           :speed 2.0
           :obstacles-lookahead 4.0
           :obstacles ((2 25) (2 25) (2 25) (0 25))
           :curr-kernel "boids"
           :bg-amp 1
           :maxspeed 9.910351
           :maxforce 0.8494587
           :maxidx 317
           :length 5
           :sepmult 2
           :alignmult 1
           :cohmult 1
           :predmult 10
           :maxlife 60000.0
           :lifemult 500.0
           :max-events-per-tick 10)
          :audio-args
          (:default (apr 99)
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
