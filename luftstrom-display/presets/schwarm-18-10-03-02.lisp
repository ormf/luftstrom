(setf *presets*
#((:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 2 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.85690904 :maxforce 0.07344935 :maxidx
    317 :length 5 :sepmult 168/127 :alignmult 343/127 :cohmult 245/127
    :predmult 1 :maxlife 60000.0 :lifemult 1000.0 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 2.7 y)) :ampfn (* (sign) (* 3 (expt 1 y))) :durfn
    (* 0.001 (expt 1/2 y)) :suswidthfn 0.1 :suspanfn 0 :decay-startfn 0.001
    :decay-endfn 0.2 :lfo-freqfn 1 :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn
    20000)
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((0 57 11 38 5 0 0 0 0 0 0 0 0 0 0 0 0 0 42 15 127 127 63 127 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 2 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.5124912 :maxforce 0.043927822 :maxidx
    317 :length 5 :sepmult 6.4488187 :alignmult 4.07874 :cohmult 3.6377952
    :predmult 1 :maxlife 60000.0 :lifemult 629.8583 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 2.7 y)) :ampfn (* (sign) (* 3 (expt 1/2 y))) :durfn
    0.5 :suswidthfn 0 :suspanfn (random 1.0) :decay-startfn 5.0e-4 :decay-endfn
    0.002 :lfo-freqfn (* 10 (expt 1.5 (random 1.0))) :x-posfn x :y-posfn y
    :wetfn 1 :filt-freqfn 20000)
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (float (funcall ipfn d2)))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (float (funcall ipfn d2)))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (float (funcall ipfn d2)))))
    ((0 4)
     (with-lin-midi (1 10000)
       (bp-set-value :lifemult (float (funcall ipfn d2))))))
   :midi-cc-state
   #2A((38 117 66 74 8 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.85690904 :maxforce 0.07344935 :maxidx
    317 :length 5 :sepmult 168/127 :alignmult 343/127 :cohmult 245/127
    :predmult 1 :maxlife 60000.0 :lifemult 1000.0 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 2.7 y)) :ampfn (* (sign) (* 1 (expt 1/2 y))) :durfn
    (* 0.2 (expt 3 (random 1.0))) :suswidthfn 0 :suspanfn (random 1.0)
    :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn
    (* 15 (expt 1.5 (random 1.0))) :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn
    20000)
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((41 84 92 70 5 0 0 0 0 0 0 0 0 0 0 0 0 0 42 15 127 127 63 127 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.85690904 :maxforce 0.07344935 :maxidx
    317 :length 5 :sepmult 168/127 :alignmult 343/127 :cohmult 245/127
    :predmult 1 :maxlife 60000.0 :lifemult 1000.0 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 2.7 y)) :ampfn (* (sign) (* 3 (expt 1/2 y))) :durfn
    3.5 :suswidthfn 0.1 :suspanfn (random 1.0) :decay-startfn 5.0e-4
    :decay-endfn 0.002 :lfo-freqfn (* 48 (random 5)) :x-posfn x :y-posfn y
    :wetfn 0.5 :filt-freqfn 20000)
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((33 117 66 74 6 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.85690904 :maxforce 0.07344935 :maxidx
    317 :length 5 :sepmult 168/127 :alignmult 343/127 :cohmult 245/127
    :predmult 1 :maxlife 60000.0 :lifemult 1000.0 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 2.7 y)) :ampfn (* (sign) (* 1 (expt 1/2 y))) :durfn
    (* 0.2 (expt 3 (random 1.0))) :suswidthfn 0.3 :suspanfn 1 :decay-startfn
    5.0e-4 :decay-endfn 0.002 :lfo-freqfn (* 15 (expt 1.5 (random 1.0)))
    :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn (n-exp y 1000 10000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((99 122 116 74 8 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 5 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx
    317 :length 5 :sepmult 875/127 :alignmult 273/127 :cohmult 21/127 :predmult
    1 :maxlife 60000.0 :lifemult 219978/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 2.7 y)) :ampfn (* (sign) (* 1 (expt 1/2 y))) :durfn
    (* 0.2 (expt 2 (random 1.0))) :suswidthfn 0.2 :suspanfn (random 1.0)
    :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn (* 6 (1+ (random 2)))
    :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn (n-exp y 1000 10000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((64 125 3 39 22 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 4 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx
    317 :length 5 :sepmult 875/127 :alignmult 273/127 :cohmult 21/127 :predmult
    1 :maxlife 60000.0 :lifemult 219978/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (+ 0.5 (n-exp y 0.1 0.5)) :ampfn (* (sign) 2) :durfn
    (n-exp y 0.05 1.0e-4) :suswidthfn 0.01 :suspanfn 0 :decay-startfn 0.5
    :decay-endfn 0.06 :lfo-freqfn 10 :x-posfn x :y-posfn y)
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((45 88 72 39 8 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 4 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx
    317 :length 5 :sepmult 875/127 :alignmult 273/127 :cohmult 21/127 :predmult
    1 :maxlife 60000.0 :lifemult 219978/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.5 1) :ampfn (* (sign) 2) :durfn
    (n-exp y (n-exp x 0.1 0.02) 1.0e-4) :suswidthfn 0.01 :suspanfn 0
    :decay-startfn 0.5 :decay-endfn 0.06 :lfo-freqfn 10 :x-posfn x :y-posfn y
    :wetfn 1 :filt-freqfn (n-exp y 100 20000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 100)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((84 70 127 127 127 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 4 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx
    317 :length 5 :sepmult 875/127 :alignmult 273/127 :cohmult 21/127 :predmult
    1 :maxlife 60000.0 :lifemult 219978/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (+ 0.5 (* 0.1 y)) :ampfn (* (sign) 2) :durfn 0.1 :suswidthfn 1
    :suspanfn 0 :decay-startfn 0.5 :decay-endfn 0.06 :lfo-freqfn 1 :x-posfn x
    :y-posfn y)
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((45 88 72 39 8 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 4 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx
    317 :length 5 :sepmult 875/127 :alignmult 273/127 :cohmult 21/127 :predmult
    1 :maxlife 60000.0 :lifemult 219978/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.5 1) :ampfn (* (sign) 2) :durfn (n-exp y 0.1 0.01)
    :suswidthfn 0.01 :suspanfn 0 :decay-startfn 0.5 :decay-endfn 0.06
    :lfo-freqfn (n-exp y 500 1000) :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn
    (n-exp y 100 20000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 100)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((44 70 127 127 127 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx
    317 :length 5 :sepmult 875/127 :alignmult 273/127 :cohmult 21/127 :predmult
    1 :maxlife 60000.0 :lifemult 219978/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.5 1) :ampfn (* (sign) 2) :durfn (n-exp y 0.1 0.02)
    :suswidthfn 0.01 :suspanfn 0 :decay-startfn 0.5 :decay-endfn 0.06
    :lfo-freqfn (n-exp y 500 1000) :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn
    (n-exp y 100 10000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 100)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((44 70 127 127 127 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx
    317 :length 5 :sepmult 875/127 :alignmult 273/127 :cohmult 21/127 :predmult
    1 :maxlife 60000.0 :lifemult 219978/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.5 1) :ampfn (* (sign) 2) :durfn (n-exp y 0.1 0.02)
    :suswidthfn 0.01 :suspanfn 0 :decay-startfn 0.5 :decay-endfn 0.06
    :lfo-freqfn (* (n-exp x 0.7 1) (n-exp y 500 1000)) :x-posfn x :y-posfn y
    :wetfn 0.5 :filt-freqfn (n-exp y 100 20000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 100)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((127 64 59 127 127 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx
    317 :length 5 :sepmult 875/127 :alignmult 273/127 :cohmult 21/127 :predmult
    1 :maxlife 60000.0 :lifemult 219978/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (n-exp y 0.5 1) :ampfn (* (sign) 2) :durfn
    (* (n-lin x 2 1) (n-exp y 0.1 0.02)) :suswidthfn 0.01 :suspanfn
    (n-lin x 0 1) :decay-startfn 0.5 :decay-endfn 0.06 :lfo-freqfn
    (* (n-exp x 0.7 1) (n-exp y 500 1000)) :x-posfn x :y-posfn y :wetfn 0.5
    :filt-freqfn (n-exp y 100 20000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 100)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((85 76 92 127 66 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 1.5162244 :maxforce 0.1299621 :maxidx
    317 :length 5 :sepmult 875/127 :alignmult 273/127 :cohmult 21/127 :predmult
    1 :maxlife 60000.0 :lifemult 219978/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 2.7 y)) :ampfn (* (sign) (* 1 (expt 1/2 y))) :durfn
    (* 0.2 (expt 2 (random 1.0))) :suswidthfn 0.2 :suspanfn (random 1.0)
    :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn
    (* 6 (n-exp y 10 500) (1+ (random 2))) :x-posfn x :y-posfn y :wetfn 1
    :filt-freqfn (n-exp y 1000 10000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((116 45 125 101 127 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.21340333 :maxforce 0.018291716 :maxidx
    317 :length 5 :sepmult 581/127 :alignmult 420/127 :cohmult 0 :predmult 1
    :maxlife 60000.0 :lifemult 3800/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 3 y)) :ampfn (* (sign) (+ 0.1 (random 0.1))) :durfn
    (* 3.8 (expt 1/5 y)) :suswidthfn 0.1 :suspanfn 0.3 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (* (expt (round (* 16 y)) (expt (* 1 (/ (aref *cc-state* 0 16) 127)) x)) 100)
    :x-posfn x :y-posfn y :wetfn 0.5 :filt-freqfn (* 200 (expt 50 y)))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((65 51 22 60 2 0 0 0 0 0 0 0 0 0 0 0 79 0 42 15 127 127 63 127 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx
    317 :length 5 :sepmult 469/127 :alignmult 546/127 :cohmult 651/127
    :predmult 1 :maxlife 60000.0 :lifemult 180500/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 3 y)) :ampfn (* (sign) (+ 0.1 (random 0.1))) :durfn
    (* 0.8 (expt 1/5 y)) :suswidthfn 0.1 :suspanfn 0.3 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (*
     (expt (round (* 16 y))
           (n-lin x 1 (n-lin (/ (aref *cc-state* 0 16) 127) 1 1.2)))
     100)
    :x-posfn x :y-posfn y :wetfn 0.5 :filt-freqfn (* 200 (expt 50 y)))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((88 127 121 73 12 0 0 0 0 0 0 0 0 0 0 0 72 87 42 15 127 127 66 127 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx
    317 :length 5 :sepmult 469/127 :alignmult 546/127 :cohmult 651/127
    :predmult 1 :maxlife 60000.0 :lifemult 180500/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 3 y)) :ampfn (* (sign) (+ 0.1 (random 0.1))) :durfn
    (* 0.8 (expt 1/5 y)) :suswidthfn 0.1 :suspanfn 0.3 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (*
     (expt (round (* 16 y))
           (n-lin x 1 (n-lin (/ (aref *cc-state* 0 16) 127) 1 1.2)))
     (m-exp (aref *cc-state* 0 17) 50 200))
    :x-posfn x :y-posfn y :wetfn 0.5 :filt-freqfn (* 200 (expt 50 y)))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((127 51 41 24 113 0 0 0 0 0 0 0 0 0 0 0 126 55 42 15 127 127 66 127 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 1.5808177 :maxforce 0.13549867 :maxidx
    317 :length 5 :sepmult 700/127 :alignmult 504/127 :cohmult 749/127
    :predmult 1 :maxlife 60000.0 :lifemult 142500/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 3 y)) :ampfn (* (sign) (+ 0.1 (random 0.1))) :durfn
    (* 0.8 (expt 1/5 y)) :suswidthfn 0.1 :suspanfn 0.3 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (*
     (expt (round (* 16 y))
           (n-lin x 1 (n-lin (/ (aref *cc-state* 0 16) 127) 1 1.2)))
     (m-exp (aref *cc-state* 0 17) 20 200))
    :x-posfn x :y-posfn y :wetfn (m-lin (aref *cc-state* 0 23) 0 1) :filt-freqfn
    (* 200 (expt 50 y)))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((65 100 107 72 75 0 0 0 0 0 0 0 0 0 0 0 121 25 42 15 127 127 66 21 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 5 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx
    317 :length 5 :sepmult 469/127 :alignmult 546/127 :cohmult 651/127
    :predmult 1 :maxlife 60000.0 :lifemult 180500/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 3 y)) :ampfn (* (sign) (+ 0.1 (random 0.8))) :durfn
    (n-exp (random 1.0) 0.01 0.8) :suswidthfn 0.2 :suspanfn (random 1.0)
    :decay-startfn 0.001 :decay-endfn 0.002 :lfo-freqfn 50 :x-posfn x :y-posfn
    y :wetfn 1 :filt-freqfn (n-exp (random 1.0) 100 10000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((62 109 48 91 40 0 0 0 0 0 0 0 0 0 0 0 50 81 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 5 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx
    317 :length 5 :sepmult 469/127 :alignmult 546/127 :cohmult 651/127
    :predmult 1 :maxlife 60000.0 :lifemult 180500/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 3 y)) :ampfn (* (sign) (+ 0.1 (random 0.8))) :durfn
    (n-exp (random 1.0) 0.01 0.8) :suswidthfn 0.2 :suspanfn 0 :decay-startfn
    0.001 :decay-endfn 0.002 :lfo-freqfn 50 :x-posfn x :y-posfn y :wetfn 1
    :filt-freqfn (n-exp (random 1.0) 100 10000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((62 109 48 91 40 0 0 0 0 0 0 0 0 0 0 0 50 81 0 0 0 0 0 0 0 0 0 0 0 0 0 0
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
    :obstacles-lookahead 2.5 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx
    317 :length 5 :sepmult 469/127 :alignmult 546/127 :cohmult 651/127
    :predmult 1 :maxlife 60000.0 :lifemult 180500/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 3 y)) :ampfn (* (sign) (+ 0.1 (random 0.8))) :durfn
    (n-exp (random 1.0) 0.01 0.4) :suswidthfn 0.2 :suspanfn 0 :decay-startfn
    0.001 :decay-endfn 0.002 :lfo-freqfn 50 :x-posfn x :y-posfn y :wetfn 1
    :filt-freqfn (n-exp (random 1.0) 1000 20000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((121 106 113 94 66 0 0 0 0 0 0 0 0 0 0 0 50 81 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 5 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx
    317 :length 5 :sepmult 469/127 :alignmult 546/127 :cohmult 651/127
    :predmult 1 :maxlife 60000.0 :lifemult 180500/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 3 y)) :ampfn (* (sign) (+ 0.1 (random 0.8))) :durfn
    (n-exp (random 1.0) 0.01 0.8) :suswidthfn 0.2 :suspanfn 0 :decay-startfn
    0.001 :decay-endfn 0.002 :lfo-freqfn (* 50 (random 16)) :x-posfn x :y-posfn
    y :wetfn 1 :filt-freqfn (n-exp (random 1.0) 100 10000))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (bp-set-value :maxspeed (* speedf 1.05))
         (bp-set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (bp-set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (bp-set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (bp-set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (bp-set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((44 127 87 94 33 0 0 0 0 0 0 0 0 0 0 0 50 81 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
  nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
  nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
  nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
  nil))
