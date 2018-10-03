(in-package :luftstrom-audio)



(scratch:setup-io)
(incudine:set-rt-block-size 64)

(defvar *sintab* (make-buffer 8192 :fill-function (gen:partials '(1))))

(define-vug sinosc (freq amp position)
  (pan2 (osc *sintab* freq amp 0 :linear) position))

(dsp! simple2 (freq amp pos)
  (foreach-frame (foreach-channel (cout (sinosc freq amp pos)))))

(dotimes (x 300) (simple2 440 0.001 0.5))
(free 0)





(define-vug phasor (freq init)
  (with-samples ((rate (* freq *sample-duration*)))
    (%phasor rate init 1)))


(define-vug %phasor (rate init end)
  (with-samples ((phase init))
    (prog1 phase
      (incf phase rate)
      (cond ((>= phase end) (decf phase end))
            ((minusp phase) (incf phase end))))))

(phasor)






(phasor lfofreq)

(dsp! bus-play-crack-lfo-rev ((bus-idx bus-number) dur (env envelope) arrayidx freq lfofreq amp inner-dur inner-suswidth  delfreq feedback delprop rev-amp)
  (:defaults 16 1 (make-envelope '(0 1 1 0) '(0 0.1 0.9) :curve :cubic) 10 400 5 1 0.01 0
             100 0.834 1.2 1)
  (incudine::with-samples
      ((isuswidth (max 0.01d0 inner-suswidth))
       (phase1 (phasor freq 0))
       (phase-lfo (phasor lfofreq 0))
       (wv-pointer (* 1024
                      arrayidx
                      (wrap (- phase1
                               (samphold phase1 phase-lfo 0 2))
                            0 1)))
       (inner-env (expt
                   (/ (clip (+ 1 (* -1 (/ (* inner-dur lfofreq)) phase-lfo))
                            0
                            (- 1 isuswidth))
                      (- 1 isuswidth))
                   3))
       (sig (* amp (envelope env 1 dur #'free) inner-env
               (buffer-read *click-array* wv-pointer :wrap-p nil :interpolation nil))))
    (foreach-frame
      (multiple-value-bind (rev1 rev2)
          (stereo-miller-reson sig rev-amp (/ delfreq) feedback 1.0d0 delprop)
        (dochannels (curr-channel 2)
          (incf (input-bus bus-idx)
                (+ sig (if (zerop curr-channel) rev1 rev2))))))))

(define-vug click-oscil (pitch phase) 
  (declare (sample pitch phase))
  (prog1
      (cos (expt (the non-negative-sample phase) pitch))
    (incf phase)))



(define-vug round-phasor (rate init end)
  (with-samples ((phase init))
    (prog1 phase
      (incf phase rate)
      (cond ((>= phase end) (setf phase 0.0d0))
            ((minusp phase) (setf phase end))))))


(define-vug ramp-phasor (freq phase)
  (incudine.vug::round-phasor 1 phase (/ *sample-rate* freq)))

(define-vug lfo-env (lfo-freq ratio1 ratio2 phase)
  (with-samples
      ((normalized-phase (/ (* lfo-freq phase) *sample-rate*)))
    (cond
      ((< normalized-phase ratio1) 1.0d0)
      ((< normalized-phase ratio2)
       (expt (the non-negative-sample (- 1 (/ (- normalized-phase ratio1)
                                              (- ratio2 ratio1))))
             3))
      (t 0))))


(lfo-click 16 0.9 1 0.01 (gen-env 0 0.3) 0.001 0.025 1 :head 200)
(lfo-click 16 0.4 0.8 4 (gen-env 1 1) 0.001 0.03 4 :head 200)



(dsp! lfo-click ((bus-idx bus-number) pitch amp dur (env envelope) lfo-freq))

(clip (* lfo-phase))

(main-env (envelope env 1 dur #'free))

 dur (env envelope)


(initialize
 (dotimes (i periods)
   (setf (aref bufidx i)
         (reduce-warnings (floor (* i (round (/ size periods))))))))


(dsp! click ((bus-idx bus-number) pitch amp dur (env envelope))
  (incudine::with-samples
      ((sig (* amp (envelope env 1 dur #'free) (click-oscil pitch 0))))
    (foreach-frame
      (dochannels (curr-channel 2)
        (incf (input-bus bus-idx) sig)))))

(min dur (/ lfo-freq))

(dsp! click ((bus-idx bus-number) pitch amp dur (env envelope))
  (incudine::with-samples
      ((sig (* amp (envelope env 1 dur #'free) (click-oscil pitch 0))))
    (foreach-frame
      (dochannels (curr-channel 2)
        (incf (input-bus bus-idx) sig)))))

(dsp! click-test ((bus-idx bus-number) pitch amp dur (env envelope))
  (incudine::with-samples
      ((sig (* amp (envelope env 1 dur #'free) (sine 440 1 0))))
    (foreach-frame
      (dochannels (curr-channel 2)
        (incf (input-bus bus-idx) sig)))))

(sprout
 (cm::process
   cm::repeat 40
   cm::do (click 16 (+ 0.3 (random 0.5)) 1.0 0.001 (gen-env 0 0) :head 200)
   cm::wait 0.1))

(sprout
 (cm::process
   cm::repeat 400
   cm::do (click 16 0.7 1.0 0.01 (gen-env 0 0) :head 200)
   cm::wait 0.030565))

(dsp! click2 ((bus-idx bus-number) pitch amp dur (env envelope))
  (incudine::with-samples
      ((sig (sine 440 1 0)))

    (foreach-frame
      (out sig))))

(dump (node 0))
;;; (cos (expt (* *sample-rate* (phasor 1 0)) pitch))


(click 16 0.5 1.0 2 (gen-env 0.0001 1) :head 200 :id 12)



(free 10)
(free 12)

(dump (node 0))

(at (+ (now) (* 1/60 (random 1.0))) (lambda () (apply #'bus-play-crack-lfo-rev :amp (random 1.0) :freq 100 *curr-params*)))

(apply #'bus-play-crack-lfo-rev :amp (random 1.0) :freq 100 *curr-params*)
