(in-package :luftstrom-display)

;;; audio-preset: 103

(digest-audio-args-preset
 '(:cc-state #(0 109 0 127 0 0 0 58 0 0 0 9 52 0 40 127)
   :p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (n-exp y 0.1 1)
   :ampfn (* (sign) (n-exp y 8 1) (r-exp 0.3 4))
   :durfn (* (mc-exp 13 0.02 2) (mc-exp-dev 14 4))
   :suswidthfn 0.2
   :suspanfn 0
   :decaystartfn 0
   :decayendfn 0.01
   :lfofreqfn (mc-exp 12 1 80)
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (mc-exp 8 1000 10000)
   :bpfreq (n-exp y 1000 5000)
   :vwlinterp (mcn-ref 3)
   :voicepan (mcn-ref 1)
   :vowel y
   :voicetype (random 5)
   :bprq (mc-exp 15 1 0.02))
 (aref *audio-presets* 103))


(save-audio-presets)
