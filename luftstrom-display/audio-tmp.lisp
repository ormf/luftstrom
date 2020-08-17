(in-package :luftstrom-display)

;;; audio-preset: 100

(digest-audio-preset-form
 '(:cc-state #(85 0 0 0 39 127 0 127 0 0 0 115 7 37 118 110)
   :p1 0
   :p2 0
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (n-exp y 0.45 0.83)
   :ampfn (* (sign) (n-exp y 1 0.5))
   :durfn (* (expt (min 2 (/ v)) (mcn-ref 9)) (m-exp (mc-ref 14) 0.1 1)
           (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (n-exp x 1 1.3)
               (expt (1+ (round (* 16 y (mcn-ref 11))))
                (m-lin (mc-ref 10) 1 1.5))
               (mc-exp 12 0.25 100) (mc-exp-dev 13 1.3))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 8 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :vowel y
   :voicetype (random 5)
   :voicepan (mcn-ref 1)
   :bpfreq (n-exp y 1000 5000)
   :bprq (mc-exp 15 1 0.01)
   :bppan (mcn-ref 16))
 :audio-preset (aref *audio-presets* 100))


(save-audio-presets)
