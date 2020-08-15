(in-package :luftstrom-display)

;;; audio-preset: 4

(digest-audio-preset-form
 '(:cc-state #(0 0 0 0 0 0 127 127 38 0 127 11 0 127 91 105)
   :p1 (mc-lin 6 0 1)
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.4 (mc-lin 7 0.8 1.2))
   :ampfn (* (sign) (n-exp y 0.7 0.35))
   :durfn (m-exp (mc-ref 14) 0.1 0.5)
   :suswidthfn 0.5
   :suspanfn 0.3
   :decaystartfn 0.03
   :decayendfn 0.03
   :lfofreqfn (+
               (* (- 1 p1)
                (* (mc-exp 12 1 (/ 1.2))
                 (expt (round (+ (mc-lin 4 1 16) (* 16 y (mcn-ref 11))))
                  (mc-exp 12 1 1.2))
                 (hertz (mc-lin 9 11 55)))
                (c2v (m-lin-dev (mc-ref 10) 12)))
               (* p1 12.5 (expt 2 (+ 2 (random 4)))))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (* (n-exp y 1 2) (m-exp (mc-ref 15) 100 10000)))
 :audio-preset (aref *audio-presets* 4))


(save-audio-presets)
