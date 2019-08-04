(in-package :luftstrom-display)

;;; audio-preset: 91

(digest-audio-args-preset
 '(:p1 (if (<= (random 1.0) (m-lin (nk2-ref 21) 0 1))
           0.6
           (m-exp (nk2-ref 19) 0.01 0.6))
   :p2 (if (<= (random 1.0) (m-lin (nk2-ref 20) 0 1))
           1
           0)
   :p3 0
   :p4 0
   :pitchfn (* (n-exp y 0.7 1.3))
   :ampfn (* (sign) (expt (m-exp (nk2-ref 5) 0.1 1) p2)
           (m-exp-zero (player-cc tidx 7) 0.01 1) (+ 0.4 (random 0.6)))
   :durfn p1
   :suswidthfn 0
   :suspanfn 0.3
   :decay-startfn 0.001
   :decay-endfn 0.002
   :lfo-freqfn (* 1 (expt (round (* (if (zerop p2) 1 16) y))
                     (n-lin x 1 (m-lin (nk2-ref 16) 1 1.5)))
                (hertz (m-lin (nk2-ref 17) 31 55))
                (n-exp-dev (m-lin (nk2-ref 18) 0 1) 1.5))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 23) 0 1)
   :filt-freqfn (n-exp y 200 10000)
   :bp-freq (n-exp y 100 5000)
   :bp-rq (m-lin (nk2-ref 22) 1 0.01))
 (aref *audio-presets* 91))


(save-audio-presets)
