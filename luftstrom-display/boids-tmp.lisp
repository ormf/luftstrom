(in-package :luftstrom-display)

;;; preset: 20

(progn
  (setf *curr-preset*
        `(:boid-params
          (:num-boids 414
           :boids-per-click 1
           :trig t
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 3.0
           :obstacles ((2 25) (2 25) (2 25) (0 25))
           :curr-kernel "boids"
           :bg-amp 0.001
           :maxspeed 2.2071335
           :maxforce 0.18918288
           :maxidx 317
           :length 5
           :sepmult 1.2755905
           :alignmult 6.7322836
           :cohmult 1.0
           :predmult 10
           :maxlife 60000.0
           :lifemult 47.244095
           :max-events-per-tick 10)
          :audio-args
          (:default (:apr 94)
                    )
          :midi-cc-fns
          ()
          :midi-note-fns
          (:player3 #'boid-state-save)
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 20)

(save-presets)
