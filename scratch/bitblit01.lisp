(in-package :scratch)

(define-vug my-phasor (freq init)
  (with-samples ((phase init)
                 (inc (* freq *sample-duration*)))
    (prog1 phase
      (incf phase inc)
      (cond ((>= phase 1.0) (setf phase (mouse-x)))
            ((minusp phase) (setf phase (mouse-x)))))))

(define-vug bitblitter (freq amp phase)
  (with-samples ((p (my-phasor freq phase))
                 (sig (* 65536 p))
                 (out (* amp (- (* (mod (bitblit sig) 65536) (expt 0.5 15)) 1))))
    (cond ((= current-channel 0) out)
          ((= current-channel 1) out)
          (t +sample-zero+))))

(progn
  (define-vug bitblit (sig)
    (mod
     (logxor (lognot 18273643920834987529)
             (logxor (ash (round sig) 3)
                     (ash (logand (round (* sig sig))
                                  (ash (round (expt sig 0.5)) 4))
                          5)))
     65536))

  
  (dsp! bitbyte (freq amp phase)
    (foreach-frame
      (foreach-channel (cout (bitblitter freq amp phase))))))

(bitbyte (* 0.25 (/ 44100 1024.0)) 0.5 0 :head 200)
;; (cuda-gui::scope)

