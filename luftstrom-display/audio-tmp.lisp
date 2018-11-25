(in-package :luftstrom-display)

;;; audio-preset: 18

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (n-exp y 0.4 1.2)
   :ampfn (* (sign) (+ 0.1 (random 0.8)))
   :durfn (n-exp (random 1.0) 0.01 0.8)
   :suswidthfn 0.2
   :suspanfn 0
   :decay-startfn 0.001
   :decay-endfn 0.002
   :lfo-freqfn 50
   :x-posfn x
   :y-posfn y
   :wetfn 1
   :filt-freqfn (n-exp (random 1.0) 100 10000))
 (aref *audio-presets* 18))


(save-audio-presets)
