(in-package :luftstrom-display)

;;; audio-preset: 5

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (n-exp y 0.4 1.08)
   :ampfn (* (sign) (n-exp y 1 0.5))
   :durfn (r-exp 0.2 0.4)
   :suswidthfn 0.2
   :suspanfn (random 1.0)
   :decay-startfn 5.0e-4
   :decay-endfn 0.002
   :lfo-freqfn (* 6 (1+ (random 2)))
   :x-posfn x
   :y-posfn y
   :wetfn 1
   :filt-freqfn (n-exp y 1000 10000))
 (aref *audio-presets* 5))


(save-audio-presets)
