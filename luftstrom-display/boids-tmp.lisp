(in-package :luftstrom-display)

;;; preset: 14

(progn
  (setf *curr-preset*
        `(:boid-params
          (:num-boids 3013
           :boids-per-click 50
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 2.5
           :obstacles ((1 25) (1 25) (1 25) (1 25))
           :curr-kernel "boids"
           :bg-amp 0.0067107594
           :maxspeed 0.105
           :maxforce 0.009000001
           :maxidx 317
           :length 5
           :sepmult 8.0
           :alignmult 1.0
           :cohmult 1.0
           :predmult 1
           :maxlife 60000.0
           :lifemult 177.16536
           :max-events-per-tick 10)
          :audio-args
          (:default (apr 92)
           :player1 (apr 37)
           :player2 (apr 37)
           :player3 (apr 37))
          :midi-cc-fns
          (:nk2 :nk2-std2
           :player1 :obst-ctl1
           :player2 :obst-ctl1
           :player3 :obst-ctl1
           :player4 :boid-ctl1
           (:nk2 6) (with-lin-midi-fn (0 50)
                      (setf *clockinterv* (round (funcall ipfn d2)))))
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 14)

(save-presets)
