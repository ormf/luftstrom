(in-package :luftstrom-display)

;;; preset: 1

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 90
             :boids-per-click 5
             :clockinterv 2
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles ((4 25))
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
            (:default (apr 0)
             :player1 (apr 1))
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
              (with-lin-midi-fn (1 10000)
                (set-value :lifemult (float (funcall ipfn d2)))))
             ((4 21)
              (with-exp-midi-fn (0.001 1.0)
                (set-value :bg-amp (float (funcall ipfn d2)))))
             ((0 7)
              (lambda (d2)
                (if (numberp d2)
                    (let ((obstacle (aref *obstacles* 0)))
                      (with-slots (brightness radius)
                          obstacle
                        (let ((ipfn (ip-exp 2.5 40.0 128)))
                          (set-lookahead 0 (float (funcall ipfn d2))))
                        (let ((ipfn (ip-exp 1 100.0 128)))
                          (set-multiplier 0 (float (funcall ipfn d2))))
                        (let ((ipfn (ip-lin 0.2 1.0 128)))
                          (setf brightness (funcall ipfn d2))))))))
             ((0 40)
              (make-retrig-move-fn 0 :dir :right :max 400 :ref 7 :clip nil))
             ((0 50)
              (make-retrig-move-fn 0 :dir :left :max 400 :ref 7 :clip nil))
             ((0 60)
              (make-retrig-move-fn 0 :dir :up :max 400 :ref 7 :clip nil))
             ((0 70)
              (make-retrig-move-fn 0 :dir :down :max 400 :ref 7 :clip nil))
             ((0 99)
              (lambda (d2)
                (if (and (numberp d2) (= d2 127))
                    (toggle-obstacle 0))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 1)

(save-presets)
