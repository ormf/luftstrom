(in-package :luftstrom-display)

;;; preset: 0

(progn
  (setf *curr-preset*
        `(:boid-params
          (:num-boids 0
           :boids-per-click 10
           :trig t
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 4.0
           :obstacles ((2 25) (2 25) (2 25) (0 25))
           :curr-kernel "boids"
           :bg-amp 1
           :maxspeed 1.0859671
           :maxforce 0.093082905
           :maxidx 317
           :length 5
           :sepmult 5.5748034
           :alignmult 3.2047243
           :cohmult 1.7165354
           :predmult 1
           :maxlife 60000.0
           :lifemult 192.91339
           :max-events-per-tick 10)
          :audio-args
          (:default (apr 99)
                    )
          :midi-cc-fns
          (:nk2 #'nk2-std-noreset
           :player1 #'obst-ctl1)
          :midi-note-fns
          (:player3 #'boid-state-save)
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 0)

(save-presets)
