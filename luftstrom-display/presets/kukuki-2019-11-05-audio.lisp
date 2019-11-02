(in-package :luftstrom-display)

(progn
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) (n-exp y 1 0.5) )
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
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 7) 1 0.01))
(aref *audio-presets* 0))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn
        (* (sign) 1  (n-exp y 1.5 2.5)))
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
(aref *audio-presets* 1))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn
        (* (sign) 1  (n-exp y 1.5 2.5)))
:durfn (* 0.1 (r-exp 1 (m-exp (mc-ref 6) 1 10)))
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (n-exp-dev (n-ewi-note (mc-ref 7)) 1.5) 50)
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000)
(aref *audio-presets* 2))
(digest-audio-args-preset
'(:p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
          0.6
          (m-exp (mc-ref 5) 0.01 0.6))
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) 1  (n-exp y 1 0.5))
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
(aref *audio-presets* 3))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 4))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.08)
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (r-exp 0.2 0.4)
:suswidthfn 0.2
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* 6 (1+ (random 2)))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp y 1000 10000))
(aref *audio-presets* 5))
(digest-audio-args-preset
'(:p1 (random 1.0)
:p2 (m-exp (mc-ref 3) 0.5 2)
:p3 (* 10 (pick 10 22 29 42 47 62 71 80))
:p4 0
:synth 0
:pitchfn (* p2 (+ 0.5 (n-exp y 0.1 (m-exp (mc-ref 2) 0.5 2))))
:ampfn (*  (n-exp y 0.125 0.5)
          (+ 0.2 (* (sign) (random 0.5))))
:durfn (* (m-exp (mc-ref 4) 1 10) (n-exp y 0.05 0.01))
:suswidthfn 0.2
:suspanfn (r-lin 0 (m-lin (mc-ref 5) 0 1))
:decaystartfn 0.5
:decayendfn 0.01
:lfofreqfn p3
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (m-exp (mc-ref 7) 100 20000))
(aref *audio-presets* 6))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.5 1)
:ampfn (* (sign) 2)
:durfn (n-exp y (n-exp x 0.1 0.02) 1.0e-4)
:suswidthfn 0.01
:suspanfn 0
:decaystartfn 0.5
:decayendfn 0.06
:lfofreqfn 10
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp y 100 20000))
(aref *audio-presets* 7))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ 0.55 (* 0.05 y))
:ampfn (* (sign) )
:durfn 0.3
:suswidthfn 0.9
:suspanfn 0.04
:decaystartfn 0.5
:decayendfn 0.2
:lfofreqfn (* (n-exp x 1 1.2) 12.5
              (expt 2 (round (ewi-lin (mc-ref 7) 0 4))))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
(aref *audio-presets* 8))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.5 1)
:ampfn (* (sign) )
:durfn (n-exp y 0.1 0.01)
:suswidthfn 0.01
:suspanfn 0
:decaystartfn 0.5
:decayendfn 0.06
:lfofreqfn (n-exp y 500 1000)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp y 100 20000))
(aref *audio-presets* 9))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.5 1)
:ampfn (* (sign) )
:durfn (n-exp y 0.1 0.02)
:suswidthfn 0.01
:suspanfn 0
:decaystartfn 0.5
:decayendfn 0.06
:lfofreqfn (* (n-exp-dev (m-lin (mc-ref 6) 0 1) 0.5)
              (n-exp y 500 1000))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp y 100 10000))
(aref *audio-presets* 10))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn
        (* (sign) 0.5  (n-exp y 0.5 1)))
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
(aref *audio-presets* 11))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn
        (* (sign) 0.5  (n-exp y 0.5 1)))
:durfn (* 0.1 (r-exp 1 (m-exp (mc-ref 6) 1 10)))
:suswidthfn 0
:suspanfn (random 1.0)
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (n-exp-dev (n-ewi-note (mc-ref 7)) 1.5) 50)
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000)
(aref *audio-presets* 12))
(digest-audio-args-preset
'(:p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
          0.6
          (m-exp (mc-ref 5) 0.01 0.6))
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) 0.5  (n-exp y 1 0.5))
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
(aref *audio-presets* 13))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 14))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign)  (+ 0.1 (random 0.1)))
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
(aref *audio-presets* 15))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign)  (+ 0.1 (random 0.6)))
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
(aref *audio-presets* 16))
(digest-audio-args-preset
'(:p1 0
:p2 (m-lin (mc-ref 5) 0 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 (m-lin (mc-ref 4) 0.8 1.2))
:ampfn (*  (sign) (+ 0.1 (random 0.6)))
:durfn (+ (* (- 1 p2) (n-exp y 0.8 0.16)) (* p2 (m-exp (mc-ref 1) 0.1 0.5)))
:suswidthfn (* p2 0.5)
:suspanfn 0.3
:decaystartfn (n-lin p2 0.001 0.03)
:decayendfn (n-lin p2 0.02 0.03)
:lfofreqfn (n-lin p2
                  (*
                   (expt (round (* 16 y)) (n-lin x 1 (m-lin (mc-ref 1) 1 1.5)))
                   (hertz (m-lin (mc-ref 2) 31 55)))
                  (* (n-exp y 0.8 1.2) (m-exp (mc-ref 3) 50 400)
                     (n-exp-dev (m-lin (mc-ref 2) 0 1) 0.5)))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 7) 0 1)
:filtfreqfn (* (n-exp y 1 2) (m-exp (mc-ref 8) 100 10000)))
(aref *audio-presets* 17))
(digest-audio-args-preset
'(:p1 (m-lin (mc-ref 6) 0 1)
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:synth 0
:pitchfn (n-exp y 0.4 (m-lin (mc-ref 4) 0.8 1.2))
:ampfn (*  (sign) (n-exp y 0.7 0.35))
:durfn (m-exp (mc-ref 1) 0.1 0.5)
:suswidthfn 0.5
:suspanfn 0.3
:decaystartfn 0.03
:decayendfn 0.03
:lfofreqfn (+
            (* (- 1 p1) (n-exp y 0.8 1.2) (m-exp (mc-ref 3) 50 400)
               (n-exp-dev (m-lin (mc-ref 2) 0 1) 0.5))
            (* p1 12.5 (expt 2 (+ 2 (random 4)))))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 7) 0 1)
:filtfreqfn (* (n-exp y 1 2) (m-exp (mc-ref 8) 100 10000)))
(aref *audio-presets* 18))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 0.8)
:ampfn (* (sign)  (+ 0.1 (random 0.8)))
:durfn (n-exp (random 1.0) 0.01 0.8)
:suswidthfn 0.5
:suspanfn 0.3
:decaystartfn 0.03
:decayendfn 0.03
:lfofreqfn (* 12.5 (expt 2 (+ 2 (random 4))))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (m-exp (mc-ref 8) 100 10000))
(aref *audio-presets* 19))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign)  (+ 0.1 (random 0.6)))
:durfn (m-exp (mc-ref 3) 0.01 0.8)
:suswidthfn 0.1
:suspanfn 0
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (*
            (expt (round (* 16 y))
                  (n-lin x (m-lin (mc-ref 2) 1 1)
                         (m-lin (mc-ref 2) 1 1.2)))
            (m-exp (mc-ref 1) 25 200))
:xposfn x
:yposfn y
:wetfn 0.5
:filtfreqfn 20000
:bpfreq (m-exp (mc-ref 7) 100 5000)
:bprq (m-exp (mc-ref 8) 1 0.1))
(aref *audio-presets* 20))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 21))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 0.5)
:ampfn (* (sign)  (r-exp 0.5 1))
:durfn (m-exp (mc-ref 6) 0.5 0.01)
:suswidthfn 0.3
:suspanfn (m-lin (mc-ref 5) 0 1)
:decaystartfn 0.01
:decayendfn 0.06
:lfofreqfn (let ((pwidth (round (m-lin (mc-ref 4) -10 16))))
             (* (expt 1.1 (random 1.0)) (hertz (m-lin (mc-ref 3) 3 80))
                (round (* y pwidth))))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000
:bpfreq (n-exp y 200 5000)
:bprq 1)
(aref *audio-presets* 22))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 0.5)
:ampfn (* (sign)  (n-exp y 1 20)
          (r-exp 0.5 2))
:durfn (m-exp (mc-ref 7) 0.5 0.01)
:suswidthfn 0.3
:suspanfn (m-lin (mc-ref 7) 0 1)
:decaystartfn 0.01
:decayendfn 0.06
  :lfofreqfn (let ((pwidth (round (m-lin (mc-ref 8) 1 16))))
               (declare (ignore pwidth))
             (* (expt 1.1 (random 1.0))
                (hertz (m-lin (mc-ref 7) 30 120))))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000
:bpfreq (m-exp (mc-ref 7) 200 5000)
:bprq 0.01)
(aref *audio-presets* 23))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 0.5)
:ampfn (* (sign)  (n-exp y 1 20)
          (r-exp 0.5 2))
:durfn (m-exp (mc-ref 7) 0.5 0.01)
:suswidthfn 0.3
:suspanfn (m-lin (mc-ref 7) 0 1)
:decaystartfn 0.01
:decayendfn 0.06
:lfofreqfn (* (expt 1.1 (random 1.0)) (hertz (m-lin (mc-ref 6) 30 120)))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (m-exp y 1000 20000))
(aref *audio-presets* 24))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 25))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 26))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (*  (sign) (n-exp y 1 0.5))
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
(aref *audio-presets* 27))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 28))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 29))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 30))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 31))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 32))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 33))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 34))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 35))
(digest-audio-args-preset
'(:p1 10
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign)  (+ 0.1 (random 0.6)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (* (n-exp x 1 1.2)
              (expt (round (* 16 y))
                    (n-lin x 1 (m-lin (mc-ref 6) 1 1.2)))
              (hertz (ewi-nlin tidx 31 55)))
:xposfn x
:yposfn y
:wetfn 0.5
:filtfreqfn (n-exp y 200 10000))
(aref *audio-presets* 36))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) 0.125 
          (+ 0.1 (random 0.6)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0.1
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.02
:lfofreqfn (* (n-exp x 1 1.2)
              (expt (round (* 16 y))
                    (n-lin x 1 (m-lin (mc-ref 6) 1 1.2)))
              (hertz (ewi-nlin tidx 31 55)))
:xposfn x
:yposfn y
:wetfn 0.5
:filtfreqfn (n-exp y 200 10000))
(aref *audio-presets* 37))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign)  (+ 0.1 (random 0.8)))
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
(aref *audio-presets* 38))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign)  (+ 0.1 (random 0.8)))
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
(aref *audio-presets* 39))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 40))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign)  (+ 0.1 (random 0.8)))
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
(aref *audio-presets* 41))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 42))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 43))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 44))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (case tidx (1 (+ 0.5 (* 0.1 y))) (otherwise (+ p2 (n-exp y 0.4 1.08))))
:ampfn (case tidx
         (1 (* (/ v 20) (sign) 2))
         (otherwise
          (progn
           (* (/ v 20) (sign) 
              (n-exp y 3 1.5)))))
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
(aref *audio-presets* 45))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ 0.5 (* 0.1 y))
:ampfn (* 0.05 (sign))
:durfn 0.1
:suswidthfn (case tidx (1 1) (otherwise 0))
:suspanfn 0
:decaystartfn 0.5
:decayendfn 0.06
:lfofreqfn (hertz (ewi-nlin tidx 1 20))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
(aref *audio-presets* 46))
(digest-audio-args-preset
'(:p1 1
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
:lfofreqfn (case tidx
             (1 1)
             (otherwise
              (* (m-exp (mc-ref 1) 1 2)
                 (m-exp (mc-ref 2) 1 10) (r-exp 20 40))))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn 20000)
(aref *audio-presets* 47))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (* (/ v 20) (sign) 
          (n-exp y 3 1.5))
:durfn 0.1
:suswidthfn 0
:suspanfn 0.0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (expt 3.5 y) (m-exp (mc-ref 1) 1 2)
              (m-exp (mc-ref 2) 1 10) (r-exp 5 5))
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp y 1000 20000))
(aref *audio-presets* 48))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (* (/ v 20) (sign) 
          (n-exp y 3 1.5))
:durfn (* (m-exp (mc-ref 3) 1 4) (+ 0.05 (random 0.4)))
:suswidthfn 0.2
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (*
            (expt (round (* (round (m-lin (mc-ref 6) 1 16.0)) y))
                  (float (m-lin (mc-ref 2) 0.5 2)))
            (m-exp (mc-ref 1) 1 2) (m-exp (mc-ref 5) 1 10)
            (r-exp 5 5))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (n-exp y 1000 20000))
(aref *audio-presets* 49))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn
        (* (/ v 20)
           (sign) (n-exp y 10 3.5)))
:durfn 0.01
:suswidthfn 0
:suspanfn 0
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (* (m-exp (mc-ref 6) 1 10) (r-exp 50 80))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000)
(aref *audio-presets* 50))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (r-exp 0.7 1.3) (m-exp (mc-ref 7) 0.4 1.08))
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (r-exp 0.2 0.6)
:suswidthfn 0.3
:suspanfn 1
:decaystartfn 5.0e-4
:decayendfn 0.002
:lfofreqfn (r-exp 15 22.5)
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (n-exp y 1000 10000))
(aref *audio-presets* 51))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 52))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 53))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign)  (+ 0.5 (random 0.5)))
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
(aref *audio-presets* 54))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (n-exp y 1 0.01) (sign) 
          (+ 0.5 (random 0.5)))
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
(aref *audio-presets* 55))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 56))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 57))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 58))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 59))
(digest-audio-args-preset
'(:p1 1
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
:lfofreqfn (* (n-exp y 1 10) (r-exp 0.8 1.2)
              (hertz (m-lin (mc-ref 6) 30 50)))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn 20000
:bpfreq (hertz (n-lin y 10 100))
:bprq (m-lin (mc-ref 7) 5 0.01))
(aref *audio-presets* 60))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn
        (* (sign) 1  (n-exp y 1.5 2.5)))
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
(aref *audio-presets* 61))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 62))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 63))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 64))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 65))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 66))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 67))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 68))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 69))
(digest-audio-args-preset
'(:p1 (random 1.0)
:p2 (m-exp (mc-ref 3) 0.5 2)
:p3 (pick 10 10 150 200 50 100 100 100)
:p4 0
:synth 0
:pitchfn (* p2 (+ 0.5 (n-exp y 0.1 (m-exp (mc-ref 2) 0.5 2))))
:ampfn (*  (n-exp y 0.125 0.5)
          (+ 0.2 (* (sign) (random 0.5))))
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
(aref *audio-presets* 70))
(digest-audio-args-preset
'(:p1 (random 1.0)
:p2 (m-exp (mc-ref 3) 0.5 2)
:p3 (* 10
       (seq-ip-pick (m-lin (mc-ref 1) 0 1) '(10 22 29 42 47 62 71 80)
                    '(10 19 32 29 53 63 75 79)))
:p4 0
:synth 0
:pitchfn (* p2 (+ 0.5 (n-exp y 0.1 (m-exp (mc-ref 2) 0.5 2))))
:ampfn (*  (n-exp y 0.125 0.5)
          (+ 0.2 (* (sign) (random 0.5))))
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
(aref *audio-presets* 71))
(digest-audio-args-preset
'(:p1 (random 1.0)
:p2 (m-exp (mc-ref 3) 0.5 2)
:p3 (* 10
       (seq-ip-pick (m-lin (mc-ref 1) 0 1) '(10 22 29 42 47 62 71 80)
                    '(10 19 32 29 53 63 75 79)))
:p4 0
:synth 0
:pitchfn (* p2 (+ 0.5 (n-exp y 0.1 (m-exp (mc-ref 2) 0.5 2))))
:ampfn (*  (n-exp y 0.125 0.5)
          (+ 0.2 (* (sign) (random 0.5))))
:durfn (* (m-exp (mc-ref 4) 1 10) (n-exp y 0.05 0.01))
:suswidthfn 0.2
:suspanfn (r-lin 0 (m-lin (mc-ref 6) 0 1))
:decaystartfn 0.5
:decayendfn 0.01
:lfofreqfn 10
:xposfn x
:yposfn y
:wetfn 1
:filtfreqfn (m-exp (mc-ref 7) 100 20000))
(aref *audio-presets* 72))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 73))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 74))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 75))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 76))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 77))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 78))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 79))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 80))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 81))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 82))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 83))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 84))
(digest-audio-args-preset
'(:p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
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
             (round
              (*
               (if (zerop p2)
                   1
                   16)
               y))
             (n-lin x 1 (m-lin (mc-ref 1) 1 1.5)))
            (hertz (m-lin (mc-ref 2) 31 55))
            (n-exp-dev (m-lin (mc-ref 3) 0 1) 1.5))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 8) 0 1)
:filtfreqfn (n-exp y 200 10000)
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 7) 1 0.01))
(aref *audio-presets* 85))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 86))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 87))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 88))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
:ampfn (* (sign) (n-exp y 1 0.5) )
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
(aref *audio-presets* 89))
(digest-audio-args-preset
'(:p1 (if (<= (random 1.0) (m-lin (mc-ref 14) 0 1))
          0.6
          (m-exp (mc-ref 4) 0.01 0.6))
:p2 (if (<= (random 1.0) (m-lin (mc-ref 13) 0 1))
        1
        0)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 1.0 1.3) 0.63951963)
:ampfn (* (sign)  (+ 0.4 (random 0.6)))
:durfn p1
:suswidthfn 0
:suspanfn 0.3
:decaystartfn 0.001
:decayendfn 0.002
:lfofreqfn (* 1 (hertz (m-lin (mc-ref 10) 31 55))
              (n-exp-dev (m-lin (mc-ref 11) 0 1) 1.5))
:xposfn x
:yposfn y
:wetfn (m-lin (mc-ref 16) 0 1)
:filtfreqfn (n-exp y 200 10000)
:bpfreq (n-exp y 100 5000)
:bprq (m-lin (mc-ref 15) 1 0.01))
(aref *audio-presets* 90))
(digest-audio-args-preset
'(:p1 (if (<= (random 1.0) (m-lin (mc-ref 14) 0 1))
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
(aref *audio-presets* 91))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:synth 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign)  (+ 0.1 (random 0.6)))
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
(aref *audio-presets* 92))
(digest-audio-args-preset
'(:p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
          0.8
          (m-exp (mc-ref 4) 0.01 0.8))
:p2 (if (<= (random 1.0) (m-lin (mc-ref 5) 0 1))
        1
        0)
:p3 0
:p4 0
:synth 0
:pitchfn (* (n-exp y 0.4 1.2) 0.63951963)
:ampfn (* (sign) (expt (m-exp (mc-ref 14) 0.1 1) p2)
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
(aref *audio-presets* 93))
(digest-audio-args-preset
'(:p1 1
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
:bprq (m-lin (mc-ref 7) 1 0.01))
(aref *audio-presets* 94))
(digest-audio-args-preset
'(:p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
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
(aref *audio-presets* 95))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 96))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 97))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 98))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
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
(aref *audio-presets* 99))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 100))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 101))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 102))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 103))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 104))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 105))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 106))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 107))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 108))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 109))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 110))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 111))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 112))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 113))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 114))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 115))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 116))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 117))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 118))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 119))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 120))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 121))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 122))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 123))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 124))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 125))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 126))
(digest-audio-args-preset
'(:p1 1
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
(aref *audio-presets* 127))
)
