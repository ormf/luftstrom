(in-package :luftstrom-display)

;;; audio-preset: 12

(digest-audio-preset-form
 '(:cc-state #(0 0 0 112 0 0 0 0 127 0 0 0 0 127 0 127)
   :p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (+ p2 (n-exp y 0.4 1.08))
   :ampfn (progn (* (sign) 0.5 (n-exp y 0.5 1)))
   :durfn (* 0.1 (r-exp 1 (m-exp (mc-ref 14) 1 10)))
   :suswidthfn 0
   :suspanfn (random 1.0)
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (hertz (mc-lin 9 30 100)) (m-exp-dev (mc-ref 10) 4))
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 16) 0 1)
   :filtfreqfn 20000)
 :audio-preset (aref *audio-presets* 12))


(save-audio-presets)
