(in-package :luftstrom-display)

;;; audio-preset: 107

(digest-audio-preset-form
 '(:cc-state #(127 0 0 0 127 127 0 48 38 66 0 125 22 86 0 0)
   :p1 0
   :p2 0
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (n-exp y 0.4 1.2)
   :ampfn (* (sign) (+ 0.1 (random 0.6)))
   :durfn (n-exp y 0.8 0.16)
   :suswidthfn 0
   :suspanfn 0.3
   :decaystartfn 0.001
   :decayendfn 0.02
   :lfofreqfn (*
               (expt (round (* 16 y))
                (n-lin x (mc-lin 11 1 (/ 1.3)) (mc-lin 11 1 1.3)))
               (hertz (m-lin (mc-ref 10) 31 55)))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 8 0 1)
   :filtfreqfn (n-exp y 200 10000)
   :vowel y
   :voicetype (random 5)
   :voicepan (mcn-ref 1)
   :bpfreq (n-exp y 1000 5000)
   :bprq (mc-exp 15 1 0.01)
   :bppan (mcn-ref 16))
 :audio-preset (aref *audio-presets* 107))


(save-audio-presets)
