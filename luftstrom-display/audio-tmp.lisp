(in-package :luftstrom-display)

;;; audio-preset: 92

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.4 1.2)
   :ampfn (* (sign) (m-exp-zero (player-cc tidx 7) 0.01 1) (r-lin 0.1 0.6))
   :durfn (n-exp y 0.8 0.16)
   :suswidthfn 0
   :suspanfn 0.3
   :decay-startfn 0.001
   :decay-endfn 0.02
   :lfo-freqfn (* (expt (round (* 16 y)) (n-lin x 1 (m-lin (nk2-ref 16) 1 1.5)))
                (hertz (m-lin (nk2-ref 17) 31 55)))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 23) 0 1)
   :filt-freqfn (n-exp y 200 10000))
 (aref *audio-presets* 92))


(save-audio-presets)
