(in-package :luftstrom-display)

;;; audio-preset: 6

(digest-audio-preset-form
 '(:cc-state #(64 0 0 0 0 0 127 127 47 0 70 11 0 127 91 105)
   :p1 (mc-lin 6 0 1)
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.4 (mc-lin 7 0.8 1.2))
   :ampfn (* (sign) (mc-exp-zero 1 0.1 9) (n-exp y 0.7 (n-lin p1 0.35 0.7)))
   :durfn (m-exp (mc-ref 14) 0.1 0.5)
   :suswidthfn 0.5
   :suspanfn (n-lin p1 0.3 0)
   :decaystartfn (n-lin p1 0.03 5.0e-4)
   :decayendfn 0.03
   :lfofreqfn (+
               (* (- 1 p1)
                (* (mc-exp 12 1 (/ 1.2))
                 (expt (round (+ (mc-lin 4 1 16) (* 16 y (mcn-ref 11))))
                  (mc-exp 12 1 1.2))
                 (hertz (mc-lin 9 11 55)))
                (c2v (m-lin-dev (mc-ref 10) 12)))
               (* p1 1))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (* (n-exp y 1 2) (m-exp (mc-ref 15) 100 10000))
   :bpfreq (n-exp y (n-lin p2 80 100) 10000)
   :bprq (mc-exp 13 2 0.01))
 :audio-preset (aref *audio-presets* 6))


(save-audio-presets)
