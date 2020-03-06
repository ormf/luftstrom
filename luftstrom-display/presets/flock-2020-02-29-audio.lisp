(in-package :luftstrom-display)

(progn
(digest-audio-preset-form
'(:cc-state #(65 75 14 0 103 0 0 126 84 0 0 0 0 93 49 127)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.448 0.831)
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (* (expt (min 2 (/ v)) (mcn-ref 13)) (mc-exp 14 0.1 1) (r-exp 0.2 0.6))
:suswidthfn 0.3
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (mc-exp 9 11.25 500) (mc-exp-dev 10 1.4))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (n-exp y 1000 10000)
:bpfreq (n-exp y 100 5000)
:bppan 1
:bprq (mc-lin 15 1 0.01))
:audio-preset (aref *audio-presets* 0))
(digest-audio-preset-form
'(:cc-state #(127 0 127 0 0 0 0 0 0 0 0 0 0 0 0 127)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.45 1)
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (* (expt (min 2 (/ v)) (mcn-ref 13)) (mc-exp 14 0.1 1) (r-exp 0.2 0.6))
:suswidthfn 0.3
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (expt (1+ (round (* 16 y (mcn-ref 11)))) (mc-lin 12 1 1.5))
              (mc-exp 9 10 200) (mc-exp-dev 10 1.2))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (n-exp y 1000 10000)
:vowel y
:voicetype (random 5)
:voicepan (mcn-ref 1)
:bpfreq (n-exp y 1000 5000)
:bprq (mc-exp 15 1 0.01)
:bppan (mcn-ref 3))
:audio-preset (aref *audio-presets* 1))
(digest-audio-preset-form
'(:cc-state #(127 0 127 0 127 127 0 0 0 0 127 0 0 67 0 39)
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
:suswidthfn 0.3
:suspanfn 0
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
              (mtof (mc-lin 9 31 55)) (mc-exp-dev 10 1.2))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (n-exp y 1000 10000)
:vowel y
:voicetype (random 5)
:voicepan (mcn-ref 1)
:bpfreq (n-exp y 1000 5000)
:bprq (mc-exp 15 1 0.01)
:bppan (mcn-ref 3))
:audio-preset (aref *audio-presets* 2))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 127 0 0 0 0 113 0 0 0 127 127 127)
:p1 0
:p2 (mc-lin 5 0 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 (mc-lin 13 0.8 1.2))
:ampfn (* (sign) (+ 0.1 (random 0.6)))
:durfn (+ (* (- 1 p2) (n-exp y 0.8 0.16)) (* p2 (mc-exp 14 0.1 0.5)))
:suswidthfn (* p2 0.5)
:suspanfn 0.3
:decaystartfn (n-lin p2 0.001 0.03)
:decayendfn (n-lin p2 0.02 0.03)
:lfofreqfn (n-lin p2
                  (* (expt (1+ (round (* 16 y))) (n-lin x 1 (mc-lin 11 1 1.5)))
                     (hertz (mc-lin 9 31 55)))
                  (* (n-exp y 0.8 1.2) (mc-exp 9 50 400)
                     (n-exp-dev (mc-lin 10 0 1) 0.5)))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (* (n-exp y 1 2) (mc-exp 15 100 10000)))
:audio-preset (aref *audio-presets* 3))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 53 0 0 0 0 126 44 27)
:p1 (mc-lin 6 0 1)
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:synth 0
:pitchfn (n-exp y 0.4 (mc-lin 11 0.8 1.2))
:ampfn (* (sign) (n-exp y 0.7 0.35))
:durfn (m-exp (mc-ref 14) 0.1 0.5)
:suswidthfn 0.5
:suspanfn 0.3
:decaystartfn 0.03
:decayendfn 0.03
:lfofreqfn (+
            (* (- 1 p1) (n-exp y 0.8 1.2) (mc-exp 9 50 400)
               (n-exp-dev (mc-lin 10 0 1) 0.5))
            (* p1 12.5 (expt 2 (+ 2 (random 4)))))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (* (n-exp y 1 2) (m-exp (mc-ref 15) 100 10000)))
:audio-preset (aref *audio-presets* 4))
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
:audio-preset (aref *audio-presets* 5))
(digest-audio-preset-form
'(:cc-state #(70 48 0 0 127 2 0 127 8 0 127 125 22 86 125 0)
:p1 (if (> (random 1.0) (mcn-ref 5))
        1
        0)
:p2 (mcn-ref 5)
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
:lfofreqfn (+
            (* p2
               (expt (round (* 16 y))
                     (n-lin x (n-lin p2 (/ 1.3) 1) (n-lin p2 1.3 1)))
               (hertz (m-lin (mc-ref 10) 31 55)))
            (* (- 1 p2) (mc-lin 10 5 10)))
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
:audio-preset (aref *audio-presets* 6))
(digest-audio-preset-form
'(:cc-state #(127 0 0 43 39 127 0 127 97 0 0 127 43 43 80 123)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.45 0.9)
:ampfn (* (sign) (n-exp y 2 0.5))
:durfn (mc-exp 4 0.01 2)
:suswidthfn 0
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.02
:lfofreqfn (* (n-exp-dev 1 (n-lin x (mc-lin 12 1 0.8) (mc-lin 12 1 1.2)))
              (expt (+ 1 (round (* y (mc-lin 10 0 16)))) (mc-lin 11 1 1.5))
              (mc-exp 9 1 100))
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
:audio-preset (aref *audio-presets* 7))
(digest-audio-preset-form
'(:cc-state #(127 0 0 0 39 127 0 127 97 0 0 127 43 53 113 60)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.45 0.9)
:ampfn (* (sign) (n-exp y 2 0.5))
:durfn (mc-exp 14 0.01 2)
:suswidthfn 0
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.02
:lfofreqfn (* (n-exp-dev 1 (n-lin x (mc-lin 12 1 0.8) (mc-lin 12 1 1.2)))
              (expt (+ 1 (round (* y (mc-lin 10 0 16)))) (mc-lin 11 1 1.5))
              (mc-exp 9 1 100))
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
:audio-preset (aref *audio-presets* 8))
(digest-audio-preset-form
'(:cc-state #(0 30 0 0 39 127 0 127 96 0 0 127 7 42 91 113)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.45 1)
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (mc-exp 14 0.01 2)
:suswidthfn 0
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.02
:lfofreqfn (* (n-exp-dev 1 (n-lin x (mc-lin 12 1 0.8) (mc-lin 12 1 1.2)))
              (expt (+ 1 (round (* y (mc-lin 10 0 16)))) (mc-lin 11 1 1.5))
              (mc-exp 9 1 100))
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
:audio-preset (aref *audio-presets* 9))
(digest-audio-preset-form
'(:cc-state #(85 0 0 0 39 127 0 127 0 0 0 115 7 37 118 110)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.45 0.83)
:ampfn (* (sign) (n-exp y 1 0.5) (n-exp-zero (ewi-luft) 0.1 1))
:durfn (* (n-exp (ewi-biss) 0.1 1) (r-exp 0.2 0.6))
:suswidthfn 0.3
:suspanfn 0.1
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (n-exp x 1 1.3)
              (expt (1+ (round (* 16 y (m-lin (ewi-note) 0 1))))
                    (m-lin (mc-ref 10) 1 1.5))
              (mtof (n-lin (ewi-note) 3 20.0)) (mc-exp-dev 13 1.3))
:xposfn x
:yposfn y
:wetfn (mc-lin 8 0 1)
:filtfreqfn (n-exp y 1000 10000)
:vowel y
:voicetype (random 5)
:voicepan (+ (ewi-gl-up) (ewi-gl-down))
:bpfreq (n-exp y 1000 5000)
:bprq (n-exp (ewi-glide) 1 0.01)
:bppan 1)
:audio-preset (aref *audio-presets* 10))
(digest-audio-preset-form
'(:cc-state #(127 48 0 0 127 1 0 127 37 12 101 125 22 86 15 0)
:p1 (if (> (random 1.0) (mcn-ref 5))
        1
        0)
:p2 (mcn-ref 5)
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.6)) (n-exp-zero (ewi-luft) 0.1 1))
:durfn (* (n-exp y 0.6 0.16))
:suswidthfn 0
:suspanfn (- 1 (ewi-biss))
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (+
            (* 1 (expt (1+ (round (* 16 y))) (n-lin (ewi-glide) 1 1.3))
               (hertz (n-lin (- (ewi-gl-up) (ewi-gl-down)) 31 33))))
:xposfn x
:yposfn y
:wetfn (n-lin (ewi-biss) 0 1)
:filtfreqfn (n-exp y 200 10000)
:vowel y
:voicetype (random 5)
:voicepan (- 1 (ewi-glide))
:bpfreq (n-exp y 1000 5000)
:bprq (mc-exp 15 1 0.01)
:bppan (mcn-ref 16))
:audio-preset (aref *audio-presets* 11))
(digest-audio-preset-form
'(:cc-state #(0 0 0 112 0 0 0 0 127 0 0 0 0 127 0 127)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (sign) 0.5 (n-exp y 0.5 1)))
:durfn (* 0.1 (r-exp 1 (m-exp (mc-ref 14) 1 10)))
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (hertz (mc-lin 9 30 100)) (m-exp-dev (mc-ref 10) 4))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 16) 0 1)
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 12))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0)
:p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
        0.6
        (m-exp (mc-ref 5) 0.01 0.6))
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) 0.5 (n-exp y 1 0.5))
:durfn p1
:suswidthfn (+ 0.1 (random 0.3))
:suspanfn (random p1)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn 45
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (* (n-exp (random 1.0) 1 10) 1000))
:audio-preset (aref *audio-presets* 13))
(digest-audio-preset-form
'(:cc-state #(68 77 18 47 49 127 16 2 48 55 0 43 76 127 0 126)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (r-exp 0.7 1.3) (m-exp (mc-ref 7) 0.4 1.08))
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (r-exp 0.2 0.6)
:suswidthfn 0.3
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* 1 (r-exp 45 45))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp y 1000 10000))
:audio-preset (aref *audio-presets* 14))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.1)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (*
            (expt (round (* 16 y))
                  (n-lin x 1 (n-lin (/ (mc-ref 16) 127) 1 1.2)))
            100)
:xposfn x
:yposfn y
:wetfn 0.5
:filtfreqfn (n-exp y 200 10000))
:audio-preset (aref *audio-presets* 15))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.6)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (* (n-exp x 1 1.2)
              (expt (round (* 16 y)) (n-lin x 1 (m-lin (mc-ref 1) 1 1.2)))
              (hertz (m-lin (mc-ref 2) 31 55)))
:xposfn x
:yposfn y
:wetfn 0.5
:filtfreqfn (n-exp y 200 10000))
:audio-preset (aref *audio-presets* 16))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 0
:p2 (mc-lin 5 0 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 (mc-lin 4 0.8 1.2))
:ampfn (* (sign) (+ 0.1 (random 0.6)))
:durfn (+ (* (- 1 p2) (n-exp y 0.8 0.16)) (* p2 (mc-exp 1 0.1 0.5)))
:suswidthfn (* p2 0.5)
:suspanfn 0.3
:decaystartfn (n-lin p2 0.001 0.03)
:decayendfn (n-lin p2 0.02 0.03)
:lfofreqfn (n-lin p2
                  (* (expt (1+ (round (* 16 y))) (n-lin x 1 (mc-lin 1 1 1.5)))
                     (hertz (mc-lin 2 31 55)))
                  (* (n-exp y 0.8 1.2) (mc-exp 3 50 400)
                     (n-exp-dev (mc-lin 2 0 1) 0.5)))
:xposfn x
:yposfn y
:wetfn (mc-lin 7 0 1)
:filtfreqfn (* (n-exp y 1 2) (mc-exp 8 100 10000)))
:audio-preset (aref *audio-presets* 17))
(digest-audio-preset-form
'(:cc-state #(127 113 0 0 0 13 127 127 0 0 0 0 0 0 0 117)
:p1 (mc-lin 6 0 1)
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.4 (mc-lin 4 0.8 1.2))
:ampfn (* (sign) (n-exp y 0.7 0.35))
:durfn (m-exp (mc-ref 1) 0.1 0.5)
:suswidthfn 0.5
:suspanfn 0.3
:decaystartfn 0.03
:decayendfn 0.03
:lfofreqfn (+
            (* (- 1 p1) (n-exp y 0.8 1.2) (m-exp (mc-ref 3) 50 400)
               (n-exp-dev (mc-lin 2 0 1) 0.5))
            (* p1 12.5 (expt 2 (+ 2 (random 4)))))
:xposfn x
:yposfn y
:wetfn (mc-lin 7 0 1)
:filtfreqfn (* (n-exp y 1 2) (m-exp (mc-ref 8) 100 10000))
:voicepan 0
:vowel (random 5)
:bpfreq 1000
:bppan (mcn-ref 3)
:bprq (mc-exp 15 0.01 1))
:audio-preset (aref *audio-presets* 18))
(digest-audio-preset-form
'(:cc-state #(98 3 102 0 0 6 121 127 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 0.8)
:ampfn (* 0.5 (sign) (+ 0.1 (random 0.8)))
:durfn (n-exp (random 1.0) 0.01 0.8)
:suswidthfn 0.5
:suspanfn 0
:decaystartfn 0.03
:decayendfn 0.03
:lfofreqfn (* (mc-exp 2 0.125 1) 30.5
              (expt (expt 2 (random (1+ (round (mc-lin 4 0 8)))))
                    (mc-lin 3 1 1.1)))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (mc-exp 8 100 10000))
:audio-preset (aref *audio-presets* 19))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 2 99 127 0 0 0 0 0 0 0 3)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.6)))
:durfn (m-exp (mc-ref 3) 0.01 0.8)
:suswidthfn 0.1
:suspanfn 0
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (*
            (expt (round (* 16 y))
                  (n-lin x (m-lin (mc-ref 2) 1 1) (m-lin (mc-ref 2) 1 1.2)))
            (m-exp (mc-ref 1) 25 200))
:xposfn x
:yposfn y
:wetfn 0.5
:filtfreqfn 20000
:bpfreq (m-exp (mc-ref 7) 100 5000)
:bprq (m-exp (mc-ref 8) 1 0.1))
:audio-preset (aref *audio-presets* 20))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.8)))
:durfn (n-exp (random 1.0) 0.01 0.4)
:suswidthfn 0.2
:suspanfn 0
:decaystartfn 0.001
:decayendfn 0.002
:lfofreqfn 50
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp (random 1.0) 1000 20000))
:audio-preset (aref *audio-presets* 21))
(digest-audio-preset-form
'(:cc-state #(0 0 4 120 0 50 0 0 0 0 0 0 0 0 0 0)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 0.5)
:ampfn (* (sign) (r-exp 0.5 1))
:durfn (m-exp (mc-ref 6) 0.5 0.01)
:suswidthfn 0.3
:suspanfn (m-lin (mc-ref 5) 0 1)
:decaystartfn 0.01
:decayendfn 0.06
:lfofreqfn (let ((pwidth (round (m-lin (mc-ref 4) -10 16))))
             (* (expt 1.1 (random 1.0)) (hertz (mc-lin 3 3 80))
                (round (* y pwidth))))
:xposfn x
:yposfn y
:wetfn (mc-lin 8 0 1)
:filtfreqfn 20000
:bpfreq (n-exp y 200 5000)
:bprq 1)
:audio-preset (aref *audio-presets* 22))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 127 76 0 111 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 0.5)
:ampfn (* (sign) (n-exp y 1 2) (r-exp 0.5 2))
:durfn (m-exp (mc-ref 7) 0.5 0.01)
:suswidthfn 0.3
:suspanfn (+ 0.3 (mc-lin-dev 9 0.3))
:decaystartfn 0.01
:decayendfn 0.06
:lfofreqfn (let ((pwidth (round (m-lin (mc-ref 8) 1 16))))
             (declare (ignore pwidth))
             (* (expt 1.1 (random 1.0)) (hertz (m-lin (mc-ref 7) 30 120))))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000
:bpfreq (* (mc-exp-dev 6 1.3) (m-exp (mc-ref 7) 200 5000))
:bprq 0.01)
:audio-preset (aref *audio-presets* 23))
(digest-audio-preset-form
'(:cc-state #(0 0 0 98 0 12 54 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 0.5)
:ampfn (* (sign) (n-exp y 1 2) (r-exp 0.5 2))
:durfn (* (mc-exp-dev 3 1.5) (mc-exp 4 0.01 0.3))
:suswidthfn 0.1
:suspanfn (r-lin 0 1)
:decaystartfn 0.01
:decayendfn 0.06
:lfofreqfn (* (expt 1.1 (random 1.0)) (hertz (m-lin (mc-ref 6) 30 120)))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (m-exp y 1000 20000))
:audio-preset (aref *audio-presets* 24))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.5)
:ampfn (* (sign) (n-exp y 1 20) (r-exp 0.5 2))
:durfn (n-exp y 0.05 0.005)
:suswidthfn 0.01
:suspanfn 0
:decaystartfn 0.01
:decayendfn 0.06
:lfofreqfn (n-exp y 100 3000)
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (m-exp y 1000 20000))
:audio-preset (aref *audio-presets* 25))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.5)
:ampfn (* (sign) (n-exp y 1 20) (r-exp 0.5 2))
:durfn (n-exp y 0.05 0.005)
:suswidthfn 0.01
:suspanfn 0
:decaystartfn 0.01
:decayendfn 0.06
:lfofreqfn (* (/ (round (* 16 y)) 16) (m-exp (mc-ref 3) 1 2) 1500)
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (m-exp y 1000 20000))
:audio-preset (aref *audio-presets* 26))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (m-exp (mc-ref 1) 0.1 0.5)
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (n-exp y 0.8 1.2) (m-exp (mc-ref 3) 50 400)
              (n-exp-dev (m-lin (mc-ref 2) 0 1) 0.5))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 7) 0 1)
:filtfreqfn (* (n-exp y 1 2) (m-exp (mc-ref 8) 100 10000)))
:audio-preset (aref *audio-presets* 27))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 127 108 101 0 111 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 0.5)
:ampfn (* (sign) (n-exp y 1 2) (r-exp 0.5 2))
:durfn (m-exp (mc-ref 5) 0.5 0.01)
:suswidthfn 0.3
:suspanfn (+ 0.3 (mc-lin-dev 9 0.3))
:decaystartfn 0.01
:decayendfn 0.06
:lfofreqfn (let ((pwidth (round (m-lin (mc-ref 8) 1 16))))
             (declare (ignore pwidth))
             (* (expt 1.1 (random 1.0)) (hertz (m-lin (mc-ref 7) 30 120))))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000
:bpfreq (* (mc-exp-dev 6 1.3) (m-exp (mc-ref 7) 200 5000))
:bprq 0.01)
:audio-preset (aref *audio-presets* 28))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 29))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn 0.6
:ampfn (m-exp-zero (mc-ref 16) 0.01 1.0)
:durfn 0.8
:suswidthfn 0
:suspanfn 0
:decaystartfn 0.001
:decayendfn 0.1
:lfofreqfn 1
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 30))
(digest-audio-preset-form
'(:cc-state #(127 53 127 0 127 127 127 127 0 2 73 0 9 69 0 42)
:p1 (if (<= (random 1.0) (mc-lin 6 0 1))
        0.6
        (mc-exp 4 0.01 0.6))
:p2 (if (<= (random 1.0) (mcn-ref 5))
        1
        0)
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.448 0.831)
:ampfn (* (sign) (expt (mc-exp 8 0.1 1) p2) (r-exp 0.2 0.6))
:durfn p1
:suswidthfn 0
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.002
:lfofreqfn (* 1
              (expt
               (round
                (*
                 (if (zerop p2)
                     1
                     16)
                 y))
               (n-lin x 1 (mc-lin 12 1 1.5)))
              (mtof (mc-lin 9 31 55)) (mc-exp-dev 10 1.2))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (n-exp y 200 10000)
:bpfreq (n-exp y 100 5000)
:bprq (mc-exp 15 1 0.01)
:bppan (mcn-ref 3)
:vowel y
:voicetype (random 5)
:voicepan (mcn-ref 1))
:audio-preset (aref *audio-presets* 31))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (mc-exp-zero 8 0.01 1) (+ 0.1 (random 0.6)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (* (expt (1+ (round (* 16 y))) (n-lin x 1 (mc-lin 12 1 1.5)))
              (hertz (mc-lin 9 31 55)) (n-exp-dev (mc-lin 10 0 1) 1.5))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (n-exp y 200 10000))
:audio-preset (aref *audio-presets* 32))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 (if (<= (random 1.0) (mc-lin 6 0 1))
        0.8
        (mc-exp 4 0.01 0.8))
:p2 (if (<= (random 1.0) (mc-lin 5 0 1))
        1
        0)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.256 0.77)
:ampfn (* (sign) (expt (mc-exp 8 0.1 1) p2) (mc-exp-zero 7 0.01 1)
          (+ 0.1 (random 0.6)))
:durfn p1
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (*
            (expt
             (round
              (*
               (if (zerop p2)
                   1
                   (1+ (round (mc-lin 11 1 16))))
               y))
             (n-lin x 1 (mc-lin 12 1 1.5)))
            (hertz (mc-lin 9 31 55)))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (n-exp y 200 10000)
:bpfreq (n-exp y 100 5000)
:bprq (mc-lin 15 1 0.01))
:audio-preset (aref *audio-presets* 33))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 50 0 127)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.448 0.831)
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (* (mc-exp 14 0.1 1) (r-exp 0.2 0.6))
:suswidthfn 0.3
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (mc-exp 9 11.25 45)
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (n-exp y 1000 10000)
:bpfreq (n-exp y 100 5000)
:bprq (mc-lin 15 1 0.01))
:audio-preset (aref *audio-presets* 34))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 35))
(digest-audio-preset-form
'(:cc-state #(127 6 9 0 121 127 0 55 18 48 36 54 9 0 122 60)
:p1 10
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.6)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (* (n-exp x 1 1.2)
              (expt (round (* 16 y)) (n-lin x 1 (m-lin (mc-ref 6) 1 1.2)))
              (hertz (m-lin (mc-ref 10) 31 55)))
:xposfn x
:yposfn y
:wetfn 0.5
:filtfreqfn (n-exp y 200 10000))
:audio-preset (aref *audio-presets* 36))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) 0.125 (+ 0.1 (random 0.6)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (* (n-exp x 1 1.2)
              (expt (round (* 16 y)) (n-lin x 1 (m-lin (mc-ref 6) 1 1.2)))
              (hertz (ewi-nlin tidx 31 55)))
:xposfn x
:yposfn y
:wetfn 0.5
:filtfreqfn (n-exp y 200 10000))
:audio-preset (aref *audio-presets* 37))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.8)))
:durfn (n-exp (random 1.0) 0.01 0.8)
:suswidthfn 0.2
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.002
:lfofreqfn (* (hertz (ewi-nlin tidx 10 50)) (expt 2 (o-x tidx))
              (expt (round (* y 16)) (m-lin (mc-ref 6) 1 1.5)))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp (random 1.0) 100 10000))
:audio-preset (aref *audio-presets* 38))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.8)))
:durfn (n-exp (random 1.0) 0.01 0.8)
:suswidthfn 0.2
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.002
:lfofreqfn (* (hertz (ewi-nlin tidx 10 50)) (expt 2 (o-x tidx))
              (expt (round (* y 16)) (m-lin (mc-ref 6) 1 1.5)))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp (random 1.0) 100 10000))
:audio-preset (aref *audio-presets* 39))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (case tidx (1 (r-exp 50 80)) (otherwise (r-exp 50 80)))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 40))
(digest-audio-preset-form
'(:cc-state #(0 0 0 56 89 18 0 0 76 40 118 1 16 90 108 126)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.8)))
:durfn (n-exp (random 1.0) 0.01 0.8)
:suswidthfn 0.2
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.002
:lfofreqfn (* (hertz (m-lin (mc-ref 4) 10 50)) (expt 2 (o-x tidx))
              (expt (round (* y (round (m-lin (mc-ref 5) 1 16))))
                    (m-exp-dev (mc-ref 6) 1.5)))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp (random 1.0) 100 10000))
:audio-preset (aref *audio-presets* 41))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 42))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 43))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ 0.5 (* 0.1 y))
:ampfn (* (sign) 0.2)
:durfn 0.1
:suswidthfn 1
:suspanfn 0
:decaystartfn 0.5
:decayendfn 0.06
:lfofreqfn 1
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 44))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (case tidx (1 (+ 0.5 (* 0.1 y))) (otherwise (+ p2 (n-exp y 0.4 1.08))))
:ampfn (case tidx
         (1 (* (/ v 20) (sign) 2))
         (otherwise (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))))
:durfn (case tidx (1 0.1) (otherwise 0.5))
:suswidthfn (case tidx (1 1) (otherwise 0))
:suspanfn (case tidx (1 0) (otherwise (random 1.0)))
:decaystartfn (case tidx (1 0.5) (otherwise 5.0e-4))
:decayendfn (case tidx (1 0.06) (otherwise 0.002))
:lfofreqfn (case tidx (1 1) (otherwise (r-exp 50 80)))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 45))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) (n-exp y 1 0.5) (m-exp-zero (mc-ref 16) 0.01 2))
:durfn (* (/ v) (m-exp (mc-ref 6) 0.1 1) (r-exp 0.2 0.6))
:suswidthfn 0.3
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (m-exp (mc-ref 4) 0.25 1) (r-exp 500 500))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (n-exp y 1000 10000)
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 7) 1 0.01)
:cc-state #(80 30 29 76 29 16 33 62 39 24 17 30 24 111 25 53))
:audio-preset (aref *audio-presets* 46))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ 0.5 (* 0.1 y))
:ampfn (* (/ v 20) (sign) 2)
:durfn 0.2
:suswidthfn 0.99
:suspanfn 0.01
:decaystartfn 0.5
:decayendfn 0.06
:lfofreqfn 1
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 47))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (* (/ v 20) (sign) (n-exp y 3 1.5))
:durfn 0.1
:suswidthfn 0
:suspanfn 0.0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (expt 3.5 y) (m-exp (mc-ref 1) 1 2) (m-exp (mc-ref 2) 1 10)
              (r-exp 5 5))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp y 1000 20000))
:audio-preset (aref *audio-presets* 48))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (* (/ v 20) (sign) (n-exp y 3 1.5))
:durfn (* (m-exp (mc-ref 3) 1 4) (+ 0.05 (random 0.4)))
:suswidthfn 0.2
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (*
            (expt (round (* (round (m-lin (mc-ref 6) 1 16.0)) y))
                  (float (m-lin (mc-ref 2) 0.5 2)))
            (m-exp (mc-ref 1) 1 2) (m-exp (mc-ref 5) 1 10) (r-exp 5 5))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (n-exp y 1000 20000))
:audio-preset (aref *audio-presets* 49))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 70 93 118 1 127 37 82 107)
:p1 0
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
:audio-preset (aref *audio-presets* 50))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (let ((val
              (* (expt (/ v) (m-lin (mc-ref 13) 0 1))
                 (m-exp (mc-ref 14) 0.01 1))))
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
:bpfreq (n-exp y 1000 5000)
:vowel (expt y (/ (mc-ref 11) 127))
:voicetype (random 5)
:bprq (m-lin (mc-ref 15) 1 0.01))
:audio-preset (aref *audio-presets* 51))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (r-exp 0.7 1.3) (m-exp (mc-ref 7) 0.4 1.08))
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (r-exp 0.2 0.6)
:suswidthfn 0.3
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (r-exp 0.8 (/ 0.8)) (r-exp 45 45))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp y 1000 10000))
:audio-preset (aref *audio-presets* 52))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 53))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.5 (random 0.5)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (*
            (expt (round (* (m-lin (mc-ref 1) 1 16) y))
                  (m-lin (mc-ref 2) 1 25/24))
            50)
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000
:bpfreq (m-exp (mc-ref 3) 100 10000)
:bprq (m-exp (mc-ref 4) 1 0.01))
:audio-preset (aref *audio-presets* 54))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (n-exp y 1 0.01) (sign) (+ 0.5 (random 0.5)))
:durfn (n-exp y 3.8 0.76)
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (* (m-exp (mc-ref 1) 25/24 1)
              (expt (round (* (m-lin (mc-ref 2) 1 16) y))
                    (m-lin (mc-ref 3) 1 25/24))
              50)
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (n-exp y 200 10000)
:bpfreq (m-exp (mc-ref 6) 100 10000)
:bprq (m-exp (mc-ref 7) 1 0.01))
:audio-preset (aref *audio-presets* 55))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 56))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 57))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 58))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 59))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (sign) (n-exp y 1.5 2.5)))
:durfn (* (r-exp 0.9 (/ 0.9)) 0.5)
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (n-exp y 1 10) (r-exp 0.8 1.2) (hertz (m-lin (mc-ref 6) 30 50)))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000
:bpfreq (hertz (n-lin y 10 100))
:bprq (m-lin (mc-ref 7) 5 0.01))
:audio-preset (aref *audio-presets* 60))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (sign) 1 (n-exp y 1.5 2.5)))
:durfn (* (m-exp (mc-ref 5) 0.01 1) (r-exp 0.9 (/ 0.9)) 0.5)
:suswidthfn 0.1
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (n-exp y 1 (m-lin (mc-ref 4) 1 20))
              (n-exp-dev (m-lin (mc-ref 2) 0 1) 2)
              (hertz (m-lin (mc-ref 3) 10 108)))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000
:bpfreq (hertz (n-lin y 10 100))
:bprq (m-lin (mc-ref 7) 5 0.01))
:audio-preset (aref *audio-presets* 61))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 62))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 63))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 64))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 65))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 66))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 67))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 68))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 69))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 (random 1.0)
:p2 (m-exp (mc-ref 3) 0.5 2)
:p3 (pick 10 10 150 200 50 100 100 100)
:p4 0
:synth 0
:pitchfn (* p2 (+ 0.5 (n-exp y 0.1 (m-exp (mc-ref 2) 0.5 2))))
:ampfn (* (n-exp y 0.125 0.5) (+ 0.2 (* (sign) (random 0.5))))
:durfn (* (m-exp (mc-ref 4) 1 10) (n-exp y 0.05 0.01))
:suswidthfn 0.2
:suspanfn (r-lin 0 (m-lin (mc-ref 6) 0 1))
:decaystartfn 0.5
:decayendfn 0.01
:lfofreqfn p3
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (m-exp (mc-ref 7) 100 20000))
:audio-preset (aref *audio-presets* 70))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 (random 1.0)
:p2 (m-exp (mc-ref 3) 0.5 2)
:p3 (* 10
       (seq-ip-pick (m-lin (mc-ref 1) 0 1) '(10 22 29 42 47 62 71 80)
                    '(10 19 32 29 53 63 75 79)))
:p4 0
:synth 0
:pitchfn (* p2 (+ 0.5 (n-exp y 0.1 (m-exp (mc-ref 2) 0.5 2))))
:ampfn (* (n-exp y 0.125 0.5) (+ 0.2 (* (sign) (random 0.5))))
:durfn (* (m-exp (mc-ref 4) 1 10) (n-exp y 0.05 0.01))
:suswidthfn 0.2
:suspanfn (r-lin 0 (m-lin (mc-ref 6) 0 1))
:decaystartfn 0.5
:decayendfn 0.01
:lfofreqfn p3
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (m-exp (mc-ref 7) 100 20000))
:audio-preset (aref *audio-presets* 71))
(digest-audio-preset-form
'(:cc-state #(0 53 0 99 0 0 127 0 0 0 0 0 0 0 0 0)
:p1 (random 1.0)
:p2 (m-exp (mc-ref 3) 0.5 2)
:p3 (* 10
       (seq-ip-pick (m-lin (mc-ref 1) 0 1) '(10 22 29 42 47 62 71 80)
                    '(10 19 32 29 53 63 75 79)))
:p4 0
:synth 0
:pitchfn (* p2 (+ 0.5 (n-exp y (mc-lin 2 0.3 0.8) (mc-lin 2 0.5 1))))
:ampfn (* (n-exp y 0.3 0.5) (+ 0.2 (* (sign) (random 0.5))))
:durfn (* (mc-exp 4 1 2) (n-exp y 0.1 0.2))
:suswidthfn 0.2
:suspanfn (r-lin 0 (mc-lin 6 0 1))
:decaystartfn 0.5
:decayendfn 0.01
:lfofreqfn 10
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (m-exp (mc-ref 7) 100 20000))
:audio-preset (aref *audio-presets* 72))
(digest-audio-preset-form
'(:cc-state #(0 73 0 91 0 0 127 126 0 0 0 0 0 0 0 0)
:p1 (random 1.0)
:p2 (m-exp (mc-ref 3) 0.5 2)
:p3 (* 10
       (seq-ip-pick (m-lin (mc-ref 1) 0 1) '(10 22 29 42 47 62 71 80)
                    '(10 19 32 29 53 63 75 79)))
:p4 0
:synth 0
:pitchfn (* p2 (+ 0.5 (n-exp y 0.1 (m-exp (mc-ref 2) 0.5 2))))
:ampfn (* (n-exp y 0.125 0.5) (+ 0.2 (* (sign) (random 0.5))))
:durfn (* (m-exp (mc-ref 4) 1 10) (n-exp y 0.05 0.01))
:suswidthfn 0.3
:suspanfn (r-lin 0 (m-lin (mc-ref 6) 0 1))
:decaystartfn 0.01
:decayendfn 0.5
:lfofreqfn 1
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (m-exp (mc-ref 7) 100 20000))
:audio-preset (aref *audio-presets* 73))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 74))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 75))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 76))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 77))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 78))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 79))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 80))
(digest-audio-preset-form
'(:cc-state #(127 0 123 119 119 0 93 119 17 102 37 127 65 99 69 80)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 81))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 82))
(digest-audio-preset-form
'(:cc-state #(0 0 0 15 127 127 0 0 54 23 109 57 0 116 0 127)
:p1 (if (<= (random 1.0) (m-lin (mc-ref 7) 0 1))
        0.6
        (m-exp (mc-ref 5) 0.01 0.6))
:p2 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
        1
        0)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.4 1.2) 0.63951963)
:ampfn (* (sign) (+ 0.1 (random 0.6)))
:durfn p1
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (*
            (expt
             (+ 1
                (round
                 (*
                  (if (zerop p2)
                      0
                      16)
                  y)))
             (n-lin x 1 (m-lin (mc-ref 2) 1 1.2)))
            (hertz (m-lin (mc-ref 1) 31 55))
            (n-exp-dev (m-lin (mc-ref 3) 0 1) 1.1))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 16) 0 1)
:filtfreqfn (n-exp y 200 10000)
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 15) 1 0.01))
:audio-preset (aref *audio-presets* 83))
(digest-audio-preset-form
'(:cc-state #(0 75 14 0 11 127 107 127 0 5 67 33 0 0 116 127)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 84))
(digest-audio-preset-form
'(:cc-state #(0 0 0 127 100 29 0 127 55 22 111 57 0 116 0 127)
:p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
        0.6
        (m-exp (mc-ref 4) 0.01 0.6))
:p2 (if (<= (random 1.0) (m-lin (mc-ref 5) 0 1))
        1
        0)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.4 1.2) 0.63951963)
:ampfn (* (sign) (+ 0.1 (random 0.6)))
:durfn p1
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (*
            (expt
             (+ 1
                (round
                 (*
                  (if (zerop p2)
                      0
                      16)
                  y)))
             (n-lin x 1 (m-lin (mc-ref 2) 1 1.5)))
            (hertz (m-lin (mc-ref 1) 31 55))
            (n-exp-dev (m-lin (mc-ref 3) 0 1) 1.5))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 16) 0 1)
:filtfreqfn (n-exp y 200 10000)
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 15) 1 0.01))
:audio-preset (aref *audio-presets* 85))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 86))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 87))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 88))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
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
:lfofreqfn (hertz (ewi-nlin tidx 1 40))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (n-exp y 1000 10000)
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 7) 1 0.01))
:audio-preset (aref *audio-presets* 89))
(digest-audio-preset-form
'(:cc-state #(127 127 0 46 127 1 0 127 22 22 0 127 0 127 127 127)
:p1 (if (<= (random 1.0) (m-lin (mc-ref 14) 0 1))
        0.1
        (m-exp (mc-ref 12) 0.01 0.6))
:p2 (if (<= (random 1.0) (m-lin (mc-ref 13) 0 1))
        1
        0)
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.4 0.8)
:ampfn (n-exp y 1 0.5)
:durfn (mc-exp 14 0.01 10)
:suswidthfn 0
:suspanfn 0
:decaystartfn 0.001
:decayendfn 0.002
:lfofreqfn (mc-exp 11 0.1 100)
:xposfn x
:yposfn y
:wetfn (mc-lin 8 0 1)
:filtfreqfn (n-exp y 200 10000)
:voicepan (mcn-ref 1)
:voicetype (round (mc-lin 2 0 4))
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 15) 1 0.01)
:bppan (mcn-ref 16))
:audio-preset (aref *audio-presets* 90))
(digest-audio-preset-form
'(:cc-state #(63 39 0 46 127 1 0 0 22 22 3 127 0 0 43 46)
:p1 (if (<= (random 1.0) (m-lin (mc-ref 14) 0 1))
        0.6
        (m-exp (mc-ref 12) 0.01 0.6))
:p2 (if (<= (random 1.0) (m-lin (mc-ref 13) 0 1))
        1
        0)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.8 0.8)
:ampfn 1
:durfn p1
:suswidthfn 0
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.002
:lfofreqfn (*
            (expt
             (round
              (*
               (if (zerop p2)
                   1
                   16)
               y))
             (n-lin x 1 (m-lin (mc-ref 9) 1 1.5)))
            (hertz (m-lin (mc-ref 10) 11 55))
            (n-exp-dev (m-lin (mc-ref 11) 0 1) 1.5))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 16) 0 1)
:filtfreqfn (n-exp y 200 10000)
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 15) 1 0.01))
:audio-preset (aref *audio-presets* 91))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 123 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.6)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (* (expt (round (* 16 y)) (n-lin x 1 (m-lin (mc-ref 9) 1 1.5)))
              (hertz (m-lin (mc-ref 10) 31 55)))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (n-exp y 200 10000))
:audio-preset (aref *audio-presets* 92))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
        0.8
        (m-exp (mc-ref 4) 0.01 0.8))
:p2 (if (<= (random 1.0) (m-lin (mc-ref 5) 0 1))
        1
        0)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.4 1.2) 0.63951963)
:ampfn (* (sign) (expt (m-exp (mc-ref 14) 0.1 1) p2) (+ 0.1 (random 0.6)))
:durfn p1
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (*
            (expt
             (round
              (*
               (if (zerop p2)
                   1
                   (round (m-lin (mc-ref 3) 1 16)))
               y))
             (n-lin x 1 (m-lin (mc-ref 1) 1 1.5)))
            (hertz (m-lin (mc-ref 2) 31 55)))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (n-exp y 200 10000)
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 7) 1 0.01))
:audio-preset (aref *audio-presets* 93))
(digest-audio-preset-form
'(:cc-state #(65 75 14 0 11 71 0 127 0 0 0 0 0 0 0 127)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) (n-exp y 1 0.5) (m-exp-zero (mc-ref 16) 0.01 2))
:durfn (* (/ v) (m-exp (mc-ref 6) 0.1 1) (r-exp 0.2 0.6))
:suswidthfn 0.3
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (mc-exp 4 0.25 1) (r-exp 500 500))
:xposfn x
:yposfn y
:wetfn (mc-lin 8 0 1)
:filtfreqfn (n-exp y 1000 10000)
:bpfreq (n-exp y 100 5000)
:bprq (mc-lin 7 1 0.01))
:audio-preset (aref *audio-presets* 94))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
        0.6
        (m-exp (mc-ref 5) 0.01 0.6))
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) 1 (n-exp y 1 0.5))
:durfn p1
:suswidthfn (+ 0.1 (random 0.3))
:suspanfn (random p1)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn 45
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (* (n-exp (random 1.0) 1 10) 1000))
:audio-preset (aref *audio-presets* 95))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (r-exp 0.2 0.6)
:suswidthfn 0.3
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* 1 (r-exp 45 45))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (n-exp y 1000 10000)
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 7) 1 0.01))
:audio-preset (aref *audio-presets* 96))
(digest-audio-preset-form
'(:cc-state #(0 30 60 28 70 0 41 13 9 9 35 54 26 50 16 17)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.6)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (*
            (expt (round (* 16 y))
                  (n-lin x 1 (n-lin (/ (mc-ref 2) 127) 1 1.2)))
            (n-exp (ewi-lin (mc-ref 3) 0 1) 50 200))
:xposfn x
:yposfn y
:wetfn 0.5
:filtfreqfn (n-exp y 200 10000))
:audio-preset (aref *audio-presets* 97))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (sign) 1 (n-exp y 1.5 2.5)))
:durfn (* (m-exp 25 0.01 1) (r-exp 0.9 (/ 0.9)) 0.5)
:suswidthfn 0.1
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (n-exp (ewi-lin (mc-ref 2) 0 1) 1 15) (n-exp-dev 0.653 2)
              129.39264)
:xposfn x
:yposfn y
:wetfn (m-lin 0 0 1)
:filtfreqfn 20000
:bpfreq (hertz (n-lin y 10 100))
:bprq (m-lin 0 5 0.01))
:audio-preset (aref *audio-presets* 98))
(digest-audio-preset-form
'(:cc-state #(127 30 127 0 39 127 0 27 59 0 3 123 9 56 0 127)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.45 1)
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (* (expt (min 2 (/ v)) (mcn-ref 13)) (m-exp (mc-ref 14) 0.1 1)
          (r-exp 0.2 0.6))
:suswidthfn 0.3
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (n-exp x 1 1)
              (expt (1+ (round (* 16 y (mcn-ref 11)))) (mc-lin 12 1 1.5))
              (mc-exp 9 0.25 4) 45 (mc-exp-dev 10 1.2))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (n-exp y 1000 10000)
:vowel y
:voicetype (random 5)
:voicepan (mcn-ref 1)
:bpfreq (n-exp y 1000 5000)
:bprq (mc-exp 15 1 0.01)
:bppan (mcn-ref 3))
:audio-preset (aref *audio-presets* 99))
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
(digest-audio-preset-form
'(:cc-state #(127 48 0 0 127 1 0 127 37 12 101 125 22 86 15 0)
:p1 (if (> (random 1.0) (mcn-ref 5))
        1
        0)
:p2 (mcn-ref 5)
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.6)))
:durfn (* (n-exp y 0.6 0.16))
:suswidthfn 0
:suspanfn 0
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (+
            (* 1 (expt (1+ (round (* 16 y))) (n-lin (ewi-glide) 1 1.3))
               (hertz 31)))
:xposfn x
:yposfn y
:wetfn (n-lin (ewi-biss) 0 1)
:filtfreqfn (n-exp y 200 10000)
:vowel y
:voicetype (random 5)
:voicepan (mcn-ref 1)
:bpfreq (n-exp y 1000 5000)
:bprq (mc-exp 15 1 0.01)
:bppan (mcn-ref 16))
:audio-preset (aref *audio-presets* 101))
(digest-audio-preset-form
'(:cc-state #(127 26 0 96 0 0 76 127 0 0 0 99 98 0 0 127)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 1
:pitchfn (mc-exp 4 0.45 1)
:ampfn (* (sign) 1)
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
:voicetype (mc-lin 3 0 4)
:bprq (mc-lin 15 1 0.01))
:audio-preset (aref *audio-presets* 102))
(digest-audio-preset-form
'(:cc-state #(127 47 0 127 0 0 0 58 0 127 0 88 46 74 6 127)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.1 1)
:ampfn (* (sign) (r-exp 1 10))
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
:bprq (mc-exp 15 1 0.02)
:bppan (mcn-ref 10))
:audio-preset (aref *audio-presets* 103))
(digest-audio-preset-form
'(:cc-state #(0 74 0 127 0 0 0 58 0 0 0 108 32 13 53 127)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.1 1)
:ampfn (* (sign) (r-exp 1 10))
:durfn (* (mc-exp 13 0.02 2) (mc-exp-dev 14 4))
:suswidthfn 0.2
:suspanfn 0
:decaystartfn 0
:decayendfn 0.01
:lfofreqfn (* (n-exp y 1 2) (mc-exp 12 1 80))
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
:audio-preset (aref *audio-presets* 104))
(digest-audio-preset-form
'(:cc-state #(127 0 1 0 0 127 0 0 0 0 0 0 0 0 0 127)
:p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
        0.6
        (m-exp (mc-ref 5) 0.01 0.6))
:p2 (- p1 1)
:p3 0
:p4 0
:synth 1
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) 1 (n-exp y 1 0.5))
:durfn p1
:suswidthfn (+ 0.1 (random 0.3))
:suspanfn (random p1)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn 45
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 16) 0 1)
:bpfreq (n-exp y 1000 5000)
:voicetype (random 5)
:voicepan (mcn-ref 1)
:vowel y
:bprq (mc-exp 15 1 0.01)
:bppan (mcn-ref 3)
:filtfreqfn (* (n-exp (random 1.0) 1 10) 1000))
:audio-preset (aref *audio-presets* 105))
(digest-audio-preset-form
'(:cc-state #(0 75 14 0 11 127 107 127 0 0 0 33 0 0 0 127)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (r-exp 0.7 1.3) (mc-exp 7 0.4 1.08))
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (r-exp 0.2 0.6)
:suswidthfn 0.3
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* 1 (r-exp 45 45))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp y 1000 10000))
:audio-preset (aref *audio-presets* 106))
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
(digest-audio-preset-form
'(:cc-state #(70 48 0 0 127 2 0 127 8 0 127 125 22 86 125 0)
:p1 (if (> (random 1.0) (mcn-ref 5))
        1
        0)
:p2 (mcn-ref 5)
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
:lfofreqfn (+
            (* p2
               (expt (round (* 16 y))
                     (n-lin x (n-lin p2 (/ 1.3) 1) (n-lin p2 1.3 1)))
               (hertz (m-lin (mc-ref 10) 31 55)))
            (* (- 1 p2) (mc-lin 10 5 10)))
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
:audio-preset (aref *audio-presets* 108))
(digest-audio-preset-form
'(:cc-state #(127 0 0 43 39 127 0 127 97 0 0 127 43 43 80 123)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.45 0.9)
:ampfn (* (sign) (n-exp y 2 0.5))
:durfn (mc-exp 4 0.01 2)
:suswidthfn 0
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.02
:lfofreqfn (* (n-exp-dev 1 (n-lin x (mc-lin 12 1 0.8) (mc-lin 12 1 1.2)))
              (expt (+ 1 (round (* y (mc-lin 10 0 16)))) (mc-lin 11 1 1.5))
              (mc-exp 9 1 100))
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
:audio-preset (aref *audio-presets* 109))
(digest-audio-preset-form
'(:cc-state #(0 0 37 0 0 127 0 127 97 0 0 127 43 53 113 60)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.45 0.9)
:ampfn (* (sign) (n-exp-zero (ewi-luft) 0.1 4) (n-exp (ewi-biss) 1 4)
          (n-exp y 2 0.5))
:durfn (mc-exp 14 0.01 2)
:suswidthfn 0
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.02
:lfofreqfn (* (n-exp-dev 1 (n-lin x (mc-lin 12 1 0.8) (mc-lin 12 1 1.2)))
              (expt (+ 1 (round (* y (mc-lin 10 0 16)))) (mc-lin 11 1 1.5))
              (n-lin (ewi-note) 1 100))
:xposfn x
:yposfn y
:wetfn (mc-lin 8 0 1)
:filtfreqfn (n-exp y 1000 10000)
:vowel y
:voicetype (random 5)
:voicepan (ewi-glide)
:bpfreq (n-exp y 1000 5000)
:bprq (n-exp (ewi-biss) 1 0.01)
:bppan 1)
:audio-preset (aref *audio-presets* 110))
(digest-audio-preset-form
'(:cc-state #(0 30 0 0 39 127 0 127 96 0 0 127 7 42 91 113)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.45 1)
:ampfn (* (sign) (n-exp y 1 0.5) (n-exp-zero (ewi-luft) 0.1 1))
:durfn (mc-exp 14 0.01 2)
:suswidthfn 0
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.02
:lfofreqfn (* (n-exp-dev 1 (n-lin x (mc-lin 12 1 0.8) (mc-lin 12 1 1.2)))
              (expt (+ 1 (round (* y (mc-lin 10 0 16)))) (mc-lin 11 1 1.5))
              (mc-exp 9 1 100))
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
:audio-preset (aref *audio-presets* 111))
(digest-audio-preset-form
'(:cc-state #(0 30 0 0 39 127 0 28 96 0 0 127 7 42 12 127)
:p1 0
:p2 0
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.45 1)
:ampfn (* (sign) (n-exp y 1 0.5) (n-exp-zero (ewi-luft) 0.1 1))
:durfn (mc-exp 14 0.01 2)
:suswidthfn 0
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.02
:lfofreqfn (* (n-exp-dev 1 (n-lin x (mc-lin 12 1 0.8) (mc-lin 12 1 1.2)))
              (expt (+ 1 (round (* y (mc-lin 10 0 16)))) (mc-lin 11 1 1.5))
              (mc-exp 9 1 100))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (n-exp y 1000 10000)
:vowel y
:voicetype (random 5)
:voicepan (mcn-ref 1)
:bpfreq (n-exp y 1000 5000)
:bprq (mc-exp 15 1 0.01)
:bppan (mcn-ref 3))
:audio-preset (aref *audio-presets* 112))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 125 0 0 0 0 0 0 0 0 127 127)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (* (sign) 0.5 (n-exp y 0.5 1) (n-exp-zero (ewi-luft) 0.1 1))
:durfn (m-exp (mc-ref 6) 0.1 1.5)
:suswidthfn 0.1
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (m-exp (mc-ref 15) 1 10) 10)
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 16) 0 1)
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 113))
(digest-audio-preset-form
'(:cc-state #(0 0 0 112 0 0 0 0 127 36 0 0 1 0 127 127)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (sign) 0.5 (n-exp y 0.5 1) (n-exp-zero (ewi-luft) 0.1 1)))
:durfn (* 0.1 (r-exp 1 (m-exp (mc-ref 13) 1 10)))
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (hertz (mc-lin 9 30 100)) (m-exp-dev (mc-ref 10) 4))
:xposfn x
:yposfn y
:bpfreq (n-exp y 100 1000)
:bprq (mc-exp 14 1 0.01)
:wetfn (m-lin (mc-ref 16) 0 1)
:filtfreqfn (mc-exp 15 100 20000))
:audio-preset (aref *audio-presets* 114))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0)
:p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
        0.6
        (m-exp (mc-ref 5) 0.01 0.6))
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) 0.5 (n-exp y 1 0.5) (n-exp-zero (ewi-luft) 0.1 1))
:durfn p1
:suswidthfn (+ 0.1 (random 0.3))
:suspanfn (random p1)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn 45
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (* (n-exp (random 1.0) 1 10) 1000))
:audio-preset (aref *audio-presets* 115))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5) (n-exp-zero (ewi-luft) 0.1 1)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 116))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5) (n-exp-zero (ewi-luft) 0.1 1)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 117))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5) (n-exp-zero (ewi-luft) 0.1 1)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 118))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5) (n-exp-zero (ewi-luft) 0.1 1)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 119))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (* (/ v 20) (sign) (n-exp y 3 1.5) (n-exp-zero (ewi-luft) 0.1 1))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 120))
(digest-audio-preset-form
'(:cc-state #(0 53 0 99 0 0 127 0 0 0 0 0 0 0 0 0)
:p1 (random 1.0)
:p2 (m-exp (mc-ref 3) 0.5 2)
:p3 (* 10
       (seq-ip-pick (m-lin (mc-ref 1) 0 1) '(10 22 29 42 47 62 71 80)
                    '(10 19 32 29 53 63 75 79)))
:p4 0
:synth 0
:pitchfn (* p2 (+ 0.5 (n-exp y (mc-lin 2 0.3 0.8) (mc-lin 2 0.5 1)))
            (n-exp-zero (ewi-luft) 0.1 1))
:ampfn (* (n-exp y 0.3 0.5) (+ 0.2 (* (sign) (random 0.5))))
:durfn (* (mc-exp 4 1 2) (n-exp y 0.1 0.2))
:suswidthfn 0.2
:suspanfn (r-lin 0 (mc-lin 6 0 1))
:decaystartfn 0.5
:decayendfn 0.01
:lfofreqfn 10
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (m-exp (mc-ref 7) 100 20000))
:audio-preset (aref *audio-presets* 121))
(digest-audio-preset-form
'(:cc-state #(127 87 0 127 27 74 117 95 0 1 0 0 0 0 0 15)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 1
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) (n-exp y 1 0.5) (n-exp-zero (ewi-luft) 0.1 1))
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
:voicepan (mcn-ref 1)
:voicetype (random 5)
:vowel (random 1.0)
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 7) 1 0.01))
:audio-preset (aref *audio-presets* 122))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 50 80)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 123))
(digest-audio-preset-form
'(:cc-state #(44 48 7 0 0 1 0 127 37 0 127 125 22 86 0 0)
:p1 (if (> (random 1.0) (mcn-ref 5))
        1
        0)
:p2 (mcn-ref 5)
:p3 0
:p4 0
:synth 1
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.6)))
:durfn (* (mc-exp 3 0.1 6) (n-exp y 0.8 0.16))
:suswidthfn 0
:suspanfn 0
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (+
            (* p2
               (expt (1+ (round (* 16 y)))
                     (n-lin x (mc-lin 11 1 (/ 1.3)) (mc-lin 11 1 1.3)))
               (hertz (m-lin (mc-ref 10) 31 88)))
            (* (- 1 p2) (mc-lin 10 5 100)))
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
:audio-preset (aref *audio-presets* 124))
(digest-audio-preset-form
'(:cc-state #(79 88 95 0 36 10 0 0 101 72 0 104 38 0 0 0)
:p1 0
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
:audio-preset (aref *audio-presets* 125))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 104 126 102 0 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (sign) 0.5 (n-exp y 0.5 1)))
:durfn (m-exp (mc-ref 6) 0.1 0.5)
:suswidthfn 0.1
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (m-exp (mc-ref 7) 1 10) 10)
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000)
:audio-preset (aref *audio-presets* 126))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 127 76 0 111 0 0 0 0 0 0 0)
:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 0.5)
:ampfn (* (sign) (n-exp y 1 2) (r-exp 0.5 2))
:durfn (m-exp (mc-ref 7) 0.5 0.01)
:suswidthfn 0.3
:suspanfn (+ 0.3 (mc-lin-dev 9 0.3))
:decaystartfn 0.01
:decayendfn 0.06
:lfofreqfn (let ((pwidth (round (m-lin (mc-ref 8) 1 16))))
             (declare (ignore pwidth))
             (* (expt 1.1 (random 1.0)) (hertz (m-lin (mc-ref 7) 30 120))))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000
:bpfreq (* (mc-exp-dev 6 1.3) (m-exp (mc-ref 7) 200 5000))
:bprq 0.01)
:audio-preset (aref *audio-presets* 127))
)
