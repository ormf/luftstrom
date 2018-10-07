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
             :obstacles (nil (0 25) (4 25) (0 25))
             :curr-kernel "boids"
             :bg-amp 1
             :maxspeed 0.96417606
             :maxforce 0.08264367
             :maxidx 317
             :length 5
             :sepmult 3.69
             :alignmult 4.3
             :cohmult 5.13
             :predmult 1
             :maxlife 60000.0
             :lifemult 1421
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (n-exp y 0.4 1.2)
             :ampfn (* (sign) (+ 0.1 (random 0.1)))
             :durfn (n-exp y 0.8 0.16)
             :suswidthfn 0.1
             :suspanfn 0.3
             :decay-startfn 0.001
             :decay-endfn 0.02
             :lfo-freqfn (*
                          (expt (round (* 16 y))
                                (n-lin x 1 (n-lin (/ (aref *nk2* 0 16) 127) 1 1.2)))
                          (m-exp (aref *nk2* 0 17) 50 200))
             :x-posfn x
             :y-posfn y
             :wetfn 0.5
             :filt-freqfn (n-exp y 200 10000))
            :midi-cc-fns
            (((0 0)
              (with-exp-midi (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (set-value :maxspeed (* speedf 1.05))
                  (set-value :maxforce (* speedf 0.09)))))
             ((0 1)
              (with-lin-midi (1 8)
                (set-value :sepmult (float (funcall ipfn d2)))))
             ((0 2)
              (with-lin-midi (1 8)
                (set-value :cohmult (float (funcall ipfn d2)))))
             ((0 3)
              (with-lin-midi (1 8)
                (set-value :alignmult (float (funcall ipfn d2)))))
             ((0 4)
              (with-lin-midi (100 2000)
                (set-value :lifemult (float (funcall ipfn d2)))))))
          `(:midi-cc-state ,(alexandria:copy-array *nk2*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 16)
