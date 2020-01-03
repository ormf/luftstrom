(in-package :luftstrom-display)

;;; preset: 0

(progn
  (setf *curr-preset*
        `(:boid-params
          (:num-boids 0
           :boids-per-click 1
           :trig t
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 4.0
           :obstacles ((2 25) (2 25) (2 25) (0 25))
           :curr-kernel "boids"
           :bg-amp 1
           :maxspeed 8.044468
           :maxforce 0.6895259
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
          (:default (apr 99)
                    )
          :midi-cc-fns
          (:nk2 #'nk2-std)
          :midi-note-fns
          (:player3 #'boid-state-save)
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 0)

(save-presets)
