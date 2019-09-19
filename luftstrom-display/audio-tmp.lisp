(in-package :luftstrom-display)

;;; audio-preset: 94

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
   :ampfn (* (sign) (n-exp y 1 0.5) (m-exp-zero (nk2-ref 7) 0.01 2))
   :durfn (* (m-exp (nk2-ref 21) 0.1 1) (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (m-exp (nk2-ref 19) 0.25 1) (r-exp 45 45))
   :xposfn x
   :yposfn y
   :wetfn (m-lin (nk2-ref 23) 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :bpfreq (n-exp y 100 5000)
   :bprq (m-lin (nk2-ref 22) 1 0.01))
 (aref *audio-presets* 94))


(save-audio-presets)
