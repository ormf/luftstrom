;;;; luftstrom.lisp
;;;;
;;;; Copyright (c) 2018 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>

(in-package #:luftstrom-audio)

(setf *print-case* :downcase)

;;; "luftstrom" goes here. Hacks and glory await!

;;; (boids :width 1200 :height 900)


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


;;(keynum 'c4)


;;(set-rt-block-size 64)

;;(block-size)
;;; (rt-start)


(defun exp-ip (start end)
  (lambda (x) (interpl x `(0 ,start 1 ,end) :base (/ end start)))) 

#|

(dsp! mouse-play-crack-lfo3 (dur (env envelope) arrayidx freq lfofreq amp inner-dur inner-suswidth)
  (:defaults 1 (make-envelope '(0 1 1 0) '(0 0.1 0.9) :curve :cubic) 10 400 5 1 0.01 0)
  (incudine::with-samples
      ((isuswidth (max 0.01d0 inner-suswidth))
       (phase1 (phasor (* 100 (expt (/ 1000 100) (mouse-x))) 0))
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
      (out (* amp (envelope env 1 dur #'free) inner-env (buffer-read *click-array* wv-pointer :wrap-p nil :interpolation nil))))))
|#

(dsp! play-crack-lfo3 (dur (env envelope) arrayidx freq lfofreq amp inner-dur inner-suswidth)
  (:defaults 1 (make-envelope '(0 1 1 0) '(0 0.1 0.9) :curve :cubic) 10 400 5 1 0.01 0)
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
      (out (* amp (envelope env 1 dur #'free) inner-env (buffer-read *click-array* wv-pointer :wrap-p nil :interpolation nil))))))

(dsp! play-click-lfo1 (dur (env envelope) arrayidx freq lfofreq amp inner-dur inner-suswidth)
  (:defaults 1 (make-envelope '(0 1 1 0) '(0 0.1 0.9) :curve :cubic) 10 400 5 1 0.01 0)
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
      (out (* amp (envelope env 1 dur #'free) inner-env (buffer-read *click-array* wv-pointer :wrap-p nil :interpolation nil))))))

#|
(dsp! test-env (gate amp lfofreq inner-attack inner-decay)
  (incudine::with-samples
      (env (make-envelope '(0 1 1 0) (list attack (- ))))
    (foreach-frame
      (out (* amp (envelope env 1 dur #'free) inner-env (buffer-read *click-array* wv-pointer :wrap-p nil :interpolation nil))))))
|#

(defun gen-env (suswidth suspan)
  (make-envelope '(0 1 1 0)
                 (list (* suspan (- 1 suswidth))
                       suswidth
                       (* (- 1 suspan) (- 1 suswidth))) :curve :cubic))



;;; (mouse-play-crack-lfo3 1000 (gen-env 1 0) 40 1 30 1 0.02)
;;; (play-crack-lfo3 1 (gen-env 0.1 0) 40 1 30 1 0.02)



;;; (free 0)


;;; (use-package :cm-incudine)

(defparameter *freq* 30)
(defparameter *arrayidx* 10)
(defparameter *lfofreq* 10)
(defparameter *inner-dur* 0.1)
(defparameter *inner-suswidth* 0.1)
(defparameter *dur* 1)
(defparameter *suswidth* 0.1)
(defparameter *suspan* 0)
(defparameter *amp* 1)
(defparameter *durfn* nil)
(defparameter *ampfn* nil)

(defstruct preset
  (freq 30)
  (arrayidx 30)
  (suswidth 0.1)
  (suspan 0)
  (lfofreq 1)
  (dur '(lambda () (random 3.0)))
  (amp '(lambda () (+ -1 (random 2.0))))
  (inner-dur 0.01)
  (inner-suswidth 0))

(defstruct (newpreset
             (:constructor gen-preset (freq arrayidx suswidth suspan lfofreq dur amp inner-dur inner-suswidth)))
  (freq 30)
  (arrayidx 30)
  (suswidth 0.1)
  (suspan 0)
  (lfofreq 1)
  (dur '(lambda () (random 3.0)))
  (amp '(lambda () (+ -1 (random 2.0))))
  (inner-dur 0.01)
  (inner-suswidth 0))

(defparameter *presets* (make-array '(200) :element-type 'preset :initial-element (make-preset)))

#|
(set-receiver!
   (lambda (st d1 d2)
     (case (status->opcode st)
       (:cc (case d1
              (0 (setf *freq* (mtof (interpl d2 '(0 -36 127 108)))))
              (1 (setf *arrayidx* (interpl d2 '(0 0 127 99))))
              (2 (setf *lfofreq* (mtof (interpl d2 '(0 -36 127 72)))))
              (6 (setf *dur* (max 0.1 (interpl d2 '(0 0.1 127 5) :base 50))))
              (7 (setf *amp* (let ((amp (interpl d2 '(0 0.001 127 1) :base 1000)))
                                      (if (= amp 0.001) 0 amp))))
              (16 (setf *inner-dur* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))
              (17 (setf *inner-suswidth* (min 0.99 (interpl d2 '(0 0 127 1)))))
              (18 (setf *suswidth* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))
              (19 (setf *suspan* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))

              (t (format t "~&:cc ~a" d1))
              ))))              
   *midi-in1*
   :format :raw)

(set-receiver!
   (lambda (st d1 d2)
     (case (status->opcode st)
       (:cc (case d1
              (0 (set-control 1 'freq (mtof (interpl d2 '(0 -36 127 108)))))
              (1 (set-control 1 'arrayidx (interpl d2 '(0 0 127 99))))
              (2 (set-control 1 'lfofreq (mtof (interpl d2 '(0 -36 127 72)))))
              (16 (set-control 1 'inner-dur (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))
              (17 (set-control 1 'inner-suswidth (float (min 0.99 (interpl d2 '(0 0 127 1))))))

              (t (format t "~&:cc ~a" d1))
              ))))
   *midi-in1*
   :format :raw)

(sprout
 (cm::process
   cm::repeat 10000
   cm::do (play-crack-lfo3 *dur* (gen-env *suswidth* *suspan*) *arrayidx* *freq* *lfofreq* *amp* *inner-dur* *inner-suswidth*)
   cm::wait 0.05))

(play-crack-lfo3 10 (gen-env *suswidth* *suspan*) *arrayidx* *freq* *lfofreq* *amp* *inner-dur* *inner-suswidth*)


(play-crack-lfo3 *dur* (gen-env *suswidth* *suspan*) *arrayidx* *freq* *lfofreq* *amp* *inner-dur* *inner-suswidth*)


(defun store-preset (n &key (presets *presets*))
  (setf (aref presets n)
        (apply #'make-preset
               (list
                :freq *freq*
                :arrayidx *arrayidx*
                :suswidth *suswidth*
                :suspan *suspan*
                :lfofreq *lfofreq*
                :dur '(lambda () (random 3.0))
                :amp '(lambda () (+ -1 (random 2.0)))
                :inner-dur *inner-dur*
                :inner-suswidth *inner-suswidth*))))




(defun recall-preset (n &key (presets *presets*))
  (let ((preset (aref presets n)))
    (setf *freq* (sv preset :freq)
          *arrayidx* (sv preset :arrayidx)
          *suswidth* (sv preset :suswidth)
          *suspan* (sv preset :suspan)
          *lfofreq* (sv preset :lfofreq)
          *durfn* (sv preset :dur)
          *ampfn* (sv preset :amp)
          *inner-dur* (sv preset :inner-dur)
          *inner-suswidth* (sv preset :inner-suswidth))))
|#

(defun mtof (keynum)
  (* 440 (cents->scaler (* 100 (- keynum 69)))))

(defun ftom (freq)
  (cm:keynum freq :hz))



(dsp! mouse-play-crack-lfo3 (arrayidx freq lfofreq amp inner-dur inner-suswidth)
  (:defaults 10 400 5 1 0.01 0)
  (incudine::with-samples
      ((isuswidth (max 0.01d0 inner-suswidth))
       (phase1 (phasor freq 0))
       (phase-lfo (phasor lfofreq 0))
       (wv-pointer (* 1024
                      arrayidx
                      (wrap (- phase1
                               (samphold phase1 phase-lfo 0 2))
                            0 1)))
       (inner-env (/ (clip (+ 1 (* -1 (/ (* inner-dur lfofreq)) phase-lfo))
                           0
                           (- 1 isuswidth))
                     (- 1 isuswidth))))
    (foreach-frame
      (out (* amp inner-env inner-env inner-env
              (buffer-read *click-array* wv-pointer :wrap-p nil :interpolation nil))))))

;;; (mouse-play-crack-lfo3 20 300 2 1 0.1 0)

(dsp! bus-play-crack-lfo3 (arrayidx freq lfofreq amp inner-dur inner-suswidth)
  (:defaults 10 400 5 1 0.01 0)
  (incudine::with-samples
      ((isuswidth (max 0.01d0 inner-suswidth))
       (phase1 (phasor freq 0))
       (phase-lfo (phasor lfofreq 0))
       (wv-pointer (* 1024
                      arrayidx
                      (wrap (- phase1
                               (samphold phase1 phase-lfo 0 2))
                            0 1)))
       (inner-env (/ (clip (+ 1 (* -1 (/ (* inner-dur lfofreq)) phase-lfo))
                           0
                           (- 1 isuswidth))
                     (- 1 isuswidth))))
    (foreach-frame
      (incf (bus 2) (* amp inner-env inner-env inner-env
                  (buffer-read *click-array* wv-pointer :wrap-p nil :interpolation nil))))))

#|

(bus-play-crack-lfo3 20 300 2 1 0.01 0 :id 6 :head 200)

(set-controls 6 :freq 100 :lfofreq 0.2 :inner-dur 0.001 :arrayidx 44)

(bus-play-crack-lfo3 20 300 2 1 0.01 0 :id 6 :head 200)
(set-controls 6 :freq 100 :lfofreq 0.2 :inner-dur 0.001 :arrayidx 44)

(set-controls
 ) 


(store-preset 0)
(recall-preset 0)
(recall-preset 1)
(recall-preset 2)
(recall-preset 3)

*presets*



(store-preset 3)

(setf preset
      (list
       :freq *freq*
       :arrayidx *arrayidx*
       :suswidth *suswidth*
       :suspan *suspan*
       :lfofreq *lfofreq*
       :dur '(lambda () (random 3.0))
       :amp '(lambda () (+ -1 (random 2.0)))
       :inner-dur *inner-dur*
       :inner-suswidth *inner-suswidth*)
      )
(:freq 45.622536 :arrayidx 6237/127 :suswidth 0.081919216 :suspan 0.01 :lfofreq
       2.8670135 :dur (lambda () (random 3.0)) :amp (lambda () (+ -1 (random 2.0)))
       :inner-dur 0.042650215 :inner-suswidth 53/127)


(set-receiver!
   (lambda (st d1 d2)
     (case (status->opcode st)
       (:cc (case d1
              (0 (setf *freq* (mtof (interpl d2 '(0 -36 127 108)))))
              (1 (setf *arrayidx* (round (interpl d2 '(0 0 127 99)))))
              (2 (setf *lfofreq* (mtof (interpl d2 '(0 -36 127 72)))))
              (6 (setf *dur* (max 0.1 (interpl d2 '(0 0.1 127 5) :base 50))))
              (7 (setf *amp* (let ((amp (interpl d2 '(0 0.001 127 1) :base 1000)))
                                      (if (= amp 0.001) 0 amp))))
              (16 (setf *inner-dur* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))
              (17 (setf *inner-suswidth* (min 0.99 (interpl d2 '(0 0 127 1)))))
              (18 (setf *suswidth* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))
              (19 (setf *suspan* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))

              (t (format t "~&:cc ~a" d1))
              ))))              
   *midi-in1*
   :format :raw)

|#


;;; (mouse-play-crack-lfo3 3 (make-envelope '(0 1 1 0) '(0 0.1 0.9) :curve :cubic))

#|

(sprout
 (cm::process
   cm::repeat 1000
   cm::do (let ((amp (* 0.001 (- (* 2 (random 2)) 1) (expt 1000 (random 1.0)))))
            (play-crack-lfo3
             (random (* 3.0 (abs amp))) (gen-env *suswidth* *suspan*) *arrayidx* *freq*  *lfofreq* amp *inner-dur* *inner-suswidth*))
   cm::wait (random 0.5)))

;;; Vögel:


(sprout
 (cm::process
   cm::repeat 10000
   cm::do (let ((amp (* 0.001 (- (* 2 (random 2)) 1) (expt 1000 (random 1.0)))))
            (play-crack-lfo3
             (random (* 1 (abs amp))) (gen-env *suswidth* *suspan*) 40 (exp-ip 8 30) (exp-ip 20 40) amp *inner-dur* *inner-suswidth*))
   cm::wait (random 0.02)))

(sprout
 (cm::process
   cm::repeat 10000
   cm::do (let ((amp (* 0.001 (- (* 2 (random 2)) 1) (expt 1000 (random 1.0)))))
            (play-crack-lfo3
             (random (* 1 (abs amp))) (gen-env *suswidth* *suspan*) *arrayidx* (exp-ip 100 1000) (exp-ip 2 10) amp *inner-dur* *inner-suswidth*))
   cm::wait (random 0.02)))

(sprout
 (cm::process
   cm::repeat 10000
   cm::do (let ((amp (* 0.001 (- (* 2 (random 2)) 1) (expt 1000 (random 1.0)))))
            (play-crack-lfo3
             (random (* 1 (abs amp))) (gen-env *suswidth* *suspan*) *arrayidx* (exp-ip 200 300) (exp-ip 2 10) amp *inner-dur* *inner-suswidth*))
   cm::wait (random 0.00125)))

(trigger)


:loop-node
:release-node

(defun exp-ip (low high)
  (* low (expt (/ high low) (random 1.0))))

(loop for x below 100 collect (exp-ip 0.001 1))

(defun cps->midi (cps)
  (+ 69 (* 12 (log (/ cps 440) 2))))

(cps->midi 35)

(defun midi->cps (keynum)
  (* 440 (expt 2 (/ (- keynum 69) 12))))

;;; (midi->cps 81)



(play-crack-lfo3
           (random 3.0) (gen-env *suswidth* *suspan*) *arrayidx* *freq* *lfofreq* (+ -1 (random 2.0)) *inner-dur* *inner-suswidth*)


(dotimes (i 50)
  (mouse-play-crack-lfo3 (random 100) (+ 100 (random 10000)) (+ 2 (random 50.0))
                         (- 1 (random 2.0)) 0.01 0.1 1 0 0))
(free 0)

cl-boids-gpu::*boids-per-click*


(cl-boids-gpu::update-cracklers)



(dograph (n)
  (set-control n 'inner-dur 0.01)
  )

(dograph (n)
  (set-control n 'amp 0.2)
  )


(boids)

(defun cl-boids-gpu::update-cracklers ()
  (let ((idx -1))
    (incudine::dograph (node)
      (let ((n (node-id node)))
        (incf idx)
        (if (< idx cl-boids-gpu::*boids-per-click*)
            (progn
              (incudine::set-control n 'lfofreq (+ 0.1 (* 1 (cl-boids-gpu::get-speed idx))))
              (incudine::set-control n 'arrayidx (+ 10 (floor (* 40 (cl-boids-gpu::get-x idx :width 640)))))
              (incudine::set-control n 'freq (+ 30 (* 50 (cl-boids-gpu::get-y idx :height 480))))))))))

|#
