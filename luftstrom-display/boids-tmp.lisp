(in-package :luftstrom-display)

;;; preset: 16

(progn
  (setf *curr-preset*
        (copy-list
         (append
          '(:boid-params
            (:num-boids 900
             :boids-per-click 100
             :clockinterv 0
             :speed 2.0
             :obstacles-lookahead 2.5
             :maxspeed 0.96417606
             :maxforce 0.08264367
             :maxidx 317
             :length 5
             :sepmult 469/127
             :alignmult 546/127
             :cohmult 651/127
             :predmult 1
             :maxlife 60000.0
             :lifemult 180500/127
             :obstacle-tracked t
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (* 0.4 (expt 3 luftstrom-display::y))
             :ampfn (* (luftstrom-display::sign) (+ 0.1 (random 0.1)))
             :durfn (* 0.8 (expt 1/5 luftstrom-display::y))
             :suswidthfn 0.1
             :suspanfn 0.3
             :decay-startfn 0.001
             :decay-endfn 0.02
             :lfo-freqfn (*
                          (expt (round (* 16 luftstrom-display::y))
                                (orm-utils:n-lin luftstrom-display::x 1
                                                 (orm-utils:n-lin
                                                  (/ (aref luftstrom-display::*nk2* 0 16)
                                                     127)
                                                  1 1.2)))
                          (orm-utils:m-exp (aref luftstrom-display::*nk2* 0 17) 50 200))
             :x-posfn luftstrom-display::x
             :y-posfn luftstrom-display::y
             :wetfn 0.5
             :filt-freqfn (* 200 (expt 50 luftstrom-display::y)))
            :midi-cc-fns
            (((0 0)
              (luftstrom-display::with-exp-midi (0.1 20)
                (let ((luftstrom-display::speedf
                       (funcall luftstrom-display::ipfn luftstrom-display::d2)))
                  (luftstrom-display::set-value :maxspeed (* luftstrom-display::speedf 1.05))
                  (luftstrom-display::set-value :maxforce
                                                (* luftstrom-display::speedf 0.09)))))
             ((0 1)
              (luftstrom-display::with-lin-midi (1 8)
                (luftstrom-display::set-value :sepmult
                                              (funcall luftstrom-display::ipfn
                                                       luftstrom-display::d2))))
             ((0 2)
              (luftstrom-display::with-lin-midi (1 8)
                (luftstrom-display::set-value :cohmult
                                              (funcall luftstrom-display::ipfn
                                                       luftstrom-display::d2))))
             ((0 3)
              (luftstrom-display::with-lin-midi (1 8)
                (luftstrom-display::set-value :alignmult
                                              (funcall luftstrom-display::ipfn
                                                       luftstrom-display::d2))))
             ((0 4)
              (luftstrom-display::with-lin-midi (100 2000)
                (luftstrom-display::set-value :lifemult
                                              (funcall luftstrom-display::ipfn
                                                       luftstrom-display::d2))))))
          `(:midi-cc-state ,(alexandria:copy-array *nk2*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 16)
