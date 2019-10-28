(in-package :luftstrom-display)

;;; preset: 5

(progn
  (setf *curr-preset*
        `(:boid-params
          (:maxforce 0.009000001
           :maxspeed 0.105
           :alignmult 1.0
           :cohmult 1.0
           :sepmult 1.0
           :num-boids 10
           :boids-per-click 1
           :trig nil
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 4.0
           :obstacles ((3 25) (4 25) (4 25) (4 25))
           :curr-kernel "boids"
           :bg-amp 1
           :maxidx 317
           :length 5
           :predmult 10
           :maxlife 60000.0
           :lifemult 0.0
           :max-events-per-tick 10)
          :audio-args
          (:default (apr 17)
           :player1 (apr 37)
           :player2 (apr 37)
           :player3 (apr 37))
          :midi-cc-fns
          (:bs1 #'mc-std-noreset-nolength
           :player1 #'obst-ctl1
           :player2 #'obst-ctl1)
          :midi-note-fns
          (:player3 #'boid-state-save)
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 5)

(save-presets)
