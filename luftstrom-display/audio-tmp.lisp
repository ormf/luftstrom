(in-package :luftstrom-display)

;;; audio-preset: 2

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (+ p2 (n-exp y 0.4 1.08))
   :ampfn (progn
            (* (sign) 1 (m-exp-zero (player-cc tidx 7) 0.01 1) (n-exp y 1.5 2.5)))
   :durfn (* 0.1 (r-exp 1 (m-exp (player-cc tidx 100) 1 10)))
   :suswidthfn 0
   :suspanfn (random 1.0)
   :decay-startfn 5.0e-4
   :decay-endfn 0.002
   :lfo-freqfn (* (n-exp-dev (n-ewi-note (player-note tidx)) 1.5) 50)
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (aref *cc-state* *nk2-chan* 23) 0 1)
   :filt-freqfn 20000)
 (aref *audio-presets* 2))


(save-audio-presets)
 
