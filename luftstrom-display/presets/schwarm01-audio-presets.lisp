(progn
(digest-audio-args-preset
'(:p1 1
:p2 (- p1 1)
:p3 0
:p4 0
:pitchfn (+ p2 (n-exp y 0.4 1.08))
:ampfn (* (m-exp-zero (or (player-cc tidx 7) 1) 0.01 10) (sign) (n-exp y 3 1.5))
:durfn 0.01
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 50)
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
:ampfn (* (m-exp (or (player-cc tidx 7) 1) 1 8) (/ v 20) (sign) (n-exp y 3 1.5))
:durfn 0.5
:suswidthfn 0
:suspanfn (random 1.0)
:decay-startfn 5.0e-4
:decay-endfn 0.002
:lfo-freqfn (r-exp 50 50)
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
(aref *audio-presets* 2))
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
(aref *audio-presets* 3))
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
(aref *audio-presets* 4))
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
(aref *audio-presets* 5))
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
(aref *audio-presets* 6))
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
(aref *audio-presets* 7))
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
(aref *audio-presets* 8))
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
(aref *audio-presets* 9))
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
(aref *audio-presets* 10))
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
(aref *audio-presets* 11))
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
(aref *audio-presets* 12))
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
(aref *audio-presets* 13))
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
(aref *audio-presets* 14))
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
(aref *audio-presets* 15))
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
(aref *audio-presets* 16))
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
(aref *audio-presets* 17))
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
(aref *audio-presets* 18))
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
(aref *audio-presets* 19))
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
(aref *audio-presets* 20))
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
(aref *audio-presets* 21))
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
(aref *audio-presets* 22))
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
(aref *audio-presets* 23))
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
(aref *audio-presets* 24))
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
(aref *audio-presets* 25))
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
:lfo-freqfn (r-exp 50 80)
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
(aref *audio-presets* 45))
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
(aref *audio-presets* 46))
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
(aref *audio-presets* 47))
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
(aref *audio-presets* 48))
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
