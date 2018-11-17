(in-package :luftstrom-display)

;;; audio-preset: 0

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (+ p2 (n-exp y 0.4 1.08))
   :ampfn (progn
            (* (/ v 20)
               (min 1.0
                    (* (m-exp-zero (player-cc tidx 7) 0.01 10)
                       (m-exp (player-cc 4 7) 0.1 10)))
               (sign) (n-exp y 10 3.5)))
   :durfn 0.01
   :suswidthfn 0
   :suspanfn 0
   :decay-startfn 5.0e-4
   :decay-endfn 0.002
   :lfo-freqfn (r-exp 50 80)
   :x-posfn x
   :y-posfn y
   :wetfn 1
   :filt-freqfn 20000)
 (aref *audio-presets* 0))


(save-audio-presets)
