(in-package :luftstrom-display)

;;; audio-preset: 50

(digest-audio-args-preset
 '(:p1 0
   :p2 0
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
   :ampfn (* (sign) (n-exp y 1 0.5))
   :durfn (* (/ v) (m-exp (mc-ref 14) 0.1 1) (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (expt 2 y) (m-exp (mc-ref 12) 0.25 1) (r-exp 200 200))
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 16) 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :bpfreq (n-exp y 1000 5000)
   :vowel y
   :voicetype (random 5)
   :bprq (m-lin (mc-ref 15) 1 0.01))
 (aref *audio-presets* 50))


(save-audio-presets)
