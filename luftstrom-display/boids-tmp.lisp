(in-package :luftstrom-display)

;;; preset: 7

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 3000
             :boids-per-click 100
             :clockinterv 0
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles ((4 25) (4 25) (4 25) (4 25))
             :curr-kernel "boids"
             :bg-amp 0.001
             :maxspeed 0.105
             :maxforce 0.009000001
             :maxidx 317
             :length 250
             :sepmult 1.0
             :alignmult 1.0
             :cohmult 1.0
             :predmult 1
             :maxlife 60000.0
             :lifemult 212.59842
             :max-events-per-tick 10)
            :audio-args
            (:default (apr 19)
             :player1 (apr 19)
             :player2 (apr 19)
             :player3 (apr 19))
            :midi-cc-fns
            (:nk2 :nk2-std
             :player1 :obst-ctl1
             :player2 :obst-ctl1
             :player3 :obst-ctl1
             :player4 :boid-ctl1
             (:nk2 6) (with-lin-midi-fn (0 50)
                        (set-value :clockinterv (round (funcall ipfn d2))))
             (:nk2 20) (with-exp-midi-fn (5 250)
                         (setf *length* (round (funcall ipfn d2))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 7)

(save-presets)
