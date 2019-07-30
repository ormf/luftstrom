(in-package :luftstrom-display)

;;; audio-preset: 17

(digest-audio-args-preset
 '(:p1 0
   :p2 (m-lin (nk2-ref 6) 0 1)
   :p3 0
   :p4 0
   :pitchfn (n-exp y 0.4 (m-lin (nk2-ref 19) 0.8 1.2))
   :ampfn (* (m-exp-zero (player-cc tidx 7) 0.01 1) (sign) (+ 0.1 (random 0.6)))
   :durfn (+ (* (- 1 p2) (n-exp y 0.8 0.16)) (* p2 (m-exp (nk2-ref 16) 0.1 0.5)))
   :suswidthfn (* p2 0.5)
   :suspanfn 0.3
   :decay-startfn (n-lin p2 0.001 0.03)
   :decay-endfn (n-lin p2 0.02 0.03)
   :lfo-freqfn (n-lin p2
                (*
                 (expt (round (* 16 y))
                  (n-lin x 1 (m-lin (nk2-ref 16) 1 1.5)))
                 (hertz (m-lin (nk2-ref 17) 31 55)))
                (* (n-exp y 0.8 1.2) (m-exp (nk2-ref 18) 50 400)
                 (n-exp-dev (m-lin (nk2-ref 17) 0 1) 0.5)))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 22) 0 1)
   :filt-freqfn (* (n-exp y 1 2) (m-exp (nk2-ref 23) 100 10000)))
 (aref *audio-presets* 17))


(save-audio-presets)
