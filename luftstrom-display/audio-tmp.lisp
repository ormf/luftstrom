(in-package :luftstrom-display)

;;; audio-preset: 2

(digest-audio-preset-form
 '(:cc-state #(0 4 127 0 0 0 0 127 43 0 0 0 0 13 58 127)
   :p1 (if (<= (mc-lin 6 0 1) (random 1.0))
           (* (expt (min 2 (/ v)) (mcn-ref 13)) (mc-exp 14 0.1 1) (r-exp 0.2 0.6))
           0.6)
   :p2 (if (<= (mcn-ref 5) (random 1.0))
           0
           1)
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (n-exp y 0.448 0.831)
   :ampfn (* (sign) (expt (mc-exp 8 0.1 1) p2) (db->amp (rand -10)))
   :durfn p1
   :suswidthfn (n-lin p2 0.3 0)
   :suspanfn (n-lin p2 0 0.3)
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* 1
               (expt
                (round
                 (1+
                  (*
                   (if (zerop p2)
                       1
                       15)
                   y (mcn-ref 11))))
                (n-lin x 1 (mc-lin 12 1 1.5)))
               (mtof (mc-lin 9 (n-lin p2 3.5 31) 55)) (mc-exp-dev 10 1.2))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (n-exp y (n-lin p2 1000 200) 10000)
   :vowel y
   :voicetype (random 5)
   :voicepan (mcn-ref 1)
   :bpfreq (n-exp y (n-lin p2 1000 100) 5000)
   :bprq (mc-exp 15 1 0.01)
   :bppan (mcn-ref 3))
 :audio-preset (aref *audio-presets* 2))


(save-audio-presets)
