(in-package :luftstrom-display)

;;; audio-preset: 90

(digest-audio-args-preset
 '(:p1 (if (<= (random 1.0) (m-lin (mc-ref 14) 0 1))
           0.6
           (m-exp (mc-ref 4) 0.01 0.6))
   :p2 (if (<= (random 1.0) (m-lin (mc-ref 13) 0 1))
           1
           0)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (* (n-exp y 1.0 1.3) 0.63951963)
   :ampfn (* (sign) (m-exp-zero (nk2-ref 16) 0.01 1) (+ 0.4 (random 0.6)))
   :durfn p1
   :suswidthfn 0
   :suspanfn 0.3
   :decaystartfn 0.001
   :decayendfn 0.002
   :lfofreqfn (* 1 (hertz (m-lin (mc-ref 10) 31 55))
               (n-exp-dev (m-lin (mc-ref 11) 0 1) 1.5))
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 16) 0 1)
   :filtfreqfn (n-exp y 200 10000)
   :bpfreq (n-exp y 100 5000)
   :bprq (m-lin (mc-ref 15) 1 0.01))
 (aref *audio-presets* 90))


(save-audio-presets)
