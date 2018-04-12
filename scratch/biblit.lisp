(in-package :scratch)

(rt-start)

;;; (ql:quickload "incudine-gui")
;;; (incudine-gui::start)
;;; (meters :num 16 :group 300)
;;; (cuda-gui:scope :id :steth02 :num-chans 2 :bus 0 :group 200)

(incudine:flush-pending)

(set-controls 1 :f1 80 :f2 200 :param-fmod .9)

(define-vug pole (in coef)
  (with-samples (y1)
    (setf y1 (+ in (* coef y1)))))

(define-vug crackle (param amp)
  (* amp (~ (abs (- (* it param) (delay1 it) 0.05)) :initial-value 0.3d0)))



(let ((f 18.184736))
  (multiple-value-bind (signif expon sign) 
      (integer-decode-float f) 
    (scale-float (float signif f) expon))) 

(free 0)


(define-vug crackle (param amp)
  (with-samples (y0 (y1 0.3d0) y2)
    (setf y0 (abs (- (* y1 param) y2 0.05d0))
          y2 y1 y1 y0)
    (* amp y0)))

(define-vug pole (in coef)
  (with-samples (y1)
    (setf y1 (+ in (* coef y1)))))

(dsp! crackle-test (f1 f2 amp param-fmod coef)
  (with-samples ((thresh (* amp .1)))
    (foreach-frame
      (stereo (pole
               (sine (if (> (crackle (+ 1.9 (sine param-fmod .07 0)) amp)
                            thresh)
                         f1
                         f2)
                     amp 0)
               coef)))))

(in)
(get-bytes-consed-in 5)
(incudine:set-rt-block-size 64)
(crackle-test 440 880 .02 .5 .96 :id 1)
(set-controls 1 :f1 800 :f2 80 :param-fmod .2)
(set-controls 1 :f1 1234 :f2 3000 :param-fmod .1)


(define-vug bitblit (amp)
  (* amp
     (cos
      (* +twopi+ (phasor (* 0.1 (expt (/ 1000 0.1) (mouse-x))) 0)))))

(define-vug bitblit (amp)
  (* amp
     (cos
      (* +twopi+ (phasor 440 0)))))

;;; (* 0.1 (expt (/ 1000 0.1) (mouse-x)))

(dsp! bitblitter (amp)
  (:defaults 0.1)
  (foreach-frame
    (out (bitblit amp))))



(dump (node 0))



(setf (bus current-channel) (audio-in current-channel))



(free 4)
(setup-io)

(scope-dsp)
(dump (node 0))
(cuda-gui:scope)

(cuda-gui::stethoscope)

(audio-in)

(meters :head 400 :num 16)

(dograph (n)
  (unless (group-p n)
    (move n :head 200)))

(scratch:node-free-unprotected)


(bitblitter 0.8 :head 200)

 

(node-free-unprotected)

(free 19)

(make-bus)

(* (ash 1 16) )


(progn
  (make-group 100)
  (make-group 200 :after 100))

(free 34)

(let ((f 18.213948732d0))
  (multiple-value-bind (signif expon sign) 
      (integer-decode-float f) 
    (scale-float (float signif f) expon)))

(define-vug bitblit (amp)
  (* amp
     (cos
      (* +twopi+ (phasor 440 0)))))
