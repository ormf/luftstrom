(in-package :luftstrom-display)

;;; audio-preset: 31

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (+ p2 (n-exp y 0.4 1.08))
   :ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
   :durfn 0.5
   :suswidthfn 0
   :suspanfn (random 1.0)
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (r-exp 50 80)
   :xposfn x
   :yposfn y
   :wetfn 1
   :filtfreqfn 20000)
 (aref *audio-presets* 31))


(save-audio-presets)
