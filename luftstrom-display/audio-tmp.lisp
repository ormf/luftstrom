(in-package :luftstrom-display)

;;; audio-preset: 7

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.5 1)
   :ampfn (* (sign) 2)
   :durfn (n-exp y (n-exp x 0.1 0.02) 1.0e-4)
   :suswidthfn 0.01
   :suspanfn 0
   :decaystartfn 0.5
   :decayendfn 0.06
   :lfofreqfn 10
   :xposfn x
   :yposfn y
   :wetfn 1
   :filtfreqfn (n-exp y 100 20000))
 (aref *audio-presets* 7))


(save-audio-presets)
