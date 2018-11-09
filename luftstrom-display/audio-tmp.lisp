(in-package :luftstrom-display)

;;; audio-preset: 16

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (n-exp y 0.4 1.2)
   :ampfn (* (sign) (m-exp-zero (player-cc tidx 7) 0.01 1) (+ 0.1 (random 0.6)))
   :durfn (n-exp y 0.8 0.16)
   :suswidthfn 0.1
   :suspanfn 0.3
   :decay-startfn 0.001
   :decay-endfn 0.02
   :lfo-freqfn (*
                (expt (round (* 16 y))
                 (n-lin x 1 (n-lin (/ (aref *cc-state* 4 16) 127) 1 1.2)))
                (m-exp (aref *cc-state* 4 17) 50 200))
   :x-posfn x
   :y-posfn y
   :wetfn 0.5
   :filt-freqfn (n-exp y 200 10000))
 (aref *audio-presets* 16))


(save-audio-presets)
