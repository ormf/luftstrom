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
         (set-value :maxspeed (* speedf 1.05))
         (set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (set-value :lifemult (funcall ipfn d2)))))
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
    :obstacles-lookahead 2.5 :maxspeed 0.85690904 :maxforce 0.07344935 :maxidx
    317 :length 5 :sepmult 168/127 :alignmult 343/127 :cohmult 245/127
    :predmult 1 :maxlife 60000.0 :lifemult 1000.0 :obstacle-tracked t
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
         (set-value :maxspeed (* speedf 1.05))
         (set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((41 57 11 38 5 0 0 0 0 0 0 0 0 0 0 0 0 0 42 15 127 127 63 127 0 0 0 0 0
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
   (:pitchfn (* 0.4 (expt 2.7 y)) :ampfn (* (sign) (* 1 (expt 1/2 y))) :durfn
    (* 0.2 (expt 3 (random 1.0))) :suswidthfn 0 :suspanfn (random 1.0)
    :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn
    (* 15 (expt 1.5 (random 1.0))) :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn
    20000)
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (set-value :maxspeed (* speedf 1.05))
         (set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (set-value :lifemult (funcall ipfn d2)))))
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
   (:num-boids 0 :boids-per-click 5 :clockinterv 5 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.85690904 :maxforce 0.07344935 :maxidx
    317 :length 5 :sepmult 168/127 :alignmult 343/127 :cohmult 245/127
    :predmult 1 :maxlife 60000.0 :lifemult 1000.0 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 2.7 y)) :ampfn
    (+ 0.2 (* (sign) (random 0.8) (expt 1/2 y))) :durfn
    (* 0.5 (expt 2 (random 1.0))) :suswidthfn 0 :suspanfn (random 1.0)
    :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn 24 :x-posfn x :y-posfn
    y :wetfn 1 :filt-freqfn 20000)
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (set-value :maxspeed (* speedf 1.05))
         (set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((71 66 122 42 6 0 0 0 0 0 0 0 0 0 0 0 0 0 42 15 127 127 63 127 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 0 :boids-per-click 5 :clockinterv 5 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.85690904 :maxforce 0.07344935 :maxidx
    317 :length 5 :sepmult 168/127 :alignmult 343/127 :cohmult 245/127
    :predmult 1 :maxlife 60000.0 :lifemult 1000.0 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 2.7 y)) :ampfn
    (+ 0.2 (* (sign) (random 0.8) (expt 1/2 y))) :durfn
    (* 0.5 (expt 2 (random 1.0))) :suswidthfn 0 :suspanfn (random 1.0)
    :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn
    (* (expt (+ 1 (* 3 (/ (aref *cc-state* 0 17) 127.0))) x) 48
       (expt (round (* y 16)) 1.3))
    :x-posfn x :y-posfn y :wetfn 0 :filt-freqfn 20000)
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (set-value :maxspeed (* speedf 1.05))
         (set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (1 10000)
       (set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((10 35 16 51 7 0 0 0 0 0 0 0 0 0 0 0 0 39 42 15 127 127 63 127 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids nil :clockinterv 50 :speed 2.0 :obstacles-lookahead 2.5
    :maxspeed 0.85690904 :maxforce 0.07344935 :maxidx 317 :length 5 :sepmult
    168/127 :alignmult 343/127 :cohmult 245/127 :predmult 1 :maxlife 20000.0
    :lifemult 100.0 :max-events-per-tick 10)
   :audio-args
   (:pitchfn (+ 0.1 (* 0.6 y)) :ampfn
    (* (sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01))) :durfn
    (* (expt 1/3 y) 1.8) :suswidthfn 0.1 :suspanfn 0.1 :decay-startfn 0.001
    :decay-endfn 0.002 :lfo-freqfn
    (* 50 (expt 5 (/ (aref *cc-state* 0 7) 127))
       (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
    :x-posfn x :y-posfn y :wetfn 1 :filt-freqfn 20000)
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 2)
       (let ((speedf (funcall ipfn d2)))
         (set-value :maxspeed (* speedf 1.05))
         (set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (set-value :alignmult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((95 63 81 68 65 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  nil nil nil nil nil
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 0.96417606 :maxforce 0.08264367 :maxidx
    317 :length 5 :sepmult 469/127 :alignmult 546/127 :cohmult 651/127
    :predmult 1 :maxlife 60000.0 :lifemult 180500/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 3 y)) :ampfn (* (sign) (+ (* 0.4) (random 0.5)))
    :durfn (* 1.8 (expt 1/5 y)) :suswidthfn 0 :suspanfn 0 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (* (expt (round (* 16 y)) (expt (* 1 (/ (aref *cc-state* 0 16) 127)) x)) 100)
    :x-posfn x :y-posfn y :wetfn 0.5 :filt-freqfn (* 200 (expt 50 y)))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 2)
       (let ((speedf (funcall ipfn d2)))
         (set-value :maxspeed (* speedf 1.05))
         (set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((113 79 127 73 95 0 0 0 0 0 0 0 0 0 0 0 79 0 42 15 127 127 63 127 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  (:boid-params
   (:num-boids 900 :boids-per-click 100 :clockinterv 0 :speed 2.0
    :obstacles-lookahead 2.5 :maxspeed 1.5093803 :maxforce 0.12937547 :maxidx
    317 :length 5 :sepmult 623/127 :alignmult 504/127 :cohmult 0 :predmult 1
    :maxlife 60000.0 :lifemult 1900/127 :obstacle-tracked t
    :max-events-per-tick 10)
   :audio-args
   (:pitchfn (* 0.4 (expt 3 y)) :ampfn (* (sign) (+ (* 0.4) (random 0.5)))
    :durfn (* 1.8 (expt 1/5 y)) :suswidthfn 0 :suspanfn 0 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (* (expt (round (* 16 y)) (expt (* 1 (/ (aref *cc-state* 0 16) 127)) x)) 100)
    :x-posfn x :y-posfn y :wetfn 0.5 :filt-freqfn (* 200 (expt 50 y)))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 2)
       (let ((speedf (funcall ipfn d2)))
         (set-value :maxspeed (* speedf 1.05))
         (set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((113 89 0 0 95 0 0 0 0 0 0 0 0 0 0 0 79 0 42 15 127 127 63 127 0 0 0 0 0
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
    (* 3.8 (expt 1/5 y)) :suswidthfn 0.1 :suspanfn 0.3 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (* (expt (round (* 16 y)) (expt (* 1 (/ (aref *cc-state* 0 16) 127)) x)) 100)
    :x-posfn x :y-posfn y :wetfn 0.5 :filt-freqfn (* 200 (expt 50 y)))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 2)
       (let ((speedf (funcall ipfn d2)))
         (set-value :maxspeed (* speedf 1.05))
         (set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((80 66 112 73 6 0 0 0 0 0 0 0 0 0 0 0 79 0 42 15 127 127 63 127 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
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
    (* 3.8 (expt 1/5 y)) :suswidthfn 0.1 :suspanfn 0.3 :decay-startfn 0.001
    :decay-endfn 0.02 :lfo-freqfn
    (* (expt (round (* 16 y)) (expt (* 1 (/ (aref *cc-state* 0 16) 127)) x)) 100)
    :x-posfn x :y-posfn y :wetfn 0.5 :filt-freqfn (* 200 (expt 50 y)))
   :midi-cc-fns
   (((0 0)
     (with-exp-midi (0.1 20)
       (let ((speedf (funcall ipfn d2)))
         (set-value :maxspeed (* speedf 1.05))
         (set-value :maxforce (* speedf 0.09)))))
    ((0 1)
     (with-lin-midi (1 8)
       (set-value :sepmult (funcall ipfn d2))))
    ((0 2)
     (with-lin-midi (1 8)
       (set-value :cohmult (funcall ipfn d2))))
    ((0 3)
     (with-lin-midi (1 8)
       (set-value :alignmult (funcall ipfn d2))))
    ((0 4)
     (with-lin-midi (100 2000)
       (set-value :lifemult (funcall ipfn d2)))))
   :midi-cc-state
   #2A((65 51 22 60 2 0 0 0 0 0 0 0 0 0 0 0 79 0 42 15 127 127 63 127 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
       (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
  nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
  nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
  nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
  nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
  nil nil nil nil nil nil nil nil nil))
