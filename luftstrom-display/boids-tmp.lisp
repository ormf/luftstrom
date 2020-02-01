(in-package :luftstrom-display)

;;; preset: 9

(progn
  (setf *curr-preset*
        `(:boid-params
          (:num-boids 2789
           :boids-per-click 50 
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 2.5
           :obstacles ((1 25) (1 25) (1 25) (1 25))
           :curr-kernel "boids"
           :bg-amp 0.0067107594
           :maxspeed 0.3520638
           :maxforce 0.030176898
           :maxidx 317
           :length 5
           :sepmult 8.0slx50
           :alignmult 1.0
           :cohmult 1.0
           :predmult 10
           :maxlife 60000.04
           :lifemult 192.91339
           :max-events-per-tick 10)
          :audio-args
          (:default (:apr 92)
           :auto (:apr 92 :cc-state #(0 0 0 0 0 0 0 0 123 0 0 0 0 0 0 0))
           :player1 (:apr 37)
           :player2 (:apr 37)
           :player3 (:apr 37))
          :midi-cc-fns
          ()
          :midi-note-fns
          ()
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 9)

(save-presets)
x50
