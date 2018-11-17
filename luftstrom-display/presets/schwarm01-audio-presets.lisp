(in-package :luftstrom-display)

(progn
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn
        (* (/ v 20)
           (min 1.0
                (* (m-exp-zero (player-cc tidx 7) 0.01 10)
                   (m-exp (player-cc 4 7) 0.1 10)))
           (sign) (n-exp y 10 3.5)))
:durfn 0.01
:suswidthfn 0
:suspanfn 0
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 0))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (sign) 1 (m-exp (player-cc tidx 7) 0.01 1) (n-exp y 1.5 2.5)))
:durfn (m-exp (player-cc tidx 100) 0.1 0.5)
:suswidthfn 0.1
:suspanfn 0
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (* 1 10)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 1))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (sign) 1 (m-exp (player-cc tidx 7) 0.01 1) (n-exp y 1.5 2.5)))
:durfn (* (r-exp 0.9 (/ 0.9)) 0.5)
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (* (r-exp 0.8 1.2) (hertz (m-lin (player-note tidx) 30 50)))
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 2))
(digest-audio-args-preset
'(:p1 (m-exp (player-note tidx) 0.01 0.8)
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.08)
:ampfn (* (sign) 1 (m-exp (player-cc tidx 7) 0.01 1) (n-exp y 1.5 2.5))
:durfn p1
:suswidthfn (+ 0.1 (random 0.3))
:suspanfn (random p1)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (* 24 (expt 2 (round (m-lin (player-cc tidx 100) 0 2))))
:x-posfn x
:y-posfn y
:wetfn (random 1.0)
:filt-freqfn (* (n-exp (random 1.0) 1 2) 5000))
(aref *audio-presets* 3))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (* (r-exp 0.7 1.3) (m-exp (player-note tidx) 0.4 1.08))
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (r-exp 0.2 0.6)
:suswidthfn 0.3
:suspanfn 1
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 15 22.5)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn (n-exp y 1000 10000))
(aref *audio-presets* 4))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.08)
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (r-exp 0.2 0.4)
:suswidthfn 0.2
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (* 6 (1+ (random 2)))
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn (n-exp y 1000 10000))
(aref *audio-presets* 5))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ 0.5 (n-exp y 0.1 0.5))
:ampfn (* (sign) 2)
:durfn (n-exp y 0.05 1.0e-4)
:suswidthfn 0.01
:suspanfn 0
:decay-startfn 0.5
:decay-endfn 0.06
:lfo-freqfn 10
:x-posfn x
:y-posfn y)
(aref *audio-presets* 6))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.5 1)
:ampfn (* (sign) 2)
:durfn (n-exp y (n-exp x 0.1 0.02) 1.0e-4)
:suswidthfn 0.01
:suspanfn 0
:decay-startfn 0.5
:decay-endfn 0.06
:lfo-freqfn 10
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn (n-exp y 100 20000))
(aref *audio-presets* 7))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ 0.5 (* 0.1 y))
:ampfn (* (sign) 2)
:durfn 0.1
:suswidthfn 1
:suspanfn 0
:decay-startfn 0.5
:decay-endfn 0.06
:lfo-freqfn 1
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 8))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.5 1)
:ampfn (* (sign) 2)
:durfn (n-exp y 0.1 0.01)
:suswidthfn 0.01
:suspanfn 0
:decay-startfn 0.5
:decay-endfn 0.06
:lfo-freqfn (n-exp y 500 1000)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn (n-exp y 100 20000))
(aref *audio-presets* 9))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.5 1)
:ampfn (* (sign) 2)
:durfn (n-exp y 0.1 0.02)
:suswidthfn 0.01
:suspanfn 0
:decay-startfn 0.5
:decay-endfn 0.06
:lfo-freqfn (n-exp y 500 1000)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn (n-exp y 100 10000))
(aref *audio-presets* 10))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:pitchfn (n-exp y 0.5 1)
:ampfn (* (sign) 2)
:durfn (n-exp y 0.1 0.02)
:suswidthfn 0.01
:suspanfn 0
:decay-startfn 0.5
:decay-endfn 0.06
:lfo-freqfn (* (n-exp x 0.7 1) (n-exp y 500 1000))
:x-posfn x
:y-posfn y
:wetfn 0.5
:filt-freqfn (n-exp y 100 20000))
(aref *audio-presets* 11))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.5 1)
:ampfn (* (sign) 2)
:durfn (* (n-lin x 2 1) (n-exp y 0.1 0.02))
:suswidthfn 0.01
:suspanfn (n-lin x 0 1)
:decay-startfn 0.5
:decay-endfn 0.06
:lfo-freqfn (* (n-exp x 0.7 1) (n-exp y 500 1000))
:x-posfn x
:y-posfn y
:wetfn 0.5
:filt-freqfn (n-exp y 100 20000))
(aref *audio-presets* 12))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.08)
:ampfn (* (sign) (n-exp y 1 0.5))
:durfn (r-exp 0.2 0.4)
:suswidthfn 0.2
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (* 6 (n-exp y 10 500) (1+ (random 2)))
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn (n-exp y 1000 10000))
(aref *audio-presets* 13))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.1)))
:durfn (n-exp y 3.8 0.76)
:suswidthfn 0.1
:suspanfn 0.3
:decay-startfn 0.001
:decay-endfn 0.02
:lfo-freqfn (*
             (expt (round (* 16 y))
                   (expt (* 1 (/ (aref *cc-state* 4 16) 127)) x))
             100)
:x-posfn x
:y-posfn y
:wetfn 0.5
:filt-freqfn (n-exp y 200 10000))
(aref *audio-presets* 14))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.1)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0.1
:suspanfn 0.3
:decay-startfn 0.001
:decay-endfn 0.02
:lfo-freqfn (*
             (expt (round (* 16 y))
                   (n-lin x 1 (n-lin (/ (aref *cc-state* 4 16) 127) 1 1.2)))
             100)
:x-posfn x
:y-posfn y
:wetfn 0.5
:filt-freqfn (n-exp y 200 10000))
(aref *audio-presets* 15))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (m-exp-zero (player-cc tidx 7) 0.01 1) (+ 0.1 (random 0.6)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0.1
:suspanfn 0.3
:decay-startfn 0.001
:decay-endfn 0.02
:lfo-freqfn (*
             (expt (round (* 16 y))
                   (n-lin x 1 (n-lin (/ (aref *cc-state* 4 16) 127) 1 1.2)))
             (m-exp (aref *cc-state* 4 17) 50 200))
:x-posfn x
:y-posfn y
:wetfn 0.5
:filt-freqfn (n-exp y 200 10000))
(aref *audio-presets* 16))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.1)))
:durfn (n-exp y 0.8 0.16)
:suswidthfn 0.1
:suspanfn 0.3
:decay-startfn 0.001
:decay-endfn 0.02
:lfo-freqfn (*
             (expt (round (* 16 y))
                   (n-lin x 1 (n-lin (/ (aref *cc-state* 4 16) 127) 1 1.2)))
             (m-exp (aref *cc-state* 4 17) 20 200))
:x-posfn x
:y-posfn y
:wetfn (m-lin (aref *cc-state* 4 23) 0 1)
:filt-freqfn (n-exp y 200 10000))
(aref *audio-presets* 17))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.8)))
:durfn (n-exp (random 1.0) 0.01 0.8)
:suswidthfn 0.2
:suspanfn 0
:decay-startfn 0.001
:decay-endfn 0.002
:lfo-freqfn 50
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn (n-exp (random 1.0) 100 10000))
(aref *audio-presets* 18))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.8)))
:durfn (n-exp (random 1.0) 0.01 0.8)
:suswidthfn 0.2
:suspanfn (random 1.0)
:decay-startfn 0.001
:decay-endfn 0.002
:lfo-freqfn 50
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn (n-exp (random 1.0) 100 10000))
(aref *audio-presets* 19))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (m-exp-zero (player-cc tidx 7) 0.01 1) (+ 0.1 (random 0.6)))
:durfn (m-exp (player-cc tidx 18) 0.01 0.8)
:suswidthfn 0.1
:suspanfn 0
:decay-startfn 0.001
:decay-endfn 0.02
:lfo-freqfn (*
             (expt (round (* 16 y))
                   (n-lin x (m-lin (player-cc tidx 2) 1 1)
                          (m-lin (player-cc tidx 2) 1 1.2)))
             (m-exp (player-cc tidx 1) 25 200))
:x-posfn x
:y-posfn y
:wetfn 0.5
:filt-freqfn 20000
:bp-freq (m-exp (player-cc tidx 16) 100 5000)
:bp-rq (m-exp (player-cc tidx 17) 1 0.1))
(aref *audio-presets* 20))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (+ 0.1 (random 0.8)))
:durfn (n-exp (random 1.0) 0.01 0.4)
:suswidthfn 0.2
:suspanfn 0
:decay-startfn 0.001
:decay-endfn 0.002
:lfo-freqfn 50
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn (n-exp (random 1.0) 1000 20000))
(aref *audio-presets* 21))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 0.5)
:ampfn (* (sign) (m-exp-zero (player-cc tidx 7) 0.01 1) (n-exp y 1 20)
          (r-exp 0.5 2))
:durfn (m-exp (player-cc tidx 0) 0.5 0.01)
:suswidthfn 0.3
:suspanfn (m-lin (player-cc tidx 19) 0 1)
:decay-startfn 0.01
:decay-endfn 0.06
:lfo-freqfn (let ((pwidth (round (m-lin (aref *cc-state* 3 100) 1 16))))
              (* (expt 1.1 (random 1.0))
                 (expt (round (* y (m-lin (player-cc tidx 18) 1 16)))
                       (m-lin (player-cc tidx 2) 0.8 1.2))
                 (m-exp (player-cc tidx 1) 5 60)))
:x-posfn x
:y-posfn y
:wetfn (m-lin (aref *cc-state* 4 23) 0 1)
:filt-freqfn 20000
:bp-freq (n-exp y 200 5000)
:bp-rq (m-exp (player-cc tidx 17) 0.01 1))
(aref *audio-presets* 22))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 0.5)
:ampfn (* (sign) (m-exp-zero (player-cc tidx 7) 0.01 1) (n-exp y 1 20)
          (r-exp 0.5 2))
:durfn (m-exp (aref *cc-state* 3 7) 0.5 0.01)
:suswidthfn 0.3
:suspanfn (m-lin (aref *cc-state* 3 7) 0 1)
:decay-startfn 0.01
:decay-endfn 0.06
:lfo-freqfn (let ((pwidth (round (m-lin (aref *cc-state* 3 100) 1 16))))
              (* (expt 1.1 (random 1.0))
                 (hertz (m-lin (player-note 4) 30 120))))
:x-posfn x
:y-posfn y
:wetfn (m-lin (aref *cc-state* 4 23) 0 1)
:filt-freqfn 20000
:bp-freq (m-exp (aref *cc-state* 3 100) 200 5000)
:bp-rq 0.01)
(aref *audio-presets* 23))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 0.5)
:ampfn (* (sign) (m-exp-zero (player-cc tidx 7) 0.01 1) (n-exp y 1 20)
          (r-exp 0.5 2))
:durfn (m-exp (aref *cc-state* 3 7) 0.5 0.01)
:suswidthfn 0.3
:suspanfn (m-lin (aref *cc-state* 3 7) 0 1)
:decay-startfn 0.01
:decay-endfn 0.06
:lfo-freqfn (* (expt 1.1 (random 1.0)) (hertz (m-lin (player-note 4) 30 120)))
:x-posfn x
:y-posfn y
:wetfn (m-lin (aref *cc-state* 4 23) 0 1)
:filt-freqfn (m-exp y 1000 20000))
(aref *audio-presets* 24))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.5)
:ampfn (* (sign) (m-exp (player-cc tidx 7) 0.1 1) (n-exp y 1 20) (r-exp 0.5 2))
:durfn (n-exp y 0.05 0.005)
:suswidthfn 0.01
:suspanfn 0
:decay-startfn 0.01
:decay-endfn 0.06
:lfo-freqfn (n-exp y 100 3000)
:x-posfn x
:y-posfn y
:wetfn (m-lin (aref *cc-state* 4 23) 0 1)
:filt-freqfn (m-exp y 1000 20000))
(aref *audio-presets* 25))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.5)
:ampfn (* (sign) (n-exp y 1 20) (r-exp 0.5 2))
:durfn (n-exp y 0.05 0.005)
:suswidthfn 0.01
:suspanfn 0
:decay-startfn 0.01
:decay-endfn 0.06
:lfo-freqfn (* (/ (round (* 16 y)) 16) (m-exp (aref *cc-state* 4 18) 1 2) 1500)
:x-posfn x
:y-posfn y
:wetfn (m-lin (aref *cc-state* 4 23) 0 1)
:filt-freqfn (m-exp y 1000 20000))
(aref *audio-presets* 26))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 27))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 28))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 29))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 30))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 31))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 32))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 33))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 34))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 35))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 36))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 37))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 38))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 39))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (case tidx (1 (r-exp 50 80)) (otherwise (r-exp 50 80)))
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 40))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (n-exp y 0.4 1.2)
:ampfn (* (sign) (m-exp-zero (player-cc tidx 7) 0.01 10) (+ 0.1 (random 0.8)))
:durfn (n-exp (random 1.0) 0.01 0.8)
:suswidthfn 0.2
:suspanfn 0
:decay-startfn 0.001
:decay-endfn 0.002
:lfo-freqfn (* 50 (expt 2 (o-x tidx))
               (expt (round (* y 16)) (m-lin (player-cc tidx 100) 1 1.5)))
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn (n-exp (random 1.0) 100 10000))
(aref *audio-presets* 41))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 42))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 43))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 44))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (case tidx (1 (+ 0.5 (* 0.1 y))) (otherwise (+ p2 (n-exp y 0.4 1.08))))
:ampfn (case tidx
         (1 (* (/ v 20) (sign) 2))
         (otherwise
          (progn
           (* (/ v 20) (sign) (m-exp-zero (player-cc tidx 7) 0.01 1)
              (n-exp y 3 1.5)))))
:durfn (case tidx (1 0.1) (otherwise 0.5))
:suswidthfn (case tidx (1 1) (otherwise 0))
:suspanfn (case tidx (1 0) (otherwise (random 1.0)))
:decay-startfn (case tidx (1 0.5) (otherwise 5.0e-4))
:decay-endfn (case tidx (1 0.06) (otherwise 0.002))
:lfo-freqfn (case tidx (1 1) (otherwise (r-exp 50 80)))
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 45))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (case tidx (1 (+ 0.5 (* 0.1 y))) (otherwise (+ p2 (n-exp y 0.4 1.08))))
:ampfn (case tidx
         (1 (* (/ v 20) (sign) 2))
         (otherwise (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))))
:durfn (case tidx (1 0.1) (otherwise 0.5))
:suswidthfn (case tidx (1 1) (otherwise 0))
:suspanfn (case tidx (1 0) (otherwise (random 1.0)))
:decay-startfn (case tidx (1 0.5) (otherwise 5.0e-4))
:decay-endfn (case tidx (1 0.06) (otherwise 0.002))
:lfo-freqfn (case tidx
              (1 1)
              (otherwise (* (m-exp (aref *cc-state* 4 7) 1 4) (r-exp 20 40))))
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 46))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (case tidx (1 (+ 0.5 (* 0.1 y))) (otherwise (+ p2 (n-exp y 0.4 1.08))))
:ampfn (case tidx
         (1 (* (/ v 20) (sign) 2))
         (otherwise (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))))
:durfn (case tidx (1 0.1) (otherwise 0.5))
:suswidthfn (case tidx (1 1) (otherwise 0))
:suspanfn (case tidx (1 0) (otherwise (random 1.0)))
:decay-startfn (case tidx (1 0.5) (otherwise 5.0e-4))
:decay-endfn (case tidx (1 0.06) (otherwise 0.002))
:lfo-freqfn (case tidx
              (1 1)
              (otherwise
               (* (m-exp (aref *cc-state* 4 0) 1 2)
                  (m-exp (aref *cc-state* 4 7) 1 10) (r-exp 20 40))))
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 47))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (* (/ v 20) (sign) (m-exp-zero (player-cc tidx 7) 0.01 1)
          (n-exp y 3 1.5))
:durfn 0.1
:suswidthfn 0
:suspanfn 0.0
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (* (expt 3.5 y) (m-exp (player-cc tidx 0) 1 2)
               (m-exp (player-cc tidx 5) 1 10) (r-exp 5 5))
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn (n-exp y 1000 20000))
(aref *audio-presets* 48))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (* (/ v 20) (sign) (m-exp-zero (player-cc tidx 7) 0.01 1)
          (n-exp y 3 1.5))
:durfn (* (m-exp (player-cc tidx 20) 1 4) (+ 0.05 (random 0.4)))
:suswidthfn 0.2
:suspanfn 0
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (*
             (expt (round (* (round (m-lin (player-cc tidx 6) 1 16.0)) y))
                   (float (m-lin (player-cc tidx 22) 0.5 2)))
             (m-exp (player-cc tidx 0) 1 2) (m-exp (player-cc tidx 5) 1 10)
             (r-exp 5 5))
:x-posfn x
:y-posfn y
:wetfn (m-lin (player-cc tidx 23) 0 1)
:filt-freqfn (n-exp y 1000 20000))
(aref *audio-presets* 49))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 50))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 51))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 52))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 53))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 54))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 55))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 56))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 57))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 58))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 59))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 60))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 61))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 62))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 63))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 64))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 65))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 66))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 67))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 68))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 69))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 70))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 71))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 72))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 73))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 74))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 75))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 76))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 77))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 78))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 79))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 80))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 81))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 82))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 83))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 84))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 85))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 86))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 87))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 88))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 89))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 90))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 91))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 92))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 93))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 94))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 95))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 96))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 97))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 98))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 99))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 100))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 101))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 102))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 103))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 104))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 105))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 106))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 107))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 108))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 109))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 110))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 111))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 112))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 113))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 114))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 115))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 116))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 117))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 118))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 119))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 120))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 121))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 122))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 123))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 124))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 125))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 126))
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 80)
:x-posfn x
:y-posfn y
:wetfn 1
:filt-freqfn 20000)
(aref *audio-presets* 127))
)
