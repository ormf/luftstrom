(in-package :luftstrom-display)

;;; audio-preset: 0

(digest-audio-preset-form
 '(:cc-state #(0 0 0 23 0 50 125 127 0 0 0 0 0 0 0 127)
   :p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
   :ampfn (* (sign) (n-exp y 1 0.5))
   :durfn (* (m-exp (mc-ref 6) 0.1 1) (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (m-exp (mc-ref 4) 0.25 1) (r-exp 45 45))
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 8) 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :bpfreq (n-exp y 100 5000)
   :bprq (m-lin (mc-ref 7) 1 0.01))
 :audio-preset (aref *audio-presets* 0))


(save-audio-presets)
