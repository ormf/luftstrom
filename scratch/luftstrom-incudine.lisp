(in-package :luftstrom)

(set-receiver!
    (lambda (st d1 d2)
      (case (status->opcode st)
        (:cc (case d1
               (0 (setf *freq* (mtof (interpl d2 '(0 -36 127 108)))))
               (1 (setf *arrayidx* (interpl d2 '(0 0 127 99))))
               (2 (setf *lfofreq* (mtof (interpl d2 '(0 -36 127 72)))))
               (6 (setf *dur* (max 0.1 (interpl d2 '(0 0.1 127 10) :base 100))))
               (7 (setf *amp* (let ((amp (interpl d2 '(0 0.001 127 1) :base 1000)))
                                (if (= amp 0.001) 0 amp))))
               (16 (setf *inner-dur* (max 0.0001 (interpl d2 '(0 0.0001 127 1) :base 100))))
               (17 (setf *inner-suswidth* (min 0.99 (interpl d2 '(0 0 127 1)))))
               (18 (setf *suswidth* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))
               (19 (setf *suspan* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))

               (t (format t "~&:cc ~a" d1))
               ))))              
    cm::*midi-in1*
    :format :raw)

