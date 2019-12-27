(in-package :luftstrom-display)

;;; audio-preset: 50

(digest-audio-args-preset
 '(:p1 0
   :p2 0
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
   :ampfn (* (sign) (n-exp y 1 1))
   :durfn (let ((val
                  (* (expt (/ v) (m-lin (mc-ref 13) 0 1))
                     (m-exp (mc-ref 14) 0.01 1) (m-exp-dev (mc-ref 15) 40))))
            val)
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (m-exp (mc-ref 9) 10 1000) (expt (m-exp (mc-ref 10) 1 10) y))
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 16) 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :bpfreq (n-exp (mc-ref 1) 1000 5000)
   :vowel (expt y (/ (mc-ref 11) 127))
   :voicetype (random 5)
   :voicepan (random 1.0)
   :bprq (m-lin (mc-ref 7) 1 0.01))
 (aref *audio-presets* 50))


(save-audio-presets)
