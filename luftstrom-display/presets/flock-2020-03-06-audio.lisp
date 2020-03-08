(in-package :luftstrom-display)

(progn
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 0))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 1))
(digest-audio-preset-form
'(:cc-state #(127 0 127 0 127 127 0 53 0 16 127 82 0 0 0 42)
:p1 (if (<= (mc-lin 6 0 1) (random 1.0))
        (* (expt (min 2 (/ v)) (mcn-ref 13)) (mc-exp 14 0.1 1) (r-exp 0.2 0.6))
        0.6)
:p2 (if (<= (mcn-ref 5) (random 1.0))
        0
        1)
:p3 0
:p4 0
:synth 0
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
                      31)
                  y (mcn-ref 11))))
               (n-lin x 1 (mc-lin 12 1 1.5)))
              (mtof (mc-lin 9 (n-lin p2 3.5 31) 55)) (mc-exp-dev 10 1.2))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (n-exp y (n-lin p2 1000 200) 10000)
:bpfreq (n-exp y (n-lin p2 1000 100) 5000)
:bprq (mc-exp 15 1 0.01))
:audio-preset (aref *audio-presets* 2))
(digest-audio-preset-form
'(:cc-state #(0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0)
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
                  (*
                   (expt (1+ (round (* 15 y (mcn-ref 11))))
                         (n-lin x 1 (mc-lin 12 1 1.5)))
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
            (* (- 1 p1)
               (*
                (expt (1+ (round (* 31 y (mcn-ref 11))))
                      (mc-lin 12 (/ 1.2) 1.2))
                (hertz (mc-lin 9 31 55)))
               (c2v (n-lin-pm 0 (* (mcn-ref 10) 12))))
            (* p1 12.5 (expt 2 (+ 2 (random 4)))))
:xposfn x
:yposfn y
:wetfn (mc-lin 16 0 1)
:filtfreqfn (* (n-exp y 1 2) (m-exp (mc-ref 15) 100 10000)))
:audio-preset (aref *audio-presets* 4))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 5))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 6))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 7))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 8))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 9))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 10))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 11))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 12))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 13))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 14))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 15))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 16))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 17))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 18))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 19))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 20))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 21))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 22))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 23))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 24))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 25))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 26))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 27))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 28))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 29))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 30))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 31))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 32))
(digest-audio-preset-form
'(:preset-form nil)
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
'(:preset-form nil)
:audio-preset (aref *audio-presets* 35))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 36))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 37))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 38))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 39))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 40))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 41))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 42))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 43))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 44))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 45))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 46))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 47))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 48))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 49))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 50))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 51))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 52))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 53))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 54))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 55))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 56))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 57))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 58))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 59))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 60))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 61))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 62))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 63))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 64))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 65))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 66))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 67))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 68))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 69))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 70))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 71))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 72))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 73))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 74))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 75))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 76))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 77))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 78))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 79))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 80))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 81))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 82))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 83))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 84))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 85))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 86))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 87))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 88))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 89))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 90))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 91))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 92))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 93))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 94))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 95))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 96))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 97))
(digest-audio-preset-form
'(:preset-form nil)
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
'(:preset-form nil)
:audio-preset (aref *audio-presets* 100))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 101))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 102))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 103))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 104))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 105))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 106))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 107))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 108))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 109))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 110))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 111))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 112))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 113))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 114))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 115))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 116))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 117))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 118))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 119))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 120))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 121))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 122))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 123))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 124))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 125))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 126))
(digest-audio-preset-form
'(:preset-form nil)
:audio-preset (aref *audio-presets* 127))
)
