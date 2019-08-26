(in-package :luftstrom-display)

;;; audio-preset: 1

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (+ p2 (n-exp y 0.4 1.08))
   :ampfn (progn
            (* (sign) 1 (m-exp-zero (player-cc tidx 7) 0.01 1) (n-exp y 1.5 2.5)))
   :durfn (m-exp (player-cc tidx 100) 0.1 0.5)
   :suswidthfn 0.1
   :suspanfn 0
   :decay-startfn 5.0e-4
   :decay-endfn 0.002
   :lfo-freqfn (* (m-exp (player-note tidx) 1 10) 10)
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (aref *cc-state* *nk2-chan* 23) 0 1)
   :filt-freqfn 20000)
 (aref *audio-presets* 1))


(save-audio-presets)
