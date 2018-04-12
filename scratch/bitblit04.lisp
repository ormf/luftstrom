(in-package :scratch)

(define-vug my-phasor (freq init)
  (with-samples ((phase init)
                 (inc (* freq *sample-duration*)))
    (prog1 phase
      (incf phase inc)
      (cond ((>= phase 1.0) (setf phase (mouse-x)))
            ((minusp phase) (setf phase (mouse-x)))))))

(define-vug bitblitter (freq amp phase)
  (with-samples ((p (phasor freq phase))
                 (sig (* 65536 p))
                 (out (* amp (mouse-y) (- (* (mod (bitblit2 sig) 65536) (expt 0.5 15)) 1))))
    (cond ((= current-channel 0) out)
          ((= current-channel 1) out)
          (t +sample-zero+))))

;;; modulation

(define-vug bitblitter (freq amp phase)
  (with-samples ((p (phasor (* (sine (* freq 3 (mouse-y)) 10 0) freq) phase))
                 (sig (* 65536 p))
                 (out (* amp (- (* (mod (bitblit2 sig) 65536) (expt 0.5 15)) 1))))
    (cond ((= current-channel 0) out)
          ((= current-channel 1) out)
          (t +sample-zero+))))

(defun bitblit2 (sig)
    (mod
     (logxor (lognot 18273643920834987529)
             (logxor (ash (round sig) 3)
                     (ash (logand (round (* sig sig))
                                  (ash (round (expt sig 0.5)) 4))
                          5)))
     65536))

(defun bitblit2 (sig)
    (mod
     (logxor (lognot 73643920834987529)
             (logxor (ash (round sig) 5)
                     (ash (logand (round (* sig sig))
                                  (ash (round (expt sig 0.5)) 4))
                          5)))
     65536))


(dsp! bitbyte (freq amp phase)
  (foreach-frame
    (foreach-channel (cout (bitblitter freq amp phase)))))

(progn
  (defun bitblit (sig)
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

(progn
  (defun bitblit (sig)
    (mod
     (logxor (lognot 73643920834987529)
             (logor (ash (round sig) 3)
                     (ash (logand (round (* sig sig))
                                  (ash (round (expt sig 0.5)) 4))
                          5)))
     2))

  (free 4)
  
(dsp! bitbyte (freq amp phase)
  (foreach-frame
    (foreach-channel (cout (bitblitter freq amp phase))))))



(bitbyte (* 0.25 (/ 44100 1024.0)) 0.5 0 :head 200)

(dsp! test (freq amp)
  (foreach-frame
    (foreach-channel (cout (* (mouse-y) (sine freq amp 0))
                           (* (mouse-y) (sine (+ 2 freq) amp 0)) )))
  )

(test 440 0.1)

(free 5)

;; (cuda-gui::scope)

(dump (node 0))

(cm:midi-open-default :direction :input)

(cm::hertz 60)

(cm::set-receiver!
   (lambda (st d1 d2)
     (case (cm::status->opcode st)
       (:cc (let ((node 4))
              (case d1
                (0 (let ((freq (cm::hertz (cm::interpl d2 '(0 -36 127 108)))))
                     (set-control node :freq freq)
                     (cuda-gui::set-scroll-x
                      (cuda-gui::find-gui "Stethoscope")
                      (round (cm::interpl (/ incudine::*sample-rate* (* 1/32 freq)) '(128 0 8192 10000))))
                     ))
                (1 (set-control node :amp (/ d2 127)))
                ;; (2 (setf *lfofreq* (mtof (interpl d2 '(0 -36 127 72)))))
                ;; (6 (setf *dur* (max 0.1 (interpl d2 '(0 0.1 127 5) :base 50))))
                ;; (7 (setf *amp* (let ((amp (interpl d2 '(0 0.001 127 1) :base 1000)))
                ;;                         (if (= amp 0.001) 0 amp))))
                ;; (16 (setf *inner-dur* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))
                ;; (17 (setf *inner-suswidth* (min 0.99 (interpl d2 '(0 0 127 1)))))
                ;; (18 (setf *suswidth* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))
                ;; (19 (setf *suspan* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))

                ;;              (t (format t "~&:cc ~a ~a" d1 d2))
                )))))              
   cm::*midi-in1*
   :format :raw)

(cuda-gui::find-gui "Stethoscope")



(delay)



