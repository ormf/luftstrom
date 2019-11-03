(in-package :luftstrom-display)

;;; audio-preset: 41

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.4 1.2)
   :ampfn (* (sign) (+ 0.1 (random 0.8)))
   :durfn (n-exp (random 1.0) 0.01 0.8)
   :suswidthfn 0.2
   :suspanfn 0.3
   :decaystartfn 0.001
   :decayendfn 0.002
   :lfofreqfn (* (hertz (m-lin (mc-ref 4) 10 50)) (expt 2 (o-x tidx))
               (expt (round (* y (round (m-lin (mc-ref 5) 1 16))))
                (m-exp-dev (mc-ref 6) 1.5)))
   :xposfn x
   :yposfn y
   :wetfn (mcn-ref 16)
   :filtfreqfn (n-exp (random 1.0) 100 10000))
 (aref *audio-presets* 41))


(save-audio-presets)
