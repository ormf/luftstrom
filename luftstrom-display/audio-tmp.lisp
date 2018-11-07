(in-package :luftstrom-display)

;;; audio-preset: 0

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (+ p2 (n-exp y 0.4 1.08))
   :ampfn (* (m-exp-zero (or (player-cc tidx 7) 1) 0.01 10) (sign) (n-exp y 3 1.5))
   :durfn (m-exp (or (player-cc tidx 22) 0) 0.01 1)
   :suswidthfn 0
   :suspanfn (random 0.2)
   :decay-startfn 5.0e-4
   :decay-endfn 0.002
   :lfo-freqfn (n-exp y 50 100)
   :x-posfn x
   :y-posfn y
   :wetfn 1
   :filt-freqfn 20000)
 (aref *audio-presets* 0))


(save-audio-presets)
