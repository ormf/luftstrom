(in-package :luftstrom-display)

;;; audio-preset: 36

(digest-audio-args-preset
 '(:p1 10
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.4 1.2)
   :ampfn (* (sign) (+ 0.1 (random 0.6)))
   :durfn (n-exp y 0.8 0.16)
   :suswidthfn 0.1
   :suspanfn 0.3
   :decaystartfn 0.001
   :decayendfn 0.02
   :lfofreqfn (* (n-exp x 1 1.2)
               (expt (round (* 16 y)) (n-lin x 1 (m-lin (mc-ref 6) 1 1.2)))
               (hertz (m-lin (mc-ref 10) 10 55)))
   :xposfn x
   :yposfn y
   :wetfn (mcn-ref 16)
   :filtfreqfn (n-exp y 200 10000))
 (aref *audio-presets* 36))


(save-audio-presets)
