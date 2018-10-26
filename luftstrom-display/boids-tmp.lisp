(in-package :luftstrom-display)

;;; preset: 1

(progn
  (setf *curr-preset*
        (copy-list
         (append
          '(:boid-params
            (:num-boids 0
             :boids-per-click 5
             :clockinterv 2
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles (nil (0 10) (1 10) (0 10))
             :curr-kernel "boids"
             :bg-amp 1
             :maxspeed 0.5124912
             :maxforce 0.043927822
             :maxidx 317
             :length 5
             :sepmult 6.4488187
             :alignmult 4.07874
             :cohmult 3.6377952
             :predmult 1
             :maxlife 60000.0
             :lifemult 629.8583
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (n-exp y 0.4 1.08)
             :ampfn (* (sign) (n-exp y 3 1.5))
             :durfn 0.5
             :suswidthfn 0
             :suspanfn (random 1.0)
             :decay-startfn 5.0e-4
             :decay-endfn 0.002
             :lfo-freqfn (r-exp 10 15)
             :x-posfn x
             :y-posfn y
             :wetfn 1
             :filt-freqfn 20000)
            :midi-cc-fns
            (((4 0)
              (with-exp-midi (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (set-value :maxspeed (* speedf 1.05))
                  (set-value :maxforce (* speedf 0.09)))))
             ((4 1)
              (with-lin-midi (1 8)
                (set-value :sepmult (float (funcall ipfn d2)))))
             ((4 2)
              (with-lin-midi (1 8)
                (set-value :cohmult (float (funcall ipfn d2)))))
             ((4 3)
              (with-lin-midi (1 8)
                (set-value :alignmult (float (funcall ipfn d2)))))
             ((4 4)
              (with-lin-midi (1 10000)
                (set-value :lifemult (float (funcall ipfn d2)))))
             ((4 21)
              (with-exp-midi (0.001 1.0)
                (set-value :bg-amp (float (funcall ipfn d2)))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 1)
