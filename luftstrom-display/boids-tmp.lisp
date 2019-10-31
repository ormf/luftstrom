(in-package :luftstrom-display)

;;; preset: 2

(progn
  (setf *curr-preset*
        `(:boid-params
          (:alignmult 1.0
           :cohmult 3.7007873
           :sepmult 1.0
           :num-boids 62
           :boids-per-click 1
           :trig nil
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 2.5
           :obstacles ((1 25) (1 25) (1 25) (1 25))
           :curr-kernel "boids"
           :bg-amp 1.0
           :maxidx 317
           :length 19
           :predmult 1
           :maxlife 60000.0
           :lifemult 251.9685
           :max-events-per-tick 10)
          :audio-args
          (:default (apr 90)
           :player1 (apr 11)
           :player2 (apr 12)
           :player3 (apr 13)
           :player4 (apr 14))
          :midi-cc-fns
          (:nk2 #'nk-std-noreset
           :player1 #'obst-ctl1
           :player2 #'obst-ctl1
           (:nk2 6) (with-lin-midi-fn (0 50)
                      (set-value :clockinterv (round (funcall ipfn d2)))))
          :midi-note-fns
          (:player3 #'boid-state-save)
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 2)

(save-presets)
