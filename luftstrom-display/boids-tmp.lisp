(in-package :luftstrom-display)

;;; preset: 1

(progn
  (setf *curr-preset*
        `(:boid-params
          (:alignmult 1.0
           :cohmult 3.7007873
           :sepmult 1.0
           :num-boids 14
           :boids-per-click 1
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
           :lifemult 251.9685
           :max-events-per-tick 10)
          :audio-args
          (:default (apr 94)
           :player2 (apr 2)
           :player3 (apr 3)
           :player4 (apr 4))
          :midi-cc-fns
          ()
          :midi-note-fns
          (:player3 #'boid-state-save)
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 1)

(save-presets)
