(in-package :luftstrom-display)

(setf *presets*
#((:boid-params
   (:num-boids 1110 :boids-per-click 50 :clockinterv 2 :speed 2.0
    :obstacles-lookahead 1.0 :obstacles ((4 25)) :curr-kernel "boids" :bg-amp
    (m-exp (aref *cc-state* 4 21) 0 1) :maxspeed 6.2630696 :maxforce 0.5368346
    :maxidx 317 :length 5 :sepmult 4.141732 :alignmult 1.0 :cohmult 1.0
    :predmult 1.0 :maxlife 60000.0 :lifemult 1.0 :max-events-per-tick 10)
   :audio-args
   (:p1 1 :p2 (- p1 1) :p3 0 :p4 0 :pitchfn (+ p2 (n-exp y 0.4 1.08)) :ampfn
    (progn (* (/ v 20) (sign) (n-exp y 3 1.5))) :durfn 0.5 :suswidthfn 0
    :suspanfn (random 1.0) :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn
    (r-exp 50 80) :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn 20000)
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-exp-midi-fn (1 1000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2)))))
    ((0 7)
     (lambda (d2)
       (if (numberp d2)
           (let ((obstacle (aref *obstacles* 0)))
             (with-slots (brightness radius)
                 obstacle
               (let ((ipfn (ip-exp 1 40.0 128)))
                 (set-lookahead 0 (float (funcall ipfn d2))))
               (let ((ipfn (ip-exp -1 -100.0 128)))
                 (set-multiplier 0
                                 (* (signum (- (aref *cc-state* 0 100) 63))
                                    (float (funcall ipfn d2)))))
               (let ((ipfn (ip-lin 0.2 1.0 128)))
                 (setf brightness (funcall ipfn d2))))))))
    ((0 40) (make-retrig-move-fn 0 :dir :right :max 400 :ref 7 :clip nil))
    ((0 50) (make-retrig-move-fn 0 :dir :left :max 400 :ref 7 :clip nil))
    ((0 60) (make-retrig-move-fn 0 :dir :up :max 400 :ref 7 :clip nil))
    ((0 70) (make-retrig-move-fn 0 :dir :down :max 400 :ref 7 :clip nil))
    ((0 99)
     (lambda (d2)
       (if (and (numberp d2) (= d2 127))
           (toggle-obstacle 0)))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (98 57 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 2 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles ((4 25)) :curr-kernel "boids" :bg-amp 1
    :maxspeed 0.5124912 :maxforce 0.043927822 :maxidx 317 :length 5 :sepmult
    6.4488187 :alignmult 4.07874 :cohmult 3.6377952 :predmult 1 :maxlife
    60000.0 :lifemult 629.8583 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.08) :ampfn (* (sign) (n-exp y 3 1.5)) :durfn 0.5
    :suswidthfn 0 :suspanfn (random 1.0) :decay-startfn 5.0e-4 :decay-endfn
    0.002 :lfo-freqfn (r-exp 10 15) :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn
    20000)
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2)))))
    ((0 7)
     (lambda (d2)
       (if (numberp d2)
           (let ((obstacle (aref *obstacles* 0)))
             (with-slots (brightness radius)
                 obstacle
               (let ((ipfn (ip-exp 2.5 40.0 128)))
                 (bp-set-value :obstacles-lookahead (float (funcall ipfn d2))))
               (let ((ipfn (ip-exp 1 100.0 128)))
                 (bp-set-value :predmult (float (funcall ipfn d2))))
               (let ((ipfn (ip-lin 0.2 1.0 128)))
                 (setf brightness (funcall ipfn d2))))))))
    ((0 40) (make-retrig-move-fn 0 :dir :right :max 400 :ref 7 :clip nil))
    ((0 50) (make-retrig-move-fn 0 :dir :left :max 400 :ref 7 :clip nil))
    ((0 60) (make-retrig-move-fn 0 :dir :up :max 400 :ref 7 :clip nil))
    ((0 70) (make-retrig-move-fn 0 :dir :down :max 400 :ref 7 :clip nil))
    ((0 99)
     (lambda (d2)
       (if (and (numberp d2) (= d2 127))
           (toggle-obstacle 0)))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (93 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 0.85690904 :maxforce 0.07344935 :maxidx 317
    :length 5 :sepmult 1.32 :alignmult 2.7 :cohmult 1.93 :predmult 1 :maxlife
    60000.0 :lifemult 1000.0 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.08) :ampfn (* (sign) (n-exp y 1 0.5)) :durfn
    (r-exp 0.2 0.6) :suswidthfn 0 :suspanfn (random 1.0) :decay-startfn 5.0e-4
    :decay-endfn 0.002 :lfo-freqfn (r-exp 15 22.5) :x-posfn x :y-posfn y :wetfn
    1 :filt-freqfn 20000)
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (41 84 92 70 5 0 0 0 0 0 0 0 0 0 0 0 0 0 42 15 127 127 63 127 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 0.85690904 :maxforce 0.07344935 :maxidx 317
    :length 5 :sepmult 1.32 :alignmult 2.7 :cohmult 1.93 :predmult 1 :maxlife
    60000.0 :lifemult 1000.0 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.08) :ampfn (* (sign) (n-exp y 3 1.5)) :durfn 3.5
    :suswidthfn 0.1 :suspanfn (random 1.0) :decay-startfn 5.0e-4 :decay-endfn
    0.002 :lfo-freqfn (* 48 (random 5)) :x-posfn x :y-posfn y :wetfn 0.5
    :filt-freqfn 20000)
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (33 117 66 74 6 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 0.85690904 :maxforce 0.07344935 :maxidx 317
    :length 5 :sepmult 1.32 :alignmult 2.7 :cohmult 1.93 :predmult 1 :maxlife
    60000.0 :lifemult 1000.0 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.08) :ampfn (* (sign) (n-exp y 1 0.5)) :durfn
    (r-exp 0.2 0.6) :suswidthfn 0.3 :suspanfn 1 :decay-startfn 5.0e-4
    :decay-endfn 0.002 :lfo-freqfn (r-exp 15 22.5) :x-posfn x :y-posfn y :wetfn
    1 :filt-freqfn (n-exp y 1000 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (99 122 116 74 8 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 5 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx 317
    :length 5 :sepmult 6.89 :alignmult 2.15 :cohmult 0.17 :predmult 1 :maxlife
    60000.0 :lifemult 1732 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.08) :ampfn (* (sign) (n-exp y 1 0.5)) :durfn
    (r-exp 0.2 0.4) :suswidthfn 0.2 :suspanfn (random 1.0) :decay-startfn
    5.0e-4 :decay-endfn 0.002 :lfo-freqfn (* 6 (1+ (random 2))) :x-posfn x
    :y-posfn y :wetfn 1 :filt-freqfn (n-exp y 1000 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (64 125 3 39 22 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 4 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx 317
    :length 5 :sepmult 6.89 :alignmult 2.15 :cohmult 0.17 :predmult 1 :maxlife
    60000.0 :lifemult 1732 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (+ 0.5 (n-exp y 0.1 0.5)) :ampfn (* (sign) 2) :durfn
    (n-exp y 0.05 1.0e-4) :suswidthfn 0.01 :suspanfn 0 :decay-startfn 0.5
    :decay-endfn 0.06 :lfo-freqfn 10 :x-posfn x :y-posfn y)
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (45 88 72 39 8 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 4 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx 317
    :length 5 :sepmult 6.89 :alignmult 2.15 :cohmult 0.17 :predmult 1 :maxlife
    60000.0 :lifemult 1732 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.5 1) :ampfn (* (sign) 2) :durfn
    (n-exp y (n-exp x 0.1 0.02) 1.0e-4) :suswidthfn 0.01 :suspanfn 0
    :decay-startfn 0.5 :decay-endfn 0.06 :lfo-freqfn 10 :x-posfn x :y-posfn y
    :wetfn 1 :filt-freqfn (n-exp y 100 20000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 100)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (84 70 127 127 127 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 4 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx 317
    :length 5 :sepmult 6.89 :alignmult 2.15 :cohmult 0.17 :predmult 1 :maxlife
    60000.0 :lifemult 1732 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (+ 0.5 (* 0.1 y)) :ampfn (* (sign) 2) :durfn 0.1 :suswidthfn 1
    :suspanfn 0 :decay-startfn 0.5 :decay-endfn 0.06 :lfo-freqfn 1 :x-posfn x
    :y-posfn y)
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (45 88 72 39 8 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 4 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx 317
    :length 5 :sepmult 6.89 :alignmult 2.15 :cohmult 0.17 :predmult 1 :maxlife
    60000.0 :lifemult 1732 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.5 1) :ampfn (* (sign) 2) :durfn (n-exp y 0.1 0.01)
    :suswidthfn 0.01 :suspanfn 0 :decay-startfn 0.5 :decay-endfn 0.06
    :lfo-freqfn (n-exp y 500 1000) :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn
    (n-exp y 100 20000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 100)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (44 70 127 127 127 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx 317
    :length 5 :sepmult 6.89 :alignmult 2.15 :cohmult 0.17 :predmult 1 :maxlife
    60000.0 :lifemult 1732 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.5 1) :ampfn (* (sign) 2) :durfn (n-exp y 0.1 0.02)
    :suswidthfn 0.01 :suspanfn 0 :decay-startfn 0.5 :decay-endfn 0.06
    :lfo-freqfn (n-exp y 500 1000) :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn
    (n-exp y 100 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 100)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (44 70 127 127 127 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx 317
    :length 5 :sepmult 6.89 :alignmult 2.15 :cohmult 0.17 :predmult 1 :maxlife
    60000.0 :lifemult 1732 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.5 1) :ampfn (* (sign) 2) :durfn (n-exp y 0.1 0.02)
    :suswidthfn 0.01 :suspanfn 0 :decay-startfn 0.5 :decay-endfn 0.06
    :lfo-freqfn (* (n-exp x 0.7 1) (n-exp y 500 1000)) :x-posfn x :y-posfn y
    :wetfn 0.5 :filt-freqfn (n-exp y 100 20000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 100)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (127 64 59 127 127 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx 317
    :length 5 :sepmult 6.89 :alignmult 2.15 :cohmult 0.17 :predmult 1 :maxlife
    60000.0 :lifemult 1732 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.5 1) :ampfn (* (sign) 2) :durfn
    (* (n-lin x 2 1) (n-exp y 0.1 0.02)) :suswidthfn 0.01 :suspanfn
    (n-lin x 0 1) :decay-startfn 0.5 :decay-endfn 0.06 :lfo-freqfn
    (* (n-exp x 0.7 1) (n-exp y 500 1000)) :x-posfn x :y-posfn y :wetfn 0.5
    :filt-freqfn (n-exp y 100 20000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 100)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (85 76 92 127 66 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 305 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1.0 :maxspeed 9.117008 :maxforce 0.7814579 :maxidx 317
    :length 5 :sepmult 3.3622048 :alignmult 3.527559 :cohmult 3.1417322
    :predmult 1 :maxlife 60000.0 :lifemult 0.0 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.08) :ampfn (* (sign) (n-exp y 1 0.5)) :durfn
    (r-exp 0.2 0.4) :suswidthfn 0.2 :suspanfn (random 1.0) :decay-startfn
    5.0e-4 :decay-endfn 0.002 :lfo-freqfn
    (* 6 (n-exp y 10 500) (1+ (random 2))) :x-posfn x :y-posfn y :wetfn 1
    :filt-freqfn (n-exp y 1000 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (107 61 57 64 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp (m-exp (aref *cc-state* 4 21) 0.001 1) :maxspeed 0.21340333
    :maxforce 0.018291716 :maxidx 317 :length 5 :sepmult 4.57 :alignmult 3.31
    :cohmult 0 :predmult 1 :maxlife 60000.0 :lifemult 29.92
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.2) :ampfn (* (sign) (+ 0.1 (random 0.1))) :durfn
    (n-exp y 3.8 0.76) :suswidthfn 0.1 :suspanfn 0.3 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (* (expt (round (* 16 y)) (expt (* 1 (/ (aref *cc-state* 4 16) 127)) x))
       100)
    :x-posfn x :y-posfn y :wetfn 0.5 :filt-freqfn (n-exp y 200 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (100 2000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (47 68 42 44 46 0 0 0 0 0 0 0 0 0 0 0 73 105 0 0 0 0 81 103 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx 317
    :length 5 :sepmult 3.69 :alignmult 4.3 :cohmult 5.13 :predmult 1 :maxlife
    60000.0 :lifemult 1421 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.2) :ampfn (* (sign) (+ 0.1 (random 0.1))) :durfn
    (n-exp y 0.8 0.16) :suswidthfn 0.1 :suspanfn 0.3 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (*
     (expt (round (* 16 y))
           (n-lin x 1 (n-lin (/ (aref *cc-state* 4 16) 127) 1 1.2)))
     100)
    :x-posfn x :y-posfn y :wetfn 0.5 :filt-freqfn (n-exp y 200 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (100 2000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (88 127 121 73 12 0 0 0 0 0 0 0 0 0 0 0 72 87 42 15 127 127 66 127 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp (m-exp (aref *cc-state* 4 21) 0.001 1) :maxspeed 0.96417606
    :maxforce 0.08264367 :maxidx 317 :length 5 :sepmult 3.69 :alignmult 4.3
    :cohmult 5.13 :predmult 1 :maxlife 60000.0 :lifemult 1421
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.2) :ampfn (* (sign) (+ 0.1 (random 0.1))) :durfn
    (n-exp y 0.8 0.16) :suswidthfn 0.1 :suspanfn 0.3 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (*
     (expt (round (* 16 y))
           (n-lin x 1 (n-lin (/ (aref *cc-state* 4 16) 127) 1 1.2)))
     (m-exp (aref *cc-state* 4 17) 50 200))
    :x-posfn x :y-posfn y :wetfn 0.5 :filt-freqfn (n-exp y 200 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (0 2000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (127 101 46 112 0 45 0 0 0 0 0 0 0 0 0 0 125 14 26 0 0 127 0 127 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles ((1 25) (1 25) (1 25) (1 25))
    :curr-kernel "boids" :bg-amp 1 :maxspeed 0.96417606 :maxforce 0.08264367
    :maxidx 317 :length 5 :sepmult 5.51 :alignmult 3.97 :cohmult 749/127
    :predmult 1 :maxlife 60000.0 :lifemult 142500/127 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.2) :ampfn (* (sign) (+ 0.1 (random 0.1))) :durfn
    (n-exp y 0.8 0.16) :suswidthfn 0.1 :suspanfn 0.3 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (*
     (expt (round (* 16 y))
           (n-lin x 1 (n-lin (/ (aref *cc-state* 4 16) 127) 1 1.2)))
     (m-exp (aref *cc-state* 4 17) 20 200))
    :x-posfn x :y-posfn y :wetfn (m-lin (aref *cc-state* 4 23) 0 1)
    :filt-freqfn (n-exp y 200 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (100 2000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (81 97 31 80 24 13 0 0 0 0 0 0 0 0 0 0 127 79 0 0 0 127 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 5 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx 317
    :length 5 :sepmult 3.69 :alignmult 4.3 :cohmult 5.13 :predmult 1 :maxlife
    60000.0 :lifemult 1421 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.2) :ampfn (* (sign) (+ 0.1 (random 0.8))) :durfn
    (n-exp (random 1.0) 0.01 0.8) :suswidthfn 0.2 :suspanfn (random 1.0)
    :decay-startfn 0.001 :decay-endfn 0.002 :lfo-freqfn 50 :x-posfn x :y-posfn
    y :wetfn 1 :filt-freqfn (n-exp (random 1.0) 100 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (100 2000)
       (bp-set-value :lifemult (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (101 127 102 83 50 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 127 0 118 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 5 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx 317
    :length 5 :sepmult 3.69 :alignmult 4.3 :cohmult 5.13 :predmult 1 :maxlife
    60000.0 :lifemult 1421 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.2) :ampfn (* (sign) (+ 0.1 (random 0.8))) :durfn
    (n-exp (random 1.0) 0.01 0.8) :suswidthfn 0.2 :suspanfn 0 :decay-startfn
    0.001 :decay-endfn 0.002 :lfo-freqfn 50 :x-posfn x :y-posfn y :wetfn 1
    :filt-freqfn (n-exp (random 1.0) 100 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (100 2000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (62 109 48 91 40 0 0 0 0 0 0 0 0 0 0 0 50 81 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  nil
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 2 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx 317
    :length 5 :sepmult 3.69 :alignmult 4.3 :cohmult 5.13 :predmult 1 :maxlife
    60000.0 :lifemult 1421 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.2) :ampfn (* (sign) (+ 0.1 (random 0.8))) :durfn
    (n-exp (random 1.0) 0.01 0.4) :suswidthfn 0.2 :suspanfn 0 :decay-startfn
    0.001 :decay-endfn 0.002 :lfo-freqfn 50 :x-posfn x :y-posfn y :wetfn 1
    :filt-freqfn (n-exp (random 1.0) 1000 20000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (100 2000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (27 34 23 63 11 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 127 0 118 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 5 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx 317
    :length 5 :sepmult 3.69 :alignmult 4.3 :cohmult 5.13 :predmult 1 :maxlife
    60000.0 :lifemult 1421 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.2) :ampfn (* (sign) (+ 0.1 (random 0.8))) :durfn
    (n-exp (random 1.0) 0.01 0.8) :suswidthfn 0.2 :suspanfn 0 :decay-startfn
    0.001 :decay-endfn 0.002 :lfo-freqfn (* 50 (random 16)) :x-posfn x :y-posfn
    y :wetfn 1 :filt-freqfn (n-exp (random 1.0) 100 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (0 2000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (79 62 39 63 2 0 0 0 0 0 0 0 0 0 0 0 127 105 0 8 0 84 0 70 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 50 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx 317
    :length 5 :sepmult 3.69 :alignmult 4.3 :cohmult 5.13 :predmult 1 :maxlife
    60000.0 :lifemult 1421 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.2) :ampfn (* (sign) (+ 0.1 (random 0.8))) :durfn
    (n-exp (random 1.0) 0.01 0.8) :suswidthfn 0.2 :suspanfn (random 1.0)
    :decay-startfn 0.001 :decay-endfn 0.002 :lfo-freqfn 50 :x-posfn x :y-posfn
    y :wetfn 1 :filt-freqfn (n-exp (random 1.0) 100 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (0 200)
       (bp-set-value :lifemult (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (54 127 127 127 120 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 127 0 118 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  nil
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 4 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx 317
    :length 5 :sepmult 6.89 :alignmult 2.15 :cohmult 0.17 :predmult 1 :maxlife
    60000.0 :lifemult 1732 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.5) :ampfn (* (sign) (n-exp y 1 20) (r-exp 0.5 2))
    :durfn (n-exp y 0.05 0.005) :suswidthfn 0.01 :suspanfn 0 :decay-startfn
    0.01 :decay-endfn 0.06 :lfo-freqfn (n-exp y 100 3000) :x-posfn x :y-posfn y
    :wetfn (m-lin (aref *cc-state* 4 23) 0 1) :filt-freqfn
    (m-exp y 1000 20000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (21 98 101 115 2 0 0 64 0 0 0 0 0 0 0 0 0 0 0 0 0 4 71 25 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx 317
    :length 5 :sepmult 6.89 :alignmult 2.15 :cohmult 0.17 :predmult 1 :maxlife
    60000.0 :lifemult 1732 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.5) :ampfn (* (sign) (n-exp y 1 20) (r-exp 0.5 2))
    :durfn (n-exp y 0.05 0.005) :suswidthfn 0.01 :suspanfn 0 :decay-startfn
    0.01 :decay-endfn 0.06 :lfo-freqfn
    (* (/ (round (* 16 y)) 16) (m-exp (aref *cc-state* 4 18) 1 2) 1500)
    :x-posfn x :y-posfn y :wetfn (m-lin (aref *cc-state* 4 23) 0 1)
    :filt-freqfn (m-exp y 1000 20000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (50 127 0 45 68 0 0 64 0 0 0 0 0 0 0 0 0 44 127 0 0 4 71 25 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  nil nil nil nil nil nil nil nil nil nil nil nil nil
  (:boid-params
   (:num-boids 0 :boids-per-click 50 :clockinterv 2 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles ((4 25)) :curr-kernel "boids" :bg-amp
    (m-exp (aref *cc-state* 4 21) 0 1) :maxspeed 0.85690904 :maxforce
    0.07344935 :maxidx 317 :length 5 :sepmult 1.32 :alignmult 2.7 :cohmult 1.93
    :predmult 1 :maxlife 60000.0 :lifemult 1000.0 :max-events-per-tick 10)
   :audio-args
   (:p1 1 :p2 (- p1 1) :p3 0 :p4 0 :pitchfn (+ p2 (n-exp y 0.4 1.08)) :ampfn
    (progn (* (/ v 20) (sign) (n-exp y 3 1.5))) :durfn 0.5 :suswidthfn 0
    :suspanfn (random 1.0) :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn
    (case tidx (1 (r-exp 50 80)) (otherwise (r-exp 50 80))) :x-posfn x :y-posfn
    y :wetfn 1 :filt-freqfn 20000)
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2)))))
    ((0 7)
     (lambda (d2)
       (if (numberp d2)
           (let ((obstacle (aref *obstacles* 0)))
             (with-slots (brightness radius)
                 obstacle
               (let ((ipfn (ip-exp 2.5 40.0 128)))
                 (bp-set-value :obstacles-lookahead (float (funcall ipfn d2))))
               (let ((ipfn (ip-exp 1 100.0 128)))
                 (bp-set-value :predmult (float (funcall ipfn d2))))
               (let ((ipfn (ip-lin 0.2 1.0 128)))
                 (setf brightness (funcall ipfn d2))))))))
    ((0 40) (make-retrig-move-fn 0 :dir :right :max 400 :ref 7 :clip nil))
    ((0 50) (make-retrig-move-fn 0 :dir :left :max 400 :ref 7 :clip nil))
    ((0 60) (make-retrig-move-fn 0 :dir :up :max 400 :ref 7 :clip nil))
    ((0 70) (make-retrig-move-fn 0 :dir :down :max 400 :ref 7 :clip nil))
    ((0 99)
     (lambda (d2)
       (if (and (numberp d2) (= d2 127))
           (toggle-obstacle 0)))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (127 125 127 63 0 83 0 0 0 0 0 0 0 0 0 0 75 98 0 0 0 121 110 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 2 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles (nil (0 10) (1 10) (0 10)) :curr-kernel
    "boids" :bg-amp 1 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx 317
    :length 5 :sepmult 3.69 :alignmult 4.3 :cohmult 5.13 :predmult 1 :maxlife
    60000.0 :lifemult 1421 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.4 1.2) :ampfn (* (sign) (+ 0.1 (random 0.8))) :durfn
    (n-exp (random 1.0) 0.01 0.8) :suswidthfn 0.2 :suspanfn 0 :decay-startfn
    0.001 :decay-endfn 0.002 :lfo-freqfn (* 50 (random 16)) :x-posfn x :y-posfn
    y :wetfn 1 :filt-freqfn (n-exp (random 1.0) 100 10000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (0 200)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (79 62 0 63 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 84 0 118 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  nil nil nil
  (:boid-params
   (:num-boids 0 :boids-per-click 50 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles ((4 25)) :curr-kernel "boids" :bg-amp
    (m-exp-zero (aref *cc-state* 4 21) 0.001 1) :maxspeed 0.85690904 :maxforce
    0.07344935 :maxidx 317 :length 5 :sepmult 1.32 :alignmult 2.7 :cohmult 1.93
    :predmult 1 :maxlife 60000.0 :lifemult 1000.0 :max-events-per-tick 10)
   :audio-args
   (:p1 1 :p2 (- p1 1) :p3 0 :p4 0 :pitchfn
    (case tidx (1 (+ 0.5 (* 0.1 y))) (otherwise (+ p2 (n-exp y 0.4 1.08))))
    :ampfn
    (case tidx
      (1 (* (/ v 20) (sign) 2))
      (otherwise (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))))
    :durfn (case tidx (1 0.1) (otherwise 0.5)) :suswidthfn
    (case tidx (1 1) (otherwise 0)) :suspanfn
    (case tidx (1 0) (otherwise (random 1.0))) :decay-startfn
    (case tidx (1 0.5) (otherwise 5.0e-4)) :decay-endfn
    (case tidx (1 0.06) (otherwise 0.002)) :lfo-freqfn
    (case tidx (1 1) (otherwise (r-exp 50 80))) :x-posfn x :y-posfn y :wetfn 1
    :filt-freqfn 20000)
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2)))))
    ((0 7)
     (lambda (d2)
       (if (numberp d2)
           (let ((obstacle (aref *obstacles* 0)))
             (with-slots (brightness radius)
                 obstacle
               (let ((ipfn (ip-exp 2.5 40.0 128)))
                 (bp-set-value :obstacles-lookahead (float (funcall ipfn d2))))
               (let ((ipfn (ip-exp 1 100.0 128)))
                 (bp-set-value :predmult (float (funcall ipfn d2))))
               (let ((ipfn (ip-lin 0.2 1.0 128)))
                 (setf brightness (funcall ipfn d2))))))))
    ((0 40) (make-retrig-move-fn 0 :dir :right :max 400 :ref 7 :clip nil))
    ((0 50) (make-retrig-move-fn 0 :dir :left :max 400 :ref 7 :clip nil))
    ((0 60) (make-retrig-move-fn 0 :dir :up :max 400 :ref 7 :clip nil))
    ((0 70) (make-retrig-move-fn 0 :dir :down :max 400 :ref 7 :clip nil))
    ((0 99)
     (lambda (d2)
       (if (and (numberp d2) (= d2 127))
           (toggle-obstacle 0)))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (80 125 127 63 1 83 0 0 0 0 0 0 0 0 0 0 75 98 0 0 0 80 110 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0
        127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 450 :boids-per-click 50 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles ((4 25)) :curr-kernel "boids" :bg-amp
    (m-exp-zero (aref *cc-state* 4 21) 0.001 1) :maxspeed 5.5262713 :maxforce
    0.47368044 :maxidx 317 :length 5 :sepmult 5.5196853 :alignmult 1.0 :cohmult
    1.0 :predmult 1.0 :maxlife 60000.0 :lifemult 7.874016 :max-events-per-tick
    10)
   :audio-args
   (:p1 1 :p2 (- p1 1) :p3 0 :p4 0 :pitchfn
    (case tidx (1 (+ 0.5 (* 0.1 y))) (otherwise (+ p2 (n-exp y 0.4 1.08))))
    :ampfn
    (case tidx
      (1 (* (/ v 20) (sign) 2))
      (otherwise (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))))
    :durfn (case tidx (1 0.1) (otherwise 0.5)) :suswidthfn
    (case tidx (1 1) (otherwise 0)) :suspanfn
    (case tidx (1 0) (otherwise (random 1.0))) :decay-startfn
    (case tidx (1 0.5) (otherwise 5.0e-4)) :decay-endfn
    (case tidx (1 0.06) (otherwise 0.002)) :lfo-freqfn
    (case tidx
      (1 1)
      (otherwise (* (m-exp (aref *cc-state* 4 7) 1 4) (r-exp 20 40))))
    :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn 20000)
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (0 1000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2)))))
    ((0 7)
     (lambda (d2)
       (if (numberp d2)
           (let ((obstacle (aref *obstacles* 0)))
             (with-slots (brightness radius)
                 obstacle
               (let ((ipfn (ip-exp 2.5 40.0 128)))
                 (bp-set-value :obstacles-lookahead (float (funcall ipfn d2))))
               (let ((ipfn (ip-exp 1 100.0 128)))
                 (bp-set-value :predmult (float (funcall ipfn d2))))
               (let ((ipfn (ip-lin 0.2 1.0 128)))
                 (setf brightness (funcall ipfn d2))))))))
    ((0 40) (make-retrig-move-fn 0 :dir :right :max 400 :ref 7 :clip nil))
    ((0 50) (make-retrig-move-fn 0 :dir :left :max 400 :ref 7 :clip nil))
    ((0 60) (make-retrig-move-fn 0 :dir :up :max 400 :ref 7 :clip nil))
    ((0 70) (make-retrig-move-fn 0 :dir :down :max 400 :ref 7 :clip nil))
    ((0 99)
     (lambda (d2)
       (if (and (numberp d2) (= d2 127))
           (toggle-obstacle 0)))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (95 82 0 0 1 77 0 127 0 0 0 0 0 0 0 0 127 96 0 20 84 102 110 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 50 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles ((4 25)) :curr-kernel "boids" :bg-amp
    (m-exp-zero (aref *cc-state* 4 21) 0.001 1) :maxspeed 2.030448 :maxforce
    0.17403841 :maxidx 317 :length 5 :sepmult 8.0 :alignmult 7.6141734 :cohmult
    6.2362204 :predmult 1.0 :maxlife 60000.0 :lifemult 913.3858
    :max-events-per-tick 10)
   :audio-args
   (:p1 1 :p2 (- p1 1) :p3 0 :p4 0 :pitchfn
    (case tidx (1 (+ 0.5 (* 0.1 y))) (otherwise (+ p2 (n-exp y 0.4 1.08))))
    :ampfn
    (case tidx
      (1 (* (/ v 20) (sign) 2))
      (otherwise (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))))
    :durfn (case tidx (1 0.1) (otherwise 0.5)) :suswidthfn
    (case tidx (1 1) (otherwise 0)) :suspanfn
    (case tidx (1 0) (otherwise (random 1.0))) :decay-startfn
    (case tidx (1 0.5) (otherwise 5.0e-4)) :decay-endfn
    (case tidx (1 0.06) (otherwise 0.002)) :lfo-freqfn
    (case tidx
      (1 1)
      (otherwise
       (* (m-exp (aref *cc-state* 4 0) 1 2) (m-exp (aref *cc-state* 4 7) 1 10)
          (r-exp 20 40))))
    :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn 20000)
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (0 1000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2)))))
    ((0 7)
     (lambda (d2)
       (if (numberp d2)
           (let ((obstacle (aref *obstacles* 0)))
             (with-slots (brightness radius)
                 obstacle
               (let ((ipfn (ip-exp 2.5 40.0 128)))
                 (bp-set-value :obstacles-lookahead (float (funcall ipfn d2))))
               (let ((ipfn (ip-exp 1 100.0 128)))
                 (bp-set-value :predmult (float (funcall ipfn d2))))
               (let ((ipfn (ip-lin 0.2 1.0 128)))
                 (setf brightness (funcall ipfn d2))))))))
    ((0 40) (make-retrig-move-fn 0 :dir :right :max 400 :ref 7 :clip nil))
    ((0 50) (make-retrig-move-fn 0 :dir :left :max 400 :ref 7 :clip nil))
    ((0 60) (make-retrig-move-fn 0 :dir :up :max 400 :ref 7 :clip nil))
    ((0 70) (make-retrig-move-fn 0 :dir :down :max 400 :ref 7 :clip nil))
    ((0 99)
     (lambda (d2)
       (if (and (numberp d2) (= d2 127))
           (toggle-obstacle 0)))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (71 127 95 120 116 127 0 120 0 0 0 0 0 0 0 0 127 96 0 20 84 127 110 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 2200 :boids-per-click 50 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :obstacles ((4 25)) :curr-kernel "boids" :bg-amp
    (m-exp-zero (aref *cc-state* 4 21) 0.001 1) :maxspeed 3.4924514 :maxforce
    0.299353 :maxidx 317 :length 5 :sepmult 1.6062992 :alignmult 5.7952757
    :cohmult 5.133858 :predmult 1.0 :maxlife 60000.0 :lifemult 472.44095
    :max-events-per-tick 10)
   :audio-args
   (:p1 1 :p2 (- p1 1) :p3 0 :p4 0 :pitchfn
    (case tidx (1 (+ 0.5 (* 0.1 y))) (otherwise (+ p2 (n-exp y 0.4 1.08))))
    :ampfn
    (case tidx
      (1 (* (/ v 20) (sign) 2))
      (otherwise (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))))
    :durfn (case tidx (1 0.1) (otherwise 0.5)) :suswidthfn
    (case tidx (1 1) (otherwise 0)) :suspanfn
    (case tidx (1 0) (otherwise (random 1.0))) :decay-startfn
    (case tidx (1 0.5) (otherwise 5.0e-4)) :decay-endfn
    (case tidx (1 0.06) (otherwise 0.002)) :lfo-freqfn
    (case tidx
      (1 1)
      (otherwise
       (* (m-exp (aref *cc-state* 4 0) 1 2) (m-exp (aref *cc-state* 4 7) 1 10)
          (r-exp 20 40))))
    :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn (n-exp y 1000 20000))
   :midi-cc-fns
   (((4 0)
     (with-exp-midi-fn (0.1 20)
       (let ((speedf (float (funcall ipfn d2))))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((4 1)
     (with-lin-midi-fn (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((4 2)
     (with-lin-midi-fn (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((4 3)
     (with-lin-midi-fn (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((4 4)
     (with-lin-midi-fn (0 1000)
       (bp-set-value :lifemult (float (funcall ipfn d2)))))
    ((4 21)
     (with-exp-midi-fn (0.001 1.0)
       (bp-set-value :bg-amp (float (funcall ipfn d2)))))
    ((0 7)
     (lambda (d2)
       (if (numberp d2)
           (let ((obstacle (aref *obstacles* 0)))
             (with-slots (brightness radius)
                 obstacle
               (let ((ipfn (ip-exp 2.5 40.0 128)))
                 (bp-set-value :obstacles-lookahead (float (funcall ipfn d2))))
               (let ((ipfn (ip-exp 1 100.0 128)))
                 (bp-set-value :predmult (float (funcall ipfn d2))))
               (let ((ipfn (ip-lin 0.2 1.0 128)))
                 (setf brightness (funcall ipfn d2))))))))
    ((0 40) (make-retrig-move-fn 0 :dir :right :max 400 :ref 7 :clip nil))
    ((0 50) (make-retrig-move-fn 0 :dir :left :max 400 :ref 7 :clip nil))
    ((0 60) (make-retrig-move-fn 0 :dir :up :max 400 :ref 7 :clip nil))
    ((0 70) (make-retrig-move-fn 0 :dir :down :max 400 :ref 7 :clip nil))
    ((0 99)
     (lambda (d2)
       (if (and (numberp d2) (= d2 127))
           (toggle-obstacle 0)))))
   :midi-cc-state
   #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (84 11 75 87 60 127 0 127 0 0 0 0 0 0 0 0 127 96 0 20 84 105 110 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
  nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
  nil nil nil nil nil nil nil nil nil nil nil nil nil))
