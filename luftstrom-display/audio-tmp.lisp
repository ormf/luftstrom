(in-package :luftstrom-display)

;;; audio-preset: 91

(digest-audio-args-preset
 '(:p1 (if (<= (random 1.0) (m-lin (mc-ref 14) 0 1))
           0.6
           (m-exp (mc-ref 12) 0.01 0.6))
   :p2 (if (<= (random 1.0) (m-lin (mc-ref 13) 0 1))
           1
           0)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.8 0.8)
   :ampfn (m-exp-zero (nk2-ref 16) 0.1 1)
   :durfn p1
   :suswidthfn 0
   :suspanfn 0.3
   :decaystartfn 0.001
   :decayendfn 0.002
   :lfofreqfn (*
               (expt
                (round
                 (*
                  (if (zerop p2)
                      1
                      16)
                  y))
                (n-lin x 1 (m-lin (mc-ref 9) 1 1.5)))
               (hertz (m-lin (mc-ref 10) 11 55))
               (n-exp-dev (m-lin (mc-ref 11) 0 1) 1.5))
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 16) 0 1)
   :filtfreqfn (n-exp y 200 10000)
   :bpfreq (n-exp y 100 5000)
   :bprq (m-lin (mc-ref 15) 1 0.01))
 (aref *audio-presets* 91))


(save-audio-presets)
