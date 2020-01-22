(in-package :luftstrom-display)

;;; audio-preset: 36

(digest-audio-preset-form
 '(:cc-state #(127 6 9 0 121 127 0 55 18 48 36 54 9 0 122 60)
   :p1 10
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
               (hertz (m-lin (mc-ref 10) 31 55)))
   :xposfn x
   :yposfn y
   :wetfn 0.5
   :filtfreqfn (n-exp y 200 10000))
 :audio-preset (aref *audio-presets* 36))


(save-audio-presets)
