(in-package :luftstrom-display)

;;; preset: 6

(progn
  (setf *curr-preset*
        `(:boid-params
          (:num-boids 62
           :boids-per-click 1
           :trig nil
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 2.5
           :obstacles ((4 25) (4 25) (4 25) (4 25))
           :curr-kernel "boids"
           :bg-amp 0.001
           :maxidx 317
           :length 19
           :sepmult 1.0
           :alignmult 1.0
           :cohmult 3.7007873
           :predmult 1
           :maxlife 60000.0
           :lifemult 251.9685
           :max-events-per-tick 10)
          :audio-args
          (:default (apr 18)
           :player1 (apr 46)
           :player2 (apr 28)
           :player3 (apr 22))
          :midi-cc-fns
          (:nk2 #'nk2-std-noreset
           :player1 #'obst-ctl1
           :player2 #'obst-ctl1
           (:nk2 20) (with-exp-midi-fn (5 250)
                       (setf *length* (round (funcall ipfn d2)))))
          :midi-note-fns
          (:arturia #'boid-num-ctl
           :player3 #'boid-state-save)
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 6)

(save-presets)
