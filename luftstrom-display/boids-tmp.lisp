(in-package :luftstrom-display)

;;; preset: 4

(progn
  (setf *curr-preset*
        `(:boid-params
          (:alignmult 5.07874
           :cohmult 3.7007873
           :sepmult 1.0
           :num-boids 691
           :boids-per-click 1
           :trig nil
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 2.5
           :obstacles ((1 25) (1 25) (1 25) (1 25))
           :curr-kernel "boids"
           :bg-amp 0.0067107594
           :maxidx 317
           :length 5
           :predmult 1
           :maxlife 60000.0
           :lifemult 185.03937
           :max-events-per-tick 10)
          :audio-args
          (:default (apr 92)
           :player1 (apr 37)
           :player2 (apr 37)
           :player3 (apr 37))
          :midi-cc-fns
          (:nk2 #'nk2-std-noreset-nolength
           :player1 #'obst-ctl1
           :player2 #'obst-ctl1
           (:nk2 6) (with-lin-midi-fn (0 50)
                      (setf *clockinterv* (round (funcall ipfn d2)))))
          :midi-note-fns
          (:arturia #'boid-num-ctl
           :player3 #'boid-state-save)
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 4)

(save-presets)

()
