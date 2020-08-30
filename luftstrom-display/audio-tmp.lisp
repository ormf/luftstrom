(in-package :luftstrom-display)

;;; audio-preset: 3

(digest-audio-preset-form
 '(:cc-state #(1 0 0 0 127 127 0 0 23 127 127 127 0 125 127 127)
   :p1 (mcn-ref 6)
   :p2 (mcn-ref 5)
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (n-exp y 0.4 (mc-lin 13 0.8 1.2))
   :ampfn (* (sign) (n-lin p1 (+ 0.1 (random 0.6)) (n-exp y 0.7 0.35)))
   :durfn (n-lin p1 (n-lin p2 (n-exp y 0.8 0.16) (* p2 (mc-exp 14 0.1 0.5))) 0.5)
   :suswidthfn (n-lin p1 (* p2 0.5) 0.5)
   :suspanfn 0.3
   :decaystartfn (n-lin p1 (n-lin p2 0.001 0.03) 0.03)
   :decayendfn (n-lin p1 (n-lin p2 0.02 0.03) 0.03)
   :lfofreqfn (n-lin p1
               (n-lin p2
                (*
                 (expt (1+ (round (* 15 y (mcn-ref 11))))
                  (n-lin x 1 (mc-lin 12 1 1.5)))
                 (hertz (mc-lin 9 31 55)))
                (* (n-exp y 0.8 1.2) (mc-exp 9 50 400)
                 (n-exp-dev (mcn-ref 10) 0.5)))
               (* 12.5 (expt 2 (+ 2 (random 4)))))
   :xposfn x
   :yposfn y
   :wetfn (mcn-ref 16)
   :filtfreqfn (n-lin p1 (* (n-exp y 1 2) (mc-exp 13 100 10000)) 10000)
   :vowel y
   :voicetype (random 5)
   :voicepan (mcn-ref 1)
   :bpfreq (n-exp y (n-lin p2 1000 100) 5000)
   :bprq (mc-exp 15 1 0.01)
   :bppan (n-lin p1 (mc-lin 3 0 1) 0))
 :audio-preset (aref *audio-presets* 3))


(save-audio-presets)
