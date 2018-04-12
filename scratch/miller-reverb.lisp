(in-package :scratch)

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

#|
(dump (node 0))
(free 1)
(free 4)
(free 6)

(dump (node 0))
(mix-bus-to-out 18 2 :id 3 :head 300)
(free 3)
(cp-output-buses 8 :tail 300)

(bus-rev 0.8 0 18 19 :id 11 :head 200)
(free 11)
(set-control 11 :delfreq 100)


(clear-buses 0 24 :head 100)
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
