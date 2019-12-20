(in-package :luftstrom-display)

;;; audio-preset: 99

(digest-audio-args-preset
 '(:p1 0
   :p2 0
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (n-exp y 0.45 0.83)
   :ampfn (* (sign) (n-exp y 1 0.5))
   :durfn (* (expt (/ v) (mcn-ref 9)) (m-exp (mc-ref 14) 0.1 1) (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (n-exp x 1 1.1)
               (expt (round (1+ (* 16 y (mcn-ref 11))))
                (m-lin (mc-ref 10) 1 1.5))
               (m-exp (mc-ref 12) 0.25 4) 45)
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 16) 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :bpfreq (n-exp y 100 5000)
   :vowel y
   :voicetype (random 5)
   :voicepan (mcn-ref 1)
   :bprq (m-lin (mc-ref 15) 1 0.01))
 (aref *audio-presets* 99))


(save-audio-presets)
