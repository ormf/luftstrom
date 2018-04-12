(in-package :scratch)

(rt-start)

;;; (ql:quickload "incudine-gui")
;;; (incudine-gui::start)
;;; (meters :num 16 :group 300)
;;; (cuda-gui:scope :id :steth02 :num-chans 2 :bus 0 :group 200)

(incudine:flush-pending)

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

(set-controls 1 :f1 80 :f2 200 :param-fmod .9)

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



(define-vug bitblit (freq amp phase)
  (* amp
     (cos
      (* +twopi+ (+ phase (phasor freq 0))))))

;;; (* 0.1 (expt (/ 1000 0.1) (mouse-x)))

(dsp! bitblitter (freq amp phase)
  (:defaults 440 0.1 0)
  (foreach-frame
    (out (bitblit freq amp phase))))

(bitblitter 440 0.8 0 :head 200)
(bitblitter 43.066406 0.8 0 :head 200)

(q+:set-value (cuda-gui::scroll-x (cuda-gui::steth-view-pane (cuda-gui:find-gui "Stethoscope"))) (round (cuda-gui::map-value 1024 128 8192 0 10000)))

(set-control 5 :phase 0.05)

(/ 44100 1024.0)

(set-rt-block-size 64)

(dump (node 0))



(setf (bus current-channel) (audio-in current-channel))



(free 4)
(setup-io)

(scope-dsp)
(dump (node 0))
(cuda-gui:scope)

(cuda-gui::scope)

(audio-in)

(meters :head 400 :num 16)

(dograph (n)
  (unless (group-p n)
    (move n :head 200)))

(scratch:node-free-unprotected)



 

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

(let ((f 18.213948732))
  (multiple-value-bind (signif expon sign) 
      (integer-decode-float f) (list signif expon sign)))

(type-of (sb-kernel:single-float-bits 18.21394873236478763929873))

(format nil "#b~b" (sb-kernel:single-float-bits 1.821394873236478763929873))

"#b0111111111010010010001101111000"
"#b1000001100100011011011000101011"
(dump (node 0))

(incudine:free 3)

(sb-kernel:single-float-bits)

(sb-kernel:decode-double-float )
(integer-decode-float 18.21394873236478763929873d0)

(float 5126770795251461 1.0d0)

(* 5.126770795251461d16 (expt 2 -48))

(expt 2 48)

-48
1

(log 4611686018427387903 2)

(expt 2 64)18446744073709551616

(9549355 -19 1)
10011

(defun integer-decode-single-float (x)
  (declare (single-float x))
  (let* ((bits (single-float-bits (abs x)))
         (exp (ldb sb!vm:single-float-exponent-byte bits))
         (sig (ldb sb!vm:single-float-significand-byte bits))
         (sign (if (minusp (float-sign x)) -1 1))
         (biased (- exp sb!vm:single-float-bias sb!vm:single-float-digits)))
    (declare (fixnum biased))
    (unless (<= exp sb!vm:single-float-normal-exponent-max)
      (error "can't decode NaN or infinity: ~S" x))
    (cond ((and (zerop exp) (zerop sig))
           (values 0 biased sign))
          ((< exp sb!vm:single-float-normal-exponent-min)
           (integer-decode-single-denorm x))
          (t
           (values (logior sig sb!vm:single-float-hidden-bit) biased sign)))))

(format t "~b" -13)

(logand 2.345 1.738)

(* 5126770795148782 (expt 2.0d0 -48) 1)

(define-vug bitblitter (amp freq)
  (with-samples ((p (phasor freq 0)))
    (let (sig (round (* p 65536)))
      (declare (type integer sig))
      (cond ((= current-channel 0) (* amp sig))
            ((= current-channel 1) p)
            (t +sample-zero+)))))
(define-vug 16-bit-phasor (freq amp)
  (round (* 65536 (phasor freq 0))))





#.most-positive-fixnum

(log  2) (- (* num (expt 0.5 61)) 1)

(+ sig 0.5d0)

(defun blit-calc (sig)
  (declare (type double-float sig)
           (optimize (speed 3)))
  (reduce-warnings (+ sig 0.5d0)))

(defun blit-calc (sig)
  (declare (type single-float sig)
           (optimize (speed 3)))
  (let ((isig (integer-decode-float sig))))
  (* 3 sig))

(integer-decode-float)

(expt 2 -10)

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
(cuda-gui::scope)
(dump (node 0))

(set-control 3 :phase 0.4)

(dsp! phasortest (freq amp)
  (setf (audio-out 0) (sample 0.4)))

(dsp! phasortest (freq amp)
)

(phasortest (* 0.5 86.13281) 0.5 :head 200)



(dump (node 0))
(free 5)

65536

(- (* 0 (expt 0.5 15)) 1)



(ash)

(free 3)
(* 2 )



(dump (node 0))

(free 3)

	t = t % (2**(n)); // avoiding number beyond 2**(bit resolution)
t =  - 1       ; //scaling to -1, 1
	t = t * 0.35;

(ash 1.738 4)

single-float:  23 bit Mantisse, 8 Bit exponent, 1 Bit sign
