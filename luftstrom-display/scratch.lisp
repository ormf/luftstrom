;;; 
;;; scratch.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2018 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
;;;
;;; Revision history: See git repository.
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the Gnu Public License, version 2 or
;;; later. See https://www.gnu.org/licenses/gpl-2.0.html for the text
;;; of this agreement.
;;; 
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;; GNU General Public License for more details.
;;;
;;; **********************************************************************

(in-package :luftstrom-display)
(player-aref)

*obstacles*

(aref *cc-state* (player-aref :nk2) 8)

(aref (cc-state (find-controller :nk2)) 8)

(restore-controllers '(:nk2))
(untrace)

(bs-replace-cc-state 0)

(store-bs-presets)
(elt *bs-presets* 20)

(map nil (lambda (bs-preset)
           (if (cl-boids-gpu::midi-cc-fns bs-preset)
               (setf (second (cl-boids-gpu::midi-cc-fns bs-preset)) '#'nk-std)))
     *bs-presets*)
(bs-state-recall 19)

(elt *bs-presets* 0)
*audio-presets*
(renew-bs-preset-audio-args (elt *bs-presets* 19))
(load-presets)


(in-package :cl-boids-gpu)
(timer-remove-boids *boids-per-click* 1 :fadetime 30)

(apply #'append (cl-boids-gpu::audio-args (elt *bs-presets* 5)))

(cl-boids-gpu::audio-args (elt *bs-presets* 5))


(map nil (lambda (bs-preset)
           (let ((audio-args (cl-boids-gpu::audio-args bs-preset)))
             (setf (cl-boids-gpu::audio-args bs-preset)
                   (apply #'append audio-args))))
     *bs-presets*)

(unless t 4)

(loop for bs-preset across *bs-presets*
      for idx from 0
      do (if (cl-boids-gpu::bs-positions bs-preset)
             (break "~a" (cl-boids-gpu::audio-args bs-preset))))

(progn
  (setf (obstacle-type (luftstrom-display::obstacle 0)) 1)
  (reset-obstacles))

(setf (obstacle-x (luftstrom-display::obstacle 0)) 400.0)

(setf *print-case* :downcase)

(loop for x in
      '((:a 650 1080 2650 2900 3250 0  -6  -7  -8 -22 80 90 120 130 140	)
        (:e 400 1700 2600 3200 3580 0 -14 -12 -14 -20 70 80 100 120 120	)
        (:i 290 1870 2800 3250 3540 0 -15 -18 -20 -30 40 90 100 120 120	)
        (:o 400  800 2600 2800 3000 0 -10 -12 -12 -26 70 80 100 130 135	)
        (:u 350  600 2700 2900 3300 0 -20 -17 -14 -26 40 60 100 120 120))
      collect (list (first x)
                    (loop for freq from 1 to 5
                          for ampdb from 6
                          for bwidth from 11
                          collect `(:freq ,(elt x freq) :ampdb ,(elt x ampdb) :bwidth ,(elt x bwidth)))))


(loop for (voice defs) on '(:bass

                            ((:a 600 1040 2250 2450 2750 0  -7  -9  -9 -20 60 70 110 120 130)
                             (:e 400 1620 2400 2800 3100 0 -12  -9 -12 -18 40 80 100 120 120)
                             (:i 350 1700 2700 3700 4950 0 -20 -30 -22 -28 60 90 100 120 120)
                             (:o 450 800  2830 3500 4950 0 -11 -21 -20 -40 40 80 100 120 120)
                             (:u 325 700  2530 3500 4950 0 -20 -32 -28 -36 40 80 100 120 120))

                            :tenor

                            ((:a 650 1080 2650 2900 3250 0  -6  -7  -8 -22 80 90 120 130 140)
                             (:e 400 1700 2600 3200 3580 0 -14 -12 -14 -20 70 80 100 120 120)
                             (:i 290 1870 2800 3250 3540 0 -15 -18 -20 -30 40 90 100 120 120)
                             (:o 400  800 2600 2800 3000 0 -10 -12 -12 -26 70 80 100 130 135)
                             (:u 350  600 2700 2900 3300 0 -20 -17 -14 -26 40 60 100 120 120))

                            :countertenor

                            ((:a 660 1120 2750 3000 3350 0  -6 -23 -24 -38 80 90 120 130 140)
                             (:e 440 1800 2700 3000 3300 0 -14 -18 -20 -20 70 80 100 120 120)
                             (:i 270 1850 2900 3350 3590 0 -24 -24 -36 -36 40 90 100 120 120)
                             (:o 430  820 2700 3000 3300 0 -10 -26 -22 -34 40 80 100 120 120)
                             (:u 370  630 2750 3000 3400 0 -20 -23 -30 -34 40 60 100 120 120))

                            :alto

                            ((:a 800 1150 2800 3500 4950 0  -4 -20 -36 -60 80  90 120 130 140)
                             (:e 400 1600 2700 3300 4950 0 -24 -30 -35 -60 60  80 120 150 200)
                             (:i 350 1700 2700 3700 4950 0 -20 -30 -36 -60 50 100 120 150 200)
                             (:o 450 800  2830 3500 4950 0  -9 -16 -28 -55 70  80 100 130 135)
                             (:u 325 700  2530 3500 4950 0 -12 -30 -40 -64 50  60 170 180 200))

                            :soprano

                            ((:a 800 1150 2900 3900 4950 0  -6 -32 -20 -50 80  90 120 130 140)
                             (:e 350 2000 2800 3600 4950 0 -20 -15 -40 -56 60 100 120 150 200)
                             (:i 270 2140 2950 3900 4950 0 -12 -26 -26 -44 60  90 100 120 120)
                             (:o 450  800 2830 3800 4950 0 -11 -22 -22 -50 40  80 100 120 120)
                             (:u 325  700 2700 3800 4950 0 -16 -35 -40 -60 50  60 170 180 200)))
      by #'cddr
      append (list voice
                   (loop for x in defs
                         append (list (first x)
                                      (loop for freq from 1 to 5
                                            for ampdb from 6
                                            for bwidth from 11
                                            collect `(:freq ,(elt x freq) :ampdb ,(elt x ampdb) :bwidth ,(elt x bwidth) :rq ,(/ (round (* 1000 (/ (elt x bwidth) (elt x freq)))) 1000.0)))))))



(:bass
 (:a
  ((:freq 600 :ampdb 0 :bwidth 60 :rq 0.1)
   (:freq 1040 :ampdb -7 :bwidth 70 :rq 0.067)
   (:freq 2250 :ampdb -9 :bwidth 110 :rq 0.049)
   (:freq 2450 :ampdb -9 :bwidth 120 :rq 0.049)
   (:freq 2750 :ampdb -20 :bwidth 130 :rq 0.047))
  :e
  ((:freq 400 :ampdb 0 :bwidth 40 :rq 0.1)
   (:freq 1620 :ampdb -12 :bwidth 80 :rq 0.049)
   (:freq 2400 :ampdb -9 :bwidth 100 :rq 0.042)
   (:freq 2800 :ampdb -12 :bwidth 120 :rq 0.043)
   (:freq 3100 :ampdb -18 :bwidth 120 :rq 0.039))
  :i
  ((:freq 350 :ampdb 0 :bwidth 60 :rq 0.171)
   (:freq 1700 :ampdb -20 :bwidth 90 :rq 0.053)
   (:freq 2700 :ampdb -30 :bwidth 100 :rq 0.037)
   (:freq 3700 :ampdb -22 :bwidth 120 :rq 0.032)
   (:freq 4950 :ampdb -28 :bwidth 120 :rq 0.024))
  :o
  ((:freq 450 :ampdb 0 :bwidth 40 :rq 0.089)
   (:freq 800 :ampdb -11 :bwidth 80 :rq 0.1)
   (:freq 2830 :ampdb -21 :bwidth 100 :rq 0.035)
   (:freq 3500 :ampdb -20 :bwidth 120 :rq 0.034)
   (:freq 4950 :ampdb -40 :bwidth 120 :rq 0.024))
  :u
  ((:freq 325 :ampdb 0 :bwidth 40 :rq 0.123)
   (:freq 700 :ampdb -20 :bwidth 80 :rq 0.114)
   (:freq 2530 :ampdb -32 :bwidth 100 :rq 0.04)
   (:freq 3500 :ampdb -28 :bwidth 120 :rq 0.034)
   (:freq 4950 :ampdb -36 :bwidth 120 :rq 0.024)))
 :tenor
 (:a
  ((:freq 650 :ampdb 0 :bwidth 80 :rq 0.123)
   (:freq 1080 :ampdb -6 :bwidth 90 :rq 0.083)
   (:freq 2650 :ampdb -7 :bwidth 120 :rq 0.045)
   (:freq 2900 :ampdb -8 :bwidth 130 :rq 0.045)
   (:freq 3250 :ampdb -22 :bwidth 140 :rq 0.043))
  :e
  ((:freq 400 :ampdb 0 :bwidth 70 :rq 0.175)
   (:freq 1700 :ampdb -14 :bwidth 80 :rq 0.047)
   (:freq 2600 :ampdb -12 :bwidth 100 :rq 0.038)
   (:freq 3200 :ampdb -14 :bwidth 120 :rq 0.038)
   (:freq 3580 :ampdb -20 :bwidth 120 :rq 0.034))
  :i
  ((:freq 290 :ampdb 0 :bwidth 40 :rq 0.138)
   (:freq 1870 :ampdb -15 :bwidth 90 :rq 0.048)
   (:freq 2800 :ampdb -18 :bwidth 100 :rq 0.036)
   (:freq 3250 :ampdb -20 :bwidth 120 :rq 0.037)
   (:freq 3540 :ampdb -30 :bwidth 120 :rq 0.034))
  :o
  ((:freq 400 :ampdb 0 :bwidth 70 :rq 0.175)
   (:freq 800 :ampdb -10 :bwidth 80 :rq 0.1)
   (:freq 2600 :ampdb -12 :bwidth 100 :rq 0.038)
   (:freq 2800 :ampdb -12 :bwidth 130 :rq 0.046)
   (:freq 3000 :ampdb -26 :bwidth 135 :rq 0.045))
  :u
  ((:freq 350 :ampdb 0 :bwidth 40 :rq 0.114)
   (:freq 600 :ampdb -20 :bwidth 60 :rq 0.1)
   (:freq 2700 :ampdb -17 :bwidth 100 :rq 0.037)
   (:freq 2900 :ampdb -14 :bwidth 120 :rq 0.041)
   (:freq 3300 :ampdb -26 :bwidth 120 :rq 0.036)))
 :countertenor
 (:a
  ((:freq 660 :ampdb 0 :bwidth 80 :rq 0.121)
   (:freq 1120 :ampdb -6 :bwidth 90 :rq 0.08)
   (:freq 2750 :ampdb -23 :bwidth 120 :rq 0.044)
   (:freq 3000 :ampdb -24 :bwidth 130 :rq 0.043)
   (:freq 3350 :ampdb -38 :bwidth 140 :rq 0.042))
  :e
  ((:freq 440 :ampdb 0 :bwidth 70 :rq 0.159)
   (:freq 1800 :ampdb -14 :bwidth 80 :rq 0.044)
   (:freq 2700 :ampdb -18 :bwidth 100 :rq 0.037)
   (:freq 3000 :ampdb -20 :bwidth 120 :rq 0.04)
   (:freq 3300 :ampdb -20 :bwidth 120 :rq 0.036))
  :i
  ((:freq 270 :ampdb 0 :bwidth 40 :rq 0.148)
   (:freq 1850 :ampdb -24 :bwidth 90 :rq 0.049)
   (:freq 2900 :ampdb -24 :bwidth 100 :rq 0.034)
   (:freq 3350 :ampdb -36 :bwidth 120 :rq 0.036)
   (:freq 3590 :ampdb -36 :bwidth 120 :rq 0.033))
  :o
  ((:freq 430 :ampdb 0 :bwidth 40 :rq 0.093)
   (:freq 820 :ampdb -10 :bwidth 80 :rq 0.098)
   (:freq 2700 :ampdb -26 :bwidth 100 :rq 0.037)
   (:freq 3000 :ampdb -22 :bwidth 120 :rq 0.04)
   (:freq 3300 :ampdb -34 :bwidth 120 :rq 0.036))
  :u
  ((:freq 370 :ampdb 0 :bwidth 40 :rq 0.108)
   (:freq 630 :ampdb -20 :bwidth 60 :rq 0.095)
   (:freq 2750 :ampdb -23 :bwidth 100 :rq 0.036)
   (:freq 3000 :ampdb -30 :bwidth 120 :rq 0.04)
   (:freq 3400 :ampdb -34 :bwidth 120 :rq 0.035)))
 :alto
 (:a
  ((:freq 800 :ampdb 0 :bwidth 80 :rq 0.1)
   (:freq 1150 :ampdb -4 :bwidth 90 :rq 0.078)
   (:freq 2800 :ampdb -20 :bwidth 120 :rq 0.043)
   (:freq 3500 :ampdb -36 :bwidth 130 :rq 0.037)
   (:freq 4950 :ampdb -60 :bwidth 140 :rq 0.028))
  :e
  ((:freq 400 :ampdb 0 :bwidth 60 :rq 0.15)
   (:freq 1600 :ampdb -24 :bwidth 80 :rq 0.05)
   (:freq 2700 :ampdb -30 :bwidth 120 :rq 0.044)
   (:freq 3300 :ampdb -35 :bwidth 150 :rq 0.045)
   (:freq 4950 :ampdb -60 :bwidth 200 :rq 0.04))
  :i
  ((:freq 350 :ampdb 0 :bwidth 50 :rq 0.143)
   (:freq 1700 :ampdb -20 :bwidth 100 :rq 0.059)
   (:freq 2700 :ampdb -30 :bwidth 120 :rq 0.044)
   (:freq 3700 :ampdb -36 :bwidth 150 :rq 0.041)
   (:freq 4950 :ampdb -60 :bwidth 200 :rq 0.04))
  :o
  ((:freq 450 :ampdb 0 :bwidth 70 :rq 0.156)
   (:freq 800 :ampdb -9 :bwidth 80 :rq 0.1)
   (:freq 2830 :ampdb -16 :bwidth 100 :rq 0.035)
   (:freq 3500 :ampdb -28 :bwidth 130 :rq 0.037)
   (:freq 4950 :ampdb -55 :bwidth 135 :rq 0.027))
  :u
  ((:freq 325 :ampdb 0 :bwidth 50 :rq 0.154)
   (:freq 700 :ampdb -12 :bwidth 60 :rq 0.086)
   (:freq 2530 :ampdb -30 :bwidth 170 :rq 0.067)
   (:freq 3500 :ampdb -40 :bwidth 180 :rq 0.051)
   (:freq 4950 :ampdb -64 :bwidth 200 :rq 0.04)))
 :soprano
 (:a
  ((:freq 800 :ampdb 0 :bwidth 80 :rq 0.1)
   (:freq 1150 :ampdb -6 :bwidth 90 :rq 0.078)
   (:freq 2900 :ampdb -32 :bwidth 120 :rq 0.041)
   (:freq 3900 :ampdb -20 :bwidth 130 :rq 0.033)
   (:freq 4950 :ampdb -50 :bwidth 140 :rq 0.028))
  :e
  ((:freq 350 :ampdb 0 :bwidth 60 :rq 0.171)
   (:freq 2000 :ampdb -20 :bwidth 100 :rq 0.05)
   (:freq 2800 :ampdb -15 :bwidth 120 :rq 0.043)
   (:freq 3600 :ampdb -40 :bwidth 150 :rq 0.042)
   (:freq 4950 :ampdb -56 :bwidth 200 :rq 0.04))
  :i
  ((:freq 270 :ampdb 0 :bwidth 60 :rq 0.222)
   (:freq 2140 :ampdb -12 :bwidth 90 :rq 0.042)
   (:freq 2950 :ampdb -26 :bwidth 100 :rq 0.034)
   (:freq 3900 :ampdb -26 :bwidth 120 :rq 0.031)
   (:freq 4950 :ampdb -44 :bwidth 120 :rq 0.024))
  :o
  ((:freq 450 :ampdb 0 :bwidth 40 :rq 0.089)
   (:freq 800 :ampdb -11 :bwidth 80 :rq 0.1)
   (:freq 2830 :ampdb -22 :bwidth 100 :rq 0.035)
   (:freq 3800 :ampdb -22 :bwidth 120 :rq 0.032)
   (:freq 4950 :ampdb -50 :bwidth 120 :rq 0.024))
  :u
  ((:freq 325 :ampdb 0 :bwidth 50 :rq 0.154)
   (:freq 700 :ampdb -16 :bwidth 60 :rq 0.086)
   (:freq 2700 :ampdb -35 :bwidth 170 :rq 0.063)
   (:freq 3800 :ampdb -40 :bwidth 180 :rq 0.047)
   (:freq 4950 :ampdb -60 :bwidth 200 :rq 0.04))))

(defparameter vowel-freq
  '(:tenor
    ((:a
       ((:freq 650 :ampdb 0 :bwidth 80) (:freq 1080 :ampdb -6 :bwidth 90)
        (:freq 2650 :ampdb -7 :bwidth 120) (:freq 2900 :ampdb -8 :bwidth 130)
        (:freq 3250 :ampdb -22 :bwidth 140)))
     (:e
      ((:freq 400 :ampdb 0 :bwidth 70) (:freq 1700 :ampdb -14 :bwidth 80)
       (:freq 2600 :ampdb -12 :bwidth 100) (:freq 3200 :ampdb -14 :bwidth 120)
       (:freq 3580 :ampdb -20 :bwidth 120)))
     (:i
      ((:freq 290 :ampdb 0 :bwidth 40) (:freq 1870 :ampdb -15 :bwidth 90)
       (:freq 2800 :ampdb -18 :bwidth 100) (:freq 3250 :ampdb -20 :bwidth 120)
       (:freq 3540 :ampdb -30 :bwidth 120)))
     (:o
      ((:freq 400 :ampdb 0 :bwidth 70) (:freq 800 :ampdb -10 :bwidth 80)
       (:freq 2600 :ampdb -12 :bwidth 100) (:freq 2800 :ampdb -12 :bwidth 130)
       (:freq 3000 :ampdb -26 :bwidth 135)))
     (:u
      ((:freq 350 :ampdb 0 :bwidth 40) (:freq 600 :ampdb -20 :bwidth 60)
       (:freq 2700 :ampdb -17 :bwidth 100) (:freq 2900 :ampdb -14 :bwidth 120)
       (:freq 3300 :ampdb -26 :bwidth 120))))))


(:a '(650 ))



#|
(loop for x below 30
   append (if (/= -1 (aref *colors* (* 4 x)))
              (list
               (list
                (aref *positions* (* 4 x))
                (aref *positions* (+ (* 4 x) 1))
                (aref *positions* (+ (* 4 x) 2))
                (aref *positions* (+ (* 4 x) 3))
                (aref *colors* (* 4 x))
                (aref *colors* (+ (* 4 x) 1))
                (aref *colors* (+ (* 4 x) 2))
                (aref *colors* (+ (* 4 x) 3))))))


(* maxspeed (expt (/ predmult maxspeed) norm-dist))

(defun calc-speed (min-speed maxspeed)
  (lambda (x)
    (exp dist)))
|#

;;; Drums:




(funcall (expand-param-fn *pitchfn* (+ 0.1 (* 0.8 y))) 2 5)

(defparameter *pitchtmp* '(+ 0.1 (* 0.8 y)))

(funcall (expand-param-fn *pitchfn* *pitchtmp*) 2 6)

(funcall *pitchfn* 2 6)

(defun luftstrom-display::play-sound (x y)
  ;;  (format t "~a ~a~%" x y)
  (setf *clock* 0)
  (sc-user::sc-lfo-click-2d-out
   :pitch (funcall *pitchfn* x y)
   :amp (funcall *ampfn* x y)
   :dur (funcall *durfn* x y)
   :suswidth (funcall *suswidthfn* x y)
   :suspan (funcall *suspanfn* x y)
   :decay-start (funcall *decay-startfn* x y)
   :decay-end (funcall *decay-endfn* x y)
   :lfo-freq (funcall *lfo-freqfn* x y)
   :x-pos (funcall *x-posfn* x y)
   :y-pos (funcall *y-posfn* x y)
   :wet (funcall *wetfn* x y)
   :filt-freq (funcall *filt-freqfn* x y)
   :head 200))

 (with-exp-midi (0.1 2)
   (lambda (d2) (let ((speed (funcall ipfn d2))) (format t "~a " speed))))

(set-exp-midi-cc (0 0.1 2) (let ((speed (funcall ipfn d2))) (format t "~a " speed)))
(set-lin-midi-cc (1 0.1 2) (let ((speed (funcall ipfn d2))) (format t "~a~%" speed)))

(setf (aref *nk2-01-tmpls* 0) '(with-exp-midi (0.1 2) (let ((speed (funcall ipfn d2))) (format t "~a " speed))))
(setf (aref *nk2-01-fns* 0) (with-exp-midi (0.1 2) (let ((speed (funcall ipfn d2))) (format t "~a " speed))))

(let ((params
       '(:boid-params
         (:num-boids nil
          :obstacles-lookahead 2.5
          :maxspeed 1.05
          :maxforce 0.0915
          :maxidx 317
          :length 5
          :sepmult 7
          :cohmult 1
          :alignmult 1
          :predmult 1
          :maxlife 60000.0
          :lifemult 100.0)
         :audio-args
         (:pitchtmpl (+ 0.1 (* 0.2 y))
          :amptmpl (* (luftstrom-display::sign) (+ 0.2 (random 4)))
          :durtmpl (* (expt 1/4 y) 0.002)
          :suswidthtmpl 0
          :suspantmpl  0
          :decay-starttmpl 0.005
          :decay-endtmpl  0.006
          :lfo-freqtmpl 1
          :x-postmpl x
          :y-postmpl y 
          :ioffstmpl 0
          :wettmpl 1
          :filt-freqtmpl 20000)
         :midi-cc-fns
         (((0 0) (with-exp-midi (0.1 2)
                   (let ((speedf (funcall ipfn d2)))
                     (setf *maxspeed* (* speedf 1.05))
                     (setf *maxforce* (* speedf 0.09)))))
          ((0 1) (with-exp-midi (0.4 3) (let ((speed (funcall ipfn d2)))
                                          (format t "~a " speed)))))
         )))
  (progn
    (digest-params params)
    (eval (macroexpand '(param-templates->functions)))))

(let ((params
       '(:boid-params
         (:num-boids nil
          :obstacles-lookahead 2.5
          :maxspeed 1.05
          :maxforce 0.0915
          :maxidx 317
          :length 5
          :sepmult 2
          :cohmult 1
          :alignmult 1
          :predmult 1
          :maxlife 60000.0
          :lifemult 100.0)
         :audio-args
         (:pitchtmpl (+ 0.1 (* 0.2 y))
          :amptmpl (* (luftstrom-display::sign) (+ 0.2 (random 4)))
          :durtmpl (* (expt 1/4 y) 0.002)
          :suswidthtmpl 0
          :suspantmpl  0
          :decay-starttmpl 0.005
          :decay-endtmpl  0.006
          :lfo-freqtmpl 1
          :x-postmpl x
          :y-postmpl y 
          :ioffstmpl 0
          :wettmpl 1
          :filt-freqtmpl 20000)
         :midi-cc-fns
         (((0 0) (with-exp-midi (0.1 2)
                   (let ((speedf (funcall ipfn d2)))
                     (setf *maxspeed* (* speedf 1.05))
                     (setf *maxforce* (* speedf 0.09)))))
          ((0 1) (with-exp-midi (0.4 3) (let ((speed (funcall ipfn d2)))
                                          (format t "~a " speed)))))
         )))
  (progn
    (digest-params params)
    (eval (macroexpand '(param-templates->functions)))))

(let ((params
       '(:boid-params
         (:num-boids nil
          :obstacles-lookahead 2.5
          :maxspeed 1.05
          :maxforce 0.0915
          :maxidx 317
          :length 5
          :sepmult 2
          :cohmult 1
          :alignmult 1
          :predmult 1
          :maxlife 60000.0
          :lifemult 100.0)
         :audio-args
         (:pitchtmpl (+ 0.1 (* 0.2 y))
          :amptmpl (* (luftstrom-display::sign) (+ 0.2 (random 4)))
          :durtmpl (* (expt 1/4 y) 0.002)
          :suswidthtmpl 0
          :suspantmpl  0
          :decay-starttmpl 0.005
          :decay-endtmpl  0.006
          :lfo-freqtmpl 1
          :x-postmpl x
          :y-postmpl y 
          :ioffstmpl 0
          :wettmpl 1
          :filt-freqtmpl 20000)
         :midi-cc-fns
         (((0 0) (with-exp-midi (0.1 2)
                   (let ((speedf (funcall ipfn d2)))
                     (setf *maxspeed* (* speedf 1.05))
                     (setf *maxforce* (* speedf 0.09)))))
          ((0 1) (with-lin-midi (1 8) (setf *sepmult* (funcall ipfn d2))))
          ((0 2) (with-lin-midi (1 8) (setf *cohmult* (funcall ipfn d2))))
          ((0 3) (with-lin-midi (1 8) (setf *alignmult* (funcall ipfn d2)))))
         )))
  (progn
    (digest-params params)
    (eval (macroexpand '(param-templates->functions)))))

(let ((params
       '(:boid-params
         (:num-boids nil
          :obstacles-lookahead 2.5
          :maxspeed 1.05
          :maxforce 0.0915
          :maxidx 317
          :length 5
          :sepmult 2
          :cohmult 1
          :alignmult 1
          :predmult 1
          :maxlife 60000.0
          :lifemult 100.0)
         :audio-args


         (:pitchtmpl (+ 0.4 (* 0.4 y))
          :amptmpl (* (luftstrom-display::sign) (random 0.1))
          :durtmpl 1.2
          :suswidthtmpl 1
          :suspantmpl 0.1
          :decay-starttmpl 0.001
          :decay-endtmpl 0.002
          :lfo-freqtmpl (* (expt 1.5 x) 50 (expt (+ 2 (* (round (* 16 y)))) 1))
          :x-postmpl x
          :y-postmpl y
)
         :midi-cc-fns
         (((0 0) (with-exp-midi (0.1 2)
                   (let ((speedf (funcall ipfn d2)))
                     (setf *maxspeed* (* speedf 1.05))
                     (setf *maxforce* (* speedf 0.09)))))
          ((0 1) (with-lin-midi (1 8) (setf *sepmult* (funcall ipfn d2))))
          ((0 2) (with-lin-midi (1 8) (setf *cohmult* (funcall ipfn d2))))
          ((0 3) (with-lin-midi (1 8) (setf *alignmult* (funcall ipfn d2)))))
         )))
  (progn
    (digest-params params)
    (eval (macroexpand '(param-templates->functions)))))


(let ((params
       '(:boid-params
         (:num-boids nil
          :obstacles-lookahead 2.5
          :maxspeed 1.05
          :maxforce 0.0915
          :maxidx 317
          :length 5
          :sepmult 2
          :cohmult 1
          :alignmult 1
          :predmult 1
          :maxlife 60000.0
          :lifemult 100.0)
         :audio-args
         (:pitchtmpl (+ 0.3 (* 0.4 y))
          :amptmpl (* (luftstrom-display::sign) 2)
          :durtmpl 0.7
          :suswidthtmpl 1
          :suspantmpl 0
          :decay-starttmpl 0.5
          :decay-endtmpl 0.7
          :lfo-freqtmpl 1
          :x-postmpl x
          :y-postmpl y)
         :midi-cc-fns
         (((0 0) (with-exp-midi (0.1 2)
                   (let ((speedf (funcall ipfn d2)))
                     (setf *maxspeed* (* speedf 1.05))
                     (setf *maxforce* (* speedf 0.09)))))
          ((0 1) (with-lin-midi (1 8) (setf *sepmult* (funcall ipfn d2))))
          ((0 2) (with-lin-midi (1 8) (setf *cohmult* (funcall ipfn d2))))
          ((0 3) (with-lin-midi (1 8) (setf *alignmult* (funcall ipfn d2)))))
         )))
  (progn
    (digest-params params)
    (eval (macroexpand '(param-templates->functions)))))



(let ((params
       '(:boid-params
         (:num-boids nil
          :obstacles-lookahead 2.5
          :maxspeed 1.05
          :maxforce 0.0915
          :maxidx 317
          :length 5
          :sepmult 2
          :cohmult 1
          :alignmult 1
          :predmult 1
          :maxlife 60000.0
          :lifemult 100.0)
         :audio-args
         (
          :pitchtmpl (+ 0.1 (* 0.2 y))
          :amptmpl (* (luftstrom-display::sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
          :durtmpl 1.6
          :suswidthtmpl 0.8
          :suspantmpl 0.5
          :decay-starttmpl 0.001
          :decay-endtmpl 0.002
          :lfo-freqtmpl (* 50 (expt 5 (/ (aref *cc-state* 0 7) 127)) (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
          :x-postmpl x
          :y-postmpl y
          )
         :midi-cc-fns
         (((0 0) (with-exp-midi (0.1 2)
                   (let ((speedf (funcall ipfn d2)))
                     (setf *maxspeed* (* speedf 1.05))
                     (setf *maxforce* (* speedf 0.09)))))
          ((0 1) (with-lin-midi (1 8) (setf *sepmult* (funcall ipfn d2))))
          ((0 2) (with-lin-midi (1 8) (setf *cohmult* (funcall ipfn d2))))
          ((0 3) (with-lin-midi (1 8) (setf *alignmult* (funcall ipfn d2)))))
         )))
  (progn
    (digest-params params)
    (eval (macroexpand '(param-templates->functions)))))

(let ((params
       '(:boid-params
         (:num-boids nil
          :speed 2.0
          :obstacles-lookahead 2.5
          :maxspeed 1.05
          :maxforce 0.0915
          :maxidx 317
          :length 5
          :sepmult 0
          :alignmult 1
          :cohmult 224/127
          :predmult 1
          :maxlife 60000.0
          :lifemult 100.0
          :max-events-per-tick 10)
         :audio-args
         (
          :pitchtmpl (+ 0.1 (* 0.2 y))
          :amptmpl (* (luftstrom-display::sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
          :durtmpl 0.6
          :suswidthtmpl 0.1
          :suspantmpl 0
          :decay-starttmpl 0.001
          :decay-endtmpl 0.002
          :lfo-freqtmpl (* 50 (expt 5 (/ (aref *cc-state* 0 7) 127)) (expt (+ 1 (* (round (* 16 y)))) (expt 1.3 x)))
          :x-postmpl x
          :y-postmpl y
          )
         :midi-cc-fns
         (((0 0) (with-exp-midi (0.1 2)
                   (let ((speedf (funcall ipfn d2)))
                     (setf *maxspeed* (* speedf 1.05))
                     (setf *maxforce* (* speedf 0.09)))))
          ((0 1) (with-lin-midi (1 8) (setf *sepmult* (funcall ipfn d2))))
          ((0 2) (with-lin-midi (1 8) (setf *cohmult* (funcall ipfn d2))))
          ((0 3) (with-lin-midi (1 8) (setf *alignmult* (funcall ipfn d2)))))
         )))
  (progn
    (digest-params params)
    (eval (macroexpand '(param-templates->functions)))))


(let ((params
       '(:boid-params
         (:num-boids nil
          :speed 2.0
          :obstacles-lookahead 2.5
          :maxspeed 1.05
          :maxforce 0.0915
          :maxidx 317
          :length 5
          :sepmult 0
          :alignmult 1
          :cohmult 224/127
          :predmult 1
          :maxlife 60000.0
          :lifemult 100.0
          :max-events-per-tick 10)
         :audio-args
         (
          :pitchtmpl (+ 0.1 (* 0.2 y))
          :amptmpl (* (luftstrom-display::sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
          :durtmpl 0.6
          :suswidthtmpl 0.1
          :suspantmpl 0.1
          :decay-starttmpl 0.001
          :decay-endtmpl 0.002
          :lfo-freqtmpl (* 50 (expt 5 (/ (aref *cc-state* 0 7) 127)) (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
          :x-postmpl x
          :y-postmpl y
          )
         :midi-cc-fns
         (((0 0) (with-exp-midi (0.1 2)
                   (let ((speedf (funcall ipfn d2)))
                     (setf *maxspeed* (* speedf 1.05))
                     (setf *maxforce* (* speedf 0.09)))))
          ((0 1) (with-lin-midi (1 8) (setf *sepmult* (funcall ipfn d2))))
          ((0 2) (with-lin-midi (1 8) (setf *cohmult* (funcall ipfn d2))))
          ((0 3) (with-lin-midi (1 8) (setf *alignmult* (funcall ipfn d2)))))
         )))
  (progn
    (digest-params params)
    (eval (macroexpand '(param-templates->functions)))))

(defun collect-boid-params ()
  nil)

(defun collect-audio-params ()
  nil)

(defun collect-midi-cc-fns ()
  nil)

(defun collect-params ()
  `(let ((params
          '(:boid-params
            ,(collect-boid-params)
            :audio-args
            ,(collect-audio-params)
            :midi-cc-fns
            ,(collect-midi-cc-fns))))
     (progn
       (digest-params params)
       (eval (macroexpand '(param-templates->functions))))))

(collect-params)

(setf *clockinterv* 0)

(defparameter *curr-preset* nil)


(progn
  (setf *curr-preset*
        '(:boid-params
          (:num-boids nil
           :clockinterv 50
           :speed 2.0
           :obstacles-lookahead 2.5
           :maxspeed 0.85690904
           :maxforce 0.07344935
           :maxidx 317
           :length 5
           :sepmult 168/127
           :alignmult 343/127
           :cohmult 245/127
           :predmult 1
           :maxlife 60000.0
           :lifemult 100.0
           :max-events-per-tick 10
           )
          :audio-args
          (:pitchfn (+ 0.1 (* 0.6 y))
           :ampfn (* (luftstrom-display::sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
           :durfn (* (expt 1/3 y) 1.8)
           :suswidthfn 0.1
           :suspanfn 0.1
           :decay-startfn 0.001
           :decay-endfn 0.002
           :lfo-freqfn (* 50 (expt 5 (/ (aref *cc-state* 0 7) 127)) (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
           :x-posfn x
           :y-posfn y
           )
          :midi-cc-fns
          (((0 0) (with-exp-midi (0.1 2)
                    (let ((speedf (funcall ipfn d2)))
                      (setf *maxspeed* (* speedf 1.05))
                      (setf *maxforce* (* speedf 0.09)))))
           ((0 1) (with-lin-midi (1 8) (setf *sepmult* (funcall ipfn d2))))
           ((0 2) (with-lin-midi (1 8) (setf *cohmult* (funcall ipfn d2))))
           ((0 3) (with-lin-midi (1 8) (setf *alignmult* (funcall ipfn d2)))))))
  (digest-params *curr-preset*))

(defun post-preset ()
  (format t "(progn
  (setf *curr-preset*
        '(:boid-params
          (:~a ~a~&~{~{           :~a ~a~}~^~%~})
          :audio-args
          (:~a ~a~&~{~{           :~a ~a~}~^~%~})
          :midi-cc-fns
          (~&~{~{           ~a~%~a~%~}~^~%~})))
  (digest-params *curr-preset*))"
          (car (getf *curr-preset* :boid-params))
          (cadr (getf *curr-preset* :boid-params))
          (loop for (key val) on (cddr (getf *curr-preset* :boid-params)) by #'cddr collect (list key val))
          (car (getf *curr-preset* :audio-args))
          (cadr (getf *curr-preset* :audio-args))
          (loop for (key val) on (getf *curr-preset* :audio-args) by #'cddr collect (list key val))
          (loop for (key val) on (getf *curr-preset* :midi-cc-fns) by #'cddr collect (list key val))))

(post-preset)
(progn
  (setf *curr-preset*
        '(:boid-params
          (:num-boids nil
           :clockinterv 50
           :speed 2.0
           :obstacles-lookahead 2.5
           :maxspeed 0.85690904
           :maxforce 0.07344935
           :maxidx 317
           :length 5
           :sepmult 168/127
           :alignmult 343/127
           :cohmult 245/127
           :predmult 1
           :maxlife 60000.0
           :lifemult 100.0
           :max-events-per-tick 10)
          :audio-args
          (:pitchfn (+ 0.1 (* 0.6 y))
           :pitchfn (+ 0.1 (* 0.6 y))
           :ampfn (* (sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
           :durfn (* (expt 1/3 y) 1.8)
           :suswidthfn 0.1
           :suspanfn 0.1
           :decay-startfn 0.001
           :decay-endfn 0.002
           :lfo-freqfn (* 50 (expt 5 (/ (aref *cc-state* 0 7) 127))
                          (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
           :x-posfn x
           :y-posfn y)
          :midi-cc-fns
          (
           ((0 0)
            (with-exp-midi (0.1 2)
              (let ((speedf (funcall ipfn d2)))
                (setf *maxspeed* (* speedf 1.05))
                (setf *maxforce* (* speedf 0.09)))))
((0 1)
 (with-lin-midi (1 8)
   (setf *sepmult* (funcall ipfn d2))))

           ((0 2)
            (with-lin-midi (1 8)
              (setf *cohmult* (funcall ipfn d2))))
((0 3)
 (with-lin-midi (1 8)
   (setf *alignmult* (funcall ipfn d2))))
)))
  (digest-params *curr-preset*))


(progn
  (setf *curr-preset*
        '(:boid-params
          (:num-boids nil
           :clockinterv 50
           :speed 2.0
           :obstacles-lookahead 2.5
           :maxspeed 0.85690904
           :maxforce 0.07344935
           :maxidx 317
           :length 5
           :sepmult 168/127
           :alignmult 343/127
           :cohmult 245/127
           :predmult 1
           :maxlife 60000.0
           :lifemult 100.0
           :max-events-per-tick 10)
          :audio-args
          (:pitchfn (+ 0.1 (* 0.6 y))
           :ampfn (* (sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
           :durfn (* (expt 1/3 y) 1.8)
           :suswidthfn 0.1
           :suspanfn 0.1
           :decay-startfn 0.001
           :decay-endfn 0.002
           :lfo-freqfn (* 50 (expt 5 (/ (aref *cc-state* 0 7) 127))
                        (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
           :x-posfn x
           :y-posfn y)
          :midi-cc-fns
          (((0 0)
            (with-exp-midi (0.1 2)
              (let ((speedf (funcall ipfn d2)))
                (setf *maxspeed* (* speedf 1.05))
                (setf *maxforce* (* speedf 0.09))))) ((0 1)
            (with-lin-midi (1 8)
              (setf *sepmult*
                    (funcall ipfn
                             d2))))
           ((0 2)
            (with-lin-midi (1 8)
              (setf *cohmult* (funcall ipfn d2)))) ((0 3)
            (with-lin-midi (1 8)
              (setf *alignmult*
                    (funcall ipfn d2)))))))
  (digest-params *curr-preset*))


(progn
  (setf *curr-preset*
        '(:boid-params
          (num-boids nil
           clockinterv 50
           speed 2.0
           obstacles-lookahead 2.5
           maxspeed 0.85690904
           maxforce 0.07344935
           maxidx 317
           length 5
           sepmult 168/127
           alignmult 343/127
           cohmult 245/127
           predmult 1
           maxlife 60000.0
           lifemult 100.0
           max-events-per-tick 10)
          :audio-args
          (pitchfn (+ 0.1 (* 0.6 y))
           ampfn (* (sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
           durfn (* (expt 1/3 y) 1.8)
           suswidthfn 0.1
           suspanfn 0.1
           decay-startfn 0.001
           decay-endfn 0.002
           lfo-freqfn (* 50 (expt 5 (/ (aref *cc-state* 0 7) 127))
                       (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
           x-posfn x
           y-posfn y)
          :midi-cc-fns
          (((0 0) (with-exp-midi (0.1 2)
                    (let ((speedf (funcall ipfn d2)))
                      (setf *maxspeed* (* speedf 1.05))
                      (setf *maxforce* (* speedf 0.09)))))
           ((0 1) (with-lin-midi (1 8)
                    (setf *sepmult*
                          (funcall ipfn
                                   d2))))
           ((0 2) (with-lin-midi (1 8)
                    (setf *cohmult* (funcall ipfn d2))))
           ((0 3) (with-lin-midi (1 8)
                    (setf *alignmult*
                          (funcall ipfn d2)))))))
  (digest-params *curr-preset*))
(loop for )

(funcall *pitchfn* 1 2 3)
  (eval (macroexpand '(param-templates->functions)))
(defmacro my)

(defun set-param-from-key (key val)
  (let ((sym (intern (format nil "*~a*" (string-upcase (symbol-name key))) 'luftstrom-display)))
    (setf (symbol-value sym) val)))

(defun set-arg-fn (tmpl)
  (let* ((key (first tmpl))
         (val (second tmpl))
         (sym (intern (format nil "*~a*" (string-upcase (symbol-name key))) 'luftstrom-display)))
    (setf (symbol-value sym) (my-macro))))



(digest-arg-fns
 '(:pitchfn (+ 0.1 (* 0.2 y))
   :ampfn (* (luftstrom-display::sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
   :durfn (* y 2)
   :suswidthfn 0.1
   :suspanfn 0.1
   :decay-startfn 0.001
   :decay-endfn 0.002
   :lfo-freqfn (* 50 (expt 5 (/ (aref *cc-state* 0 7) 127)) (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
   :x-posfn x
   :y-posfn y))
          
(funcall *durfn* 1 1 3)



(defmacro my-macro (sym val)
  `(setf ,sym (lambda (&optional x y v) (declare (ignorable x y v)) ,val)))

(funcall (my-macro *pitchfn* (+ 0.1 (* 0.4 y))) 2 4)

(dolist (x '((*pitchfn* (+ 0.1 (* 0.2 y)))
             (*ampfn* (+ 0.1 (* 0.1 y)))))
  (my-macro (first x) (second x)))

(defmacro muy-macro (exprs)
  `(let ((forms (mapcar))))


  )



(funcall (testexpander '(*pichfn* (+ 0.1 (* x 3)))) 4)

(lambda (&optional x y z) (+ 0.1 (* x 3)))

(funcall *ampfn* 1 4)
(funcall (my-macro (+ 0.1 (* 0.2 y))) 2 4)

(funcall (set-arg-fn '(:pitchfn (+ 0.1 (* 0.4 y)))) 1 2 3)

(let ((params
       '(:boid-params
         (:num-boids nil
          :speed 2.0
          :obstacles-lookahead 2.5
          :maxspeed 1.3734769
          :maxforce 0.1177266
          :maxidx 317
          :length 5
          :sepmult 0
          :alignmult 658/127
          :cohmult 364/127
          :predmult 1
          :maxlife 60000.0
          :lifemult 100.0
          :max-events-per-tick 10
          )
         :audio-args
         (
          :pitchtmpl (+ 0.1 (* 0.2 y))
          :amptmpl (* (luftstrom-display::sign) (+ (* 0.01 (expt 16 (- 1 y))) (random 0.01)))
          :durtmpl (* (expt 1/3 y) 1.8)
          :suswidthtmpl 0.1
          :suspantmpl 0.1
          :decay-starttmpl 0.001
          :decay-endtmpl 0.002
          :lfo-freqtmpl (* 50 (expt 5 (/ (aref *cc-state* 0 7) 127)) (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
          :x-postmpl x
          :y-postmpl y
          :wettmpl 0.7
          :filt-freqtmpl 20000
          )
         :midi-cc-fns
         (((0 0) (with-exp-midi (0.1 20)
                   (let ((speedf (funcall ipfn d2)))
                     (setf *maxspeed* (* speedf 1.05))
                     (setf *maxforce* (* speedf 0.09)))))
          ((0 1) (with-lin-midi (1 8) (setf *sepmult* (funcall ipfn d2))))
          ((0 2) (with-lin-midi (1 8) (setf *cohmult* (funcall ipfn d2))))
          ((0 3) (with-lin-midi (1 8) (setf *alignmult* (funcall ipfn d2)))))
         )))
  (progn
    (digest-params params)
    (eval (macroexpand '(param-templates->functions)))))

;;; screen cast: statisch
(let ((params
       '(:boid-params
         (:num-boids 1740
          :speed 2.0
          :obstacles-lookahead 2.5
          :maxspeed 0.13486503
          :maxforce 0.011559862
          :maxidx 317
          :length 5
          :sepmult 196/127
          :alignmult 602/127
          :cohmult 0
          :predmult 1
          :maxlife 60000.0
          :lifemult 100.0
          :max-events-per-tick 10
          )
         :audio-args
         (
          :pitchtmpl (+ 0.1 (* 0.2 y))
          :amptmpl (* (luftstrom-display::sign) (+ (* 0.01 (expt 16 (- 1 y))) (random 0.01)))
          :durtmpl (* (expt 1/3 y) (expt 0.05 (/ (aref *cc-state* 0 0) 127)) 1.8)
          :suswidthtmpl 0.1
          :suspantmpl 0.1
          :decay-starttmpl 0.001
          :decay-endtmpl 0.002
          :lfo-freqtmpl (* 50 (expt 1/2 x) (expt 5 (/ (aref *cc-state* 0 7) 127)) (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
          :x-postmpl x
          :y-postmpl y
          :wettmpl 0.7
          :filt-freqtmpl 20000
          )
         :midi-cc-fns
         (((0 0) (with-exp-midi (0.1 20)
                   (let ((speedf (funcall ipfn d2)))
                     (setf *maxspeed* (* speedf 1.05))
                     (setf *maxforce* (* speedf 0.09)))))
          ((0 1) (with-lin-midi (1 8) (setf *sepmult* (funcall ipfn d2))))
          ((0 2) (with-lin-midi (1 8) (setf *cohmult* (funcall ipfn d2))))
          ((0 3) (with-lin-midi (1 8) (setf *alignmult* (funcall ipfn d2)))))
         )))
  (progn
    (digest-params params)
    (eval (macroexpand '(param-templates->functions)))))


(let ((params
       '(:boid-params
         (:num-boids 1740
          :speed 2.0
          :obstacles-lookahead 2.5
          :maxspeed 0.13486503
          :maxforce 0.011559862
          :maxidx 317
          :length 5
          :sepmult 196/127
          :alignmult 602/127
          :cohmult 0
          :predmult 1
          :maxlife 60000.0
          :lifemult 10.0
          :max-events-per-tick 10
          )
         :audio-args
         (
          :pitchtmpl (+ 0.1 (* 0.2 y))
          :amptmpl (* (luftstrom-display::sign) (+ (* 0.01 (expt 16 (- 1 y))) (random 0.01)))
          :durtmpl (* (expt 1/3 y) (expt 0.05 (/ (aref *cc-state* 0 0) 127)) 1.8)
          :suswidthtmpl 0.1
          :suspantmpl 0.1
          :decay-starttmpl 0.001
          :decay-endtmpl 0.002
          :lfo-freqtmpl (* 50 (expt 1/2 x) (expt 5 (/ (aref *cc-state* 0 7) 127)) (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
          :x-postmpl x
          :y-postmpl y
          :wettmpl 0.7
          :filt-freqtmpl 20000
          )
         :midi-cc-fns
         (((0 0) (with-exp-midi (0.1 20)
                   (let ((speedf (funcall ipfn d2)))
                     (setf *maxspeed* (* speedf 1.05))
                     (setf *maxforce* (* speedf 0.09)))))
          ((0 1) (with-lin-midi (1 8) (setf *sepmult* (funcall ipfn d2))))
          ((0 2) (with-lin-midi (1 8) (setf *cohmult* (funcall ipfn d2))))
          ((0 3) (with-lin-midi (1 8) (setf *alignmult* (funcall ipfn d2)))))
         )))
  (progn
    (digest-params params)
    (eval (macroexpand '(param-templates->functions)))))



(funcall *wetfn* 1 2)



*maxidx*

;;; 5000 boids:

(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 1.5500001)
  (setf *maxforce* 0.0465)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 1)
  (setf *cohmult* 3)
  (setf *alignmult* 1)
  (setf *predmult* 1)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 100.0)
  (defun luftstrom-display::play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (setf *clock* 0)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (* (expt 1/2 y) (+  0.8 (random 0.2))))
     :dur 0.2
     :suswidth 1
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
     :x-pos x
     :y-pos y
     :head 200)))

;;; Drums
(defun luftstrom-display::play-sound (x y)
  (setf *clock* 1)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.5 (* 0.1 y))
   :amp (* (luftstrom-display::sign) 2)
   :dur 0.7
   :suswidth 1
   :suspan 0
   :decay-start 0.5
   :decay-end 0.7
   :lfo-freq 1
   :x-pos x
   :y-pos y
   :head 200))


(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 3.5500001)
  (setf *maxforce* 0.1465)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 3)
  (setf *cohmult* 5)
  (setf *alignmult* 5)
  (setf *predmult* 2.5)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
  (defun luftstrom-display::play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (setf *clock* 0)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (* (expt 1/2 y) (+  0.8 (random 0.2))))
     :dur 0.2
     :suswidth 1
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
     :x-pos x
     :y-pos y
     :head 200)))


(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 1.500001)
  (setf *maxforce* 0.25)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 2)
  (setf *cohmult* 2)
  (setf *alignmult* 2)
  (setf *predmult* 2.5)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
  (defun luftstrom-display::play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (setf *clock* 0)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (* (expt 1/2 y) (+  0.05 (random 0.02))))
     :dur 0.2
     :suswidth 0.5
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* y 100 (expt 2 (+ 2 (* (round (* 7 x))))))
     :x-pos x
     :y-pos y
     :head 200)))

(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 0.1500001)
  (setf *maxforce* 0.025)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 3)
  (setf *cohmult* 5)
  (setf *alignmult* 5)
  (setf *predmult* 2.5)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
  (defun luftstrom-display::play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (setf *clock* 0)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (* (expt 1/2 y) (+  0.2 (random 0.02))))
     :dur 0.2
     :suswidth 0.5
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
     :x-pos x
     :y-pos y
     :head 200)))

(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 3.5500001)
  (setf *maxforce* 0.1465)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 3)
  (setf *cohmult* 5)
  (setf *alignmult* 5)
  (setf *predmult* 2.5)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
  (defun luftstrom-display::play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (setf *clock* 0)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (* (expt 1/2 y) (+  0.8 (random 0.2))))
     :dur 0.2
     :suswidth 1
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
     :x-pos x
     :y-pos y
     :head 200)))



(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 1.5500001)
  (setf *maxforce* 0.0465)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 1)
  (setf *cohmult* 3)
  (setf *predmult* 1)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
  (defun luftstrom-display::play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (random 0.2))
     :dur 0.2
     :suswidth 1
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
     :x-pos x
     :y-pos y
     :head 200)))

(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 0.5500001)
  (setf *maxforce* 0.0165)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 2)
  (setf *cohmult* 1)
  (setf *alignmult* 1)
  (setf *predmult* 2)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (random 0.2))
     :dur 0.2
     :suswidth 1
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
     :x-pos x
     :y-pos y
     :head 200)))

(progn
  (setf *obstacles-lookahead* 2.5)
  (setf *maxspeed* 3.05)
  (setf *maxforce* 0.0915)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 2)
  (setf *cohmult* 5)
  (setf *predmult* 1)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
  (defun luftstrom-display::play-sound (x y)

    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (random 0.2))
     :dur 0.2
     :suswidth 1
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
     :x-pos x
     :y-pos y
     :head 200)))

;;; Drums:

(progn
  (setf *obstacles-lookahead* 2.5)
  (setf *maxspeed* 1.05)
  (setf *maxforce* 0.0915)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 2)
  (setf *cohmult* 1)
  (setf *predmult* 1)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 100.0)
  (defun luftstrom-display::play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (setf *clock* 3 )
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.5 (* 0.05 y))
     :amp (* (luftstrom-display::sign) 2)
     :dur 1
     :suswidth 1
     :suspan 0
     :decay-start 0.5
     :decay-end 0.6
     :lfo-freq 1
     :x-pos x
     :y-pos y
     :head 200)))


(defun luftstrom-display::play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.5 (* 0.05 y))
   :amp (* (luftstrom-display::sign) 2)
   :dur 1
   :suswidth 1
   :suspan 0
   :decay-start 0.5
   :decay-end 0.6
   :lfo-freq 1
   :x-pos x
   :y-pos y
   :head 200))
 
#|
((bus-idx bus-number)
pitch amp dur (env envelope) decay-start decay-end lfo-freq x-pos y-pos)
|#


(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.8 y))
   :amp (* (luftstrom-display::sign) (random 0.2))
   :dur 0.2
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
   :x-pos x
   :y-pos y
   :head 200))


;;; hier:

;;; 1200 boids:

(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 1.5500001)
  (setf *maxforce* 0.0465)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 1)
  (setf *cohmult* 3)
  (setf *alignmult* 1)
  (setf *predmult* 1)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
  (defun luftstrom-display::play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (random 0.2))
     :dur 0.2
     :suswidth 1
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
     :x-pos x
     :y-pos y
     :head 200)))


(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 1.5500001)
  (setf *maxforce* 0.0465)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 1)
  (setf *cohmult* 3)
  (setf *alignmult* 1)
  (setf *predmult* 1)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 10.0)
  (setf *pitchfn* (lambda (x y) x (+ 0.1 (* 0.8 y))))
  (defun luftstrom-display::play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (apply #'*pitchfn* x y)
     :amp (* (luftstrom-display::sign) (+ 0.2 (random 0.2)))
     :dur 0.2
     :suswidth 1
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.04
     :lfo-freq (* (expt 1.3 y) 10 (expt (+ 1 (* (round (* 16 x)))) 0.5))
     :x-pos x
     :y-pos y
     :head 200)))

(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 1.5500001)
  (setf *maxforce* 0.0465)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 2)
  (setf *cohmult* 1)
  (setf *alignmult* 1)
  (setf *predmult* 2)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (random 0.2))
     :dur 0.2
     :suswidth 1
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
     :x-pos x
     :y-pos y
     :head 200)))

;;; 180 Boids


(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 1.5500001)
  (setf *maxforce* 0.0465)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 2)
  (setf *cohmult* 2)
  (setf *alignmult* 2)
  (setf *predmult* 2)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 100.0)

  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (random 0.2))
     :dur 0.2
     :suswidth 0.9
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* y 100 (expt 1.3 (+ 2 (* (round (* 7 x))))))
     :x-pos x
     :y-pos y
     :head 200)))

(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 0.5500001)
  (setf *maxforce* 0.0165)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 2)
  (setf *alignmult* 1)
  (setf *cohmult* 1)
  (setf *predmult* 2)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 200.0)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.8 y))
     :amp (* (luftstrom-display::sign) (random 0.02))
     :dur 0.6
     :suswidth 1
     :suspan 0.1
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 100 (expt 1.3 (+ 2 (* (round (* 7 y))))))
     :x-pos x
     :y-pos y
     :head 200)))

(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 4.0)
  (setf *maxspeed* 1.5500001)
  (setf *maxforce* 0.0465)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 2)
  (setf *cohmult* 1)
  (setf *alignmult* 1)
  (setf *predmult* 2)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 200.0)
  (defun play-sound (x y)
        (setf *clock* 2)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.2 y))
     :amp (* (luftstrom-display::sign) (random 0.02))
     :dur 0.4
     :suswidth 0.5
     :suspan 0.2
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 50 (expt (+ 1 (* (round (* 17 y)))) 1.04))
     :x-pos x
     :y-pos y
     :head 200)))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.7 y))
   :amp (* (luftstrom-display::sign) (random 0.02) (- 1 y))
   :dur 0.6
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 50 (expt (+ 1 (* (round (* 17 y)))) 0.9))
   :x-pos x
   :y-pos y
   :head 200))


(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.8 y))
   :amp (* (luftstrom-display::sign) (random 0.2))
   :dur 0.01
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 100 (expt 1.3 (+ 2 (* (round (* 17 y))))))
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.3 (* 0.2 y))
   :amp (* (luftstrom-display::sign) (random 0.02))
   :dur 0.2
   :suswidth 1
   :suspan 0
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 2 (expt (+ x 1.3713) (+ 2 (* (round (* 7 x))))))
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.3 (* 0.2 y))
   :amp (* (luftstrom-display::sign) (random 0.2))
   :dur 0.02
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 2 (expt (+ y 1.3713) (+ 2 (* (round (* 7 y))))))
   :x-pos x
   :y-pos y
   :head 200))


(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.7 y))
   :amp (* (luftstrom-display::sign) (random 4))
   :dur 0.002
   :suswidth 0.99
   :suspan 0.5
   :decay-start 0.001
   :decay-end 0.035
   :lfo-freq 10
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.7 y))
   :amp (* (luftstrom-display::sign) (random 4))
   :dur 0.00002
   :suswidth 0.99
   :suspan 0.5
   :decay-start 0.0000001
   :decay-end 0.0000001
   :lfo-freq 10
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch 0.5
   :amp (* (luftstrom-display::sign) 2)
   :dur 1
   :suswidth 1
   :suspan 0
   :decay-start 0.5
   :decay-end 0.06
   :lfo-freq 0.1
   :x-pos x
   :y-pos y
   :head 200))


*speed*

(sc-user::sc-lfo-click-2d-out
 :pitch (+ 0.5 (* 0.1 0.5))
 :amp (* (luftstrom-display::sign) 0.05)
 :dur 3
 :suswidth 0.3
 :suspan 0.1
 :decay-start 0
 :decay-end 0.6
 :lfo-freq 330
 :x-pos 0.5
 :y-pos 0.5
 :head 200)

(progn
  (setf *speed* 2.0)
  (setf *obstacles-lookahead* 2.5)
  (setf *maxspeed* 1.5500001)
  (setf *maxforce* 0.0465)
  (setf *maxidx* 317)
  (setf *length* 5)
  (setf *sepmult* 2)
  (setf *cohmult* 1)
  (setf *predmult* 1)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
  (setf *max-events-per-tick* 10)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.5 (* 0.1 y))
     :amp (* (luftstrom-display::sign) 0.05)
     :dur 0.1
     :suswidth 0.3
     :suspan 0.5
     :decay-start 0.5
     :decay-end 0.6
     :lfo-freq 130
     :x-pos x
     :y-pos y
     :head 200))
  )



;;; Drums:

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.5 (* 0.1 y))
   :amp (* (luftstrom-display::sign) 2)
   :dur 1
   :suswidth 1
   :suspan 0
   :decay-start 0.5
   :decay-end 0.06
   :lfo-freq 1
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.2 (* 1 y))
   :amp (* (luftstrom-display::sign) 2)
   :dur 0.002
   :suswidth 0
   :suspan 0
   :decay-start 0.0005
   :decay-end 0.002
   :lfo-freq 1
   :x-pos x
   :y-pos y
   :ioffs 0.00
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.5 (* 0.1 y))
   :amp (* (luftstrom-display::sign) 2)
   :dur 2
   :suswidth 0
   :suspan 0
   :decay-start 0.13
   :decay-end 0.2
   :lfo-freq 10
   :x-pos x
   :y-pos y
   :ioffs 0.01
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.2 (* 1 y))
   :amp (* (luftstrom-display::sign) 2)
   :dur 1
   :suswidth 0
   :suspan 0
   :decay-start 0.0005
   :decay-end 0.002
   :lfo-freq 10
   :x-pos x
   :y-pos y
   :ioffs 0.00
   :head 200))


(boids)
(/ 172.0)

(let ((x 0.5) (y 1))
  (sc-user::sc-lfo-click-2d-out
   :pitch 0.5
   :amp (* (luftstrom-display::sign) 2)
   :dur 1
   :suswidth 1
   :suspan 0
   :decay-start 0.0001
   :decay-end 0.5
   :lfo-freq 0.1
   :x-pos x
   :y-pos y
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.2 y))
   :amp (* (luftstrom-display::sign) (+ (* 0.003 (expt 16 (- 1 y))) (random 0.01)))
   :dur 1.6
   :suswidth 0.4
   :suspan 0.2
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) 0.9))
   :x-pos x
   :y-pos y
   :head 200))


(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.3 y))
   :amp (* (luftstrom-display::sign) (+ (* 0.03 (expt 1/128 y)) (random 0.01)))
   :dur 0.8
   :suswidth 0.4
   :suspan 0.2
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* (expt 0.9 x) 40 (expt (+ 10 (* (round (* 16 y)))) 1.01))
   :x-pos x
   :y-pos y
   :head 200))




;;; irre (1200 boids)!

(progn
;;; 540 boids
  (let ((fac 3))
    (setf *maxspeed* (* fac 0.1))
    (setf *maxforce* (* fac 0.0003)))
  (setf *maxidx* 317)
  (setf *length* 5)

  (setf *sepmult* 0)
  (setf *alignmult* 10)
  (setf *cohmult* 4)
  (setf *predmult* 2)
  (setf *platform* nil)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 100.0)
;;  (setf *width* 640)
;;  (setf *height* 480)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.2 y))
     :amp (* (luftstrom-display::sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
     :dur 1.6
     :suswidth 0.8
     :suspan 0.5
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
     :x-pos x
     :y-pos y
     ;;     :filt-freq (* 2000 (expt 10 (- 1 y)))
     :head 200)))

(progn
;;; 540 boids
  (let ((fac 3))
    (setf *maxspeed* (* fac 0.1))
    (setf *maxforce* (* fac 0.0003)))
  (setf *maxidx* 317)
  (setf *length* 5)

  (setf *sepmult* 1)
  (setf *alignmult* 1)
  (setf *cohmult* 3)
  (setf *predmult* 2)
  (setf *platform* nil)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
;;  (setf *width* 640)
;;  (setf *height* 480)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.2 y))
     :amp (* (luftstrom-display::sign) (+ (* 0.01 (expt 16 (- 1 y))) (random 0.003)))
     :dur 1.6
     :suswidth 0.8
     :suspan 0.5
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
     :x-pos x
     :y-pos y
     :wet (+ 0.5 (* 0.5 x))
     :filt-freq (* 2000 (expt 10 y))
     :head 200)))

(progn
;;; 540 boids
  (let ((fac 3))
    (setf *maxspeed* (* fac 0.1))
    (setf *maxforce* (* fac 0.0003)))
  (setf *maxidx* 317)
  (setf *length* 5)

  (setf *sepmult* 1)
  (setf *alignmult* 1)
  (setf *cohmult* 3)
  (setf *predmult* 2)
  (setf *platform* nil)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 1000.0)
;;  (setf *width* 640)
;;  (setf *height* 480)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.2 y))
     :amp (* (luftstrom-display::sign) (+ (* 0.01 (expt 16 (- 1 y))) (random 0.003)))
     :dur 1.6
     :suswidth 0.8
     :suspan 0.5
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
     :x-pos x
     :y-pos y
     :wet (+ 0.5 (* 0.5 y))
     :filt-freq (* 200 (expt 10 y))
     :head 200)))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.2 y))
   :amp (* (luftstrom-display::sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
   :dur 1.6
   :suswidth 0.8
   :suspan 0.5
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
   :x-pos x
   :y-pos y
   :head 200))


;;; (setf *test* t)


(progn
;;; 5400 boids in 1200x800!!! 
  
  (let ((fac 1.5))
    (setf *maxspeed* (* fac 0.1))
    (setf *maxforce* (* fac 0.003)))
  (setf *maxidx* 317)
  (setf *length* 5)

  (setf *sepmult* 2)
  (setf *alignmult* 5)
  (setf *cohmult* 5)
  (setf *predmult* 1)
  (setf *platform* nil)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 200.0)
;;  (setf *width* 1200)
;;  (setf *height* 800)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.2 y))
     :amp (* (luftstrom-display::sign) (+ (* 0.01 (expt 16 (- 1 y))) (random 0.003)))
     :dur 1.6
     :suswidth 0.8
     :suspan 0.5
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
     :x-pos x
     :y-pos y
     :wet (+ 0.5 (* 0.5 y))
     :filt-freq (* 200 (expt 10 y))
     :head 200)))

(progn
;;; 5400 boids in 1200x800!!! 
  
  (let ((fac 3))
    (setf *maxspeed* (* fac 0.1))
    (setf *maxforce* (* fac 0.001)))
  (setf *maxidx* 317)
  (setf *length* 5)

  (setf *sepmult* 2)
  (setf *alignmult* 1)
  (setf *cohmult* 1)
  (setf *predmult* 1)
  (setf *platform* nil)
  (setf *maxlife* 60000.0)
  (setf *lifemult* 20.0)
;;  (setf *width* 1200)
;;  (setf *height* 800)
  (defun play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (sc-user::sc-lfo-click-2d-out
     :pitch (+ 0.1 (* 0.2 y))
     :amp (* (luftstrom-display::sign) (+ (* 0.01 (expt 16 (- 1 y))) (random 0.003)))
     :dur 1.6
     :suswidth 0.8
     :suspan 0.5
     :decay-start 0.001
     :decay-end 0.002
     :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) (+ 0.5 y)))
     :x-pos x
     :y-pos y
     :wet (+ 0.5 (* 0.5 y))
     :filt-freq (* 200 (expt 10 y))
     :head 200)))




(in-package :luftstrom-display)

(load-preset 4)

(store-curr-preset 2)
(aref )

(aref *presets* 0)


(defparameter *pitchfn* nil)
(defparameter *ampfn* nil)
(defparameter *durfn* nil)

(defparameter *fn-sym-lookup-hash* (make-hash-table))

(loop for (key name) in
     '((:pitchfn *pitchfn*)
       (:ampfn *ampfn*)
       (:durfn *durfn*))
   do (setf (gethash key *fn-sym-lookup-hash*) name))

(defun play-synth (x y z)
  (cl-synth
   :pitch (funcall *pitchfn* x y z)
   :amp (funcall *ampfn* x y z)
   :dur (funcall *durfn* x y z)))

(defparameter *preset*
  '(:audio-args
    (:pitchfn (+ 0.1 (* 0.7 y))
     :ampfn (* (sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
     :durfn (* (expt 1/3 y) 1.8))))

(loop for (key val) on (getf *preset* :audio-args) by #'cddr
   do (setf (symbol-value (gethash key *fn-name-hash*))
            (eval `(lambda (&optional x y z)
                     (declare (ignorable x y z))
                     ,val))))

;;; (funcall *pitchfn* 1 2 3) -> 1.5

(sprout
 (process
   do (luftstrom-display::play-sound 0.5
                                     (/ (aref luftstrom-display::*cc-state* 0 16)
                                        127.0))
   wait 0.5))

(defun realize-score-boards (game)
  (let ((db `((#\0 . :digit-0)
              (#\1 . :digit-1)
              (#\2 . :digit-2)
              (#\3 . :digit-3)
              (#\4 . :digit-4)
              (#\5 . :digit-5)
              (#\6 . :digit-6)
              (#\7 . :digit-7)
              (#\8 . :digit-8)
              (#\9 . :digit-9)))
        (score-chars (reverse (map 'list #'identity
                                   (format nil "~D" (score game)))))
        (highscore-chars (reverse (map 'list #'identity
                                       (format nil "~D" (highscore game))))))

    ;; realize the score board
    (setf (score-board game) nil)
    (let ((xstart .85)
          (xstep -.02)
          (ci 0))
      (dolist (c score-chars)
        (push (make-entity (cdr (assoc c db))
                           :x (+ xstart (* xstep ci)) :y .98)
              (score-board game))
        (incf ci)))

    ;; realize the highscore board
    (setf (highscore-board game) nil)
    (let ((xstart .15)
          (xstep -.02)
          (ci 0))
      (dolist (c highscore-chars)
        (push (make-entity (cdr (assoc c db))
                           :x (+ xstart (* xstep ci)) :y .98)
              (highscore-board game))
        (incf ci)))))

(let ((speedf (float 5)))
  (set-value :maxspeed (* speedf 1.05))
  (set-value :maxforce (* speedf 0.09)))


(let ((speedf (float 5)))
  (set-value :maxspeed (* speedf 1.05))
  (set-value :maxforce (* speedf 0.09)))
(in-package :luftstrom-display)

;;; preset: 0

(progn
  (setf *curr-preset*
        (copy-list
         (append
          '(:boid-params
            (:num-boids 0
             :boids-per-click 5
             :clockinterv 2
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles ((4 25))
             :curr-kernel "boids"
             :bg-amp (m-exp (aref *cc-state* 0 21) 0 1)
             :maxspeed 0.85690904
             :maxforce 0.07344935
             :maxidx 317
             :length 5
             :sepmult 1.32
             :alignmult 2.7
             :cohmult 1.93
             :predmult 1
             :maxlife 60000.0
             :lifemult 1000.0
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (n-exp y 0.4 1.08)
             :ampfn (* (sign) 3)
             :durfn (n-exp y 0.001 5.0e-4)
             :suswidthfn 0.1
             :suspanfn 0
             :decay-startfn 0.001
             :decay-endfn 0.2
             :lfo-freqfn 1
             :x-posfn x
             :y-posfn y
             :wetfn 1
             :filt-freqfn 20000)
            :midi-cc-fns
            (((4 0)
              (with-exp-midi (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (set-value :maxspeed (* speedf 1.05))
                  (set-value :maxforce (* speedf 0.09)))))
             ((4 1)
              (with-lin-midi (1 8)
                (set-value :sepmult (float (funcall ipfn d2)))))
             ((4 2)
              (with-lin-midi (1 8)
                (set-value :cohmult (float (funcall ipfn d2)))))
             ((4 3)
              (with-lin-midi (1 8)
                (set-value :alignmult (float (funcall ipfn d2)))))
             ((4 4)
              (with-lin-midi (1 10000)
                (set-value :lifemult (float (funcall ipfn d2)))))
             ((4 21)
              (with-exp-midi (0.001 1.0)
                (set-value :bg-amp (float (funcall ipfn d2)))))
             ((0 40) (make-retrig-move-fn 0 :dir :right :ref 100 :clip nil))
             ((0 50) (make-retrig-move-fn 0 :dir :left  :ref 100 :clip nil))
             ((0 60) (make-retrig-move-fn 0 :dir :up    :ref 100 :clip nil))
             ((0 70) (make-retrig-move-fn 0 :dir :down  :ref 100 :clip nil))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 0)

(m-exp-zero (nk2-ref 7) 0.01 1.0)

(m-exp (nk2-ref 16) 10 20)


(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
   :ampfn (* (sign) (n-exp y 1 0.5))
   :durfn (* (m-exp (mc-ref 6) 0.1 1) (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (m-exp (mc-ref 4) 0.25 1) (r-exp 45 45))
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 8) 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :bpfreq (n-exp y 100 5000)
   :bprq (m-lin (mc-ref 7) 1 0.01))
 (aref *audio-presets* 0))

(mapcar (lambda (x) (* x 0.63951963))  '(0.7 1.3))
(0.45 0.83)

(progn
  (edit-audio-preset *curr-audio-preset-no*))


(elt *bs-presets* 49)

(bs-state-recall 48)
