(in-package :luftstrom-display)

;;; preset: 1

(progn
  (setf *curr-preset*
        `(:boid-params
          (:maxforce 0.07247026
           :maxspeed 0.8454863
           :alignmult 3.8110237
           :cohmult 5.1889763
           :sepmult 6.2362204
           :num-boids 505
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
           :predmult 10
           :maxlife 60000.0
           :lifemult 90.55118
           :max-events-per-tick 10)
          :audio-args
          (:player2 (apr 95)
           :default (apr 99))
          :midi-cc-fns
          (:nk2 #'nk-std-noreset
           :player1 #'obst-ctl1)
          :midi-note-fns
          (:player3 #'boid-state-save)
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 1)

(save-presets)
