(in-package :luftstrom-display)

;;; preset: 0

(progn
  (setf *curr-preset*
        `(:boid-params
          (:num-boids 12603
           :boids-per-click 11
           :trig t
           :clockinterv 0
           :speed 2.0
           :obstacles-lookahead 4.0
           :obstacles ((2 25) (2 25) (2 25) (0 25))
           :curr-kernel "boids"
           :bg-amp 1
           :maxspeed 1.4542702
           :maxforce 0.124651745
           :maxidx 317
           :length 5
           :sepmult 1.0551181
           :alignmult 3.535433
           :cohmult 1.0
           :predmult 1
           :maxlife 60000.0
           :lifemult 82.67716
           :max-events-per-tick 10)
          :audio-args
          (:default (apr 91)
           :player1 (apr 91)
           :player2 (apr 91)
           :player3 (apr 91)
           :player4 (apr 91))
          :midi-cc-fns
          (:nk2 #'mc-std
           :player1 :obst-ctl1
           :player2 :obst-ctl1
           :player3 :obst-ctl1
           :player4 :life-ctl1
           (:nk2 6) (with-lin-midi-fn (0 50)
                      (setf *clockinterv* (round (funcall ipfn d2)))))
          :midi-note-fns
          (:player3 #'boid-state-save)
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 0)

(save-presets)
