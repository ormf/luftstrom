(in-package :luftstrom-display)

;;; preset: 7

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 0
             :boids-per-click 5
             :clockinterv 4
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles (nil (0 10) (1 10) (0 10))
             :curr-kernel "boids"
             :bg-amp 1
             :maxspeed 1.5162244
             :maxforce 0.1299621
             :maxidx 317
             :length 5
             :sepmult 6.89
             :alignmult 2.15
             :cohmult 0.17
             :predmult 1
             :maxlife 60000.0
             :lifemult 1732
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (n-exp y 0.5 1)
             :ampfn (* (sign) 2)
             :durfn (n-exp y (n-exp x 0.1 0.02) 1.0e-4)
             :suswidthfn 0.01
             :suspanfn 0
             :decay-startfn 0.5
             :decay-endfn 0.06
             :lfo-freqfn 10
             :x-posfn x
             :y-posfn y
             :wetfn 1
             :filt-freqfn (n-exp y 100 20000))
            :midi-cc-fns
            (((4 0)
              (with-exp-midi-fn (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (set-value :maxspeed (* speedf 1.05))
                  (set-value :maxforce (* speedf 0.09)))))
             ((4 1)
              (with-lin-midi-fn (1 8)
                (set-value :sepmult (float (funcall ipfn d2)))))
             ((4 2)
              (with-lin-midi-fn (1 8)
                (set-value :cohmult (float (funcall ipfn d2)))))
             ((4 3)
              (with-lin-midi-fn (1 8)
                (set-value :alignmult (float (funcall ipfn d2)))))
             ((4 4)
              (with-lin-midi-fn (1 100)
                (set-value :lifemult (float (funcall ipfn d2)))))
             ((4 21)
              (with-exp-midi-fn (0.001 1.0)
                (set-value :bg-amp (float (funcall ipfn d2)))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 7)
