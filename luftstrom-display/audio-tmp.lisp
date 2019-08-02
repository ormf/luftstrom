(in-package :luftstrom-display)

;;; audio-preset: 0

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
   :ampfn (* (sign) (n-exp y 1 0.5) (m-exp-zero (nk2-ref 7) 0.04 4))
   :durfn (* (m-exp (nk2-ref 21) 0.1 1) (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decay-startfn 5.0e-4
   :decay-endfn 0.002
   :lfo-freqfn (* (m-exp (nk2-ref 19) 0.25 1) (r-exp 45 45))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 23) 0 1)
   :filt-freqfn (n-exp y 1000 10000)
   :bp-freq (n-exp y 100 5000)
   :bp-rq (m-lin (nk2-ref 22) 1 0.01))
 (aref *audio-presets* 0))


(save-audio-presets)
