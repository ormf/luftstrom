(in-package :luftstrom-display)

;;; preset: 19

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 1700
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
             :sepmult 5.2440944
             :alignmult 4.6377954
             :cohmult 4.2519684
             :predmult 1
             :maxlife 60000.0
             :lifemult 5000.0
             :max-events-per-tick 10)
            :audio-args
            (:default (apr 19)
             :player1 (apr 19))
            :midi-cc-fns
            (:nk2 :nk2-std
             :player1 :obst-ctl1
             :player2 :obst-ctl1
             :player3 :obst-ctl1
             :player4 :obst-ctl1
             (:nk2 6) (with-lin-midi-fn (0 50)
                        (set-value :clockinterv (round (funcall ipfn d2))))
             (:nk2 20) (with-exp-midi-fn (5 250)
                         (setf *length* (round (funcall ipfn d2))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 19)

(save-presets)
