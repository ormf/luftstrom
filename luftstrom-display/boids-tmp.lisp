(in-package :luftstrom-display)

;;; preset: 18

(progn
  (setf *curr-preset*
        (copy-list
         (append
          '(:boid-params
            (:num-boids 900
             :boids-per-click 100
             :clockinterv 5
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles (nil (0 10) (1 10) (0 10))
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
             :ampfn (* (sign) (+ 0.1 (random 0.8)))
             :durfn (n-exp (random 1.0) 0.01 0.8)
             :suswidthfn 0.2
             :suspanfn (random 1.0)
             :decay-startfn 0.001
             :decay-endfn 0.002
             :lfo-freqfn 50
             :x-posfn x
             :y-posfn y
             :wetfn 1
             :filt-freqfn (n-exp (random 1.0) 100 10000))
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
              (with-lin-midi (0 2000)
                (set-value :lifemult (float (funcall ipfn d2)))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 23)

(save-presets)
