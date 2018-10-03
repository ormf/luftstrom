(in-package :luftstrom-audio)

(defparameter *basedir* nil)
(defparameter *click-array* nil)

(setf *basedir*
      (merge-pathnames
       (make-pathname
        :directory '(:relative "work/kompositionen/luftstrom"))
       (user-homedir-pathname)))

(setf *click-array*
      (buffer-load
       (merge-pathnames
        "snd/click-array.wav"
        *basedir*)))

(define-vug input-bus ((channel fixnum))
  (bus (the fixnum
         (+ (the fixnum
              (* current-frame *number-of-bus-channels*))
            channel))))

(define-vug bus-miller-reson (in out0 out1 amp deltime feedback maxdelay delprop)
     (with-samples
         (d1 d2 phi sig1 sig2)
       (initialize
        (setf d1 +sample-zero+
              d2 +sample-zero+))
       (setf phi (* pi (+ (* in in) (* d2 d2))))
       (setf sig1 (+ (* (cos phi) (+ in d1))
                     (* -1 (sin phi) (+ 0 d2))))
       (setf sig2 (+ (* (cos phi) (+ in d2))
                     (* (sin phi) (+ 0 d1))))
       (setf d2 (vdelay (* feedback
                           sig1)
                        maxdelay deltime))
       (setf d1 (vdelay (* feedback
                           sig2)
                        maxdelay (* delprop deltime)))
       (incf (input-bus (sample->fixnum out0)) (* amp sig1))
       (incf (input-bus (sample->fixnum out1)) (* amp sig2))))

(define-vug audio-miller-reson (in out0 out1 amp deltime feedback maxdelay delprop)
     (with-samples
         (d1 d2 phi sig1 sig2)
       (initialize
        (setf d1 +sample-zero+
              d2 +sample-zero+))
       (setf phi (* pi (+ (* in in) (* d2 d2))))
       (setf sig1 (+ (* (cos phi) (+ in d1))
                     (* -1 (sin phi) (+ 0 d2))))
       (setf sig2 (+ (* (cos phi) (+ in d2))
                     (* (sin phi) (+ 0 d1))))
       (setf d2 (vdelay (* feedback
                           sig1)
                        maxdelay deltime))
       (setf d1 (vdelay (* feedback
                           sig2)
                        maxdelay (* delprop deltime)))
       (incf (audio-out (sample->fixnum out0)) (* amp sig1))
       (incf (audio-out (sample->fixnum out1)) (* amp sig2))))

(define-vug mono-miller-reson (in amp deltime feedback maxdelay delprop)
     (with-samples
         (d1 d2 phi sig1 sig2)
       (initialize
        (setf d1 +sample-zero+
              d2 +sample-zero+))
       (setf phi (* pi (+ (* in in) (* d2 d2))))
       (setf sig1 (+ (* (cos phi) (+ in d1))
                     (* -1 (sin phi) (+ 0 d2))))
       (setf sig2 (+ (* (cos phi) (+ in d2))
                     (* (sin phi) (+ 0 d1))))
       (setf d2 (vdelay (* feedback
                           sig1)
                        maxdelay deltime))
       (setf d1 (vdelay (* feedback
                           sig2)
                        maxdelay (* delprop deltime)))
       (+ (* amp sig1) (* amp sig2))))

(define-vug stereo-miller-reson (in amp deltime feedback maxdelay delprop)
     (with-samples
         (d1 d2 phi sig1 sig2)
       (initialize
        (setf d1 +sample-zero+
              d2 +sample-zero+))
       (setf phi (* pi (+ (* in in) (* d2 d2))))
       (setf sig1 (+ (* (cos phi) (+ in d1))
                     (* -1 (sin phi) (+ 0 d2))))
       (setf sig2 (+ (* (cos phi) (+ in d2))
                     (* (sin phi) (+ 0 d1))))
       (setf d2 (vdelay (* feedback
                           sig1)
                        maxdelay deltime))
       (setf d1 (vdelay (* feedback
                           sig2)
                        maxdelay (* delprop deltime)))
       (values (* amp sig1) (* amp sig2))))

(dsp! audio-rev (amp in out0 out1 delfreq feedback delprop)
  (:defaults 0.9 0 16 17 100 0.834 1.2)
  (foreach-frame
    (audio-miller-reson (audio-in (sample->fixnum in))
                  out0 out1
                  amp (/ delfreq) feedback 2 delprop)))

(dsp! bus-rev (amp in out0 out1 delfreq feedback delprop)
  (:defaults 0.9 0 16 17 100 0.834 1.2)
  (foreach-frame
    (bus-miller-reson (input-bus (sample->fixnum in))
                  out0
                  out1
                  amp (/ delfreq) feedback 2 delprop)))

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

(dsp! bus-play-crack-lfo3 ((bus-idx bus-number) dur (env envelope) arrayidx
                           freq lfofreq amp inner-dur inner-suswidth)
  (:defaults 16 1 (make-envelope '(0 1 1 0) '(0 0.1 0.9) :curve :cubic) 10 400 5 1 0.01 0)
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
                   3)))
    (foreach-frame
      (incf (input-bus bus-idx)
            (* amp (envelope env 1 dur #'free) inner-env
               (buffer-read *click-array* wv-pointer :wrap-p nil :interpolation nil))))))

(dsp! bus-play-crack-lfo-rev ((bus bus-number) dur (env envelope) arrayidx
                              freq lfofreq amp inner-dur inner-suswidth
                              delfreq feedback delprop wet rev-dur)
  (:defaults 16 1 (make-envelope '(0 1 1 0) '(0 0.1 0.9) :curve :cubic) 10 400 5 1 0.01 0
             100 0.834 1.2 1 1)
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
       (sig (* amp (envelope env 1 dur) inner-env
               (buffer-read *click-array* wv-pointer :wrap-p nil :interpolation nil)))
       (rev-env (envelope env 1 rev-dur #'free)))
    (foreach-frame
      (multiple-value-bind (rev1 rev2)
          (stereo-miller-reson sig wet (/ delfreq) feedback 1.0d0 delprop)
        (dochannels (curr-channel 2)
          (incf (input-bus (+ bus curr-channel))
                (+ (* (1- wet) sig) (if (zerop curr-channel) (* rev-env rev1) (* rev-env rev2)))))))))


(dsp! bus-play-crack-lfo3 ((bus-idx bus-number) dur (env envelope) arrayidx
                           freq lfofreq amp inner-dur inner-suswidth)
  (:defaults 16 1 (make-envelope '(0 1 1 0) '(0 0.1 0.9) :curve :cubic) 10 400 5 1 0.01 0)
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
                   3)))
    (foreach-frame
      (incf (input-bus bus-idx)
            (* amp (envelope env 1 dur #'free) inner-env
               (buffer-read *click-array* wv-pointer :wrap-p nil :interpolation nil))))))

;; *curr-params*


; #<JACKMIDI:input-STREAM "midi_in-1"> receiving!

#|
(setf *curr-params* '(:bus 16 :dur 0.08062992 :arrayidx 0 :freq 169.06549 :lfofreq 267.40002 :amp
 1.0 :inner-dur 0.013092703 :inner-suswidth 0 :delfreq 77.04237 :feedback 0.5
 :delprop 0.8937008 :wet 0.51968503 :rev-dur 0.82660055 :head 200))


(:bus 16 :dur 0.6692126 :env
 #<envelope :POINTS 4 :LOOP-NODE -1 :RELEASE-NODE -1> :arrayidx 10 :freq
 4186.009 :lfofreq 6.3953753 :amp 0.28346458 :inner-dur 0.044021152
 :inner-suswidth 0 :delfreq 347.4854 :feedback 1 :delprop 2.3307085 :wet 1.0
 :rev-dur 0.07063548 :head 200)
|#


(defun play ()
  (apply #'bus-play-crack-lfo-rev *curr-params*)
  (if *active*
      (at (+ (now) (max *dtime* 0.001))
          (lambda () (play)))))

;; (play)

#|
(setf *play-crack* t)
 
(sprout
 (process
   cm::repeat 10000
   cm::do
   (apply #'bus-play-crack-lfo-rev *curr-params*)
   cm::wait 0.001))
(free 0)

(cuda-gui::start)
(rt-start)
(setq *max-number-of-nodes* 500)

(let ((num 40000))
  (dotimes (i num)
    (at (+ (now) (* i 0.01))
        (lambda () (apply #'bus-play-crack-lfo-rev *curr-params*)))))



(play)
(dotimes (i 10)
  (at (+ (now) i)
      (lambda () (format t "now!~%"))))


(setf (logger-level) :error)

(setf (logger-level) :error)
(let ((play t) (pending nil))
  (cm::set-receiver!
   (lambda (st d1 d2)
     (case (cm::status->opcode st)
       (:cc (progn
              (case d1
                (0 (setf (getf *curr-params* :freq) (cm::hertz (cm::interpl d2 '(0 -36 127 108)))))
                (1 (setf (getf *curr-params* :dur) (cm::interpl d2 '(0 0 127 1))))
                (2 (setf (getf *curr-params* :arrayidx) (cm::interpl d2 '(0 0 127 100))))
                (3 (setf (getf *curr-params* :lfofreq) (cm::hertz (cm::interpl d2 '(0 -36 127 108)))))
                (4 (setf (getf *curr-params* :amp) (cm::interpl d2 '(0 0 127 1))))
                (5 (setf (getf *curr-params* :inner-dur) (cm::interpl d2 '(0 0.01 127 1))))
                (6 (setf (getf *curr-params* :delfreq) (cm::hertz (cm::interpl d2 '(0 -36 127 108)))))
                (7 (setf (getf *curr-params* :feedback) (cm::interpl d2 '(0 0.5 127 1))))
                (16 (setf (getf *curr-params* :delprop) (cm::interpl d2 '(0 0.5 127 3))))
                (17 (setf (getf *curr-params* :wet) (cm::interpl d2 '(0 0 127 1))))
                (18 (setf (getf *curr-params* :inner-suswidth) (cm::interpl d2 '(0 0 127 0.99))))
                (19 (setf (getf *curr-params* :rev-dur) (cm::interpl d2 '(0.01 0 127 3) :base 300)))
                (20 (setf (getf *curr-params* :dur) (cm::interpl d2 '(0 0 127 1))))
                (21 (setf (getf *curr-params* :dur) (cm::interpl d2 '(0 0 127 1))))
                (22 (setf (getf *curr-params* :dur) (cm::interpl d2 '(0 0 127 1))))
                (23 (setf (getf *curr-params* :dur) (cm::interpl d2 '(0 0 127 1))))

                (t nil)
                )
              (speedlim (play pending) (apply #'bus-play-crack-lfo-rev *curr-params*))))))                
   cm::*midi-in1*
   :format :raw))

(bus-play-crack-lfo-rev *curr-params*)



(dsp! test-play-crack-lfo (amp)
  (out (sine 440 amp 0)))

(test-play-crack-lfo 0.1)
(free 0)

(dump (node 0))
(free 11)
(defvar *my-env*
  (luftstrom::gen-env 0.1 0))

(time
 (dotimes (i 50)
   (bus-play-crack-lfo-rev 16 0.6
                           (luftstrom::gen-env 0.1 0) 40 400 10 :amp 1
                           :inner-dur 0.1 :delprop 1.1 :delfreq 300 :wet 0.5)))

(bus-play-crack-lfo-rev 16 0.6
                        (luftstrom::gen-env 0.1 0) 40 400 10 :amp 1
                        :inner-dur 0.1 :delprop 1.1 :delfreq 300 :wet 0.5)

(scratch:setup-io)
(free 0)
(dump (node 0)) 




(bus-play-crack-lfo-rev 16 0.6
                        (luftstrom::gen-env 0.1 0) 40 400 10 :amp 1
                        :inner-dur 0.1 :delprop 1.1 :delfreq 300 :wet 0.5 :head 200)

(cm::midi-open-default :direction :input)


(at (+ (incudine::now) (* *sample-rate* 1)) (lambda () (format t "~&now!")))


(bus-play-crack-lfo3 18 10.4 (luftstrom::gen-env 0.1 0) 10 100 10 0.5 0.02 :head 200)

(bus-play-crack-lfo3 16 0.1 (luftstrom::gen-env 0.1 0) 10 100 10 0.5 0.02 :head 200)
(bus-play-crack-lfo3 16 0.02 (luftstrom::gen-env 0.1 0) 100 50 100 0.5 0.02 :head 200)
(bus-play-crack-lfo3 16 0.1 (luftstrom::gen-env 0.1 0) 3 100 10 0.5 0.05 :head 200)
(bus-play-crack-lfo3 16 1 (luftstrom::gen-env 0.1 0) 40 1 30 1 0.02 :head 200)

(mtof 69)
(scratch::set-controls 11 :feedback 0.8 :delfreq 100 :delprop 1.03)
(ftom 30)

(sprout
 (process
   cm::repeat 1000
   cm::do
   (bus-play-crack-lfo3 16 0.02 (luftstrom::gen-env 0.001 0) 10
                        (mtof (between 10 49.0))
                        (mtof (between 40 40)) 0.5 0.002 :head 200)
   cm::wait 0.07))

(sprout
 (process
   cm::repeat 1000
   cm::do
   (bus-play-crack-lfo3 16 0.02 (luftstrom::gen-env 0.001 0) 10
                        (mtof (between 40 40.0))
                        (mtof (between 30 40)) 0.5 0.002 :head 200)
   cm::wait (interpl (random 1.0) '(0 0.2 1 1 :base 10))))

(incudine::flush-pending)
(luftstrom::play-crack-lfo3 1 (luftstrom::gen-env 0.1 0) 40 1 30 1 0.02)

|#

#|
(dump (node 0))
(free 1)
(free 3)
(free 4)
(free 8)

(dump (node 0))
(scratch:mix-bus-to-out 16 2 :id 8 :head 300)
(free 8)
( 18 2 :id 5 :head 300)
(scratch:mix-bus-to-out 18 2 :id 7 :head 300)
(free 5)
(cp-output-buses 8 :tail 300)
(scratch:setup-io)
(bus-rev 0.8 16 18 19 :id 11 :head 200)
(free 11)
(set-controls 11 :delfreq 100 :feedback 0)


(scratch::clear-buses 0 24 :head 100)
(cp-input-buses 0 :tail 100)
(setup-io)
(audio-rev 0.8 0 0 1 :id 10 :head 200)
(free 10)





(free 2)

(free 6)

(mix-to-output 8 2 :head 300)

(bus (sample->fixnum out0))
                    (bus (sample->fixnum out1))

(dsp! bus-out ()
  (foreach-frame
    (out (bus 0))))

(dsp! test
)
(bus-out :id 10)

(dsp! sinus (freq amp)
  (:defaults 440 0.1)
  (setf (bus 16) (sine freq amp 0)))

(dsp! sinus (freq amp)
  (:defaults 440 0.1)
  (out (sine freq amp 0)))

(sinus :id 50 :head 200)
(free 50)
(setf (bus 16) 0.0d0)
(bus 8)
(dotimes (i 16) (print (bus i)))


(cuda-gui:scope :id "Stethoscope")

(free 5)

(cp-to-output-buses 16 :head 300)

(set-control 5 :delfreq 100)

(set-rt-block-size 1)

(dsp! cp-input-buses ((first-in-bus channel-number))
  (:defaults 0)
  (foreach-frame
    (dochannels (current-channel *number-of-input-bus-channels*)
      (setf (bus (+ current-channel first-in-bus)) (audio-in current-channel)))))

(dsp! bus-out ()
  (foreach-frame
    (foreach-channel
      (out (bus 0) (bus 1)))))

(cp-input-buses :head 0)
(bus-out :tail 0)

(dsp! cp-input-buses ((first-in-bus channel-number))
   (:defaults 0)
   (foreach-frame
     (dochannels (current-channel *number-of-input-bus-channels*)
       (setf (bus (+ current-channel first-in-bus)) (audio-in current-channel)))))
 

(dsp! out-test ()
  (out (bus 0) (bus 1)))
 
(set-rt-block-size 256)
(rt-start)
(cp-input-buses :id 1)
(out-test :after 1)

(free 0)


(set-controls 5 :delfreq 1450 :delprop 1.347 :feedback 0.8 :amp 1)


(set-control 5 :amp 0.5)
(set-control 5 :feedback 0.8)
(set-control 5 :delprop 1.347)
(set-control 5 :delprop 1.1)

(set-rt-block-size 256)

|#

