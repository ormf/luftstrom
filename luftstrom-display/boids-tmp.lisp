(in-package :luftstrom-display)

;;; preset: 13

(progn
  (setf *curr-preset*
        `(:boid-params
          (:num-boids 13
           :boids-per-click 50
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 2.5
           :obstacles ((1 25) (1 25) (1 25) (1 25))
           :curr-kernel "boids"
           :bg-amp 0.0067107594
           :maxspeed 9.910351
           :maxforce 0.8494587
           :maxidx 317
           :length 5
           :sepmult 6.4566927
           :alignmult 2.2125983
           :cohmult 1.8267716
           :predmult 1
           :maxlife 60000.0
           :lifemult 267.71652
           :max-events-per-tick 10)
          :audio-args
          (:default (apr 91)
           :player1 (apr 91)
           :player2 (apr 91)
           :player3 (apr 91)
           :player4 (apr 91))
          :midi-cc-fns
          (:nk2 :nk2-std2
           :player1 :obst-ctl1
           :player2 :obst-ctl1
           :player3 :obst-ctl1
           (:nk2 6) (with-lin-midi-fn (0 50)
                      (setf *clockinterv* (round (funcall ipfn d2)))))
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 13)

(save-presets)
