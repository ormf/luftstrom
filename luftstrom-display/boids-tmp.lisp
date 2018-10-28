(in-package :luftstrom-display)

;;; preset: 0

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
             :obstacles ((4 25))
             :curr-kernel "boids"
             :bg-amp (m-exp (aref *cc-state* 0 21) 0 1)
             :maxspeed 0.85690904
             :maxforce 0.07344935
             :maxidx 317
             :length 5
             :sepmult 1.32
             :alignmult 2.7
             :cohmult 1.93
             :predmult 1
             :maxlife 60000.0
             :lifemult 1000.0
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (n-exp y 0.4 1.08)
             :ampfn (* (sign) 3)
             :durfn (n-exp y 0.001 5.0e-4)
             :suswidthfn 0.1
             :suspanfn 0
             :decay-startfn 0.001
             :decay-endfn 0.2
             :lfo-freqfn 1
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
                (set-value :bg-amp (float (funcall ipfn d2)))))
             ((0 7)
              (lambda (d2)
                (let ((obstacle (aref *obstacles* 0)))
                  (with-slots (brightness radius) obstacle
                    (let ((ipfn (ip-exp 1.0 2.0 128)))
                      (set-value :predmult (float (funcall ipfn d2))))
                    (let ((ipfn (ip-lin 0.2 1.0 128)))
                      (setf brightness (funcall ipfn d2)))
                    (let ((ipfn (ip-lin 25 60 128)))
                       (setf radius (round (funcall ipfn d2))))))))
             ((0 40)
              (make-retrig-move-fn 0 :dir :right :max 400 :ref 7 :clip nil))
             ((0 50)
              (make-retrig-move-fn 0 :dir :left :max 400 :ref 7 :clip nil))
             ((0 60)
              (make-retrig-move-fn 0 :dir :up :max 400 :ref 7 :clip nil))
             ((0 70)
              (make-retrig-move-fn 0 :dir :down :max 400 :ref 7 :clip nil))
             ((0 99)
              (lambda (d2) (if (= d2 127) (toggle-obstacle 0))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))


(defmacro make-cc-fn (&body body)
  `(lambda (d2)
     ,@body))

(state-store-curr-preset 0)


(funcall (aref *cc-fns* 0 7) 0)

(setf (obstacle-brightness (aref *obstacles* 0)) 1.0)

(make-cc-fn
  (let ((obstacle (aref *obstacles* 0)))
    (with-slots (brightness radius) obstacle
      (let ((ipfn (ip-exp 1.0 100.0 128)))
        (set-value :predmult (float (funcall ipfn d2))))
      (let ((ipfn (ip-lin 0.2 1.0 128)))
        (format t "~&brightness ~a" (round (funcall ipfn d2)))
        (setf brightness (funcall ipfn d2)))
      (let ((ipfn (ip-lin 25 60 128)))
        (format t "~&radius ~a" (round (funcall ipfn d2)))
        (setf radius (round (funcall ipfn d2)))))))
