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
(cl-boids-gpu::%update-system)
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

(gl-enqueue
 (cl-boids-gpu::reshuffle-life cl-boids-gpu::*win* nil)
 )

(gl-enqueue
 (boid-coords-buffer cl-boids-gpu::*bs*)
 )
(let* ((width 960)
       (height 540)
       (monitoraspect (/ width height)))
  (setf cl-boids-gpu::*gl-x-aspect* (numerator monitoraspect))
  (setf cl-boids-gpu::*gl-y-aspect* (denominator monitoraspect))
  (cl-boids-gpu:boids :width width :height height :pos-y -15 :pos-x 960))

(bs-positions luftstrom-display::*curr-boid-state*)

(bs-state-recall 1 :load-boids t)

(bs-state-recall 6 :load-boids t)
(bs-state-recall 4 :load-boids t)
(bs-state-recall 18 :load-boids t)
(bs-state-recall 19 :load-boids t)
(bs-state-recall 21 :load-boids t)

(bs-state-recall 90 :load-boids t)
(bs-state-recall 91 :load-boids t)

(setf (val (cl-boids-gpu::bp-speed *bp*)) 1)
(setf (val (cl-boids-gpu::bp-speed *bp*)) 22)
(setf (val (cl-boids-gpu::bp-speed *bp*)) 100)
(setf (val (cl-boids-gpu::bp-speed *bp*)) 274.7)

(setf cl-boids-gpu::*curr-max-velo* 0)

*curr-boid-state*

(incudine.osc:close *pd-out*)



*retrig*
(cl-boids-gpu::vel-array-max (cl-boids-gpu::bs-velocities *curr-boid-state*))

(find-gui :pv1)

(/ 1009 1016.0)
cl-boids-gpu::*bs*


(defparameter *playing* t)

(defun generate-speeds (time &optional start)
  (let ((min 5) (max 100) (dtime 0.05))
    (if *playing*
        (let ((next (+ time dtime)))
          (with-open-file (out "/tmp/timing.txt" :direction :output :if-exists :supersede)
            (multiple-value-bind (hrs rest) (floor (- time start) 3600.0)
              (multiple-value-bind (mins secs) (floor rest 60.0)
                (format out "~2,'0d:~2,'0d:~2,'0d~%" (round hrs) (round mins) (floor secs)))))
          (setf (val (cl-boids-gpu::bp-speed *bp*)) (* min (expt (/ max min) (/ (random 128) 127))))
          (at next #'generate-speeds next start)))))

(generate-speeds (now) (now))

(setf *playing* nil)

luftstrom-display::unregister-bs-presets-handler

(apply #'max
       (remove nil (loop for p across *presets*
                         collect (getf (getf p :boid-params) :num-boids))))

(setf sb-ext::*gc-run-time* 0)
(setf (sb-ext::dynamic-space-size) (expt 2 34))



(let* ((width 960)
       (height 540)
       (monitoraspect (/ width height)))
  (setf cl-boids-gpu::*gl-x-aspect* (numerator monitoraspect))
  (setf cl-boids-gpu::*gl-y-aspect* (denominator monitoraspect))
  (cl-boids-gpu:boids :width width :height height :pos-y -15 :pos-x 960))

(defun make-stepper ()
  (let ((num 42))
    (lambda (n)
      (incf num n)
      (bs-state-recall num :load-boids t))))

(defparameter *step* (make-stepper))

(funcall *step* -1)
(funcall *step* 1)

(subseq (slot-value luftstrom-display::*curr-boid-state* 'bs-life) 0 32)
(subseq (slot-value luftstrom-display::*curr-boid-state* 'bs-velocities) 0 32)


(/ (/ 1 60.0) 0.0004)

(setf (cl-boids-gpu::lifemult *bp*) 100)


(*curr-boid-state*)

(bs-state-recall 2 :load-boids t :load-audio t)

(gl-enqueue (cl-boids-gpu::reload-programs cl-boids-gpu::*win*))

(first (cl-boids-gpu::systems cl-boids-gpu::*win*))


cl-boids-gpu::*win*

(cl-boids-gpu::bs-positions (aref *bs-presets* 19))

*curr-boid-state*
*velocities*

(elt *bs-presets* 0)
*audio-presets*
(renew-bs-preset-audio-args (elt *bs-presets* 19))
(load-presets)



(setf (aref (cl-boids-gpu::midi-cc-state (elt *bs-presets* 68)) 5 7) 0)


(progn
  (setf (cl-boids-gpu::midi-cc-state (elt *bs-presets* 66))
        (ucopy (cl-boids-gpu::midi-cc-state (elt *bs-presets* 71))))
  nil)

(progn
  (setf (cl-boids-gpu::audio-args (elt *bs-presets* 66))
        (cl-boids-gpu::audio-args (elt *bs-presets* 71)))
  nil)

Jimi: 19
schön: 37


(in-package :cl-boids-gpu)
(timer-remove-boids 300 *boids-per-click* :fadetime 0)

(timer-remove-boids 1000 *boids-per-click* :fadetime 10)
(timer-add-boids 7397 *boids-per-click* :fadetime 30)

(timer-add-boids 30 *boids-per-click* :fadetime 10)

(gl-enqueue (lambda () (add-boids *win* 1000)))
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
          :speed 1.0
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



(setf *lifemult* 100)

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
  (bp-set-value :maxspeed (* speedf 1.05))
  (bp-set-value :maxforce (* speedf 0.09)))


(let ((speedf (float 5)))
  (bp-set-value :maxspeed (* speedf 1.05))
  (bp-set-value :maxforce (* speedf 0.09)))
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
                  (bp-set-value :maxspeed (* speedf 1.05))
                  (bp-set-value :maxforce (* speedf 0.09)))))
             ((4 1)
              (with-lin-midi (1 8)
                (bp-set-value :sepmult (float (funcall ipfn d2)))))
             ((4 2)
              (with-lin-midi (1 8)
                (bp-set-value :cohmult (float (funcall ipfn d2)))))
             ((4 3)
              (with-lin-midi (1 8)
                (bp-set-value :alignmult (float (funcall ipfn d2)))))
             ((4 4)
              (with-lin-midi (1 10000)
                (bp-set-value :lifemult (float (funcall ipfn d2)))))
             ((4 21)
              (with-exp-midi (0.001 1.0)
                (bp-set-value :bg-amp (float (funcall ipfn d2)))))
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

(luftstrom-display::play-sound 0.004019394 0.15525568  0.3)

(luftstrom-display::play-sound 0.4329236 0.41563112 1 1.7789375)

(destructuring-bind (x y tidx velo) '(0.4329236 0.41563112 1 1.7789375)
  x

  )

(destructuring-bind (x y tidx velo) '(0.4329236 0.41563112 1 1.7789375)
  (let*
      ((pl-ref (tidx->player tidx))
       (fndefs (fn-defs pl-ref))
       (synth (getf (aref fndefs 0) :synth))
       (synth-id-hash (aref *audio-fn-idx-lookup* synth))
       (p1 (ensure-funcall fndefs synth-id-hash :p1 0 x y velo pl-ref))
       (p2 (ensure-funcall fndefs synth-id-hash :p2 0 x y velo pl-ref p1))
       (p3 (ensure-funcall fndefs synth-id-hash :p3 0 x y velo pl-ref p1 p2))
       (p4 (ensure-funcall fndefs synth-id-hash :p4 0 x y velo pl-ref p1 p2 p3)))
    (list p1 p2 p3 p4)))

(cuda-gui::emit-signal
 (aref (cuda-gui::buttons (gui instance)) (- d1 44)) "setState(int)" velo)


(let ((d1 51)
      (velo 127))
  (cuda-gui::emit-signal
   (aref (cuda-gui::buttons (cuda-gui::find-gui :bs1)) (- d1 44)) "setState(int)" velo))


(cuda-gui::emit-signal
 (aref (cuda-gui::buttons (cuda-gui::find-gui :bs1)) 7)
 "setState(int)" 127)

(cuda-gui::find-gui :bs1)
(find-controller :bs1)

(aref (cuda-gui::buttons (cuda-gui::find-gui :bs1)) 5)
http://icem-www.folkwang-uni.de/~finnendahl/download/kompositionen/rekurs/rekurs-noten.tgz

(apply #'max
       (loop for (x y z w) on '(-1.0508349 -0.20026743 0.0 0.0 -1.2924111 -0.6433141 0.0 0.0 -1.0522245
                                -0.08897748 0.0 0.0 -1.0220407 0.29418644 0.0 0.0 -1.0599064 0.16021626 0.0
                                0.0 -1.057147 0.22975288 0.0 0.0 -1.0728908 -0.16583887 0.0 0.0 -1.0518849
                                -0.2949693 0.0 0.0 -1.0933961 0.19053715 0.0 0.0 -1.1074722 -0.029625535 0.0
                                0.0 -1.1397549 0.049810052 0.0 0.0 -1.1300913 0.028561553 0.0 0.0 -1.3198816
                                -0.068301804 0.0 0.0 -1.1375151 -0.036141858 0.0 0.0 -1.1369094 0.13772611
                                0.0 0.0 -1.0958196 -0.3654928 0.0 0.0 -1.1079022 -0.5366998 0.0 0.0
                                -1.1977782 0.101822704 0.0 0.0 -1.1374768 0.31089452 0.0 0.0 -1.1863451
                                -0.02591045 0.0 0.0 -1.1807687 0.21600394 0.0 0.0 -1.2928439 0.16462964 0.0
                                0.0 -1.2163767 0.01349516 0.0 0.0 -1.3036516 -0.13959765 0.0 0.0 -1.3710276
                                0.4521944 0.0 0.0 -1.4492687 -0.31525648 0.0 0.0 -1.2596511 0.10909885 0.0
                                0.0 -1.3961464 -0.1464537 0.0 0.0 -1.3263397 0.16768092 0.0 0.0 -1.2000326
                                -0.39592707 0.0 0.0 -1.2370985 -0.3137174 0.0 0.0 -1.2806966 -0.13638328 0.0
                                0.0 -1.2842213 -0.10651209 0.0 0.0 -1.2768767 0.22308087 0.0 0.0 -1.2935683
                                -0.17967442 0.0 0.0 -1.3346272 -0.2615772 0.0 0.0 -1.3357089 -0.33535606 0.0
                                0.0 -1.2845428 0.49372602 0.0 0.0 -1.4171602 -0.012442972 0.0 0.0 -1.4080553
                                0.06653445 0.0 0.0 -0.79226357 -0.6746433 0.0 0.0 -1.3661809 -0.16549277 0.0
                                0.0 -1.2307453 -0.045237046 0.0 0.0 -1.3039011 -0.45601305 0.0 0.0 -1.4078687
                                0.34661543 0.0 0.0 -1.3885448 -0.02933759 0.0 0.0 -1.4195412 0.15292111 0.0
                                0.0 -1.4355109 -0.17382728 0.0 0.0 -1.462919 0.17513825 0.0 0.0 -1.4148015
                                0.34155902 0.0 0.0 -1.2822504 -0.63767123 0.0 0.0 -0.4229422 -1.1647745 0.0
                                0.0 -1.4690825 0.11270329 0.0 0.0 -1.0889864 0.36280164 0.0 0.0 -1.4181924
                                0.41662717 0.0 0.0 -1.508724 0.4179721 0.0 0.0 -1.4210746 0.06816288 0.0 0.0
                                -1.366968 -0.019410012 0.0 0.0 -1.3754174 -0.47886238 0.0 0.0 -1.482963
                                -0.37549466 0.0 0.0 -1.2728631 0.060300544 0.0 0.0 -1.5621617 0.43979603 0.0
                                0.0 -1.5583415 -0.22770414 0.0 0.0 -1.1726017 0.15657885 0.0 0.0 -1.3212264
                                0.42521974 0.0 0.0 -1.4995553 0.42958677 0.0 0.0 -0.97093356 1.0261699 0.0
                                0.0 -1.3624511 -0.71849144 0.0 0.0 -1.3662024 -0.46987495 0.0 0.0 -1.6065229
                                -0.4693631 0.0 0.0 -1.6922561 -0.3371876 0.0 0.0 -1.4485073 0.1021747 0.0 0.0
                                -1.5583915 -0.19517009 0.0 0.0 -1.5304519 -0.34569559 0.0 0.0 -1.6694026
                                -0.2637091 0.0 0.0 -1.5269879 -0.34294698 0.0 0.0 -1.6720115 0.23393303 0.0
                                0.0 -1.3685247 0.24836278 0.0 0.0 -1.4123341 0.46573612 0.0 0.0 -1.6358168
                                -0.35597697 0.0 0.0 -1.5061735 -0.68187016 0.0 0.0 -1.7752922 -0.435165 0.0
                                0.0 -1.4616308 0.46872652 0.0 0.0 -1.7607623 0.33060643 0.0 0.0 -1.1996192
                                -1.0132754 0.0 0.0 -1.4798566 -0.07364336 0.0 0.0 -1.784857 0.23983167 0.0
                                0.0 -1.6866828 -0.6204029 0.0 0.0 -1.6068314 -0.58826274 0.0 0.0 -1.5811578
                                -0.54368216 0.0 0.0 -1.8228269 0.1725776 0.0 0.0 -1.5557557 0.08481219 0.0
                                0.0 -1.3699147 -0.23084863 0.0 0.0 -1.4538808 0.12081444 0.0 0.0 -1.9017038
                                -0.05496037 0.0 0.0 -1.1467401 -0.1020246 0.0 0.0 -1.5561135 0.37629464 0.0
                                0.0 -1.4019599 0.2700786 0.0 0.0 -1.8155841 0.69524497 0.0 0.0 -1.911884
                                0.30678892 0.0 0.0 -1.6144296 0.74237293 0.0 0.0 -1.3061408 -0.67433447 0.0
                                0.0 -1.9228301 -0.37741607 0.0 0.0 -1.7507764 -0.43092325 0.0 0.0 -1.5811405
                                -0.91357476 0.0 0.0 -1.9870405 -0.2784045 0.0 0.0 -1.930993 0.6092953 0.0 0.0
                                -1.5268222 -0.6066861 0.0 0.0 -1.5163869 -0.9552388 0.0 0.0 -1.4472995
                                0.125622 0.0 0.0 -2.0954792 0.091157034 0.0 0.0 -1.2263216 -0.018941306 0.0
                                0.0 -1.9956456 -0.68466765 0.0 0.0 -2.1742153 0.70012254 0.0 0.0 -1.2733991
                                0.42298254 0.0 0.0 -1.4353802 0.14864102 0.0 0.0 -2.0392008 0.54542714 0.0
                                0.0 -1.6095784 -0.09402196 0.0 0.0 -2.0229392 0.67906237 0.0 0.0 -2.183621
                                -0.48048127 0.0 0.0 -1.576686 -0.043371443 0.0 0.0 -2.413706 0.102446355 0.0
                                0.0 -1.5716232 0.2815833 0.0 0.0 -1.5722866 -0.5037886 0.0 0.0 -1.411629
                                -0.888344 0.0 0.0 -1.0618159 0.4250188 0.0 0.0 -2.2065215 0.19846462 0.0 0.0
                                -1.9277618 0.13724239 0.0 0.0 -2.1720984 -0.74713415 0.0 0.0 -1.7833933
                                -0.77760184 0.0 0.0 -1.6515831 -0.20032401 0.0 0.0 -2.513544 0.9348229 0.0
                                0.0 -2.2397923 -0.6129674 0.0 0.0 -1.7088053 0.13636531 0.0 0.0 -1.4540489
                                0.30869287 0.0 0.0 -1.9250597 0.11650048 0.0 0.0 -1.4018208 0.20053843 0.0
                                0.0 -1.1803852 0.07660457 0.0 0.0 -2.4423378 0.3037182 0.0 0.0 -2.116891
                                -1.1348386 0.0 0.0 -1.9481255 -0.54326653 0.0 0.0 -1.5293486 0.16448951 0.0
                                0.0 -1.6771318 0.5361349 0.0 0.0 -1.714592 -0.27462703 0.0 0.0 -1.711766
                                0.36952728 0.0 0.0 -2.438722 0.32839197 0.0 0.0 -2.4528286 -0.9410782 0.0 0.0
                                -2.4433212 -0.5064781 0.0 0.0 -1.6400629 0.42613396 0.0 0.0 -0.9903402
                                -1.0409939 0.0 0.0 -2.3702066 -0.8786783 0.0 0.0 -1.5157015 0.37742704 0.0
                                0.0 -2.2798011 1.17207 0.0 0.0 -2.643149 -0.17962392 0.0 0.0 -1.4235504
                                -0.38653848 0.0 0.0 -2.4454896 -0.8821849 0.0 0.0 -2.604698 0.2469238 0.0 0.0
                                -1.3151269 -0.21339509 0.0 0.0 -2.5952413 0.616104 0.0 0.0 -2.6133246
                                0.41523278 0.0 0.0 -2.4615908 -1.1568946 0.0 0.0 -1.68804 -0.7127223 0.0 0.0
                                -1.6231356 -0.598499 0.0 0.0 -1.2278458 -1.0855252 0.0 0.0 -2.2869747
                                0.22690666 0.0 0.0 -1.6436013 0.11336221 0.0 0.0 -2.7618065 -0.5732085 0.0
                                0.0 -2.3577952 -0.29084444 0.0 0.0 -1.7408633 0.055355027 0.0 0.0 -1.4417683
                                0.13005653 0.0 0.0 -2.6146996 -1.0329838 0.0 0.0 -2.9149413 -0.8653722 0.0
                                0.0 -1.7977648 -0.40704527 0.0 0.0 -1.2938272 -0.6907631 0.0 0.0 -2.9098713
                                0.2130157 0.0 0.0 -2.8958488 0.12880564 0.0 0.0 -2.132022 0.733311 0.0 0.0
                                -1.3256761 -1.9068301 0.0 0.0 -1.3611412 0.36621928 0.0 0.0 -1.6168622
                                -0.69917834 0.0 0.0 -2.8841157 -0.7510271 0.0 0.0 -2.1653965 -0.63573736 0.0
                                0.0 -2.0332055 -0.076647505 0.0 0.0 -1.2906877 -0.44265455 0.0 0.0 -1.4548347
                                0.30870688 0.0 0.0 -1.1476853 0.45621982 0.0 0.0 -3.0334122 0.22313718 0.0
                                0.0 -1.1971114 -0.27535704 0.0 0.0 -2.8535821 0.7966654 0.0 0.0 -2.3404183
                                -0.10913946 0.0 0.0 -1.7085875 0.34070987 0.0 0.0 -2.4354851 0.17705768 0.0
                                0.0 -3.091662 0.5548972 0.0 0.0 -1.7202401 -0.6812968 0.0 0.0 -1.9360461
                                -0.051778745 0.0 0.0 -1.1794207 -1.067522 0.0 0.0 -2.6830812 -1.5240031 0.0
                                0.0 -1.4464066 0.13166305 0.0 0.0 -1.7223003 0.29118717 0.0 0.0 -2.3968463
                                -0.3232352 0.0 0.0 -3.475212 0.033927843 0.0 0.0 -1.3142464 -0.21424565 0.0
                                0.0 -1.3145021 0.2861579 0.0 0.0 -1.9016167 -0.49202025 0.0 0.0 -3.3899605
                                -0.38490644 0.0 0.0 -1.1011205 -0.62599015 0.0 0.0 -1.862986 0.4741514 0.0
                                0.0 -1.7686851 0.0034601537 0.0 0.0 -0.69566005 -0.35655433 0.0 0.0
                                -1.8035274 0.48381174 0.0 0.0 -3.6700938 -0.27833533 0.0 0.0 -3.5943978
                                0.398056 0.0 0.0 -3.4519384 0.12861845 0.0 0.0 -2.8277733 -1.3847119 0.0 0.0
                                -3.4905214 0.38330373 0.0 0.0 -1.43642 -0.15917659 0.0 0.0 -1.783255
                                -0.38164315 0.0 0.0 -2.5601099 -0.7545985 0.0 0.0 -1.1206241 0.46642387 0.0
                                0.0 -3.138694 1.738866 0.0 0.0 -1.3313212 -0.5377806 0.0 0.0 -1.5536022
                                0.6666326 0.0 0.0 -1.6780597 2.1144626 0.0 0.0 -2.3347707 -0.8738187 0.0 0.0
                                -2.3451905 -0.96379954 0.0 0.0 -1.8446459 -0.22653025 0.0 0.0 -1.9419422
                                -0.19670291 0.0 0.0 -3.7864804 -0.4686985 0.0 0.0 -3.4434927 -0.8927993 0.0
                                0.0 -1.4107441 0.02198302 0.0 0.0 -1.7487775 -0.69420683 0.0 0.0 -2.4105952
                                -1.3378953 0.0 0.0 -3.7566786 0.13534115 0.0 0.0 -2.6737478 -0.070161335 0.0
                                0.0 -3.8224564 -0.026754074 0.0 0.0 -2.5952942 0.40903607 0.0 0.0 -0.8383215
                                -1.2190096 0.0 0.0 -1.4447669 -0.19299486 0.0 0.0 -1.2860004 -0.5631362 0.0
                                0.0 -2.6859531 0.38136056 0.0 0.0 -2.2272213 -1.196593 0.0 0.0 -2.0196378
                                0.3182854 0.0 0.0 -1.2147908 0.38182554 0.0 0.0 -1.2176418 -0.3557876 0.0 0.0
                                -0.4338266 -0.93729174 0.0 0.0 -3.4991026 1.9213638 0.0 0.0 -2.8672318
                                0.4581179 0.0 0.0 -1.4718236 -0.016328871 0.0 0.0 -2.6841857 0.45856565 0.0
                                0.0 -1.4608334 0.22168162 0.0 0.0 -1.8676403 0.7295323 0.0 0.0 -1.3239924
                                0.09067337 0.0 0.0 -1.0812675 -0.99015284 0.0 0.0 -4.124463 -0.13020994 0.0
                                0.0 -1.5471201 -0.5412318 0.0 0.0 -1.241052 -0.03168659 0.0 0.0 -2.796306
                                1.2313861 0.0 0.0 -1.2128478 0.0897264 0.0 0.0 -4.388827 -0.5218295 0.0 0.0
                                -1.472108 -0.14918968 0.0 0.0 -3.510711 -2.3864267 0.0 0.0 -2.0028737
                                0.73888826 0.0 0.0 -4.2048397 0.34995142 0.0 0.0 -1.3712968 0.007503152 0.0
                                0.0 -0.7347476 -0.6026892 0.0 0.0 -2.8187046 0.8009103 0.0 0.0 -1.9839272
                                0.410975 0.0 0.0 -1.343652 0.11686136 0.0 0.0 -3.1051745 0.7808165 0.0 0.0
                                -2.580241 -0.39138204 0.0 0.0 -1.8999422 -0.20761958 0.0 0.0 -2.477737
                                -1.5317613 0.0 0.0 -1.4066256 0.070977576 0.0 0.0 -2.9084172 -0.117457174 0.0
                                0.0 -1.487222 0.06421054 0.0 0.0 -4.920259 0.4190139 0.0 0.0 -1.4908246
                                1.1160187 0.0 0.0 -1.9140868 -0.5361653 0.0 0.0 -1.4085264 -0.29230174 0.0
                                0.0 -1.109943 0.9503856 0.0 0.0 -4.392375 1.7860432 0.0 0.0 -4.1271806
                                2.1011932 0.0 0.0 -4.461303 -1.4247367 0.0 0.0 -1.2382689 0.15858537 0.0 0.0
                                -2.7226002 -1.6614809 0.0 0.0 -3.198878 -0.4055834 0.0 0.0 -1.4650341
                                0.019827388 0.0 0.0 -1.4249582 0.29257292 0.0 0.0 -3.193533 -0.33074945 0.0
                                0.0 -4.695859 0.8752108 0.0 0.0 -1.3978251 -0.095189944 0.0 0.0 -1.1890036
                                0.6898676 0.0 0.0 -2.8844824 1.0478289 0.0 0.0 -1.9589962 -0.971646 0.0 0.0
                                -1.1980691 -0.3082993 0.0 0.0 -2.1761193 -0.28948444 0.0 0.0 -4.9442606
                                0.5670223 0.0 0.0 -4.863294 0.9143836 0.0 0.0 -3.0355942 0.54211986 0.0 0.0
                                -5.098547 -0.64454406 0.0 0.0 -1.244084 0.81439894 0.0 0.0 -1.1582106
                                -1.4757118 0.0 0.0 -2.8796816 -1.7118571 0.0 0.0 -5.050168 0.5839182 0.0 0.0
                                -3.1519055 0.835192 0.0 0.0 -3.0770872 -1.363352 0.0 0.0 -1.3634759
                                0.12360463 0.0 0.0 -5.3779697 -0.17604221 0.0 0.0 -5.3507066 0.5205715 0.0
                                0.0 -5.3270106 -0.56812453 0.0 0.0 -3.1483295 0.52708495 0.0 0.0 -2.1962938
                                -0.01544556 0.0 0.0 -5.1796117 -0.8274021 0.0 0.0 -3.496929 -0.03003165 0.0
                                0.0 -2.9218025 0.78252137 0.0 0.0 -1.4892213 0.03447014 0.0 0.0 -5.4747124
                                -0.95219654 0.0 0.0 -3.2273443 -0.06539251 0.0 0.0 -4.958768 -2.1750853 0.0
                                0.0 -5.4142413 0.29391465 0.0 0.0 -4.6072063 -3.320052 0.0 0.0 -5.415578
                                -1.4152199 0.0 0.0 -1.9699955 -0.7081849 0.0 0.0 -5.064809 -2.9335122 0.0 0.0
                                -1.2477964 0.6537357 0.0 0.0 -1.2981104 -0.24955 0.0 0.0 -2.3353825
                                -0.17209804 0.0 0.0 -6.3561215 0.9235129 0.0 0.0 -1.4815316 -0.038685907 0.0
                                0.0 -0.597054 0.7677821 0.0 0.0 -3.5577142 -0.27279866 0.0 0.0 -4.0788555
                                0.61319077 0.0 0.0 -1.2421347 0.18766713 0.0 0.0 -6.0204587 -1.505485 0.0 0.0
                                -5.5453515 0.92896205 0.0 0.0 -3.5350587 0.14372958 0.0 0.0 -1.4802774
                                0.06363205 0.0 0.0 -3.533388 -0.48400956 0.0 0.0 -5.5971394 -1.7958211 0.0
                                0.0 -1.9536253 0.584723 0.0 0.0 -1.2356198 0.79938996 0.0 0.0 -1.2084849
                                -0.69342464 0.0 0.0 -1.3268883 0.1955134 0.0 0.0 -3.1328373 1.7757118 0.0 0.0
                                -2.7303724 -1.8388934 0.0 0.0 -3.3360116 1.8359731 0.0 0.0 -3.8298805
                                -0.4548698 0.0 0.0 -2.050836 -0.1575659 0.0 0.0 -1.4065483 0.019376533 0.0
                                0.0 -2.3660698 0.44540444 0.0 0.0 -5.2020664 3.2240617 0.0 0.0 -2.2812934
                                -0.53137547 0.0 0.0 -1.4740115 0.21994734 0.0 0.0 -6.154345 -1.7278546 0.0
                                0.0 -1.3640347 -0.4113518 0.0 0.0 -1.3510572 0.53904265 0.0 0.0 -3.3646266
                                1.5311832 0.0 0.0 -3.4160218 -1.2103186 0.0 0.0 -1.3952104 0.010813876 0.0
                                0.0 -3.5509531 -1.0363097 0.0 0.0 -3.2522123 1.8620439 0.0 0.0 -1.2928945
                                0.18899311 0.0 0.0 -1.4163917 -1.9631695 0.0 0.0 -1.3890052 -0.11583001 0.0
                                0.0 -5.8662257 -2.644508 0.0 0.0 -5.1404033 4.0387583 0.0 0.0 -1.4803792
                                -0.100292526 0.0 0.0 -2.1615226 -0.016459165 0.0 0.0 -1.4437182 0.33059964
                                0.0 0.0 -3.6691902 0.8361001 0.0 0.0 -1.8933206 1.0203238 0.0 0.0 -2.4665663
                                0.023635859 0.0 0.0 -2.1265342 -0.34256008 0.0 0.0 -2.1887984 -0.12954396 0.0
                                0.0 -2.2435534 -0.079866484 0.0 0.0 -3.3345408 1.3516611 0.0 0.0 -1.4511474
                                -0.25302073 0.0 0.0 -1.2114706 -0.82470185 0.0 0.0 -1.4566563 -0.049689434
                                0.0 0.0 -3.690975 -0.81259394 0.0 0.0 -1.206216 0.81160223 0.0 0.0 -2.239274
                                -0.057541106 0.0 0.0 -3.8428829 0.5013094 0.0 0.0 -8.135962 -0.6730309 0.0
                                0.0 -1.4506029 0.14782415 0.0 0.0 -1.4169906 0.22670051 0.0 0.0 -1.3161278
                                0.69527227 0.0 0.0 -1.0977914 -0.8256524 0.0 0.0 -7.218099 0.5208391 0.0 0.0
                                -1.4104235 -0.17420998 0.0 0.0 -2.1297827 0.71244425 0.0 0.0 -2.3086088
                                0.4706045 0.0 0.0 -1.4430879 -0.023486987 0.0 0.0 -6.9502883 -2.0788264 0.0
                                0.0 -7.564538 1.3604982 0.0 0.0 -1.4550239 0.20777428 0.0 0.0 -3.8958776
                                -0.6961704 0.0 0.0 -2.3590133 0.2229223 0.0 0.0 -1.1121609 0.4321687 0.0 0.0
                                -2.197259 0.644873 0.0 0.0 -1.4143964 0.32482895 0.0 0.0 -2.2817285
                                -0.011245891 0.0 0.0 -1.4715561 0.083634704 0.0 0.0 -7.430881 0.5097729 0.0
                                0.0 -3.9968264 1.0949448 0.0 0.0 -1.4028422 -0.06572549 0.0 0.0 -3.3075464
                                -2.9266727 0.0 0.0 -3.1214993 2.5853884 0.0 0.0 -3.7662694 -1.419169 0.0 0.0
                                -1.1834078 0.775896 0.0 0.0 -1.3851676 0.24891227 0.0 0.0 -1.4305925
                                -0.13362484 0.0 0.0 -4.0591264 0.53114194 0.0 0.0 -1.259276 0.5451488 0.0 0.0
                                -8.283397 2.2444627 0.0 0.0 -6.374436 4.402794 0.0 0.0 -3.933651 -1.4677233
                                0.0 0.0 -7.3632965 2.7378356 0.0 0.0 -1.3948454 -0.040757507 0.0 0.0
                                -1.5766064 1.3611581 0.0 0.0 -1.2948946 -0.666961 0.0 0.0 -4.6812043
                                0.40121302 0.0 0.0 -1.4059379 -0.26120573 0.0 0.0 -4.560835 -0.463363 0.0 0.0
                                -1.4533017 0.14197092 0.0 0.0 -2.4521682 0.84026706 0.0 0.0 -1.4182198
                                -0.03500703 0.0 0.0 -1.360066 0.2898951 0.0 0.0 -1.286695 -0.7291139 0.0 0.0
                                -2.3693109 -0.23510389 0.0 0.0 -2.3921335 -0.8145163 0.0 0.0 -2.209948
                                0.45469522 0.0 0.0 -1.060892 0.12318349 0.0 0.0 -1.1998895 -0.5768097 0.0 0.0
                                -6.902437 -4.5703673 0.0 0.0 -4.651065 0.4234176 0.0 0.0 -7.972107 -2.3305185
                                0.0 0.0 -2.5728202 0.64011616 0.0 0.0 -1.3725067 0.47001296 0.0 0.0
                                -1.4357723 0.27279064 0.0 0.0 -2.2746885 0.43830213 0.0 0.0 -1.2353306
                                0.20620766 0.0 0.0 -4.0039134 -1.7529517 0.0 0.0 -1.3173829 0.5541875 0.0 0.0
                                -1.327546 0.057946995 0.0 0.0 -4.250131 5.008727e-4 0.0 0.0 -1.4531975
                                0.3265653 0.0 0.0 -2.462007 -0.90527374 0.0 0.0 -4.585966 -1.1509879 0.0 0.0
                                -4.4730887 0.44484952 0.0 0.0 -1.442912 -0.02088472 0.0 0.0 -8.849694
                                -0.6341423 0.0 0.0 -1.4160868 -0.02263555 0.0 0.0 -9.350849 0.33022457 0.0
                                0.0 -1.453607 0.051235374 0.0 0.0 -4.572016 0.066050075 0.0 0.0 -8.695997
                                1.2530806 0.0 0.0 -2.307988 0.3608952 0.0 0.0 -4.6520905 0.37579134 0.0 0.0
                                -8.409856 -3.3377228 0.0 0.0 -9.041297 -0.22454253 0.0 0.0 -1.3956457
                                -0.18514267 0.0 0.0 -4.517358 1.242679 0.0 0.0 -7.8450813 -4.6807623 0.0 0.0
                                -7.825277 0.63551366 0.0 0.0 -2.2594073 -0.482305 0.0 0.0 -5.010398
                                -0.84181565 0.0 0.0 -2.4216142 0.46447304 0.0 0.0 -1.3805952 -0.2124187 0.0
                                0.0 -1.186468 0.6334864 0.0 0.0 -9.347603 0.24203542 0.0 0.0 -2.4217012
                                1.3728582 0.0 0.0 -1.2001512 -0.079407334 0.0 0.0 -10.996122 -0.041574415 0.0
                                0.0 -1.3772984 0.34555244 0.0 0.0 -2.7664626 -0.4002189 0.0 0.0 -1.3044913
                                0.5342083 0.0 0.0 -1.1622292 0.1007838 0.0 0.0 -1.0195899 -0.53480417 0.0 0.0
                                -2.735215 -0.4848883 0.0 0.0 -2.5198798 -0.20678863 0.0 0.0 -2.2319798
                                -1.078468 0.0 0.0 -12.069116 0.3729715 0.0 0.0 -1.3728788 -0.27129817 0.0 0.0
                                -1.2680526 -0.5624185 0.0 0.0 -9.928052 -0.5307482 0.0 0.0 -0.63945055
                                0.27275226 0.0 0.0 -1.3102833 0.17455709 0.0 0.0 -0.98286134 -0.78565097 0.0
                                0.0 -3.1151643 3.1301422 0.0 0.0 -1.3630124 0.0884845 0.0 0.0 -2.6429923
                                -0.39997053 0.0 0.0 -1.7607226 -0.5547689 0.0 0.0 -1.4456313 0.18016326 0.0
                                0.0 -1.4281559 0.13743065 0.0 0.0 -2.779991 0.47696862 0.0 0.0 -1.4581141
                                -0.20813602 0.0 0.0 -1.2008194 -0.74987745 0.0 0.0 -4.5913076 2.1552815 0.0
                                0.0 -10.235416 0.17684965 0.0 0.0 -1.2759833 -0.8159512 0.0 0.0 -1.4580407
                                0.123351574 0.0 0.0 -2.0985427 -1.3931838 0.0 0.0 -1.3899972 -0.44103405 0.0
                                0.0 -4.930653 -1.3917415 0.0 0.0 -2.458203 -0.8349647 0.0 0.0 -10.464874
                                1.6886066 0.0 0.0 -10.678526 -0.079134464 0.0 0.0 -4.9606576 0.5134996 0.0
                                0.0 -2.4076207 0.39678812 0.0 0.0 -2.2343543 -1.5692685 0.0 0.0 -10.44598
                                2.433942 0.0 0.0 -2.1633391 1.0850896 0.0 0.0 -2.4719272 -0.110985935 0.0 0.0
                                -1.3222079 -0.205378 0.0 0.0 -4.9285746 0.884381 0.0 0.0 -1.327169
                                0.027842196 0.0 0.0 -4.7216835 -1.9672252 0.0 0.0 -1.1489644 -0.6544229 0.0
                                0.0 -2.5591044 0.5189122 0.0 0.0 -1.0330234 -0.7879179 0.0 0.0 -2.200333
                                0.9743426 0.0 0.0 -1.3069268 0.050953653 0.0 0.0 -4.333241 -1.9432311 0.0 0.0
                                -1.3059701 0.10022166 0.0 0.0 -2.204813 -0.3261251 0.0 0.0 -1.3340375
                                0.13761695 0.0 0.0 -1.2263929 0.28705725 0.0 0.0 -1.2419962 0.41516292 0.0
                                0.0 -4.6645703 2.0380833 0.0 0.0 -4.4133205 -2.7327535 0.0 0.0 -5.421458
                                -0.96411765 0.0 0.0 -0.5937917 0.88062465 0.0 0.0 -2.4046605 -0.39016917 0.0
                                0.0 -1.2343794 0.4249298 0.0 0.0 -2.3744586 -0.66826695 0.0 0.0 -1.2560809
                                0.114109464 0.0 0.0 -1.1729467 0.17448978 0.0 0.0 -1.2297473 -0.4038161 0.0
                                0.0 -2.4797153 -0.4048906 0.0 0.0 -5.536696 0.78096783 0.0 0.0 -1.2679497
                                -0.110203795 0.0 0.0 -0.9730717 -0.8352336 0.0 0.0 -5.195065 0.97699994 0.0
                                0.0 -5.257233 -0.8202211 0.0 0.0 -1.1103365 0.4904955 0.0 0.0 -2.5033083
                                1.0718639 0.0 0.0 -2.4151945 0.038870826 0.0 0.0 -1.2186885 0.39834103 0.0
                                0.0 -5.368437 0.93577534 0.0 0.0 -2.4839346 -0.08349773 0.0 0.0 -1.2728841
                                0.011154431 0.0 0.0 -4.5887933 -2.7225873 0.0 0.0 -0.97306675 0.1744943 0.0
                                0.0 -1.2697206 0.40791628 0.0 0.0 -2.2669122 1.1312124 0.0 0.0 -2.5328286
                                0.8613759 0.0 0.0 -5.2731504 -1.4335902 0.0 0.0 -2.2789028 -1.4321768 0.0 0.0
                                -2.677436 -0.15264267 0.0 0.0 -1.2598065 0.3484268 0.0 0.0 -2.6258957
                                0.6621722 0.0 0.0 -2.7476807 -1.1786206 0.0 0.0 -1.933597 -1.312276 0.0 0.0
                                -5.4695673 1.1758813 0.0 0.0 -1.3142836 -0.08975014 0.0 0.0 -1.2439809
                                -0.4417427 0.0 0.0 -5.4460173 -0.92811614 0.0 0.0 -5.708364 0.3658671 0.0 0.0
                                -1.271479 -0.39227274 0.0 0.0 -5.9939823 -1.0001401 0.0 0.0 -5.710327
                                -0.91124225 0.0 0.0 -2.874896 0.63953084 0.0 0.0 -1.2119915 -0.4179049 0.0
                                0.0 -2.4996936 -0.6478813 0.0 0.0 -5.831275 -0.98452526 0.0 0.0 -5.9099755
                                -1.3779103 0.0 0.0 -1.0694509 0.7139685 0.0 0.0 -1.297817 -0.03863508 0.0 0.0
                                -6.4724054 -1.553748 0.0 0.0 -1.2545635 0.99193835 0.0 0.0 -1.221385
                                0.3078851 0.0 0.0 -2.6460648 -0.30239972 0.0 0.0 -5.975616 1.3268464 0.0 0.0
                                -5.588359 -1.0522963 0.0 0.0 -2.37624 1.391612 0.0 0.0 -1.2691053 0.43095738
                                0.0 0.0 -0.41389528 1.2374437 0.0 0.0 -2.5796087 0.3122072 0.0 0.0 -2.6065657
                                -0.98201895 0.0 0.0 -1.0720799 -0.7803385 0.0 0.0 -2.3079536 1.274318 0.0 0.0
                                -6.1120076 -0.39000195 0.0 0.0 -1.3174834 -0.24416304 0.0 0.0 -1.1438179
                                -0.5939736 0.0 0.0 -2.3670049 -1.0947989 0.0 0.0 -2.637899 1.0526565 0.0 0.0
                                -6.4768476 0.8420774 0.0 0.0 -2.7612975 -0.5224899 0.0 0.0 -1.2158955
                                -0.44881094 0.0 0.0 -1.2002745 -0.49669877 0.0 0.0 -0.91157985 -0.84987706
                                0.0 0.0 -2.4555984 -0.71687496 0.0 0.0 -5.9562936 0.62359756 0.0 0.0
                                -5.889823 -0.5063529 0.0 0.0 -2.646583 -0.35082573 0.0 0.0 -5.0117435
                                3.1777642 0.0 0.0 -5.9709477 -0.2331719 0.0 0.0 -2.6163602 -0.3585325 0.0 0.0
                                -0.8760997 -1.0238401 0.0 0.0 -1.2406152 -0.4939082 0.0 0.0 -2.7240088
                                0.85755634 0.0 0.0 -2.5891256 1.2756196 0.0 0.0 -1.0196334 -0.80012816 0.0
                                0.0 -2.6532547 0.103024475 0.0 0.0 -0.8175356 -1.0772411 0.0 0.0 -2.6734908
                                0.869535 0.0 0.0 -1.2816374 0.16669615 0.0 0.0 -1.1645583 0.018406183 0.0 0.0
                                -1.1532294 0.6607663 0.0 0.0 -2.3958235 -1.0965868 0.0 0.0 -2.5040734
                                -0.9546347 0.0 0.0 -1.2006607 -0.4519529 0.0 0.0 -2.512465 1.4831362 0.0 0.0
                                -0.73009926 -1.0443074 0.0 0.0 -1.3094783 -0.22634624 0.0 0.0 -1.280032
                                0.35155016 0.0 0.0 -6.379336 -1.5747502 0.0 0.0 -5.701153 2.404025 0.0 0.0
                                -1.1756704 0.5394429 0.0 0.0 -1.2705895 0.17183208 0.0 0.0 -1.1713566
                                0.44643924 0.0 0.0 -1.316125 0.077044755 0.0 0.0 -2.8602173 -0.33642396 0.0
                                0.0 -1.3772014 -0.068977766 0.0 0.0 -0.77405244 -0.3633732 0.0 0.0 -6.2463603
                                0.71580285 0.0 0.0 -2.8560755 -0.35409927 0.0 0.0 -1.1921493 -0.5786635 0.0
                                0.0 -2.8275905 0.7158241 0.0 0.0 -1.3203032 0.1917631 0.0 0.0 -2.6566901
                                -0.62655634 0.0 0.0 -2.7930768 -0.8703565 0.0 0.0 -1.278681 0.37298393 0.0
                                0.0 -6.374165 0.07443995 0.0 0.0 -2.890377 -0.5929548 0.0 0.0 -1.2340324
                                -0.054002672 0.0 0.0 -2.5476894 -4.02767 0.0 0.0 -1.2563659 0.0687931 0.0 0.0
                                -2.8875153 0.77321845 0.0 0.0 -1.3040375 0.29214475 0.0 0.0 -2.728818
                                -1.1644539 0.0 0.0 -1.2385509 0.39469847 0.0 0.0 -1.1412283 -0.62523943 0.0
                                0.0 -6.5714025 0.60231304 0.0 0.0 -1.4637386 -0.047593933 0.0 0.0 -2.7022085
                                0.38793376 0.0 0.0 -2.9228017 -0.9251015 0.0 0.0 -1.1222187 -0.539286 0.0 0.0
                                -1.0559858 -0.38834676 0.0 0.0 -6.587891 -1.0606081 0.0 0.0 -2.7386212
                                -0.17216459 0.0 0.0 -1.2322743 0.03820935 0.0 0.0 -0.9955187 -0.3606386 0.0
                                0.0 -1.073582 -0.700312 0.0 0.0 -6.545449 1.0215701 0.0 0.0 -1.2279112
                                0.27674362 0.0 0.0 -7.806262 0.7359497 0.0 0.0 -1.2236173 -0.54757273 0.0 0.0
                                -2.7801862 0.42171037 0.0 0.0 -1.1579806 0.42033437 0.0 0.0 -2.8006768
                                0.41847354 0.0 0.0 -1.0845902 0.69597036 0.0 0.0 -1.0127959 -0.87957627 0.0
                                0.0 -7.598426 0.8953555 0.0 0.0 -2.9087484 0.6171467 0.0 0.0 -1.3059925
                                -0.21280606 0.0 0.0 -1.1455528 -0.5003733 0.0 0.0 -1.146304 -0.23243779 0.0
                                0.0 -7.0332646 1.0081964 0.0 0.0 -6.6048083 -1.9370202 0.0 0.0 -2.7739787
                                -0.3945968 0.0 0.0 -2.4874775 0.7654249 0.0 0.0 -1.261029 -0.34563795 0.0 0.0
                                -1.0063921 0.7079878 0.0 0.0 -3.0306394 0.4174511 0.0 0.0 -7.141506
                                -1.1822292 0.0 0.0 -7.0628796 -0.61656505 0.0 0.0 -4.9462814 -1.5419843 0.0
                                0.0 -6.5905023 4.4033923 0.0 0.0 -7.0404916 0.32316062 0.0 0.0 -6.965571
                                -0.8764681 0.0 0.0 -2.754726 -0.7376924 0.0 0.0 -2.805036 0.30107048 0.0 0.0
                                -1.2754402 0.40559196 0.0 0.0 -1.2745849 0.1893394 0.0 0.0 -0.9676571
                                0.87633055 0.0 0.0 -3.002236 0.697071 0.0 0.0 -1.1314151 0.59244895 0.0 0.0
                                -7.548955 0.7610108 0.0 0.0 -2.6561296 0.25980565 0.0 0.0 -7.3309546 1.50946
                                0.0 0.0 -1.2615418 -0.10572321 0.0 0.0 -1.2328143 0.48449254 0.0 0.0
                                -7.0650115 1.3064717 0.0 0.0 -1.9079366 -1.3635458 0.0 0.0 -10.170682
                                -1.0262433 0.0 0.0 -3.0993993 0.11997202 0.0 0.0 -7.246048 -1.7309291 0.0 0.0
                                -3.0425034 0.034792557 0.0 0.0 -2.7178774 1.0799958 0.0 0.0 -6.5183926
                                -3.228397 0.0 0.0 -1.241165 0.31093433 0.0 0.0 -6.9273067 2.434638 0.0 0.0
                                -3.0647485 0.27097753 0.0 0.0 -7.2413516 1.1059794 0.0 0.0 -1.2552445
                                -0.30378512 0.0 0.0 -7.384418 -0.38764253 0.0 0.0 -6.74214 2.7390115 0.0 0.0
                                -1.2074344 0.49604768 0.0 0.0 -1.323103 -0.20919397 0.0 0.0 -2.7368374
                                0.9817342 0.0 0.0 -1.1030065 -0.3302249 0.0 0.0 -3.1120348 -0.21858788 0.0
                                0.0 -7.341663 1.2138538 0.0 0.0 -1.0563401 -0.7683494 0.0 0.0 -2.9990869
                                -0.87535745 0.0 0.0 -7.710606 3.0232322 0.0 0.0 -7.324486 -1.7825639 0.0 0.0
                                -2.7911034 0.7812218 0.0 0.0 -8.047194 -1.4669799 0.0 0.0 -6.4681253
                                -3.6806169 0.0 0.0 -1.224023 -0.3301206 0.0 0.0 -2.919301 -0.29145187 0.0 0.0
                                -6.9703608 -2.6532912 0.0 0.0 -1.3359694 0.11517077 0.0 0.0 -1.3234355
                                0.09140334 0.0 0.0 -7.627599 -1.3745526 0.0 0.0 -7.272177 1.9592799 0.0 0.0
                                -7.9643726 -0.27989933 0.0 0.0 -1.3087455 0.06373304 0.0 0.0 -2.864707
                                0.60463804 0.0 0.0 -1.2746497 0.3158014 0.0 0.0 -2.7483454 -1.2768356 0.0 0.0
                                -1.2829188 -0.019022187 0.0 0.0 -7.396348 1.8388232 0.0 0.0 -2.4115958
                                -1.7961189 0.0 0.0 -2.990632 -0.2557446 0.0 0.0 -7.1721025 -3.6498249 0.0 0.0
                                -2.7587378 -1.1121075 0.0 0.0 -1.2230647 -0.4051059 0.0 0.0 -3.2157192
                                0.32484087 0.0 0.0 -1.2373956 0.20203619 0.0 0.0 -1.2855877 0.047533587 0.0
                                0.0 -7.0765095 3.3624847 0.0 0.0 -8.429816 -1.1584246 0.0 0.0 -7.8006516
                                0.9749658 0.0 0.0 -1.2389896 -0.5004033 0.0 0.0 -2.8139524 -0.051231395 0.0
                                0.0 -2.792996 1.0744611 0.0 0.0 -6.9728456 -3.7445211 0.0 0.0 -7.9481997
                                0.68766 0.0 0.0 -1.2601178 0.16871938 0.0 0.0 -1.2025341 0.42253554 0.0 0.0
                                -7.559659 -2.1828575 0.0 0.0 -1.3169364 -0.20145872 0.0 0.0 -0.82676244
                                -0.21183251 0.0 0.0 -7.874858 -0.7217197 0.0 0.0 -6.460618 4.862274 0.0 0.0
                                -3.9226155 -0.25120842 0.0 0.0 -7.647248 3.033478 0.0 0.0 -1.4054674
                                0.4960907 0.0 0.0 -3.5552113 -0.94352823 0.0 0.0 -3.2725217 -1.0615653 0.0
                                0.0 -9.172054 -1.8357277 0.0 0.0 -2.9296288 -1.1570708 0.0 0.0 -3.4145865
                                -0.30228794 0.0 0.0 -0.8244221 0.72396654 0.0 0.0 -19.691614 11.545186 0.0
                                0.0 -7.7890277 3.4666348 0.0 0.0 -1.0530782 -0.6391561 0.0 0.0 -1.3853235
                                -0.54807067 0.0 0.0 -3.1750307 -1.3587176 0.0 0.0 -2.6441069 1.0994843 0.0
                                0.0 -8.559892 -2.2036054 0.0 0.0 -8.177945 -2.148611 0.0 0.0 -2.8289263
                                -0.34947175 0.0 0.0 -25.271849 -3.8311682 0.0 0.0 -23.35312 5.6042533 0.0 0.0
                                -1.4774388 -0.15803732 0.0 0.0 -2.8026357 -0.53046006 0.0 0.0 -23.34669
                                -3.2708018 0.0 0.0 -9.01906 -2.1135654 0.0 0.0 -8.231284 -4.697927 0.0 0.0
                                -1.4105896 0.3711675 0.0 0.0 -8.518046 -0.7869024 0.0 0.0 -1.4124036
                                -0.17343742 0.0 0.0 -1.4780406 0.16574503 0.0 0.0 -3.0776503 0.82942784 0.0
                                0.0 -8.4076605 -2.5047243 0.0 0.0 -3.1227064 1.0979488 0.0 0.0 -8.504178
                                1.9394267 0.0 0.0 -8.530519 1.8986471 0.0 0.0 -1.3109753 0.5784205 0.0 0.0
                                -3.1970873 -0.15947033 0.0 0.0 -9.498652 -1.3265499 0.0 0.0 -29.838818
                                -0.8916197 0.0 0.0 -3.6959062 -0.51982635 0.0 0.0 -25.629093 -2.4911177 0.0
                                0.0 -3.343614 0.3041216 0.0 0.0 -3.233749 1.5212237 0.0 0.0 -2.7312374
                                0.034104034 0.0 0.0 -8.485456 -2.7811303 0.0 0.0 -7.319773 5.3934727 0.0 0.0
                                -24.257227 2.9985218 0.0 0.0 -8.909971 0.6490939 0.0 0.0 -10.053924 3.4955924
                                0.0 0.0 -3.7379737 -0.8411886 0.0 0.0 -0.82640547 0.73814416 0.0 0.0
                                -1.4104098 0.44345823 0.0 0.0 -9.517067 -1.5704682 0.0 0.0 -8.977768
                                0.87010944 0.0 0.0 -3.1770866 0.7846809 0.0 0.0 -3.6582053 -1.1429363 0.0 0.0
                                -24.904905 3.8660796 0.0 0.0 -8.946929 1.1142062 0.0 0.0 -1.4053125
                                0.28436822 0.0 0.0 -3.6182597 0.45732465 0.0 0.0 -1.3965863 0.036882844 0.0
                                0.0 -3.183629 1.4442723 0.0 0.0 -24.469488 -13.091957 0.0 0.0 -3.6380663
                                -0.83550924 0.0 0.0 -1.4828423 0.15160878 0.0 0.0 -10.495422 -0.2380495 0.0
                                0.0 -3.055537 -1.1831145 0.0 0.0 -8.506884 -2.4772427 0.0 0.0 -27.909407
                                -3.7921402 0.0 0.0 -1.1147493 0.29077747 0.0 0.0 -9.121664 2.8744085 0.0 0.0
                                -2.8572726 -0.8635402 0.0 0.0 -8.991129 -1.7767019 0.0 0.0 -3.342609
                                -0.43533337 0.0 0.0 -1.4690078 -0.0051154904 0.0 0.0 -1.4057295 0.43966785
                                0.0 0.0 -1.4217584 0.3699316 0.0 0.0 -3.2259812 0.6918316 0.0 0.0 -3.6549146
                                -1.3881366 0.0 0.0 -28.329283 -0.6628691 0.0 0.0 -3.0633173 -1.8666836 0.0
                                0.0 -3.4032273 1.1657726 0.0 0.0 -9.629573 -3.92129 0.0 0.0 -1.4474086
                                0.32547918 0.0 0.0 -9.244633 -2.887204 0.0 0.0 -9.682917 -3.5505888 0.0 0.0
                                -0.96125984 -0.43006468 0.0 0.0 -3.354114 -1.4194354 0.0 0.0 -27.403666
                                2.97009 0.0 0.0 -9.062038 3.307197 0.0 0.0 -9.360627 -1.5853726 0.0 0.0
                                -3.4115028 -1.166197 0.0 0.0 -1.337376 -0.0057718605 0.0 0.0 -4.1381507
                                -0.23821941 0.0 0.0 -8.686426 4.502857 0.0 0.0 -9.244767 -3.1566894 0.0 0.0
                                -3.5118408 1.038506 0.0 0.0 -1.1074817 0.66463757 0.0 0.0 -1.3684285
                                -0.21231902 0.0 0.0 -25.827663 14.293895 0.0 0.0 -27.840178 -10.633002 0.0
                                0.0 -1.4341952 -0.4015741 0.0 0.0 -9.169797 2.3053808 0.0 0.0 -3.5788472
                                1.1099129 0.0 0.0 -34.353065 -3.0085583 0.0 0.0 -3.6682045 1.2870308 0.0 0.0
                                -1.3101707 -0.30505988 0.0 0.0 -10.080431 -1.318281 0.0 0.0 -27.411264
                                6.870429 0.0 0.0 -1.1638709 -0.32492596 0.0 0.0 -1.2558411 -0.6607568 0.0 0.0
                                -0.91974276 1.158076 0.0 0.0 -3.7177002 0.25120562 0.0 0.0 -1.5462937
                                0.3861017 0.0 0.0 -1.2770895 0.10654622 0.0 0.0 -3.5048428 0.9242082 0.0 0.0
                                -7.2090583 3.9977105 0.0 0.0 -8.82595 6.9570074 0.0 0.0 -27.789867 10.04477
                                0.0 0.0 -9.212566 -3.8880098 0.0 0.0 -4.001933 -0.30369624 0.0 0.0 -2.637503
                                -0.9636861 0.0 0.0 -8.686264 4.401793 0.0 0.0 -4.0465074 -0.47306266 0.0 0.0
                                -9.078947 -3.088459 0.0 0.0 -3.0671039 -2.6826305 0.0 0.0 -27.864414
                                -11.369677 0.0 0.0 -21.835587 -21.131659 0.0 0.0 -9.8669405 4.032442 0.0 0.0
                                -3.230324 -1.2829763 0.0 0.0 -29.609793 2.3593357 0.0 0.0 -33.557266
                                -5.5530334 0.0 0.0 -30.96103 0.4038718 0.0 0.0 -2.580271 -2.7543721 0.0 0.0
                                -3.4481604 -0.39767936 0.0 0.0 -1.4270828 -0.07264629 0.0 0.0 -9.839626
                                -2.322662 0.0 0.0 -10.063956 1.7197238 0.0 0.0 -9.92196 -3.5204065 0.0 0.0
                                -10.088159 0.7778772 0.0 0.0 -3.7106225 -1.55719 0.0 0.0 -1.4183924
                                -0.03272856 0.0 0.0 -1.401911 -0.067107335 0.0 0.0 -10.06441 1.6372229 0.0
                                0.0 -9.388206 -4.818711 0.0 0.0 -3.8469522 -0.7519534 0.0 0.0 -3.9534671
                                1.1479206 0.0 0.0 -1.220503 0.14889805 0.0 0.0 -1.2012421 -0.43276796 0.0 0.0
                                -10.345998 1.9454851 0.0 0.0 -46.10633 -9.465002 0.0 0.0 -2.6844113
                                -1.1380792 0.0 0.0 -11.709023 -0.41513246 0.0 0.0 -3.7533624 0.8496592 0.0
                                0.0 -28.185904 -5.1902413 0.0 0.0 -41.437073 3.682268 0.0 0.0 -10.739117
                                2.2387638 0.0 0.0 -1.4716734 -0.19479394 0.0 0.0 -3.6361713 -0.9220476 0.0
                                0.0 -31.47728 -3.5942652 0.0 0.0 -32.22472 -1.0078198 0.0 0.0 -10.4465685
                                -1.4336221 0.0 0.0 -1.2535772 0.41632026 0.0 0.0 -1.2840238 -0.696156 0.0 0.0
                                -9.415507 -6.564497 0.0 0.0 -1.3402495 -0.41494474 0.0 0.0 -1.4117265
                                0.11684735 0.0 0.0 -11.675966 0.89848465 0.0 0.0 -1.3173605 -0.252907 0.0 0.0
                                -1.1500297 -0.61130977 0.0 0.0 -4.125876 -0.12107175 0.0 0.0 -3.0975413
                                0.17713253 0.0 0.0 -3.5736046 -1.2933091 0.0 0.0 -10.710351 5.177132 0.0 0.0
                                -28.644272 -16.884691 0.0 0.0 -1.4521313 0.11291887 0.0 0.0 -32.420025
                                -9.040438 0.0 0.0 -1.3786935 -0.28125507 0.0 0.0 -11.007079 -4.5045414 0.0
                                0.0 -3.5741823 -0.13420324 0.0 0.0 -3.7726045 0.1629839 0.0 0.0 -1.3947968
                                -0.29801506 0.0 0.0 -32.342175 9.008304 0.0 0.0 -13.893719 0.9877748 0.0 0.0
                                -10.286556 2.7792473 0.0 0.0 -1.4907752 -0.02978557 0.0 0.0 -11.039428
                                3.4427402 0.0 0.0 -1.4031801 -0.31401828 0.0 0.0 -9.240716 4.7654514 0.0 0.0
                                -11.524695 0.32309225 0.0 0.0 -4.0472274 -1.185473 0.0 0.0 -11.04004
                                -0.62965596 0.0 0.0 -3.5448275 1.2688898 0.0 0.0 -10.799336 3.0750296 0.0 0.0
                                -1.4732382 -0.20793147 0.0 0.0 -1.4887747 -0.10389792 0.0 0.0 -11.40848
                                -3.9330692 0.0 0.0 -1.4339503 -0.24074085 0.0 0.0 -3.4586203 -1.1916738 0.0
                                0.0 -1.3732713 -0.1788591 0.0 0.0 -4.0636606 -0.7017894 0.0 0.0 -1.4053283
                                -0.4806449 0.0 0.0 -1.323918 0.5424222 0.0 0.0 -3.6182234 -0.015300685 0.0
                                0.0 -1.3560024 0.48174942 0.0 0.0 -3.2253654 1.5475706 0.0 0.0 -3.1540818
                                -2.5809999 0.0 0.0 -3.9837914 -1.1704754 0.0 0.0 -12.770209 -2.0847237 0.0
                                0.0 -1.3687183 0.48427638 0.0 0.0 -11.556171 -1.0145812 0.0 0.0 -1.4752178
                                0.19957092 0.0 0.0 -3.930238 0.6329839 0.0 0.0 -1.4351425 -0.06577904 0.0 0.0
                                -29.68619 27.690584 0.0 0.0 -3.9177115 -0.2192461 0.0 0.0 -11.978983
                                -1.5091164 0.0 0.0 -1.4470521 -0.16835003 0.0 0.0 -36.266655 -0.086257875 0.0
                                0.0 -11.491355 2.005394 0.0 0.0 -12.548124 -0.61743784 0.0 0.0 -1.3690058
                                -0.12814847 0.0 0.0 -4.34267 0.90911084 0.0 0.0 -1.364051 0.5034118 0.0 0.0
                                -3.6605082 -0.5566953 0.0 0.0 -13.092783 2.6918223 0.0 0.0 -4.0791097
                                0.8498437 0.0 0.0 -10.944158 3.291977 0.0 0.0 -11.7902565 0.34928474 0.0 0.0
                                -4.276716 -1.4788357 0.0 0.0 -3.4883146 -0.74214655 0.0 0.0 -1.2993455
                                0.39659968 0.0 0.0 -3.267338 1.7759972 0.0 0.0 -11.414593 -1.3811816 0.0 0.0
                                -1.172787 0.78304154 0.0 0.0 -4.0969586 0.49495336 0.0 0.0 -3.7138226
                                0.963399 0.0 0.0 -3.6887033 -1.628877 0.0 0.0 -12.690759 2.3085203 0.0 0.0
                                -1.4299084 0.33247638 0.0 0.0 -3.7484984 -1.4424732 0.0 0.0 -9.23892
                                -2.6459825 0.0 0.0 -1.1702178 0.81667084 0.0 0.0 -12.27403 -3.1686532 0.0 0.0
                                -38.488335 10.625584 0.0 0.0 -11.542563 4.8161016 0.0 0.0 -3.933895 1.6719763
                                0.0 0.0 -11.904979 0.6635768 0.0 0.0 -12.925745 -3.3342023 0.0 0.0 -1.4520068
                                -0.15108734 0.0 0.0 -1.3341519 -0.59305257 0.0 0.0 -3.676982 1.4046364 0.0
                                0.0 -34.291122 -17.753595 0.0 0.0 -1.3902891 0.5315429 0.0 0.0 -13.165364
                                1.5454212 0.0 0.0 -11.011286 4.149513 0.0 0.0 -1.469574 0.1013191 0.0 0.0
                                -3.5471363 -1.8893224 0.0 0.0 -1.4062158 -0.17562304 0.0 0.0 -0.56627977
                                0.43565077 0.0 0.0 -1.3970538 -0.12814908 0.0 0.0 -4.420857 0.5327281 0.0 0.0
                                -1.1633078 -0.50163674 0.0 0.0 -38.957417 15.458797 0.0 0.0 -1.4125215
                                0.07297084 0.0 0.0 -13.306846 2.039527 0.0 0.0 -8.106201 -8.378434 0.0 0.0
                                -1.2556356 0.2890206 0.0 0.0 -3.4250622 1.9694387 0.0 0.0 -1.2292138
                                -0.43829843 0.0 0.0 -1.4790744 -0.052739576 0.0 0.0 -13.765174 -0.5309446 0.0
                                0.0 -47.613937 7.1436043 0.0 0.0 -13.591277 -3.069333 0.0 0.0 -3.9980938
                                -0.2511878 0.0 0.0 -1.3648775 -0.47682613 0.0 0.0 -38.519173 23.184553 0.0
                                0.0 -10.800927 -5.4853177 0.0 0.0 -4.477673 -0.20346254 0.0 0.0 -11.987443
                                3.4340963 0.0 0.0 -3.8272097 1.7338238 0.0 0.0 -13.369161 0.49270275 0.0 0.0
                                -12.454517 -5.300834 0.0 0.0 -3.0819683 2.2928164 0.0 0.0 -1.4880121
                                -0.08521942 0.0 0.0 -3.8082087 0.13917986 0.0 0.0 -1.2337464 0.51066184 0.0
                                0.0 -13.4766865 -3.3665724 0.0 0.0 -1.1734906 0.5219716 0.0 0.0 -1.388322
                                0.46949762 0.0 0.0 -52.748417 -1.4840628 0.0 0.0 -1.4594762 -0.0070249843 0.0
                                0.0 -1.1957066 -0.7008424 0.0 0.0 -12.3909 -2.563866 0.0 0.0 -1.4429235
                                0.22860129 0.0 0.0 -15.033418 -3.8277235 0.0 0.0 -3.6309485 1.3685788 0.0 0.0
                                -1.4167616 -0.0028336644 0.0 0.0 -12.399594 0.5915263 0.0 0.0 -4.0100727
                                -1.2469109 0.0 0.0 -45.934284 -9.35579 0.0 0.0 -10.579205 9.357056 0.0 0.0
                                -4.5714054 0.22760269 0.0 0.0 -1.4726712 0.14053726 0.0 0.0 -39.97078
                                18.509928 0.0 0.0 -3.8500717 -0.5765818 0.0 0.0 -45.315594 -2.992978 0.0 0.0
                                -1.150248 0.53662264 0.0 0.0 -1.383416 -0.19900748 0.0 0.0 -1.3952737
                                -0.23742257 0.0 0.0 -42.921597 -12.056427 0.0 0.0 -14.054119 -1.6774715 0.0
                                0.0 -17.5075 4.2671356 0.0 0.0 -1.3650675 0.23054035 0.0 0.0 -3.580127
                                1.4004397 0.0 0.0 -54.86965 -12.465814 0.0 0.0 -1.4842682 0.07898645 0.0 0.0
                                -43.300106 13.006524 0.0 0.0 -1.4497322 0.056681227 0.0 0.0 -44.566223
                                -1.3728584 0.0 0.0 -1.3389893 -0.40894535 0.0 0.0 -1.1635518 -0.619958 0.0
                                0.0 -1.2967349 0.5038939 0.0 0.0 -13.762305 4.7385645 0.0 0.0 -3.9027114
                                1.7603719 0.0 0.0 -4.184072 -0.594192 0.0 0.0 -4.62962 -0.25475875 0.0 0.0
                                -1.4254657 -0.23233613 0.0 0.0 -4.003698 -0.095334075 0.0 0.0 -13.276881
                                0.52445096 0.0 0.0 -12.492975 3.5198514 0.0 0.0 -3.6847272 -0.90367776 0.0
                                0.0 -13.287083 1.6329877 0.0 0.0 -4.268547 -0.75172466 0.0 0.0 -13.030305
                                -0.69377357 0.0 0.0 -12.816878 5.485917 0.0 0.0 -1.446607 0.4175753 0.0 0.0
                                -1.212581 0.53294015 0.0 0.0 -13.7357645 6.3713856 0.0 0.0 -13.825847
                                -2.2179713 0.0 0.0 -14.865021 3.6037412 0.0 0.0 -4.894137 1.5785428 0.0 0.0
                                -1.4527258 0.0021263806 0.0 0.0 -13.412514 5.008689 0.0 0.0 -49.63776
                                -20.528301 0.0 0.0 -11.952209 9.034414 0.0 0.0 -0.9480506 0.01917085 0.0 0.0
                                -1.3357106 -0.13399692 0.0 0.0 -1.2442338 -0.30351126 0.0 0.0 -3.752562
                                1.179994 0.0 0.0 -13.498238 2.396934 0.0 0.0 -3.555538 -1.5885717 0.0 0.0
                                -4.224254 -0.521064 0.0 0.0 -14.971682 -2.0896137 0.0 0.0 -13.439301
                                -3.4712143 0.0 0.0 -4.745728 0.4216851 0.0 0.0 -12.6010895 6.0513935 0.0 0.0
                                -12.67708 -5.7033386 0.0 0.0 -14.229803 4.2812796 0.0 0.0 -1.4371625
                                -0.24399225 0.0 0.0 -3.9513316 -0.5659854 0.0 0.0 -1.4745128 0.01588843 0.0
                                0.0 -1.1861773 -0.4306677 0.0 0.0 -1.3851328 0.027071156 0.0 0.0 -5.4139805
                                -0.24257079 0.0 0.0 -45.742588 18.180332 0.0 0.0 -1.3740389 0.32068405 0.0
                                0.0 -1.2810643 -0.22421277 0.0 0.0 -1.411461 -0.42825392 0.0 0.0 -14.834602
                                0.14213383 0.0 0.0 -4.27229 -1.7472724 0.0 0.0 -42.635235 26.620033 0.0 0.0
                                -1.4765977 -0.18461938 0.0 0.0 -18.730528 4.951751 0.0 0.0 -3.3747892
                                -1.8888831 0.0 0.0 -14.128635 0.31382364 0.0 0.0 -1.3495337 -0.4947854 0.0
                                0.0 -4.458677 -1.6448852 0.0 0.0 -14.193278 -0.62607944 0.0 0.0 -1.0849516
                                -0.9542178 0.0 0.0 -13.737825 3.234705 0.0 0.0 -15.486827 2.2327023 0.0 0.0
                                -1.3910488 -0.41357207 0.0 0.0 -4.6905255 0.6895054 0.0 0.0 -4.2123427
                                1.1595536 0.0 0.0 -13.843639 -5.501567 0.0 0.0 -1.0177019 0.940021 0.0 0.0
                                -15.917521 0.7283983 0.0 0.0 -4.4283915 0.46059194 0.0 0.0 -15.722522
                                -0.5183919 0.0 0.0 -1.3829476 0.1655789 0.0 0.0 -4.097269 -0.87656015 0.0 0.0
                                -3.6197507 -1.9845147 0.0 0.0 -65.90737 -1.7234821 0.0 0.0 -4.005915 1.843267
                                0.0 0.0 -3.251538 -0.14642632 0.0 0.0 -16.132376 -2.7075846 0.0 0.0 -15.2777
                                4.7922435 0.0 0.0 -4.5608025 -0.45494786 0.0 0.0 -54.839535 -5.3734226 0.0
                                0.0 -10.920883 8.880367 0.0 0.0 -16.198019 -2.417957 0.0 0.0 -52.775764
                                -7.6592803 0.0 0.0 -51.760715 3.9060082 0.0 0.0 -4.0287104 0.9158489 0.0 0.0
                                -4.4432335 0.97320473 0.0 0.0 -15.990756 1.0459677 0.0 0.0 -48.624756
                                25.456305 0.0 0.0 -1.4680967 0.017046135 0.0 0.0 -11.843529 8.801801 0.0 0.0
                                -1.3434153 -0.11141769 0.0 0.0 -3.7439318 2.661815 0.0 0.0 -4.1358724
                                -1.0379815 0.0 0.0 -14.787836 0.36974666 0.0 0.0 -1.1928153 0.5922511 0.0 0.0
                                -14.471487 -7.603229 0.0 0.0 -1.3790032 0.07266113 0.0 0.0 -1.4536692
                                -0.039960157 0.0 0.0 -1.2635815 0.5832069 0.0 0.0 -15.007518 1.5723933 0.0
                                0.0 -1.383473 -0.32757717 0.0 0.0 -14.96564 -0.43305302 0.0 0.0 -1.3974273
                                -0.22891876 0.0 0.0 -4.8882723 0.54521966 0.0 0.0 -60.291546 25.99861 0.0 0.0
                                -3.96842 1.6074594 0.0 0.0 -4.1571465 0.09967422 0.0 0.0 -4.1933126
                                -0.3015138 0.0 0.0 -1.3817832 0.40420687 0.0 0.0 -1.372412 0.43289614 0.0 0.0
                                -14.5476 1.8961159 0.0 0.0 -1.3891338 -0.5440304 0.0 0.0 -14.6044445
                                -2.154317 0.0 0.0 -1.4063263 -0.46620706 0.0 0.0 -1.3743242 0.41653302 0.0
                                0.0 -12.426278 10.1022215 0.0 0.0 -57.401756 -11.522103 0.0 0.0 -16.222013
                                2.3442461 0.0 0.0 -1.1803094 -0.37804094 0.0 0.0 -1.4501204 0.21567397 0.0
                                0.0 -15.478558 4.876457 0.0 0.0 -4.0189357 0.57071716 0.0 0.0 -1.3890089
                                -0.20231815 0.0 0.0 -1.3766547 0.22955413 0.0 0.0 -1.3622739 -0.4360028 0.0
                                0.0 -14.221462 -7.0314684 0.0 0.0 -1.4839078 -0.01911377 0.0 0.0 -3.0830035
                                0.35544658 0.0 0.0 -0.92458874 -0.9313723 0.0 0.0 -4.1259956 -0.44508523 0.0
                                0.0 -16.827436 -1.0208585 0.0 0.0 -15.086766 -0.83457863 0.0 0.0 -4.7746634
                                0.6612812 0.0 0.0 -16.716349 -2.2661023 0.0 0.0 -1.4431179 -0.10840383 0.0
                                0.0 -14.418744 -5.64653 0.0 0.0 -20.521952 2.4392488 0.0 0.0 -16.96111
                                -3.0552728 0.0 0.0 -5.05282 -0.19952904 0.0 0.0 -1.2153882 -0.5080454 0.0 0.0
                                -1.2820725 0.51711667 0.0 0.0 -2.8560693 -3.4849887 0.0 0.0 -56.361687
                                -11.84299 0.0 0.0 -16.422207 -4.6511717 0.0 0.0 -58.198215 16.318604 0.0 0.0
                                -1.3002567 -0.3364614 0.0 0.0 -15.119503 6.66927 0.0 0.0 -4.1452584
                                -2.7128332 0.0 0.0 -4.2133827 -1.4753287 0.0 0.0 -4.0981526 0.94647694 0.0
                                0.0 -58.209522 -7.341998 0.0 0.0 -1.4524947 0.2693365 0.0 0.0 -1.4671459
                                -0.24222544 0.0 0.0 -1.4407066 -0.074695446 0.0 0.0 -4.062013 1.5388389 0.0
                                0.0 -86.15428 -18.83572 0.0 0.0 -13.443795 9.195864 0.0 0.0 -3.7537897
                                2.1095324 0.0 0.0 -1.1722306 -0.84637934 0.0 0.0 -1.4850678 0.05224325 0.0
                                0.0 -13.687441 -10.302239 0.0 0.0 -1.3218309 0.6217059 0.0 0.0 -1.3236893
                                0.21056269 0.0 0.0 -60.467426 4.93267 0.0 0.0 -3.9945688 -0.62969506 0.0 0.0
                                -3.9642553 -1.88373 0.0 0.0 -16.237036 -2.8382447 0.0 0.0 -4.803693
                                -0.6540354 0.0 0.0 -1.4436412 0.04604768 0.0 0.0 -1.1927778 0.49723026 0.0
                                0.0 -16.242264 0.40474048 0.0 0.0 -60.781544 -3.8805468 0.0 0.0 -3.1018314
                                2.583084 0.0 0.0 -1.2104794 -0.8556628 0.0 0.0 -4.2243395 1.4845427 0.0 0.0
                                -3.7907124 -0.35299808 0.0 0.0 -15.812514 3.9237263 0.0 0.0 -58.698746
                                -18.529797 0.0 0.0 -0.6890819 1.1990117 0.0 0.0 -15.975304 4.0880284 0.0 0.0
                                -68.20708 48.553967 0.0 0.0 -16.213886 -1.8858482 0.0 0.0 -4.849809
                                -0.48891565 0.0 0.0 -20.206106 -2.4208894 0.0 0.0 -1.0702626 -0.017931528 0.0
                                0.0 -1.4355032 -0.3920741 0.0 0.0 -87.36291 -3.5786462 0.0 0.0 -1.354173
                                -0.099488325 0.0 0.0 -1.3400053 -0.53294826 0.0 0.0 -4.576708 0.8458446 0.0
                                0.0 -4.6368694 1.5833528 0.0 0.0 -4.2127237 2.2103605 0.0 0.0 -3.7565222
                                1.9646208 0.0 0.0 -16.79348 -7.6741867 0.0 0.0 -17.803823 1.9651128 0.0 0.0
                                -1.3308884 0.047621246 0.0 0.0 -4.5596914 -0.23340856 0.0 0.0 -20.460073
                                2.6080463 0.0 0.0 -14.133681 -2.972367 0.0 0.0 -1.2828206 -0.010093719 0.0
                                0.0 -18.263136 2.4915633 0.0 0.0 -1.03017 -0.8248585 0.0 0.0 -1.2286388
                                -0.51892626 0.0 0.0 -16.81637 0.04184747 0.0 0.0 -1.3118316 0.12208699 0.0
                                0.0 -4.12796 -1.2200698 0.0 0.0 -16.324495 0.838937 0.0 0.0 -17.489185
                                -2.2321105 0.0 0.0 -16.555025 0.37720957 0.0 0.0 -4.6120586 -0.90110177 0.0
                                0.0 -1.2834282 -0.27655992 0.0 0.0 -1.2602333 -0.44040415 0.0 0.0 -16.113197
                                4.8076873 0.0 0.0 -21.168934 2.3648112 0.0 0.0 -14.527054 10.581522 0.0 0.0
                                -1.3159562 -0.1482857 0.0 0.0 -1.3205678 -0.16014445 0.0 0.0 -4.813514
                                -0.2879887 0.0 0.0 -15.714802 -7.2359424 0.0 0.0 -15.778913 5.684761 0.0 0.0
                                -4.6564035 0.29823732 0.0 0.0 -5.306233 1.4694387 0.0 0.0 -18.451385
                                -3.2956197 0.0 0.0 -1.0695665 0.77124697 0.0 0.0 -1.2843403 0.38158423 0.0
                                0.0 -4.770557 -1.0198148 0.0 0.0 -1.2379162 0.4851276 0.0 0.0 -17.912273
                                -3.5339 0.0 0.0 -4.630516 -0.9343733 0.0 0.0 -1.3361498 0.08741699 0.0 0.0
                                -17.154165 2.6493034 0.0 0.0 -20.819471 -3.5663476 0.0 0.0 -5.0353518
                                1.4905027 0.0 0.0 -17.365456 11.308812 0.0 0.0 -19.897453 4.0420914 0.0 0.0
                                -17.215103 1.3746936 0.0 0.0 -4.2944603 0.88264346 0.0 0.0 -1.2686434
                                -0.13251747 0.0 0.0 -0.63753235 1.1304909 0.0 0.0 -1.0819267 -0.62359923 0.0
                                0.0 -17.177114 3.6480522 0.0 0.0 -1.3257022 -0.08921777 0.0 0.0 -1.3377852
                                -0.067278616 0.0 0.0 -1.2966678 0.23043239 0.0 0.0 -3.8234637 2.8147697 0.0
                                0.0 -0.9887953 0.525044 0.0 0.0 -4.6680155 1.0278702 0.0 0.0 -4.0130105
                                2.0433626 0.0 0.0 -4.39703 -1.912861 0.0 0.0 -4.019102 1.665953 0.0 0.0
                                -4.7693233 0.5829094 0.0 0.0 -17.49493 -1.8257269 0.0 0.0 -1.062252
                                0.07399425 0.0 0.0 -4.7367983 0.95597625 0.0 0.0 -4.4339414 0.40237167 0.0
                                0.0 -1.3402783 -0.037325375 0.0 0.0 -3.999987 -1.7573783 0.0 0.0 -4.404552
                                -1.6163497 0.0 0.0 -19.522633 -5.3716183 0.0 0.0 -1.3213927 3.2179058e-4 0.0
                                0.0 -1.3202246 0.08069418 0.0 0.0 -1.267159 0.11822194 0.0 0.0 -15.032662
                                8.803616 0.0 0.0 -16.958527 5.5124125 0.0 0.0 -4.516644 -1.7832358 0.0 0.0
                                -3.799388 2.3237195 0.0 0.0 -21.550365 9.041916 0.0 0.0 -20.815157 2.2395113
                                0.0 0.0 -4.4340944 -0.52677554 0.0 0.0 -4.377642 -0.02179104 0.0 0.0
                                -1.2354054 0.5178845 0.0 0.0 -4.317543 -2.058734 0.0 0.0 -18.46057 4.7020845
                                0.0 0.0 -18.598516 1.3899293 0.0 0.0 -12.4724245 -12.496315 0.0 0.0 -1.313555
                                -0.02861562 0.0 0.0 -24.219053 -0.12250973 0.0 0.0 -20.617222 -2.1303892 0.0
                                0.0 -20.625326 -2.292806 0.0 0.0 -4.816266 0.9401439 0.0 0.0 -15.31617
                                8.635259 0.0 0.0 -1.0629492 -0.23602363 0.0 0.0 -3.904668 1.3041656 0.0 0.0
                                -16.247152 7.828258 0.0 0.0 -3.714228 -3.1682422 0.0 0.0 -17.029018
                                -6.0594025 0.0 0.0 -1.2845953 0.23934568 0.0 0.0 -24.023039 -0.5192366 0.0
                                0.0 -1.3018439 -0.32242364 0.0 0.0 -21.209614 -1.6305734 0.0 0.0 -4.2147264
                                1.4847454 0.0 0.0 -4.5167394 0.3212248 0.0 0.0 -4.344738 1.2197816 0.0 0.0
                                -18.78412 -3.3652728 0.0 0.0 -4.956756 0.13306132 0.0 0.0 -4.4907184
                                2.1134331 0.0 0.0 -3.5223315 -2.8636415 0.0 0.0 -3.8462584 -2.31893 0.0 0.0
                                -18.20784 -3.533482 0.0 0.0 -1.2496257 -0.43828225 0.0 0.0 -1.284167
                                -0.0932025 0.0 0.0 -4.56153 2.5968475 0.0 0.0 -4.642944 -0.06540683 0.0 0.0
                                -4.4288177 -0.57060313 0.0 0.0 -1.2180377 0.49988824 0.0 0.0 -1.2272305
                                -0.3666273 0.0 0.0 -20.275259 -0.08553016 0.0 0.0 -1.1353077 0.6859544 0.0
                                0.0 -20.273874 -3.401364 0.0 0.0 -4.332256 -0.79976827 0.0 0.0 -18.236166
                                -2.2074072 0.0 0.0 -1.1798197 -0.6334026 0.0 0.0 -1.2852613 0.23919046 0.0
                                0.0 -1.3305546 0.13153617 0.0 0.0 -4.711462 1.7177933 0.0 0.0 -5.044501
                                0.44931397 0.0 0.0 -17.670721 5.44161 0.0 0.0 -0.86931574 0.97091264 0.0 0.0
                                -4.4568667 0.22553834 0.0 0.0 -4.554871 -0.67784196 0.0 0.0 -21.22151
                                3.9390805 0.0 0.0 -5.0734954 -1.3946608 0.0 0.0 -1.3168358 -0.13601452 0.0
                                0.0 -1.2993245 -0.32927555 0.0 0.0 -23.624718 4.215967 0.0 0.0 -4.4887366
                                -0.4414786 0.0 0.0 -5.038968 1.4773198 0.0 0.0 -4.8854733 -1.2019824 0.0 0.0
                                -1.3832345 -0.004102271 0.0 0.0 -1.0726117 0.8043493 0.0 0.0 -18.887453
                                -1.9889158 0.0 0.0 -4.5804033 -0.5530093 0.0 0.0 -4.687477 -1.1058569 0.0 0.0
                                -1.2082994 -0.4921985 0.0 0.0 -1.3145285 -0.19271071 0.0 0.0 -1.2023747
                                -0.40343115 0.0 0.0 -1.1557667 0.50636226 0.0 0.0 -3.9568822 -2.3231137 0.0
                                0.0 -1.2840986 -0.38279158 0.0 0.0 -18.569796 -4.791638 0.0 0.0 -4.906347
                                -1.2783697 0.0 0.0 -1.2966992 0.22994749 0.0 0.0 -19.51167 -2.7011585 0.0 0.0
                                -1.2696859 -0.1600309 0.0 0.0 -1.2840087 0.35261104 0.0 0.0 -21.404034
                                1.5530572 0.0 0.0 -18.91017 -2.6656559 0.0 0.0 -3.8396618 -2.1277997 0.0 0.0
                                -1.329635 0.15994115 0.0 0.0 -22.217178 -5.4264517 0.0 0.0 -5.2880526
                                0.52243525 0.0 0.0 -4.5078807 -0.38282812 0.0 0.0 -4.9308677 -0.21961136 0.0
                                0.0 -4.8383746 -1.3072522 0.0 0.0 -4.8945193 -1.9520515 0.0 0.0 -4.7687345
                                1.709388 0.0 0.0 -1.1968632 0.4171516 0.0 0.0 -1.3043479 -0.1982054 0.0 0.0
                                -2.2536244 -4.6132717 0.0 0.0 -17.151703 -9.950963 0.0 0.0 -3.8572037
                                -3.1846614 0.0 0.0 -21.85436 -0.38116756 0.0 0.0 -4.5520725 0.9737156 0.0 0.0
                                -20.136967 -0.8223076 0.0 0.0 -1.2546704 0.37267816 0.0 0.0 -1.2365444
                                0.36575255 0.0 0.0 -35.028873 -13.746046 0.0 0.0 -5.2780147 0.19695371 0.0
                                0.0 -1.3405099 -0.008590421 0.0 0.0 -1.2703862 -0.120009676 0.0 0.0
                                -1.2432656 -0.18209887 0.0 0.0 -17.157528 9.497706 0.0 0.0 -27.54421
                                3.7490025 0.0 0.0 -22.10739 -1.5030954 0.0 0.0 -6.5456476 0.33735818 0.0 0.0
                                -1.2792771 0.39507106 0.0 0.0 -18.711672 -6.9279075 0.0 0.0 -1.2018653
                                -0.45154724 0.0 0.0 -1.3037755 -0.08616562 0.0 0.0 -4.8659005 0.46128353 0.0
                                0.0 -3.3859358 3.340955 0.0 0.0 -1.3166095 -0.18974786 0.0 0.0 -19.271347
                                4.7123036 0.0 0.0 -20.092543 -0.5957028 0.0 0.0 -1.3022141 -0.31459352 0.0
                                0.0 -4.596641 1.3717346 0.0 0.0 -20.875593 7.6006827 0.0 0.0 -1.2833799
                                -0.47955796 0.0 0.0 -25.623322 2.5831215 0.0 0.0 -1.3358523 -0.08187626 0.0
                                0.0 -20.554585 -2.265098 0.0 0.0 -1.3118128 -0.10837442 0.0 0.0 -0.56354165
                                0.6464449 0.0 0.0 -21.64812 -2.982261 0.0 0.0 -4.698521 1.3096055 0.0 0.0
                                -4.2439237 -3.0586696 0.0 0.0 -4.642054 0.87746525 0.0 0.0 -20.899002
                                0.43789846 0.0 0.0 -4.1140347 3.2410176 0.0 0.0 -5.1164823 1.1045834 0.0 0.0
                                -5.024399 0.15983658 0.0 0.0 -4.229581 -1.9532049 0.0 0.0 -5.7018037
                                -0.5729226 0.0 0.0 -1.2394336 -0.5020116 0.0 0.0 -4.645158 0.23752706 0.0 0.0
                                -1.2539401 -0.19627975 0.0 0.0 -22.151226 0.81645924 0.0 0.0 -1.1497735
                                -0.63209146 0.0 0.0 -4.7056556 -1.899485 0.0 0.0 -20.402082 0.33859554 0.0
                                0.0 -1.2828302 0.015543008 0.0 0.0 -1.4565 -0.007317695 0.0 0.0 -20.46809
                                -0.07982088 0.0 0.0 -5.298206 -0.41654554 0.0 0.0 -20.288118 -3.0123758 0.0
                                0.0 -1.0686481 0.15832385 0.0 0.0 -5.0469065 -1.2287617 0.0 0.0 -24.047161
                                5.9217978 0.0 0.0 -20.139135 5.4040728 0.0 0.0 -1.0146067 0.7953114 0.0 0.0
                                -25.44986 1.1219931 0.0 0.0 -1.3135368 0.10022475 0.0 0.0 -20.641209
                                1.2682564 0.0 0.0 -1.2527807 0.47333503 0.0 0.0 -22.911135 -9.918221 0.0 0.0
                                -4.9090157 1.9746528 0.0 0.0 -4.953118 -1.5330905 0.0 0.0 -1.3201163
                                0.046307143 0.0 0.0 -23.548029 -3.859025 0.0 0.0 -4.2839127 2.0113392 0.0 0.0
                                -20.844765 0.48628882 0.0 0.0 -1.1623402 -0.5758148 0.0 0.0 -1.2674137
                                0.43642816 0.0 0.0 -1.3382888 0.015243017 0.0 0.0 -17.700094 -11.66672 0.0
                                0.0 -4.009268 2.6110265 0.0 0.0 -20.345615 -6.982373 0.0 0.0 -21.588179
                                12.0293 0.0 0.0 -1.2623295 -0.28094682 0.0 0.0 -21.408457 4.368583 0.0 0.0
                                -20.771944 12.968208 0.0 0.0 -1.3206073 0.14732473 0.0 0.0 -4.932307
                                -1.2157427 0.0 0.0 -22.074858 4.35141 0.0 0.0 -1.189942 -0.4512309 0.0 0.0
                                -1.1763587 0.39190197 0.0 0.0 -0.892506 -0.9649813 0.0 0.0 -1.3008803
                                -0.11718104 0.0 0.0 -71.77968 63.578342 0.0 0.0 -1.4146568 -0.22943223 0.0
                                0.0 -7.1366267 -1.1128992 0.0 0.0 -21.536974 5.661895 0.0 0.0 -1.4517615
                                0.18953773 0.0 0.0 -24.912128 0.32317927 0.0 0.0 -6.680252 1.0882176 0.0 0.0
                                -4.657647 -2.889541 0.0 0.0 -0.7890933 -0.8365439 0.0 0.0 -24.257887 6.114669
                                0.0 0.0 -22.99162 -0.7921924 0.0 0.0 -5.559768 -0.36322376 0.0 0.0 -5.289806
                                2.8378382 0.0 0.0 -4.94923 1.1410658 0.0 0.0 -5.556096 -0.030101372 0.0 0.0
                                -4.7738996 -1.840483 0.0 0.0 -4.7904468 -2.0676842 0.0 0.0 -1.4637331
                                -0.07414253 0.0 0.0 -93.270134 -31.78278 0.0 0.0 -4.3796825 2.0819907 0.0 0.0
                                -96.93328 24.998533 0.0 0.0 -23.574448 5.6505876 0.0 0.0 -1.3419919
                                0.032663763 0.0 0.0 -5.014843 -0.03694203 0.0 0.0 -4.6832943 -2.2006962 0.0
                                0.0 -24.262856 5.861744 0.0 0.0 -99.572365 -5.591002 0.0 0.0 -1.2259148
                                -0.71555895 0.0 0.0 -4.9849663 1.3596472 0.0 0.0 -21.379715 6.2589397 0.0 0.0
                                -102.90397 -29.292166 0.0 0.0 -102.89544 6.473354 0.0 0.0 -1.2552358
                                0.3645978 0.0 0.0 -21.452627 -13.049408 0.0 0.0 -5.2067084 0.70689696 0.0 0.0
                                -4.8000875 -1.6518289 0.0 0.0 -21.478832 -9.111878 0.0 0.0 -4.4500294
                                2.0926988 0.0 0.0 -6.11013 0.31945586 0.0 0.0 -22.76491 -7.490166 0.0 0.0
                                -1.2472988 0.6259605 0.0 0.0 -118.72729 9.876343 0.0 0.0 -25.447773 3.2863805
                                0.0 0.0 -5.5372844 2.734669 0.0 0.0 -5.287986 -0.6242244 0.0 0.0 -1.1745673
                                0.39998704 0.0 0.0 -1.4279174 0.08792243 0.0 0.0 -1.2175926 0.29100397 0.0
                                0.0 -5.7625813 -0.4069912 0.0 0.0 -22.768185 3.4248917 0.0 0.0 -24.546139
                                1.7296016 0.0 0.0 -25.586517 3.939324 0.0 0.0 -23.878242 0.44682395 0.0 0.0
                                -114.52691 -22.733562 0.0 0.0 -108.128456 -0.9062431 0.0 0.0 -6.169489
                                0.42269638 0.0 0.0 -111.477745 25.1507 0.0 0.0 -1.3824574 -0.49497056 0.0 0.0
                                -1.433093 0.40281627 0.0 0.0 -22.564262 -5.3511066 0.0 0.0 -1.4004982
                                -0.2941639 0.0 0.0 -6.2103 -2.7892048 0.0 0.0 -21.84229 -8.216908 0.0 0.0
                                -111.57542 -14.542713 0.0 0.0 -17.977795 -13.97531 0.0 0.0 -6.12306
                                -1.0418205 0.0 0.0 -17.350151 15.245553 0.0 0.0 -23.168919 -0.009599031 0.0
                                0.0 -23.932358 2.4646182 0.0 0.0 -1.3058962 0.28441328 0.0 0.0 -122.9894
                                4.6736116 0.0 0.0 -1.3373045 -0.6189671 0.0 0.0 -1.2411786 0.79950964 0.0 0.0
                                -20.241642 13.883598 0.0 0.0 -110.26351 40.50824 0.0 0.0 -1.3092668
                                -0.06697947 0.0 0.0 -1.2610183 -0.5124407 0.0 0.0 -135.39859 -17.397379 0.0
                                0.0 -5.5412326 -1.0208279 0.0 0.0 -1.2455107 0.06752642 0.0 0.0 -1.4212666
                                -0.24490815 0.0 0.0 -0.96988213 -1.107192 0.0 0.0 -4.704406 -2.002121 0.0 0.0
                                -97.248825 60.3089 0.0 0.0 -103.59306 41.49279 0.0 0.0 -1.419245 -0.16339466
                                0.0 0.0 -109.43783 35.149696 0.0 0.0 -1.1821712 -0.74326885 0.0 0.0
                                -5.6979117 -2.1767576 0.0 0.0 -1.2838823 -0.4088014 0.0 0.0 -96.58967
                                -54.879166 0.0 0.0 -24.524015 9.939104 0.0 0.0 -1.3282714 0.41350394 0.0 0.0
                                -1.0325801 -0.9671933 0.0 0.0 -4.9172664 -1.7381712 0.0 0.0 -5.7576394
                                1.8255931 0.0 0.0 -1.1915176 0.5490492 0.0 0.0 -6.431446 0.19096746 0.0 0.0
                                -1.4302338 -0.1322967 0.0 0.0 -1.3457533 0.5347229 0.0 0.0 -23.179956
                                -8.507695 0.0 0.0 -4.8476024 -2.1684742 0.0 0.0 -1.4211015 -0.057193022 0.0
                                0.0 -26.55126 -3.7949557 0.0 0.0 -6.1273327 -1.7506313 0.0 0.0 -108.744576
                                -37.675312 0.0 0.0 -24.979685 1.5803057 0.0 0.0 -116.47527 47.813442 0.0 0.0
                                -1.3996624 0.09184641 0.0 0.0 -1.4571347 0.11105625 0.0 0.0 -24.173136
                                -3.2438505 0.0 0.0 -25.177958 -3.2437117 0.0 0.0 -114.68968 -1.8171618 0.0
                                0.0 -1.342306 -0.32997677 0.0 0.0 -3.0504944 -4.1272407 0.0 0.0 -1.2418376
                                0.66408527 0.0 0.0 -147.102 -6.9237714 0.0 0.0 -24.94438 2.8581066 0.0 0.0
                                -88.430725 -72.1702 0.0 0.0 -1.6416799 -0.33806553 0.0 0.0 -6.263033
                                -0.6876861 0.0 0.0 -28.7698 -3.9967656 0.0 0.0 -1.3922313 -0.3675189 0.0 0.0
                                -25.684214 0.13831426 0.0 0.0 -6.0525975 -0.36605996 0.0 0.0 -5.536954
                                0.47771928 0.0 0.0 -1.453225 0.30841866 0.0 0.0 -1.365841 -0.22530217 0.0 0.0
                                -4.8927717 2.1298785 0.0 0.0 -4.387343 2.7837067 0.0 0.0 -30.360405 9.5990305
                                0.0 0.0 -114.40713 20.81278 0.0 0.0 -23.296574 -8.526588 0.0 0.0 -1.3126602
                                -0.58533543 0.0 0.0 -29.684984 10.41249 0.0 0.0 -116.035164 -14.594019 0.0
                                0.0 -118.087975 12.371249 0.0 0.0 -24.893373 -3.3407326 0.0 0.0 -1.4664465
                                -0.19651651 0.0 0.0 -26.36885 -5.3818803 0.0 0.0 -24.244024 6.299502 0.0 0.0
                                -121.22005 -2.3597457 0.0 0.0 -4.1700025 3.4143066 0.0 0.0 -5.880025
                                2.5502205 0.0 0.0 -26.0725 1.9430805 0.0 0.0 -5.497569 -1.6225111 0.0 0.0
                                -27.800499 6.839533 0.0 0.0 -27.064495 2.2459056 0.0 0.0 -6.479596 0.23175555
                                0.0 0.0 -25.952168 9.331195 0.0 0.0 -0.8118279 -1.2492259 0.0 0.0 -26.857204
                                7.933866 0.0 0.0 -1.4641007 -0.22929925 0.0 0.0 -1.4831337 -0.009851668 0.0
                                0.0 -136.9128 -17.412064 0.0 0.0 -5.3442135 0.16953145 0.0 0.0 -122.73987
                                16.713978 0.0 0.0 -1.0573004 -0.91130257 0.0 0.0 -27.824541 5.387014 0.0 0.0
                                -5.237277 1.1341335 0.0 0.0 -0.9354058 0.08415771 0.0 0.0 -1.2005669
                                0.41621575 0.0 0.0 -1.2654285 0.6943011 0.0 0.0 -1.3112979 -0.42809474 0.0
                                0.0 -6.221205 -2.1210747 0.0 0.0 -28.457449 7.715024 0.0 0.0 -21.69629
                                -12.854273 0.0 0.0 -132.88193 6.8809276 0.0 0.0 -115.07429 -63.439255 0.0 0.0
                                -1.4476303 0.2565034 0.0 0.0 -25.446665 3.6094031 0.0 0.0 -1.4408756
                                0.09696343 0.0 0.0 -23.367912 -10.348848 0.0 0.0 -97.791756 78.06844 0.0 0.0
                                -29.154434 -4.380462 0.0 0.0 -1.3736632 -0.39370602 0.0 0.0 -6.3682246
                                0.6561401 0.0 0.0 -6.3886333 0.15022512 0.0 0.0 -1.4165212 0.20560692 0.0 0.0
                                -30.544426 12.040764 0.0 0.0 -1.4186099 0.04504164 0.0 0.0 -1.4435911
                                0.017714541 0.0 0.0 -5.8178825 -1.2175698 0.0 0.0 -155.93828 31.215574 0.0
                                0.0 -5.5214896 -0.45144787 0.0 0.0 -26.043472 3.3569894 0.0 0.0 -25.555445
                                0.81850874 0.0 0.0 -135.96758 -61.151028 0.0 0.0 -1.1828022 -0.6575797 0.0
                                0.0 -4.3348627 -2.5021245 0.0 0.0 -1.3811389 0.21376419 0.0 0.0 -2.6534965
                                2.247951 0.0 0.0 -6.3487577 1.4638234 0.0 0.0 -6.1703267 1.2643925 0.0 0.0
                                -0.9768839 0.28174993 0.0 0.0 -23.026247 -11.878229 0.0 0.0 -0.9331913
                                0.4100661 0.0 0.0 -1.3755388 -0.41949096 0.0 0.0 -6.244395 2.481142 0.0 0.0
                                -1.1312556 -0.054627344 0.0 0.0 -1.0486943 0.19093807 0.0 0.0 -1.043361
                                0.12851217 0.0 0.0 -26.443127 -11.432907 0.0 0.0 -1.2951206 -0.2725931 0.0
                                0.0 -1.4574156 -0.0061797723 0.0 0.0 -26.27727 -11.944477 0.0 0.0 -1.2532084
                                -0.75016075 0.0 0.0 -0.9651271 -0.98686624 0.0 0.0 -28.109097 -9.409433 0.0
                                0.0 -126.89133 -26.86196 0.0 0.0 -6.1570168 -2.6073701 0.0 0.0 -1.4512833
                                -0.31116375 0.0 0.0 -1.2218606 0.70522314 0.0 0.0 -5.530303 1.2202945 0.0 0.0
                                -5.2364626 -2.9041271 0.0 0.0 -5.7369866 -0.06981097 0.0 0.0 -4.381601
                                2.7700505 0.0 0.0 -26.429346 -5.8827224 0.0 0.0 -27.374947 11.6739 0.0 0.0
                                -6.6140976 -1.343063 0.0 0.0 -5.222011 2.3552637 0.0 0.0 -130.87593 -59.50503
                                0.0 0.0 -1.4384354 0.17700164 0.0 0.0 -1.4192917 -0.09053463 0.0 0.0
                                -24.031282 11.999273 0.0 0.0 -38.3657 -3.573903 0.0 0.0 -27.618229 -2.117655
                                0.0 0.0 -6.95776 -25.641914 0.0 0.0 -22.541542 15.461857 0.0 0.0 -6.4706984
                                -1.1610464 0.0 0.0 -24.284857 18.07409 0.0 0.0 -6.184671 -2.332247 0.0 0.0
                                -1.4698919 0.34228766 0.0 0.0 -1.4225847 0.17724223 0.0 0.0 -5.6577377
                                -0.75636613 0.0 0.0 -1.257411 -0.6773605 0.0 0.0 -24.035467 -12.569792 0.0
                                0.0 -1.4731468 -0.012497942 0.0 0.0 -136.09013 44.024082 0.0 0.0 -23.74586
                                12.490233 0.0 0.0 -1.4354597 -0.31383 0.0 0.0 -28.247156 1.0461127 0.0 0.0
                                -139.58966 -5.41274 0.0 0.0 -1.5973481 -0.58527994 0.0 0.0 -1.3717153
                                -0.4756913 0.0 0.0 -5.215813 1.5107527 0.0 0.0 -6.082213 1.2620704 0.0 0.0
                                -1.2710643 0.7526784 0.0 0.0 -5.2170386 1.6064596 0.0 0.0 -1.1024591
                                -0.7199554 0.0 0.0 -4.9939814 -1.9201443 0.0 0.0 -137.23819 -5.2456493 0.0
                                0.0 -25.683203 8.753183 0.0 0.0 -1.2538533 -0.76795286 0.0 0.0 -5.5366364
                                1.2561871 0.0 0.0 -1.2436816 -0.09799724 0.0 0.0 -1.3663404 0.34036523 0.0
                                0.0 -31.120829 3.7828674 0.0 0.0 -1.262419 0.5546478 0.0 0.0 -27.066523
                                -13.559855 0.0 0.0 -1.2616616 -0.55283433 0.0 0.0 -35.240124 8.132613 0.0 0.0
                                -5.77556 -2.3180437 0.0 0.0 -30.51807 -3.3911333 0.0 0.0 -28.266594 13.27563
                                0.0 0.0 -176.25307 57.204926 0.0 0.0 -148.67226 -0.35145417 0.0 0.0
                                -29.373121 -6.249425 0.0 0.0 -4.3961425 3.9219086 0.0 0.0 -1.3742846
                                0.25100517 0.0 0.0 -3.1125636 -1.9441683 0.0 0.0 -1.3170929 0.36474115 0.0
                                0.0 -22.285563 -15.9283905 0.0 0.0 -109.83367 89.140274 0.0 0.0 -1.4830751
                                -0.10519099 0.0 0.0 -6.6894107 -1.6131327 0.0 0.0 -1.377321 -0.30725187 0.0
                                0.0 -1.4484766 -0.010101721 0.0 0.0 -1.4056697 0.29056025 0.0 0.0 -1.3281361
                                0.044992268 0.0 0.0 -6.4251523 -2.9648528 0.0 0.0 -1.4429873 0.003743142 0.0
                                0.0 -1.4303036 -0.10264361 0.0 0.0 -1.273029 0.5461044 0.0 0.0 -1.2815987
                                0.55709267 0.0 0.0 -119.570114 83.60037 0.0 0.0 -5.147599 0.4144115 0.0 0.0
                                -34.934696 -2.1208923 0.0 0.0 -31.879147 -0.9392867 0.0 0.0 -22.03671
                                -17.529943 0.0 0.0 -1.4586726 0.14590779 0.0 0.0 -1.4604628 -0.12366625 0.0
                                0.0 -26.663597 9.15815 0.0 0.0 -6.862429 -0.9870289 0.0 0.0 -121.42104
                                -80.09661 0.0 0.0 -5.5734158 2.336043 0.0 0.0 -135.09586 -54.953564 0.0 0.0
                                -5.0203524 -3.8530502 0.0 0.0 -1.3862536 0.29669988 0.0 0.0 -5.597152
                                -3.9505546 0.0 0.0 -153.23138 -55.339947 0.0 0.0 -1.2367064 -0.64778703 0.0
                                0.0 -141.22215 40.826756 0.0 0.0 -17.847313 18.391806 0.0 0.0 -0.87043166
                                0.4282302 0.0 0.0 -1.4438144 -0.3365257 0.0 0.0 -7.051815 1.0801094 0.0 0.0
                                -29.418974 1.0914394 0.0 0.0 -31.18294 1.3151697 0.0 0.0 -6.5224476
                                -0.38306725 0.0 0.0 -151.80653 33.53002 0.0 0.0 -5.5676455 -1.7707275 0.0 0.0
                                -1.4207189 -0.12547928 0.0 0.0 -1.2191128 -0.78241134 0.0 0.0 -5.742506
                                -0.21634792 0.0 0.0 -151.82742 -0.009346662 0.0 0.0 -1.1221489 -0.79371893
                                0.0 0.0 -1.095557 0.5344043 0.0 0.0 -131.78635 -76.59632 0.0 0.0 -140.5764
                                -53.254288 0.0 0.0 -29.24552 -1.0392965 0.0 0.0 -147.2263 -42.089695 0.0 0.0
                                -1.261506 0.17811738 0.0 0.0 -5.786101 -0.9111383 0.0 0.0 -6.1727605
                                1.7285652 0.0 0.0 -5.885224 -2.6744297 0.0 0.0 -5.6962404 -1.2868835 0.0 0.0
                                -150.82924 -18.046839 0.0 0.0 -1.3916194 0.35438454 0.0 0.0 -5.5623775
                                -1.5797926 0.0 0.0 -1.3907297 0.10978769 0.0 0.0 -156.63216 -59.048023 0.0
                                0.0 -1.3946807 0.32276195 0.0 0.0 -1.3249105 -0.6030939 0.0 0.0 -34.223404
                                -3.4559364 0.0 0.0 -1.3106244 -0.5884556 0.0 0.0 -29.024294 -13.567483 0.0
                                0.0 -5.891995 2.9307976 0.0 0.0 -1.1789547 -0.50891614 0.0 0.0 -30.665445
                                -5.530332 0.0 0.0 -194.51756 5.6747074 0.0 0.0 -155.75568 -44.57131 0.0 0.0
                                -1.5624636 -0.41278863 0.0 0.0 -5.6997805 0.4514962 0.0 0.0 -4.7766123
                                -0.44361934 0.0 0.0 -29.45607 0.5723353 0.0 0.0 -6.822148 -0.066826336 0.0
                                0.0 -1.4170979 0.2787113 0.0 0.0 -30.81069 0.5499121 0.0 0.0 -36.198
                                1.8714172 0.0 0.0 -6.201466 1.63569 0.0 0.0 -1.4558403 -0.29761 0.0 0.0
                                -5.4279885 1.5936837 0.0 0.0 -1.4042561 -0.2691638 0.0 0.0 -5.229698
                                2.4346805 0.0 0.0 -198.3829 -63.31189 0.0 0.0 -31.546886 -1.9558284 0.0 0.0
                                -1.3970258 0.33124068 0.0 0.0 -1.3681809 0.17638879 0.0 0.0 -7.2736917
                                -0.069419265 0.0 0.0 -33.653408 -3.5398405 0.0 0.0 -32.04521 3.703567 0.0 0.0
                                -6.118363 -1.7154902 0.0 0.0 -6.8599224 2.4769154 0.0 0.0 -1.3018008
                                -0.38860708 0.0 0.0 -1.2619599 0.050572757 0.0 0.0 -32.183155 1.0959003 0.0
                                0.0 -5.172048 -2.921882 0.0 0.0 -155.81956 32.424152 0.0 0.0 -6.159491
                                1.9527133 0.0 0.0 -192.61746 53.333527 0.0 0.0 -35.828922 -1.1354566 0.0 0.0
                                -5.3392053 -0.2772274 0.0 0.0 -7.3542895 1.8828788 0.0 0.0 -31.674685
                                -13.356077 0.0 0.0 -32.11697 0.42450842 0.0 0.0 -1.3951341 -0.089192234 0.0
                                0.0 -4.6286826 3.4912817 0.0 0.0 -30.16923 8.130148 0.0 0.0 -31.045403
                                -6.8010154 0.0 0.0 -39.268906 -8.530673 0.0 0.0 -32.096107 -10.287322 0.0 0.0
                                -30.765112 -4.9878025 0.0 0.0 -6.254094 -2.9843931 0.0 0.0 -5.5585313
                                2.005388 0.0 0.0 -4.8204684 -3.875711 0.0 0.0 -1.3666366 -0.4504806 0.0 0.0
                                -1.4439992 0.102670096 0.0 0.0 -1.7775221 -0.2857874 0.0 0.0 -7.1648993
                                0.93613404 0.0 0.0 -31.905378 -13.296325 0.0 0.0 -40.337982 -7.4707384 0.0
                                0.0 -33.442604 -9.487458 0.0 0.0 -0.8779407 -0.2598057 0.0 0.0 -5.8733788
                                -1.2734987 0.0 0.0 -1.0846748 0.65334827 0.0 0.0 -1.4035536 0.047217946 0.0
                                0.0 -44.12658 0.6256347 0.0 0.0 -28.73662 18.158262 0.0 0.0 -30.260935
                                5.9602637 0.0 0.0 -7.9119644 -0.9352191 0.0 0.0 -0.81212777 -0.36625847 0.0
                                0.0 -0.9981623 -0.8880562 0.0 0.0 -5.88438 1.666095 0.0 0.0 -1.2252816
                                0.50425124 0.0 0.0 -6.003673 0.42748278 0.0 0.0 -1.4266819 -0.4145065 0.0 0.0
                                -6.2237496 4.195939 0.0 0.0 -1.392876 0.2566837 0.0 0.0 -5.610327 1.8176813
                                0.0 0.0 -32.008614 -8.858093 0.0 0.0 -1.0839148 -0.34393996 0.0 0.0
                                -1.4335827 -0.12157098 0.0 0.0 -6.4213967 0.29035506 0.0 0.0 -5.9872165
                                1.3862903 0.0 0.0 -1.4390975 -0.45806375 0.0 0.0 -1.3903595 0.3334303 0.0 0.0
                                -5.3257365 1.617071 0.0 0.0 -1.3490762 -0.34388012 0.0 0.0 -6.9044976
                                0.10046837 0.0 0.0 -239.17505 -45.504112 0.0 0.0 -1.2738179 0.7915845 0.0 0.0
                                -33.6712 -9.914905 0.0 0.0 -0.9469397 -0.67723423 0.0 0.0 -31.675335
                                -3.7432775 0.0 0.0 -172.12842 -3.4077811 0.0 0.0 -30.541445 -11.241009 0.0
                                0.0 -34.968346 -7.326047 0.0 0.0 -1.5351648 0.14169249 0.0 0.0 -1.2950746
                                0.72026587 0.0 0.0 -1.383225 -0.46500304 0.0 0.0 -34.31242 -8.71137 0.0 0.0
                                -41.49789 14.901244 0.0 0.0 -1.3913599 -0.080039024 0.0 0.0 -35.247528
                                -8.908326 0.0 0.0 -34.04878 -3.9691224 0.0 0.0 -1.4103409 -0.2597315 0.0 0.0
                                -222.96016 -39.189156 0.0 0.0 -5.5837793 2.0319905 0.0 0.0 -8.191207
                                -2.6182175 0.0 0.0 -33.51824 -3.953621 0.0 0.0 -1.4649203 -0.16988407 0.0 0.0
                                -1.4014349 -0.25480315 0.0 0.0 -33.797558 7.784169 0.0 0.0 -1.100881
                                -0.88264537 0.0 0.0 -34.5489 -6.463861 0.0 0.0 -33.261223 7.836525 0.0 0.0
                                -36.22924 -4.7215357 0.0 0.0 -1.3983321 -0.16825637 0.0 0.0 -6.254407
                                -0.26991686 0.0 0.0 -5.409144 1.8851705 0.0 0.0 -28.99934 -14.383619 0.0 0.0
                                -33.386463 -4.912905 0.0 0.0 -6.1977296 -0.04206789 0.0 0.0 -33.839905
                                -5.0434427 0.0 0.0 -1.3328797 -0.31882927 0.0 0.0 -1.3432739 -0.37991655 0.0
                                0.0 -189.96565 -22.083218 0.0 0.0 -7.7949815 2.7239087 0.0 0.0 -1.4332719
                                -0.29152688 0.0 0.0 -1.3638909 0.5954815 0.0 0.0 -1.2601911 -0.08620807 0.0
                                0.0 -1.4285417 0.4216215 0.0 0.0 -7.7038794 0.16122048 0.0 0.0 -1.3884829
                                0.46061337 0.0 0.0 -5.4609547 -2.739891 0.0 0.0 -31.055368 -9.384552 0.0 0.0
                                -35.344517 -1.9998039 0.0 0.0 -205.49515 -25.67841 0.0 0.0 -1.4639289
                                -0.2578279 0.0 0.0 -201.25797 -23.32965 0.0 0.0 -182.36014 -47.97041 0.0 0.0
                                -1.2125279 0.6352748 0.0 0.0 -257.89044 -68.52293 0.0 0.0 -32.806667 6.577754
                                0.0 0.0 -198.76987 6.984862 0.0 0.0 -183.22179 -7.666718 0.0 0.0 -1.294962
                                -0.054281782 0.0 0.0 -1.4142115 0.23518585 0.0 0.0 -28.84995 17.298498 0.0
                                0.0 -6.522022 -0.22515142 0.0 0.0 -32.25946 -9.217244 0.0 0.0 -23.13643
                                -25.808678 0.0 0.0 -1.3769968 -0.11282011 0.0 0.0 -1.3817061 0.34828195 0.0
                                0.0 -6.748774 2.8988645 0.0 0.0 -7.2948284 1.5921212 0.0 0.0 -189.96895
                                -68.46651 0.0 0.0 -31.464731 -26.248869 0.0 0.0 -5.5586395 2.820656 0.0 0.0
                                -1.3534415 0.42054817 0.0 0.0 -33.13738 16.781143 0.0 0.0 -53.47822
                                -18.378733 0.0 0.0 -47.084137 0.6443095 0.0 0.0 -5.152064 1.1425818 0.0 0.0
                                -37.95952 -0.6300724 0.0 0.0 -7.1389966 1.0701109 0.0 0.0 -1.4640619
                                0.0015342756 0.0 0.0 -1.3039397 -0.138562 0.0 0.0 -184.35754 -39.766685 0.0
                                0.0 -0.89143753 0.8774358 0.0 0.0 -1.3406202 -0.10548404 0.0 0.0 -39.492584
                                8.03795 0.0 0.0 -6.548138 -1.8655576 0.0 0.0 -6.448595 -2.0061843 0.0 0.0
                                -0.8466667 -1.1442863 0.0 0.0 -195.14162 -24.539772 0.0 0.0 -6.5110598
                                -2.0327752 0.0 0.0 -5.1939425 -3.5557487 0.0 0.0 -6.6573305 3.8370566 0.0 0.0
                                -1.4532374 -0.032474216 0.0 0.0 -1.4233882 -0.20209894 0.0 0.0 -6.0185184
                                1.2014209 0.0 0.0 -5.7343817 -3.6642218 0.0 0.0 -1.4565425 0.27415326 0.0 0.0
                                -7.171184 -2.1470206 0.0 0.0 -6.3363404 -4.042065 0.0 0.0 -1.3983563
                                0.46612555 0.0 0.0 -34.53264 -2.7975047 0.0 0.0 -7.468367 -1.2254163 0.0 0.0
                                -35.498653 -7.790142 0.0 0.0 -148.61337 124.19851 0.0 0.0 -215.14297
                                -79.99944 0.0 0.0 -6.7788286 -1.417995 0.0 0.0 -40.736805 3.818392 0.0 0.0
                                -1.4852422 -0.02884286 0.0 0.0 -7.123706 -2.6586642 0.0 0.0 -34.38679
                                6.2739305 0.0 0.0 -33.693787 -6.270885 0.0 0.0 -198.73705 7.6761827 0.0 0.0
                                -225.07782 94.1714 0.0 0.0 -6.328942 -0.42540285 0.0 0.0 -1.3222576
                                -0.66972524 0.0 0.0 -6.3954077 -0.15009421 0.0 0.0 -1.5508407 -0.3811243 0.0
                                0.0 -1.249077 0.58242583 0.0 0.0 -329.5612 -103.16697 0.0 0.0 -1.3902261
                                0.045459438 0.0 0.0 -1.2879286 -0.6745114 0.0 0.0 -38.117344 9.101013 0.0 0.0
                                -7.3235884 -1.8851156 0.0 0.0 -34.072536 5.9416313 0.0 0.0 -166.1979
                                108.74269 0.0 0.0 -1.2446338 0.6927591 0.0 0.0 -26.721283 -22.080814 0.0 0.0
                                -1.4123319 -0.17082103 0.0 0.0 -1.4642446 -0.21426828 0.0 0.0 -6.015636
                                1.923905 0.0 0.0 -36.025894 0.08509355 0.0 0.0 -0.94659156 -0.81155926 0.0
                                0.0 -6.629718 2.0575008 0.0 0.0 -1.4808543 -0.13724743 0.0 0.0 -199.5005
                                44.755146 0.0 0.0 -1.3985387 -0.37618512 0.0 0.0 -6.305815 -2.9344275 0.0 0.0
                                -35.078197 -6.591599 0.0 0.0 -42.690643 -9.083864 0.0 0.0 -7.025553
                                -0.3148684 0.0 0.0 -1.2908096 0.18690833 0.0 0.0 -1.3626474 0.28479883 0.0
                                0.0 -180.54065 -92.608734 0.0 0.0 -1.2886304 -0.34791756 0.0 0.0 -1.2586058
                                -0.6800808 0.0 0.0 -37.440926 -5.270697 0.0 0.0 -1.4184124 -0.33018157 0.0
                                0.0 -35.491253 -14.291397 0.0 0.0 -1.3738679 -0.2645193 0.0 0.0 -1.3560989
                                0.46911913 0.0 0.0 -1.7076051 -0.2903063 0.0 0.0 -215.65523 24.725182 0.0 0.0
                                -1.4564551 -0.14809595 0.0 0.0 -1.7064534 0.5821052 0.0 0.0 -36.904396
                                -10.351612 0.0 0.0 -6.3707166 2.9801898 0.0 0.0 -221.78763 -56.364105 0.0 0.0
                                -40.351208 -3.3501906 0.0 0.0 -1.4027716 -0.044056922 0.0 0.0 -1.4020035
                                -0.25827128 0.0 0.0 -1.2497492 -0.7960284 0.0 0.0 -1.2608078 0.36166227 0.0
                                0.0 -6.7240787 3.2382214 0.0 0.0 -311.7779 -114.76971 0.0 0.0 -0.9925157
                                -1.0656958 0.0 0.0 -1.4519303 0.075678036 0.0 0.0 -53.907646 -18.985378 0.0
                                0.0 -1.4170929 -0.444951 0.0 0.0 -193.24037 80.194115 0.0 0.0 -1.0355253
                                -0.9890045 0.0 0.0 -33.731026 -17.166561 0.0 0.0 -198.74902 43.739285 0.0 0.0
                                -6.724218 -2.821187 0.0 0.0 -6.0359583 -2.0253334 0.0 0.0 -5.8557324
                                2.3153708 0.0 0.0 -1.3571752 0.08820432 0.0 0.0 -1.3781934 0.14986117 0.0 0.0
                                -7.024658 0.6754941 0.0 0.0 -2.5239244 -4.750966 0.0 0.0 -1.4411451
                                0.14165595 0.0 0.0 -32.95784 -16.34634 0.0 0.0 -193.5603 -87.51373 0.0 0.0
                                -7.4798646 1.2188026 0.0 0.0 -34.41346 -11.1559925 0.0 0.0 -42.751137
                                11.023401 0.0 0.0 -1.2628698 0.8047765 0.0 0.0 -36.34622 -1.154903 0.0 0.0
                                -1.2435118 -0.7652552 0.0 0.0 -1.4758596 0.14344564 0.0 0.0 -1.3151758
                                -0.25509414 0.0 0.0 -38.16093 8.30291 0.0 0.0 -7.7021804 -0.47988915 0.0 0.0
                                -43.411385 -11.255884 0.0 0.0 -250.90744 -113.915726 0.0 0.0 -37.787292
                                -19.986914 0.0 0.0 -1.4070201 -0.2593969 0.0 0.0 -6.6193805 -2.1842337 0.0
                                0.0 -43.564228 -3.1369715 0.0 0.0 -31.019176 -25.438774 0.0 0.0 -29.99504
                                -21.810041 0.0 0.0 -203.02507 87.38758 0.0 0.0 -7.864085 0.5825186 0.0 0.0
                                -1.2206839 0.8159356 0.0 0.0 -1.4686261 0.2459046 0.0 0.0 -7.7167163
                                0.9026933 0.0 0.0 -34.767838 19.923777 0.0 0.0 -4.787678 5.2268295 0.0 0.0
                                -6.467846 -0.29260448 0.0 0.0 -1.416801 -0.32017666 0.0 0.0 -1.3763536
                                0.5079251 0.0 0.0 -1.3374736 0.10423615 0.0 0.0 -1.37891 0.23928645 0.0 0.0
                                -244.38937 16.321157 0.0 0.0 -32.911163 17.208652 0.0 0.0 -1.2134339
                                -0.07243808 0.0 0.0 -4.3201923 -3.1287417 0.0 0.0 -7.057004 2.8567808 0.0 0.0
                                -39.807953 2.6266718 0.0 0.0 -220.19278 -26.021643 0.0 0.0 -7.9146423
                                -0.4422138 0.0 0.0 -8.1664505 1.6452597 0.0 0.0 -7.972384 -0.8605318 0.0 0.0
                                -7.6598797 -1.8428426 0.0 0.0 -6.394596 -1.319287 0.0 0.0 -30.20468
                                -27.048834 0.0 0.0 -1.3731784 0.35185382 0.0 0.0 -6.6544433 -0.7372325 0.0
                                0.0 -0.9517904 -0.7667738 0.0 0.0 -1.4390315 -0.0011885986 0.0 0.0 -8.516864
                                0.81023216 0.0 0.0 -39.84092 -14.1376 0.0 0.0 -236.77382 18.169552 0.0 0.0
                                -39.28078 -8.975862 0.0 0.0 -48.672707 0.12813158 0.0 0.0 -1.4913876
                                9.3867956e-4 0.0 0.0 -1.3228862 -0.5338172 0.0 0.0 -308.45605 50.767864 0.0
                                0.0 -1.4032843 0.46194965 0.0 0.0 -39.14625 14.434125 0.0 0.0 -38.183426
                                9.130529 0.0 0.0 -8.019049 -2.3553684 0.0 0.0 -46.9965 2.6775596 0.0 0.0
                                -228.05331 -61.68295 0.0 0.0 -7.591319 -0.9186344 0.0 0.0 -62.41387 -18.69651
                                0.0 0.0 -1.3790396 -0.19112343 0.0 0.0 -6.615635 0.8357851 0.0 0.0 -6.17285
                                2.1528163 0.0 0.0 -1.4287146 0.020982483 0.0 0.0 -38.392643 9.751871 0.0 0.0
                                -1.1800703 0.23022181 0.0 0.0 -283.03986 -119.889145 0.0 0.0 -1.2668705
                                0.71970165 0.0 0.0 -1.2596288 0.7780574 0.0 0.0 -33.3415 5.3080554 0.0 0.0
                                -0.72710997 0.051224142 0.0 0.0 -6.614922 -0.20780842 0.0 0.0 -1.1005818
                                -1.0035884 0.0 0.0 -1.4638419 0.13096525 0.0 0.0 -238.09695 -75.60833 0.0 0.0
                                -4.8671417 -4.255449 0.0 0.0 -247.64803 -60.70518 0.0 0.0 -37.456528
                                10.880259 0.0 0.0 -37.68246 11.069114 0.0 0.0 -6.769113 2.927356 0.0 0.0
                                -231.89256 54.519615 0.0 0.0 -1.4481783 0.010921224 0.0 0.0 -1.9637263
                                0.24366008 0.0 0.0 -7.471189 0.092750154 0.0 0.0 -7.966591 1.8703717 0.0 0.0
                                -7.8971877 2.1997237 0.0 0.0 -8.559539 -0.16160625 0.0 0.0 -1.2066988
                                -0.7766339 0.0 0.0 -1.4341409 0.3723442 0.0 0.0 -38.940414 10.66177 0.0 0.0
                                -1.479597 0.15864332 0.0 0.0 -1.1491501 0.3487654 0.0 0.0 -5.9032917
                                3.0181212 0.0 0.0 -6.413042 -1.9873904 0.0 0.0 -38.28523 10.584677 0.0 0.0
                                -40.91875 4.631504 0.0 0.0 -1.3691245 -0.4297836 0.0 0.0 -1.4056998
                                0.35046026 0.0 0.0 -38.48914 7.1628366 0.0 0.0 -7.007806 2.956937 0.0 0.0
                                -1.4521002 0.059313953 0.0 0.0 -1.348626 0.029496526 0.0 0.0 -215.34572
                                -115.21026 0.0 0.0 -6.6872997 0.5146512 0.0 0.0 -1.4171618 -0.09130105 0.0
                                0.0 -1.1059393 0.92970806 0.0 0.0 -39.342514 -6.6833158 0.0 0.0 -7.2799106
                                2.1689005 0.0 0.0 -50.83307 3.973062 0.0 0.0 -6.690431 1.7951715 0.0 0.0
                                -7.4032884 -0.03292087 0.0 0.0 -1.0033171 1.0684716 0.0 0.0 -7.093275
                                1.5501488 0.0 0.0 -20.564407 -25.181332 0.0 0.0 -230.53867 -90.18218 0.0 0.0
                                -244.52574 106.76367 0.0 0.0 -37.45903 16.515476 0.0 0.0 -1.200628 -0.7027359
                                0.0 0.0 -38.021152 -13.845541 0.0 0.0 -29.403765 26.501915 0.0 0.0 -39.235153
                                10.2101345 0.0 0.0 -6.478547 -1.6557419 0.0 0.0 -40.539932 -11.377484 0.0 0.0
                                -39.262886 -14.802059 0.0 0.0 -6.647186 1.6392053 0.0 0.0 -40.962994
                                -18.046587 0.0 0.0 -41.252144 -4.3804917 0.0 0.0 -1.317363 -0.5611578 0.0 0.0
                                -1.383372 0.41369763 0.0 0.0 -6.889166 -1.150472 0.0 0.0 -36.458942
                                -16.555141 0.0 0.0 -1.3934742 0.15623923 0.0 0.0 -282.05142 14.092789 0.0 0.0
                                -1.2849327 0.3234156 0.0 0.0 -55.416 8.996804 0.0 0.0 -6.532281 -0.8918475
                                0.0 0.0 -1.1726437 0.9425417 0.0 0.0 -1.3151249 0.6115081 0.0 0.0 -6.990102
                                1.8998789 0.0 0.0 -1.2428161 -0.69474953 0.0 0.0 -1.1854224 0.51965845 0.0
                                0.0 -246.34373 -66.397484 0.0 0.0 -292.09134 -129.67744 0.0 0.0 -38.274765
                                14.4297085 0.0 0.0 -40.906376 21.28459 0.0 0.0 -6.5487514 -2.011263 0.0 0.0
                                -8.142414 -1.5103817 0.0 0.0 -1.4239537 0.20259643 0.0 0.0 -37.425568
                                -17.63089 0.0 0.0 -7.3682165 -1.5933962 0.0 0.0 -6.4332967 3.229644 0.0 0.0
                                -44.240826 14.027186 0.0 0.0 -40.40479 5.1379175 0.0 0.0 -1.2721882
                                0.12827021 0.0 0.0 -39.94329 -28.186195 0.0 0.0 -7.9667525 0.16541192 0.0 0.0
                                -1.4054523 0.13937885 0.0 0.0 -1.3348265 0.2655737 0.0 0.0 -1.1548179
                                -0.9397276 0.0 0.0 -247.07832 -81.83326 0.0 0.0 -33.889442 28.307087 0.0 0.0
                                -1.4782398 -0.043474354 0.0 0.0 -8.238774 1.6883059 0.0 0.0 -6.5091825
                                4.5895157 0.0 0.0 -51.095924 -9.505566 0.0 0.0 -6.6287074 1.9013357 0.0 0.0
                                -1.3890136 0.05181679 0.0 0.0 -1.37897 -0.060983524 0.0 0.0 -8.450275
                                -0.8887494 0.0 0.0 -1.3409803 -0.020574221 0.0 0.0 -1.2358238 -0.33005992 0.0
                                0.0 -4.4293666 -5.1000795 0.0 0.0 -40.93204 4.661965 0.0 0.0 -1.2516857
                                -0.29199374 0.0 0.0 -50.063686 11.4694 0.0 0.0 -1.3480026 -0.057552338 0.0
                                0.0 -7.307001 3.309344 0.0 0.0 -6.809805 1.761095 0.0 0.0 -1.0231688
                                0.38864917 0.0 0.0 -1.288617 0.21895212 0.0 0.0 -8.205233 0.7088802 0.0 0.0
                                -7.416806 0.805805 0.0 0.0 -1.2808181 -0.3328075 0.0 0.0 -45.47692 -9.909665
                                0.0 0.0 -1.2687082 0.429095 0.0 0.0 -32.772293 -25.602491 0.0 0.0 -1.3144158
                                -0.08531496 0.0 0.0 -39.804096 -12.254044 0.0 0.0 -1.2813497 -0.22227281 0.0
                                0.0 -1.0645658 0.69546366 0.0 0.0 -8.920285 -0.29135105 0.0 0.0 -1.0856744
                                0.03268788 0.0 0.0 -6.8637342 -2.4433815 0.0 0.0 -0.9985573 0.5791736 0.0 0.0
                                -6.2264347 2.5484557 0.0 0.0 -40.330982 -18.473003 0.0 0.0 -1.2238505
                                0.44917297 0.0 0.0 -1.2518885 0.45571333 0.0 0.0 -54.80641 -2.6976612 0.0 0.0
                                -1.206769 -0.56132936 0.0 0.0 -1.2680109 0.3543334 0.0 0.0 -1.1433711
                                0.047563344 0.0 0.0 -48.51452 -12.203364 0.0 0.0 -1.202517 0.26159155 0.0 0.0
                                -6.853396 -0.8405625 0.0 0.0 -6.928464 -1.7161313 0.0 0.0 -1.3399704
                                -0.043602303 0.0 0.0 -45.48493 3.5886438 0.0 0.0 -42.236763 12.113118 0.0 0.0
                                -1.1514344 0.59925693 0.0 0.0 -6.507817 1.9409226 0.0 0.0 -6.853651 0.6652011
                                0.0 0.0 -7.302464 -1.3941739 0.0 0.0 -5.2339435 5.5116615 0.0 0.0 -1.0643623
                                -0.77675 0.0 0.0 -44.564194 -6.424565 0.0 0.0 -40.07441 14.231887 0.0 0.0
                                -7.697249 1.466463 0.0 0.0 -1.209585 0.57569885 0.0 0.0 -31.99632 -33.10257
                                0.0 0.0 -1.2416326 0.48891935 0.0 0.0 -8.677961 -1.0516272 0.0 0.0 -40.67813
                                -17.776022 0.0 0.0 -1.2834436 -0.07124194 0.0 0.0 -1.1542039 0.28906178 0.0
                                0.0 -7.086199 -2.8497152 0.0 0.0 -1.2564663 0.37404415 0.0 0.0 -1.3361177
                                -0.058102276 0.0 0.0 -1.2279925 0.59929025 0.0 0.0 -1.1171838 -0.64556456 0.0
                                0.0 -7.3132815 -2.206777 0.0 0.0 -63.166862 -4.916905 0.0 0.0 -54.29026
                                -0.702702 0.0 0.0 -1.2328532 -0.42628545 0.0 0.0 -1.111521 0.043503035 0.0
                                0.0 -1.2132101 0.25600928 0.0 0.0 -1.3353103 -0.12529196 0.0 0.0 -40.23372
                                -15.645491 0.0 0.0 -1.3196663 0.17951694 0.0 0.0 -1.3348562 0.06509338 0.0
                                0.0 -7.614973 0.42005074 0.0 0.0 -5.8658395 -4.040849 0.0 0.0 -6.9624147
                                -0.36948216 0.0 0.0 -1.3265971 -0.11279727 0.0 0.0 -6.5053096 -3.4055305 0.0
                                0.0 -41.29525 -15.954012 0.0 0.0 -6.2459784 -3.1682906 0.0 0.0 -1.2251009
                                0.41195375 0.0 0.0 -6.976864 0.6800581 0.0 0.0 -41.5898 20.041378 0.0 0.0
                                -6.763572 -1.1044911 0.0 0.0 -7.0218997 -3.0765052 0.0 0.0 -36.582447
                                28.327976 0.0 0.0 -6.8216333 -0.9374775 0.0 0.0 -9.754987 1.7167233 0.0 0.0
                                -1.2522298 -0.34750706 0.0 0.0 -42.42047 -16.463034 0.0 0.0 -1.2764096
                                0.18456583 0.0 0.0 -1.330486 -0.027020903 0.0 0.0 -47.66753 -12.681869 0.0
                                0.0 -49.23689 14.542909 0.0 0.0 -7.0424123 1.903825 0.0 0.0 -0.99504274
                                -0.985879 0.0 0.0 -7.9095683 -0.29671153 0.0 0.0 -6.14297 -5.236485 0.0 0.0
                                -42.76533 -13.703336 0.0 0.0 -1.2585757 -0.3175363 0.0 0.0 -0.98513085
                                0.47189564 0.0 0.0 -1.3366227 0.11491007 0.0 0.0 -1.5499284 -0.540884 0.0 0.0
                                -7.2433195 -1.2183832 0.0 0.0 -1.3074309 -0.29913214 0.0 0.0 -6.4539814
                                -2.4890625 0.0 0.0 -1.3246746 0.2021803 0.0 0.0 -1.302612 -0.017881135 0.0
                                0.0 -1.3960342 0.1598253 0.0 0.0 -1.0957711 0.7492843 0.0 0.0 -1.3217232
                                -0.052547574 0.0 0.0 -1.1641197 0.65593225 0.0 0.0 -42.664597 12.533193 0.0
                                0.0 -1.4775476 0.018646859 0.0 0.0 -40.065292 26.796608 0.0 0.0 -1.2294288
                                -0.25980407 0.0 0.0 -1.3826436 0.16488126 0.0 0.0 -1.3092662 0.28021044 0.0
                                0.0 -7.7554216 0.21421658 0.0 0.0 -46.658604 -8.50081 0.0 0.0 -1.2115618
                                0.52501 0.0 0.0 -5.554325 4.8365006 0.0 0.0 -43.682827 -9.849332 0.0 0.0
                                -47.429058 -22.589287 0.0 0.0 -40.82039 1.6240367 0.0 0.0 -0.9859734
                                -0.88150877 0.0 0.0 -51.607952 -0.94038 0.0 0.0 -1.2909521 -0.33525366 0.0
                                0.0 -1.2670226 0.3185295 0.0 0.0 -44.963978 21.202742 0.0 0.0 -1.235767
                                -0.46809837 0.0 0.0 -1.3002938 0.11809217 0.0 0.0 -7.3482823 3.3589158 0.0
                                0.0 -1.0987966 -0.7696633 0.0 0.0 -6.954721 -3.1281207 0.0 0.0 -7.063076
                                -1.7852691 0.0 0.0 -44.22837 -27.359125 0.0 0.0 -1.121525 -0.19822639 0.0 0.0
                                -1.2886482 -0.047239386 0.0 0.0 -7.733511 -0.34674683 0.0 0.0 -45.83028
                                11.073268 0.0 0.0 -46.284058 0.9104646 0.0 0.0 -45.496853 4.251204 0.0 0.0
                                -11.881521 -2.7984104 0.0 0.0 -1.3402902 0.052136492 0.0 0.0 -42.472412
                                18.740086 0.0 0.0 -67.21628 -10.370925 0.0 0.0 -0.6767781 -0.7583372 0.0 0.0
                                -7.5751543 -2.688302 0.0 0.0 -6.7777576 -2.3068957 0.0 0.0 -1.2454233
                                -0.6480535 0.0 0.0 -27.764652 38.62066 0.0 0.0 -1.2495246 0.46115598 0.0 0.0
                                -72.458275 -30.886309 0.0 0.0 -6.5083566 -3.0372698 0.0 0.0 -0.91687256
                                0.009940922 0.0 0.0 -1.2725079 0.253506 0.0 0.0 -1.0765984 0.20466574 0.0 0.0
                                -1.2921982 0.06627503 0.0 0.0 -45.82374 -3.315694 0.0 0.0 -7.068935
                                -3.1330748 0.0 0.0 -15.795932 2.4534104 0.0 0.0 -1.1633278 -0.5691467 0.0 0.0
                                -48.626663 -11.409648 0.0 0.0 -13.210002 -3.4272957 0.0 0.0 -1.2817044
                                -0.37333745 0.0 0.0 -45.0854 9.381412 0.0 0.0 -47.62616 6.769819 0.0 0.0
                                -7.801714 -3.2577727 0.0 0.0 -41.562176 -20.313545 0.0 0.0 -47.913948
                                -5.3026767 0.0 0.0 -38.90021 28.529062 0.0 0.0 -44.237793 -13.852995 0.0 0.0
                                -7.6407375 -1.6565528 0.0 0.0 -7.8335986 0.6338628 0.0 0.0 -7.8694515
                                -2.5650709 0.0 0.0 -1.2715595 -0.08860384 0.0 0.0 -1.0526226 0.23093063 0.0
                                0.0 -7.034328 -2.2828476 0.0 0.0 -47.84457 -16.237999 0.0 0.0 -0.6980651
                                -0.16158271 0.0 0.0 -1.2680004 0.20579475 0.0 0.0 -45.806175 13.070371 0.0
                                0.0 -1.282097 -0.38577378 0.0 0.0 -51.84187 -21.55097 0.0 0.0 -8.096727
                                -2.1317067 0.0 0.0 -1.4438609 -0.5079627 0.0 0.0 -1.2842935 -0.12289699 0.0
                                0.0 -43.696255 -16.94389 0.0 0.0 -7.14093 -3.5865743 0.0 0.0 -41.34577
                                22.2033 0.0 0.0 -55.2416 -2.526094 0.0 0.0 -1.1945752 -0.6759556 0.0 0.0
                                -42.745186 19.604425 0.0 0.0 -7.3329244 0.93299526 0.0 0.0 -1.2970059
                                -0.15733628 0.0 0.0 -39.036892 29.76027 0.0 0.0 -42.632355 -21.373375 0.0 0.0
                                -7.2169657 -5.3750725 0.0 0.0 -12.912679 0.5473348 0.0 0.0 -38.313164
                                -27.654156 0.0 0.0 -53.065273 12.7783165 0.0 0.0 -1.336109 -0.03881325 0.0
                                0.0 -1.0965351 0.25125295 0.0 0.0 -49.3375 -1.6644518 0.0 0.0 -7.998121
                                0.48661563 0.0 0.0 -47.437637 9.747643 0.0 0.0 -1.2156652 -0.3690682 0.0 0.0
                                -1.1664182 0.16264239 0.0 0.0 -1.0665691 -0.68185544 0.0 0.0 -48.81886
                                8.606013 0.0 0.0 -7.5917416 2.503033 0.0 0.0 -1.4177849 0.6707311 0.0 0.0
                                -1.3168138 0.23968054 0.0 0.0 -1.1877614 0.5175147 0.0 0.0 -1.190325
                                -0.4992906 0.0 0.0 -6.764731 -4.3458657 0.0 0.0 -7.8195767 1.1933495 0.0 0.0
                                -1.4023889 0.0785489 0.0 0.0 -62.44006 4.535024 0.0 0.0 -6.0576267 5.008169
                                0.0 0.0 -1.333042 -0.07308528 0.0 0.0 -47.89441 2.507987 0.0 0.0 -1.1072916
                                -0.70301217 0.0 0.0 -6.9325066 -2.834944 0.0 0.0 -71.467865 26.047104 0.0 0.0
                                -51.808617 -6.722545 0.0 0.0 -1.2863317 0.29845047 0.0 0.0 -1.2665709
                                -0.3851499 0.0 0.0 -7.2643104 -0.8293296 0.0 0.0 -8.0968485 -1.1281575 0.0
                                0.0 -6.326353 -3.3500788 0.0 0.0 -1.2958138 0.19671157 0.0 0.0 -1.1810226
                                -0.35956714 0.0 0.0 -7.4496098 -1.204816 0.0 0.0 -1.3330443 0.13093312 0.0
                                0.0 -1.2851918 -0.016693452 0.0 0.0 -8.263606 -1.2882009 0.0 0.0 -1.3390478
                                0.047812477 0.0 0.0 -62.37634 29.749695 0.0 0.0 -1.2654552 0.3899991 0.0 0.0
                                -1.1015977 -0.6684021 0.0 0.0 -47.060535 -15.771081 0.0 0.0 -8.23571
                                -3.3754203 0.0 0.0 -1.2729338 0.4043541 0.0 0.0 -1.2452613 -0.39948484 0.0
                                0.0 -6.5689254 -3.7474284 0.0 0.0 -7.674959 -1.7086256 0.0 0.0 -1.0638431
                                0.39494124 0.0 0.0 -8.295079 -1.2158958 0.0 0.0 -7.782682 0.46989116 0.0 0.0
                                -7.378026 0.6055609 0.0 0.0 -7.361855 3.4948814 0.0 0.0 -0.18311875
                                0.59872663 0.0 0.0 -46.667763 -15.37463 0.0 0.0 -56.271538 14.2800255 0.0 0.0
                                -37.11032 -38.074734 0.0 0.0 -54.023132 -13.141256 0.0 0.0 -1.4830247
                                -0.14228418 0.0 0.0 -51.601173 -13.3762 0.0 0.0 -1.2755344 -0.5991076 0.0 0.0
                                -7.6038504 -3.3948214 0.0 0.0 -1.0639184 0.4953537 0.0 0.0 -1.4043232
                                -0.16961312 0.0 0.0 -52.80056 19.291094 0.0 0.0 -1.0418277 -0.09283342 0.0
                                0.0 -1.4494231 0.32985342 0.0 0.0 -62.285316 13.573898 0.0 0.0 -1.4346395
                                -0.29791206 0.0 0.0 -54.99016 16.767351 0.0 0.0 -8.486785 -2.6473742 0.0 0.0
                                -1.483303 0.06883254 0.0 0.0 -8.331427 1.7655846 0.0 0.0 -1.4853649
                                0.0052094012 0.0 0.0 -6.80402 -4.5910945 0.0 0.0 -1.3897452 0.20284912 0.0
                                0.0 -1.3946168 -0.29213378 0.0 0.0 -8.198325 4.0031962 0.0 0.0 -58.738083
                                17.322113 0.0 0.0 -1.5488027 -0.26751277 0.0 0.0 -46.85705 -22.180887 0.0 0.0
                                -6.326715 -4.0350814 0.0 0.0 -1.4380049 0.019391574 0.0 0.0 -8.225834
                                1.2416857 0.0 0.0 -1.3535433 0.27980363 0.0 0.0 -5.858175 -4.574585 0.0 0.0
                                -7.307137 -1.9116868 0.0 0.0 -326.8094 -117.57438 0.0 0.0 -0.7485132
                                -1.2367572 0.0 0.0 -65.51511 30.385504 0.0 0.0 -7.5950093 0.63980436 0.0 0.0
                                -5.7431045 -5.179954 0.0 0.0 -6.406646 -5.4224987 0.0 0.0 -1.43515 0.2966648
                                0.0 0.0 -6.574916 1.198347 0.0 0.0 -7.4534426 -2.3831549 0.0 0.0 -8.262716
                                -1.1670953 0.0 0.0 -54.74665 18.107147 0.0 0.0 -351.57486 -70.979675 0.0 0.0
                                -8.148246 -3.5777116 0.0 0.0 -8.12622 -1.8895649 0.0 0.0 -357.95096 35.82941
                                0.0 0.0 -1.2950301 0.3755234 0.0 0.0 -1.3595655 0.018826753 0.0 0.0
                                -1.2285602 -0.27845973 0.0 0.0 -7.5965686 -3.089961 0.0 0.0 -376.19147
                                195.62119 0.0 0.0 -48.87284 -17.380726 0.0 0.0 -58.40396 15.115268 0.0 0.0
                                -1.4067084 0.099262506 0.0 0.0 -1.3473256 -0.6898259 0.0 0.0 -412.79425
                                15.886753 0.0 0.0 -14.32624 0.058953386 0.0 0.0 -96.884575 -0.7322722 0.0 0.0
                                -1.3998946 -0.14525503 0.0 0.0 -53.80494 -15.337441 0.0 0.0 -55.351555
                                -10.639913 0.0 0.0 -59.34722 -20.976439 0.0 0.0 -48.158367 -27.162111 0.0 0.0
                                -7.793638 5.5142565 0.0 0.0 -5.082951 -5.1569796 0.0 0.0 -45.293842
                                -40.225807 0.0 0.0 -1.221622 0.756251 0.0 0.0 -1.4147626 -0.13328652 0.0 0.0
                                -347.66556 -163.51173 0.0 0.0 -52.601665 -13.680361 0.0 0.0 -53.27836
                                -21.898714 0.0 0.0 -50.803757 -17.485756 0.0 0.0 -1.4748695 -0.05157984 0.0
                                0.0 -56.04379 -11.29343 0.0 0.0 -58.39498 -3.3767273 0.0 0.0 -1.2365905
                                -0.7210842 0.0 0.0 -1.4494878 -0.110445805 0.0 0.0 -1.0050663 0.55723083 0.0
                                0.0 -517.2515 -7.2678146 0.0 0.0 -377.4195 -45.49836 0.0 0.0 -43.43395
                                -35.90651 0.0 0.0 -1.4343507 -0.14738381 0.0 0.0 -1.2079232 -0.110386044 0.0
                                0.0 -59.099133 4.641292 0.0 0.0 -316.16895 -199.52602 0.0 0.0 -1.4278737
                                0.15500511 0.0 0.0 -1.4664754 -0.25784802 0.0 0.0 -1.2374977 -0.7295721 0.0
                                0.0 -7.816579 2.142394 0.0 0.0 -363.56018 54.652496 0.0 0.0 -53.310127
                                23.254627 0.0 0.0 -8.67764 -5.8732657 0.0 0.0 -1.2836461 0.12643848 0.0 0.0
                                -50.37055 -26.091799 0.0 0.0 -1.392202 -0.13239197 0.0 0.0 -343.3889
                                -157.8036 0.0 0.0 -7.4398203 -6.3988023 0.0 0.0 -63.256542 -6.555476 0.0 0.0
                                -287.98312 -246.42142 0.0 0.0 -1.1878952 -0.52667856 0.0 0.0 -326.37933
                                -177.63481 0.0 0.0 -39.72224 34.4228 0.0 0.0 -1.443929 0.06464155 0.0 0.0
                                -358.32947 -102.37948 0.0 0.0 -51.25989 -31.052332 0.0 0.0 -1.3078165
                                0.3715226 0.0 0.0 -1.3333974 0.5624066 0.0 0.0 -1.3084509 -0.60872865 0.0 0.0
                                -50.596596 -21.281368 0.0 0.0 -8.801769 -2.2803197 0.0 0.0 -8.026869
                                1.6512048 0.0 0.0 -1.3298715 0.66135067 0.0 0.0 -63.711067 -5.3061495 0.0 0.0
                                -1.2627908 0.5069419 0.0 0.0 -9.453118 -2.7367308 0.0 0.0 -369.0515
                                -137.62256 0.0 0.0 -63.08217 13.755388 0.0 0.0 -7.406766 1.1151218 0.0 0.0
                                -50.85254 18.830362 0.0 0.0 -8.309253 -3.1781275 0.0 0.0 -6.81432 -3.3015265
                                0.0 0.0 -1.3161204 0.42646977 0.0 0.0 -1.4710779 0.09161902 0.0 0.0 -54.7887
                                -9.287724 0.0 0.0 -7.622399 1.3471165 0.0 0.0 -9.025435 -2.972274 0.0 0.0
                                -1.3943607 -0.17124403 0.0 0.0 -70.745865 -15.736093 0.0 0.0 -0.9308831
                                -0.24391642 0.0 0.0 -1.2803288 -0.60243845 0.0 0.0 -1.4261714 0.35174525 0.0
                                0.0 -0.7446505 0.7334398 0.0 0.0 -1.399917 -0.26031688 0.0 0.0 -1.3845955
                                -0.28495222 0.0 0.0 -57.097687 5.216026 0.0 0.0 -54.591026 -4.82101 0.0 0.0
                                -43.912624 -34.191418 0.0 0.0 -1.3277903 0.6567537 0.0 0.0 -8.473991
                                -2.7934291 0.0 0.0 -8.003742 -3.2087321 0.0 0.0 -57.306305 -10.377193 0.0 0.0
                                -1.1916859 0.0027018937 0.0 0.0 -1.4240915 -0.15343529 0.0 0.0 -1.254833
                                -0.617723 0.0 0.0 -395.82697 122.11444 0.0 0.0 -1.3832889 0.08871124 0.0 0.0
                                -1.3119982 -0.16430375 0.0 0.0 -362.3698 140.77214 0.0 0.0 -1.4289712
                                0.23925619 0.0 0.0 -56.552055 -9.83868 0.0 0.0 -45.579456 -6.842364 0.0 0.0
                                -1.0894752 -0.9854043 0.0 0.0 -1.4426404 0.083819844 0.0 0.0 -57.89377
                                -32.28482 0.0 0.0 -441.5855 -70.062706 0.0 0.0 -1.3431484 0.41847324 0.0 0.0
                                -6.1640897 -6.0824203 0.0 0.0 -8.53107 -1.6565127 0.0 0.0 -65.72093
                                -15.585399 0.0 0.0 -8.783976 -2.8482742 0.0 0.0 -418.6857 -41.70048 0.0 0.0
                                -1.4434066 -0.30095524 0.0 0.0 -7.931627 1.9768364 0.0 0.0 -46.128376
                                33.65327 0.0 0.0 -62.60764 9.731502 0.0 0.0 -1.4731746 -0.18989693 0.0 0.0
                                -60.335793 -25.378063 0.0 0.0 -1.1965052 0.13537826 0.0 0.0 -52.114014
                                -29.024494 0.0 0.0 -61.79508 -9.8229065 0.0 0.0 -38.92794 38.748108 0.0 0.0
                                -38.466846 38.886616 0.0 0.0 -1.4751003 0.079803094 0.0 0.0 -51.84023
                                29.648836 0.0 0.0 -1.3364822 0.53308636 0.0 0.0 -7.5742345 -1.5774177 0.0 0.0
                                -9.47503 1.8101367 0.0 0.0 -367.13947 -219.52187 0.0 0.0 -1.1954526 0.8507555
                                0.0 0.0 -374.74496 165.8748 0.0 0.0 -7.5906487 -3.3767037 0.0 0.0 -9.349397
                                -2.7977247 0.0 0.0 -7.1946673 5.0842657 0.0 0.0 -7.188177 -4.9591813 0.0 0.0
                                -7.566273 3.0806851 0.0 0.0 -6.8702083 -3.3873122 0.0 0.0 -408.31387
                                -106.291145 0.0 0.0 -59.85366 -16.566479 0.0 0.0 -40.584713 -41.58352 0.0 0.0
                                -101.310326 -36.710205 0.0 0.0 -60.368282 -7.4734077 0.0 0.0 -7.876662
                                0.13843456 0.0 0.0 -58.446304 -24.952168 0.0 0.0 -9.132353 1.4850171 0.0 0.0
                                -1.2890905 -0.56056774 0.0 0.0 -69.84594 1.3363537 0.0 0.0 -9.908753
                                2.2664096 0.0 0.0 -9.473323 -2.069145 0.0 0.0 -56.31602 -14.116235 0.0 0.0
                                -8.293216 -5.2532406 0.0 0.0 -1.4473919 -0.25181 0.0 0.0 -63.708195 -5.001992
                                0.0 0.0 -1.479216 -0.041714706 0.0 0.0 -52.15515 -26.790636 0.0 0.0 -9.703374
                                0.7879369 0.0 0.0 -87.88908 -4.1349607 0.0 0.0 -1.2956007 0.7164025 0.0 0.0
                                -58.716064 -12.068778 0.0 0.0 -362.10516 -196.1264 0.0 0.0 -67.43351
                                -1.1048952 0.0 0.0 -426.919 -147.57571 0.0 0.0 -1.246009 0.56209654 0.0 0.0
                                -9.041571 1.7929373 0.0 0.0 -59.122017 -25.189068 0.0 0.0 -7.583412 1.8778324
                                0.0 0.0 -0.7896357 -0.029926388 0.0 0.0 -473.53226 -152.60968 0.0 0.0
                                -401.39438 -166.55998 0.0 0.0 -65.55645 -11.886421 0.0 0.0 -1.3653573
                                -0.5262636 0.0 0.0 -7.780712 1.5170486 0.0 0.0 -7.5925426 -2.8667839 0.0 0.0
                                -53.529175 -36.294704 0.0 0.0 -1.4482881 -0.16018057 0.0 0.0 -38.433422
                                -33.190346 0.0 0.0 -59.578968 -26.90961 0.0 0.0 -6.418196 -4.515229 0.0 0.0
                                -68.81576 4.092596 0.0 0.0 -6.5337424 4.857086 0.0 0.0 -1.3403565 0.62171346
                                0.0 0.0 -1.2314298 -0.6861499 0.0 0.0 -60.300934 -23.37714 0.0 0.0 -9.688845
                                -3.3564956 0.0 0.0 -8.1773405 -4.5925317 0.0 0.0 -1.4397672 0.15506788 0.0
                                0.0 -55.8825 -23.549292 0.0 0.0 -53.104782 21.365463 0.0 0.0 -1.3581026
                                -0.16871351 0.0 0.0 -8.927486 -0.76388526 0.0 0.0 -8.107176 1.0179313 0.0 0.0
                                -1.3705846 0.39732826 0.0 0.0 -63.210415 31.271208 0.0 0.0 -8.001268
                                -3.9395483 0.0 0.0 -62.316284 -27.861176 0.0 0.0 -1.171745 -0.5381711 0.0 0.0
                                -1.3752477 0.41845733 0.0 0.0 -1.3707662 0.022713749 0.0 0.0 -1.4550991
                                0.30292666 0.0 0.0 -8.220317 -6.1206207 0.0 0.0 -1.4544238 -0.28713763 0.0
                                0.0 -7.3536973 -2.9875455 0.0 0.0 -1.3029053 0.03031621 0.0 0.0 -7.802303
                                -4.7936344 0.0 0.0 -7.6424813 2.3491352 0.0 0.0 -1.1050025 -0.2745162 0.0 0.0
                                -7.0442533 -4.293586 0.0 0.0 -8.521404 -2.9304056 0.0 0.0 -1.3693179
                                0.5033291 0.0 0.0 -8.360257 3.4680676 0.0 0.0 -10.206092 -1.4010848 0.0 0.0
                                -61.4662 -5.2125654 0.0 0.0 -64.1528 27.59909 0.0 0.0 -1.0117556 -0.9153171
                                0.0 0.0 -1.1188534 -0.802498 0.0 0.0 -8.771402 1.8336325 0.0 0.0 -531.37146
                                -307.4488 0.0 0.0 -66.3682 3.7823834 0.0 0.0 -54.446552 -39.996887 0.0 0.0
                                -9.439452 -0.3821162 0.0 0.0 -10.01535 -0.21842545 0.0 0.0 -1.3940825
                                -0.04690489 0.0 0.0 -36.96445 -48.834354 0.0 0.0 -1.4784737 0.05410403 0.0
                                0.0 -1.3742685 -0.5661509 0.0 0.0 -8.327308 1.8781074 0.0 0.0 -68.21874
                                12.977899 0.0 0.0 -376.22 -263.6022 0.0 0.0 -1.3768858 -0.14353082 0.0 0.0
                                -55.97038 -34.77435 0.0 0.0 -8.435348 -4.187484 0.0 0.0 -1.4473442 0.18717021
                                0.0 0.0 -10.054099 -0.5166118 0.0 0.0 -1.4773972 -0.1790304 0.0 0.0
                                -63.494614 29.446285 0.0 0.0 -407.96616 -195.0049 0.0 0.0 -1.4831439
                                0.0033923408 0.0 0.0 -9.652106 -4.442288 0.0 0.0 -9.776222 -1.5115979 0.0 0.0
                                -65.29777 23.34692 0.0 0.0 -0.6929381 -1.2905056 0.0 0.0 -9.359302 2.2958 0.0
                                0.0 -7.8010426 3.8363407 0.0 0.0 -9.248343 -3.6661353 0.0 0.0 -595.06885
                                -98.58615 0.0 0.0 -351.43616 -264.05893 0.0 0.0 -50.315105 -43.684887 0.0 0.0
                                -60.761883 -0.37094235 0.0 0.0 -1.2525127 -0.45798317 0.0 0.0 -1.2876896
                                -0.20023753 0.0 0.0 -9.106037 -0.4326629 0.0 0.0 -8.983846 -1.059058 0.0 0.0
                                -67.793365 17.906214 0.0 0.0 -1.2768723 -0.6560687 0.0 0.0 -60.97184
                                -2.6836042 0.0 0.0 -7.49266 -5.1713443 0.0 0.0 -9.106843 -3.4379804 0.0 0.0
                                -9.030392 -4.351718 0.0 0.0 -61.0003 -11.848005 0.0 0.0 -60.781013 1.374043
                                0.0 0.0 -1.1939973 0.51271725 0.0 0.0 -1.3177435 -0.39417982 0.0 0.0
                                -58.991932 21.381235 0.0 0.0 -1.3542405 -0.38869444 0.0 0.0 -8.049944
                                1.4138676 0.0 0.0 -62.39251 -6.747095 0.0 0.0 -56.581165 -20.050058 0.0 0.0
                                -67.75354 -8.390885 0.0 0.0 -79.26018 -32.048862 0.0 0.0 -8.324446
                                0.119112805 0.0 0.0 -8.323815 3.288543 0.0 0.0 -1.4700365 0.04511837 0.0 0.0
                                -1.3977503 -0.05947709 0.0 0.0 -46.839127 34.566425 0.0 0.0 -64.14962
                                -8.396783 0.0 0.0 -1.3932773 -0.15501733 0.0 0.0 -1.3947208 -0.014533729 0.0
                                0.0 -1.5220866 -0.267988 0.0 0.0 -426.41443 170.86282 0.0 0.0 -1.453838
                                -0.46027982 0.0 0.0 -430.71536 -191.07986 0.0 0.0 -1.2548472 0.61643213 0.0
                                0.0 -57.686558 22.960482 0.0 0.0 -9.2267685 0.23703861 0.0 0.0 -7.642572
                                -4.366984 0.0 0.0 -54.698284 -27.765062 0.0 0.0 -10.04395 3.3580356 0.0 0.0
                                -2.0345125 -0.3648446 0.0 0.0 -1.0099419 -1.0749838 0.0 0.0 -64.78077
                                -16.820496 0.0 0.0 -7.540982 3.3618832 0.0 0.0 -1.44461 -0.34080517 0.0 0.0
                                -63.885365 -27.677343 0.0 0.0 -1.4385858 -0.15382253 0.0 0.0 -387.4328
                                -316.7167 0.0 0.0 -68.27633 -2.8526883 0.0 0.0 -467.521 -145.28372 0.0 0.0
                                -680.7392 -161.89774 0.0 0.0 -418.89304 -255.12529 0.0 0.0 -69.18144
                                22.954306 0.0 0.0 -1.4718785 -0.20258817 0.0 0.0 -63.137207 -16.723919 0.0
                                0.0 -1.2607532 0.64151144 0.0 0.0 -6.420577 -5.0261025 0.0 0.0 -9.181682
                                -4.175932 0.0 0.0 -61.360138 3.846196 0.0 0.0 -60.584225 10.675887 0.0 0.0
                                -681.65967 244.08081 0.0 0.0 -70.71177 -27.190304 0.0 0.0 -9.405325
                                -7.0165396 0.0 0.0 -1.4089059 -0.399043 0.0 0.0 -473.01364 -12.646061 0.0 0.0
                                -10.358523 -0.8385801 0.0 0.0 -1.3333853 -0.6233243 0.0 0.0 -63.89003
                                -1.9463336 0.0 0.0 -61.639 -0.643198 0.0 0.0 -334.40314 -537.6882 0.0 0.0
                                -58.368717 -20.675287 0.0 0.0 -1.2029557 0.32625198 0.0 0.0 -361.4247
                                -310.63272 0.0 0.0 -1.4881237 -0.019521952 0.0 0.0 -10.082316 2.077459 0.0
                                0.0 -8.119383 -6.4078474 0.0 0.0 -9.800826 2.9967484 0.0 0.0 -1.2121793
                                0.82369614 0.0 0.0 -10.147721 2.5870073 0.0 0.0 -1.4619691 -0.21939535 0.0
                                0.0 -1.4118716 -0.44104785 0.0 0.0 -1.4613307 0.0749239 0.0 0.0 -1.4631277
                                -0.21275103 0.0 0.0 -66.24334 14.566439 0.0 0.0 -9.072285 -4.4722605 0.0 0.0
                                -56.903656 -29.218996 0.0 0.0 -8.315774 0.04057425 0.0 0.0 -8.643596
                                -2.9966686 0.0 0.0 -7.6209507 -1.7312069 0.0 0.0 -1.452863 -0.012889795 0.0
                                0.0 -1.3491633 0.27447215 0.0 0.0 -9.380596 0.0999375 0.0 0.0 -1.2128234
                                -0.81026447 0.0 0.0 -8.393296 1.5907551 0.0 0.0 -55.12657 -30.027819 0.0 0.0
                                -1.308925 -0.011008427 0.0 0.0 -1.3196919 0.19462845 0.0 0.0 -9.295096
                                -4.178397 0.0 0.0 -9.142918 0.05202147 0.0 0.0 -61.15089 -23.915985 0.0 0.0
                                -7.9591837 -3.176989 0.0 0.0 -64.65845 -33.5318 0.0 0.0 -9.11949 -2.2470226
                                0.0 0.0 -8.033507 -2.3217974 0.0 0.0 -1.260263 -0.6752063 0.0 0.0 -61.7688
                                14.758867 0.0 0.0 -1.3028688 -0.5717558 0.0 0.0 -500.97098 168.72278 0.0 0.0
                                -1.396686 -0.4291286 0.0 0.0 -757.2539 -188.27399 0.0 0.0 -10.432884
                                -0.3572504 0.0 0.0 -69.55062 13.770757 0.0 0.0 -0.95007765 -0.8962806 0.0 0.0
                                -1.426983 -0.07209191 0.0 0.0 -8.320357 -0.78477585 0.0 0.0 -11.97892
                                -5.524105 0.0 0.0 -63.340652 -5.0087595 0.0 0.0 -6.888427 5.5460696 0.0 0.0
                                -1.4319577 -0.39353523 0.0 0.0 -1.0738183 -0.39133403 0.0 0.0 -9.650523
                                -3.6530113 0.0 0.0 -79.04321 3.0058987 0.0 0.0 -85.09665 -20.559166 0.0 0.0
                                -55.780758 -34.036423 0.0 0.0 -9.025829 2.5818737 0.0 0.0 -8.84428 2.8675697
                                0.0 0.0 -59.85906 -22.352322 0.0 0.0 -1.2173644 -0.2833234 0.0 0.0 -1.277137
                                0.76009065 0.0 0.0 -1.3910991 0.435653 0.0 0.0 -63.669678 16.284945 0.0 0.0
                                -1.1687946 0.40337947 0.0 0.0 -7.895692 -4.890112 0.0 0.0 -10.422547 0.325586
                                0.0 0.0 -9.491889 -5.2827945 0.0 0.0 -8.37669 6.1412864 0.0 0.0 -5.5201325
                                5.115073 0.0 0.0 -1.1273632 0.50156325 0.0 0.0 -9.513215 0.3124389 0.0 0.0
                                -434.46524 -371.11047 0.0 0.0 -503.32574 124.82014 0.0 0.0 -477.29636
                                -169.42836 0.0 0.0 -0.8899761 -0.9556943 0.0 0.0 -6.600826 -7.2924905 0.0 0.0
                                -72.3122 -14.017135 0.0 0.0 -40.547695 -53.516525 0.0 0.0 -9.603822 -3.461289
                                0.0 0.0 -1.4843711 0.020184375 0.0 0.0 -8.9495945 3.2908003 0.0 0.0
                                -525.59814 237.15793 0.0 0.0 -1.1071194 0.6597886 0.0 0.0 -7.5847473
                                -3.833662 0.0 0.0 -68.06564 -15.889464 0.0 0.0 -521.64777 -54.97966 0.0 0.0
                                -1.0642534 0.6939234 0.0 0.0 -47.73663 -46.450294 0.0 0.0 -0.8900285
                                -0.8995031 0.0 0.0 -59.415966 32.662 0.0 0.0 -73.713615 -6.0841966 0.0 0.0
                                -73.98711 6.6116753 0.0 0.0 -1.3940614 -0.51514405 0.0 0.0 -1.4207693
                                -0.42450172 0.0 0.0 -616.1372 187.2301 0.0 0.0 -79.45137 -25.605003 0.0 0.0
                                -64.98329 20.29682 0.0 0.0 -1.1828853 0.7688357 0.0 0.0 -1.3804998 0.46303406
                                0.0 0.0 -8.406001 3.6738338 0.0 0.0 -9.043209 5.722387 0.0 0.0 -9.382337
                                -4.3888235 0.0 0.0 -0.7144078 -0.9450775 0.0 0.0 -506.86188 -203.56477 0.0
                                0.0 -1.3225577 -0.5636976 0.0 0.0 -1.1624246 -0.4838289 0.0 0.0 -61.941364
                                35.504635 0.0 0.0 -68.228874 18.37061 0.0 0.0 -68.62735 20.575022 0.0 0.0
                                -9.175329 0.38442644 0.0 0.0 -61.217533 -22.385506 0.0 0.0 -532.56995
                                65.685234 0.0 0.0 -1.2101951 -0.35330132 0.0 0.0 -1.4813639 -0.065903 0.0 0.0
                                -1.4204273 -0.20014288 0.0 0.0 -1.3161925 -0.6244484 0.0 0.0 -1.2216798
                                -0.5427614 0.0 0.0 -9.614308 -2.116862 0.0 0.0 -79.29987 15.014063 0.0 0.0
                                -85.1667 -18.15942 0.0 0.0 -1.2135271 -0.8276232 0.0 0.0 -8.34406 3.618664
                                0.0 0.0 -1.4394758 0.26327306 0.0 0.0 -90.894066 11.523415 0.0 0.0 -9.060917
                                4.665812 0.0 0.0 -8.08674 4.291801 0.0 0.0 -73.20184 -39.575848 0.0 0.0
                                -65.87828 -9.736886 0.0 0.0 -1.4646747 0.16443503 0.0 0.0 -1.2000117
                                -0.53815037 0.0 0.0 -8.585548 -0.8125222 0.0 0.0 -1.4692147 -0.02456644 0.0
                                0.0 -67.9269 2.488455 0.0 0.0 -9.564741 -0.23360918 0.0 0.0 -399.64923
                                -394.10138 0.0 0.0 -1.3321087 0.57089025 0.0 0.0 -1.4856627 0.2969025 0.0 0.0
                                -10.079476 -3.889889 0.0 0.0 -1.3423882 0.43715268 0.0 0.0 -9.054616
                                -0.20650174 0.0 0.0 -9.288967 -2.7205243 0.0 0.0 -69.78811 3.394267 0.0 0.0
                                -64.01958 20.262486 0.0 0.0 -528.99677 444.91382 0.0 0.0 -9.40332 -5.2410126
                                0.0 0.0 -1.4226501 -0.13314174 0.0 0.0 -8.805831 1.1185148 0.0 0.0 -116.09695
                                -11.858416 0.0 0.0 -7.7187915 -6.1489635 0.0 0.0 -1.2585174 -0.16685326 0.0
                                0.0 -76.05069 -25.655617 0.0 0.0 -1.0339464 -0.21470255 0.0 0.0 -1.2954391
                                -0.34879076 0.0 0.0 -43.407352 -51.6161 0.0 0.0 -1.3310152 -0.026664734 0.0
                                0.0 -6.641112 -6.5633783 0.0 0.0 -1.3260005 -0.14480689 0.0 0.0 -1.3157694
                                -0.011188767 0.0 0.0 -8.447789 3.9232538 0.0 0.0 -1.3140746 0.033639833 0.0
                                0.0 -1.3184633 0.23049203 0.0 0.0 -57.23568 -39.38567 0.0 0.0 -1.2965686
                                -0.18648463 0.0 0.0 -8.667928 -1.5404049 0.0 0.0 -91.5439 -7.4511137 0.0 0.0
                                -1.3268113 0.0027611859 0.0 0.0 -0.9306917 0.25613284 0.0 0.0 -7.778841
                                -2.9811926 0.0 0.0 -1.231988 -0.08461355 0.0 0.0 -1.318066 -0.16919602 0.0
                                0.0 -1.2501795 0.48326987 0.0 0.0 -10.287491 -3.0303192 0.0 0.0 -8.393377
                                1.7613168 0.0 0.0 -7.6593657 -4.1024966 0.0 0.0 -1.2149364 0.5221303 0.0 0.0
                                -0.99828213 0.89369816 0.0 0.0 -6.7958736 5.43608 0.0 0.0 -1.2326881
                                0.36411476 0.0 0.0 -1.289263 0.33568978 0.0 0.0 -10.0592985 -2.849932 0.0 0.0
                                -1.2764965 -0.3067017 0.0 0.0 -60.42272 -35.893787 0.0 0.0 -8.167596
                                5.4293137 0.0 0.0 -25.823332 41.13195 0.0 0.0 -68.636 0.26011786 0.0 0.0
                                -1.3282173 0.08845697 0.0 0.0 -8.640404 1.7165865 0.0 0.0 -1.1230624
                                -0.7001671 0.0 0.0 -1.161558 -0.3899395 0.0 0.0 -81.16521 -13.216878 0.0 0.0
                                -92.57839 -12.66353 0.0 0.0 -8.222787 -2.5226424 0.0 0.0 -8.801223 0.06461396
                                0.0 0.0 -1.2996297 0.21470597 0.0 0.0 -1.2342141 0.50874966 0.0 0.0
                                -0.84352654 0.6619351 0.0 0.0 -7.9941044 4.235863 0.0 0.0 -1.2926152
                                -0.12486009 0.0 0.0 -1.2288781 0.5104407 0.0 0.0 -68.5154 -24.72409 0.0 0.0
                                -6.8628335 5.5338507 0.0 0.0 -1.2874383 0.30283764 0.0 0.0 -64.94969
                                -28.993689 0.0 0.0 -87.39928 19.51864 0.0 0.0 -9.002939 3.1732435 0.0 0.0
                                -9.395318 -3.5113723 0.0 0.0 -10.779535 -2.5598736 0.0 0.0 -89.62745
                                29.927197 0.0 0.0 -8.387393 -1.9774332 0.0 0.0 -69.45738 4.5682306 0.0 0.0
                                -1.288008 0.080742806 0.0 0.0 -9.14613 -1.8987613 0.0 0.0 -1.2769663
                                0.0072653294 0.0 0.0 -58.47296 -44.417233 0.0 0.0 -12.34171 -0.53625077 0.0
                                0.0 -8.675806 -0.2391902 0.0 0.0 -8.370125 -4.1288285 0.0 0.0 -9.694176
                                -0.08449703 0.0 0.0 -11.622771 1.3228368 0.0 0.0 -9.852092 -7.477459 0.0 0.0
                                -8.513985 4.624045 0.0 0.0 -1.2978238 -0.57842714 0.0 0.0 -1.3292363
                                -0.09973316 0.0 0.0 -0.9937288 0.79091406 0.0 0.0 -61.938362 -33.026295 0.0
                                0.0 -8.829201 1.2150079 0.0 0.0 -8.475661 -4.878504 0.0 0.0 -9.374907
                                2.6455734 0.0 0.0 -1.1636186 -0.026095945 0.0 0.0 -74.13472 -35.380974 0.0
                                0.0 -1.1505144 0.6421361 0.0 0.0 -86.51758 -3.5885751 0.0 0.0 -12.934994
                                4.710945 0.0 0.0 -10.124052 0.6892644 0.0 0.0 -7.856076 3.711669 0.0 0.0
                                -8.407136 -7.885544 0.0 0.0 -10.191849 -3.878621 0.0 0.0 -9.447053 -2.6693351
                                0.0 0.0 -1.2884067 -0.049019013 0.0 0.0 -7.7521634 -3.9605782 0.0 0.0
                                -82.666916 2.0620494 0.0 0.0 -1.2252996 -0.2899917 0.0 0.0 -1.0900683
                                -0.2179885 0.0 0.0 -8.684549 0.4402172 0.0 0.0 -70.77138 -5.415194 0.0 0.0
                                -9.709711 -1.3846054 0.0 0.0 -9.470695 2.6565537 0.0 0.0 -75.750694
                                -12.877964 0.0 0.0 -0.8053687 -1.0457482 0.0 0.0 -8.812342 -4.2147675 0.0 0.0
                                -8.1598215 -3.6313238 0.0 0.0 -69.38363 -28.594637 0.0 0.0 -1.3006355
                                -0.29407993 0.0 0.0 -1.0981227 -0.37194297 0.0 0.0 -8.263516 4.6232886 0.0
                                0.0 -1.1149397 -0.681493 0.0 0.0 -1.1425565 -0.42027318 0.0 0.0 -1.2063304
                                -0.52968544 0.0 0.0 -80.93166 -20.927378 0.0 0.0 -1.2011682 -0.5187332 0.0
                                0.0 -11.934477 -0.019079966 0.0 0.0 -1.3257216 -0.4149732 0.0 0.0 -1.2119893
                                0.3778617 0.0 0.0 -9.121748 -1.5628103 0.0 0.0 -8.444552 5.1473126 0.0 0.0
                                -89.34344 15.994494 0.0 0.0 -56.20922 44.749023 0.0 0.0 -6.477001 -6.2511463
                                0.0 0.0 -1.138545 0.5844176 0.0 0.0 -79.534164 7.3507495 0.0 0.0 -9.1777115
                                -2.7332585 0.0 0.0 -9.726918 -1.8551987 0.0 0.0 -1.0775895 0.7676485 0.0 0.0
                                -10.551034 -0.25738928 0.0 0.0 -1.3382094 0.04852144 0.0 0.0 -10.0048275
                                -1.6274779 0.0 0.0 -1.1535337 0.60289377 0.0 0.0 -8.216145 -2.7998717 0.0 0.0
                                -62.9408 -35.62338 0.0 0.0 -1.2941825 0.1921149 0.0 0.0 -1.2881832
                                -0.13913313 0.0 0.0 -0.6489167 -1.1514549 0.0 0.0 -8.129461 -5.7026634 0.0
                                0.0 -8.823072 -0.56228745 0.0 0.0 -76.464485 -25.401146 0.0 0.0 -83.42693
                                -25.408018 0.0 0.0 -7.283733 -6.1253686 0.0 0.0 -9.040579 0.0719662 0.0 0.0
                                -78.52736 4.747201 0.0 0.0 -76.63946 2.439989 0.0 0.0 -1.3215148 -0.19225387
                                0.0 0.0 -80.02585 -23.952417 0.0 0.0 -8.849207 -0.1397181 0.0 0.0 -0.6672502
                                0.8758173 0.0 0.0 -10.507015 -3.0334003 0.0 0.0 -1.5598477 0.6092542 0.0 0.0
                                -1.2146292 -0.24878135 0.0 0.0 -87.4466 0.90620166 0.0 0.0 -9.252743
                                -1.3001059 0.0 0.0 -9.500708 1.4404281 0.0 0.0 -178.718 -11.321887 0.0 0.0
                                -11.959324 -1.1710355 0.0 0.0 -65.699 -32.457565 0.0 0.0 -1.080598
                                0.010203816 0.0 0.0 -1.3533798 -0.27624637 0.0 0.0 -1.0292965 0.46027106 0.0
                                0.0 -8.223138 -3.3737755 0.0 0.0 -10.50194 1.8757015 0.0 0.0 -1.3136982
                                0.057391778 0.0 0.0 -78.22437 -30.425251 0.0 0.0 -74.67031 27.761374 0.0 0.0
                                -9.720735 -1.618605 0.0 0.0 -12.175645 -5.182389 0.0 0.0 -1.3289227
                                0.16375162 0.0 0.0 -102.9015 -15.042232 0.0 0.0 -9.41688 -4.5937967 0.0 0.0
                                -1.3991456 0.34080023 0.0 0.0 -1.141631 -0.76135516 0.0 0.0 -1.1730043
                                -0.5623635 0.0 0.0 -92.46196 -27.162977 0.0 0.0 -1.3126096 -0.09454809 0.0
                                0.0 -11.724122 -1.3905941 0.0 0.0 -10.504678 0.5843165 0.0 0.0 -68.07534
                                29.321259 0.0 0.0 -9.091224 -4.2453575 0.0 0.0 -1.324437 0.05372622 0.0 0.0
                                -1.2397062 -0.27221388 0.0 0.0 -10.970971 -4.6679225 0.0 0.0 -1.2123888
                                -0.46526942 0.0 0.0 -1.0951357 -0.63791806 0.0 0.0 -9.65133 -0.6162014 0.0
                                0.0 -1.0587147 -0.8117438 0.0 0.0 -1.3169976 -0.20699124 0.0 0.0 -9.359644
                                0.30229315 0.0 0.0 -1.251373 -0.27980286 0.0 0.0 -9.663376 -0.48635313 0.0
                                0.0 -10.155225 -3.5910366 0.0 0.0 -8.33494 -3.799889 0.0 0.0 -44.571598
                                -67.55978 0.0 0.0 -8.901454 -3.1942303 0.0 0.0 -1.0873659 -0.5659986 0.0 0.0
                                -1.3003136 -0.28670347 0.0 0.0 -1.3505478 -0.14786784 0.0 0.0 -8.981109
                                0.23688823 0.0 0.0 -1.2881289 -0.3615109 0.0 0.0 -11.037159 -0.32109508 0.0
                                0.0 -9.935569 0.954906 0.0 0.0 -9.154889 1.1775776 0.0 0.0 -7.353807
                                5.1771226 0.0 0.0 -8.640714 -5.254926 0.0 0.0 -8.660657 -3.175217 0.0 0.0
                                -1.3003788 -0.123568945 0.0 0.0 -0.8698059 0.85273665 0.0 0.0 -59.788868
                                -49.113033 0.0 0.0 -1.2289821 -0.331723 0.0 0.0 -1.1917676 -0.59885025 0.0
                                0.0 -1.2685549 -0.23986177 0.0 0.0 -82.02694 33.62165 0.0 0.0 -8.9752445
                                -0.81443536 0.0 0.0 -10.839989 -0.9879243 0.0 0.0 -1.3173622 -0.16235216 0.0
                                0.0 -1.320528 -0.030885627 0.0 0.0 -1.1989096 0.49187127 0.0 0.0 -92.68994
                                14.800517 0.0 0.0 -9.737517 -0.61430955 0.0 0.0 -6.6483693 7.645308 0.0 0.0
                                -1.3608019 -0.052782066 0.0 0.0 -77.90007 3.237514 0.0 0.0 -1.329331
                                0.12811273 0.0 0.0 -73.58282 26.03299 0.0 0.0 -8.974418 1.0260985 0.0 0.0
                                -9.676346 -3.4658294 0.0 0.0 -1.2785413 -0.28971967 0.0 0.0 -8.814084
                                2.0679886 0.0 0.0 -7.979058 -5.2127466 0.0 0.0 -0.9823258 -0.44522953 0.0 0.0
                                -9.242863 0.8993277 0.0 0.0 -9.293682 -3.1282587 0.0 0.0 -89.17784 10.071133
                                0.0 0.0 -1.2663898 -0.4310924 0.0 0.0 -1.2556576 0.3197907 0.0 0.0 -0.8383261
                                -0.8987799 0.0 0.0 -6.9205146 6.3861256 0.0 0.0 -8.995565 2.328859 0.0 0.0
                                -80.707664 -50.214184 0.0 0.0 -91.71065 1.6263887 0.0 0.0 -1.2477372 0.312608
                                0.0 0.0 -93.744545 -16.721962 0.0 0.0 -10.227098 -0.14618224 0.0 0.0
                                -1.0697658 -0.53105044 0.0 0.0 -1.0579442 -0.7206791 0.0 0.0 -1.2318712
                                0.39503783 0.0 0.0 -8.145932 -6.1137476 0.0 0.0 -8.723331 -3.2753458 0.0 0.0
                                -1.1600897 -0.032188408 0.0 0.0 -1.5363853 0.47191727 0.0 0.0 -9.331954
                                0.67051005 0.0 0.0 -1.2490199 -0.4819478 0.0 0.0 -1.2746497 0.04429802 0.0
                                0.0 -8.821551 1.3636547 0.0 0.0 -77.455414 31.98006 0.0 0.0 -1.1425616
                                0.26153654 0.0 0.0 -69.72997 -58.6319 0.0 0.0 -1.3667889 -0.41176903 0.0 0.0
                                -82.76879 -16.093206 0.0 0.0 -1.4053818 -0.41345116 0.0 0.0 -11.736551
                                1.2965174 0.0 0.0 -75.85226 15.496346 0.0 0.0 -8.540764 5.8517046 0.0 0.0
                                -1.2735782 0.73000133 0.0 0.0 -8.26314 -3.673375 0.0 0.0 -0.9912945
                                -1.0759149 0.0 0.0 -73.832664 27.787048 0.0 0.0 -0.91107774 0.28630975 0.0
                                0.0 -0.9072687 0.10795732 0.0 0.0 -1.1468523 0.7766231 0.0 0.0 -82.06424
                                33.526505 0.0 0.0 -8.991414 5.2832427 0.0 0.0 -71.94821 -38.05298 0.0 0.0
                                -10.468769 -1.2701315 0.0 0.0 -1.4724369 0.06058429 0.0 0.0 -1.1517547
                                -0.7173447 0.0 0.0 -10.935765 3.6836028 0.0 0.0 -11.746594 -1.4410572 0.0 0.0
                                -7.3943343 -5.573707 0.0 0.0 -590.2222 -473.98877 0.0 0.0 -9.420135 2.3924582
                                0.0 0.0 -72.955086 45.55944 0.0 0.0 -11.323412 2.5476289 0.0 0.0 -1.1443124
                                0.4448383 0.0 0.0 -84.21606 -30.731907 0.0 0.0 -1.4866167 -0.026455307 0.0
                                0.0 -10.62933 -0.6878351 0.0 0.0 -84.40623 -19.26328 0.0 0.0 -10.528315
                                3.1082978 0.0 0.0 -10.698332 -3.4343436 0.0 0.0 -82.67516 30.369495 0.0 0.0
                                -1.3435339 -0.59758663 0.0 0.0 -86.91468 19.215147 0.0 0.0 -9.507372
                                -2.3257337 0.0 0.0 -70.646545 -37.96885 0.0 0.0 -79.59629 -10.208798 0.0 0.0
                                -13.295692 2.2265258 0.0 0.0 -698.1753 -114.57001 0.0 0.0 -1.396727 0.2161359
                                0.0 0.0 -1.4771792 -0.256524 0.0 0.0 -767.1723 -67.83992 0.0 0.0 -90.23553
                                -8.071044 0.0 0.0 -1.2663985 -0.26985037 0.0 0.0 -9.7711525 3.619889 0.0 0.0
                                -77.76044 -17.705288 0.0 0.0 -1.2550732 -0.5220319 0.0 0.0 -1.426924
                                0.010722898 0.0 0.0 -10.258745 -1.8121974 0.0 0.0 -1.4044789 -0.26781133 0.0
                                0.0 -1.3597288 -0.4445867 0.0 0.0 -660.4812 -408.30484 0.0 0.0 -11.324049
                                0.6109677 0.0 0.0 -19.919851 -3.55857 0.0 0.0 -11.142448 3.5874467 0.0 0.0
                                -9.870374 3.3459601 0.0 0.0 -398.76147 152.77661 0.0 0.0 -1.3396968
                                -0.48854113 0.0 0.0 -9.63008 1.9951608 0.0 0.0 -88.39543 -14.6248255 0.0 0.0
                                -83.9406 30.273935 0.0 0.0 -100.851685 19.562222 0.0 0.0 -1.3625333
                                -0.32969332 0.0 0.0 -91.10529 9.345844 0.0 0.0 -1.1321069 -0.888976 0.0 0.0
                                -1.4681498 0.17540412 0.0 0.0 -76.67619 -36.37278 0.0 0.0 -10.889858
                                -2.7126904 0.0 0.0 -8.495744 -8.000111 0.0 0.0 -74.47985 53.795536 0.0 0.0
                                -1.2825086 0.15469691 0.0 0.0 -1.4134177 0.28567106 0.0 0.0 -12.400229
                                -3.4318373 0.0 0.0 -680.62115 -193.20798 0.0 0.0 -1297.7896 -335.92645 0.0
                                0.0 -85.20929 4.2749734 0.0 0.0 -10.571108 4.2960153 0.0 0.0 -90.769775
                                -16.496418 0.0 0.0 -9.508038 1.7134143 0.0 0.0 -67.86447 -26.155832 0.0 0.0
                                -1.3674994 0.32851207 0.0 0.0 -9.781503 1.7866149 0.0 0.0 -1.1073859
                                0.81501645 0.0 0.0 -9.321439 -2.745926 0.0 0.0 -703.3349 -209.0658 0.0 0.0
                                -591.377 -435.32736 0.0 0.0 -1.3081608 0.28243378 0.0 0.0 -1.4073616
                                -0.18184939 0.0 0.0 -6.047515 -7.1354055 0.0 0.0 -11.786505 -0.3593969 0.0
                                0.0 -963.5413 570.99133 0.0 0.0 -1.42937 0.12086716 0.0 0.0 -5.1494856
                                -8.7195 0.0 0.0 -1.2529643 -0.13942231 0.0 0.0 -76.70619 -33.766567 0.0 0.0
                                -1.372536 -0.41369542 0.0 0.0 -73.78961 -24.187271 0.0 0.0 -8.840181
                                -5.9105744 0.0 0.0 -1.3401561 -0.59564644 0.0 0.0 -85.349815 -34.335636 0.0
                                0.0 -9.611929 6.8822627 0.0 0.0 -10.004051 -0.14530775 0.0 0.0 -10.083637
                                -3.5815244 0.0 0.0 -1.4314175 0.27910003 0.0 0.0 -11.478433 -2.1394897 0.0
                                0.0 -1.4297715 -0.37124225 0.0 0.0 -80.05861 22.33784 0.0 0.0 -80.888214
                                -13.858787 0.0 0.0 -11.27138 -0.6215066 0.0 0.0 -93.51887 -26.118979 0.0 0.0
                                -11.35669 -3.2601402 0.0 0.0 -110.57112 -16.199205 0.0 0.0 -82.14698
                                -22.598942 0.0 0.0 -9.385568 3.6187553 0.0 0.0 -11.262144 -3.898784 0.0 0.0
                                -11.408878 -2.6924858 0.0 0.0 -1.4668857 -0.24815577 0.0 0.0 -10.249684
                                2.6883821 0.0 0.0 -9.332264 1.9459873 0.0 0.0 -10.253501 -6.2965484 0.0 0.0
                                -0.43941906 -0.026186889 0.0 0.0 -700.86847 -219.28104 0.0 0.0 -1.3029273
                                0.5071403 0.0 0.0 -84.94127 0.064855814 0.0 0.0 -79.7871 -32.571877 0.0 0.0
                                -4.0513306 -9.846365 0.0 0.0 -10.40618 -2.7530074 0.0 0.0 -9.725784 4.1808167
                                0.0 0.0 -1.3695681 -0.6511545 0.0 0.0 -87.72418 2.5188477 0.0 0.0 -82.88053
                                3.5529454 0.0 0.0 -1.354894 0.44195518 0.0 0.0 -1.3897312 0.5303098 0.0 0.0
                                -9.709777 1.7223463 0.0 0.0 -9.872175 -2.944179 0.0 0.0 -12.146173 -4.4279404
                                0.0 0.0 -81.25727 18.029654 0.0 0.0 -85.11739 17.290413 0.0 0.0 -98.81903
                                -33.975792 0.0 0.0 -99.852554 -30.689182 0.0 0.0 -1.4016806 0.42476943 0.0
                                0.0 -1.1596725 -0.8050113 0.0 0.0 -127.51926 5.861242 0.0 0.0 -1.4603653
                                -0.21762972 0.0 0.0 -1.4799125 0.26644206 0.0 0.0 -11.647066 0.62598896 0.0
                                0.0 -11.064836 -2.872046 0.0 0.0 -1.2501203 0.7045452 0.0 0.0 -1.3712536
                                0.32230866 0.0 0.0 -914.56323 -223.21793 0.0 0.0 -78.99509 -40.45232 0.0 0.0
                                -9.005509 3.0717344 0.0 0.0 -10.043868 2.9021833 0.0 0.0 -1.270823 0.5914332
                                0.0 0.0 -10.4453125 2.8072462 0.0 0.0 -1.3834568 -0.24173318 0.0 0.0
                                -8.711573 -7.462657 0.0 0.0 -1.3275514 0.41364524 0.0 0.0 -98.9546 -19.960176
                                0.0 0.0 -1.4361895 0.07902089 0.0 0.0 -7.472053 -5.0538473 0.0 0.0 -80.20848
                                44.7724 0.0 0.0 -86.40879 -7.362972 0.0 0.0 -106.45301 -35.11417 0.0 0.0
                                -86.75663 10.313208 0.0 0.0 -8.012944 -5.6682196 0.0 0.0 -1.0611309
                                0.69304717 0.0 0.0 -10.1511 -0.58592814 0.0 0.0 -105.46875 62.07688 0.0 0.0
                                -9.570882 -3.3936496 0.0 0.0 -73.32215 42.42507 0.0 0.0 -152.7537 28.099129
                                0.0 0.0 -1.3983018 -0.4371472 0.0 0.0 -95.65033 -9.234415 0.0 0.0 -127.24542
                                10.585572 0.0 0.0 -0.96505266 -1.1089965 0.0 0.0 -1.3553052 0.014754921 0.0
                                0.0 -1.4835528 -0.10255719 0.0 0.0 -84.24866 -44.67855 0.0 0.0 -83.48692
                                13.24624 0.0 0.0 -1.3170062 -0.066034615 0.0 0.0 -7.1424956 -7.349227 0.0 0.0
                                -1.2010663 -0.45978358 0.0 0.0 -10.762204 1.3363856 0.0 0.0 -90.80384
                                19.021383 0.0 0.0 -1.4293895 -0.08410545 0.0 0.0 -8.980116 6.7672415 0.0 0.0
                                -97.57667 2.639816 0.0 0.0 -754.371 -252.36913 0.0 0.0 -102.20833 -57.25394
                                0.0 0.0 -1.3816658 -0.12380589 0.0 0.0 -1.3791537 -0.3042212 0.0 0.0 -9.96604
                                -5.4742455 0.0 0.0 -11.854755 -1.2335981 0.0 0.0 -1.3614277 -0.08454488 0.0
                                0.0 -86.02556 13.190242 0.0 0.0 -10.439566 -4.891143 0.0 0.0 -1.1048009
                                0.31027752 0.0 0.0 -43.59005 -59.099472 0.0 0.0 -111.26588 1.6729418 0.0 0.0
                                -1.4218438 -0.31108302 0.0 0.0 -1.0793117 -0.7315769 0.0 0.0 -10.69266
                                -5.7766395 0.0 0.0 -9.152716 -3.194553 0.0 0.0 -9.765148 -0.2496573 0.0 0.0
                                -1.2904222 0.6513657 0.0 0.0 -10.293101 -5.9849243 0.0 0.0 -98.557686
                                4.417684 0.0 0.0 -11.8298025 -0.5488307 0.0 0.0 -9.306735 6.1791835 0.0 0.0
                                -8.494697 -4.6034174 0.0 0.0 -86.797005 -8.79577 0.0 0.0 -68.2444 -52.35505
                                0.0 0.0 -78.53265 -36.510025 0.0 0.0 -89.90646 18.174904 0.0 0.0 -8.112616
                                -4.4445024 0.0 0.0 -1.4394637 0.063037015 0.0 0.0 -12.96259 -5.5863895 0.0
                                0.0 -10.433354 0.7788055 0.0 0.0 -83.88262 -30.96609 0.0 0.0 -1.3954087
                                0.3098622 0.0 0.0 -10.8363285 1.4556489 0.0 0.0 -1.2441161 -0.4574051 0.0 0.0
                                -69.74547 -60.268353 0.0 0.0 -11.769274 1.4532267 0.0 0.0 -1.4772877
                                0.1674475 0.0 0.0 -1.3209982 -0.6384876 0.0 0.0 -821.6291 471.42044 0.0 0.0
                                -9.6839 -5.0789175 0.0 0.0 -1.4639255 -0.14888234 0.0 0.0 -91.5418 -26.319405
                                0.0 0.0 -1.2426103 -0.69251406 0.0 0.0 -9.700819 6.66954 0.0 0.0 -89.1265
                                -31.440016 0.0 0.0 -99.045975 6.483125 0.0 0.0 -91.84583 -42.54585 0.0 0.0
                                -16.284151 0.6231625 0.0 0.0 -90.65876 17.638882 0.0 0.0 -9.868864 -5.6082687
                                0.0 0.0 -1.332671 0.2846459 0.0 0.0 -88.76332 6.6548834 0.0 0.0 -1.2414725
                                0.80396056 0.0 0.0 -1.4501119 0.31588435 0.0 0.0 -135.13649 -14.806076 0.0
                                0.0 -120.429375 31.553959 0.0 0.0 -10.003979 -7.517187 0.0 0.0 -111.38507
                                38.224056 0.0 0.0 -9.109815 5.494565 0.0 0.0 -9.940553 -1.4375213 0.0 0.0
                                -8.905678 -4.0403285 0.0 0.0 -10.854699 -4.5336676 0.0 0.0 -1.0912709
                                0.87321246 0.0 0.0 -1.3924125 -0.494439 0.0 0.0 -11.759832 -2.6613266 0.0 0.0
                                -8.458071 7.1762414 0.0 0.0 -11.749382 -1.731461 0.0 0.0 -1167.4884
                                -275.77875 0.0 0.0 -88.75471 32.58185 0.0 0.0 -9.910467 -6.869333 0.0 0.0
                                -8.251601 -4.6311026 0.0 0.0 -10.25718 -1.5115894 0.0 0.0 -11.156247
                                -5.3366084 0.0 0.0 -85.9973 -50.42692 0.0 0.0 -1.109817 -0.8909057 0.0 0.0
                                -1.3854764 0.38261652 0.0 0.0 -98.687836 15.365354 0.0 0.0 -1.3225648
                                -0.49270847 0.0 0.0 -9.798542 -1.3800157 0.0 0.0 -100.294174 -14.019927 0.0
                                0.0 -88.30041 32.8968 0.0 0.0 -11.082215 -1.0013312 0.0 0.0 -7.0949903
                                -7.8301964 0.0 0.0 -1.2429006 0.608696 0.0 0.0 -0.94869477 -1.0860211 0.0 0.0
                                -10.283922 -4.225079 0.0 0.0 -0.5046287 0.12948456 0.0 0.0 -7.208642
                                -8.181048 0.0 0.0 -1.4111769 0.15300004 0.0 0.0 -85.34883 -26.56656 0.0 0.0
                                -11.146362 4.0250487 0.0 0.0 -1.4191623 -0.20182484 0.0 0.0 -91.03103
                                39.11878 0.0 0.0 -1.3883835 -0.23478465 0.0 0.0 -12.3043995 -0.19960034 0.0
                                0.0 -1184.2778 -284.28128 0.0 0.0 -89.39126 7.424997 0.0 0.0 -824.56915
                                -109.94603 0.0 0.0 -1.2369502 -0.06694533 0.0 0.0 -76.00247 -47.92318 0.0 0.0
                                -118.08772 24.594418 0.0 0.0 -1.3896364 -0.20694643 0.0 0.0 -1.4357831
                                0.20228854 0.0 0.0 -10.813301 4.949309 0.0 0.0 -66.95153 -60.265247 0.0 0.0
                                -91.153564 -57.172276 0.0 0.0 -1.472194 0.045342725 0.0 0.0 -1.4234489
                                -0.0062105544 0.0 0.0 -117.495735 18.8665 0.0 0.0 -1.37082 0.050406784 0.0
                                0.0 -88.705086 27.711744 0.0 0.0 -11.383662 -5.1280932 0.0 0.0 -1.0602182
                                -0.9930429 0.0 0.0 -89.40367 -41.93752 0.0 0.0 -1.2707835 0.22979152 0.0 0.0
                                -154.60863 70.0657 0.0 0.0 -93.76908 -21.369226 0.0 0.0 -107.48493 -21.19034
                                0.0 0.0 -1.4597386 -0.013745977 0.0 0.0 -1.3441454 0.27318147 0.0 0.0
                                -9.862433 2.6066053 0.0 0.0 -61.29669 -81.46046 0.0 0.0 -10.77637 0.5974055
                                0.0 0.0 -1.4721715 -0.07336613 0.0 0.0 -1.310572 -0.6730309 0.0 0.0 -862.2566
                                -147.63986 0.0 0.0 -10.066124 -7.2485924 0.0 0.0 -1.3450618 0.6312277 0.0 0.0
                                -103.829475 -0.7807802 0.0 0.0 -1.5278087 0.1631819 0.0 0.0 -1.3502456
                                -0.3154653 0.0 0.0 -81.37022 -41.451122 0.0 0.0 -1.4593347 0.0012688879 0.0
                                0.0 -110.83929 44.312527 0.0 0.0 -1.3315752 0.597434 0.0 0.0 -102.92995
                                12.82545 0.0 0.0 -9.76608 -4.979924 0.0 0.0 -1.3886944 0.35914385 0.0 0.0
                                -99.31607 23.848352 0.0 0.0 -1.4525611 -0.15980507 0.0 0.0 -10.520366
                                -1.4902389 0.0 0.0 -9.772418 2.241525 0.0 0.0 -1.2285527 -0.43134683 0.0 0.0
                                -128.20448 44.07622 0.0 0.0 -101.669655 -23.343327 0.0 0.0 -1.3436531
                                -0.20893009 0.0 0.0 -91.03497 -7.82473 0.0 0.0 -127.858246 -47.326256 0.0 0.0
                                -107.85819 43.068745 0.0 0.0 -95.878555 -47.32545 0.0 0.0 -1.2560692
                                -0.7279362 0.0 0.0 -9.61892 -3.9139218 0.0 0.0 -864.10846 59.956303 0.0 0.0
                                -1.4546428 -0.04064941 0.0 0.0 -9.560695 -3.7197893 0.0 0.0 -13.2394495
                                -3.6967318 0.0 0.0 -92.17044 7.01908 0.0 0.0 -13.132691 -0.1454439 0.0 0.0
                                -91.61403 12.857639 0.0 0.0 -1.3414892 -0.39438665 0.0 0.0 -1.4224144
                                0.263849 0.0 0.0 -1.4276078 0.014728308 0.0 0.0 -1050.874 -232.28229 0.0 0.0
                                -1.2747732 0.41714978 0.0 0.0 -94.737144 12.796324 0.0 0.0 -0.90471905
                                -1.1183474 0.0 0.0 -101.091576 -30.93987 0.0 0.0 -1.2204905 0.40623525 0.0
                                0.0 -11.786409 -1.0114667 0.0 0.0 -128.09703 -69.51808 0.0 0.0 -1.1654352
                                -0.816528 0.0 0.0 -11.322577 0.15199919 0.0 0.0 -878.56085 -24.266167 0.0 0.0
                                -1.383719 0.34194633 0.0 0.0 -1.3663619 -0.26015815 0.0 0.0 -1.4271033
                                0.36509416 0.0 0.0 -112.34081 -2.937581 0.0 0.0 -874.6653 -114.22874 0.0 0.0
                                -1.2907887 -0.46158558 0.0 0.0 -9.668146 -5.917934 0.0 0.0 -1.4176532
                                -0.11236953 0.0 0.0 -1.3665721 -0.25199586 0.0 0.0 -11.8299885 -4.6248417 0.0
                                0.0 -1.0868723 -0.9919831 0.0 0.0 -10.761381 -6.1199417 0.0 0.0 -757.93994
                                -560.0234 0.0 0.0 -9.719585 -5.6592126 0.0 0.0 -11.184345 -2.4566236 0.0 0.0
                                -11.798333 4.2299056 0.0 0.0 -92.259964 -47.713387 0.0 0.0 -80.00636 54.24864
                                0.0 0.0 -107.17223 -3.2062392 0.0 0.0 -0.9131655 -1.0891304 0.0 0.0
                                -94.135155 33.48149 0.0 0.0 -1.1442586 0.7456531 0.0 0.0 -160.25275
                                -30.951412 0.0 0.0 -11.52735 4.2990484 0.0 0.0 -94.31351 -12.831176 0.0 0.0
                                -95.0793 -52.478592 0.0 0.0 -9.770163 -5.4832315 0.0 0.0 -847.30493
                                -435.98495 0.0 0.0 -105.748665 15.927542 0.0 0.0 -1.014072 0.777156 0.0 0.0
                                -63.718735 67.91262 0.0 0.0 -10.833417 -6.9736905 0.0 0.0 -650.1615 622.52606
                                0.0 0.0 -1.5023496 0.1778863 0.0 0.0 -12.258769 -2.2420983 0.0 0.0 -1.192584
                                -0.0589425 0.0 0.0 -1.1653718 -0.7467863 0.0 0.0 -100.79449 13.747811 0.0 0.0
                                -1.4066502 0.06581342 0.0 0.0 -141.98029 -48.12598 0.0 0.0 -1.4578952
                                0.3111343 0.0 0.0 -1.4362018 -0.29101852 0.0 0.0 -1.2878387 -0.31812087 0.0
                                0.0 -901.3659 -487.2836 0.0 0.0 -97.94458 30.010159 0.0 0.0 -1.3627806
                                0.50530386 0.0 0.0 -88.64061 33.361214 0.0 0.0 -1.246366 -0.68702203 0.0 0.0
                                -93.39899 -21.43759 0.0 0.0 -10.906985 -1.4171823 0.0 0.0 -87.44302
                                -53.784435 0.0 0.0 -1.4835626 0.046599105 0.0 0.0 -9.131355 -8.952267 0.0 0.0
                                -10.142107 5.427589 0.0 0.0 -1.4244894 -0.3541945 0.0 0.0 -9.818005 1.4324416
                                0.0 0.0 -117.63888 -2.9590907 0.0 0.0 -10.258353 0.13856244 0.0 0.0 -87.30082
                                -52.46929 0.0 0.0 -11.443262 5.004013 0.0 0.0 -82.791016 -23.521553 0.0 0.0
                                -12.77488 -0.78915024 0.0 0.0 -1.2283149 -0.70455754 0.0 0.0 -931.4792
                                -657.2588 0.0 0.0 -12.959441 -0.34617049 0.0 0.0 -0.89850503 -1.1769458 0.0
                                0.0 -1.4378489 -0.2674691 0.0 0.0 -5.475398 -8.73783 0.0 0.0 -1.3872082
                                -0.43374118 0.0 0.0 -1.2529024 -0.559002 0.0 0.0 -118.107605 -17.341166 0.0
                                0.0 -1.3281393 0.4772323 0.0 0.0 -118.42486 -20.203173 0.0 0.0 -72.76837
                                -4.802829 0.0 0.0 -109.465935 13.408704 0.0 0.0 -12.652552 2.2884455 0.0 0.0
                                -116.62927 -27.267935 0.0 0.0 -917.3832 150.53743 0.0 0.0 -1.5006238
                                0.28305182 0.0 0.0 -92.27869 30.423845 0.0 0.0 -12.388453 -1.3780944 0.0 0.0
                                -109.76931 -11.508991 0.0 0.0 -1.4842246 -0.13818456 0.0 0.0 -1.1302754
                                -0.7932388 0.0 0.0 -10.283291 -1.9817537 0.0 0.0 -95.617386 -16.71919 0.0 0.0
                                -7.648072 -9.121704 0.0 0.0 -97.12954 -16.040274 0.0 0.0 -78.9551 -77.93033
                                0.0 0.0 -88.008865 -67.48437 0.0 0.0 -1.4176422 -0.13834926 0.0 0.0 -96.05548
                                -19.477768 0.0 0.0 -114.64908 -3.8615954 0.0 0.0 -11.752721 4.495176 0.0 0.0
                                -10.930633 -0.23553604 0.0 0.0 -1.2925209 -0.62554085 0.0 0.0 -10.461518
                                0.42192504 0.0 0.0 -69.68719 -68.32404 0.0 0.0 -1.1061826 -0.477879 0.0 0.0
                                -15.640211 -4.3252907 0.0 0.0 -10.623878 -0.51484865 0.0 0.0 -1.4139
                                0.0052014887 0.0 0.0 -1.3642207 -0.51451397 0.0 0.0 -13.737083 0.91554075 0.0
                                0.0 -11.174838 2.7790682 0.0 0.0 -97.7943 -6.1557612 0.0 0.0 -1.3639866
                                0.1436241 0.0 0.0 -892.7265 -403.08337 0.0 0.0 -105.75995 -25.372858 0.0 0.0
                                -11.917437 -1.9211719 0.0 0.0 -102.97973 -41.707336 0.0 0.0 -14.424711
                                1.4497195 0.0 0.0 -1.324281 -0.06712225 0.0 0.0 -103.04148 -31.875765 0.0 0.0
                                -685.7842 -663.7583 0.0 0.0 -15.982347 -6.9357514 0.0 0.0 -1.3257275
                                -0.24493879 0.0 0.0 -11.3973 1.3410947 0.0 0.0 -1.2596742 -0.3765852 0.0 0.0
                                -0.9318729 0.22733906 0.0 0.0 -112.26861 -3.8829405 0.0 0.0 -12.676008
                                -5.5583677 0.0 0.0 -8.900649 -7.1369805 0.0 0.0 -104.92024 -69.51895 0.0 0.0
                                -1.3777289 -0.19410673 0.0 0.0 -1.3627931 -0.7800026 0.0 0.0 -108.36086
                                6.674376 0.0 0.0 -8.841463 -6.776337 0.0 0.0 -1.4696518 -0.014897194 0.0 0.0
                                -10.8502445 -2.1592321 0.0 0.0 -12.674036 -4.9073358 0.0 0.0 -11.219297
                                -1.9804956 0.0 0.0 -12.424353 -0.42289156 0.0 0.0 -1.2334552 -0.8366803 0.0
                                0.0 -1.3953615 -0.30343786 0.0 0.0 -81.72647 48.0798 0.0 0.0 -111.8372
                                10.860203 0.0 0.0 -103.73659 33.835503 0.0 0.0 -1.358972 -0.5762304 0.0 0.0
                                -1.406275 -0.4932403 0.0 0.0 -1.392468 -0.024313316 0.0 0.0 -9.79301
                                -6.4455914 0.0 0.0 -11.072202 -0.5748175 0.0 0.0 -1.4377564 0.07459962 0.0
                                0.0 -0.9717619 -1.0439613 0.0 0.0 -11.390968 -6.276591 0.0 0.0 -0.7939052
                                -1.183615 0.0 0.0 -1.3477648 0.19461197 0.0 0.0 -1.2060782 -0.31099212 0.0
                                0.0 -1.1129524 -0.3969292 0.0 0.0 -9.870409 5.759536 0.0 0.0 -1.2592587
                                0.67078483 0.0 0.0 -136.79697 4.3437896 0.0 0.0 -1.430685 -0.2777031 0.0 0.0
                                -1.2192328 0.4439342 0.0 0.0 -100.858864 42.72 0.0 0.0 -10.193401 -6.7879844
                                0.0 0.0 -11.515011 2.661245 0.0 0.0 -11.716915 -1.6862663 0.0 0.0 -0.9341139
                                -0.9029803 0.0 0.0 -82.04133 -95.86307 0.0 0.0 -1.3619772 0.28292286 0.0 0.0
                                -1.3765461 0.016279744 0.0 0.0 -0.9344305 -0.8759506 0.0 0.0 -0.8613928
                                -1.165761 0.0 0.0 -104.436195 49.381573 0.0 0.0 -12.431079 2.4270914 0.0 0.0
                                -11.528823 -2.1672726 0.0 0.0 -1.0984228 -0.9048464 0.0 0.0 -103.57024
                                -10.575328 0.0 0.0 -109.40248 -1.2568777 0.0 0.0 -1.4410506 -0.29798618 0.0
                                0.0 -1.0255847 -0.8666642 0.0 0.0 -1.4125111 -0.36259678 0.0 0.0 -1.3845954
                                0.474779 0.0 0.0 -1.3809154 -0.29266486 0.0 0.0 -9.938708 -3.4659748 0.0 0.0
                                -10.748562 -5.093313 0.0 0.0 -1.316563 0.39436162 0.0 0.0 -1.4082716
                                -0.47509986 0.0 0.0 -10.258734 -1.935348 0.0 0.0 -130.02222 22.383463 0.0 0.0
                                -1.4782728 -0.30756876 0.0 0.0 -97.28595 31.131191 0.0 0.0 -7.8119435
                                -10.431689 0.0 0.0 -130.42047 -34.637768 0.0 0.0 -1.2177942 -0.8432208 0.0
                                0.0 -10.978057 -4.9302406 0.0 0.0 -1.3451612 0.44582832 0.0 0.0 -92.82483
                                41.944855 0.0 0.0 -11.789157 1.7099309 0.0 0.0 -10.267799 -4.5673666 0.0 0.0
                                -14.410987 -3.6898549 0.0 0.0 -89.970924 -50.822437 0.0 0.0 -10.5053425
                                -1.1500597 0.0 0.0 -1.4346938 -0.11072925 0.0 0.0 -1.4659523 -0.2130708 0.0
                                0.0 -22.051287 -0.25795597 0.0 0.0 -106.39717 -8.351604 0.0 0.0 -1.4521425
                                -0.04021015 0.0 0.0 -9.126617 -9.3658495 0.0 0.0 -1.0588502 0.9869886 0.0 0.0
                                -98.97166 -26.670866 0.0 0.0 -83.23247 -70.81517 0.0 0.0 -1277.554 442.41016
                                0.0 0.0 -132.05257 63.736706 0.0 0.0 -1.2603242 -0.4547673 0.0 0.0 -98.14059
                                -40.119736 0.0 0.0 -9.090569 -5.2611446 0.0 0.0 -7.9589086 -7.4771214 0.0 0.0
                                -99.0369 -48.384956 0.0 0.0 -10.2659235 -0.91910905 0.0 0.0 -10.731872
                                -1.7829767 0.0 0.0 -9.802545 -6.3410664 0.0 0.0 -1.3607113 -0.25962973 0.0
                                0.0 -999.8343 -343.67422 0.0 0.0 -11.164643 7.1837454 0.0 0.0 -12.914104
                                1.594738 0.0 0.0 -1.3695091 0.09217348 0.0 0.0 -1.4368484 -0.085682765 0.0
                                0.0 -88.432076 -66.337265 0.0 0.0 -1.4098102 -0.47461084 0.0 0.0 -14.254757
                                -0.8355399 0.0 0.0 -8.257211 1.9661652 0.0 0.0 -1019.8795 -302.90732 0.0 0.0
                                -108.56734 -34.62742 0.0 0.0 -1.323674 -0.589879 0.0 0.0 -1.1450812
                                -0.63231516 0.0 0.0 -10.425084 -2.0687501 0.0 0.0 -160.24527 24.482882 0.0
                                0.0 -1.418094 -0.23562059 0.0 0.0 -1.2944267 -0.596681 0.0 0.0 -12.439819
                                -1.4862766 0.0 0.0 -13.108993 -1.6455433 0.0 0.0 -99.09513 31.500105 0.0 0.0
                                -10.741701 -0.10015747 0.0 0.0 -104.86064 -4.546788 0.0 0.0 -1.3648046
                                -0.18602473 0.0 0.0 -103.16516 -59.2895 0.0 0.0 -90.96872 59.46565 0.0 0.0
                                -10.229226 -1.7099048 0.0 0.0 -1.2940658 0.32750982 0.0 0.0 -10.89222
                                -1.6305885 0.0 0.0 -114.64701 8.382145 0.0 0.0 -115.30692 30.384748 0.0 0.0
                                -12.932613 -6.412913 0.0 0.0 -1.4154971 -0.2688585 0.0 0.0 -10.4660225
                                -6.025671 0.0 0.0 -1.4010655 0.20056455 0.0 0.0 -218.74861 24.390991 0.0 0.0
                                -122.609215 69.5351 0.0 0.0 -924.26276 -497.9004 0.0 0.0 -1.400788
                                -0.09058077 0.0 0.0 -117.07818 -17.157919 0.0 0.0 -1.0832305 -0.9853271 0.0
                                0.0 -1.4186201 -0.20194599 0.0 0.0 -89.63809 57.384247 0.0 0.0 -112.29696
                                -10.541107 0.0 0.0 -105.12782 -2.048694 0.0 0.0 -1.41162 -0.42667833 0.0 0.0
                                -102.46983 13.230214 0.0 0.0 -10.064565 7.5143976 0.0 0.0 -1.4161487
                                0.32818508 0.0 0.0 -103.11402 -57.75836 0.0 0.0 -1.4257859 -0.068251014 0.0
                                0.0 -14.169601 -6.001319 0.0 0.0 -106.08766 13.420417 0.0 0.0 -1.3867598
                                0.4500562 0.0 0.0 -11.965764 2.0310454 0.0 0.0 -10.090586 -4.6739683 0.0 0.0
                                -1.4528495 -0.19110104 0.0 0.0 -1367.0712 -168.28667 0.0 0.0 -113.456635
                                -7.7042375 0.0 0.0 -1.4203861 0.49865648 0.0 0.0 -90.81208 -79.79282 0.0 0.0
                                -11.182295 4.605715 0.0 0.0 -10.045717 8.812475 0.0 0.0 -11.09196 1.1223407
                                0.0 0.0 -10.850119 2.353228 0.0 0.0 -9.384235 3.4164212 0.0 0.0 -1.4812235
                                -0.06791032 0.0 0.0 -152.83301 1.5408138 0.0 0.0 -11.78197 2.6609263 0.0 0.0
                                -9.397031 6.507342 0.0 0.0 -118.82192 23.495728 0.0 0.0 -10.425666 -8.9842005
                                0.0 0.0 -13.04655 2.7341518 0.0 0.0 -1.1801469 -0.83219695 0.0 0.0 -1.450045
                                -0.16631758 0.0 0.0 -105.19855 17.224512 0.0 0.0 -171.0113 -33.61826 0.0 0.0
                                -11.398602 4.243952 0.0 0.0 -113.19122 -88.8829 0.0 0.0 -12.471088
                                -0.36241895 0.0 0.0 -0.9025338 -0.42380762 0.0 0.0 -10.212095 3.5604753 0.0
                                0.0 -8.977552 -7.7614446 0.0 0.0 -1.4614532 0.101820245 0.0 0.0 -113.07755
                                -58.21927 0.0 0.0 -11.842915 -5.478832 0.0 0.0 -1.2962267 -0.3512878 0.0 0.0
                                -9.250184 9.532519 0.0 0.0 -1.4384075 0.1453901 0.0 0.0 -1.3802423 0.41752854
                                0.0 0.0 -1.520545 -0.0064075748 0.0 0.0 -9.264437 6.0569363 0.0 0.0
                                -128.69595 -41.842796 0.0 0.0 -1.1629357 -0.723374 0.0 0.0 -1068.0979
                                -360.96133 0.0 0.0 -1.274158 0.71579874 0.0 0.0 -10.792561 -5.820917 0.0 0.0
                                -12.153922 0.5284883 0.0 0.0 -1.2419972 -0.5963886 0.0 0.0 -13.539733
                                0.93097216 0.0 0.0 -10.586152 -6.063603 0.0 0.0 -118.33107 -26.372028 0.0 0.0
                                -12.755851 4.6807804 0.0 0.0 -11.57069 7.3527446 0.0 0.0 -1.5883296
                                -0.5321403 0.0 0.0 -0.9712555 -1.10026 0.0 0.0 -110.7734 -22.821056 0.0 0.0
                                -12.835717 -1.9988965 0.0 0.0 -115.302986 -90.47919 0.0 0.0 -156.29 -4.429165
                                0.0 0.0 -7.767533 -10.027045 0.0 0.0 -11.791429 3.3641646 0.0 0.0 -1.4420978
                                -0.14885312 0.0 0.0 -1.3947086 -0.27101558 0.0 0.0 -12.052977 1.417108 0.0
                                0.0 -1.4613025 -0.5846726 0.0 0.0 -1071.625 500.03714 0.0 0.0 -1.4727694
                                -0.22701174 0.0 0.0 -112.26087 -61.648144 0.0 0.0 -108.87036 50.497982 0.0
                                0.0 -1.2895397 0.27172807 0.0 0.0 -1.4791005 -0.10777962 0.0 0.0 -110.488556
                                -51.556736 0.0 0.0 -108.22487 23.992289 0.0 0.0 -11.064868 6.159309 0.0 0.0
                                -1.3331268 0.40243486 0.0 0.0 -13.795979 4.1438565 0.0 0.0 -1.2645674
                                -0.36704588 0.0 0.0 -11.263542 0.7687932 0.0 0.0 -1.4538854 0.15976724 0.0
                                0.0 -124.60045 2.2978473 0.0 0.0 -1.3969766 -0.22907355 0.0 0.0 -109.0124
                                -29.935863 0.0 0.0 -1.108579 -0.76027703 0.0 0.0 -1.3672786 -0.5511608 0.0
                                0.0 -11.448303 -5.0241523 0.0 0.0 -1.4817472 -0.12812148 0.0 0.0 -1.4700192
                                -0.14534885 0.0 0.0 -1.2358717 -0.6187019 0.0 0.0 -1.3809528 0.23368913 0.0
                                0.0 -9.650892 -5.8165774 0.0 0.0 -1.4162362 -0.3931849 0.0 0.0 -1.4056035
                                0.33613157 0.0 0.0 -13.166641 -0.15698834 0.0 0.0 -9.576414 7.5557127 0.0 0.0
                                -1.3943117 0.3745955 0.0 0.0 -124.93079 -14.635728 0.0 0.0 -10.121399
                                0.80330074 0.0 0.0 -1573.54 -8.1668 0.0 0.0 -118.976036 -52.34738 0.0 0.0
                                -10.282455 3.9056804 0.0 0.0 -1.4195744 0.13475591 0.0 0.0 -804.1877
                                -800.52423 0.0 0.0 -104.738174 -70.15707 0.0 0.0 -1135.3009 45.697514 0.0 0.0
                                -12.042143 4.792298 0.0 0.0 -1035.6896 470.94788 0.0 0.0 -1.4740375
                                0.19459619 0.0 0.0 -139.15643 -6.057842 0.0 0.0 -1.3361946 0.22777867 0.0 0.0
                                -11.335961 5.093409 0.0 0.0 -1.4277837 -0.3806298 0.0 0.0 -1.1445838
                                0.0831343 0.0 0.0 -114.02358 -37.21936 0.0 0.0 -121.96361 93.15342 0.0 0.0
                                -105.37492 -70.41673 0.0 0.0 -111.794716 -50.525257 0.0 0.0 -1183.3259
                                56.833145 0.0 0.0 -1.4604306 -0.041255508 0.0 0.0 -128.3943 -77.279686 0.0
                                0.0 -1.3027344 -0.20227987 0.0 0.0 -10.652039 4.653316 0.0 0.0 -1.4551798
                                0.2939203 0.0 0.0 -1.4105973 -0.030169278 0.0 0.0 -1.4628313 0.04191912 0.0
                                0.0 -1.4605194 0.0017723516 0.0 0.0 -9.5371275 -2.868112 0.0 0.0 -104.23319
                                -65.81959 0.0 0.0 -10.127833 6.3051267 0.0 0.0 -1.4127492 -0.34120834 0.0 0.0
                                -1.3610762 0.10175915 0.0 0.0 -13.834206 -0.106758595 0.0 0.0 -1.3035284
                                0.62836903 0.0 0.0 -1.4266319 -0.030896166 0.0 0.0 -1.2034009 0.8500668 0.0
                                0.0 -148.04344 -102.06785 0.0 0.0 -11.32548 0.81082726 0.0 0.0 -1.3234023
                                -0.46199942 0.0 0.0 -1.3984982 0.062496275 0.0 0.0 -10.674756 -7.0797467 0.0
                                0.0 -10.178918 -6.992762 0.0 0.0 -1.0441041 -0.6448585 0.0 0.0 -1.225326
                                0.5417964 0.0 0.0 -10.870884 -1.0203365 0.0 0.0 -1.2397509 0.39481014 0.0 0.0
                                -1.1105138 -0.7474188 0.0 0.0 -14.0041275 -3.1533084 0.0 0.0 -1.3145486
                                0.22653091 0.0 0.0 -11.946461 -4.4650197 0.0 0.0 -9.5671215 -7.3780866 0.0
                                0.0 -12.322645 -0.112574436 0.0 0.0 -12.932352 -0.3871423 0.0 0.0 -11.193981
                                5.070875 0.0 0.0 -1.3745352 -0.33207494 0.0 0.0 -100.38181 -87.79888 0.0 0.0
                                -1.3166981 -0.22760177 0.0 0.0 -12.367674 0.93870896 0.0 0.0 -12.895479
                                -3.230827 0.0 0.0 -10.291026 -3.7572453 0.0 0.0 -1.2732835 -0.40258145 0.0
                                0.0 -1.1353273 0.49030158 0.0 0.0 -105.527084 -50.628147 0.0 0.0 -1.2870486
                                -0.07055967 0.0 0.0 -115.879166 35.301807 0.0 0.0 -1.229798 -0.19550836 0.0
                                0.0 -1.2667199 -0.41373035 0.0 0.0 -11.722515 -4.6416135 0.0 0.0 -9.351116
                                5.823613 0.0 0.0 -10.882962 0.027655484 0.0 0.0 -99.26217 -55.222324 0.0 0.0
                                -97.97789 57.56851 0.0 0.0 -1.2804292 -0.39215502 0.0 0.0 -1.2526422
                                0.32289493 0.0 0.0 -11.257765 -7.3666883 0.0 0.0 -132.88649 21.684671 0.0 0.0
                                -10.491338 -6.5769563 0.0 0.0 -0.43851322 -0.2600664 0.0 0.0 -1.199492
                                0.30999517 0.0 0.0 -1.1387038 -0.6560044 0.0 0.0 -11.236894 2.0565298 0.0 0.0
                                -13.598772 -2.948559 0.0 0.0 -13.572083 7.303678 0.0 0.0 -10.72758 6.6566052
                                0.0 0.0 -11.000359 -1.1161683 0.0 0.0 -19.471045 7.1668057 0.0 0.0 -1.1815957
                                -0.63049644 0.0 0.0 -1.33939 -0.032817993 0.0 0.0 -1.2707274 -0.3232573 0.0
                                0.0 -1.3190317 -0.0655454 0.0 0.0 -1.2522172 0.45707247 0.0 0.0 -1.2018571
                                -0.59518784 0.0 0.0 -1.1555943 -0.6188591 0.0 0.0 -11.567963 4.724486 0.0 0.0
                                -10.907346 3.4978838 0.0 0.0 -103.9103 73.1334 0.0 0.0 -1.2547766 -0.46234247
                                0.0 0.0 -101.60694 -61.71747 0.0 0.0 -120.219986 19.579823 0.0 0.0 -1.2434554
                                -0.5003819 0.0 0.0 -12.503716 -2.7158456 0.0 0.0 -12.20388 -1.615098 0.0 0.0
                                -1.2990395 0.2543389 0.0 0.0 -112.10196 40.51629 0.0 0.0 -12.541552
                                -3.2931287 0.0 0.0 -12.236723 2.70958 0.0 0.0 -1.2842319 -0.2797481 0.0 0.0
                                -226.96341 7.123201 0.0 0.0 -1.2031332 0.08327972 0.0 0.0 -11.856447
                                -2.2888846 0.0 0.0 -1.276426 0.3875488 0.0 0.0 -11.398559 4.9700933 0.0 0.0
                                -1.0981704 -0.61328447 0.0 0.0 -118.0941 19.71191 0.0 0.0 -9.397138 -6.620605
                                0.0 0.0 -1.3265722 0.09802428 0.0 0.0 -1.3304784 -0.16784045 0.0 0.0
                                -19.355627 8.184459 0.0 0.0 -1.314578 -0.17429549 0.0 0.0 -1.3549229
                                -0.40186077 0.0 0.0 -1.2917039 0.2758047 0.0 0.0 -113.64003 -23.979473 0.0
                                0.0 -1.3265576 0.09076628 0.0 0.0 -0.8523163 -1.0181594 0.0 0.0 -11.634057
                                4.00233 0.0 0.0 -1.4160212 -0.27236125 0.0 0.0 -162.92006 92.394005 0.0 0.0
                                -1.1827986 -0.8020654 0.0 0.0 -1.1275489 0.69630283 0.0 0.0 -1.2579013
                                -0.44764933 0.0 0.0 -1.3354796 -0.017800398 0.0 0.0 -1.1148214 -0.3525178 0.0
                                0.0 -10.317826 -8.802282 0.0 0.0 -1.0018806 0.508944 0.0 0.0 -10.8498
                                6.363403 0.0 0.0 -1.2936968 0.09483071 0.0 0.0 -1.2065686 -0.5588393 0.0 0.0
                                -10.937559 11.188179 0.0 0.0 -1.2926162 0.026613362 0.0 0.0 -17.044245
                                -6.683651 0.0 0.0 -114.72636 38.962307 0.0 0.0 -12.614518 0.05794671 0.0 0.0
                                -1.0530446 -0.03132724 0.0 0.0 -10.338693 -3.2535858 0.0 0.0 -129.88446
                                4.047027 0.0 0.0 -14.259714 -7.7626476 0.0 0.0 -1.0525287 -0.18542907 0.0 0.0
                                -1.2944615 -0.19564223 0.0 0.0 -1.3137089 -0.09445856 0.0 0.0 -1.0525873
                                0.4984082 0.0 0.0 -1.3974532 -0.15097919 0.0 0.0 -11.528696 0.29084474 0.0
                                0.0 -1.0840555 -0.41219217 0.0 0.0 -1.0219151 0.6797932 0.0 0.0 -1.061507
                                -0.6703481 0.0 0.0 -1.31825 -0.03392008 0.0 0.0 -1.0581381 -0.07299401 0.0
                                0.0 -1.2977954 -0.07304722 0.0 0.0 -111.223404 -50.431267 0.0 0.0 -1.27609
                                0.29839447 0.0 0.0 -1.2634966 -0.44162953 0.0 0.0 -1.8634386 -0.09836769 0.0
                                0.0 -0.9121667 -0.16115671 0.0 0.0 -11.963958 -1.3087225 0.0 0.0 -1.337813
                                0.073170796 0.0 0.0 -120.60574 -21.444845 0.0 0.0 -1.0847975 -0.6758289 0.0
                                0.0 -1.2629586 -0.31545806 0.0 0.0 -11.1749325 -1.3857545 0.0 0.0 -0.9603614
                                -0.91025525 0.0 0.0 -12.275389 -2.8328128 0.0 0.0 -1.321137 -0.20852025 0.0
                                0.0 -12.364375 -1.6373998 0.0 0.0 -1.0662155 -0.97380906 0.0 0.0 -1.3312868
                                0.045011986 0.0 0.0 -1.2975359 0.14336854 0.0 0.0 -1.1439112 -0.70084846 0.0
                                0.0 -1.2973343 0.14575419 0.0 0.0 -12.034581 -0.06543097 0.0 0.0 -12.170025
                                -4.3670716 0.0 0.0 -1.0083221 -0.8873638 0.0 0.0 -1.2829757 -0.30295146 0.0
                                0.0 -13.600341 -4.1999087 0.0 0.0 -7.2993464 -8.573049 0.0 0.0 -1.1232641
                                0.5590643 0.0 0.0 -0.9808567 -0.89510065 0.0 0.0 -138.83582 29.304962 0.0 0.0
                                -1.1491164 0.66684604 0.0 0.0 -10.509137 -7.1097403 0.0 0.0 -11.389176
                                -6.3753047 0.0 0.0 -1.2815626 -0.47417516 0.0 0.0 -18.428555 -9.868732 0.0
                                0.0 -11.222066 -3.8794682 0.0 0.0 -12.377581 1.9827468 0.0 0.0 -121.886055
                                -23.102972 0.0 0.0 -13.567214 0.6477005 0.0 0.0 -1.2229685 -0.39501548 0.0
                                0.0 -117.73572 -39.60348 0.0 0.0 -1.3092022 -0.02918331 0.0 0.0 -132.37369
                                -15.026973 0.0 0.0 -10.979965 2.5660527 0.0 0.0 -1.2502197 -0.41905266 0.0
                                0.0 -1.2883781 0.2577395 0.0 0.0 -132.498 -16.028366 0.0 0.0 -1.2953964
                                0.17984332 0.0 0.0 -134.67928 73.476105 0.0 0.0 -1.4357663 0.17852667 0.0 0.0
                                -10.880205 -3.1411083 0.0 0.0 -11.1988325 -7.0152783 0.0 0.0 -12.324516
                                -3.447245 0.0 0.0 -1.3149438 -0.18170634 0.0 0.0 -1.3747923 -0.3166349 0.0
                                0.0 -11.74541 0.46273807 0.0 0.0 -115.71881 34.73762 0.0 0.0 -1.2899234
                                -0.037739627 0.0 0.0 -12.308539 3.5915115 0.0 0.0 -1.2813231 -0.28017476 0.0
                                0.0 -12.777879 0.9572216 0.0 0.0 -124.14594 -37.830208 0.0 0.0 -1.2190478
                                -0.5402331 0.0 0.0 -1.2501596 0.4780853 0.0 0.0 -122.638275 -26.726358 0.0
                                0.0 -1.1922216 -0.44926196 0.0 0.0 -1.3077075 -0.20181182 0.0 0.0 -12.583284
                                -1.201522 0.0 0.0 -11.35296 -0.29181695 0.0 0.0 -11.263416 4.9970083 0.0 0.0
                                -1.2523482 0.19511265 0.0 0.0 -9.89478 7.973619 0.0 0.0 -125.41545 -61.792683
                                0.0 0.0 -85.19699 -86.89703 0.0 0.0 -1.2487001 -0.41456044 0.0 0.0 -154.02364
                                -20.797058 0.0 0.0 -10.044348 6.2143397 0.0 0.0 -104.896 -77.9672 0.0 0.0
                                -0.8298218 0.1519515 0.0 0.0 -1.3063928 0.3321914 0.0 0.0 -1.2903671
                                -0.07222383 0.0 0.0 -12.579837 0.9733982 0.0 0.0 -11.531918 -2.5704165 0.0
                                0.0 -11.100782 -2.7258997 0.0 0.0 -12.762955 -1.0022795 0.0 0.0 -121.96774
                                -9.196754 0.0 0.0 -24.458975 6.6237054 0.0 0.0 -1.3281366 0.07688305 0.0 0.0
                                -1.240106 0.179705 0.0 0.0 -1.3356831 0.025172183 0.0 0.0 -1.2096874
                                0.32118255 0.0 0.0 -12.558105 -1.8972732 0.0 0.0 -129.53537 -22.995413 0.0
                                0.0 -1.1109539 0.68471444 0.0 0.0 -1.3182452 0.08765585 0.0 0.0 -1.1275085
                                -0.33399612 0.0 0.0 -21.036882 2.3033276 0.0 0.0 -0.9123285 -0.84665143 0.0
                                0.0 -1.2270238 0.19092654 0.0 0.0 -1.2593611 -0.41316292 0.0 0.0 -11.128842
                                6.9381495 0.0 0.0 -162.74907 -8.591052 0.0 0.0 -1.2278808 0.21392713 0.0 0.0
                                -12.680737 2.1180542 0.0 0.0 -1.1702763 0.5279653 0.0 0.0 -1.1866657
                                -0.56460613 0.0 0.0 -1.2343324 -0.44213274 0.0 0.0 -12.624345 -1.4377253 0.0
                                0.0 -9.983885 5.4279017 0.0 0.0 -119.87032 -44.805744 0.0 0.0 -135.14029
                                24.464865 0.0 0.0 -115.728806 43.57609 0.0 0.0 -1.3152966 -0.12498098 0.0 0.0
                                -9.978757 -8.41908 0.0 0.0 -10.46101 4.783947 0.0 0.0 -13.798893 6.068164 0.0
                                0.0 -1.3602374 0.7096721 0.0 0.0 -12.854566 -1.856893 0.0 0.0 -11.816273
                                -1.4982917 0.0 0.0 -12.670078 -1.9016188 0.0 0.0 -111.01359 81.88731 0.0 0.0
                                -122.0857 -22.715458 0.0 0.0 -1.3146493 -0.010241024 0.0 0.0 -9.135536
                                -8.291164 0.0 0.0 -1.2903651 0.036515534 0.0 0.0 -12.168134 -4.5971003 0.0
                                0.0 -0.9762848 -0.6491696 0.0 0.0 -9.157183 6.234979 0.0 0.0 -1.3169659
                                -0.13162044 0.0 0.0 -0.85542655 -0.1326516 0.0 0.0 -1.2750424 0.3232802 0.0
                                0.0 -12.151508 2.295966 0.0 0.0 -12.735825 -4.6685123 0.0 0.0 -1.2364671
                                0.47896704 0.0 0.0 -1.1489373 -0.6649926 0.0 0.0 -1.1857266 0.6266149 0.0 0.0
                                -1.3856899 -0.65640235 0.0 0.0 -10.8350935 -7.166869 0.0 0.0 -13.047566
                                -0.3667743 0.0 0.0 -10.436332 -5.1190104 0.0 0.0 -1.2909044 -0.6068005 0.0
                                0.0 -1.4858279 -0.10830398 0.0 0.0 -1.3612165 0.4071479 0.0 0.0 -1.3248968
                                -0.20887342 0.0 0.0 -13.714078 3.8707032 0.0 0.0 -15.429641 4.450352 0.0 0.0
                                -77.88733 -98.43311 0.0 0.0 -1.255479 -0.43081877 0.0 0.0 -1036.9203
                                -1056.406 0.0 0.0 -189.32121 -82.15657 0.0 0.0 -120.81023 34.967476 0.0 0.0
                                -1.3844975 -0.40976375 0.0 0.0 -1.3259093 0.60551155 0.0 0.0 -1.4723016
                                -0.04510878 0.0 0.0 -19.78524 -0.2980909 0.0 0.0 -1.3870645 -0.3913494 0.0
                                0.0 -1.4083569 -0.43212602 0.0 0.0 -12.125008 2.4599235 0.0 0.0 -1.4060225
                                -0.39834177 0.0 0.0 -1.3610984 -0.47536448 0.0 0.0 -13.044454 0.6876712 0.0
                                0.0 -1123.1904 -466.0618 0.0 0.0 -1374.7803 212.95578 0.0 0.0 -1.3265376
                                -0.29310814 0.0 0.0 -11.373157 -6.477069 0.0 0.0 -0.83296585 -1.1777276 0.0
                                0.0 -121.07197 -37.096226 0.0 0.0 -1.3497806 0.26918465 0.0 0.0 -11.488233
                                -6.5864835 0.0 0.0 -11.719626 1.2486883 0.0 0.0 -125.452774 18.313963 0.0 0.0
                                -10.334537 -6.0196986 0.0 0.0 -1.3955469 -0.22724065 0.0 0.0 -1.3295791
                                -0.6564396 0.0 0.0 -1.4428612 0.09249578 0.0 0.0 -147.22182 -55.43272 0.0 0.0
                                -1.41117 0.33574224 0.0 0.0 -13.808511 -4.562951 0.0 0.0 -13.66023 2.6728866
                                0.0 0.0 -1.325787 -0.50006884 0.0 0.0 -1.3795477 -0.47796395 0.0 0.0
                                -0.8665764 -0.64326864 0.0 0.0 -1563.2294 -118.72089 0.0 0.0 -11.185342
                                -8.369641 0.0 0.0 -1.4189004 -0.31201023 0.0 0.0 -1.362672 -0.23653322 0.0
                                0.0 -1.2576538 -0.71922237 0.0 0.0 -1.3712647 0.163876 0.0 0.0 -131.42046
                                -18.398697 0.0 0.0 -1.4274997 0.0084043145 0.0 0.0 -2.2653449 -0.12303388 0.0
                                0.0 -1.3610591 0.43758002 0.0 0.0 -1.4909244 0.006516641 0.0 0.0 -14.412161
                                0.7809804 0.0 0.0 -1.3749607 -0.34703383 0.0 0.0 -14.473289 1.9603621 0.0 0.0
                                -122.75936 35.592537 0.0 0.0 -20.182354 -4.5200086 0.0 0.0 -13.872314
                                4.799102 0.0 0.0 -14.099777 -4.458642 0.0 0.0 -1251.8406 679.55725 0.0 0.0
                                -1.3961477 0.21798871 0.0 0.0 -1.3812485 -0.11777809 0.0 0.0 -12.759917
                                -5.728895 0.0 0.0 -1.0690697 -0.9933252 0.0 0.0 -137.99496 -9.049887 0.0 0.0
                                -140.40193 -44.121777 0.0 0.0 -0.5516519 -0.5782686 0.0 0.0 -1.2812145
                                -0.53763247 0.0 0.0 -1.4133594 -0.118927 0.0 0.0 -1.2935675 0.17028263 0.0
                                0.0 -118.87477 -61.349274 0.0 0.0 -14.53938 -1.9269568 0.0 0.0 -18.968084
                                -4.301661 0.0 0.0 -135.14366 -31.70667 0.0 0.0 -1.2548828 -0.7197207 0.0 0.0
                                -1.3794004 0.7018458 0.0 0.0 -11.081705 -5.3811827 0.0 0.0 -10.03144
                                -8.530195 0.0 0.0 -13.018628 -6.9603477 0.0 0.0 -141.11473 40.397503 0.0 0.0
                                -1.3986627 0.24588151 0.0 0.0 -1.4471062 0.12056751 0.0 0.0 -1.4677341
                                -0.15649487 0.0 0.0 -1.3407356 -0.62816846 0.0 0.0 -14.667408 -2.7935653 0.0
                                0.0 -14.96704 -6.1860027 0.0 0.0 -9.021412 7.899742 0.0 0.0 -1.4607576
                                -0.05449738 0.0 0.0 -1.1085883 -0.82843405 0.0 0.0 -13.369621 0.6724123 0.0
                                0.0 -1.1767697 -0.8370005 0.0 0.0 -95.68493 -87.98115 0.0 0.0 -14.569019
                                3.2326543 0.0 0.0 -1.2864344 0.2877359 0.0 0.0 -0.9379936 0.7120199 0.0 0.0
                                -1.3595494 -0.51897144 0.0 0.0 -1.4609182 0.0192402 0.0 0.0 -1.1851411
                                -0.46519747 0.0 0.0 -129.16553 -18.850483 0.0 0.0 -14.93069 -3.15986 0.0 0.0
                                -136.78348 63.74385 0.0 0.0 -140.25414 21.569052 0.0 0.0 -12.681819 8.296907
                                0.0 0.0 -128.02919 -58.13127 0.0 0.0 -11.937286 -4.733651 0.0 0.0 -150.00432
                                -19.125872 0.0 0.0 -13.861636 -2.3613484 0.0 0.0 -15.8963375 0.025434637 0.0
                                0.0 -1.4815055 0.11006132 0.0 0.0 -2118.1003 -1023.20825 0.0 0.0 -137.03427
                                -33.272034 0.0 0.0 -141.46774 -42.299618 0.0 0.0 -179.24637 78.76424 0.0 0.0
                                -1.460879 0.08925692 0.0 0.0 -1.332238 0.07893343 0.0 0.0 -13.034203
                                -3.3585677 0.0 0.0 -1.3205001 0.18081345 0.0 0.0 -1.3890975 -0.16448478 0.0
                                0.0 -1.4163486 0.16013536 0.0 0.0 -12.734351 1.6089633 0.0 0.0 -1.4552169
                                -0.22103478 0.0 0.0 -12.329966 -4.531739 0.0 0.0 -1465.451 -760.64215 0.0 0.0
                                -13.984957 -2.216334 0.0 0.0 -12.99157 -4.2931166 0.0 0.0 -161.62578 54.87431
                                0.0 0.0 -136.97746 -36.52761 0.0 0.0 -12.222377 -5.8205333 0.0 0.0 -142.9848
                                37.215824 0.0 0.0 -150.0973 9.938273 0.0 0.0 -1.5663083 -0.41794083 0.0 0.0
                                -122.79945 -49.179646 0.0 0.0 -109.58354 -90.821846 0.0 0.0 -132.96054
                                15.974845 0.0 0.0 -1412.9563 -629.4649 0.0 0.0 -1.3005066 0.013966933 0.0 0.0
                                -148.32149 -61.29205 0.0 0.0 -1.2181667 0.56487817 0.0 0.0 -15.07961
                                1.1940497 0.0 0.0 -1.3870177 0.026421886 0.0 0.0 -14.236958 -2.1340652 0.0
                                0.0 -1.3804955 -0.25085622 0.0 0.0 -1862.0724 113.95218 0.0 0.0 -1.4461391
                                -0.053500365 0.0 0.0 -1.4154053 -0.10321872 0.0 0.0 -1.339088 -0.28993645 0.0
                                0.0 -10.496204 -5.5229497 0.0 0.0 -13.426594 1.4930317 0.0 0.0 -12.896641
                                -4.2673826 0.0 0.0 -12.168289 6.058683 0.0 0.0 -13.197749 2.5061471 0.0 0.0
                                -136.23859 -31.476564 0.0 0.0 -133.3446 -5.192064 0.0 0.0 -1.3030106
                                -0.07212195 0.0 0.0 -138.10176 6.634632 0.0 0.0 -136.34727 -60.27108 0.0 0.0
                                -137.4836 -26.482246 0.0 0.0 -129.75005 -32.159805 0.0 0.0 -15.38977
                                7.1953382 0.0 0.0 -153.81822 -107.22644 0.0 0.0 -12.434206 -5.055204 0.0 0.0
                                -1.3987048 -0.32242954 0.0 0.0 -1.4103926 0.4048285 0.0 0.0 -1.388617
                                -0.33299583 0.0 0.0 -120.36948 58.870834 0.0 0.0 -13.845536 -1.0637093 0.0
                                0.0 -124.143654 62.904408 0.0 0.0 -1.4261216 -0.111641295 0.0 0.0 -138.57843
                                -64.19479 0.0 0.0 -1.3564172 -0.2643488 0.0 0.0 -133.7403 65.35494 0.0 0.0
                                -1709.1046 661.7514 0.0 0.0 -21.699402 -5.061122 0.0 0.0 -11.917021 6.4747624
                                0.0 0.0 -1.3003262 -0.506135 0.0 0.0 -1.2370763 -0.7577537 0.0 0.0 -13.340898
                                2.1481338 0.0 0.0 -1.373848 -0.47063854 0.0 0.0 -1.3857936 -0.039797924 0.0
                                0.0 -13.714591 -9.397183 0.0 0.0 -149.2275 29.522509 0.0 0.0 -1.1766473
                                0.8734781 0.0 0.0 -14.711676 2.7861598 0.0 0.0 -1.3208452 0.0735384 0.0 0.0
                                -1353.2345 -844.3643 0.0 0.0 -162.50044 94.59051 0.0 0.0 -121.51237 70.00408
                                0.0 0.0 -1.4366217 0.051881995 0.0 0.0 -1.7118728 -0.8046134 0.0 0.0
                                -1.2949831 0.47041276 0.0 0.0 -1.1721765 -0.8815284 0.0 0.0 -16.50429
                                4.248672 0.0 0.0 -13.234691 4.082909 0.0 0.0 -1.4120824 -0.18369232 0.0 0.0
                                -1.4691721 -0.19397064 0.0 0.0 -1524.4509 -945.4062 0.0 0.0 -1.4888501
                                -0.019903984 0.0 0.0 -148.7369 -43.049137 0.0 0.0 -13.393302 1.8123224 0.0
                                0.0 -155.32631 2.0822997 0.0 0.0 -145.9847 -42.117725 0.0 0.0 -1.3422204
                                0.08281483 0.0 0.0 -138.20735 -28.35432 0.0 0.0 -208.95142 44.945587 0.0 0.0
                                -133.76335 -32.04329 0.0 0.0 -253.4402 -31.91936 0.0 0.0 -133.36707
                                -27.584164 0.0 0.0 -1542.3815 -28.211159 0.0 0.0 -1.4499679 0.04543232 0.0
                                0.0 -1.0686723 -0.71786827 0.0 0.0 -12.96339 4.639873 0.0 0.0 -1.2277638
                                0.35175726 0.0 0.0 -151.81313 36.79128 0.0 0.0 -1.1905557 -0.861653 0.0 0.0
                                -187.3793 -35.761524 0.0 0.0 -14.01231 2.337309 0.0 0.0 -145.00172 -33.836697
                                0.0 0.0 -143.90475 -56.717037 0.0 0.0 -1.3601593 -0.36384255 0.0 0.0
                                -1.323675 -0.6259305 0.0 0.0 -1.3514324 -0.27091026 0.0 0.0 -12.463193
                                -7.809199 0.0 0.0 -139.95276 26.43731 0.0 0.0 -15.256174 1.6250653 0.0 0.0
                                -13.554523 -6.7960873 0.0 0.0 -13.682318 1.9762771 0.0 0.0 -1.3107096
                                -0.2264404 0.0 0.0 -125.76204 -55.60717 0.0 0.0 -160.17966 -46.247875 0.0 0.0
                                -1.3834845 0.21725813 0.0 0.0 -19.129139 -3.7477887 0.0 0.0 -12.548711
                                -2.0404375 0.0 0.0 -1.5157255 -0.072336815 0.0 0.0 -279.86426 6.546309 0.0
                                0.0 -1.4864708 0.08394987 0.0 0.0 -142.54112 -72.730965 0.0 0.0 -124.873085
                                -83.20836 0.0 0.0 -15.241539 0.5708928 0.0 0.0 -1.4413804 -0.015930936 0.0
                                0.0 -139.06744 9.483411 0.0 0.0 -1.4107797 0.18568079 0.0 0.0 -143.30821
                                -8.073087 0.0 0.0 -13.696382 -1.0864457 0.0 0.0 -14.915218 -2.5842857 0.0 0.0
                                -1155.0898 -1357.4259 0.0 0.0 -11.247068 4.9896398 0.0 0.0 -13.02054 1.858405
                                0.0 0.0 -1656.8179 -37.929276 0.0 0.0 -1.2712159 -0.25658727 0.0 0.0
                                -1.3003781 -0.66906446 0.0 0.0 -11.47648 4.3241363 0.0 0.0 -1.4663895
                                -0.03650553 0.0 0.0 -13.8448715 0.56395173 0.0 0.0 -14.299662 -1.315976 0.0
                                0.0 -96.80002 -128.98766 0.0 0.0 -1.382304 -0.26992974 0.0 0.0 -1.0262643
                                -0.65061843 0.0 0.0 -1.3979027 0.123269744 0.0 0.0 -14.047783 -2.3219466 0.0
                                0.0 -1.3167415 0.6552508 0.0 0.0 -3.4941742 0.21067534 0.0 0.0 -142.09546
                                -64.01878 0.0 0.0 -12.910369 4.1747537 0.0 0.0 -162.20103 -80.59055 0.0 0.0
                                -155.39531 6.7000747 0.0 0.0 -1.4756395 0.17076127 0.0 0.0 -120.966415
                                -69.81103 0.0 0.0 -159.3007 -2.63712 0.0 0.0 -14.206817 -5.400402 0.0 0.0
                                -116.0741 -109.79452 0.0 0.0 -1.4081435 0.011109479 0.0 0.0 -1.466734
                                0.24914852 0.0 0.0 -14.796086 -4.490094 0.0 0.0 -132.25415 94.53781 0.0 0.0
                                -148.68782 -34.29725 0.0 0.0 -13.52842 6.6151376 0.0 0.0 -1.4188812
                                0.33669195 0.0 0.0 -139.81088 -21.586502 0.0 0.0 -158.94171 -8.606729 0.0 0.0
                                -1.4291335 -0.31937537 0.0 0.0 -14.450029 -4.3386354 0.0 0.0 -12.254058
                                -1.0620936 0.0 0.0 -25.932213 4.6480727 0.0 0.0 -8.765682 -8.445831 0.0 0.0
                                -12.726708 5.792524 0.0 0.0 -136.10843 27.391106 0.0 0.0 -13.745164
                                0.51310515 0.0 0.0 -14.550521 -2.8302326 0.0 0.0 -1.2425799 -0.45077047 0.0
                                0.0 -130.6836 52.73818 0.0 0.0 -0.9949992 -1.0563489 0.0 0.0 -0.974153
                                -0.7432406 0.0 0.0 -149.48875 -48.934647 0.0 0.0 -1.1452444 -0.63905495 0.0
                                0.0 -1.3642612 0.33796534 0.0 0.0 -142.77794 4.7870345 0.0 0.0 -141.17227
                                -5.7135177 0.0 0.0 -10.633847 -11.195547 0.0 0.0 -163.22084 -46.98911 0.0 0.0
                                -135.12106 -86.06128 0.0 0.0 -1.1328725 -0.82042634 0.0 0.0 -1204.9446
                                -1201.5046 0.0 0.0 -146.47173 -62.083485 0.0 0.0 -1.2015101 0.703357 0.0 0.0
                                -140.61696 17.95682 0.0 0.0 -1.3381132 -0.4928881 0.0 0.0 -1.4136353
                                0.26330277 0.0 0.0 -1.4539131 0.20410636 0.0 0.0 -150.95787 55.998394 0.0 0.0
                                -1.4362689 0.13368551 0.0 0.0 -12.333489 6.4375477 0.0 0.0 -122.9711
                                -71.05651 0.0 0.0 -153.14555 -50.362003 0.0 0.0 -1854.6194 137.6043 0.0 0.0
                                -1.3256474 0.3622 0.0 0.0 -1.4072855 -0.35143784 0.0 0.0 -13.576727
                                -4.3425922 0.0 0.0 -13.576832 3.296081 0.0 0.0 -1.4664664 0.10858461 0.0 0.0
                                -1.3826014 0.36042657 0.0 0.0 -155.28293 11.45691 0.0 0.0 -153.45406
                                10.670694 0.0 0.0 -15.191702 -3.6481502 0.0 0.0 -1.4173928 0.1190814 0.0 0.0
                                -163.00243 -5.186893 0.0 0.0 -1.4772986 0.04740305 0.0 0.0 -1.3315964
                                -0.61239976 0.0 0.0 -1.0106565 -0.92805547 0.0 0.0 -1.270082 0.21287912 0.0
                                0.0 -1943.646 -572.3302 0.0 0.0 -212.76175 -194.74904 0.0 0.0 -144.0644
                                36.707092 0.0 0.0 -15.739364 5.795205 0.0 0.0 -140.75778 -77.19173 0.0 0.0
                                -1.3202333 -0.005977091 0.0 0.0 -13.102011 -4.8819404 0.0 0.0 -1.3458076
                                0.15152606 0.0 0.0 -156.33234 49.28849 0.0 0.0 -10.809151 10.584759 0.0 0.0
                                -1.4079425 0.002969898 0.0 0.0 -167.2641 -2.7001817 0.0 0.0 -1.4686096
                                0.51071376 0.0 0.0 -1.4555266 -0.16892798 0.0 0.0 -14.852406 4.8641534 0.0
                                0.0 -151.2833 63.003117 0.0 0.0 -1.4759481 -0.1500193 0.0 0.0 -139.19743
                                37.31703 0.0 0.0 -1.386839 -0.15801486 0.0 0.0 -142.05042 -8.062179 0.0 0.0
                                -16.648512 -2.9901845 0.0 0.0 -0.77449214 1.0839713 0.0 0.0 -1.3525956
                                0.53554785 0.0 0.0 -1.487514 0.3739962 0.0 0.0 -1635.579 -664.9047 0.0 0.0
                                -1.3428364 0.3495469 0.0 0.0 -1.4494395 -0.4082699 0.0 0.0 -1.2401059
                                0.65530664 0.0 0.0 -1.4157051 -0.28291675 0.0 0.0 -4139.535 -1021.05347 0.0
                                0.0 -1.4794513 0.06542651 0.0 0.0 -1.430025 0.2619261 0.0 0.0 -1761.8141
                                -1214.5566 0.0 0.0 -116.33507 -98.09142 0.0 0.0 -143.72527 -19.54625 0.0 0.0
                                -14.795108 -3.0317538 0.0 0.0 -11.953778 7.4841905 0.0 0.0 -1.4030409
                                -0.47660068 0.0 0.0 -1.3259643 0.38573095 0.0 0.0 -1.1421546 -0.6293716 0.0
                                0.0 -1.387925 -0.022330835 0.0 0.0 -1.3972446 -0.14673313 0.0 0.0 -98.00164
                                -109.380646 0.0 0.0 -149.49977 -65.63352 0.0 0.0 -10.655193 -8.322469 0.0 0.0
                                -146.18694 -25.717964 0.0 0.0 -1.4784423 -0.019045105 0.0 0.0 -14.047683
                                -6.1245966 0.0 0.0 -1.2936149 -0.6360557 0.0 0.0 -213.19366 17.632696 0.0 0.0
                                -16.358467 -2.851958 0.0 0.0 -13.422232 -4.397589 0.0 0.0 -2343.9133
                                -143.2603 0.0 0.0 -13.407303 -4.082889 0.0 0.0 -1.461756 -0.113501586 0.0 0.0
                                -1.4833235 -0.034092017 0.0 0.0 -145.07071 18.072226 0.0 0.0 -128.56459
                                69.60059 0.0 0.0 -161.37674 27.142681 0.0 0.0 -1.4606456 -0.25592226 0.0 0.0
                                -146.16953 -23.053278 0.0 0.0 -156.26073 -54.983078 0.0 0.0 -133.41159
                                -60.517696 0.0 0.0 -1.0439572 -0.8375924 0.0 0.0 -13.32963 -4.970838 0.0 0.0
                                -1.1823256 -0.32508588 0.0 0.0 -1737.179 -121.48233 0.0 0.0 -1.3145374
                                0.34850186 0.0 0.0 -104.99236 -102.622604 0.0 0.0 -1.3519124 -0.26083234 0.0
                                0.0 -11.950422 -5.4346538 0.0 0.0 -14.082305 -6.7876563 0.0 0.0 -1.4825088
                                0.12440488 0.0 0.0 -155.39008 -87.58355 0.0 0.0 -1.2713469 0.6609046 0.0 0.0
                                -1.4203333 0.14496954 0.0 0.0 -15.757183 -3.616932 0.0 0.0 -2335.463
                                -1091.0472 0.0 0.0 -159.4079 -22.188696 0.0 0.0 -1.4898559 -0.076343715 0.0
                                0.0 -13.041951 -6.1246395 0.0 0.0 -13.110496 -3.9409573 0.0 0.0 -142.31456
                                57.66342 0.0 0.0 -139.71342 52.41113 0.0 0.0 -135.9744 -40.23877 0.0 0.0
                                -168.97253 -6.1980524 0.0 0.0 -1.4405799 0.182909 0.0 0.0 -15.691841
                                -2.390281 0.0 0.0 -12.877691 2.300089 0.0 0.0 -1842.2103 -730.6907 0.0 0.0
                                -1.0693973 0.40114433 0.0 0.0 -256.71133 11.687064 0.0 0.0 -12.000454
                                -4.22864 0.0 0.0 -147.09744 -94.97923 0.0 0.0 -154.5658 -67.24698 0.0 0.0
                                -1.3840871 0.17933337 0.0 0.0 -147.71136 -26.42265 0.0 0.0 -1.3555454
                                -0.07467764 0.0 0.0 -1.2972629 -0.7986279 0.0 0.0 -218.88733 9.525531 0.0 0.0
                                -1.479983 -0.14270125 0.0 0.0 -149.89494 -9.7124405 0.0 0.0 -1.4658972
                                0.055540714 0.0 0.0 -1.1144785 -0.0047313417 0.0 0.0 -183.55879 -34.698666
                                0.0 0.0 -1342.6085 -1170.2069 0.0 0.0 -1.2201319 0.6457323 0.0 0.0 -1.420338
                                -0.14013276 0.0 0.0 -1.4383422 0.08107249 0.0 0.0 -176.8799 34.533886 0.0 0.0
                                -1.4532543 -0.29273286 0.0 0.0 -235.0173 -104.56339 0.0 0.0 -1.3575828
                                0.4089852 0.0 0.0 -1.3256227 0.10093467 0.0 0.0 -281.88098 61.13812 0.0 0.0
                                -15.067563 3.2817852 0.0 0.0 -149.38783 9.639889 0.0 0.0 -12.101948 7.7685843
                                0.0 0.0 -1.4129575 -0.1814001 0.0 0.0 -211.81636 -19.052387 0.0 0.0
                                -161.99171 -3.1060364 0.0 0.0 -1797.2977 20.773342 0.0 0.0 -170.31122
                                -68.68946 0.0 0.0 -250.47395 -6.774443 0.0 0.0 -1.4766977 0.16495724 0.0 0.0
                                -153.68669 -27.851858 0.0 0.0 -274.26248 -57.456192 0.0 0.0 -15.973946
                                0.12056543 0.0 0.0 -1.3444173 -0.23477153 0.0 0.0 -128.81972 -88.75663 0.0
                                0.0 -1.4734393 -0.0059406534 0.0 0.0 -16.590536 -9.840033 0.0 0.0 -1.3660492
                                -0.4410314 0.0 0.0 -1.3729907 -0.52716917 0.0 0.0 -1.2932003 -0.2146673 0.0
                                0.0 -1.2363254 -0.052813765 0.0 0.0 -154.06998 -71.779755 0.0 0.0 -161.2604
                                9.633126 0.0 0.0 -129.97267 -76.81195 0.0 0.0 -137.36267 -104.33231 0.0 0.0
                                -1.2186831 -0.43457767 0.0 0.0 -190.28581 7.8605623 0.0 0.0 -1.3133963
                                -0.33943728 0.0 0.0 -206.6141 7.156924 0.0 0.0 -1.2795069 -0.7456867 0.0 0.0
                                -14.069919 -2.8315322 0.0 0.0 -15.219165 -5.0490727 0.0 0.0 -0.5669666
                                -0.010213204 0.0 0.0 -229.13277 -78.77489 0.0 0.0 -163.69505 -8.939566 0.0
                                0.0 -150.05074 -56.73533 0.0 0.0 -1765.5826 -475.38004 0.0 0.0 -14.335607
                                -1.781242 0.0 0.0 -1.4512393 0.17381917 0.0 0.0 -1.3988868 0.22063194 0.0 0.0
                                -171.5489 26.521732 0.0 0.0 -0.6693668 -0.9231507 0.0 0.0 -1.4753263
                                -0.11890766 0.0 0.0 -1.4587009 0.21180746 0.0 0.0 -12.430876 10.915969 0.0
                                0.0 -15.161011 5.366911 0.0 0.0 -166.48187 -40.377296 0.0 0.0 -1.4535828
                                -0.14770482 0.0 0.0 -26.543116 -11.682541 0.0 0.0 -1.370084 -0.16662334 0.0
                                0.0 -222.91113 0.50734335 0.0 0.0 -127.359 -94.63281 0.0 0.0 -1.4869514
                                0.036932133 0.0 0.0 -1.2472918 0.7770657 0.0 0.0 -1.3534534 -0.1314767 0.0
                                0.0 -1530.3906 -1163.4734 0.0 0.0 -1.3626205 -0.53130245 0.0 0.0 -141.23135
                                -100.94936 0.0 0.0 -1.3456391 -0.5874932 0.0 0.0 -16.440666 -6.2488275 0.0
                                0.0 -13.539513 4.950453 0.0 0.0 -14.102887 -2.2524981 0.0 0.0 -14.075372
                                -2.9688895 0.0 0.0 -135.67706 -71.313965 0.0 0.0 -1.2849463 0.0019473693 0.0
                                0.0 -13.773594 2.268526 0.0 0.0 -14.061566 -2.8307166 0.0 0.0 -1.529851
                                0.20912126 0.0 0.0 -109.092766 107.87167 0.0 0.0 -1.1887512 -0.5544427 0.0
                                0.0 -0.9081679 -0.61003953 0.0 0.0 -208.33188 -67.73407 0.0 0.0 -14.748342
                                -1.3742075 0.0 0.0 -244.28156 -35.335743 0.0 0.0 -1.2619123 -0.24968925 0.0
                                0.0 -12.521756 -2.6317835 0.0 0.0 -172.18347 83.8777 0.0 0.0 -1.3192734
                                0.16884951 0.0 0.0 -13.696336 0.068575665 0.0 0.0 -1.3410405 0.003278605 0.0
                                0.0 -1.3266847 -0.5520841 0.0 0.0 -145.3723 -32.787693 0.0 0.0 -21.616398
                                3.8828347 0.0 0.0 -1.1095515 0.4757502 0.0 0.0 -0.91652834 0.3590613 0.0 0.0
                                -154.19655 -45.025795 0.0 0.0 -1.2158626 -0.36354095 0.0 0.0 -182.89456
                                -44.942436 0.0 0.0 -1.3011851 -0.10847204 0.0 0.0 -1.3235937 -0.09618231 0.0
                                0.0 -136.008 -73.7048 0.0 0.0 -13.631608 -4.9887633 0.0 0.0 -1.0540109
                                -0.81467444 0.0 0.0 -247.73666 106.637535 0.0 0.0 -0.96677846 0.8555544 0.0
                                0.0 -1.326046 -0.0019038365 0.0 0.0 -125.60448 -90.89621 0.0 0.0 -14.306221
                                1.6018249 0.0 0.0 -150.90793 -36.07634 0.0 0.0 -16.935425 0.025715986 0.0 0.0
                                -1.2348378 -0.38082018 0.0 0.0 -15.218696 3.3443522 0.0 0.0 -145.4022
                                -84.62157 0.0 0.0 -1.3687224 -0.35774955 0.0 0.0 -14.55491 -0.37313598 0.0
                                0.0 -12.694885 -2.160443 0.0 0.0 -1.2263279 0.5086167 0.0 0.0 -193.21382
                                -41.415615 0.0 0.0 -1.2883692 -0.23198877 0.0 0.0 -13.330378 -1.3657948 0.0
                                0.0 -13.395902 0.23804677 0.0 0.0 -0.95537966 -0.8442325 0.0 0.0 -14.346728
                                1.5867388 0.0 0.0 -1.1010718 0.5080365 0.0 0.0 -1.2215567 -0.47118264 0.0 0.0
                                -284.55322 34.006493 0.0 0.0 -152.79092 -72.58368 0.0 0.0 -13.65221
                                -2.8653538 0.0 0.0 -1.1828159 -0.502526 0.0 0.0 -173.35713 31.718838 0.0 0.0
                                -15.060245 -0.6776539 0.0 0.0 -13.266884 -1.8378885 0.0 0.0 -12.512561
                                -2.7497625 0.0 0.0 -1.2254027 0.32159767 0.0 0.0 -13.453608 -3.7881503 0.0
                                0.0 -1.0336516 -0.8454772 0.0 0.0 -0.69720626 -1.1317652 0.0 0.0 -11.278448
                                -7.3230944 0.0 0.0 -0.98843896 -0.7959708 0.0 0.0 -0.9462207 -0.87188435 0.0
                                0.0 -1.3344916 -0.023242502 0.0 0.0 -1.2985952 -0.097944535 0.0 0.0
                                -145.79587 64.06095 0.0 0.0 -1.2275068 -0.48468468 0.0 0.0 -214.0095
                                -32.661736 0.0 0.0 -1.1107869 -0.4296944 0.0 0.0 -14.503929 -1.4779719 0.0
                                0.0 -16.192228 9.484086 0.0 0.0 -11.6084385 -6.292317 0.0 0.0 -14.462332
                                6.1828203 0.0 0.0 -1.1323923 0.71153307 0.0 0.0 -17.718025 -0.2757695 0.0 0.0
                                -1.2959087 0.1459096 0.0 0.0 -13.947851 -6.0112214 0.0 0.0 -164.42247
                                -46.99296 0.0 0.0 -17.076788 -1.0183464 0.0 0.0 -142.47136 94.817604 0.0 0.0
                                -18.06581 4.1878963 0.0 0.0 -14.246275 -1.1480551 0.0 0.0 -1.1682292
                                -0.6324822 0.0 0.0 -1.3290747 -0.046926018 0.0 0.0 -1.1604525 -0.66299117 0.0
                                0.0 -0.95787346 -1.0549624 0.0 0.0 -141.19852 -71.7377 0.0 0.0 -12.883876
                                -1.2614615 0.0 0.0 -1.1940236 -0.5701768 0.0 0.0 -5.1626544 -13.625096 0.0
                                0.0 -1.2973833 -0.094041035 0.0 0.0 -1.1675525 -0.63760185 0.0 0.0 -141.49411
                                -71.935074 0.0 0.0 -152.28728 36.319073 0.0 0.0 -19.873728 3.3728995 0.0 0.0
                                -185.59445 57.368565 0.0 0.0 -1.1123295 -0.7494157 0.0 0.0 -1.2340653
                                0.306205 0.0 0.0 -1.2085856 0.37355378 0.0 0.0 -1.2964177 -0.32173446 0.0 0.0
                                -15.77487 -0.33839083 0.0 0.0 -1.2178763 0.6476966 0.0 0.0 -156.15602
                                -31.589563 0.0 0.0 -1.218015 -0.51777107 0.0 0.0 -13.889431 -1.0312686 0.0
                                0.0 -1.3138082 0.1909821 0.0 0.0 -1.269268 0.21443155 0.0 0.0 -12.780697
                                -6.5185657 0.0 0.0 -171.93683 -53.879395 0.0 0.0 -1.1078771 -0.69014204 0.0
                                0.0 -11.789594 5.392205 0.0 0.0 -1.2160132 0.4967354 0.0 0.0 -1.2893351
                                -0.061102215 0.0 0.0 -12.507616 -7.846737 0.0 0.0 -15.046287 -2.7443314 0.0
                                0.0 -0.12433635 -1.2680635 0.0 0.0 -1.218386 -0.31706232 0.0 0.0 -184.35126
                                -38.188637 0.0 0.0 -249.08833 -19.146082 0.0 0.0 -1.301551 -0.09740281 0.0
                                0.0 -14.432799 2.7426794 0.0 0.0 -1.2553611 0.025413686 0.0 0.0 -173.99135
                                2.066729 0.0 0.0 -1.1855853 -0.08216911 0.0 0.0 -13.916139 2.317836 0.0 0.0
                                -9.476913 -11.351709 0.0 0.0 -1.2612383 0.3585445 0.0 0.0 -1.2586614
                                -0.3411831 0.0 0.0 -0.94978076 -0.9328282 0.0 0.0 -1.2941986 0.19981799 0.0
                                0.0 -1.2986041 0.17549159 0.0 0.0 -13.54176 -4.1351533 0.0 0.0 -16.330109
                                -1.6303194 0.0 0.0 -1.4908875 0.31064162 0.0 0.0 -1.2430631 -0.42319536 0.0
                                0.0 -420.9197 -190.80461 0.0 0.0 -14.66224 -4.6737795 0.0 0.0 -15.381669
                                -7.9347515 0.0 0.0 -1.2027234 0.5725292 0.0 0.0 -1.3677282 0.3669165 0.0 0.0
                                -1.1404736 -0.670702 0.0 0.0 -1.2910722 0.07222486 0.0 0.0 -15.875223
                                7.0383873 0.0 0.0 -1.2668054 -0.3086454 0.0 0.0 -0.86792386 -1.0818821 0.0
                                0.0 -1.0025831 0.21588714 0.0 0.0 -152.20113 -55.26532 0.0 0.0 -1.3228942
                                0.21784452 0.0 0.0 -168.65077 5.977313 0.0 0.0 -1.2898377 0.36561224 0.0 0.0
                                -13.283027 -5.143032 0.0 0.0 -13.17958 -8.631635 0.0 0.0 -10.805183 6.612219
                                0.0 0.0 -1.206482 -0.005860552 0.0 0.0 -1.2614748 -0.31529555 0.0 0.0
                                -14.559188 3.0607812 0.0 0.0 -1.2803609 0.24627216 0.0 0.0 -158.27986
                                -60.15787 0.0 0.0 -1.9036113 -0.40238404 0.0 0.0 -0.9466983 -0.83771014 0.0
                                0.0 -12.375826 8.282656 0.0 0.0 -165.77136 -35.73923 0.0 0.0 -12.976267
                                2.2238772 0.0 0.0 -1.2405435 -0.50625926 0.0 0.0 -232.6125 -34.456875 0.0 0.0
                                -13.524073 -4.60656 0.0 0.0 -15.875018 2.786805 0.0 0.0 -1.113314 0.62026036
                                0.0 0.0 -1.1595988 -0.36074907 0.0 0.0 -1.2577485 0.21548967 0.0 0.0
                                -1.1983358 0.59724545 0.0 0.0 -1.3294303 -0.13612145 0.0 0.0 -13.412628
                                -2.9586458 0.0 0.0 -1.162239 -0.41880172 0.0 0.0 -1.2404513 0.5057861 0.0 0.0
                                -12.888032 2.878257 0.0 0.0 -1.335234 0.050052017 0.0 0.0 -465.7576 -84.716
                                0.0 0.0 -1.2431223 0.021297565 0.0 0.0 -1.3233691 -0.21586554 0.0 0.0
                                -241.6618 -87.33328 0.0 0.0 -147.20546 -86.721924 0.0 0.0 -1.3017654
                                -0.14996132 0.0 0.0 -10.62689 -7.597082 0.0 0.0 -1.0295587 -1.0382477 0.0 0.0
                                -1.0739442 0.5643445 0.0 0.0 -13.992105 -2.898737 0.0 0.0 -1.248693
                                0.48605344 0.0 0.0 -10.52645 7.9718566 0.0 0.0 -13.724664 0.53461516 0.0 0.0
                                -14.683107 -2.8834703 0.0 0.0 -0.9120889 -0.52801484 0.0 0.0 -170.18593
                                21.609585 0.0 0.0 -1.3062799 0.14926133 0.0 0.0 -1.1598144 0.49234694 0.0 0.0
                                -19.667572 -3.4796064 0.0 0.0 -1.336263 0.07525283 0.0 0.0 -13.636448
                                -4.555481 0.0 0.0 -10.108802 -8.577646 0.0 0.0 -15.444635 7.454721 0.0 0.0
                                -1.2817378 -0.35093868 0.0 0.0 -14.156997 1.8601297 0.0 0.0 -14.659771
                                3.038404 0.0 0.0 -13.437603 -2.235909 0.0 0.0 -133.49454 -120.054756 0.0 0.0
                                -12.239179 -5.027174 0.0 0.0 -175.2529 -39.61401 0.0 0.0 -0.8352773
                                -0.9993671 0.0 0.0 -15.288745 2.133585 0.0 0.0 -1.4276018 -0.43661165 0.0 0.0
                                -2.058463 -0.57567936 0.0 0.0 -197.84373 -48.215508 0.0 0.0 -1.293351
                                0.3163279 0.0 0.0 -13.856538 -3.9640138 0.0 0.0 -160.81667 81.34525 0.0 0.0
                                -0.7181599 -0.019136896 0.0 0.0 -11.837492 -8.245155 0.0 0.0 -1.186572
                                0.40662846 0.0 0.0 -1.1550114 0.2821561 0.0 0.0 -14.958546 0.98691684 0.0 0.0
                                -1.1871506 -0.31060237 0.0 0.0 -1.2394557 -0.34055176 0.0 0.0 -287.9924
                                97.41873 0.0 0.0 -1.3338364 0.06663608 0.0 0.0 -1.3375475 0.07495256 0.0 0.0
                                -1.0573137 0.57799995 0.0 0.0 -1.3340486 -0.016482677 0.0 0.0 -15.02904
                                0.45198828 0.0 0.0 -15.638972 1.2774379 0.0 0.0 -1.2386144 -0.49186912 0.0
                                0.0 -15.68129 -4.6435356 0.0 0.0 -1.338159 -0.07901696 0.0 0.0 -0.99328
                                -0.82239383 0.0 0.0 -200.45566 -75.20248 0.0 0.0 -205.52074 -1.200206 0.0 0.0
                                -9.847278 -8.88211 0.0 0.0 -1.2524499 -0.47063336 0.0 0.0 -15.104659
                                0.048129674 0.0 0.0 -1.1388763 -0.6924235 0.0 0.0 -14.618199 -3.4352257 0.0
                                0.0 -18.887367 -9.09681 0.0 0.0 -11.601988 8.578434 0.0 0.0 -1.2277492
                                -0.51146686 0.0 0.0 -13.262285 -4.2138042 0.0 0.0 -159.03601 41.061455 0.0
                                0.0 -1.3400419 -0.036961563 0.0 0.0 -1.3512996 0.28483337 0.0 0.0 -1.3177452
                                -0.04393688 0.0 0.0 -1.0497178 -0.75803566 0.0 0.0 -1.3091109 0.12906107 0.0
                                0.0 -1.3225708 0.12807629 0.0 0.0 -1.3325933 -0.1181607 0.0 0.0 -158.23358
                                -75.68678 0.0 0.0 -12.5102 -4.777045 0.0 0.0 -13.8399105 0.4011358 0.0 0.0
                                -13.242985 -5.2512574 0.0 0.0 -10.389235 11.103985 0.0 0.0 -122.3666
                                94.593475 0.0 0.0 -1.7036967 0.20159374 0.0 0.0 -1.4494928 -0.26174384 0.0
                                0.0 -15.238997 -9.515373 0.0 0.0 -15.111739 -1.1502428 0.0 0.0 -16.99974
                                -0.93978244 0.0 0.0 -161.28004 -106.20651 0.0 0.0 -117.0835 -141.34822 0.0
                                0.0 -2292.6274 -834.8347 0.0 0.0 -16.997992 -15.214337 0.0 0.0 -173.5635
                                85.223175 0.0 0.0 -162.79216 -46.582134 0.0 0.0 -16.619303 4.226995 0.0 0.0
                                -196.00345 40.57948 0.0 0.0 -1.3113717 -0.6911347 0.0 0.0 -1.3087368
                                -0.18529025 0.0 0.0 -1.317663 0.56206983 0.0 0.0 -2266.444 -1401.9515 0.0 0.0
                                -246.82455 0.7146223 0.0 0.0 -0.7954058 -0.6199886 0.0 0.0 -1.3678627
                                0.5744337 0.0 0.0 -1.3655629 0.37464255 0.0 0.0 -1.0966275 -1.0008901 0.0 0.0
                                -11.111742 -12.824425 0.0 0.0 -13.465571 -7.233412 0.0 0.0 -1.2504798
                                -0.301113 0.0 0.0 -13.344058 -2.386192 0.0 0.0 -1.4694101 0.06902578 0.0 0.0
                                -192.63084 -63.4844 0.0 0.0 -187.69836 73.06308 0.0 0.0 -1.2548349
                                -0.39141282 0.0 0.0 -218.15361 -34.49657 0.0 0.0 -17.919529 2.6226976 0.0 0.0
                                -155.44621 -74.473076 0.0 0.0 -1.4651656 -0.03013855 0.0 0.0 -12.619839
                                -1.3514555 0.0 0.0 -1.4728395 -0.0021598262 0.0 0.0 -1.4097513 -0.115589686
                                0.0 0.0 -179.78514 2.9460554 0.0 0.0 -14.513418 5.2048507 0.0 0.0 -14.106879
                                1.4471661 0.0 0.0 -10.9241495 8.622232 0.0 0.0 -1.1319354 -0.6056708 0.0 0.0
                                -1.4578003 0.30060026 0.0 0.0 -1.2472667 -0.79360807 0.0 0.0 -10.485437
                                8.458051 0.0 0.0 -198.20625 -49.620377 0.0 0.0 -17.128366 -4.72586 0.0 0.0
                                -13.339783 2.5648553 0.0 0.0 -13.950528 -2.4215186 0.0 0.0 -14.479259
                                -4.488595 0.0 0.0 -13.279147 3.2693875 0.0 0.0 -13.552873 -1.706263 0.0 0.0
                                -1.4439081 -0.052481413 0.0 0.0 -186.26088 30.343382 0.0 0.0 -16.729193
                                -3.1945543 0.0 0.0 -15.251015 -1.5105917 0.0 0.0 -15.531553 7.4578104 0.0 0.0
                                -1.2242979 -0.36275885 0.0 0.0 -1.4315467 -0.12373372 0.0 0.0 -1.3385962
                                -0.52828175 0.0 0.0 -13.867279 -3.0918934 0.0 0.0 -1.450298 0.04832667 0.0
                                0.0 -281.11932 -64.549835 0.0 0.0 -10.880712 -10.76653 0.0 0.0 -191.15063
                                -18.612112 0.0 0.0 -1.3502116 -0.18171841 0.0 0.0 -181.84694 46.506123 0.0
                                0.0 -1.4148221 -0.008543453 0.0 0.0 -0.9976305 -1.081877 0.0 0.0 -1.0740497
                                -1.0178766 0.0 0.0 -203.96977 62.752083 0.0 0.0 -17.793503 -6.729565 0.0 0.0
                                -16.636093 1.9762565 0.0 0.0 -227.3636 48.565323 0.0 0.0 -228.2487 117.67786
                                0.0 0.0 -1.3349874 0.5879007 0.0 0.0 -18.148993 1.7960796 0.0 0.0 -1.3499508
                                -0.4360552 0.0 0.0 -151.16438 -115.4723 0.0 0.0 -1.3201064 0.40825823 0.0 0.0
                                -12.921171 8.436792 0.0 0.0 -16.248306 -5.347426 0.0 0.0 -191.3383 136.68156
                                0.0 0.0 -16.721281 -2.2741482 0.0 0.0 -1.382056 -0.6987658 0.0 0.0 -1.4321766
                                0.14189951 0.0 0.0 -1.0255494 -0.35250264 0.0 0.0 -1.1120301 -0.96800256 0.0
                                0.0 -15.475777 -4.849052 0.0 0.0 -15.999532 -2.7685738 0.0 0.0 -174.65817
                                18.835655 0.0 0.0 -15.869522 -3.0928998 0.0 0.0 -166.33401 52.11483 0.0 0.0
                                -1.2679684 -0.5557988 0.0 0.0 -17.344732 0.48834231 0.0 0.0 -197.61809
                                14.335373 0.0 0.0 -192.14124 11.428236 0.0 0.0 -164.49512 -58.830418 0.0 0.0
                                -15.265653 2.1654441 0.0 0.0 -1.5892457 -0.10735209 0.0 0.0 -1.3796637
                                0.47615892 0.0 0.0 -165.71768 -61.438736 0.0 0.0 -2249.7188 273.63342 0.0 0.0
                                -1.0329763 -1.0625243 0.0 0.0 -133.78043 75.810905 0.0 0.0 -1.4245278
                                -0.055563428 0.0 0.0 -16.478548 -3.9264996 0.0 0.0 -10.211369 -13.7696 0.0
                                0.0 -1.4726185 0.12753922 0.0 0.0 -176.17116 16.132341 0.0 0.0 -174.90648
                                -14.4395485 0.0 0.0 -14.524734 5.2969894 0.0 0.0 -18.17526 -0.10544768 0.0
                                0.0 -1.3680125 0.3560468 0.0 0.0 -1.3817908 0.32524562 0.0 0.0 -1.4916953
                                0.14498192 0.0 0.0 -1.3483139 -1.0007862 0.0 0.0 -174.79716 -56.68826 0.0 0.0
                                -2329.9285 163.7098 0.0 0.0 -194.17174 -98.281166 0.0 0.0 -14.960078
                                4.2305117 0.0 0.0 -15.552959 6.5397406 0.0 0.0 -2268.1614 -891.2632 0.0 0.0
                                -14.51062 -2.5649788 0.0 0.0 -13.233337 -3.5452647 0.0 0.0 -11.366263
                                -12.712431 0.0 0.0 -16.15006 -3.0533412 0.0 0.0 -1.4683702 -0.22316404 0.0
                                0.0 -179.05801 40.984943 0.0 0.0 -1.3072609 0.3043329 0.0 0.0 -1.4241321
                                -0.4133159 0.0 0.0 -179.56375 42.11207 0.0 0.0 -15.014695 -0.7778445 0.0 0.0
                                -15.505249 1.6775796 0.0 0.0 -19.99238 -1.1822599 0.0 0.0 -177.06836
                                -1.8095886 0.0 0.0 -1.2525144 0.7611398 0.0 0.0 -15.470454 0.5236626 0.0 0.0
                                -200.28415 -7.2389445 0.0 0.0 -1.6490945 0.22564931 0.0 0.0 -2319.1143
                                -665.85876 0.0 0.0 -1.08558 0.84644634 0.0 0.0 -146.70099 -44.211334 0.0 0.0
                                -1.4857308 -0.015636712 0.0 0.0 -1.3324146 -0.66513854 0.0 0.0 -1.2761623
                                -0.6934996 0.0 0.0 -16.17188 -2.0255914 0.0 0.0 -1.4274776 -0.034352563 0.0
                                0.0 -1.3451056 -0.4867258 0.0 0.0 -8.86986 3.7260242 0.0 0.0 -2901.4304
                                772.09564 0.0 0.0 -1.3906397 0.40147427 0.0 0.0 -1.0700302 0.87286496 0.0 0.0
                                -1.4642495 0.25267068 0.0 0.0 -152.0486 -146.99648 0.0 0.0 -1.4664104
                                -0.14570694 0.0 0.0 -1.3721001 -0.3720727 0.0 0.0 -1.3876398 -0.12639225 0.0
                                0.0 -2359.9792 -1448.7566 0.0 0.0 -14.365567 1.331145 0.0 0.0 -15.909412
                                3.3982708 0.0 0.0 -1.2310337 0.55644065 0.0 0.0 -1.0892475 -0.5246839 0.0 0.0
                                -1.3705591 -0.27859426 0.0 0.0 -15.202417 -8.519232 0.0 0.0 -1.3009766
                                -0.43782255 0.0 0.0 -1.3534542 -0.5775046 0.0 0.0 -15.813026 -4.312966 0.0
                                0.0 -16.169 -4.9511266 0.0 0.0 -186.31975 16.400135 0.0 0.0 -187.19159
                                -55.355404 0.0 0.0 -1.3537738 -0.48383725 0.0 0.0 -1.4850144 -0.106038935 0.0
                                0.0 -22.090796 -6.879997 0.0 0.0 -1.0143716 -1.015917 0.0 0.0 -1.5029525
                                0.6115367 0.0 0.0 -1.3801687 -0.0074392552 0.0 0.0 -1.4291303 -0.16054285 0.0
                                0.0 -249.93213 40.428535 0.0 0.0 -1.4793124 0.026108036 0.0 0.0 -13.20024
                                11.32368 0.0 0.0 -13.602592 -10.204234 0.0 0.0 -1.2981973 0.6165194 0.0 0.0
                                -17.387058 5.015143 0.0 0.0 -1.2631547 -0.6833824 0.0 0.0 -1.4551743
                                0.23602858 0.0 0.0 -168.97849 -62.75306 0.0 0.0 -1.125713 -0.6026 0.0 0.0
                                -210.32077 40.181637 0.0 0.0 -1.4608614 0.06906913 0.0 0.0 -1.4836193
                                0.09658667 0.0 0.0 -1.3979803 -0.17065898 0.0 0.0 -1.4589471 -0.19785209 0.0
                                0.0 -242.34213 -28.662527 0.0 0.0 -2466.398 -1113.5511 0.0 0.0 -1.473276
                                0.21226385 0.0 0.0 -18.02529 -7.484221 0.0 0.0 -159.03409 -85.81926 0.0 0.0
                                -1.1904621 0.12150869 0.0 0.0 -260.02774 65.52468 0.0 0.0 -15.116975
                                -6.760199 0.0 0.0 -15.3398075 -3.8037632 0.0 0.0 -1.3023148 0.14950898 0.0
                                0.0 -14.929432 -3.5280337 0.0 0.0 -13.13773 -8.759364 0.0 0.0 -10.929395
                                8.810778 0.0 0.0 -168.7122 104.20423 0.0 0.0 -244.01814 40.301098 0.0 0.0
                                -17.568962 2.1981936 0.0 0.0 -1.3189795 -0.11092062 0.0 0.0 -201.87035
                                -44.95601 0.0 0.0 -2037.1326 -1268.3683 0.0 0.0 -14.248548 9.7127905 0.0 0.0
                                -1.2226084 0.1372445 0.0 0.0 -1.4577218 0.2824508 0.0 0.0 -16.312572
                                -1.0347538 0.0 0.0 -255.97256 -25.376846 0.0 0.0 -184.89917 14.491583 0.0 0.0
                                -14.25994 6.302549 0.0 0.0 -1.2847912 0.28937313 0.0 0.0 -1.3838623
                                0.083677225 0.0 0.0 -2864.5105 129.75133 0.0 0.0 -1.1997947 -0.3823047 0.0
                                0.0 -1.4011539 -0.39425114 0.0 0.0 -187.03006 90.81776 0.0 0.0 -14.005721
                                0.5583524 0.0 0.0 -15.746282 1.9190651 0.0 0.0 -234.78448 77.75355 0.0 0.0
                                -13.089608 -5.1499095 0.0 0.0 -15.4563675 3.6794684 0.0 0.0 -1.4480412
                                -0.08143784 0.0 0.0 -171.8151 -83.71987 0.0 0.0 -1.4322565 0.106275536 0.0
                                0.0 -1.4144121 -0.37245858 0.0 0.0 -1.3132548 -0.5085213 0.0 0.0 -1.2750995
                                -0.34562618 0.0 0.0 -14.459058 -2.362286 0.0 0.0 -1.1987985 0.70096874 0.0
                                0.0 -15.296953 4.3593616 0.0 0.0 -188.18225 -68.3015 0.0 0.0 -179.14798
                                -71.2189 0.0 0.0 -1.3507859 0.3526524 0.0 0.0 -17.790787 0.6687211 0.0 0.0
                                -14.258489 -8.609047 0.0 0.0 -1.4848984 0.12044279 0.0 0.0 -1.5003504
                                -0.5925043 0.0 0.0 -1.4105864 0.19434762 0.0 0.0 -0.7896546 -0.9832556 0.0
                                0.0 -1.4149513 0.3377828 0.0 0.0 -154.74043 -99.86018 0.0 0.0 -13.235063
                                -10.332358 0.0 0.0 -27.292776 -14.584917 0.0 0.0 -186.89061 -45.78398 0.0 0.0
                                -1.3066405 -0.30094007 0.0 0.0 -16.265547 -2.2977674 0.0 0.0 -1.2803003
                                0.03752553 0.0 0.0 -192.6829 4.779859 0.0 0.0 -15.271082 -4.223615 0.0 0.0
                                -1.413018 -0.30452776 0.0 0.0 -1.1274983 -0.36866876 0.0 0.0 -1.3089496
                                -0.5926587 0.0 0.0 -19.470404 3.0592408 0.0 0.0 -215.61794 44.203766 0.0 0.0
                                -160.8188 76.00935 0.0 0.0 -184.38348 -15.650034 0.0 0.0 -1.2785156 0.2605473
                                0.0 0.0 -17.351519 -1.4916466 0.0 0.0 -1.3229368 0.20983231 0.0 0.0
                                -13.605797 -6.998184 0.0 0.0 -176.83218 -78.87273 0.0 0.0 -210.77298
                                -15.521743 0.0 0.0 -15.832883 -1.2848401 0.0 0.0 -12.567586 8.749521 0.0 0.0
                                -1.3236725 -0.011937253 0.0 0.0 -13.5181465 -5.7164125 0.0 0.0 -14.320495
                                -7.084176 0.0 0.0 -15.7064705 2.1493976 0.0 0.0 -221.32457 -66.92362 0.0 0.0
                                -1.282499 -0.12347981 0.0 0.0 -1.332594 0.014277664 0.0 0.0 -13.142755
                                -8.828745 0.0 0.0 -1.3740151 0.29714948 0.0 0.0 -1.3047328 -0.06741838 0.0
                                0.0 -15.939899 1.6785482 0.0 0.0 -182.27588 -90.13427 0.0 0.0 -174.15929
                                -66.38752 0.0 0.0 -0.83724356 -0.96131825 0.0 0.0 -310.3112 -110.357056 0.0
                                0.0 -14.308785 6.8546815 0.0 0.0 -184.50703 -28.126398 0.0 0.0 -234.97932
                                -95.45604 0.0 0.0 -246.00275 -152.30653 0.0 0.0 -11.800471 -8.41953 0.0 0.0
                                -13.37704 -4.4125137 0.0 0.0 -1.2179246 0.26013276 0.0 0.0 -14.684746
                                -1.1719158 0.0 0.0 -14.291969 -3.5693989 0.0 0.0 -1.2947032 -0.30309775 0.0
                                0.0 -299.2794 96.981346 0.0 0.0 -1.3355473 -0.0920689 0.0 0.0 -1.3214086
                                -0.14809823 0.0 0.0 -1.1650975 0.47208023 0.0 0.0 -1.3300203 -0.81155646 0.0
                                0.0 -210.1868 39.740032 0.0 0.0 -1.306241 0.05897333 0.0 0.0 -1.2492791
                                0.4092631 0.0 0.0 -161.79916 -7.2211905 0.0 0.0 -244.37727 -0.4118266 0.0 0.0
                                -1.284659 0.04586821 0.0 0.0 -201.40753 39.103527 0.0 0.0 -192.56752
                                -38.720627 0.0 0.0 -193.89325 -31.841131 0.0 0.0 -15.819436 2.4442608 0.0 0.0
                                -15.612206 -0.8157774 0.0 0.0 -17.86342 -4.2804093 0.0 0.0 -175.96248
                                -67.04241 0.0 0.0 -1.3260084 -0.055956665 0.0 0.0 -1.256461 0.07306488 0.0
                                0.0 -1.126194 -0.7287113 0.0 0.0 -1.31316 -0.189909 0.0 0.0 -1.2841494
                                -0.05798148 0.0 0.0 -13.412413 -4.434305 0.0 0.0 -14.699638 6.3570657 0.0 0.0
                                -11.61706 -9.143021 0.0 0.0 -215.53036 -3.1274142 0.0 0.0 -185.65053
                                -35.119537 0.0 0.0 -1.3255762 0.17251322 0.0 0.0 -213.57191 30.848785 0.0 0.0
                                -1.2304465 -0.40370995 0.0 0.0 -1.3189694 -0.20092049 0.0 0.0 -1.1916031
                                0.45008966 0.0 0.0 -1.1755563 -0.63407034 0.0 0.0 -1.2994589 -0.20289415 0.0
                                0.0 -15.86269 -0.5089318 0.0 0.0 -13.804715 -3.3011045 0.0 0.0 -13.887645
                                -2.9677854 0.0 0.0 -21.619661 -12.139514 0.0 0.0 -305.65817 40.15148 0.0 0.0
                                -246.14383 78.943016 0.0 0.0 -1.2187345 -0.52876884 0.0 0.0 -14.715023
                                1.6137265 0.0 0.0 -15.531445 1.072274 0.0 0.0 -281.48987 -27.362728 0.0 0.0
                                -171.54692 117.03005 0.0 0.0 -1.4673145 0.32584494 0.0 0.0 -13.565383
                                -4.2587533 0.0 0.0 -14.461625 -5.7031016 0.0 0.0 -1.331407 0.33947366 0.0 0.0
                                -17.415693 -4.7643805 0.0 0.0 -1.3407702 0.037189156 0.0 0.0 -16.5246
                                -2.7625613 0.0 0.0 -1.299888 0.13214679 0.0 0.0 -207.15384 -22.082388 0.0 0.0
                                -171.89006 -82.68972 0.0 0.0 -1.2402868 -0.337645 0.0 0.0 -13.377648
                                -4.8074584 0.0 0.0 -1.3251963 -0.14262365 0.0 0.0 -175.6085 -94.991615 0.0
                                0.0 -1.2335354 -0.49644265 0.0 0.0 -216.06909 -31.173172 0.0 0.0 -1.3201087
                                -0.19066878 0.0 0.0 -257.94333 -38.800503 0.0 0.0 -1.4597383 0.13785519 0.0
                                0.0 -191.39098 -0.18533643 0.0 0.0 -0.9816624 -0.6769376 0.0 0.0 -1.2937459
                                0.44973156 0.0 0.0 -14.409686 -7.2841434 0.0 0.0 -1.3067262 -0.051341943 0.0
                                0.0 -12.04734 -7.6395254 0.0 0.0 -20.79987 7.6971745 0.0 0.0 -1.2370837
                                -0.48159212 0.0 0.0 -17.31405 -4.3844776 0.0 0.0 -14.243209 -1.1020542 0.0
                                0.0 -15.884432 -2.6253917 0.0 0.0 -1.3371389 0.08428287 0.0 0.0 -1.3108102
                                0.20875072 0.0 0.0 -18.023703 -5.8190665 0.0 0.0 -1.286458 -0.34982985 0.0
                                0.0 -262.02228 -17.289022 0.0 0.0 -19.705208 8.081264 0.0 0.0 -1.2731739
                                -0.24314646 0.0 0.0 -340.74246 -157.23883 0.0 0.0 -1.1046265 0.6475543 0.0
                                0.0 -32.22097 -12.702741 0.0 0.0 -16.204039 -10.667609 0.0 0.0 -13.460037
                                -4.8496842 0.0 0.0 -24.722668 4.3913918 0.0 0.0 -17.228596 -7.154448 0.0 0.0
                                -13.615737 -6.091999 0.0 0.0 -18.740759 0.21993297 0.0 0.0 -13.962308
                                7.0248895 0.0 0.0 -207.44418 -39.73445 0.0 0.0 -24.212826 -7.88032 0.0 0.0
                                -1.2151963 0.36928564 0.0 0.0 -17.169674 4.585331 0.0 0.0 -1.3316182
                                -0.007658564 0.0 0.0 -19.177238 3.627031 0.0 0.0 -1.2024066 -0.59225315 0.0
                                0.0 -22.049358 -2.4884245 0.0 0.0 -14.133636 2.399753 0.0 0.0 -13.977792
                                8.167075 0.0 0.0 -18.209833 0.085370265 0.0 0.0 -1.3341736 0.13853942 0.0 0.0
                                -16.209803 -1.2799938 0.0 0.0 -16.067118 5.244346 0.0 0.0 -242.58475
                                7.4389324 0.0 0.0 -1.3149999 -0.1002365 0.0 0.0 -12.928946 -9.524098 0.0 0.0
                                -1.2376343 0.06064359 0.0 0.0 -1.1955358 -0.57958585 0.0 0.0 -7.093026
                                -12.248604 0.0 0.0 -1.0013895 -0.87645584 0.0 0.0 -186.95715 -101.59736 0.0
                                0.0 -14.327866 -0.43661675 0.0 0.0 -216.96173 50.106007 0.0 0.0 -1.1598526
                                -0.05997868 0.0 0.0 -1.3065957 -0.019364975 0.0 0.0 -1.2347169 -0.4808723 0.0
                                0.0 -13.902415 -5.767697 0.0 0.0 -19.363398 -3.2756038 0.0 0.0 -1.3220365
                                -0.026912354 0.0 0.0 -16.332848 -1.953315 0.0 0.0 -16.281189 -5.3672466 0.0
                                0.0 -14.152766 -11.707249 0.0 0.0 -184.85527 -63.178795 0.0 0.0 -16.5042
                                -4.7868257 0.0 0.0 -1.0458345 -0.83445585 0.0 0.0 -13.770526 -10.171863 0.0
                                0.0 -0.89938736 -0.5536242 0.0 0.0 -1.266194 0.38755056 0.0 0.0 -1.3349873
                                0.10531663 0.0 0.0 -1.1643047 -0.6651678 0.0 0.0 -1.3353634 0.07177862 0.0
                                0.0 -1.3191437 0.05720917 0.0 0.0 -1.2266452 0.2714171 0.0 0.0 -17.047749
                                5.888046 0.0 0.0 -14.501202 -11.558427 0.0 0.0 -1.2872165 -0.072936624 0.0
                                0.0 -191.00458 45.151855 0.0 0.0 -18.008404 0.028774915 0.0 0.0 -12.209687
                                7.7259703 0.0 0.0 -15.190864 -5.1658444 0.0 0.0 -1.2592018 -0.44392532 0.0
                                0.0 -13.425407 -7.8612723 0.0 0.0 -13.371387 7.393159 0.0 0.0 -174.29654
                                -91.22658 0.0 0.0 -181.69829 96.74739 0.0 0.0 -12.55698 7.1764536 0.0 0.0
                                -14.424903 -1.065112 0.0 0.0 -252.06073 -178.7496 0.0 0.0 -1.2862446
                                -0.11112671 0.0 0.0 -1.2774758 0.42630458 0.0 0.0 -30.524641 5.0601363 0.0
                                0.0 -2.8448331 -0.0642355 0.0 0.0 -1.2360971 -0.38221171 0.0 0.0 -14.373328
                                -7.520986 0.0 0.0 -21.907661 -0.1319406 0.0 0.0 -16.293543 -6.5135665 0.0 0.0
                                -1.0678002 -0.71880966 0.0 0.0 -198.93405 -184.05257 0.0 0.0 -215.65504
                                17.667524 0.0 0.0 -0.96763057 -0.5836582 0.0 0.0 -1.1307696 -0.612521 0.0 0.0
                                -1.3535999 0.74774075 0.0 0.0 -193.96318 -96.58172 0.0 0.0 -1.266889
                                0.26959068 0.0 0.0 -1.2736917 0.30618265 0.0 0.0 -1.0355505 0.14820123 0.0
                                0.0 -1.1478758 -0.5677157 0.0 0.0 -1.2604071 -0.16642098 0.0 0.0 -1.3227553
                                -0.103658326 0.0 0.0 -1.2683144 0.40066233 0.0 0.0 -13.3804035 -1.9798279 0.0
                                0.0 -1.334729 -0.035401013 0.0 0.0 -13.2247925 1.2390891 0.0 0.0 -235.11386
                                37.594788 0.0 0.0 -184.80006 -47.199203 0.0 0.0 -15.534 -15.254668 0.0 0.0
                                -1.3334372 -0.29498684 0.0 0.0 -17.45947 7.0243444 0.0 0.0 -1.2406133
                                0.26902464 0.0 0.0 -1.2672352 -0.0755987 0.0 0.0 -13.125837 9.8105 0.0 0.0
                                -1.3106065 -0.2191964 0.0 0.0 -1.3258954 0.102836624 0.0 0.0 -181.7819
                                81.844025 0.0 0.0 -1.2925142 -0.33344325 0.0 0.0 -15.082613 -1.8676947 0.0
                                0.0 -189.71657 61.884632 0.0 0.0 -1.2036227 -0.58340764 0.0 0.0 -1.2384773
                                -0.39177695 0.0 0.0 -16.333843 -1.7729645 0.0 0.0 -13.430121 -9.074613 0.0
                                0.0 -1.271236 -0.39418292 0.0 0.0 -198.66971 22.598192 0.0 0.0 -1.1454765
                                0.6512869 0.0 0.0 -1.2340523 -0.095250696 0.0 0.0 -13.779557 -4.790319 0.0
                                0.0 -15.837858 -6.6214485 0.0 0.0 -0.4771072 0.4512855 0.0 0.0 -161.42606
                                -118.66211 0.0 0.0 -35.1296 -9.031064 0.0 0.0 -142.09206 -154.35587 0.0 0.0
                                -143.96292 -139.61835 0.0 0.0 -13.702712 5.6356754 0.0 0.0 -1.0912923
                                -0.6944512 0.0 0.0 -16.170156 0.6157784 0.0 0.0 -1.2215302 -0.49086285 0.0
                                0.0 -1.2896794 -0.24557544 0.0 0.0 -179.16031 -162.04991 0.0 0.0 -14.777712
                                -10.940237 0.0 0.0 -15.8108015 5.355691 0.0 0.0 -196.17326 -49.799496 0.0 0.0
                                -198.32857 -8.120692 0.0 0.0 -17.600157 -3.4705484 0.0 0.0 -1.450038 0.098042
                                0.0 0.0 -18.015656 -1.938058 0.0 0.0 -1.1902426 -0.23048602 0.0 0.0
                                -14.647003 -1.6494536 0.0 0.0 -17.267252 -3.840264 0.0 0.0 -1.4438375
                                0.23043793 0.0 0.0 -170.31232 -108.11835 0.0 0.0 -0.73768425 -0.12525487 0.0
                                0.0 -1.4067315 0.19991054 0.0 0.0 -1.3788698 -0.49761033 0.0 0.0 -1.3981831
                                0.23003215 0.0 0.0 -15.413661 0.014245866 0.0 0.0 -14.479915 -2.7585797 0.0
                                0.0 -1.4827524 -0.2743902 0.0 0.0 -1.309217 0.1799814 0.0 0.0 -1.373501
                                -0.31378034 0.0 0.0 -250.73082 -89.795 0.0 0.0 -357.691 -3.5470567 0.0 0.0
                                -15.430046 -1.0897056 0.0 0.0 -16.622898 -6.1917253 0.0 0.0 -214.98744
                                118.33029 0.0 0.0 -284.03345 -50.197144 0.0 0.0 -15.42534 -6.4133554 0.0 0.0
                                -200.2592 138.83513 0.0 0.0 -1.4580011 0.51750857 0.0 0.0 -18.562893
                                -1.2253886 0.0 0.0 -229.99217 23.235308 0.0 0.0 -212.6956 3.7431753 0.0 0.0
                                -1.3460008 -0.11531526 0.0 0.0 -236.37012 52.108658 0.0 0.0 -174.10052
                                122.670105 0.0 0.0 -14.673315 1.3165954 0.0 0.0 -16.544666 -8.339519 0.0 0.0
                                -20.301075 0.6979019 0.0 0.0 -205.99892 -45.165024 0.0 0.0 -1.3581291
                                -0.14766622 0.0 0.0 -1.4083728 0.016561106 0.0 0.0 -1.2999933 -0.72794306 0.0
                                0.0 -17.401402 4.230903 0.0 0.0 -3298.7168 1798.5695 0.0 0.0 -1.5476549
                                0.1142045 0.0 0.0 -13.876175 -11.748521 0.0 0.0 -1.3535614 -0.05478648 0.0
                                0.0 -15.6000595 5.993556 0.0 0.0 -18.66901 -1.2931335 0.0 0.0 -257.807
                                -77.3847 0.0 0.0 -1.4708787 -0.2251019 0.0 0.0 -16.439129 3.169966 0.0 0.0
                                -1.3223919 -0.48629645 0.0 0.0 -2853.7397 281.2978 0.0 0.0 -10.907765
                                -14.338221 0.0 0.0 -15.940974 4.442052 0.0 0.0 -12.237846 11.410849 0.0 0.0
                                -1.5097184 -0.64841676 0.0 0.0 -188.56522 -85.47906 0.0 0.0 -1.3623167
                                -0.028542645 0.0 0.0 -1.3580694 0.52823955 0.0 0.0 -203.92989 21.780542 0.0
                                0.0 -224.78934 64.97087 0.0 0.0 -161.79724 156.39273 0.0 0.0 -1.5491655
                                -0.08657251 0.0 0.0 -23.326023 -15.289417 0.0 0.0 -15.509266 -1.7018098 0.0
                                0.0 -1.3609079 0.3703586 0.0 0.0 -16.724472 -0.6073241 0.0 0.0 -18.316666
                                5.0153933 0.0 0.0 -1.4523622 0.1720367 0.0 0.0 -17.7877 -1.0712559 0.0 0.0
                                -1.4146017 -0.3078049 0.0 0.0 -15.44659 10.389725 0.0 0.0 -17.572107
                                -6.560955 0.0 0.0 -1.3168297 -0.6723118 0.0 0.0 -271.85788 7.1670017 0.0 0.0
                                -3169.8987 -274.59894 0.0 0.0 -15.748835 -7.2505374 0.0 0.0 -233.07756
                                16.97117 0.0 0.0 -166.66747 121.5761 0.0 0.0 -217.08354 -22.86606 0.0 0.0
                                -1.4047797 0.43997735 0.0 0.0 -1.4196148 -0.39576513 0.0 0.0 -14.336531
                                -7.8544254 0.0 0.0 -16.628054 -0.2689391 0.0 0.0 -13.563106 6.195439 0.0 0.0
                                -15.854962 -7.7632723 0.0 0.0 -202.41727 -43.456734 0.0 0.0 -16.391306
                                -4.213624 0.0 0.0 -15.920696 5.6860495 0.0 0.0 -207.58214 -26.304996 0.0 0.0
                                -1.4421169 -0.36422524 0.0 0.0 -1.4226041 -0.056088153 0.0 0.0 -18.347897
                                3.5512648 0.0 0.0 -3816.0186 602.975 0.0 0.0 -1.5114757 0.045386985 0.0 0.0
                                -1.2839202 -0.15578847 0.0 0.0 -14.724311 -1.8196186 0.0 0.0 -194.40758
                                -157.01683 0.0 0.0 -1.4466009 0.052379575 0.0 0.0 -1.3927522 -0.504019 0.0
                                0.0 -1.3943794 -0.51542133 0.0 0.0 -209.8922 -58.471195 0.0 0.0 -180.3063
                                -155.18507 0.0 0.0 -1.3837123 0.12559955 0.0 0.0 -17.452898 -0.4130066 0.0
                                0.0 -17.795822 6.304599 0.0 0.0 -1.4076936 0.31666836 0.0 0.0 -1.2515682
                                -0.80097926 0.0 0.0 -1.3807276 -0.042609364 0.0 0.0 -244.65 -152.77803 0.0
                                0.0 -1.3118095 -0.041592363 0.0 0.0 -17.279068 -5.4915743 0.0 0.0 -2771.1265
                                -1023.55695 0.0 0.0 -1.2086827 -0.7938109 0.0 0.0 -186.64186 96.237854 0.0
                                0.0 -1.4218588 -0.05548741 0.0 0.0 -1.1374803 -0.18691386 0.0 0.0 -227.6062
                                -63.67681 0.0 0.0 -1.1203549 -0.6334531 0.0 0.0 -1.4355867 -0.9274795 0.0 0.0
                                -1.3914311 0.30164987 0.0 0.0 -16.050198 -9.833053 0.0 0.0 -1.1482213
                                -0.79797095 0.0 0.0 -230.57956 -65.0518 0.0 0.0 -1.2818071 0.025111623 0.0
                                0.0 -1.2789271 -0.9358467 0.0 0.0 -249.26929 46.355885 0.0 0.0 -3263.4219
                                -1027.7125 0.0 0.0 -18.127804 -5.483777 0.0 0.0 -182.84157 -151.00714 0.0 0.0
                                -7.239398 -1.0988623 0.0 0.0 -14.019778 -6.600809 0.0 0.0 -1.3338673
                                -0.61587036 0.0 0.0 -17.997066 -4.9356065 0.0 0.0 -1.4577615 -0.3095393 0.0
                                0.0 -4024.1914 510.37213 0.0 0.0 -1.3924158 0.19547951 0.0 0.0 -1.4861157
                                0.019494422 0.0 0.0 -187.26976 96.06295 0.0 0.0 -17.871447 -5.9475274 0.0 0.0
                                -1.4459945 0.30115336 0.0 0.0 -1.2436398 -0.3248043 0.0 0.0 -1.0244737
                                -0.8096025 0.0 0.0 -1.8215686 -0.61559814 0.0 0.0 -222.07811 19.457277 0.0
                                0.0 -3964.3987 -240.67917 0.0 0.0 -234.51749 57.08645 0.0 0.0 -2721.6604
                                -1582.2262 0.0 0.0 -230.58868 107.837456 0.0 0.0 -16.594316 -0.49815053 0.0
                                0.0 -1.437078 -0.034197003 0.0 0.0 -1.2030905 -0.8134292 0.0 0.0 -275.9354
                                -83.99044 0.0 0.0 -15.064433 1.2092353 0.0 0.0 -13.38523 12.270939 0.0 0.0
                                -1.423968 -0.29433036 0.0 0.0 -1.2971064 -0.57440394 0.0 0.0 -285.11295
                                -119.75305 0.0 0.0 -1.3298742 -0.06350956 0.0 0.0 -200.52477 74.63114 0.0 0.0
                                -16.95746 9.939358 0.0 0.0 -19.223167 5.127934 0.0 0.0 -3146.2466 398.3177
                                0.0 0.0 -206.90964 81.476875 0.0 0.0 -1.3934753 0.50054073 0.0 0.0 -227.90034
                                91.65005 0.0 0.0 -14.192773 -9.340534 0.0 0.0 -1.3045976 -0.45675096 0.0 0.0
                                -1.4454467 -0.0302471 0.0 0.0 -1.3855686 0.45397043 0.0 0.0 -1.5103794
                                -0.2841037 0.0 0.0 -237.93996 24.967075 0.0 0.0 -1.3516105 -0.4180983 0.0 0.0
                                -1.4451989 -0.10297311 0.0 0.0 -16.847292 -5.335315 0.0 0.0 -226.42572
                                88.99141 0.0 0.0 -176.55614 -162.23596 0.0 0.0 -1.4167738 -0.15070859 0.0 0.0
                                -15.734685 -2.3153443 0.0 0.0 -1.430555 -0.45089757 0.0 0.0 -18.89982
                                -8.774527 0.0 0.0 -17.386238 5.063908 0.0 0.0 -1.4494791 -0.32637554 0.0 0.0
                                -14.814311 -8.307929 0.0 0.0 -232.0589 -35.268753 0.0 0.0 -225.18153
                                72.987206 0.0 0.0 -212.94876 25.762682 0.0 0.0 -12.653906 8.0131235 0.0 0.0
                                -1.4206759 0.27482796 0.0 0.0 -1.3338985 0.6472293 0.0 0.0 -1.3372922
                                -0.6231218 0.0 0.0 -242.9344 -30.520935 0.0 0.0 -244.95766 -1.5565975 0.0 0.0
                                -1.4322318 0.11001378 0.0 0.0 -16.986464 1.1221738 0.0 0.0 -233.92679
                                -28.335625 0.0 0.0 -1.2083608 -0.76314527 0.0 0.0 -17.048222 0.3272371 0.0
                                0.0 -1.3892436 -0.31000596 0.0 0.0 -1.8029487 -0.7699915 0.0 0.0 -1.3704121
                                -0.18705349 0.0 0.0 -248.96785 -108.90041 0.0 0.0 -1.451447 0.21722656 0.0
                                0.0 -192.0024 -49.047047 0.0 0.0 -18.537647 -4.899882 0.0 0.0 -1.4550773
                                0.053114533 0.0 0.0 -15.64065 -5.412188 0.0 0.0 -1.3625323 0.010247715 0.0
                                0.0 -14.797321 -8.264939 0.0 0.0 -1.3773438 0.26837978 0.0 0.0 -1.448391
                                0.29906452 0.0 0.0 -159.92824 -174.498 0.0 0.0 -286.39798 -93.87643 0.0 0.0
                                -23.026543 -4.3669777 0.0 0.0 -0.82666844 0.8573183 0.0 0.0 -1.4204891
                                -0.31941262 0.0 0.0 -1.4116162 -0.33844027 0.0 0.0 -14.181764 -4.6500053 0.0
                                0.0 -210.7957 -53.92226 0.0 0.0 -19.892279 -1.3163749 0.0 0.0 -1.3196605
                                0.6354317 0.0 0.0 -15.339982 7.9349585 0.0 0.0 -17.416306 -10.25156 0.0 0.0
                                -16.127186 6.378449 0.0 0.0 -280.06015 69.00033 0.0 0.0 -19.155727 3.3415363
                                0.0 0.0 -1.4382414 -0.057121146 0.0 0.0 -4144.059 -155.32648 0.0 0.0
                                -225.44647 -27.267502 0.0 0.0 -22.234741 6.7484145 0.0 0.0 -15.978526
                                -6.7089624 0.0 0.0 -17.256172 1.4092656 0.0 0.0 -16.098402 -4.2044964 0.0 0.0
                                -13.546163 -10.424004 0.0 0.0 -17.44756 4.9224834 0.0 0.0 -1.3956099
                                -0.1192683 0.0 0.0 -247.115 25.323502 0.0 0.0 -18.957869 -3.6982849 0.0 0.0
                                -1.3215352 0.22951493 0.0 0.0 -204.23734 -145.2192 0.0 0.0 -1.5620594
                                -0.30234352 0.0 0.0 -1.4546288 0.15712303 0.0 0.0 -232.77136 -124.712654 0.0
                                0.0 -15.628722 -0.38360354 0.0 0.0 -1.420262 -0.10452157 0.0 0.0 -1.1818374
                                -0.7282349 0.0 0.0 -281.44012 -63.13638 0.0 0.0 -19.000166 3.6346164 0.0 0.0
                                -1.3701799 -0.3075858 0.0 0.0 -237.1681 76.89113 0.0 0.0 -218.13452
                                -6.3218465 0.0 0.0 -285.30246 42.393883 0.0 0.0 -1.2687097 0.38910505 0.0 0.0
                                -1.2059175 -0.5813683 0.0 0.0 -249.83156 119.58898 0.0 0.0 -1.0246807
                                0.599247 0.0 0.0 -22.951504 -8.20941 0.0 0.0 -17.012825 -2.9055054 0.0 0.0
                                -1.3299879 -0.14822368 0.0 0.0 -1.216603 -0.5593723 0.0 0.0 -17.04653
                                2.755176 0.0 0.0 -15.061859 -9.16637 0.0 0.0 -12.65539 -4.463944 0.0 0.0
                                -224.7345 -140.32938 0.0 0.0 -16.150188 -4.495339 0.0 0.0 -1.3391807
                                0.05191435 0.0 0.0 -0.87658715 -0.97364396 0.0 0.0 -15.08502 -7.536712 0.0
                                0.0 -1.1862581 -0.419165 0.0 0.0 -0.95273584 0.7758878 0.0 0.0 -16.774961
                                0.44576788 0.0 0.0 -1.4663787 -0.31730166 0.0 0.0 -16.453003 1.5758817 0.0
                                0.0 -1.2869182 -0.15950713 0.0 0.0 -1.333535 -0.02681723 0.0 0.0 -18.338842
                                -3.306719 0.0 0.0 -212.15688 -57.886517 0.0 0.0 -15.646071 7.4159155 0.0 0.0
                                -15.880165 12.504731 0.0 0.0 -218.00104 30.469906 0.0 0.0 -17.029495
                                2.8004365 0.0 0.0 -1.2247534 -0.54069394 0.0 0.0 -1.3300986 0.6513129 0.0 0.0
                                -1.2713189 0.34406188 0.0 0.0 -1.2859169 -0.33889252 0.0 0.0 -225.02379
                                -55.525135 0.0 0.0 -1.0749414 -0.673668 0.0 0.0 -178.9196 -129.17114 0.0 0.0
                                -228.21097 39.192413 0.0 0.0 -16.56244 3.010569 0.0 0.0 -1.3049369 -0.202115
                                0.0 0.0 -1.2289065 0.48096913 0.0 0.0 -1.3214147 -0.11203331 0.0 0.0
                                -1.1742235 -0.6195382 0.0 0.0 -19.698027 -0.15430875 0.0 0.0 -229.11183
                                -82.315605 0.0 0.0 -17.74928 -3.4984436 0.0 0.0 -250.73727 94.74004 0.0 0.0
                                -1.2893811 -0.363226 0.0 0.0 -1.3078922 0.26711714 0.0 0.0 -16.136133
                                -6.4411507 0.0 0.0 -16.81318 -3.7537222 0.0 0.0 -15.368338 4.473346 0.0 0.0
                                -143.1765 -183.40419 0.0 0.0 -229.74075 -37.29119 0.0 0.0 -14.847933
                                3.8153408 0.0 0.0 -14.980092 3.0930638 0.0 0.0 -282.1706 -129.8939 0.0 0.0
                                -21.658957 -5.409529 0.0 0.0 -281.96054 -16.221205 0.0 0.0 -255.3894
                                -25.70068 0.0 0.0 -216.39638 -51.080776 0.0 0.0 -18.5073 -1.7309318 0.0 0.0
                                -1.023345 -0.85761684 0.0 0.0 -1.3167095 0.23689358 0.0 0.0 -317.08316
                                170.07614 0.0 0.0 -0.72245246 0.038793437 0.0 0.0 -233.7213 -0.27910876 0.0
                                0.0 -243.36026 -30.795404 0.0 0.0 -17.599108 -6.047437 0.0 0.0 -14.706879
                                -8.355061 0.0 0.0 -1.4045709 0.13197654 0.0 0.0 -181.55396 -147.78154 0.0 0.0
                                -248.86382 106.00937 0.0 0.0 -1.1347823 0.82640535 0.0 0.0 -31.235048
                                -3.9163332 0.0 0.0 -1.1754963 -0.6450158 0.0 0.0 -1.1511568 0.80230296 0.0
                                0.0 -22.557661 -0.011429946 0.0 0.0 -270.9892 6.226372 0.0 0.0 -1.0715858
                                -0.7693626 0.0 0.0 -182.3482 -218.54034 0.0 0.0 -1.2347449 0.18671991 0.0 0.0
                                -1.3179336 -0.046199255 0.0 0.0 -249.0563 36.65561 0.0 0.0 -1.3332617
                                -0.08108395 0.0 0.0 -1.320097 0.13506033 0.0 0.0 -1.3315626 -0.11462711 0.0
                                0.0 -17.50691 -3.028574 0.0 0.0 -245.06763 30.8155 0.0 0.0 -1.2594807
                                -0.3729205 0.0 0.0 -1.2619221 -0.20451978 0.0 0.0 -1.2661653 -0.14918965 0.0
                                0.0 -14.739859 -4.4078403 0.0 0.0 -197.8814 -102.481674 0.0 0.0 -0.9777151
                                -0.7862793 0.0 0.0 -1.3144792 -0.16158502 0.0 0.0 -1.3369975 -0.094643 0.0
                                0.0 -15.317849 1.9043037 0.0 0.0 -1.2778882 0.17756677 0.0 0.0 -14.281667
                                9.965258 0.0 0.0 -235.21286 22.415482 0.0 0.0 -15.235251 2.4717584 0.0 0.0
                                -275.84686 -78.616806 0.0 0.0 -17.265594 -2.2912338 0.0 0.0 -1.2720652
                                0.0038121343 0.0 0.0 -17.189362 -3.4510794 0.0 0.0 -1.3025066 0.31168887 0.0
                                0.0 -14.103449 -7.1097016 0.0 0.0 -185.39291 -107.06286 0.0 0.0 -1.1407963
                                -0.578172 0.0 0.0 -20.730547 6.0665693 0.0 0.0 -0.89438546 -0.973065 0.0 0.0
                                -1.1938725 -0.5987112 0.0 0.0 -14.882958 -7.780355 0.0 0.0 -18.17161 2.292411
                                0.0 0.0 -15.853214 6.3001 0.0 0.0 -1.0305858 -0.12673095 0.0 0.0 -1.2006626
                                0.5901454 0.0 0.0 -188.52853 -181.6646 0.0 0.0 -1.2925841 0.03838695 0.0 0.0
                                -225.7054 -19.45832 0.0 0.0 -1.0756391 -0.22354779 0.0 0.0 -226.63757
                                -4.5507617 0.0 0.0 -1.3394383 0.054585226 0.0 0.0 -245.31174 47.774075 0.0
                                0.0 -1.3336463 -0.011419792 0.0 0.0 -1.264644 0.3382037 0.0 0.0 -1.1847165
                                -0.5239873 0.0 0.0 -1.094876 -0.630578 0.0 0.0 -11.04165 -8.95606 0.0 0.0
                                -16.893398 -4.9082136 0.0 0.0 -240.03969 71.60057 0.0 0.0 -0.97010833
                                0.566242 0.0 0.0 -14.79015 -4.0861382 0.0 0.0 -15.764616 2.5989006 0.0 0.0
                                -226.91255 17.657331 0.0 0.0 -1.1338619 -0.71662563 0.0 0.0 -1.0927956
                                -0.7729391 0.0 0.0 -15.188479 8.904238 0.0 0.0 -13.4107485 -11.369958 0.0 0.0
                                -1.5008941 -0.419562 0.0 0.0 -1.2071791 -0.55336154 0.0 0.0 -1.3797529
                                -0.7865213 0.0 0.0 -1.3341701 0.122259796 0.0 0.0 -0.74245226 -0.6226317 0.0
                                0.0 -1.2411551 -0.4148444 0.0 0.0 -1.5531404 0.21201907 0.0 0.0 -1.3717192
                                0.46021065 0.0 0.0 -238.09346 -29.49435 0.0 0.0 -21.747877 -1.7105175 0.0 0.0
                                -264.35574 11.791535 0.0 0.0 -1.2944906 -0.28296864 0.0 0.0 -33.782322
                                -1.0954818 0.0 0.0 -0.92953926 0.9622693 0.0 0.0 -222.31104 -91.408035 0.0
                                0.0 -1.3063138 -0.06681402 0.0 0.0 -214.22285 -81.15804 0.0 0.0 -1.3314708
                                -0.068451 0.0 0.0 -1.0907865 0.72144413 0.0 0.0 -13.871696 -6.341708 0.0 0.0
                                -1.3766832 -0.5998902 0.0 0.0 -240.71104 9.608994 0.0 0.0 -1.3020438
                                0.19949111 0.0 0.0 -1.1984849 -0.06507591 0.0 0.0 -1.2946593 -0.12451438 0.0
                                0.0 -1.3197689 -0.20968994 0.0 0.0 -16.459251 -6.5068736 0.0 0.0 -1.129737
                                -0.5025508 0.0 0.0 -1.3147593 -0.05222202 0.0 0.0 -1.1386594 -0.7029098 0.0
                                0.0 -17.301939 -3.7777395 0.0 0.0 -1.1333451 -0.36682624 0.0 0.0 -1.2892443
                                -0.14414516 0.0 0.0 -1.1249384 -0.7146542 0.0 0.0 -250.81523 -90.77111 0.0
                                0.0 -21.585602 -3.2074502 0.0 0.0 -1.265297 -0.35255468 0.0 0.0 -245.09113
                                -136.17723 0.0 0.0 -242.09467 7.1379294 0.0 0.0 -17.710285 -0.74591297 0.0
                                0.0 -17.231848 -7.7414446 0.0 0.0 -14.434235 -5.861173 0.0 0.0 -0.8112217
                                -1.029224 0.0 0.0 -1.2077619 -0.5592332 0.0 0.0 -17.693476 0.03394011 0.0 0.0
                                -260.14624 -106.60839 0.0 0.0 -1.2495979 -0.45733884 0.0 0.0 -252.9142
                                -33.17651 0.0 0.0 -16.686779 -4.3668523 0.0 0.0 -283.38867 84.2991 0.0 0.0
                                -0.9271372 -0.9618626 0.0 0.0 -230.39099 23.26094 0.0 0.0 -16.89062
                                -3.3232243 0.0 0.0 -231.40056 11.86303 0.0 0.0 -10.181577 -11.825761 0.0 0.0
                                -1.1782275 0.047503665 0.0 0.0 -235.78378 61.121784 0.0 0.0 -1.304324
                                -0.2542831 0.0 0.0 -1.1492391 0.15351264 0.0 0.0 -1.3008875 0.27486086 0.0
                                0.0 -21.019705 2.015544 0.0 0.0 -15.5334425 -2.0035121 0.0 0.0 -254.27974
                                -32.26104 0.0 0.0 -18.008608 -6.3200746 0.0 0.0 -1.208063 -0.38032266 0.0 0.0
                                -17.457249 -3.4128582 0.0 0.0 -17.020445 -3.4422925 0.0 0.0 -15.693504
                                -0.8870917 0.0 0.0 -21.201096 6.183928 0.0 0.0 -351.3178 -88.931915 0.0 0.0
                                -1.3390607 -0.008270309 0.0 0.0 -17.780838 0.19835179 0.0 0.0 -1.3105121
                                0.14017282 0.0 0.0 -14.097425 16.55808 0.0 0.0 -1.2010193 -0.5783225 0.0 0.0
                                -1.3789749 0.19430134 0.0 0.0 -282.76318 27.573612 0.0 0.0 -15.604463
                                1.787204 0.0 0.0 -14.244464 6.690546 0.0 0.0 -15.661424 -1.5860549 0.0 0.0
                                -338.0468 -252.32405 0.0 0.0 -13.436402 -8.086472 0.0 0.0 -1.2753834
                                0.39361006 0.0 0.0 -1.3150573 0.17438115 0.0 0.0 -20.762993 -4.557725 0.0 0.0
                                -1.4314154 0.114453115 0.0 0.0 -1.2075537 -0.42373464 0.0 0.0 -15.68411
                                -1.602002 0.0 0.0 -18.746803 -9.775556 0.0 0.0 -1.3403647 0.041372225 0.0 0.0
                                -1.3065782 -0.29045734 0.0 0.0 -24.159426 -1.7184292 0.0 0.0 -253.2048
                                -53.534252 0.0 0.0 -1.4802791 -0.41926578 0.0 0.0 -12.189696 9.975791 0.0 0.0
                                -16.3011 -2.7288518 0.0 0.0 -17.403456 -0.45464402 0.0 0.0 -1.052312
                                -0.79110444 0.0 0.0 -15.641101 -8.693444 0.0 0.0 -1.284056 0.3327002 0.0 0.0
                                -16.172768 -3.6332254 0.0 0.0 -17.60269 -2.9614058 0.0 0.0 -1.2619889
                                -0.34356752 0.0 0.0 -245.56436 -84.562 0.0 0.0 -14.964752 6.4716077 0.0 0.0
                                -14.921414 5.221881 0.0 0.0 -18.580524 -4.97711 0.0 0.0 -1.288426 0.060153235
                                0.0 0.0 -1.1318032 0.05360383 0.0 0.0 -1.3231676 0.21753958 0.0 0.0
                                -15.5981865 -4.986289 0.0 0.0 -1.3180544 -0.24796121 0.0 0.0 -223.56017
                                75.35613 0.0 0.0 -1.0075996 -0.8568191 0.0 0.0 -16.473959 1.4359723 0.0 0.0
                                -245.46217 87.86903 0.0 0.0 -17.510866 0.48330596 0.0 0.0 -1.4522254
                                -0.036166944 0.0 0.0 -19.155363 -6.399329 0.0 0.0 -1.4419571 -0.12676854 0.0
                                0.0 -272.45483 -94.67375 0.0 0.0 -16.938337 -3.9686697 0.0 0.0 -269.146
                                -103.70721 0.0 0.0 -19.888659 -3.4527345 0.0 0.0 -231.32649 -59.004253 0.0
                                0.0 -2.1292763 -0.23642838 0.0 0.0 -231.95285 -47.977283 0.0 0.0 -17.172398
                                -5.6999617 0.0 0.0 -13.896652 -14.827463 0.0 0.0 -17.833189 -8.30063 0.0 0.0
                                -284.33224 48.476032 0.0 0.0 -275.32245 -85.97855 0.0 0.0 -288.2224 11.071827
                                0.0 0.0 -208.05489 114.340904 0.0 0.0 -1.4297216 -0.13901281 0.0 0.0
                                -1.5992069 -0.046116903 0.0 0.0 -17.967783 4.47502 0.0 0.0 -257.7581
                                -50.434082 0.0 0.0 -16.013762 -12.765909 0.0 0.0 -282.1976 -59.659554 0.0 0.0
                                -20.250963 -0.9810318 0.0 0.0 -262.93274 -3.0649886 0.0 0.0 -1.3976518
                                -0.08597274 0.0 0.0 -17.644297 -5.2916036 0.0 0.0 -1.1522949 0.9194431 0.0
                                0.0 -232.16716 54.042923 0.0 0.0 -1.112601 -0.47714737 0.0 0.0 -1.3893367
                                0.2340288 0.0 0.0 -3556.4092 614.89575 0.0 0.0 -1.4296712 -0.06481635 0.0 0.0
                                -1.490724 0.28324723 0.0 0.0 -1.2994944 0.078854606 0.0 0.0 -265.68927
                                123.276405 0.0 0.0 -16.824993 -4.871016 0.0 0.0 -16.992369 5.875402 0.0 0.0
                                -1.4768807 -0.6195188 0.0 0.0 -1.4186387 0.3004124 0.0 0.0 -1.4359722
                                -0.12960109 0.0 0.0 -250.46716 23.554525 0.0 0.0 -230.2644 -72.35579 0.0 0.0
                                -0.9134797 -1.001343 0.0 0.0 -3624.3335 -211.59492 0.0 0.0 -1.4803274
                                -0.14077985 0.0 0.0 -19.493748 5.5648475 0.0 0.0 -282.98404 -55.810223 0.0
                                0.0 -202.9211 127.68143 0.0 0.0 -11.039265 -11.657511 0.0 0.0 -18.25918
                                2.7546134 0.0 0.0 -19.474426 0.755205 0.0 0.0 -1.1036719 -0.9805258 0.0 0.0
                                -13.3661785 -14.6182995 0.0 0.0 -17.874117 2.9834452 0.0 0.0 -225.69705
                                -113.603096 0.0 0.0 -241.4227 -74.61546 0.0 0.0 -1.3778734 -0.43226567 0.0
                                0.0 -17.023056 -4.679456 0.0 0.0 -235.28282 -98.4253 0.0 0.0 -1.4660206
                                -0.14372666 0.0 0.0 -645.6665 115.77651 0.0 0.0 -10.884975 -16.649694 0.0 0.0
                                -269.13083 -81.217155 0.0 0.0 -19.501528 -2.3001287 0.0 0.0 -1.9698302
                                0.101552784 0.0 0.0 -1.4664735 -0.25296327 0.0 0.0 -1.2717749 0.33263543 0.0
                                0.0 -15.53645 8.982461 0.0 0.0 -19.599384 1.3701879 0.0 0.0 -1.268889
                                0.28302944 0.0 0.0 -204.2013 -3.3445456 0.0 0.0 -22.45319 -2.9172328 0.0 0.0
                                -18.73091 -0.32544294 0.0 0.0 -288.4305 1.6080403 0.0 0.0 -0.8796579
                                -0.8706672 0.0 0.0 -20.59708 -2.5973039 0.0 0.0 -1.0156801 -0.81222236 0.0
                                0.0 -18.095991 -0.21079282 0.0 0.0 -19.777325 -6.5315413 0.0 0.0 -238.99644
                                38.941452 0.0 0.0 -240.28893 30.2791 0.0 0.0 -0.81051517 0.77544135 0.0 0.0
                                -16.378336 -7.0096517 0.0 0.0 -14.495755 15.9905 0.0 0.0 -1.4252837
                                0.27504146 0.0 0.0 -238.8992 -42.120773 0.0 0.0 -1.3223697 -0.21024896 0.0
                                0.0 -16.344017 -7.425023 0.0 0.0 -18.573229 2.7775931 0.0 0.0 -17.555616
                                -4.395509 0.0 0.0 -1.3507322 -0.3598374 0.0 0.0 -17.212662 4.562506 0.0 0.0
                                -1.0519327 -0.9769906 0.0 0.0 -20.809011 0.017628781 0.0 0.0 -16.36489
                                8.125559 0.0 0.0 -32.527668 3.0886781 0.0 0.0 -1.404592 0.047204476 0.0 0.0
                                -1.324976 0.14059159 0.0 0.0 -280.00266 -69.23334 0.0 0.0 -1.4536602
                                0.28621712 0.0 0.0 -191.87318 215.35884 0.0 0.0 -17.21708 -5.961535 0.0 0.0
                                -1.471039 -0.0797217 0.0 0.0 -32.226635 -4.2155128 0.0 0.0 -16.026152
                                -2.5477707 0.0 0.0 -251.04305 52.950798 0.0 0.0 -17.591188 -5.129043 0.0 0.0
                                -1.4383972 -0.37847096 0.0 0.0 -14.123902 -11.544268 0.0 0.0 -1.4930553
                                0.29275113 0.0 0.0 -1.0559125 -0.7301995 0.0 0.0 -16.757553 -2.7962682 0.0
                                0.0 -243.23026 -118.35459 0.0 0.0 -1.4678159 -0.12182688 0.0 0.0 -19.609602
                                1.5143971 0.0 0.0 -1.2113106 0.54235524 0.0 0.0 -1.2838116 -0.25815994 0.0
                                0.0 -1.2044985 0.22944377 0.0 0.0 -14.829243 10.64489 0.0 0.0 -18.12775
                                2.507257 0.0 0.0 -1.3408462 0.024792407 0.0 0.0 -19.315548 3.5193934 0.0 0.0
                                -1.3230165 0.42233676 0.0 0.0 -1.4151855 0.22606248 0.0 0.0 -238.21553
                                -59.17262 0.0 0.0 -17.843956 2.472605 0.0 0.0 -15.39477 8.912604 0.0 0.0
                                -1.3028095 0.09404256 0.0 0.0 -16.217024 0.52104956 0.0 0.0 -1.3707585
                                -0.44370252 0.0 0.0 -1.3911307 -0.5158809 0.0 0.0 -1.0748448 -0.83207786 0.0
                                0.0 -1.0169883 -0.7327901 0.0 0.0 -1.4605325 -0.21035774 0.0 0.0 -1.3893331
                                -0.17810223 0.0 0.0 -1.3383137 0.64657426 0.0 0.0 -1.2997391 0.41433385 0.0
                                0.0 -1.260141 -0.24484241 0.0 0.0 -16.24749 -5.255229 0.0 0.0 -233.58614
                                64.852806 0.0 0.0 -15.690634 -6.2724247 0.0 0.0 -231.60759 -84.6656 0.0 0.0
                                -279.31128 66.70705 0.0 0.0 -18.730892 -11.269794 0.0 0.0 -233.52734
                                -169.29185 0.0 0.0 -1.4749422 0.17838976 0.0 0.0 -18.78946 3.858955 0.0 0.0
                                -0.9371063 -0.95800984 0.0 0.0 -16.102598 8.02436 0.0 0.0 -252.22432
                                -63.723553 0.0 0.0 -1.4814558 -0.025187105 0.0 0.0 -1.3027773 0.25845683 0.0
                                0.0 -260.11237 -124.6447 0.0 0.0 -14.635063 10.511922 0.0 0.0 -1.2247524
                                -0.67982835 0.0 0.0 -17.419868 -3.1666822 0.0 0.0 -1.3313262 -0.4862804 0.0
                                0.0 -16.800194 -3.3466167 0.0 0.0 -245.2705 -36.18375 0.0 0.0 -1.3042699
                                -0.035463464 0.0 0.0 -1.1450912 0.64235085 0.0 0.0 -15.590784 -5.0008593 0.0
                                0.0 -0.42591503 -1.2196733 0.0 0.0 -26.519117 -4.388926 0.0 0.0 -247.98701
                                12.932085 0.0 0.0 -1.2426586 0.7173403 0.0 0.0 -0.99869955 -0.962141 0.0 0.0
                                -18.08596 -1.1072793 0.0 0.0 -287.9401 -16.889503 0.0 0.0 -1.3128377
                                -0.018066792 0.0 0.0 -1.4711748 -0.1142069 0.0 0.0 -15.434067 -14.101634 0.0
                                0.0 -262.97122 82.456924 0.0 0.0 -18.652697 6.806815 0.0 0.0 -286.81186
                                30.556383 0.0 0.0 -15.793994 3.8868463 0.0 0.0 -16.492508 7.2954774 0.0 0.0
                                -1.4112904 -0.2348398 0.0 0.0 -1.4657462 0.21647121 0.0 0.0 -1.461476
                                -0.2837192 0.0 0.0 -1.3809824 -0.51566404 0.0 0.0 -1.4701585 -0.21804807 0.0
                                0.0 -16.471998 5.0842953 0.0 0.0 -1.3807564 -0.32005277 0.0 0.0 -249.56493
                                -11.865614 0.0 0.0 -276.05154 19.977411 0.0 0.0 -288.19058 -11.871191 0.0 0.0
                                -16.358799 -0.84362215 0.0 0.0 -250.00061 -5.8559585 0.0 0.0 -17.143469
                                2.1241608 0.0 0.0 -15.024772 -5.690117 0.0 0.0 -283.28992 17.92784 0.0 0.0
                                -1.3407845 -0.5229286 0.0 0.0 -1.109506 -0.84159017 0.0 0.0 -1.3845719
                                0.22417116 0.0 0.0 -16.392933 0.81933147 0.0 0.0 -4541.33 2137.365 0.0 0.0
                                -1.3206578 -0.6183132 0.0 0.0 -250.5366 13.960568 0.0 0.0 -1.3084149
                                0.18019432 0.0 0.0 -273.41068 -87.19034 0.0 0.0 -200.99525 150.29123 0.0 0.0
                                -246.15947 49.82644 0.0 0.0 -16.717442 4.5174284 0.0 0.0 -250.73462 16.908674
                                0.0 0.0 -16.447914 -0.50239927 0.0 0.0 -1.4859459 0.06495378 0.0 0.0
                                -18.354883 -0.55057603 0.0 0.0 -251.45729 -141.29395 0.0 0.0 -1.2455252
                                -0.09700633 0.0 0.0 -1.3474654 0.47484577 0.0 0.0 -17.91928 4.1673646 0.0 0.0
                                -17.673306 -5.140206 0.0 0.0 -4033.311 855.5753 0.0 0.0 -1.4832429
                                0.082195394 0.0 0.0 -717.4319 -186.7595 0.0 0.0 -1.4083918 -0.6013227 0.0 0.0
                                -1.301366 0.19134532 0.0 0.0 -1.4469131 0.35012168 0.0 0.0 -19.343327
                                4.5997915 0.0 0.0 -19.034548 2.2407296 0.0 0.0 -288.41373 -3.5017436 0.0 0.0
                                -1.4483949 -0.11038079 0.0 0.0 -17.932514 -1.1090329 0.0 0.0 -240.54445
                                77.60552 0.0 0.0 -15.783623 -9.959444 0.0 0.0 -1.3645421 -0.42976204 0.0 0.0
                                -1.3847444 -0.31751353 0.0 0.0 -19.06377 -7.1924314 0.0 0.0 -1.3136587
                                -0.33854076 0.0 0.0 -4275.597 -920.3552 0.0 0.0 -1.4409899 0.26734927 0.0 0.0
                                -1.3259965 -0.66775006 0.0 0.0 -574.197 -54.911407 0.0 0.0 -21.199068
                                -0.57204366 0.0 0.0 -299.12558 16.162218 0.0 0.0 -18.299665 -3.036148 0.0 0.0
                                -1.6206641 0.31263816 0.0 0.0 -16.110106 -7.9214582 0.0 0.0 -1.4198556
                                -0.44325936 0.0 0.0 -285.67767 39.78699 0.0 0.0 -15.683402 5.220582 0.0 0.0
                                -1.3112799 -0.2966358 0.0 0.0 -0.982057 -1.0566449 0.0 0.0 -1.1885122
                                -0.48445097 0.0 0.0 -277.7219 77.88009 0.0 0.0 -330.9947 -10.97623 0.0 0.0
                                -248.84355 -53.3001 0.0 0.0 -0.9633953 0.13666774 0.0 0.0 -248.65251
                                54.154903 0.0 0.0 -17.827534 -10.729689 0.0 0.0 -15.3322 5.946152 0.0 0.0
                                -21.236525 7.3441653 0.0 0.0 -1.1319506 -0.85207087 0.0 0.0 -245.71059
                                -108.202774 0.0 0.0 -198.39299 -160.12706 0.0 0.0 -4378.7637 -1593.5891 0.0
                                0.0 -1.3983577 -0.08690402 0.0 0.0 -1.3191402 -0.4704103 0.0 0.0 -0.8423944
                                -1.285 0.0 0.0 -1.4299328 0.058708027 0.0 0.0 -1.1126947 -0.3893451 0.0 0.0
                                -1.0365897 0.8727683 0.0 0.0 -281.70212 61.95701 0.0 0.0 -1.6710159 0.4606011
                                0.0 0.0 -1.3940557 -0.09932414 0.0 0.0 -219.43413 -158.289 0.0 0.0 -1.3719695
                                0.12998313 0.0 0.0 -253.61436 -132.40913 0.0 0.0 -252.8686 40.44867 0.0 0.0
                                -22.588768 -8.56362 0.0 0.0 -17.614618 7.5070415 0.0 0.0 -271.7212 -96.759186
                                0.0 0.0 -12.942551 -11.292795 0.0 0.0 -238.27477 -95.048615 0.0 0.0
                                -1.4230684 -0.20506781 0.0 0.0 -237.83388 -96.24589 0.0 0.0 -1.3693403
                                0.34465605 0.0 0.0 -331.6583 -36.908928 0.0 0.0 -1.2958326 -0.46273398 0.0
                                0.0 -20.460396 -0.15085922 0.0 0.0 -256.1419 -132.61246 0.0 0.0 -283.7271
                                51.900574 0.0 0.0 -286.2331 35.572033 0.0 0.0 -1.3270799 0.6681947 0.0 0.0
                                -452.67084 -62.436302 0.0 0.0 -0.8713272 -1.1526059 0.0 0.0 -226.66135
                                -77.86881 0.0 0.0 -8896.194 -4029.665 0.0 0.0 -1.372386 -0.36643654 0.0 0.0
                                -257.02396 130.89474 0.0 0.0 -3988.4097 -724.46875 0.0 0.0 -14.365706
                                -10.090234 0.0 0.0 -288.3861 5.3106494 0.0 0.0 -245.5746 -78.930145 0.0 0.0
                                -264.7694 -49.649178 0.0 0.0 -1.4297972 -0.2841072 0.0 0.0 -1.2752188
                                -0.2690546 0.0 0.0 -1.3866587 0.47309315 0.0 0.0 -18.519283 2.1341956 0.0 0.0
                                -16.648558 -5.642282 0.0 0.0 -1.2304524 -0.797097 0.0 0.0 -1.408934
                                -0.39776096 0.0 0.0 -17.401697 -9.559706 0.0 0.0 -269.54776 -39.80494 0.0 0.0
                                -299.43878 -224.68736 0.0 0.0 -272.6542 5.207489 0.0 0.0 -220.79533
                                -196.75726 0.0 0.0 -1.480171 0.04176091 0.0 0.0 -19.994362 -6.139277 0.0 0.0
                                -288.50662 -107.36387 0.0 0.0 -1.3971689 -0.502391 0.0 0.0 -14.626359
                                -4.0135922 0.0 0.0 -195.11053 -157.86641 0.0 0.0 -263.0859 -118.23945 0.0 0.0
                                -323.0884 -103.66155 0.0 0.0 -1.758868 0.50305927 0.0 0.0 -14.921157
                                7.3269567 0.0 0.0 -258.31592 127.84053 0.0 0.0 -19.774834 -8.629369 0.0 0.0
                                -1.3593043 -0.23560174 0.0 0.0 -16.29788 2.555162 0.0 0.0 -1.2137415
                                -0.5326898 0.0 0.0 -18.099276 -5.5783744 0.0 0.0 -1.3271897 0.5623042 0.0 0.0
                                -1.0745643 0.7459382 0.0 0.0 -18.183271 4.9789333 0.0 0.0 -1.3743778
                                0.24134102 0.0 0.0 -261.78897 -5.877629 0.0 0.0 -3372.0725 2369.4104 0.0 0.0
                                -274.51642 11.293625 0.0 0.0 -245.22128 88.58823 0.0 0.0 -288.31653
                                -8.2665415 0.0 0.0 -1.3537941 -0.36417612 0.0 0.0 -255.50816 53.373962 0.0
                                0.0 -307.52707 4.671614 0.0 0.0 -17.265856 6.642412 0.0 0.0 -225.2991
                                -161.8571 0.0 0.0 -0.3670741 -0.067171596 0.0 0.0 -1.4813262 -0.1557438 0.0
                                0.0 -1.1217479 -0.71707547 0.0 0.0 -245.0526 -129.81694 0.0 0.0 -401.04996
                                -187.61597 0.0 0.0 -266.23868 -71.69349 0.0 0.0 -17.673952 -6.799624 0.0 0.0
                                -14.7225685 -3.452257 0.0 0.0 -4373.4507 95.72288 0.0 0.0 -299.55817 6.591553
                                0.0 0.0 -20.557377 4.745827 0.0 0.0 -15.052255 -3.9675932 0.0 0.0 -17.853552
                                4.005493 0.0 0.0 -331.21555 -88.90616 0.0 0.0 -17.681673 -0.67977303 0.0 0.0
                                -1.4124299 -0.10680739 0.0 0.0 -11.213386 14.964326 0.0 0.0 -20.503153
                                -5.7388997 0.0 0.0 -1.3684962 -0.2315796 0.0 0.0 -1.4332699 0.17393085 0.0
                                0.0 -1.3252777 -0.2082006 0.0 0.0 -16.574493 2.0390449 0.0 0.0 -1.3051853
                                -0.3555639 0.0 0.0 -22.569862 1.1185046 0.0 0.0 -0.98420197 0.46774346 0.0
                                0.0 -18.694525 -3.1501055 0.0 0.0 -1.4311299 -0.32699633 0.0 0.0 -16.51765
                                -3.2143123 0.0 0.0 -23.795717 -5.847411 0.0 0.0 -17.928383 -15.543467 0.0 0.0
                                -24.1371 -1.8876387 0.0 0.0 -15.350354 1.7422134 0.0 0.0 -1.4289308
                                -0.47899845 0.0 0.0 -1.1646254 0.59415114 0.0 0.0 -1.3736719 0.45898604 0.0
                                0.0 -1.2995453 0.5372908 0.0 0.0 -1.4146168 0.45160085 0.0 0.0 -18.192259
                                3.1180863 0.0 0.0 -1.3603805 0.41695312 0.0 0.0 -1.4563178 -0.2725533 0.0 0.0
                                -1.253345 0.45204002 0.0 0.0 -281.4543 -74.15905 0.0 0.0 -1.423504 0.12876058
                                0.0 0.0 -272.11624 95.64256 0.0 0.0 -262.29105 119.99229 0.0 0.0 -1.4533534
                                0.22922781 0.0 0.0 -4196.8364 -445.97644 0.0 0.0 -329.2556 -111.57512 0.0 0.0
                                -1.2649614 0.20028228 0.0 0.0 -1.4843882 0.025341658 0.0 0.0 -13.983218
                                -8.684694 0.0 0.0 -1.182442 -0.8911824 0.0 0.0 -1.2845354 -0.40336475 0.0 0.0
                                -16.920277 -12.096254 0.0 0.0 -139.66376 -89.26403 0.0 0.0 -1.4689971
                                0.15539813 0.0 0.0 -262.8431 24.741251 0.0 0.0 -280.3576 67.78171 0.0 0.0
                                -1.4857619 -0.10114829 0.0 0.0 -1.339033 -0.63566774 0.0 0.0 -28.299435
                                2.0725904 0.0 0.0 -1.017215 -0.70320356 0.0 0.0 -1.4150745 0.19875123 0.0 0.0
                                -266.3254 -45.086304 0.0 0.0 -13.200539 -11.75611 0.0 0.0 -15.596682
                                -6.6239233 0.0 0.0 -13.594913 -11.369915 0.0 0.0 -1.2622374 0.2714827 0.0 0.0
                                -1.4037517 0.47125316 0.0 0.0 -265.34476 -24.845003 0.0 0.0 -1.1333282
                                0.09672776 0.0 0.0 -16.916996 -0.7033125 0.0 0.0 -1.5012808 -0.14895093 0.0
                                0.0 -1.2819191 -0.6512047 0.0 0.0 -4586.0547 1225.8838 0.0 0.0 -1.4111134
                                -0.19818583 0.0 0.0 -18.841045 -0.28351203 0.0 0.0 -14.081692 -9.44658 0.0
                                0.0 -279.56415 70.98338 0.0 0.0 -245.93617 -36.402508 0.0 0.0 -20.501877
                                5.2022886 0.0 0.0 -477.71362 -51.682182 0.0 0.0 -1.58998 0.12312277 0.0 0.0
                                -1.6618661 0.05722589 0.0 0.0 -1.4761496 -0.18707325 0.0 0.0 -1.237229
                                -0.8001903 0.0 0.0 -20.554077 3.0439618 0.0 0.0 -21.02135 -3.8642335 0.0 0.0
                                -22.014261 -15.907727 0.0 0.0 -1.4277636 0.30875695 0.0 0.0 -274.87314
                                -66.117325 0.0 0.0 -248.6411 -63.002228 0.0 0.0 -11.973563 -13.100932 0.0 0.0
                                -19.234396 -0.1013769 0.0 0.0 -16.246777 -7.558817 0.0 0.0 -16.479677
                                3.7851913 0.0 0.0 -14.239147 -12.282181 0.0 0.0 -288.29898 8.857619 0.0 0.0
                                -19.0929 -8.7438755 0.0 0.0 -12.444065 -16.343632 0.0 0.0 -1.3692069
                                0.26604283 0.0 0.0 -1.4278039 -0.38852656 0.0 0.0 -267.9689 127.12525 0.0 0.0
                                -453.2964 74.20687 0.0 0.0 -46.07875 -2.2318473 0.0 0.0 -4001.0166 -1651.902
                                0.0 0.0 -16.273767 -14.636212 0.0 0.0 -15.052537 6.082396 0.0 0.0 -174.59946
                                -205.18036 0.0 0.0 -1.4601686 -0.28171375 0.0 0.0 -236.86136 128.5937 0.0 0.0
                                -1.3852606 0.5244995 0.0 0.0 -1.4071151 -0.43141675 0.0 0.0 -266.73453
                                109.76079 0.0 0.0 -282.59933 34.464027 0.0 0.0 -1.2906488 0.71338385 0.0 0.0
                                -261.61212 -67.21261 0.0 0.0 -4436.741 -1168.9932 0.0 0.0 -1.388172
                                0.08754115 0.0 0.0 -186.85641 216.1319 0.0 0.0 -1.3198396 0.4905504 0.0 0.0
                                -1.3706129 -0.32788634 0.0 0.0 -1.4869503 0.055086717 0.0 0.0 -1.1940087
                                0.33017868 0.0 0.0 -21.378555 -1.2708856 0.0 0.0 -1.356273 0.20482148 0.0 0.0
                                -287.93542 16.968697 0.0 0.0 -4820.2705 -618.9566 0.0 0.0 -18.77852
                                -3.8602808 0.0 0.0 -1.3737861 0.4781106 0.0 0.0 -18.22466 5.5726533 0.0 0.0
                                -1.2019614 -0.8007753 0.0 0.0 -18.888237 3.9776518 0.0 0.0 -1.4376377
                                -0.345274 0.0 0.0 -248.7561 -109.69065 0.0 0.0 -1.1385878 -0.7782136 0.0 0.0
                                -234.07828 -168.52927 0.0 0.0 -0.7644069 -1.196138 0.0 0.0 -277.64847
                                78.14142 0.0 0.0 -10035.192 -4164.611 0.0 0.0 -1.2937375 -0.2965984 0.0 0.0
                                -15.564593 -7.0971217 0.0 0.0 -1.4815459 -0.12655218 0.0 0.0 -30.139837
                                -4.7246895 0.0 0.0 -200.59914 -207.25523 0.0 0.0 -1.2987789 0.27351144 0.0
                                0.0 -19.357702 1.5157706 0.0 0.0 -17.809795 1.5262278 0.0 0.0 -12.73578
                                -17.289728 0.0 0.0 -1.3267324 -0.044904273 0.0 0.0 -1.2328215 -0.82415724 0.0
                                0.0 -0.8732629 -0.41316727 0.0 0.0 -287.7761 -19.484896 0.0 0.0 -1.4844979
                                -0.12072356 0.0 0.0 -18.601112 -12.394774 0.0 0.0 -1.3714345 -0.5784761 0.0
                                0.0 -1.3451602 -0.6131637 0.0 0.0 -1.3527173 -0.26627514 0.0 0.0 -15.977939
                                8.351125 0.0 0.0 -1.36506 0.18985836 0.0 0.0 -1.4382278 0.2099748 0.0 0.0
                                -1.4360597 0.3181859 0.0 0.0 -1.4717535 -0.06235082 0.0 0.0 -20.816458
                                4.485816 0.0 0.0 -21.370497 -2.958188 0.0 0.0 -271.01443 -98.72147 0.0 0.0
                                -265.98898 111.55545 0.0 0.0 -272.75372 -136.42703 0.0 0.0 -4191.6914
                                1285.0502 0.0 0.0 -1.3225954 -0.83843184 0.0 0.0 -18.967598 -4.115058 0.0 0.0
                                -19.422653 -8.484396 0.0 0.0 -16302.063 -11124.798 0.0 0.0 -27.009706
                                0.49979565 0.0 0.0 -1.314481 -0.26788908 0.0 0.0 -1.3066614 -0.1776758 0.0
                                0.0 -18.473333 5.5302596 0.0 0.0 -1.2082478 0.56946236 0.0 0.0 -1.3809538
                                0.06644945 0.0 0.0 -1.2139436 -0.48257726 0.0 0.0 -210.52513 -52.737286 0.0
                                0.0 -1.1538209 0.57928514 0.0 0.0 -317.97546 49.14366 0.0 0.0 -275.02264
                                11.118975 0.0 0.0 -17.666397 -7.749445 0.0 0.0 -18.893269 -4.2818427 0.0 0.0
                                -446.30374 12.294446 0.0 0.0 -1.1758983 0.83422476 0.0 0.0 -16.955307
                                6.126291 0.0 0.0 -1.2889528 -0.31519926 0.0 0.0 -1.3739065 0.177713 0.0 0.0
                                -1.2550426 -0.47330046 0.0 0.0 -0.9377242 0.41059107 0.0 0.0 -1.3074625
                                -0.08246108 0.0 0.0 -1.2877532 0.20319009 0.0 0.0 -1.3162502 -0.23806274 0.0
                                0.0 -1.3065199 0.29564726 0.0 0.0 -17.882898 -6.427767 0.0 0.0 -261.02893
                                -87.44641 0.0 0.0 -1.2643644 -0.419884 0.0 0.0 -1.3018554 0.29425853 0.0 0.0
                                -7.3614793 -17.893833 0.0 0.0 -18.564798 3.9011297 0.0 0.0 -287.99182
                                109.86208 0.0 0.0 -23.680466 7.4530697 0.0 0.0 -233.88408 -175.26035 0.0 0.0
                                -284.92902 -65.442184 0.0 0.0 -17.38704 -7.4305563 0.0 0.0 -1.3374848
                                -0.025505282 0.0 0.0 -1.2340913 -0.1919935 0.0 0.0 -1.3227268 0.20017344 0.0
                                0.0 -14.212359 -12.967208 0.0 0.0 -14.195967 -9.6220045 0.0 0.0 -15.149546
                                -9.893568 0.0 0.0 -277.3459 -13.102082 0.0 0.0 -1.3088318 0.10498174 0.0 0.0
                                -550.9515 -213.09482 0.0 0.0 -271.22647 5.3753085 0.0 0.0 -17.564861
                                7.3474636 0.0 0.0 -16.55364 -9.5271225 0.0 0.0 -272.76126 -54.34483 0.0 0.0
                                -289.98282 -187.22717 0.0 0.0 -387.46613 -363.9096 0.0 0.0 -0.97917235
                                0.95213526 0.0 0.0 -1.1165287 -0.54196906 0.0 0.0 -1.0835813 0.030117378 0.0
                                0.0 -1.3166875 -0.17249668 0.0 0.0 -1.2505006 0.4765688 0.0 0.0 -278.4839
                                -12.085021 0.0 0.0 -15.150663 -11.918512 0.0 0.0 -29.35172 -1.0960855 0.0 0.0
                                -294.2965 -9.820975 0.0 0.0 -1.3275052 0.13537599 0.0 0.0 -1.165436
                                0.33949506 0.0 0.0 -316.88205 45.88054 0.0 0.0 -18.629213 5.5897484 0.0 0.0
                                -0.98124576 0.8794154 0.0 0.0 -42.015972 -8.709561 0.0 0.0 -17.503487
                                -14.618803 0.0 0.0 -231.48155 134.63591 0.0 0.0 -1.0046382 -0.04070769 0.0
                                0.0 -1.0307039 -0.84330726 0.0 0.0 -339.90485 137.71794 0.0 0.0 -21.212688
                                6.8823977 0.0 0.0 -1.1896367 -0.58180964 0.0 0.0 -25.04554 -0.7633901 0.0 0.0
                                -14.563703 -9.083878 0.0 0.0 -28.739374 6.6115966 0.0 0.0 -1.3305476
                                0.040171083 0.0 0.0 -18.068184 -1.5085113 0.0 0.0 -20.17203 1.8482443 0.0 0.0
                                -1.4014037 0.020113587 0.0 0.0 -19.146906 -2.4987493 0.0 0.0 -1.2022418
                                0.5859167 0.0 0.0 -1.2370337 -0.44995892 0.0 0.0 -20.462893 1.4672511 0.0 0.0
                                -18.68101 -5.7787294 0.0 0.0 -1.2705985 -0.4283266 0.0 0.0 -17.932268
                                7.4563355 0.0 0.0 -1.249622 -0.47479844 0.0 0.0 -1.1490242 -0.67166066 0.0
                                0.0 -1.1065617 0.28279775 0.0 0.0 -1.0707645 -0.74775213 0.0 0.0 -15.846424
                                -3.41556 0.0 0.0 -294.7025 -107.90726 0.0 0.0 -1.2356311 0.49732065 0.0 0.0
                                -1.149899 -0.47287494 0.0 0.0 -0.5794842 -1.1883578 0.0 0.0 -1.3101604
                                0.054327354 0.0 0.0 -20.894808 -4.7828755 0.0 0.0 -15.862062 -6.8312874 0.0
                                0.0 -332.0152 -3.8504336 0.0 0.0 -388.9194 39.583717 0.0 0.0 -1.1828717
                                0.5924634 0.0 0.0 -0.81114 -0.6007373 0.0 0.0 -1.165547 0.35612434 0.0 0.0
                                -19.053288 1.395818 0.0 0.0 -1.3365855 -0.05442612 0.0 0.0 -1.3093033
                                0.26173386 0.0 0.0 -1.7275529 0.15167774 0.0 0.0 -0.97819924 0.9130173 0.0
                                0.0 -1.41261 0.26588213 0.0 0.0 -17.291954 0.17196096 0.0 0.0 -1.2729999
                                0.010772608 0.0 0.0 -1.1942446 0.5256452 0.0 0.0 -492.66412 -151.28159 0.0
                                0.0 -1.125848 -0.5618976 0.0 0.0 -1.2240415 0.53725016 0.0 0.0 -1.2878419
                                0.35837346 0.0 0.0 -275.58255 154.93303 0.0 0.0 -1.2424921 -0.36840653 0.0
                                0.0 -1.3371055 -0.061593886 0.0 0.0 -19.190287 -0.36273652 0.0 0.0 -1.0006934
                                -0.24720965 0.0 0.0 -1.2275013 0.49278662 0.0 0.0 -1.2951903 0.26940677 0.0
                                0.0 -313.10785 -117.834305 0.0 0.0 -23.609661 3.961214 0.0 0.0 -207.39302
                                194.3608 0.0 0.0 -19.062052 7.3057265 0.0 0.0 -1.2982496 -0.78807294 0.0 0.0
                                -389.56195 63.00791 0.0 0.0 -409.80426 160.91743 0.0 0.0 -14.003271 3.9231758
                                0.0 0.0 -1.2904055 -0.23558445 0.0 0.0 -256.26816 -157.4275 0.0 0.0 -296.4982
                                49.924084 0.0 0.0 -20.110233 -3.3343494 0.0 0.0 -21.120237 4.4452667 0.0 0.0
                                -366.3066 149.52196 0.0 0.0 -18.254292 -9.192015 0.0 0.0 -228.4832 -170.7836
                                0.0 0.0 -18.0068 -3.4717307 0.0 0.0 -1.2348684 -0.2992847 0.0 0.0 -1.3347136
                                -0.016422726 0.0 0.0 -1.2903806 -0.24695961 0.0 0.0 -16.495401 -5.534605 0.0
                                0.0 -1.2731378 -0.3948993 0.0 0.0 -1.3035823 -0.2657233 0.0 0.0 -301.71136
                                12.254708 0.0 0.0 -1.317284 -0.22820866 0.0 0.0 -1.4691045 0.18304136 0.0 0.0
                                -282.11365 47.74646 0.0 0.0 -21.293617 -3.7862089 0.0 0.0 -1.2026876
                                0.30918422 0.0 0.0 -418.61923 210.7547 0.0 0.0 -1.2791088 -0.36123466 0.0 0.0
                                -1.2439646 0.06797765 0.0 0.0 -21.628708 1.0166732 0.0 0.0 -22.787497
                                -7.887458 0.0 0.0 -14.00722 -10.742202 0.0 0.0 -16.01594 -12.666508 0.0 0.0
                                -288.44736 -306.72693 0.0 0.0 -16.167877 10.316764 0.0 0.0 -291.1093
                                -133.67459 0.0 0.0 -19.587412 8.910902 0.0 0.0 -311.94183 -73.65787 0.0 0.0
                                -37.642296 -12.050588 0.0 0.0 -285.74237 97.47153 0.0 0.0 -1.244526
                                -0.3990412 0.0 0.0 -1.269324 0.10725807 0.0 0.0 -22.489853 -2.914877 0.0 0.0
                                -17.06987 -3.5979395 0.0 0.0 -1.305526 -0.03452605 0.0 0.0 -17.297335
                                9.598888 0.0 0.0 -287.9218 -3.725569 0.0 0.0 -1.0819209 -0.46275747 0.0 0.0
                                -1.3054988 0.27762175 0.0 0.0 -1.2652707 -0.4230313 0.0 0.0 -1.3138673
                                -0.22741018 0.0 0.0 -1.2361022 0.4447337 0.0 0.0 -17.277916 -13.158922 0.0
                                0.0 -23.546282 5.816891 0.0 0.0 -339.23035 -27.058872 0.0 0.0 -282.8247
                                -114.09314 0.0 0.0 -1.2461894 -0.05254802 0.0 0.0 -1.4594284 0.09547625 0.0
                                0.0 -1.3110126 0.11763994 0.0 0.0 -302.57962 40.783066 0.0 0.0 -19.82268
                                0.9025064 0.0 0.0 -1.3919339 0.24706973 0.0 0.0 -1.3156912 0.25059712 0.0 0.0
                                -1.1190387 -0.4996588 0.0 0.0 -1.3253502 0.08398196 0.0 0.0 -1.274915
                                -0.2692286 0.0 0.0 -0.9716193 -0.24893059 0.0 0.0 -31.645056 -4.5080624 0.0
                                0.0 -37.041824 -14.581161 0.0 0.0 -18.270706 7.457491 0.0 0.0 -1.241481
                                -0.4994059 0.0 0.0 -0.49249437 -1.1127087 0.0 0.0 -1.3207186 0.16098858 0.0
                                0.0 -250.9215 -145.57045 0.0 0.0 -1.1193136 0.28285766 0.0 0.0 -289.79974
                                -16.149044 0.0 0.0 -357.96548 -53.637356 0.0 0.0 -1.0332415 -0.97832936 0.0
                                0.0 -288.97244 -103.52703 0.0 0.0 -1.2537893 -0.16077565 0.0 0.0 -0.99130446
                                -0.78374124 0.0 0.0 -415.61096 -101.24591 0.0 0.0 -1.1401778 0.6537032 0.0
                                0.0 -1.2079648 0.58312166 0.0 0.0 -19.332014 -3.7937045 0.0 0.0 -19.316866
                                2.2865021 0.0 0.0 -16.480833 6.0303273 0.0 0.0 -1.3314079 0.15109302 0.0 0.0
                                -22.66838 -1.742232 0.0 0.0 -17.673609 10.631063 0.0 0.0 -325.13156 15.258141
                                0.0 0.0 -18.887768 -6.1889033 0.0 0.0 -289.3973 35.805656 0.0 0.0 -1.175892
                                -0.6370009 0.0 0.0 -21.201887 -5.43787 0.0 0.0 -1.1332469 -0.68792754 0.0 0.0
                                -20.168982 1.9983888 0.0 0.0 -19.723314 3.007936 0.0 0.0 -345.4709 -170.1953
                                0.0 0.0 -39.453556 -7.3700094 0.0 0.0 -15.587483 -10.1256695 0.0 0.0
                                -633.77167 24.37236 0.0 0.0 -1.3138908 0.06387155 0.0 0.0 -292.29376
                                -10.492502 0.0 0.0 -1.097153 0.7050527 0.0 0.0 -290.86295 6.7056184 0.0 0.0
                                -20.364664 3.7298055 0.0 0.0 -288.74707 -48.558872 0.0 0.0 -18.566835
                                -0.53224564 0.0 0.0 -1.3462343 0.21190663 0.0 0.0 -18.287273 4.38627 0.0 0.0
                                -1.2706329 -0.07694576 0.0 0.0 -15.269196 9.588625 0.0 0.0 -1.1168867
                                -0.56822896 0.0 0.0 -22.028051 -0.65311104 0.0 0.0 -1.250623 0.36520877 0.0
                                0.0 -30.561697 -0.15496612 0.0 0.0 -19.03108 5.758312 0.0 0.0 -293.67828
                                1.408065 0.0 0.0 -17.488516 -2.3172677 0.0 0.0 -18.941425 6.46078 0.0 0.0
                                -1.1490164 0.6181502 0.0 0.0 -1.2499402 -0.4045049 0.0 0.0 -1.2027538
                                -0.55797434 0.0 0.0 -1.2370163 0.46561593 0.0 0.0 -1.3054283 -0.45846123 0.0
                                0.0 -19.503119 2.8388963 0.0 0.0 -1.4877025 -0.33520418 0.0 0.0 -392.79248
                                185.53758 0.0 0.0 -11.029114 -17.677637 0.0 0.0 -19.750935 -1.61172 0.0 0.0
                                -1.3304031 -0.551085 0.0 0.0 -1.401055 0.07525445 0.0 0.0 -248.5478
                                -146.35143 0.0 0.0 -1.462383 0.033759702 0.0 0.0 -18.742052 1.798346 0.0 0.0
                                -1.4148265 -0.40471256 0.0 0.0 -1.4387184 -0.3502124 0.0 0.0 -5158.4766
                                -1008.4873 0.0 0.0 -275.64587 -84.93586 0.0 0.0 -1.2888242 0.15677872 0.0 0.0
                                -1.2481763 0.41204628 0.0 0.0 -1.3187566 -0.48563778 0.0 0.0 -1.4192681
                                -0.084517725 0.0 0.0 -1.3502843 -0.36567345 0.0 0.0 -247.94217 147.3751 0.0
                                0.0 -18.255848 7.925075 0.0 0.0 -22.014818 -13.722427 0.0 0.0 -1.254387
                                -0.46161875 0.0 0.0 -274.92175 87.25118 0.0 0.0 -343.37427 80.35727 0.0 0.0
                                -253.94344 136.7753 0.0 0.0 -5822.283 -3826.3015 0.0 0.0 -263.31775
                                -172.47847 0.0 0.0 -0.9336168 -1.0422404 0.0 0.0 -21.66194 2.634724 0.0 0.0
                                -17.101053 -7.8168483 0.0 0.0 -1.4000981 -0.45246777 0.0 0.0 -1.284374
                                -0.5393073 0.0 0.0 -22.365505 0.5543589 0.0 0.0 -260.49658 -123.83969 0.0 0.0
                                -18.634747 -7.6237493 0.0 0.0 -18.331179 -12.562968 0.0 0.0 -1.8329899
                                -0.15113306 0.0 0.0 -279.529 71.12161 0.0 0.0 -1.3510534 0.47685724 0.0 0.0
                                -19.703827 -1.2491117 0.0 0.0 -18.172216 -11.101134 0.0 0.0 -19.551584
                                3.9113126 0.0 0.0 -1.2671307 0.3461705 0.0 0.0 -36.365704 4.140851 0.0 0.0
                                -5161.059 -1325.5057 0.0 0.0 -1.1784048 -0.77440995 0.0 0.0 -1.3236078
                                -0.4519797 0.0 0.0 -288.2717 -9.704436 0.0 0.0 -17.726082 2.0327365 0.0 0.0
                                -1.1879454 -0.64016515 0.0 0.0 -1.3736312 -0.22177067 0.0 0.0 -389.47736
                                71.1287 0.0 0.0 -1.4393295 -0.26567626 0.0 0.0 -1.4805455 -0.16570383 0.0 0.0
                                -17.790157 -10.855993 0.0 0.0 -1.4371796 0.19496611 0.0 0.0 -1.3899404
                                -0.2715521 0.0 0.0 -16.521557 0.49697584 0.0 0.0 -0.7970659 -1.1064103 0.0
                                0.0 -13.075929 -12.291047 0.0 0.0 -253.21399 -138.12103 0.0 0.0 -5889.8574
                                -3222.073 0.0 0.0 -627.93335 22.045963 0.0 0.0 -1.4019794 -0.15548865 0.0 0.0
                                -1.442696 0.22608441 0.0 0.0 -16.643763 13.0821085 0.0 0.0 -1.4805527
                                0.14011897 0.0 0.0 -19.678783 -5.8430734 0.0 0.0 -1.3771425 -0.479621 0.0 0.0
                                -1.3771038 -0.4402717 0.0 0.0 -1.5039098 -1.0287907 0.0 0.0 -284.37704
                                48.21245 0.0 0.0 -272.37006 94.91737 0.0 0.0 -21.002728 -8.5924015 0.0 0.0
                                -1.3648732 0.5090794 0.0 0.0 -21.15889 0.2343755 0.0 0.0 -0.9875954
                                -0.9783445 0.0 0.0 -280.97525 -65.17399 0.0 0.0 -1.3618723 0.2676573 0.0 0.0
                                -288.32068 8.119699 0.0 0.0 -1.3577844 0.37893945 0.0 0.0 -1.429588
                                -0.3434204 0.0 0.0 -1.3193827 -0.18853919 0.0 0.0 -1.4345661 -0.033804096 0.0
                                0.0 -22.312634 -3.6384008 0.0 0.0 -286.21048 -35.753475 0.0 0.0 -7980.1714
                                -938.2229 0.0 0.0 -277.94702 77.07272 0.0 0.0 -21.50676 -6.613565 0.0 0.0
                                -16.67909 10.926118 0.0 0.0 -221.1053 -185.22202 0.0 0.0 -288.0951 -13.998711
                                0.0 0.0 -1.2818173 0.19897941 0.0 0.0 -1.4825007 0.064542085 0.0 0.0
                                -1.3975236 0.4270131 0.0 0.0 -1.4389904 0.1766878 0.0 0.0 -329.39636
                                -84.579796 0.0 0.0 -277.81937 -77.53147 0.0 0.0 -20.069021 -2.9106581 0.0 0.0
                                -775.33386 -103.37716 0.0 0.0 -1.2442987 0.53278464 0.0 0.0 -20.394985
                                10.037454 0.0 0.0 -1.444522 0.04166261 0.0 0.0 -4771.577 -524.0222 0.0 0.0
                                -17.280825 -10.566818 0.0 0.0 -1.2574099 -0.7050433 0.0 0.0 -21.777964
                                -2.3554566 0.0 0.0 -1.2356495 0.21548241 0.0 0.0 -21.085152 -8.663172 0.0 0.0
                                -19.65155 -4.4091034 0.0 0.0 -18.76543 -3.2544713 0.0 0.0 -22.811333
                                -1.4520628 0.0 0.0 -237.91663 251.37257 0.0 0.0 -270.3389 -100.55661 0.0 0.0
                                -24.158205 -9.940245 0.0 0.0 -314.95837 73.36511 0.0 0.0 -1.3603889
                                -0.17304565 0.0 0.0 -18.84535 4.0552363 0.0 0.0 -1.334342 0.048380226 0.0 0.0
                                -1.0880805 0.3798263 0.0 0.0 -1.3971376 -0.30402815 0.0 0.0 -277.35364
                                -79.18147 0.0 0.0 -19.951756 0.6368571 0.0 0.0 -1.449182 0.10169733 0.0 0.0
                                -267.5902 -107.657936 0.0 0.0 -269.65582 102.37424 0.0 0.0 -8.042294
                                -16.188313 0.0 0.0 -273.44135 91.7855 0.0 0.0 -21.71832 4.6842017 0.0 0.0
                                -21.226744 -2.4675193 0.0 0.0 -21.697361 5.825635 0.0 0.0 -19.644413 4.619343
                                0.0 0.0 -0.7334019 -1.1451794 0.0 0.0 -281.7954 61.53131 0.0 0.0 -14.874237
                                -12.077401 0.0 0.0 -0.9329669 -1.151796 0.0 0.0 -18.047241 0.9368749 0.0 0.0
                                -305.902 -36.353325 0.0 0.0 -1.5943403 0.9767131 0.0 0.0 -336.29828 -91.64322
                                0.0 0.0 -1.3763252 0.20598516 0.0 0.0 -19.664646 11.523346 0.0 0.0 -285.69437
                                157.34969 0.0 0.0 -15.81765 8.731929 0.0 0.0 -1.3281671 0.49926496 0.0 0.0
                                -1.4036442 0.46533838 0.0 0.0 -315.3493 101.56 0.0 0.0 -24.407469 -5.9660864
                                0.0 0.0 -16.559156 -7.215422 0.0 0.0 -21.117502 3.858282 0.0 0.0 -261.06323
                                -122.64067 0.0 0.0 -2.0585308 -0.10849112 0.0 0.0 -1.357187 0.5657904 0.0 0.0
                                -21.111393 2.001181 0.0 0.0 -15.680195 9.090166 0.0 0.0 -280.3891 -67.65128
                                0.0 0.0 -231.79108 -205.22682 0.0 0.0 -1.4054059 0.40869236 0.0 0.0
                                -1.4577763 0.26923835 0.0 0.0 -273.4957 -78.16707 0.0 0.0 -259.99557
                                -124.88817 0.0 0.0 -23.938368 0.15668568 0.0 0.0 -22.455576 3.387073 0.0 0.0
                                -417.17233 -249.07721 0.0 0.0 -1.2748408 0.46798477 0.0 0.0 -1.250745
                                -0.7598108 0.0 0.0 -1.3808352 0.3506282 0.0 0.0 -20.286129 -3.6711938 0.0 0.0
                                -1.2176119 -1.0092262 0.0 0.0 -1.2449504 -0.64643425 0.0 0.0 -20.678146
                                -1.8386337 0.0 0.0 -18.842724 -8.4349575 0.0 0.0 -18.552042 -5.174384 0.0 0.0
                                -1.1227111 -0.69558066 0.0 0.0 -1.3328912 -0.6282941 0.0 0.0 -23.81939
                                1.9792708 0.0 0.0 -1.3424464 -0.1455923 0.0 0.0 -21.787512 6.45737 0.0 0.0
                                -1.2882702 -0.8418736 0.0 0.0 -1.1288251 -0.1881224 0.0 0.0 -1.2334049
                                -0.75350714 0.0 0.0 -249.72643 -144.33107 0.0 0.0 -1.422597 -0.32975304 0.0
                                0.0 -21.368347 -3.0641751 0.0 0.0 -0.8480089 0.6739487 0.0 0.0 -22.293694
                                -1.3985695 0.0 0.0 -286.04797 37.030987 0.0 0.0 -1.2228838 -0.5393633 0.0 0.0
                                -19.024487 2.9359121 0.0 0.0 -1.4237124 -0.19502683 0.0 0.0 -21.43515
                                -0.23939002 0.0 0.0 -21.627573 -6.4429026 0.0 0.0 -1.4103533 0.10108121 0.0
                                0.0 -288.35147 6.9405026 0.0 0.0 -17.319086 -5.6826897 0.0 0.0 -15.736751
                                4.062039 0.0 0.0 -1.3569275 -0.7162814 0.0 0.0 -372.4294 -24.096651 0.0 0.0
                                -311.01404 30.665056 0.0 0.0 -0.5821084 -0.60452044 0.0 0.0 -5281.1953
                                -2091.0586 0.0 0.0 -1.3480048 0.48832783 0.0 0.0 -20.486658 10.059178 0.0 0.0
                                -17.06432 -10.7627735 0.0 0.0 -16.653376 -8.970132 0.0 0.0 -1.4327939
                                -0.37669766 0.0 0.0 -326.77594 -140.23726 0.0 0.0 -19.92339 5.2734356 0.0 0.0
                                -853.5216 87.69511 0.0 0.0 -229.50148 168.79433 0.0 0.0 -1.483123 0.06013263
                                0.0 0.0 -21.288252 3.8998382 0.0 0.0 -340.90738 -104.108055 0.0 0.0
                                -1.4858682 0.12540542 0.0 0.0 -314.2079 -11.000303 0.0 0.0 -24.396648
                                4.2049336 0.0 0.0 -17.632853 -4.965448 0.0 0.0 -1.1144205 0.5897112 0.0 0.0
                                -332.64432 -14.513403 0.0 0.0 -278.29965 -75.78947 0.0 0.0 -241.63618
                                -157.50142 0.0 0.0 -18.734272 -11.345274 0.0 0.0 -1.4021047 0.3887846 0.0 0.0
                                -279.93466 -69.50772 0.0 0.0 -1.2468165 -0.481827 0.0 0.0 -7417.1177 799.097
                                0.0 0.0 -729.4978 120.74893 0.0 0.0 -18.806948 -3.9945414 0.0 0.0 -322.5189
                                86.841995 0.0 0.0 -1.4643394 0.029252548 0.0 0.0 -0.5994802 -0.8044172 0.0
                                0.0 -324.43677 133.27974 0.0 0.0 -21.440195 11.315697 0.0 0.0 -22.812698
                                3.596619 0.0 0.0 -1.4092743 -0.33497104 0.0 0.0 -1.4004934 -0.50424343 0.0
                                0.0 -200.74619 -207.1128 0.0 0.0 -1.2463043 0.7588723 0.0 0.0 -1.329876
                                -0.12974197 0.0 0.0 -22.513306 1.5284109 0.0 0.0 -258.26785 -128.42297 0.0
                                0.0 -1.4051926 -0.2495931 0.0 0.0 -1.4749742 0.17661916 0.0 0.0 -20.659298
                                -1.2259905 0.0 0.0 -1.3897015 -0.05273016 0.0 0.0 -1.4453723 0.3304505 0.0
                                0.0 -267.3297 108.303085 0.0 0.0 -1.4874414 -0.07893552 0.0 0.0 -287.91776
                                -237.33594 0.0 0.0 -1.0996654 -0.8622031 0.0 0.0 -261.6084 121.473366 0.0 0.0
                                -1.4394084 -0.58747 0.0 0.0 -14.793762 -11.134516 0.0 0.0 -1.396974 0.2323034
                                0.0 0.0 -1.2892492 0.2537657 0.0 0.0 -272.84894 93.53188 0.0 0.0 -1.4107946
                                -0.39105225 0.0 0.0 -325.31705 -153.95274 0.0 0.0 -1.4490005 0.12741795 0.0
                                0.0 -1.1740768 -0.4635798 0.0 0.0 -20.394945 -0.5009339 0.0 0.0 -23.778227
                                -5.1609883 0.0 0.0 -1.3193916 0.08739894 0.0 0.0 -17.57875 -11.02408 0.0 0.0
                                -19.718964 -6.4465885 0.0 0.0 -17.84604 3.984193 0.0 0.0 -1.2671506
                                0.23420338 0.0 0.0 -391.9376 70.020775 0.0 0.0 -1.3145348 -0.24644464 0.0 0.0
                                -1.3301401 -0.039468702 0.0 0.0 -21.164192 -7.619584 0.0 0.0 -1.2593769
                                -0.3595261 0.0 0.0 -588.5074 -100.13427 0.0 0.0 -19.992664 4.668666 0.0 0.0
                                -19.818653 -3.333281 0.0 0.0 -1.3347114 -0.03432095 0.0 0.0 -1.1561158
                                -0.58574957 0.0 0.0 -0.82793087 -0.80472815 0.0 0.0 -1.3196336 -0.182932 0.0
                                0.0 -397.9533 -35.670753 0.0 0.0 -1.2562317 -0.44479826 0.0 0.0 -0.8156183
                                -0.99562013 0.0 0.0 -18.96117 2.9159083 0.0 0.0 -608.6871 -370.52118 0.0 0.0
                                -19.274374 -7.107513 0.0 0.0 -367.66608 -86.87694 0.0 0.0 -20.439129
                                2.0544064 0.0 0.0 -21.515364 2.7667007 0.0 0.0 -1.2870575 -0.2619468 0.0 0.0
                                -19.204432 -6.780327 0.0 0.0 -1.3394129 -0.0598148 0.0 0.0 -17.279621
                                -8.67472 0.0 0.0 -1.1411158 -0.33929288 0.0 0.0 -1.2653029 -0.33854064 0.0
                                0.0 -1.2760491 -0.17199454 0.0 0.0 -1.1584408 0.63688374 0.0 0.0 -0.8530535
                                -0.9745541 0.0 0.0 -1.3874482 -0.07242282 0.0 0.0 -1.2442107 -0.45407343 0.0
                                0.0 -1.4579744 -0.35666966 0.0 0.0 -1.2781149 0.06392528 0.0 0.0 -528.69226
                                -94.66718 0.0 0.0 -1.3842685 0.43611744 0.0 0.0 -18.21784 -2.1255744 0.0 0.0
                                -1.2889495 -0.24461995 0.0 0.0 -17.881687 -10.07813 0.0 0.0 -15.253535
                                -10.224366 0.0 0.0 -1.3053825 0.28926203 0.0 0.0 -1.2678704 0.24054073 0.0
                                0.0 -20.359802 -1.9140313 0.0 0.0 -1.1838286 -0.61718595 0.0 0.0 -1.1283658
                                0.71636176 0.0 0.0 -2.4828095 0.36462906 0.0 0.0 -18.828848 -4.937431 0.0 0.0
                                -24.4734 -1.8762347 0.0 0.0 -20.87312 6.384336 0.0 0.0 -304.91043 111.67078
                                0.0 0.0 -1.2625624 0.43094033 0.0 0.0 -25.919321 2.0791507 0.0 0.0 -1.2763765
                                -0.20452528 0.0 0.0 -20.345085 8.046766 0.0 0.0 -305.69586 -96.92658 0.0 0.0
                                -33.540283 9.1387205 0.0 0.0 -1.2810594 -0.3920911 0.0 0.0 -329.36957
                                -84.87933 0.0 0.0 -17.69255 12.329175 0.0 0.0 -1.2890246 -0.20077118 0.0 0.0
                                -19.203894 -3.542772 0.0 0.0 -17.63237 -10.836531 0.0 0.0 -1.2857323
                                0.18532072 0.0 0.0 -293.87198 -130.26027 0.0 0.0 -17.541006 3.1994102 0.0 0.0
                                -1.2025099 -0.56609774 0.0 0.0 -13.548486 8.135089 0.0 0.0 -18.918402
                                4.9387836 0.0 0.0 -51.36279 2.2159138 0.0 0.0 -1.1889002 0.25220498 0.0 0.0
                                -0.9698185 -0.72709465 0.0 0.0 -1.2565795 -0.42701045 0.0 0.0 -1.2979043
                                -0.006595283 0.0 0.0 -1.2868868 0.28708175 0.0 0.0 -28.506783 -1.6832854 0.0
                                0.0 -1.2739507 -0.22311775 0.0 0.0 -362.32285 -5.080819 0.0 0.0 -340.92645
                                -123.066216 0.0 0.0 -1.1893483 0.27451897 0.0 0.0 -1.0737509 0.2338757 0.0
                                0.0 -11.991434 16.332077 0.0 0.0 -20.561735 -2.3741024 0.0 0.0 -1.2788001
                                -0.40449315 0.0 0.0 -17.961168 4.404919 0.0 0.0 -19.703907 -6.502081 0.0 0.0
                                -1.311944 0.1579813 0.0 0.0 -688.1042 -356.9686 0.0 0.0 -17.22121 -2.6094718
                                0.0 0.0 -1.165697 -0.51272064 0.0 0.0 -330.6309 -151.42891 0.0 0.0 -19.322187
                                -8.237322 0.0 0.0 -13.183509 -12.19968 0.0 0.0 -52.421318 -16.852411 0.0 0.0
                                -320.08347 49.999218 0.0 0.0 -0.87438387 0.9830294 0.0 0.0 -19.31368
                                -0.11292856 0.0 0.0 -19.856012 -6.8980336 0.0 0.0 -18.173616 10.563376 0.0
                                0.0 -1.309055 0.20319968 0.0 0.0 -1.1806066 -0.63688827 0.0 0.0 -31.19816
                                -11.0963745 0.0 0.0 -18.943634 7.8708405 0.0 0.0 -18.43986 -0.868028 0.0 0.0
                                -22.121819 -7.571287 0.0 0.0 -0.970965 -0.8555325 0.0 0.0 -1.4150195
                                -0.1743356 0.0 0.0 -1.191579 0.5216244 0.0 0.0 -342.37585 40.081284 0.0 0.0
                                -1.456423 -0.04012966 0.0 0.0 -18.514267 -1.1690358 0.0 0.0 -1.0164635
                                -0.59349924 0.0 0.0 -1.0702295 -0.7863464 0.0 0.0 -341.01416 -230.09106 0.0
                                0.0 -1.1835895 -0.23640022 0.0 0.0 -404.7291 74.98891 0.0 0.0 -19.531712
                                -7.913432 0.0 0.0 -0.8796496 -0.6520598 0.0 0.0 -1.3250122 -0.1352713 0.0 0.0
                                -19.597292 2.122197 0.0 0.0 -410.4131 38.497074 0.0 0.0 -313.70978 -145.74147
                                0.0 0.0 -1.2224993 0.41404966 0.0 0.0 -20.329094 -4.6598864 0.0 0.0
                                -18.260511 -10.271614 0.0 0.0 -0.96958494 -0.5265719 0.0 0.0 -1.3080846
                                -0.16463813 0.0 0.0 -1.0526177 -0.7556144 0.0 0.0 -0.56069964 -0.1581579 0.0
                                0.0 -1.2597766 -0.32613942 0.0 0.0 -1.2497554 0.27161175 0.0 0.0 -0.55400527
                                -0.83175695 0.0 0.0 -1.2537353 0.3868023 0.0 0.0 -461.62958 -174.08078 0.0
                                0.0 -17.133234 -8.360668 0.0 0.0 -34.937107 13.118785 0.0 0.0 -509.78665
                                -165.95866 0.0 0.0 -1.2800997 0.11847664 0.0 0.0 -1.4834098 -0.4085573 0.0
                                0.0 -1.3817459 0.16174506 0.0 0.0 -19.82814 -5.8514843 0.0 0.0 -1.1857336
                                -0.6207931 0.0 0.0 -1.2175918 0.3875558 0.0 0.0 -1.1130396 -0.06700966 0.0
                                0.0 -18.766468 9.747796 0.0 0.0 -20.261244 6.042892 0.0 0.0 -1.200335
                                0.567035 0.0 0.0 -0.91024745 0.44916967 0.0 0.0 -1.167391 -0.5952851 0.0 0.0
                                -1.2443787 -0.48301035 0.0 0.0 -319.13715 -78.67053 0.0 0.0 -369.4101
                                16.829542 0.0 0.0 -298.63974 -137.70726 0.0 0.0 -326.98285 -121.61514 0.0 0.0
                                -1.3357632 0.33400133 0.0 0.0 -18.646633 -0.77886707 0.0 0.0 -17.07916
                                9.881104 0.0 0.0 -1.2858878 0.06455577 0.0 0.0 -20.143167 6.3880568 0.0 0.0
                                -32.985977 -1.2777671 0.0 0.0 -18.654516 -0.85335004 0.0 0.0 -1.1541256
                                0.4193322 0.0 0.0 -1.27038 0.057613086 0.0 0.0 -1.2153871 0.548532 0.0 0.0
                                -1.325313 -0.10680452 0.0 0.0 -1.2241976 -0.5372659 0.0 0.0 -24.6728
                                -4.265671 0.0 0.0 -23.287012 12.716077 0.0 0.0 -529.02325 -5.504191 0.0 0.0
                                -19.822918 0.19719493 0.0 0.0 -1.3164936 -0.0968294 0.0 0.0 -18.330822
                                -10.683203 0.0 0.0 -28.852913 -1.1703175 0.0 0.0 -1.3040297 -0.13814062 0.0
                                0.0 -1.3958312 0.108443424 0.0 0.0 -366.0841 -203.44637 0.0 0.0 -24.606173
                                4.7981453 0.0 0.0 -0.85783255 -1.1118585 0.0 0.0 -1.023621 -0.86368877 0.0
                                0.0 -1.2893094 -0.29253992 0.0 0.0 -0.89330065 -0.96399903 0.0 0.0 -21.82207
                                3.8980963 0.0 0.0 -1.217093 0.26290452 0.0 0.0 -1.1370592 -1.2591708 0.0 0.0
                                -1.3335235 -0.114962816 0.0 0.0 -1.2132747 -0.21297601 0.0 0.0 -1.33347
                                0.029656706 0.0 0.0 -1.192097 -0.5910181 0.0 0.0 -1.2841244 0.09056194 0.0
                                0.0 -1.0044161 -0.7827726 0.0 0.0 -1.0983595 0.731578 0.0 0.0 -17.477755
                                -12.109995 0.0 0.0 -1.3214128 -0.03206899 0.0 0.0 -19.914688 6.8205013 0.0
                                0.0 -1.3266748 0.08272822 0.0 0.0 -586.70966 -335.80002 0.0 0.0 -21.897781
                                -4.542743 0.0 0.0 -1.2941813 -0.32699078 0.0 0.0 -447.27774 -2.940062 0.0 0.0
                                -1.2706094 -0.29905486 0.0 0.0 -20.012018 7.241438 0.0 0.0 -1.3251635
                                -0.19687228 0.0 0.0 -1.5421264 0.7093053 0.0 0.0 -14.352562 -15.330961 0.0
                                0.0 -20.923658 2.7699482 0.0 0.0 -561.4427 -20.114704 0.0 0.0 -1.1282877
                                -0.70346564 0.0 0.0 -19.55949 -3.4569666 0.0 0.0 -18.754442 0.25288698 0.0
                                0.0 -441.44977 80.56146 0.0 0.0 -1.2758279 0.2681524 0.0 0.0 -19.930809
                                -7.567508 0.0 0.0 -16.719547 11.641895 0.0 0.0 -1.2970335 0.22733818 0.0 0.0
                                -18.610455 -7.1089344 0.0 0.0 -1.1561292 0.15036008 0.0 0.0 -1.0503224
                                0.7788668 0.0 0.0 -1.3310574 -0.12426176 0.0 0.0 -1.1647873 -0.4061272 0.0
                                0.0 -1.2703779 0.016077382 0.0 0.0 -16.643972 8.781504 0.0 0.0 -25.15119
                                1.548462 0.0 0.0 -17.176645 -14.47517 0.0 0.0 -21.017052 -3.7397919 0.0 0.0
                                -1.303286 0.30547976 0.0 0.0 -20.261412 -4.467122 0.0 0.0 -614.14264
                                -193.73901 0.0 0.0 -1.3026328 -0.28112724 0.0 0.0 -20.967045 3.1037009 0.0
                                0.0 -1.1202573 -0.39516437 0.0 0.0 -1.1581982 -0.6640205 0.0 0.0 -0.8878936
                                -0.55460405 0.0 0.0 -768.0967 69.1696 0.0 0.0 -1.215168 -0.03335828 0.0 0.0
                                -1.2687644 -0.20493151 0.0 0.0 -21.242393 -0.9095717 0.0 0.0 -1.8187965
                                -0.7013337 0.0 0.0 -19.096224 -6.9622974 0.0 0.0 -535.57874 -206.7866 0.0 0.0
                                -14.629506 13.651329 0.0 0.0 -21.242077 -2.6910653 0.0 0.0 -1.2941891
                                0.34519848 0.0 0.0 -1.3003606 0.013993631 0.0 0.0 -412.45898 110.74586 0.0
                                0.0 -19.422998 -6.3098006 0.0 0.0 -24.779829 -5.3031583 0.0 0.0 -1.3029783
                                -0.27523816 0.0 0.0 -20.386978 -6.2138166 0.0 0.0 -1.1465682 -0.5258423 0.0
                                0.0 -21.974293 9.415824 0.0 0.0 -1.1604643 0.34331983 0.0 0.0 -1.1747955
                                -0.4044927 0.0 0.0 -404.05704 -141.65135 0.0 0.0 -1.2618406 0.44913715 0.0
                                0.0 -17.988003 -5.78194 0.0 0.0 -0.8828628 -0.71227676 0.0 0.0 -1.1802641
                                -0.51305646 0.0 0.0 -1.1927375 -0.33532408 0.0 0.0 -1.3108481 -0.18915045 0.0
                                0.0 -1.2818305 -0.37044787 0.0 0.0 -19.931128 2.1012633 0.0 0.0 -1.3019786
                                0.34292892 0.0 0.0 -0.86901534 -1.0024433 0.0 0.0 -1.1365876 -2.4022162e-4
                                0.0 0.0 -1.283758 0.10198644 0.0 0.0 -21.088411 3.0458863 0.0 0.0 -15.235943
                                13.0742235 0.0 0.0 -501.58423 215.60449 0.0 0.0 -1.4351108 -0.128638 0.0 0.0
                                -1.286721 -0.14134227 0.0 0.0 -1.3489429 -0.47161818 0.0 0.0 -1.172779
                                0.65083396 0.0 0.0 -25.061934 16.98463 0.0 0.0 -1.4038471 0.048929714 0.0 0.0
                                -1.286006 -0.36325258 0.0 0.0 -1.238599 -0.43410575 0.0 0.0 -21.318615
                                -2.8398654 0.0 0.0 -20.164587 6.993674 0.0 0.0 -326.80338 -92.42204 0.0 0.0
                                -1.3093668 -0.2316922 0.0 0.0 -1.0615562 -0.60004723 0.0 0.0 -1.2519556
                                0.43076473 0.0 0.0 -1.2167975 -0.54882985 0.0 0.0 -1.3179121 -0.07422105 0.0
                                0.0 -1.1600734 0.55984426 0.0 0.0 -21.150099 0.4611797 0.0 0.0 -1.290672
                                0.0361636 0.0 0.0 -1.6105627 -0.6943104 0.0 0.0 -25.103851 4.6503963 0.0 0.0
                                -1.2961252 0.32565567 0.0 0.0 -1.2693583 -0.40097448 0.0 0.0 -1.0880649
                                -0.7759096 0.0 0.0 -19.538315 3.8260498 0.0 0.0 -21.176136 -1.6955643 0.0 0.0
                                -18.876598 2.1291764 0.0 0.0 -17.234003 12.649872 0.0 0.0 -1.3292271
                                -0.18116128 0.0 0.0 -19.307331 -5.8216496 0.0 0.0 -1.3398027 0.0039077885 0.0
                                0.0 -1.1491053 0.51702744 0.0 0.0 -20.349525 -0.090794034 0.0 0.0 -19.2629
                                5.700253 0.0 0.0 -1.3126895 0.22893372 0.0 0.0 -16.627127 -13.714941 0.0 0.0
                                -1.3069103 0.041713655 0.0 0.0 -1.3002257 0.11200348 0.0 0.0 -799.2314
                                510.57632 0.0 0.0 -338.0204 -185.84521 0.0 0.0 -24.801662 9.627496 0.0 0.0
                                -25.293922 -1.1347615 0.0 0.0 -1.1992881 -0.58425707 0.0 0.0 -1.3064605
                                -0.28733826 0.0 0.0 -20.201536 0.4371439 0.0 0.0 -1.3314312 -0.11350265 0.0
                                0.0 -451.74997 -100.33474 0.0 0.0 -30.01724 -6.2246213 0.0 0.0 -0.90908176
                                -0.95694923 0.0 0.0 -1.1901349 -0.40675557 0.0 0.0 -1.090873 0.76308733 0.0
                                0.0 -1.5805886 0.09386315 0.0 0.0 -425.0745 -13.246573 0.0 0.0 -1.2708517
                                -0.09823779 0.0 0.0 -1.3356228 -0.06014632 0.0 0.0 -21.440342 -2.7712758 0.0
                                0.0 -15.417496 15.188097 0.0 0.0 -21.287148 3.8890038 0.0 0.0 -18.738989
                                3.5513346 0.0 0.0 -12.907187 -14.76349 0.0 0.0 -1.1623499 0.45596775 0.0 0.0
                                -21.522398 -0.5865866 0.0 0.0 -388.0567 7.223175 0.0 0.0 -491.82178 45.286453
                                0.0 0.0 -20.840887 -5.914647 0.0 0.0 -1.7601959 -0.8879356 0.0 0.0 -17.103361
                                -11.282608 0.0 0.0 -376.4066 -80.40099 0.0 0.0 -18.948803 -1.7110898 0.0 0.0
                                -1.0155991 -0.08027047 0.0 0.0 -17.46212 -6.3663454 0.0 0.0 -1.1985128
                                0.51439536 0.0 0.0 -17.235146 4.7329216 0.0 0.0 -336.75925 -239.85683 0.0 0.0
                                -21.271772 -3.054176 0.0 0.0 -1.3065345 0.10987022 0.0 0.0 -348.34708
                                -114.83053 0.0 0.0 -1.3219914 0.20246409 0.0 0.0 -18.567797 0.33167365 0.0
                                0.0 -1.1014962 0.7266117 0.0 0.0 -46.852882 -1.50371 0.0 0.0 -2.3645332
                                -0.30548802 0.0 0.0 -1.3592407 -0.35445905 0.0 0.0 -390.18665 9.681767 0.0
                                0.0 -585.62476 -108.80819 0.0 0.0 -23.27227 -11.100444 0.0 0.0 -24.524845
                                5.1738234 0.0 0.0 -18.43437 -5.155493 0.0 0.0 -19.83329 -8.661041 0.0 0.0
                                -1.2276837 -0.51420027 0.0 0.0 -19.857546 4.2846336 0.0 0.0 -25.61397
                                3.484992 0.0 0.0 -409.05457 44.822052 0.0 0.0 -1.3301004 -0.008662227 0.0 0.0
                                -1.2636938 0.4496597 0.0 0.0 -19.655966 11.278883 0.0 0.0 -390.49335 30.22718
                                0.0 0.0 -31.071016 -10.842263 0.0 0.0 -1.305755 0.30150294 0.0 0.0 -1.2987194
                                0.6767145 0.0 0.0 -1.2602857 0.35754284 0.0 0.0 -1.2820406 0.02746154 0.0 0.0
                                -315.13858 146.64417 0.0 0.0 -1.1941104 0.37990406 0.0 0.0 -529.3321
                                -195.51207 0.0 0.0 -1.3099265 0.16321321 0.0 0.0 -20.34956 2.1553855 0.0 0.0
                                -1.0162617 -0.6299828 0.0 0.0 -1.1428419 -0.69576705 0.0 0.0 -0.8726277
                                -0.11179916 0.0 0.0 -1.2519282 -0.0123089785 0.0 0.0 -1.1966585 -0.5653026
                                0.0 0.0 -438.31903 -174.3093 0.0 0.0 -1.1741534 -0.5694498 0.0 0.0 -22.640322
                                -3.9350083 0.0 0.0 -1.2103072 -0.23644216 0.0 0.0 -1.3020117 0.106117755 0.0
                                0.0 -33.663216 10.689999 0.0 0.0 -269.6966 -250.15352 0.0 0.0 -1.2492217
                                0.20368661 0.0 0.0 -1.3032602 -0.22684516 0.0 0.0 -19.058706 -1.3532832 0.0
                                0.0 -19.388918 9.672945 0.0 0.0 -19.06334 2.3606532 0.0 0.0 -1.0476134
                                0.76264 0.0 0.0 -1.3224068 0.20860015 0.0 0.0 -19.096527 -1.7236263 0.0 0.0
                                -34.135956 8.433626 0.0 0.0 -343.17307 142.9251 0.0 0.0 -19.109278 9.740631
                                0.0 0.0 -20.105162 -2.9058228 0.0 0.0 -1.257658 -0.45366883 0.0 0.0
                                -20.486452 -10.555952 0.0 0.0 -21.753942 0.7414863 0.0 0.0 -1.29981
                                -0.0806771 0.0 0.0 -1.2744875 -0.2713238 0.0 0.0 -20.028046 2.896288 0.0 0.0
                                -1.325485 -0.4145788 0.0 0.0 -16.902308 -15.655712 0.0 0.0 -1.2940748
                                0.19225724 0.0 0.0 -18.833538 11.007218 0.0 0.0 -38.843407 -5.7812986 0.0 0.0
                                -50.390713 5.759711 0.0 0.0 -1.3906652 -0.02707978 0.0 0.0 -0.5071551
                                -0.16786781 0.0 0.0 -1.3133965 -0.27153298 0.0 0.0 -19.001974 3.2605858 0.0
                                0.0 -1.2687978 -0.29502153 0.0 0.0 -1.3225061 -0.18217692 0.0 0.0 -1.4622412
                                -0.009543866 0.0 0.0 -30.349144 -7.638379 0.0 0.0 -1.2852366 -0.27619714 0.0
                                0.0 -374.04578 -1.20493 0.0 0.0 -20.4917 -0.34459224 0.0 0.0 -1.0560611
                                0.22401461 0.0 0.0 -1.3072524 -1.0268313 0.0 0.0 -1.3348856 0.07267105 0.0
                                0.0 -21.578873 3.504974 0.0 0.0 -21.413286 -3.65046 0.0 0.0 -1.2220643
                                -0.45313647 0.0 0.0 -1.2170346 0.43350628 0.0 0.0 -20.175041 -8.317879 0.0
                                0.0 -1.2414746 -0.19837435 0.0 0.0 -20.21631 -8.168968 0.0 0.0 -0.9357267
                                -0.66950727 0.0 0.0 -352.91754 -185.92085 0.0 0.0 -340.30847 -158.46321 0.0
                                0.0 -17.92763 -12.599131 0.0 0.0 -1.276161 -0.19072895 0.0 0.0 -1.0829333
                                -0.77969813 0.0 0.0 -1.2994813 0.0698525 0.0 0.0 -1.1725625 -0.36469126 0.0
                                0.0 -1.2597966 -0.45785677 0.0 0.0 -357.22052 -117.56012 0.0 0.0 -269.9979
                                -261.9169 0.0 0.0 -542.4058 -18.988049 0.0 0.0 -1.2435949 0.12878418 0.0 0.0
                                -337.1801 -108.31311 0.0 0.0 -1.0604885 -0.7978203 0.0 0.0 -1.3293701
                                0.17879246 0.0 0.0 -1.0794445 -0.7967385 0.0 0.0 -18.106348 -9.715334 0.0 0.0
                                -1.5199435 -0.08478255 0.0 0.0 -1.2921568 0.33678648 0.0 0.0 -22.96492
                                1.5600154 0.0 0.0 -19.217178 2.4551108 0.0 0.0 -25.15467 7.3865495 0.0 0.0
                                -1.1997454 -0.4005901 0.0 0.0 -394.34274 224.03653 0.0 0.0 -0.896784 0.968067
                                0.0 0.0 -294.06946 -186.11774 0.0 0.0 -29.662315 -0.6790224 0.0 0.0
                                -401.17917 21.331078 0.0 0.0 -19.06753 -3.0755603 0.0 0.0 -352.22427
                                -137.45016 0.0 0.0 -342.53522 160.30362 0.0 0.0 -1.2677413 0.11544752 0.0 0.0
                                -434.9452 -273.72855 0.0 0.0 -19.479624 -9.913176 0.0 0.0 -1.3330474
                                0.1307964 0.0 0.0 -1.1842241 0.19608757 0.0 0.0 -1.3200978 0.09840912 0.0 0.0
                                -1.025835 -0.8530266 0.0 0.0 -351.59665 196.76544 0.0 0.0 -19.06222 7.5099845
                                0.0 0.0 -1.277542 0.33341593 0.0 0.0 -1.2117853 -0.2536901 0.0 0.0 -19.631834
                                -5.450765 0.0 0.0 -21.639458 -4.268953 0.0 0.0 -1.3249115 0.16158903 0.0 0.0
                                -22.774027 -0.8372657 0.0 0.0 -1.2937914 0.18054618 0.0 0.0 -1.3233786
                                -0.17237489 0.0 0.0 -1.2440994 -0.35404456 0.0 0.0 -18.524218 -11.843687 0.0
                                0.0 -1.3247577 0.33187163 0.0 0.0 -515.35394 38.4918 0.0 0.0 -19.622484
                                -9.884745 0.0 0.0 -376.51498 -54.33504 0.0 0.0 -20.345982 -8.315414 0.0 0.0
                                -20.128868 -8.790469 0.0 0.0 -1.2809998 -0.28981134 0.0 0.0 -1.2158188
                                -0.5630315 0.0 0.0 -0.9728167 -0.9154303 0.0 0.0 -1.2949507 -0.34532163 0.0
                                0.0 -1.5408611 -0.053600296 0.0 0.0 -379.6332 -34.427097 0.0 0.0 -371.57523
                                85.51276 0.0 0.0 -380.32596 -28.404533 0.0 0.0 -1.3214521 0.084690675 0.0 0.0
                                -1.2104231 0.35374364 0.0 0.0 -354.29355 -57.39872 0.0 0.0 -1.1386967
                                -0.4899867 0.0 0.0 -1.2966955 -0.083770424 0.0 0.0 -1.2774985 -0.2501273 0.0
                                0.0 -1.2541102 -0.4613373 0.0 0.0 -19.399776 -1.0861408 0.0 0.0 -516.0737
                                -63.641376 0.0 0.0 -17.489517 8.311097 0.0 0.0 -1.3329598 0.12661885 0.0 0.0
                                -1.0655875 0.29280683 0.0 0.0 -1.2347276 -0.34613594 0.0 0.0 -1.1426302
                                -0.4987211 0.0 0.0 -1.3252634 0.18565342 0.0 0.0 -20.7356 -6.3230066 0.0 0.0
                                -1.3268615 0.09682155 0.0 0.0 -505.99417 125.62389 0.0 0.0 -1.2948527
                                0.016529493 0.0 0.0 -20.214916 9.016091 0.0 0.0 -355.8739 -142.72055 0.0 0.0
                                -22.607208 -2.2691972 0.0 0.0 -588.1954 -53.590004 0.0 0.0 -1.259126
                                -0.142331 0.0 0.0 -1.3100125 -0.14722212 0.0 0.0 -404.81155 53.52267 0.0 0.0
                                -383.4742 -20.278252 0.0 0.0 -23.928823 5.5346866 0.0 0.0 -496.98895
                                162.99983 0.0 0.0 -21.910654 -0.49368545 0.0 0.0 -1.2833917 -0.38628003 0.0
                                0.0 -29.265894 12.790837 0.0 0.0 -1.1290408 -0.7185087 0.0 0.0 -16.98531
                                11.9772415 0.0 0.0 -1.6901336 -0.2524998 0.0 0.0 -20.66817 -2.2958953 0.0 0.0
                                -1.2675854 0.05695321 0.0 0.0 -1.2628021 -0.022310093 0.0 0.0 -20.727396
                                10.807552 0.0 0.0 -1.200681 -0.19413109 0.0 0.0 -1.3367685 0.11223351 0.0 0.0
                                -1.2614074 -0.3357378 0.0 0.0 -521.47894 -62.238407 0.0 0.0 -1.1425561
                                -0.18657134 0.0 0.0 -20.437489 8.743446 0.0 0.0 -22.227192 -13.469475 0.0 0.0
                                -1.4474427 0.2902271 0.0 0.0 -20.077251 -9.556805 0.0 0.0 -1.103691 0.1739124
                                0.0 0.0 -1.2969598 -0.32479814 0.0 0.0 -15.984544 11.285588 0.0 0.0
                                -23.179642 -10.708315 0.0 0.0 -587.1118 -103.172714 0.0 0.0 -1.2859862
                                -0.26301 0.0 0.0 -1.2364836 0.07326143 0.0 0.0 -1.2756013 -0.30988774 0.0 0.0
                                -338.6968 -233.96817 0.0 0.0 -436.38174 -38.31392 0.0 0.0 -19.15561 -3.869795
                                0.0 0.0 -1.3089622 0.09301244 0.0 0.0 -22.832777 10.336059 0.0 0.0 -1.3401047
                                -0.06172408 0.0 0.0 -1.222088 0.54662037 0.0 0.0 -1.1847721 0.6108713 0.0 0.0
                                -1.3111979 0.08823575 0.0 0.0 -519.5379 -98.079765 0.0 0.0 -363.2139
                                31.755136 0.0 0.0 -363.62714 -27.8054 0.0 0.0 -1.3210337 -0.040837064 0.0 0.0
                                -1.076778 -0.39385834 0.0 0.0 -1.3148861 -0.26225975 0.0 0.0 -22.005878
                                3.092801 0.0 0.0 -1.2069262 0.0997726 0.0 0.0 -21.178764 -7.0160675 0.0 0.0
                                -363.5551 50.976643 0.0 0.0 -23.33152 1.7309353 0.0 0.0 -1.286848 -0.36959845
                                0.0 0.0 -1.2838885 -0.054297395 0.0 0.0 -781.0106 -248.52917 0.0 0.0
                                -1.234215 -0.47682732 0.0 0.0 -611.43695 -188.28922 0.0 0.0 -1.2022926
                                0.56706095 0.0 0.0 -407.3931 -76.12483 0.0 0.0 -31.354488 7.2408338 0.0 0.0
                                -31.257458 -13.969703 0.0 0.0 -365.43497 25.10264 0.0 0.0 -1.2266723
                                -0.26349896 0.0 0.0 -384.91428 -62.624134 0.0 0.0 -1.4781052 0.048146565 0.0
                                0.0 -21.747206 3.1025264 0.0 0.0 -19.875889 -10.102438 0.0 0.0 -21.570301
                                -5.5946555 0.0 0.0 -15.320719 12.76488 0.0 0.0 -1.262389 -0.44881344 0.0 0.0
                                -1.241443 -0.23885846 0.0 0.0 -389.79028 -27.531944 0.0 0.0 -20.91237
                                7.885268 0.0 0.0 -360.2471 -151.8885 0.0 0.0 -1.3282007 -0.16390446 0.0 0.0
                                -1.271061 0.15084098 0.0 0.0 -23.08892 -7.9371443 0.0 0.0 -21.824177 4.521114
                                0.0 0.0 -20.36098 2.456103 0.0 0.0 -20.983364 -0.047072016 0.0 0.0 -1.2503527
                                0.14096045 0.0 0.0 -1.3039187 -0.30020034 0.0 0.0 -0.7583563 -0.39069423 0.0
                                0.0 -1.2829674 -0.20769696 0.0 0.0 -1.1728936 0.5325143 0.0 0.0 -1.3311008
                                0.045889813 0.0 0.0 -1.3605584 -0.46845797 0.0 0.0 -1.0807799 -0.7128606 0.0
                                0.0 -1.277453 -0.10407144 0.0 0.0 -1.2606329 0.31599727 0.0 0.0 -1.204741
                                0.29388562 0.0 0.0 -1.2238437 -0.5449538 0.0 0.0 -1.1591091 -0.5469947 0.0
                                0.0 -1.0627161 -0.64841026 0.0 0.0 -1.2586578 -0.4411581 0.0 0.0 -1.2741627
                                -0.4132246 0.0 0.0 -1.2621729 0.27210575 0.0 0.0 -1.1069063 0.09941221 0.0
                                0.0 -16.84794 14.718282 0.0 0.0 -1.3388691 0.027663792 0.0 0.0 -1.1813315
                                0.5883965 0.0 0.0 -14.384899 13.47246 0.0 0.0 -28.576746 -26.654072 0.0 0.0
                                -445.1814 32.002266 0.0 0.0 -20.639807 -3.4243064 0.0 0.0 -1.0122383
                                -0.85887647 0.0 0.0 -1.2633862 -0.058937643 0.0 0.0 -1.2802619 0.04566869 0.0
                                0.0 -1.3051775 -0.07082266 0.0 0.0 -1.304605 -0.15745363 0.0 0.0 -21.135973
                                14.04015 0.0 0.0 -1.3094242 -0.062325004 0.0 0.0 -26.092413 -0.052584283 0.0
                                0.0 -15.585453 -16.12499 0.0 0.0 -1.2964147 -0.19453852 0.0 0.0 -367.20175
                                -53.924114 0.0 0.0 -262.57996 -295.35263 0.0 0.0 -1.2252579 0.04082108 0.0
                                0.0 -21.514835 -3.1282845 0.0 0.0 -418.9561 -228.42935 0.0 0.0 -0.8186594
                                -0.6713773 0.0 0.0 -1.0949719 0.51671654 0.0 0.0 -22.267227 -3.283456 0.0 0.0
                                -477.6464 -7.53674 0.0 0.0 -17.286594 -12.687484 0.0 0.0 -1.3086848
                                -0.28818005 0.0 0.0 -25.316277 -7.637817 0.0 0.0 -19.806623 0.94017106 0.0
                                0.0 -342.37973 -30.830074 0.0 0.0 -0.9907949 -0.903429 0.0 0.0 -19.004051
                                5.6746173 0.0 0.0 -19.574879 3.198908 0.0 0.0 -1.1919503 0.5934916 0.0 0.0
                                -1.2700399 -0.38349852 0.0 0.0 -22.526394 -0.5959256 0.0 0.0 -23.929865
                                -0.57551277 0.0 0.0 -1.3999611 -0.13665882 0.0 0.0 -22.189394 0.25909078 0.0
                                0.0 -1.277269 0.22431566 0.0 0.0 -1.04595 -0.8295282 0.0 0.0 -21.516382
                                -6.4531674 0.0 0.0 -22.233372 3.8479524 0.0 0.0 -18.426863 4.764044 0.0 0.0
                                -1.0963205 -0.13180886 0.0 0.0 -1.1257589 -0.3425 0.0 0.0 -370.1727 52.26964
                                0.0 0.0 -25.457136 -1.1711681 0.0 0.0 -30.338394 4.8381095 0.0 0.0 -22.579536
                                0.099728055 0.0 0.0 -442.49078 -91.30986 0.0 0.0 -19.74878 1.760464 0.0 0.0
                                -1.0257019 0.08788583 0.0 0.0 -1.3362772 0.081688724 0.0 0.0 -1.4558556
                                0.33208054 0.0 0.0 -19.513165 11.097182 0.0 0.0 -19.832863 10.731548 0.0 0.0
                                -21.729656 -1.9242533 0.0 0.0 -19.449926 3.9504063 0.0 0.0 -19.066452
                                -5.661481 0.0 0.0 -20.75445 3.0575714 0.0 0.0 -1.2290845 -0.4441375 0.0 0.0
                                -1.3046182 0.30060792 0.0 0.0 -1.3200346 -0.14332587 0.0 0.0 -1.164236
                                -0.6502845 0.0 0.0 -26.616282 -5.7254286 0.0 0.0 -421.27844 63.586586 0.0 0.0
                                -1.303283 0.28573233 0.0 0.0 -19.736292 -0.17833504 0.0 0.0 -661.466
                                -37.99145 0.0 0.0 -1.2602364 -0.07351765 0.0 0.0 -1.0007836 -0.87234086 0.0
                                0.0 -1.2790346 -0.090167545 0.0 0.0 -317.41064 -202.09604 0.0 0.0 -1.2986763
                                -0.3259948 0.0 0.0 -21.067436 -7.685051 0.0 0.0 -22.338335 3.7319007 0.0 0.0
                                -21.93808 -4.17721 0.0 0.0 -26.752422 4.075053 0.0 0.0 -1.2973351 -0.29124382
                                0.0 0.0 -19.736414 8.276135 0.0 0.0 -25.970547 -20.265207 0.0 0.0 -253.38055
                                -279.2944 0.0 0.0 -584.76416 -46.04876 0.0 0.0 -1.2737333 0.3940221 0.0 0.0
                                -517.2003 -12.112354 0.0 0.0 -20.892094 8.706665 0.0 0.0 -1.2756922 -0.140077
                                0.0 0.0 -21.579128 15.346642 0.0 0.0 -17.282463 14.053707 0.0 0.0 -1.2423828
                                -0.24221785 0.0 0.0 -375.90958 -38.93362 0.0 0.0 -1.2110356 0.419456 0.0 0.0
                                -35.474308 -4.384547 0.0 0.0 -1.2811366 -0.3852721 0.0 0.0 -913.02 -73.94855
                                0.0 0.0 -1.2304403 0.53386927 0.0 0.0 -1.1468141 0.6125672 0.0 0.0 -31.95814
                                8.504744 0.0 0.0 -1.2438394 -0.43077472 0.0 0.0 -367.39294 92.00554 0.0 0.0
                                -467.8259 -138.23875 0.0 0.0 -21.72226 12.955396 0.0 0.0 -22.461329
                                -2.4311688 0.0 0.0 -1.3391747 0.07745924 0.0 0.0 -22.29511 3.7117193 0.0 0.0
                                -1.2536867 -0.056127004 0.0 0.0 -1.2816979 -0.53148705 0.0 0.0 -553.9327
                                -28.773804 0.0 0.0 -1.2439599 0.063292325 0.0 0.0 -1.2634504 -0.0675417 0.0
                                0.0 -1.1963608 0.18826467 0.0 0.0 -1.1257633 0.327825 0.0 0.0 -1.2368081
                                -0.27016306 0.0 0.0 -32.947834 -12.059922 0.0 0.0 -35.093735 3.9011111 0.0
                                0.0 -430.61023 -233.42471 0.0 0.0 -1.3082176 0.10612876 0.0 0.0 -22.320168
                                1.9240546 0.0 0.0 -1.306944 0.01895674 0.0 0.0 -1.1855557 -0.45922512 0.0 0.0
                                -1.2835127 -0.3787847 0.0 0.0 -450.16806 -123.48793 0.0 0.0 -1.2049716
                                -0.007846266 0.0 0.0 -1.3242131 -0.10477371 0.0 0.0 -22.170387 3.727651 0.0
                                0.0 -20.467655 10.02957 0.0 0.0 -22.431536 2.2317882 0.0 0.0 -37.114113
                                -8.424044 0.0 0.0 -506.90695 -233.30972 0.0 0.0 -1.0479535 -0.83376557 0.0
                                0.0 -1.2514298 -0.45394418 0.0 0.0 -18.931965 -6.716539 0.0 0.0 -1.3151858
                                0.09205919 0.0 0.0 -19.153883 11.908981 0.0 0.0 -36.381893 10.169221 0.0 0.0
                                -1.3311437 -0.15022524 0.0 0.0 -20.81746 7.183944 0.0 0.0 -1.7038434
                                -0.5153866 0.0 0.0 -1.2462674 -0.3485288 0.0 0.0 -0.99859357 -0.7758982 0.0
                                0.0 -1.2038307 0.5694837 0.0 0.0 -1.148577 0.6342181 0.0 0.0 -1.3237127
                                0.21169241 0.0 0.0 -15.619731 -6.8629656 0.0 0.0 -26.937792 5.9090204 0.0 0.0
                                -1.2759649 0.3818179 0.0 0.0 -1.3311241 0.15954715 0.0 0.0 -1.0363142
                                -0.6525947 0.0 0.0 -1.2716116 0.092146054 0.0 0.0 -1.1688309 -0.6077256 0.0
                                0.0 -14.906203 -11.010032 0.0 0.0 -1.164363 0.34382623 0.0 0.0 -17.27222
                                10.260995 0.0 0.0 -17.782898 -9.408873 0.0 0.0 -1.3120351 0.27823982 0.0 0.0
                                -1.1606655 -0.5786277 0.0 0.0 -1.2182103 0.09658568 0.0 0.0 -1.2928773
                                0.22380517 0.0 0.0 -385.83554 -121.209915 0.0 0.0 -1.2540461 0.2756686 0.0
                                0.0 -369.6097 -105.253746 0.0 0.0 -1.4072024 -0.06658715 0.0 0.0 -1.1706295
                                -0.6264625 0.0 0.0 -1.1920488 -0.10792042 0.0 0.0 -21.356413 2.2781935 0.0
                                0.0 -1.3100291 0.15401123 0.0 0.0 -410.17532 -1.5732467 0.0 0.0 -1.484997
                                -0.24286047 0.0 0.0 -19.98649 -7.41843 0.0 0.0 -23.419256 14.785876 0.0 0.0
                                -1.3009868 -0.17047799 0.0 0.0 -588.4619 -127.42947 0.0 0.0 -19.599546
                                -4.786122 0.0 0.0 -22.26206 -13.071782 0.0 0.0 -1.3297884 0.15195131 0.0 0.0
                                -1.0875207 0.53009033 0.0 0.0 -1.0245528 -0.031191396 0.0 0.0 -354.98245
                                -151.25258 0.0 0.0 -26.943584 6.382003 0.0 0.0 -1.2122376 0.32173854 0.0 0.0
                                -1.216887 -0.47889566 0.0 0.0 -22.881712 0.61225253 0.0 0.0 -0.97824895
                                0.8989923 0.0 0.0 -1.0554467 -0.40018946 0.0 0.0 -25.673256 10.183686 0.0 0.0
                                -20.751877 9.804092 0.0 0.0 -354.233 155.07173 0.0 0.0 -28.341965 -5.1530337
                                0.0 0.0 -19.432241 -12.13918 0.0 0.0 -1.2592599 -0.12801345 0.0 0.0
                                -0.46343917 -1.2035847 0.0 0.0 -23.544748 -6.0052805 0.0 0.0 -25.541578
                                -10.169097 0.0 0.0 -410.78882 -41.763115 0.0 0.0 -1.2732217 0.28943062 0.0
                                0.0 -350.73154 -218.27995 0.0 0.0 -512.28815 -149.59193 0.0 0.0 -1.2262205
                                -0.24216612 0.0 0.0 -512.0839 135.47905 0.0 0.0 -1.2679185 0.36097068 0.0 0.0
                                -20.163622 1.7266649 0.0 0.0 -1.1816992 -0.5559858 0.0 0.0 -1.1140597
                                0.16919193 0.0 0.0 -1.3270351 -0.14950676 0.0 0.0 -18.657978 -10.839662 0.0
                                0.0 -1.0075672 -0.8803714 0.0 0.0 -22.817327 2.9551892 0.0 0.0 -21.724054
                                7.289898 0.0 0.0 -1.3108919 0.23918419 0.0 0.0 -1.4680501 0.5094328 0.0 0.0
                                -1.2841442 0.06280584 0.0 0.0 -0.9460503 -0.9139845 0.0 0.0 -1.2761933
                                -0.40522248 0.0 0.0 -393.2914 -132.2547 0.0 0.0 -28.292183 -5.314454 0.0 0.0
                                -1.0838393 0.76399845 0.0 0.0 -1.3248882 0.06095246 0.0 0.0 -21.483105
                                -2.182644 0.0 0.0 -1.1824417 0.6668116 0.0 0.0 -21.550026 8.088931 0.0 0.0
                                -27.856075 0.13467816 0.0 0.0 -501.62387 -192.72678 0.0 0.0 -722.4672
                                156.5188 0.0 0.0 -22.951977 -1.1392738 0.0 0.0 -27.227736 -0.24641874 0.0 0.0
                                -1.3132793 -0.23242815 0.0 0.0 -1.1153741 0.07155211 0.0 0.0 -1.3187022
                                -0.05248474 0.0 0.0 -1.2298857 -0.47322217 0.0 0.0 -1.1399262 0.6053357 0.0
                                0.0 -1.3277725 -0.15840511 0.0 0.0 -1.2353783 -0.50222117 0.0 0.0 -18.601364
                                13.562978 0.0 0.0 -1.2917231 0.29709262 0.0 0.0 -1.360744 0.0041570365 0.0
                                0.0 -1.4809785 -0.044887707 0.0 0.0 -1.0168595 -0.7548828 0.0 0.0 -21.398094
                                -6.759507 0.0 0.0 -0.9806672 0.72764426 0.0 0.0 -21.303322 8.641821 0.0 0.0
                                -36.611095 -12.138297 0.0 0.0 -1.0651387 0.038969796 0.0 0.0 -1.2902495
                                -0.26455274 0.0 0.0 -21.69561 0.096518196 0.0 0.0 -572.16644 72.301796 0.0
                                0.0 -1.3406606 -0.01333178 0.0 0.0 -18.190456 -8.915716 0.0 0.0 -0.95014566
                                0.0035621524 0.0 0.0 -302.00977 85.10535 0.0 0.0 -21.116869 3.2904742 0.0 0.0
                                -275.7752 279.41943 0.0 0.0 -1.3762517 -0.29553425 0.0 0.0 -1.1412431
                                -0.6701441 0.0 0.0 -1.048146 -0.6163934 0.0 0.0 -1.1950837 -0.38523975 0.0
                                0.0 -22.11342 6.4391494 0.0 0.0 -1.3358568 0.11897852 0.0 0.0 -20.082022
                                3.4762475 0.0 0.0 -1.3177825 -0.122086294 0.0 0.0 -287.42953 -288.5317 0.0
                                0.0 -396.48224 -137.71011 0.0 0.0 -1.2700727 0.37354803 0.0 0.0 -18.993208
                                -10.567613 0.0 0.0 -1.2521752 -0.2435608 0.0 0.0 -1.2314081 -0.46066266 0.0
                                0.0 -438.39468 -93.351036 0.0 0.0 -1.2932022 0.1577463 0.0 0.0 -34.18
                                10.884189 0.0 0.0 -1.2722201 -0.059861887 0.0 0.0 -20.328436 -10.294917 0.0
                                0.0 -1.3402327 0.029578632 0.0 0.0 -1.1340733 -0.40015873 0.0 0.0 -21.712357
                                -1.5628535 0.0 0.0 -1.2004828 -0.124456875 0.0 0.0 -1.3164762 -0.11545912 0.0
                                0.0 -1.2987745 -0.056691162 0.0 0.0 -24.5692 -3.104581 0.0 0.0 -1.3231124
                                0.07933183 0.0 0.0 -23.122189 2.0204363 0.0 0.0 -22.112879 7.057485 0.0 0.0
                                -386.63702 82.649086 0.0 0.0 -1.2876167 0.30102333 0.0 0.0 -479.22656
                                -180.94035 0.0 0.0 -23.164616 -1.6329964 0.0 0.0 -1.2426456 0.34766716 0.0
                                0.0 -1.0904553 0.27302814 0.0 0.0 -22.380901 -4.6395006 0.0 0.0 -1.3306992
                                0.06357771 0.0 0.0 -22.695782 4.901111 0.0 0.0 -1.192984 0.46373093 0.0 0.0
                                -1.3179148 -0.222777 0.0 0.0 -1.3524141 0.7194226 0.0 0.0 -19.79723 11.888681
                                0.0 0.0 -20.309792 7.9661136 0.0 0.0 -1.2532847 -0.2763578 0.0 0.0 -1.2163644
                                -0.44770846 0.0 0.0 -406.11093 -119.75827 0.0 0.0 -1.3074473 -0.07733373 0.0
                                0.0 -21.784332 -1.5737991 0.0 0.0 -1.5699723 -1.3404119 0.0 0.0 -1.2880929
                                -0.3412198 0.0 0.0 -20.228136 -11.292126 0.0 0.0 -23.651024 7.5273848 0.0 0.0
                                -21.781706 -1.8207507 0.0 0.0 -1.3280594 0.07153508 0.0 0.0 -23.114822
                                12.939757 0.0 0.0 -1.2344203 -0.3941844 0.0 0.0 -1.2712319 -0.30744386 0.0
                                0.0 -1.2576685 0.2159925 0.0 0.0 -1.2463555 0.0688183 0.0 0.0 -547.17615
                                -600.67 0.0 0.0 -26.283348 2.3815162 0.0 0.0 -24.824413 1.5834361 0.0 0.0
                                -19.900509 4.8228354 0.0 0.0 -1044.8225 -143.39606 0.0 0.0 -43.4317 9.062474
                                0.0 0.0 -1.2143557 -0.019144103 0.0 0.0 -378.5659 125.46848 0.0 0.0
                                -1.1775507 -0.49295458 0.0 0.0 -21.661997 -2.952503 0.0 0.0 -1.1859524
                                -0.33883145 0.0 0.0 -1.2151815 0.05129321 0.0 0.0 -546.95026 -219.93286 0.0
                                0.0 -21.800758 7.248795 0.0 0.0 -1.2303445 -0.44592562 0.0 0.0 -469.86707
                                -122.3536 0.0 0.0 -1.1611434 0.36977232 0.0 0.0 -1.2895666 -0.20658095 0.0
                                0.0 -390.01715 -88.0978 0.0 0.0 -27.162111 -4.8582835 0.0 0.0 -1.071661
                                -0.74720895 0.0 0.0 -0.6536474 0.25934428 0.0 0.0 -22.46532 -6.3933606 0.0
                                0.0 -22.832947 -0.9335335 0.0 0.0 -21.551876 -4.1238327 0.0 0.0 -806.39624
                                -143.33408 0.0 0.0 -389.9245 91.82496 0.0 0.0 -1.3041896 -0.23744752 0.0 0.0
                                -1.3366741 0.022405708 0.0 0.0 -425.88806 -40.644093 0.0 0.0 -427.91724
                                2.7807531 0.0 0.0 -1.2523392 0.54186875 0.0 0.0 -21.058863 2.948973 0.0 0.0
                                -1250.9316 -335.51526 0.0 0.0 -1.1941974 0.44807652 0.0 0.0 -1.3311862
                                0.03236866 0.0 0.0 -421.80283 -75.72002 0.0 0.0 -20.077633 -4.618941 0.0 0.0
                                -1.2926773 -0.18673632 0.0 0.0 -1.3127873 -0.19634661 0.0 0.0 -1.3341889
                                0.09244772 0.0 0.0 -369.47443 -43.910442 0.0 0.0 -21.822826 2.3005838 0.0 0.0
                                -23.197758 -3.1599128 0.0 0.0 -26.658909 -1.7459146 0.0 0.0 -1.1030368
                                -0.7497853 0.0 0.0 -1.0026222 -0.8270164 0.0 0.0 -1.1304002 0.71169865 0.0
                                0.0 -391.94498 -92.23057 0.0 0.0 -1.2991415 0.19893686 0.0 0.0 -1.5603538
                                -0.7362329 0.0 0.0 -1.075715 0.73213893 0.0 0.0 -17.551664 -15.190621 0.0 0.0
                                -1.4958196 -0.84979194 0.0 0.0 -558.7908 -1.6312659 0.0 0.0 -1.1930534
                                -0.5912201 0.0 0.0 -1.2733562 -0.19429979 0.0 0.0 -1.2879065 0.1286453 0.0
                                0.0 -31.042824 9.730141 0.0 0.0 -1.4577767 -0.28557786 0.0 0.0 -1.3043333
                                -0.10613621 0.0 0.0 -1.095363 0.6234351 0.0 0.0 -1.4513634 0.23604643 0.0 0.0
                                -22.024971 -1.0499413 0.0 0.0 -1.0966852 -0.23515494 0.0 0.0 -22.957945
                                -15.551698 0.0 0.0 -45.29252 -15.163756 0.0 0.0 -44.261414 8.5809355 0.0 0.0
                                -1.317693 -0.2349573 0.0 0.0 -1.269305 -0.3237633 0.0 0.0 -1.3073504
                                0.09158429 0.0 0.0 -372.2282 -159.11227 0.0 0.0 -19.99151 -4.765375 0.0 0.0
                                -1.3830861 0.59825474 0.0 0.0 -1.0582143 0.41920418 0.0 0.0 -1.1882476
                                -0.58175963 0.0 0.0 -1.3467528 -0.4472335 0.0 0.0 -18.8488 13.918324 0.0 0.0
                                -22.999563 -4.848317 0.0 0.0 -1.5355994 -0.1907565 0.0 0.0 -1.1243674
                                0.24676722 0.0 0.0 -1.3208989 0.20004353 0.0 0.0 -444.00174 -129.95772 0.0
                                0.0 -21.171377 -9.504927 0.0 0.0 -22.558119 6.558941 0.0 0.0 -1.3121448
                                -0.027622294 0.0 0.0 -22.106295 -0.52157784 0.0 0.0 -20.831734 2.1205647 0.0
                                0.0 -1.3207016 -0.06441921 0.0 0.0 -391.08887 110.87886 0.0 0.0 -22.875443
                                4.3740716 0.0 0.0 -1.1253744 0.6583077 0.0 0.0 -427.76617 -75.32006 0.0 0.0
                                -316.4704 -297.64706 0.0 0.0 -516.84686 112.86577 0.0 0.0 -388.9463
                                -120.10537 0.0 0.0 -1.2631893 0.009885162 0.0 0.0 -1.2354205 -0.13153231 0.0
                                0.0 -0.87890124 -0.78410447 0.0 0.0 -26.986282 -14.609576 0.0 0.0 -21.90359
                                -0.8930749 0.0 0.0 -0.67084676 -0.6461936 0.0 0.0 -1.2317345 0.49305066 0.0
                                0.0 -20.579542 2.6290407 0.0 0.0 -17.384548 15.043118 0.0 0.0 -22.140987
                                -0.95610833 0.0 0.0 -17.772577 -10.543145 0.0 0.0 -1.1768987 0.029478922 0.0
                                0.0 -0.9686604 -0.83250153 0.0 0.0 -21.864386 8.838817 0.0 0.0 -23.015167
                                -4.609829 0.0 0.0 -28.15417 -5.1021757 0.0 0.0 -1.2289615 -0.27994168 0.0 0.0
                                -20.617386 -2.5918324 0.0 0.0 -326.85214 -245.63174 0.0 0.0 -1.2859564
                                -0.27274996 0.0 0.0 -0.99663734 -0.83808446 0.0 0.0 -1.3111937 -0.27175686
                                0.0 0.0 -27.855206 -3.7568278 0.0 0.0 -23.070074 5.075701 0.0 0.0 -1.1660105
                                0.11890243 0.0 0.0 -20.552004 14.423468 0.0 0.0 -21.774137 4.325254 0.0 0.0
                                -498.62552 -22.18398 0.0 0.0 -1.0433489 -0.8321475 0.0 0.0 -26.317936
                                9.552939 0.0 0.0 -1.2606637 0.34821343 0.0 0.0 -1.2059863 -0.3661911 0.0 0.0
                                -1.2462862 0.27093568 0.0 0.0 -1.3312486 -0.08970687 0.0 0.0 -20.44536
                                -8.65324 0.0 0.0 -20.803385 1.1242397 0.0 0.0 -21.537552 5.5314345 0.0 0.0
                                -1.2528236 -0.4665537 0.0 0.0 -1.175282 0.6317301 0.0 0.0 -22.761969
                                -6.4769287 0.0 0.0 -1.2327633 0.36808115 0.0 0.0 -85.74063 68.75242 0.0 0.0
                                -24.187492 14.494638 0.0 0.0 -1.2179644 -0.44938385 0.0 0.0 -1.2650383
                                -0.15860179 0.0 0.0 -1.2110784 -0.3321481 0.0 0.0 -20.64321 -1.0037664 0.0
                                0.0 -19.629322 -6.5480027 0.0 0.0 -23.434633 -4.014011 0.0 0.0 -0.9954378
                                -0.4249233 0.0 0.0 -1.3371792 0.05090467 0.0 0.0 -1.2824152 -0.32933074 0.0
                                0.0 -25.417126 -13.888005 0.0 0.0 -1.3091092 -0.5267444 0.0 0.0 -1.3327751
                                0.15316461 0.0 0.0 -21.821003 -3.470388 0.0 0.0 -1.239264 -0.40925822 0.0 0.0
                                -1.2724749 -0.40109643 0.0 0.0 -1.3277588 -0.0948787 0.0 0.0 -1.1034114
                                0.6663978 0.0 0.0 -1.2530937 0.046686538 0.0 0.0 -1.5665276 -0.094786674 0.0
                                0.0 -23.64401 -1.8817213 0.0 0.0 -0.9229978 -0.9519521 0.0 0.0 -1.2923428
                                0.5260932 0.0 0.0 -1.1727008 0.21112552 0.0 0.0 -1.2860659 0.23485695 0.0 0.0
                                -21.468966 -13.664055 0.0 0.0 -1.3147736 0.23446089 0.0 0.0 -1.0512233
                                -1.1629207 0.0 0.0 -21.341154 1.7814914 0.0 0.0 -1.1735247 0.55939895 0.0 0.0
                                -371.75766 -52.736515 0.0 0.0 -2.290815 0.19970635 0.0 0.0 -1.1853042
                                0.5545576 0.0 0.0 -0.9843514 0.59585387 0.0 0.0 -51.603336 -10.249519 0.0 0.0
                                -442.81024 0.86028403 0.0 0.0 -11.849348 -17.112827 0.0 0.0 -1.1585605
                                -0.022329532 0.0 0.0 -1.1850885 0.21749376 0.0 0.0 -432.68906 -96.09474 0.0
                                0.0 -0.9077435 -0.13312046 0.0 0.0 -1.2641422 0.25973767 0.0 0.0 -22.140165
                                -3.1689253 0.0 0.0 -1.3196633 -0.10871271 0.0 0.0 -1.0717137 0.4945384 0.0
                                0.0 -1.3236852 -0.1645113 0.0 0.0 -1.1530566 -0.6289759 0.0 0.0 -21.953074
                                8.903152 0.0 0.0 -1.28335 0.13293484 0.0 0.0 -27.746807 1.0199177 0.0 0.0
                                -1.178754 -0.58759165 0.0 0.0 -576.79364 -55.93734 0.0 0.0 -1.1785403
                                0.023940336 0.0 0.0 -21.641983 -5.4459076 0.0 0.0 -1.296692 -0.15340282 0.0
                                0.0 -471.11267 63.928833 0.0 0.0 -22.943783 4.5499473 0.0 0.0 -1.255171
                                0.46431583 0.0 0.0 -1.2755042 -0.14674957 0.0 0.0 -1.3156015 0.1396613 0.0
                                0.0 -1.2589447 -0.4007138 0.0 0.0 -23.740074 -0.79757893 0.0 0.0 -21.16242
                                -6.9186273 0.0 0.0 -26.502678 -6.6924176 0.0 0.0 -414.27637 235.38301 0.0 0.0
                                -1.1719627 0.5990552 0.0 0.0 -22.360224 -1.3662587 0.0 0.0 -1.255149
                                -0.4097337 0.0 0.0 -1.3284074 0.18114984 0.0 0.0 -34.7125 -13.010666 0.0 0.0
                                -1.4567893 0.0833588 0.0 0.0 -22.4056 -1.1621442 0.0 0.0 -1.3143753
                                0.14334154 0.0 0.0 -1.2391584 0.45783597 0.0 0.0 -1.3131963 0.17854482 0.0
                                0.0 -21.78157 5.444475 0.0 0.0 -0.7051779 -0.9224596 0.0 0.0 -36.795673
                                -9.7648735 0.0 0.0 -1.3265096 0.118737005 0.0 0.0 -23.529207 -4.116237 0.0
                                0.0 -1.2529836 0.121504106 0.0 0.0 -349.1253 114.77016 0.0 0.0 -1.3314527
                                -0.15372628 0.0 0.0 -1.1851094 -0.013354339 0.0 0.0 -20.259687 12.44833 0.0
                                0.0 -417.20386 -163.45038 0.0 0.0 -1.329586 0.49151087 0.0 0.0 -1.2352642
                                -0.32608846 0.0 0.0 -410.35648 -175.36807 0.0 0.0 -1.0260992 -0.18548416 0.0
                                0.0 -1.245918 -0.41929355 0.0 0.0 -1.254033 -0.47491637 0.0 0.0 -23.956898
                                -2.0277753 0.0 0.0 -1.2950556 -0.52848303 0.0 0.0 -1.2411969 -0.44396123 0.0
                                0.0 -21.033049 -0.3195781 0.0 0.0 -48.66308 -7.9615498 0.0 0.0 -21.861084
                                5.3528757 0.0 0.0 -1.3977427 0.47337118 0.0 0.0 -1.3128588 -0.0864316 0.0 0.0
                                -1.128473 0.21559723 0.0 0.0 -1.4615519 0.27201408 0.0 0.0 -1.29243
                                -0.1394462 0.0 0.0 -1.3150613 0.26291794 0.0 0.0 -1.202686 0.47856024 0.0 0.0
                                -1.2515597 -0.47389716 0.0 0.0 -23.919273 -1.2455883 0.0 0.0 -1.3042833
                                -0.30957016 0.0 0.0 -1.1227592 -0.7209574 0.0 0.0 -1.3384004 0.09103964 0.0
                                0.0 -1.3305501 -0.01028195 0.0 0.0 -0.8143498 -0.801255 0.0 0.0 -1.3371811
                                -0.042484283 0.0 0.0 -1.2644311 -0.38428333 0.0 0.0 -1.2480028 0.0072869803
                                0.0 0.0 -1.1172475 -0.59771216 0.0 0.0 -25.618597 -9.898468 0.0 0.0
                                -922.51605 -188.24275 0.0 0.0 -1.2761575 0.18420719 0.0 0.0 -23.469698
                                -4.889228 0.0 0.0 -480.8937 45.238426 0.0 0.0 -1.2964242 0.26663485 0.0 0.0
                                -22.477009 -12.606615 0.0 0.0 -1.3397496 -0.016532892 0.0 0.0 -1.2553086
                                -0.14251354 0.0 0.0 -23.700308 0.17049623 0.0 0.0 -1.1527661 0.39703575 0.0
                                0.0 -25.1406 -4.603907 0.0 0.0 -57.405655 -1.5523489 0.0 0.0 -21.13878
                                0.458237 0.0 0.0 -427.87732 -119.09716 0.0 0.0 -24.763243 -3.182534 0.0 0.0
                                -20.583815 -4.8400617 0.0 0.0 -1.241402 0.4158757 0.0 0.0 -1.3209586
                                -0.12641546 0.0 0.0 -26.064001 -12.056148 0.0 0.0 -1.3150935 -0.17665282 0.0
                                0.0 -1.0854297 0.45603654 0.0 0.0 -24.093752 -2.1133769 0.0 0.0 -0.995623
                                -0.79032403 0.0 0.0 -490.60727 169.29637 0.0 0.0 -440.6865 -109.219444 0.0
                                0.0 -20.310604 -13.130174 0.0 0.0 -0.8067282 -1.0321195 0.0 0.0 -16.958372
                                -14.726073 0.0 0.0 -1.1764629 -0.5820764 0.0 0.0 -517.2282 -51.38598 0.0 0.0
                                -1.0904659 -0.6987809 0.0 0.0 -1.2003446 0.1263882 0.0 0.0 -1.3340117
                                0.16852589 0.0 0.0 -1.0078497 -0.49444386 0.0 0.0 -30.050665 -15.518175 0.0
                                0.0 -18.81151 9.761949 0.0 0.0 -18.142885 13.541568 0.0 0.0 -772.98474
                                -442.92548 0.0 0.0 -1.1934179 0.22458057 0.0 0.0 -425.77515 -15.025657 0.0
                                0.0 -19.35887 -8.685455 0.0 0.0 -1.2518737 0.07925253 0.0 0.0 -0.96492636
                                -0.6396032 0.0 0.0 -1.2616172 0.0010523946 0.0 0.0 -22.216988 5.9245524 0.0
                                0.0 -21.9022 -10.390101 0.0 0.0 -49.901043 8.239207 0.0 0.0 -21.256845
                                11.080697 0.0 0.0 -25.247473 -0.33831325 0.0 0.0 -21.222876 -0.622804 0.0 0.0
                                -27.055983 12.139546 0.0 0.0 -1.1858565 0.26381698 0.0 0.0 -24.183456
                                1.7161664 0.0 0.0 -29.668053 -0.76776594 0.0 0.0 -29.2662 8.90619 0.0 0.0
                                -1.2732297 0.019720301 0.0 0.0 -22.063728 -22.773735 0.0 0.0 -21.575167
                                20.249708 0.0 0.0 -19.987637 7.2135344 0.0 0.0 -1.1605774 0.51111144 0.0 0.0
                                -1.322532 -0.0038177667 0.0 0.0 -1.3400474 0.025022702 0.0 0.0 -1.2676276
                                -0.42446977 0.0 0.0 -1.2250525 -0.37514642 0.0 0.0 -36.116318 3.9135232 0.0
                                0.0 -1.2096044 -0.5009965 0.0 0.0 -1.2516469 0.12469224 0.0 0.0 -1.212239
                                0.5444926 0.0 0.0 -478.64954 -101.01582 0.0 0.0 -502.11823 -153.24547 0.0 0.0
                                -415.86874 105.46955 0.0 0.0 -25.972445 -1.6809827 0.0 0.0 -24.073605
                                3.3187802 0.0 0.0 -23.96392 -0.29793638 0.0 0.0 -1.1658274 0.30738834 0.0 0.0
                                -1.3023078 -0.094279476 0.0 0.0 -1.3023717 -0.29787067 0.0 0.0 -1.3328792
                                -0.008232216 0.0 0.0 -403.2349 220.91838 0.0 0.0 -1.2761126 0.14557943 0.0
                                0.0 -543.42236 -147.72798 0.0 0.0 -421.2062 -254.66754 0.0 0.0 -15.7938795
                                8.840675 0.0 0.0 -24.223312 23.997694 0.0 0.0 -22.16308 -4.896847 0.0 0.0
                                -430.40457 -8.42946 0.0 0.0 -23.893839 -3.8025868 0.0 0.0 -1.1804622
                                -0.625786 0.0 0.0 -1.3260338 0.13448688 0.0 0.0 -1.1800916 -0.6127122 0.0 0.0
                                -1.2106922 0.24037038 0.0 0.0 -0.48296198 -0.37480062 0.0 0.0 -24.241032
                                0.3672032 0.0 0.0 -21.281195 1.4872442 0.0 0.0 -21.45004 17.847263 0.0 0.0
                                -23.238579 -7.449774 0.0 0.0 -22.141178 5.4959354 0.0 0.0 -0.732997
                                -1.0216361 0.0 0.0 -1.2988474 -0.22871904 0.0 0.0 -1.2930574 -0.10241254 0.0
                                0.0 -1.2131544 0.50916934 0.0 0.0 -21.526524 7.633138 0.0 0.0 -22.6757
                                7.895629 0.0 0.0 -1.197255 -0.59502655 0.0 0.0 -430.66687 -168.82915 0.0 0.0
                                -1.0345078 -0.7031118 0.0 0.0 -24.22853 -1.5539792 0.0 0.0 -1.3157842
                                0.17503071 0.0 0.0 -24.089197 1.6050655 0.0 0.0 -23.620098 5.564554 0.0 0.0
                                -495.54648 10.229767 0.0 0.0 -1.2625338 -0.32619342 0.0 0.0 -1.0161189
                                0.8194682 0.0 0.0 -21.066103 -11.943642 0.0 0.0 -38.412468 -7.820846 0.0 0.0
                                -22.831013 1.573333 0.0 0.0 -691.95056 -78.34972 0.0 0.0 -374.61032 14.290673
                                0.0 0.0 -1.3267664 0.11881664 0.0 0.0 -405.66156 153.66046 0.0 0.0 -1.3193696
                                -0.16189629 0.0 0.0 -1.2606466 -0.21287286 0.0 0.0 -1.1721966 0.58026403 0.0
                                0.0 -21.745544 -7.193554 0.0 0.0 -1.3142309 -0.0052842796 0.0 0.0 -1.2121339
                                0.14401755 0.0 0.0 -1.1785223 0.057226863 0.0 0.0 -404.11136 346.9072 0.0 0.0
                                -1.153356 -0.43981418 0.0 0.0 -1.1873405 0.4778959 0.0 0.0 -15.246057
                                -14.969067 0.0 0.0 -1.120764 -0.14202182 0.0 0.0 -1.740666 -0.6343093 0.0 0.0
                                -1.0963721 -0.75435084 0.0 0.0 -1.3365761 -0.11128861 0.0 0.0 -23.949999
                                17.867186 0.0 0.0 -1.6685579 -0.6823876 0.0 0.0 -1.3003688 0.024196334 0.0
                                0.0 -1.175465 -0.48900926 0.0 0.0 -1.2203274 0.19089027 0.0 0.0 -1.2815329
                                -0.36240253 0.0 0.0 -1.3208665 -0.13369018 0.0 0.0 -26.249065 -2.9204795 0.0
                                0.0 -444.7537 -141.69342 0.0 0.0 -421.89124 -110.90424 0.0 0.0 -1.3133149
                                -0.1724324 0.0 0.0 -0.98962003 -0.8878066 0.0 0.0 -1.0555786 -0.8098038 0.0
                                0.0 -21.20581 -10.528281 0.0 0.0 -1.2288066 -0.53546226 0.0 0.0 -24.211916
                                -3.0209658 0.0 0.0 -1.0879748 -0.5128615 0.0 0.0 -453.75964 113.552635 0.0
                                0.0 -516.4754 -143.41974 0.0 0.0 -22.964514 -8.06583 0.0 0.0 -1.2518148
                                -0.13022462 0.0 0.0 -20.830296 -9.139559 0.0 0.0 -22.857948 2.4256213 0.0 0.0
                                -34.475384 -19.323362 0.0 0.0 -0.8482356 -1.0219822 0.0 0.0 -1.1982888
                                -0.6013325 0.0 0.0 -1.2786087 -0.03274944 0.0 0.0 -1.2545619 0.007212699 0.0
                                0.0 -29.750355 0.22092034 0.0 0.0 -1.3002295 0.43520445 0.0 0.0 -17.536028
                                12.384592 0.0 0.0 -20.732967 -5.755293 0.0 0.0 -1.4750705 5.7661533e-4 0.0
                                0.0 -1.7686383 -0.8758675 0.0 0.0 -18.29988 -14.624947 0.0 0.0 -481.17056
                                -145.94556 0.0 0.0 -1.3360746 -0.098964006 0.0 0.0 -1.2010899 -0.5737876 0.0
                                0.0 -22.462336 5.089525 0.0 0.0 -1.2435689 -0.49472585 0.0 0.0 -1.3006032
                                -0.26067773 0.0 0.0 -1.0679142 -0.72159916 0.0 0.0 -403.2902 -174.56714 0.0
                                0.0 -1.0152164 -0.45885405 0.0 0.0 -452.14395 130.77548 0.0 0.0 -1.0697039
                                -1.0103495 0.0 0.0 -1.265125 -0.23399207 0.0 0.0 -1.2061952 -0.05306644 0.0
                                0.0 -1.293743 -0.21701619 0.0 0.0 -1.2374752 -0.5174109 0.0 0.0 -1.1236159
                                0.11064753 0.0 0.0 -708.68866 -43.681564 0.0 0.0 -1.1935393 -0.31675634 0.0
                                0.0 -22.03868 -10.7147 0.0 0.0 -23.716717 -6.8522434 0.0 0.0 -24.199446
                                3.439732 0.0 0.0 -1.3137043 -0.20540895 0.0 0.0 -0.82885844 0.85889685 0.0
                                0.0 -1.3039238 0.3145582 0.0 0.0 -27.339506 7.3840795 0.0 0.0 -1.2359229
                                -0.13588692 0.0 0.0 -1.3316325 -0.057256952 0.0 0.0 -1.297531 0.041850023 0.0
                                0.0 -1.3402547 -0.045149412 0.0 0.0 -23.904528 -15.204799 0.0 0.0 -1.1759858
                                -0.0434716 0.0 0.0 -45.467907 -3.6862524 0.0 0.0 -1.1967782 0.40924212 0.0
                                0.0 -1.3266461 0.16730039 0.0 0.0 -1.289302 0.08787884 0.0 0.0 -1.3263206
                                -0.09463285 0.0 0.0 -27.385897 -6.408334 0.0 0.0 -0.98299176 -0.85987926 0.0
                                0.0 -1.2808574 0.18346089 0.0 0.0 -24.854404 12.200548 0.0 0.0 -504.3259
                                -57.79026 0.0 0.0 -1.3351694 0.10949593 0.0 0.0 -1.0607257 -0.7513402 0.0 0.0
                                -1.2369108 -0.5058888 0.0 0.0 -90.60977 -1.1117841 0.0 0.0 -1.2250899
                                0.2928586 0.0 0.0 -1.3052602 -0.017469965 0.0 0.0 -24.23927 -0.90283585 0.0
                                0.0 -430.92377 -270.12866 0.0 0.0 -21.940056 -10.964392 0.0 0.0 -23.849936
                                5.994646 0.0 0.0 -21.1755 -12.317435 0.0 0.0 -30.052374 3.903649 0.0 0.0
                                -22.387577 -10.158412 0.0 0.0 -1.0972327 -0.765172 0.0 0.0 -30.408861
                                1.6172802 0.0 0.0 -1.0780132 -0.7969142 0.0 0.0 -19.780945 -1.5811887 0.0 0.0
                                -1.1235436 -0.647415 0.0 0.0 -17.222992 -12.07673 0.0 0.0 -22.159163
                                -5.699757 0.0 0.0 -1.319926 -0.18844213 0.0 0.0 -1.4270912 0.0523757 0.0 0.0
                                -2.6002898 -0.47121236 0.0 0.0 -40.72154 -21.290968 0.0 0.0 -435.7244
                                -35.4519 0.0 0.0 -1.1964173 -0.4918859 0.0 0.0 -1.3256558 -0.30174974 0.0 0.0
                                -510.70157 -17.680893 0.0 0.0 -1.3285291 -0.022147095 0.0 0.0 -21.170385
                                -4.7328486 0.0 0.0 -24.637177 -0.7725053 0.0 0.0 -23.841177 -5.78703 0.0 0.0
                                -23.176764 -5.528702 0.0 0.0 -1.0095876 -0.8819213 0.0 0.0 -23.092918
                                -6.925906 0.0 0.0 -24.631208 0.4348614 0.0 0.0 -23.687817 -2.2183325 0.0 0.0
                                -1.1756523 -0.32801592 0.0 0.0 -1.2733217 0.17079943 0.0 0.0 -22.28177
                                -10.2558155 0.0 0.0 -1.268248 0.30773112 0.0 0.0 -0.4526484 -1.2588178 0.0
                                0.0 -1.3504118 -0.20629176 0.0 0.0 -16.705101 -2.6749816 0.0 0.0 -442.18265
                                66.27705 0.0 0.0 -1.18883 -0.4974038 0.0 0.0 -19.172327 -10.234992 0.0 0.0
                                -1.1530206 0.24031946 0.0 0.0 -1.0601206 -0.6886842 0.0 0.0 -21.598707
                                -2.475054 0.0 0.0 -1.2914333 0.08115683 0.0 0.0 -418.41483 -159.58119 0.0 0.0
                                -624.1387 99.18362 0.0 0.0 -0.9691842 0.060548715 0.0 0.0 -26.78589 7.2404013
                                0.0 0.0 -1.4021354 0.47690305 0.0 0.0 -1.2626524 -0.17287824 0.0 0.0
                                -1.333596 -0.21390301 0.0 0.0 -21.707756 -1.5514662 0.0 0.0 -1.2773359
                                -0.3994571 0.0 0.0 -1.2373314 -0.36044636 0.0 0.0 -1.3150206 -0.26166216 0.0
                                0.0 -1.2497681 0.018088065 0.0 0.0 -1.2572342 -0.28351396 0.0 0.0 -1.1953759
                                -0.30020756 0.0 0.0 -21.387178 9.297873 0.0 0.0 -22.74939 -9.977371 0.0 0.0
                                -449.53647 172.46082 0.0 0.0 -447.4931 42.384224 0.0 0.0 -17.15845 -12.987304
                                0.0 0.0 -1.3050277 -0.0877828 0.0 0.0 -1.3257866 -0.10881127 0.0 0.0
                                -26.400793 -9.054782 0.0 0.0 -396.00482 -213.7107 0.0 0.0 -1.000364
                                -0.06873695 0.0 0.0 -1.2270507 -0.5230603 0.0 0.0 -1.2222036 -0.5338068 0.0
                                0.0 -21.74248 1.2461923 0.0 0.0 -591.45404 52.625187 0.0 0.0 -1.3119959
                                -0.17050439 0.0 0.0 -19.350134 6.786329 0.0 0.0 -1.3159349 0.2573928 0.0 0.0
                                -1.2635775 -0.3223715 0.0 0.0 -503.45853 121.0576 0.0 0.0 -1.1532791
                                -0.39838785 0.0 0.0 -784.0585 16.174496 0.0 0.0 -27.017653 -6.123062 0.0 0.0
                                -1.2680674 -0.38444874 0.0 0.0 -24.094404 5.886302 0.0 0.0 -22.053228
                                -7.7430725 0.0 0.0 -24.28856 2.3345788 0.0 0.0 -1.3245584 0.01093741 0.0 0.0
                                -480.36868 -61.05009 0.0 0.0 -1.3096069 -0.24815486 0.0 0.0 -20.0181 8.707583
                                0.0 0.0 -2.3782818 0.03685087 0.0 0.0 -451.46454 -27.034689 0.0 0.0
                                -1.2976967 -0.31056193 0.0 0.0 -590.1907 -88.408264 0.0 0.0 -500.34116
                                28.170593 0.0 0.0 -21.537895 10.474335 0.0 0.0 -536.2879 -151.50839 0.0 0.0
                                -1.0657207 0.30810297 0.0 0.0 -25.055708 -0.46881914 0.0 0.0 -1.3383433
                                0.046379287 0.0 0.0 -1.2421383 -0.41764304 0.0 0.0 -1.2027576 -0.35502684 0.0
                                0.0 -19.879642 -5.113739 0.0 0.0 -416.82977 -178.56267 0.0 0.0 -641.29584
                                8.692151 0.0 0.0 -20.663063 10.997737 0.0 0.0 -1.3087249 0.010037519 0.0 0.0
                                -1.1519611 0.6840239 0.0 0.0 -1.3317534 -0.15908894 0.0 0.0 -1.1615552
                                -0.43499315 0.0 0.0 -1.1543572 0.65933096 0.0 0.0 -29.530521 -1.7112838 0.0
                                0.0 -1.0797766 -0.7920378 0.0 0.0 -21.882154 1.0319028 0.0 0.0 -20.890587
                                3.3589597 0.0 0.0 -1.1002041 -0.75614667 0.0 0.0 -21.416336 -4.0609283 0.0
                                0.0 -519.8156 -53.62376 0.0 0.0 -20.495998 11.454856 0.0 0.0 -1.2976618
                                -0.23773123 0.0 0.0 -23.355532 8.305845 0.0 0.0 -21.55481 3.5380623 0.0 0.0
                                -434.08118 355.06546 0.0 0.0 -1.3161447 -0.1450023 0.0 0.0 -35.338017
                                -14.056079 0.0 0.0 -0.9532772 0.21494663 0.0 0.0 -21.911472 -0.9813573 0.0
                                0.0 -1.291601 -0.042260554 0.0 0.0 -888.2079 212.88237 0.0 0.0 -1.0410166
                                -0.81518334 0.0 0.0 -1.0508299 -0.7970959 0.0 0.0 -1.2920011 0.10777535 0.0
                                0.0 -24.229416 5.9190755 0.0 0.0 -1.6102655 0.13990733 0.0 0.0 -38.820778
                                12.928651 0.0 0.0 -25.844915 16.946268 0.0 0.0 -19.631172 15.232581 0.0 0.0
                                -1.2906607 -0.034028668 0.0 0.0 -28.97792 15.91563 0.0 0.0 -29.34661
                                -5.941342 0.0 0.0 -1.0736295 0.39679882 0.0 0.0 -24.522118 -1.2810044 0.0 0.0
                                -21.957006 0.91384023 0.0 0.0 -1.1031693 -0.6982688 0.0 0.0 -1.3183402
                                0.14081825 0.0 0.0 -1.2471198 0.27787215 0.0 0.0 -490.695 7.636453 0.0 0.0
                                -1.316936 -0.016397096 0.0 0.0 -18.138737 -16.261412 0.0 0.0 -1.3150305
                                -0.039524604 0.0 0.0 -31.383886 16.866236 0.0 0.0 -481.54028 -97.48811 0.0
                                0.0 -1.2967027 -0.023805201 0.0 0.0 -1.2433212 0.31396025 0.0 0.0 -28.915882
                                0.63051015 0.0 0.0 -1.0605613 0.76711017 0.0 0.0 -2.5526114 0.8463252 0.0 0.0
                                -23.583544 -8.176535 0.0 0.0 -1.347127 0.41181773 0.0 0.0 -1.3541652
                                -0.5601643 0.0 0.0 -1.3009884 0.13523878 0.0 0.0 -25.958122 7.6761775 0.0 0.0
                                -1.2013555 -0.17945254 0.0 0.0 -1.2540867 -0.47283757 0.0 0.0 -24.70927
                                -2.333609 0.0 0.0 -1.3354279 0.12194233 0.0 0.0 -1.1198651 0.5126881 0.0 0.0
                                -25.305937 0.56348026 0.0 0.0 -1.389833 0.16481726 0.0 0.0 -1.2909807
                                -0.33894622 0.0 0.0 -1.1016577 -0.7298458 0.0 0.0 -1.195286 -0.24814044 0.0
                                0.0 -846.80817 -165.94542 0.0 0.0 -0.590917 -1.1773489 0.0 0.0 -21.853825
                                -2.7871957 0.0 0.0 -25.587002 -9.052136 0.0 0.0 -20.401596 11.599255 0.0 0.0
                                -1.3000158 -0.12755609 0.0 0.0 -1.331922 -0.052128028 0.0 0.0 -1.3142016
                                0.040521998 0.0 0.0 -32.28938 -7.404601 0.0 0.0 -19.93809 -12.202182 0.0 0.0
                                -19.330404 -10.623683 0.0 0.0 -1.3022476 0.22601426 0.0 0.0 -1.2947122
                                -0.013766699 0.0 0.0 -29.112823 -1.5531663 0.0 0.0 -1.2818958 0.09412621 0.0
                                0.0 -1.2931504 0.26658294 0.0 0.0 -1.1921548 -0.27076906 0.0 0.0 -27.048033
                                -2.959704 0.0 0.0 -1.3890793 0.46233538 0.0 0.0 -427.6125 315.9693 0.0 0.0
                                -20.25349 8.501904 0.0 0.0 -24.934504 1.1191074 0.0 0.0 -1.2943428
                                -0.30952466 0.0 0.0 -472.5637 -151.34192 0.0 0.0 -1.0628806 0.6851619 0.0 0.0
                                -555.62646 131.76297 0.0 0.0 -496.49567 6.7226925 0.0 0.0 -21.408611
                                5.4543467 0.0 0.0 -0.93181366 -0.23656677 0.0 0.0 -1.1542343 -0.051945705 0.0
                                0.0 -21.003141 -13.756887 0.0 0.0 -24.873556 -3.4775715 0.0 0.0 -1.3999052
                                0.52489865 0.0 0.0 -1.0517707 -0.7880686 0.0 0.0 -23.270258 -9.418031 0.0 0.0
                                -1.1364489 -0.68696874 0.0 0.0 -0.78184557 0.38466665 0.0 0.0 -1.2792739
                                0.29992214 0.0 0.0 -0.85315734 -0.62070733 0.0 0.0 -22.701622 -6.058191 0.0
                                0.0 -1.2287382 0.3516787 0.0 0.0 -22.452536 7.6258154 0.0 0.0 -22.086601
                                11.672183 0.0 0.0 -1.338769 0.044116784 0.0 0.0 -16.481777 -14.801378 0.0 0.0
                                -1.1335386 0.61412454 0.0 0.0 -1.2986759 -0.33036843 0.0 0.0 -1.3368479
                                -0.07109928 0.0 0.0 -21.431007 -5.551428 0.0 0.0 -523.2363 236.82018 0.0 0.0
                                -1.253178 0.39832696 0.0 0.0 -1.0800397 -0.78695196 0.0 0.0 -1.2861345
                                0.27399173 0.0 0.0 -25.031834 -4.8311396 0.0 0.0 -1071.3967 -150.35191 0.0
                                0.0 -1.2275139 -0.25185862 0.0 0.0 -24.518362 -5.832681 0.0 0.0 -1.2093266
                                0.3685018 0.0 0.0 -24.451525 -6.004742 0.0 0.0 -1.2633674 0.42950374 0.0 0.0
                                -1.1402955 -0.67719007 0.0 0.0 -1.31505 0.21026954 0.0 0.0 -556.2788
                                -149.91522 0.0 0.0 -32.20383 2.182007 0.0 0.0 -25.035421 -2.921817 0.0 0.0
                                -1.3219088 -0.21152565 0.0 0.0 -0.9051408 -0.93960327 0.0 0.0 -1.2815425
                                -0.23049727 0.0 0.0 -1.1899438 -0.55677384 0.0 0.0 -1.3166546 0.044303667 0.0
                                0.0 -1.1550639 0.31273094 0.0 0.0 -0.7966594 -1.340359 0.0 0.0 -1.1844151
                                -0.31951386 0.0 0.0 -423.40018 -269.329 0.0 0.0 -1.1219301 -0.6960369 0.0 0.0
                                -16.868624 11.50053 0.0 0.0 -1.1820598 -0.43885082 0.0 0.0 -1.7642393
                                0.14306211 0.0 0.0 -1.059598 0.028349131 0.0 0.0 -25.202251 -1.627269 0.0 0.0
                                -662.3622 -268.56836 0.0 0.0 -1.337503 0.034434218 0.0 0.0 -1.3216171
                                0.04178059 0.0 0.0 -1.2549803 -0.1242804 0.0 0.0 -1.237875 0.4432312 0.0 0.0
                                -21.272854 4.883386 0.0 0.0 -1.138094 -0.06315985 0.0 0.0 -0.94778967
                                -0.8902504 0.0 0.0 -1.9384526 -0.33513147 0.0 0.0 -1.2903441 -0.064859726 0.0
                                0.0 -1.0974345 0.62456197 0.0 0.0 -1.150335 -0.6538413 0.0 0.0 -1.3199906
                                -0.21655977 0.0 0.0 -1.2063757 0.092400685 0.0 0.0 -30.016922 -5.3104854 0.0
                                0.0 -1.3911135 0.13412747 0.0 0.0 -0.9425631 -0.8549756 0.0 0.0 -1.323935
                                0.16535836 0.0 0.0 -21.50182 -12.89746 0.0 0.0 -0.9761669 -0.877785 0.0 0.0
                                -1.2319909 -0.18700019 0.0 0.0 -1.2759012 0.3466464 0.0 0.0 -430.8867
                                -189.3021 0.0 0.0 -467.72372 -53.184425 0.0 0.0 -467.99136 51.70744 0.0 0.0
                                -1.3076818 -0.21854822 0.0 0.0 -1.2031571 0.5616405 0.0 0.0 -489.63687
                                84.05374 0.0 0.0 -17.314686 -13.84192 0.0 0.0 -1.2257373 -0.4701937 0.0 0.0
                                -522.5128 147.7859 0.0 0.0 -22.139757 2.707696 0.0 0.0 -1.1353561 0.013108223
                                0.0 0.0 -1.1945122 0.398177 0.0 0.0 -1.2809649 0.38468063 0.0 0.0 -24.941303
                                -7.5204635 0.0 0.0 -540.1046 -62.959408 0.0 0.0 -1.3184851 0.14759058 0.0 0.0
                                -1.1017021 -0.6092422 0.0 0.0 -25.598785 -1.9600903 0.0 0.0 -29.513361
                                -8.165672 0.0 0.0 -509.01007 193.04793 0.0 0.0 -399.83612 252.07874 0.0 0.0
                                -1.3369179 0.0748629 0.0 0.0 -14.393331 -17.73945 0.0 0.0 -472.3052
                                -232.79103 0.0 0.0 -1.2882544 -0.3346491 0.0 0.0 -0.8019327 -1.0070558 0.0
                                0.0 -587.147 223.3932 0.0 0.0 -20.808971 -14.284924 0.0 0.0 -520.0578
                                -269.0852 0.0 0.0 -1.2484756 0.29833135 0.0 0.0 -16.1995 -15.4058075 0.0 0.0
                                -28.30644 -8.78479 0.0 0.0 -1.156479 -0.57864493 0.0 0.0 -461.87238 106.47665
                                0.0 0.0 -25.545958 2.6828828 0.0 0.0 -16.707623 -13.894765 0.0 0.0 -1.1555549
                                0.6234904 0.0 0.0 -34.270573 12.310149 0.0 0.0 -21.559875 -23.828009 0.0 0.0
                                -19.505798 16.211605 0.0 0.0 -1.2724161 -0.2969817 0.0 0.0 -469.75653
                                -197.77847 0.0 0.0 -1.1474282 0.31115967 0.0 0.0 -497.223 113.08216 0.0 0.0
                                -30.659048 -8.692672 0.0 0.0 -25.011055 -6.199961 0.0 0.0 -502.42084
                                -89.09633 0.0 0.0 -31.540455 -15.535283 0.0 0.0 -18.145744 -0.45972353 0.0
                                0.0 -1.1983285 0.4768617 0.0 0.0 -1.3106501 -0.2827471 0.0 0.0 -36.715645
                                -11.956173 0.0 0.0 -1.247635 0.408737 0.0 0.0 -1.1847967 0.5143651 0.0 0.0
                                -1.3066667 0.29604512 0.0 0.0 -17.568201 16.389313 0.0 0.0 -727.3767
                                54.926323 0.0 0.0 -31.07882 7.240623 0.0 0.0 -29.983122 6.953279 0.0 0.0
                                -22.221191 3.0151398 0.0 0.0 -1.2928132 0.1779432 0.0 0.0 -1.2966783
                                -0.3414674 0.0 0.0 -1.2364761 -0.45667613 0.0 0.0 -22.29578 -2.0722685 0.0
                                0.0 -1.2811859 0.0667305 0.0 0.0 -727.3792 74.22801 0.0 0.0 -26.512762
                                -7.9167404 0.0 0.0 -1.2810166 0.2065635 0.0 0.0 -1.2233394 -0.49180278 0.0
                                0.0 -1.3085431 -0.040795635 0.0 0.0 -22.24578 26.034384 0.0 0.0 -19.69512
                                -22.35052 0.0 0.0 -1.2901894 -0.2901978 0.0 0.0 -518.4909 -186.99922 0.0 0.0
                                -26.812132 7.1860237 0.0 0.0 -22.301954 -2.356026 0.0 0.0 -20.331345
                                9.5533085 0.0 0.0 -454.62524 -149.16975 0.0 0.0 -1.2565148 0.010840252 0.0
                                0.0 -1.0433201 -0.28555337 0.0 0.0 -21.46336 6.6149764 0.0 0.0 -1.1978295
                                -0.10508148 0.0 0.0 -39.94831 -1.3280739 0.0 0.0 -22.940243 7.498505 0.0 0.0
                                -1.0550516 0.8180903 0.0 0.0 -1.1468226 0.6632791 0.0 0.0 -28.678806
                                1.8674148 0.0 0.0 -30.744444 -15.4702015 0.0 0.0 -20.235256 -9.7226 0.0 0.0
                                -0.8330388 -0.99668366 0.0 0.0 -1.1766107 -0.40986118 0.0 0.0 -23.733025
                                -2.7679646 0.0 0.0 -1.3309695 -0.12091043 0.0 0.0 -25.408428 -1.7289952 0.0
                                0.0 -0.9232715 -0.8421913 0.0 0.0 -1.1636058 -0.4880111 0.0 0.0 -24.76603
                                5.8919945 0.0 0.0 -1.3264345 -0.19596502 0.0 0.0 -489.96252 410.7753 0.0 0.0
                                -683.93243 63.087055 0.0 0.0 -1.341142 -0.0100804055 0.0 0.0 -1.2594516
                                0.37545142 0.0 0.0 -1.3254083 0.16544911 0.0 0.0 -1.3078324 0.27568233 0.0
                                0.0 -517.2892 201.37477 0.0 0.0 -18.537909 15.307556 0.0 0.0 -1.2549902
                                0.35766885 0.0 0.0 -1.1495711 0.25672114 0.0 0.0 -20.164759 -15.363589 0.0
                                0.0 -1.2292422 -0.5045053 0.0 0.0 -511.86774 76.38546 0.0 0.0 -1.1654383
                                0.52398545 0.0 0.0 -25.324738 3.165238 0.0 0.0 -24.628912 8.330406 0.0 0.0
                                -614.08795 -313.38504 0.0 0.0 -1.281064 0.27488664 0.0 0.0 -24.663881
                                -6.7759914 0.0 0.0 -1.3125676 0.26303262 0.0 0.0 -585.9893 263.47632 0.0 0.0
                                -614.606 414.77478 0.0 0.0 -435.74255 208.08145 0.0 0.0 -1.3088928
                                -0.28226846 0.0 0.0 -27.697521 3.757321 0.0 0.0 -23.626469 -5.4141536 0.0 0.0
                                -1.3250587 0.11008842 0.0 0.0 -483.06653 17.672155 0.0 0.0 -24.471357
                                7.4723296 0.0 0.0 -1.481218 -0.19059165 0.0 0.0 -39.26608 7.254909 0.0 0.0
                                -1.1702447 0.5702556 0.0 0.0 -1.3330017 0.13743128 0.0 0.0 -26.595726
                                11.56752 0.0 0.0 -1.2611126 -0.06506013 0.0 0.0 -483.44513 -27.235142 0.0 0.0
                                -20.635 -9.233297 0.0 0.0 -55.82395 -4.939491 0.0 0.0 -407.72937 -261.75635
                                0.0 0.0 -1.3091521 -0.18444026 0.0 0.0 -1.2408855 -0.02143918 0.0 0.0
                                -23.5857 -10.217456 0.0 0.0 -21.0004 -8.39471 0.0 0.0 -1.3067845 -0.17378582
                                0.0 0.0 -1.4789362 -0.27759454 0.0 0.0 -29.590265 -5.3965917 0.0 0.0
                                -397.88303 -277.93347 0.0 0.0 -1.2644461 0.2018451 0.0 0.0 -1.254348
                                0.16864058 0.0 0.0 -0.58933175 -1.197584 0.0 0.0 -1.3232331 -0.17337401 0.0
                                0.0 -1.0692885 -0.7389074 0.0 0.0 -1.2986265 -0.077882245 0.0 0.0 -1.281046
                                -0.05284029 0.0 0.0 -0.9775509 -0.773724 0.0 0.0 -0.6023893 -1.1839858 0.0
                                0.0 -21.633547 -17.678144 0.0 0.0 -24.198397 9.158232 0.0 0.0 -1.2659655
                                -0.4241269 0.0 0.0 -1.3392246 -0.04891611 0.0 0.0 -1.3026702 0.038069095 0.0
                                0.0 -562.06415 -6.302016 0.0 0.0 -464.63876 145.84633 0.0 0.0 -1.2313684
                                0.38029024 0.0 0.0 -25.911427 -3.56705 0.0 0.0 -1.2352822 0.17969792 0.0 0.0
                                -26.27872 9.92472 0.0 0.0 -23.246843 7.0754957 0.0 0.0 -1.3105942 -0.03430147
                                0.0 0.0 -22.74159 -12.91206 0.0 0.0 -439.18854 212.31581 0.0 0.0 -1.0940408
                                -0.6526645 0.0 0.0 -1.0516943 0.24249335 0.0 0.0 -22.69731 0.20203298 0.0 0.0
                                -1.3058081 -0.22379455 0.0 0.0 -1.3000631 -0.14191292 0.0 0.0 -23.734213
                                10.110796 0.0 0.0 -25.39635 -4.562841 0.0 0.0 -586.5613 153.71942 0.0 0.0
                                -1.388488 0.31076705 0.0 0.0 -41.768463 -27.336966 0.0 0.0 -1.1778531
                                -0.14833301 0.0 0.0 -25.20083 -5.596097 0.0 0.0 -26.207584 0.6738572 0.0 0.0
                                -1.1055434 -0.5942063 0.0 0.0 -603.8295 65.43639 0.0 0.0 -56.50383 5.0145073
                                0.0 0.0 -1.2563915 0.3624674 0.0 0.0 -1.2233982 -0.42283762 0.0 0.0
                                -1.1174681 0.64609945 0.0 0.0 -1.0409129 -0.19281054 0.0 0.0 -29.947172
                                -4.3358645 0.0 0.0 -26.27359 -10.020186 0.0 0.0 -1.1875427 -0.5191256 0.0 0.0
                                -692.0417 -123.77102 0.0 0.0 -24.944649 -1.8288745 0.0 0.0 -480.34937
                                -99.282845 0.0 0.0 -490.41064 -13.840881 0.0 0.0 -1.3360301 0.63551116 0.0
                                0.0 -25.724262 1.7840934 0.0 0.0 -27.577314 6.0037017 0.0 0.0 -13.036676
                                -8.240553 0.0 0.0 -489.80038 -363.22833 0.0 0.0 -1.3557289 -0.048803084 0.0
                                0.0 -1.4607091 -0.3270508 0.0 0.0 -25.751066 2.1722271 0.0 0.0 -1.0866963
                                0.17264415 0.0 0.0 -483.58267 88.65019 0.0 0.0 -1.3204811 0.025215462 0.0 0.0
                                -1.3166064 0.037505616 0.0 0.0 -24.753378 -7.575 0.0 0.0 -1.2545145
                                -0.35505012 0.0 0.0 -1.1416075 0.64156526 0.0 0.0 -22.421753 1.4091498 0.0
                                0.0 -24.905396 7.093149 0.0 0.0 -1.0122527 0.8597421 0.0 0.0 -1.3278322
                                0.18284118 0.0 0.0 -1.1792072 -0.5780079 0.0 0.0 -24.483604 -0.97490853 0.0
                                0.0 -1.247662 -0.39607793 0.0 0.0 -1.3213272 -0.19394945 0.0 0.0 -25.946375
                                -4.368244 0.0 0.0 -23.895699 5.4610176 0.0 0.0 -38.940563 11.294699 0.0 0.0
                                -24.844807 7.3228354 0.0 0.0 -1.3204341 -0.14241616 0.0 0.0 -25.955948
                                8.77244 0.0 0.0 -25.7961 1.7980592 0.0 0.0 -1.4254205 -0.25697517 0.0 0.0
                                -22.808344 0.89529425 0.0 0.0 -1.3124759 0.26852322 0.0 0.0 -658.8975
                                -38.15193 0.0 0.0 -1.2735825 0.2682953 0.0 0.0 -22.199764 -5.3695374 0.0 0.0
                                -1.3045636 0.2957327 0.0 0.0 -491.6228 -202.44643 0.0 0.0 -1.0140318
                                0.5545817 0.0 0.0 -1.2996354 0.17681357 0.0 0.0 -0.64004767 0.35501185 0.0
                                0.0 -1.155922 -0.6767217 0.0 0.0 -1.2265538 -0.39752212 0.0 0.0 -24.079784
                                0.7416002 0.0 0.0 -23.155802 12.687928 0.0 0.0 -1.3118756 0.19078094 0.0 0.0
                                -1.3336445 0.011974469 0.0 0.0 -1.2814072 -0.11485953 0.0 0.0 -423.7217
                                257.2307 0.0 0.0 -25.338888 -1.4988633 0.0 0.0 -1.3197669 -0.13549218 0.0 0.0
                                -1.0869626 -0.6894935 0.0 0.0 -1.2122327 0.14038193 0.0 0.0 -23.073677
                                8.481836 0.0 0.0 -25.119844 6.327244 0.0 0.0 -26.191677 10.870997 0.0 0.0
                                -1.2130824 0.5385137 0.0 0.0 -1.2699527 0.10361257 0.0 0.0 -1.4906057
                                -0.06215401 0.0 0.0 -486.3593 221.02122 0.0 0.0 -1.2901677 -0.2253925 0.0 0.0
                                -1.1413599 0.15398489 0.0 0.0 -59.345016 -28.731478 0.0 0.0 -528.5269
                                80.94161 0.0 0.0 -664.3127 -28.914839 0.0 0.0 -3.0729697 0.17338735 0.0 0.0
                                -452.55173 -206.79904 0.0 0.0 -28.0581 -4.726448 0.0 0.0 -21.995493
                                -13.949692 0.0 0.0 -1.265456 -0.18598418 0.0 0.0 -1.8381082 0.68480384 0.0
                                0.0 -56.524017 -28.118929 0.0 0.0 -1.6665144 -0.16173863 0.0 0.0 -1.299602
                                -0.21741636 0.0 0.0 -1.2094522 -0.12221926 0.0 0.0 -0.60518575 -0.077202834
                                0.0 0.0 -25.216309 2.116943 0.0 0.0 -1.2452056 -0.027434535 0.0 0.0 -573.689
                                60.65978 0.0 0.0 -1.2981783 0.073192656 0.0 0.0 -1.1272889 -0.64972955 0.0
                                0.0 -1.2832111 0.3341849 0.0 0.0 -1.2257982 0.45327675 0.0 0.0 -1.4097551
                                -0.68324363 0.0 0.0 -38.399487 2.899171 0.0 0.0 -1.2951494 0.3293432 0.0 0.0
                                -1.3257385 -0.2016526 0.0 0.0 -1.1059395 0.018992573 0.0 0.0 -1.2556057
                                0.2592956 0.0 0.0 -1.3171468 -0.24141009 0.0 0.0 -24.680487 8.489547 0.0 0.0
                                -499.34378 28.762259 0.0 0.0 -25.066633 6.4284368 0.0 0.0 -1.3071921
                                0.2700542 0.0 0.0 -24.876434 9.247315 0.0 0.0 -1.1485904 0.09662146 0.0 0.0
                                -1.0657841 0.11590096 0.0 0.0 -1.1818705 0.0617645 0.0 0.0 -23.070787
                                -8.852219 0.0 0.0 -1.4156228 -0.40357125 0.0 0.0 -1.2878578 0.3168542 0.0 0.0
                                -25.524696 1.4778109 0.0 0.0 -19.445166 -12.285607 0.0 0.0 -527.32947
                                113.207954 0.0 0.0 -481.4257 -243.40857 0.0 0.0 -35.3911 0.8256243 0.0 0.0
                                -1.5973532 -0.53304404 0.0 0.0 -1.1816422 0.59978586 0.0 0.0 -471.34875
                                -136.26611 0.0 0.0 -1.1910456 0.06249474 0.0 0.0 -58.807808 -4.2621737 0.0
                                0.0 -26.091412 -0.46747947 0.0 0.0 -26.075188 -2.1452198 0.0 0.0 -0.79588616
                                -1.0773046 0.0 0.0 -32.992844 -2.6817997 0.0 0.0 -535.9364 71.95697 0.0 0.0
                                -20.745214 -15.400957 0.0 0.0 -1.2746772 -0.4128123 0.0 0.0 -1.3049706
                                -0.20970964 0.0 0.0 -0.9248094 0.5113354 0.0 0.0 -1.3274813 -0.19401523 0.0
                                0.0 -22.776775 -2.635209 0.0 0.0 -1.2666967 -0.4249421 0.0 0.0 -1.2316524
                                0.4541439 0.0 0.0 -1.2926387 -0.21588516 0.0 0.0 -18.800802 13.343433 0.0 0.0
                                -41.87752 14.614112 0.0 0.0 -1.3252622 0.18022253 0.0 0.0 -24.468058
                                4.0164733 0.0 0.0 -1.2154177 0.3237911 0.0 0.0 -22.96811 -12.534574 0.0 0.0
                                -1.2979877 0.27043003 0.0 0.0 -1.0482507 0.7280457 0.0 0.0 -1.2325212
                                0.5144359 0.0 0.0 -26.51183 -6.282852 0.0 0.0 -17.308289 -20.055376 0.0 0.0
                                -1.2919174 0.2262872 0.0 0.0 -26.465282 3.3122969 0.0 0.0 -532.29114
                                109.49304 0.0 0.0 -1.2838349 -0.36892763 0.0 0.0 -32.70198 -5.888799 0.0 0.0
                                -23.795406 10.978974 0.0 0.0 -492.22296 115.15522 0.0 0.0 -1.1197131
                                -0.3818208 0.0 0.0 -1.2509426 -0.20590179 0.0 0.0 -1.2774704 -0.3804021 0.0
                                0.0 -274.279 234.32343 0.0 0.0 -446.93817 -444.55188 0.0 0.0 -0.9857534
                                0.7704704 0.0 0.0 -3.845661 -0.68717074 0.0 0.0 -19.877262 -8.345825 0.0 0.0
                                -1.3322252 -0.14069939 0.0 0.0 -0.7946704 -0.92690873 0.0 0.0 -1.3121077
                                0.047130723 0.0 0.0 -18.377325 -13.97769 0.0 0.0 -1.2421259 0.38216528 0.0
                                0.0 -1.3057854 -0.24219522 0.0 0.0 -1.1997395 0.5795871 0.0 0.0 -26.898586
                                -10.188146 0.0 0.0 -1.0340168 -0.20354146 0.0 0.0 -26.200188 -0.50560105 0.0
                                0.0 -1.2857629 0.33898914 0.0 0.0 -1.2532989 -0.27946818 0.0 0.0 -21.881672
                                7.055952 0.0 0.0 -16.481123 -16.245956 0.0 0.0 -1.161062 0.6359391 0.0 0.0
                                -1.3391558 0.04649232 0.0 0.0 -509.0817 -286.43542 0.0 0.0 -1.2463676
                                -0.20534827 0.0 0.0 -22.357332 -6.041196 0.0 0.0 -1.2820697 0.39414895 0.0
                                0.0 -1.2992454 -0.0766986 0.0 0.0 -24.349468 6.3656206 0.0 0.0 -1.2613705
                                -0.3833031 0.0 0.0 -1.2288169 0.23118652 0.0 0.0 -1.328413 0.020355036 0.0
                                0.0 -1.3028477 -0.31262016 0.0 0.0 -507.84143 37.124928 0.0 0.0 -94.85929
                                32.49245 0.0 0.0 -0.68193734 -0.41012433 0.0 0.0 -64.519516 -3.2506678 0.0
                                0.0 -1.314422 -0.24920434 0.0 0.0 -1.1706378 0.64526016 0.0 0.0 -27.119352
                                -9.807527 0.0 0.0 -1.3090017 0.16935776 0.0 0.0 -678.27625 91.66108 0.0 0.0
                                -1.3037066 0.15239818 0.0 0.0 -29.00385 6.6375465 0.0 0.0 -1.2531753
                                -0.27483657 0.0 0.0 -1.1376727 0.5751449 0.0 0.0 -1.2435265 0.22175251 0.0
                                0.0 -1.1172916 0.59481096 0.0 0.0 -1.1844116 -0.5366467 0.0 0.0 -23.997444
                                8.472909 0.0 0.0 -1.2912844 0.20792624 0.0 0.0 -26.22993 -5.6381097 0.0 0.0
                                -1.28801 -0.27671126 0.0 0.0 -1.3038518 -0.0878616 0.0 0.0 -1.3242284
                                0.18035102 0.0 0.0 -1.2395344 -0.25949797 0.0 0.0 -24.56602 9.646289 0.0 0.0
                                -1.2096663 -0.2415636 0.0 0.0 -1.2180637 -0.55125684 0.0 0.0 -21.163612
                                -11.252176 0.0 0.0 -723.08435 334.455 0.0 0.0 -54.675495 12.346433 0.0 0.0
                                -22.28137 -6.5494967 0.0 0.0 -1.2609826 0.10357244 0.0 0.0 -1.3171554
                                0.15502411 0.0 0.0 -22.575722 -5.4329247 0.0 0.0 -1.2905246 -0.24002169 0.0
                                0.0 -1.2279309 -0.44402444 0.0 0.0 -42.607212 14.565242 0.0 0.0 -543.8034
                                96.268005 0.0 0.0 -1.1871967 -0.15536174 0.0 0.0 -28.441927 -5.496723 0.0 0.0
                                -1.2419512 -0.27718797 0.0 0.0 -22.652143 10.645749 0.0 0.0 -1.2051839
                                -0.54748887 0.0 0.0 -1.2063679 0.673441 0.0 0.0 -1.0354855 -0.8124993 0.0 0.0
                                -1.0030286 0.15520722 0.0 0.0 -37.726646 -18.68363 0.0 0.0 -0.77145493
                                0.2819473 0.0 0.0 -1.2687851 -0.049900655 0.0 0.0 -1.1594679 0.62457037 0.0
                                0.0 -0.89811605 -0.99552816 0.0 0.0 -25.911263 -5.3706555 0.0 0.0 -1.4917986
                                -0.18919365 0.0 0.0 -22.717728 -5.190971 0.0 0.0 -1.1642946 -0.61897665 0.0
                                0.0 -716.0254 205.76704 0.0 0.0 -55.263836 11.062786 0.0 0.0 -0.7580591
                                -0.99973816 0.0 0.0 -1.3193941 6.2953675e-4 0.0 0.0 -1.2574893 0.39190564 0.0
                                0.0 -1.3146296 -0.2666722 0.0 0.0 -23.283243 -0.22457707 0.0 0.0 -1.1554476
                                -0.30763707 0.0 0.0 -26.475368 0.5847262 0.0 0.0 -1.23629 -0.50928795 0.0 0.0
                                -26.678532 -18.145939 0.0 0.0 -1.2239106 -0.29052854 0.0 0.0 -26.954426
                                -2.0772939 0.0 0.0 -24.125586 -6.758797 0.0 0.0 -1.3049551 -0.24721539 0.0
                                0.0 -1.3105035 -0.048780654 0.0 0.0 -1.1622006 0.55066437 0.0 0.0 -550.7796
                                78.89863 0.0 0.0 -25.888744 7.7711806 0.0 0.0 -1.4589462 -0.89095706 0.0 0.0
                                -1.259762 0.42257625 0.0 0.0 -1.2816384 -0.38778836 0.0 0.0 -51.09371
                                24.33579 0.0 0.0 -599.89825 -6.983372 0.0 0.0 -1.3258307 0.18387084 0.0 0.0
                                -1.2684864 0.3175268 0.0 0.0 -555.38776 -48.13955 0.0 0.0 -1.2242124
                                -0.067457326 0.0 0.0 -1.0568056 0.8116399 0.0 0.0 -1.2936952 0.33290288 0.0
                                0.0 -1.2322145 -0.5027015 0.0 0.0 -1.3360935 0.025502719 0.0 0.0 -1.3593398
                                0.0312595 0.0 0.0 -1.5835984 0.3724937 0.0 0.0 -25.799622 -6.409841 0.0 0.0
                                -25.581161 -7.184213 0.0 0.0 -1.0345694 -0.73706377 0.0 0.0 -1.3270117
                                -0.65804976 0.0 0.0 -22.206036 -14.033147 0.0 0.0 -1.3343717 -0.080357976 0.0
                                0.0 -21.548502 -8.795478 0.0 0.0 -559.2358 -4.343699 0.0 0.0 -1.2218678
                                -0.40822884 0.0 0.0 -635.42474 132.10262 0.0 0.0 -1.2663393 -0.46701086 0.0
                                0.0 -0.801682 0.9795708 0.0 0.0 -1.340068 -0.034151968 0.0 0.0 -558.6172
                                -38.85127 0.0 0.0 -21.799425 16.087255 0.0 0.0 -1.1442622 -0.6999111 0.0 0.0
                                -24.915056 3.9131598 0.0 0.0 -1.217035 -0.5324115 0.0 0.0 -0.9681138
                                0.7833059 0.0 0.0 -24.825539 -4.530148 0.0 0.0 -27.165756 -0.34063092 0.0 0.0
                                -30.953247 -13.856996 0.0 0.0 -1.3041198 -0.11368964 0.0 0.0 -28.836569
                                4.375487 0.0 0.0 -1.298615 0.113278665 0.0 0.0 -24.1243 -0.5687343 0.0 0.0
                                -1.3499448 0.55913866 0.0 0.0 -1.2977338 -0.33968067 0.0 0.0 -1.2731373
                                0.15391348 0.0 0.0 -1.2017343 -0.5154783 0.0 0.0 -29.263744 -0.77770233 0.0
                                0.0 -0.72156894 -1.0503206 0.0 0.0 -519.78687 310.85645 0.0 0.0 -1.2862433
                                0.372994 0.0 0.0 -465.5955 -315.58228 0.0 0.0 -499.18246 153.48183 0.0 0.0
                                -29.625923 -10.887073 0.0 0.0 -26.339443 -3.719438 0.0 0.0 -1.3797208
                                0.27141115 0.0 0.0 -1.2003527 -0.026653685 0.0 0.0 -22.15796 9.167454 0.0 0.0
                                -1.6425996 -0.65909535 0.0 0.0 -683.89435 -168.96141 0.0 0.0 -14.311577
                                -12.017641 0.0 0.0 -1.2615948 -0.4476653 0.0 0.0 -22.953156 -10.624109 0.0
                                0.0 -21.254194 3.4092824 0.0 0.0 -0.863511 -1.0060338 0.0 0.0 -29.81233
                                21.345074 0.0 0.0 -0.98751724 3.7741847e-4 0.0 0.0 -626.3549 -78.77912 0.0
                                0.0 -1.1355046 0.20290336 0.0 0.0 -1.2979012 0.11272368 0.0 0.0 -31.035103
                                -9.80094 0.0 0.0 -1.2339723 0.4222938 0.0 0.0 -1.2872511 -0.3352135 0.0 0.0
                                -1.2158397 -0.4025352 0.0 0.0 -1.1255252 -0.06463586 0.0 0.0 -1.1298467
                                0.6736803 0.0 0.0 -39.682274 -15.486225 0.0 0.0 -1.5498259 -0.07943902 0.0
                                0.0 -1.1175674 -0.5658994 0.0 0.0 -0.8057784 -0.7972568 0.0 0.0 -1.306592
                                0.24994385 0.0 0.0 -1.3232371 -0.2187807 0.0 0.0 -1.2448746 -0.29275188 0.0
                                0.0 -40.161877 -35.072556 0.0 0.0 -1.5705854 0.27993092 0.0 0.0 -1.3041304
                                0.14833619 0.0 0.0 -1.2413365 0.18851899 0.0 0.0 -1.1129318 -0.06367807 0.0
                                0.0 -25.486834 8.010058 0.0 0.0 -561.74347 77.118286 0.0 0.0 -1.7475098
                                -0.7637877 0.0 0.0 -27.254688 2.0741549 0.0 0.0 -41.837223 -7.3894467 0.0 0.0
                                -438.76135 -291.25394 0.0 0.0 -643.11237 -144.37555 0.0 0.0 -22.966263
                                -10.83097 0.0 0.0 -1.3078828 0.2856871 0.0 0.0 -40.992672 18.211946 0.0 0.0
                                -29.339811 -2.8119183 0.0 0.0 -26.019926 -8.453305 0.0 0.0 -1.2943187
                                0.11648312 0.0 0.0 -1.2757845 0.3628814 0.0 0.0 -1.3288198 -0.16868395 0.0
                                0.0 -1.3268399 -0.08528422 0.0 0.0 -760.9121 -98.26889 0.0 0.0 -1.266731
                                -0.41016537 0.0 0.0 -503.0318 -160.5311 0.0 0.0 -1.095206 -0.25419402 0.0 0.0
                                -1.2603766 -0.14606763 0.0 0.0 -23.032454 0.9123485 0.0 0.0 -1.2573917
                                -0.46777007 0.0 0.0 -514.4815 121.19094 0.0 0.0 -20.161367 15.3729105 0.0 0.0
                                -1.3227297 0.08290886 0.0 0.0 -488.44223 -202.8382 0.0 0.0 -23.621346
                                0.25611573 0.0 0.0 -1.1731142 -0.6013211 0.0 0.0 -22.258247 7.459004 0.0 0.0
                                -1.4764093 -0.2896351 0.0 0.0 -0.96345663 -0.018873418 0.0 0.0 -1.1902205
                                0.35269526 0.0 0.0 -0.87043744 -0.21434024 0.0 0.0 -18.991026 -16.965378 0.0
                                0.0 -1.2348467 0.42244494 0.0 0.0 -1.1133552 -0.02976378 0.0 0.0 -1.3041816
                                -0.30106926 0.0 0.0 -455.97015 -270.51157 0.0 0.0 -1.3259342 0.19208276 0.0
                                0.0 -428.76242 -312.2118 0.0 0.0 -26.708452 -2.488186 0.0 0.0 -28.16174
                                8.955822 0.0 0.0 -0.7775393 -0.92587465 0.0 0.0 -27.751003 4.2293878 0.0 0.0
                                -553.35986 -146.00418 0.0 0.0 -22.973766 -10.644688 0.0 0.0 -1.2989821
                                -0.2574198 0.0 0.0 -17.655653 -15.562142 0.0 0.0 -26.676022 0.18409199 0.0
                                0.0 -26.812922 1.758364 0.0 0.0 -1.1535704 0.6020219 0.0 0.0 -1.0256047
                                -0.46561506 0.0 0.0 -26.890396 -1.1609571 0.0 0.0 -23.23733 -4.59233 0.0 0.0
                                -529.03253 -56.159184 0.0 0.0 -22.939146 -5.3694677 0.0 0.0 -1.3002547
                                -0.051846802 0.0 0.0 -27.462711 1.5134816 0.0 0.0 -26.205145 5.939858 0.0 0.0
                                -1.2580819 0.41644803 0.0 0.0 -1.3371847 -0.054999366 0.0 0.0 -574.48224
                                230.98424 0.0 0.0 -29.081896 4.065713 0.0 0.0 -1.1978106 -0.53860956 0.0 0.0
                                -23.944366 -10.296777 0.0 0.0 -1326.177 -499.53317 0.0 0.0 -1.3286293
                                -0.1612007 0.0 0.0 -1.3108212 -0.21075536 0.0 0.0 -26.696154 -1.0882396 0.0
                                0.0 -25.78946 7.5574317 0.0 0.0 -27.1848 4.422452 0.0 0.0 -1.3019106
                                -0.3080823 0.0 0.0 -22.931728 -6.114542 0.0 0.0 -1.3254638 0.06421108 0.0 0.0
                                -25.262697 9.476344 0.0 0.0 -26.921719 1.8801185 0.0 0.0 -1.2097967 0.4725254
                                0.0 0.0 -1.1169764 0.66244304 0.0 0.0 -1.2962132 0.32641956 0.0 0.0
                                -1.0935876 -0.5749208 0.0 0.0 -0.9589754 -0.90045094 0.0 0.0 -1.3363472
                                -0.09283396 0.0 0.0 -534.8792 -12.539582 0.0 0.0 -534.1617 32.24855 0.0 0.0
                                -20.356714 -12.1961155 0.0 0.0 -27.173283 -4.810086 0.0 0.0 -34.326168
                                4.100992 0.0 0.0 -0.624544 -1.1109655 0.0 0.0 -24.683762 -6.8364997 0.0 0.0
                                -1.2798129 0.26483247 0.0 0.0 -25.590755 -1.338388 0.0 0.0 -21.916107
                                16.71846 0.0 0.0 -587.0709 -209.60408 0.0 0.0 -1.2739515 -0.31569102 0.0 0.0
                                -471.28323 255.99835 0.0 0.0 -25.152855 -8.833602 0.0 0.0 -22.682405
                                13.445608 0.0 0.0 -1.241239 0.22105242 0.0 0.0 -31.946022 -14.500781 0.0 0.0
                                -559.58453 -148.4505 0.0 0.0 -25.084293 5.369095 0.0 0.0 -1.3397734
                                -0.06818315 0.0 0.0 -34.40123 -2.9689164 0.0 0.0 -23.30746 10.288884 0.0 0.0
                                -1.3246768 -0.07809877 0.0 0.0 -1.1236929 -0.38817018 0.0 0.0 -23.427269
                                -4.221522 0.0 0.0 -1.2165833 -0.3710855 0.0 0.0 -1.4727833 0.32852438 0.0 0.0
                                -535.85846 47.3644 0.0 0.0 -1.263812 0.38247666 0.0 0.0 -433.03244 -319.53677
                                0.0 0.0 -1.3207006 -0.009396198 0.0 0.0 -26.5658 -5.163473 0.0 0.0 -1.6463038
                                0.83612937 0.0 0.0 -1.324496 0.20315765 0.0 0.0 -21.127743 -14.667319 0.0 0.0
                                -1.3132976 -0.19751891 0.0 0.0 -27.589968 2.5708666 0.0 0.0 -458.06998
                                -284.1251 0.0 0.0 -1.2549859 -0.16319987 0.0 0.0 -28.754593 -1.652416 0.0 0.0
                                -24.5155 -11.062802 0.0 0.0 -1.2960911 -0.21852824 0.0 0.0 -1.1798965
                                0.5408682 0.0 0.0 -26.133762 -3.694759 0.0 0.0 -25.610924 -2.4083624 0.0 0.0
                                -489.68347 227.38 0.0 0.0 -1.312122 0.25139162 0.0 0.0 -1.2468903 -0.4148074
                                0.0 0.0 -30.53785 10.316092 0.0 0.0 -539.83 23.330305 0.0 0.0 -0.6507667
                                -0.3693653 0.0 0.0 -1.2215638 -0.5104467 0.0 0.0 -1.4734088 0.3215373 0.0 0.0
                                -1.3009288 0.2991833 0.0 0.0 -1.2941595 -0.2991733 0.0 0.0 -27.118912
                                -1.0763267 0.0 0.0 -32.952854 -4.1714764 0.0 0.0 -1.3137884 -0.22056827 0.0
                                0.0 -1.4116789 -0.39099935 0.0 0.0 -1.3320026 0.15269135 0.0 0.0 -1.2680964
                                0.34361598 0.0 0.0 -26.609135 -3.6742165 0.0 0.0 -1.1598692 -0.65750647 0.0
                                0.0 -31.98289 4.557268 0.0 0.0 -24.946167 -10.317103 0.0 0.0 -25.464071
                                -3.526489 0.0 0.0 -25.74729 -4.3798976 0.0 0.0 -26.86891 -7.1573567 0.0 0.0
                                -1.2599854 0.32423213 0.0 0.0 -26.886093 -3.7060616 0.0 0.0 -1.3847069
                                -0.14825918 0.0 0.0 -28.36161 6.8593397 0.0 0.0 -25.040565 -6.220491 0.0 0.0
                                -1.0092775 -0.81833506 0.0 0.0 -1.5062271 0.10687328 0.0 0.0 -1.1385095
                                0.53731173 0.0 0.0 -1.3199773 0.010421257 0.0 0.0 -1.6064367 0.05718839 0.0
                                0.0 -1.2305014 -0.46915567 0.0 0.0 -1.310816 0.20392264 0.0 0.0 -499.35812
                                215.07457 0.0 0.0 -542.5332 -179.1097 0.0 0.0 -1.3308836 -0.11347355 0.0 0.0
                                -1.2737546 0.32887748 0.0 0.0 -1.148657 -0.6803078 0.0 0.0 -0.9055039
                                -0.9858548 0.0 0.0 -1.2955306 0.5841903 0.0 0.0 -24.852499 6.6911306 0.0 0.0
                                -27.209988 0.33028474 0.0 0.0 -1.2300099 0.095618114 0.0 0.0 -1.3391824
                                0.06913046 0.0 0.0 -0.8652782 -0.31742844 0.0 0.0 -1.230862 0.5267653 0.0 0.0
                                -1.0565445 -0.6506668 0.0 0.0 -33.31059 0.92610675 0.0 0.0 -1.3608775
                                -0.55094105 0.0 0.0 -537.7498 -91.326 0.0 0.0 -27.801527 -2.0349813 0.0 0.0
                                -25.197807 -20.426754 0.0 0.0 -1.1577483 0.48489448 0.0 0.0 -22.785803
                                -11.752387 0.0 0.0 -458.2948 -296.77725 0.0 0.0 -1.1975912 -0.4219731 0.0 0.0
                                -1.2237598 0.48980922 0.0 0.0 -26.602686 5.414448 0.0 0.0 -42.44823 11.60799
                                0.0 0.0 -26.848347 4.855465 0.0 0.0 -27.003878 -7.1552415 0.0 0.0 -1.2337502
                                -0.61542904 0.0 0.0 -1.0522428 -0.18366832 0.0 0.0 -26.47576 6.6779327 0.0
                                0.0 -741.965 -1.8909994 0.0 0.0 -1.2924966 0.35559314 0.0 0.0 -1.2925788
                                -0.075634375 0.0 0.0 -21.611387 -10.469261 0.0 0.0 -1.2929413 -0.22967443 0.0
                                0.0 -1.3145068 0.009685327 0.0 0.0 -558.04114 194.98271 0.0 0.0 -1.2188191
                                0.4506398 0.0 0.0 -1.3413554 -0.012823652 0.0 0.0 -1.2552963 0.4491834 0.0
                                0.0 -1.2689302 -0.19683158 0.0 0.0 -1.1235071 0.04710364 0.0 0.0 -1.5736457
                                -0.2169011 0.0 0.0 -26.24634 -7.0200443 0.0 0.0 -23.952833 12.087228 0.0 0.0
                                -1.3167914 -0.08648543 0.0 0.0 -27.88975 2.4886112 0.0 0.0 -1.3391802
                                -0.05856924 0.0 0.0 -1.2390969 -0.5111558 0.0 0.0 -1.1889213 -0.4923124 0.0
                                0.0 -21.037916 -17.250265 0.0 0.0 -14.784579 18.784399 0.0 0.0 -18.921146
                                15.419846 0.0 0.0 -1.2735025 -0.35664472 0.0 0.0 -27.106451 3.7091734 0.0 0.0
                                -28.457314 -11.383524 0.0 0.0 -1.0414939 0.658617 0.0 0.0 -1.2393361
                                0.3600785 0.0 0.0 -1.2746719 -0.3693043 0.0 0.0 -33.440247 11.069816 0.0 0.0
                                -1.3063953 0.28004384 0.0 0.0 -40.49078 -17.9138 0.0 0.0 -1.5419624
                                0.45161286 0.0 0.0 -1.2740469 -0.06359518 0.0 0.0 -0.69517577 0.17530282 0.0
                                0.0 -1.2820568 -0.37396696 0.0 0.0 -1.1283664 -0.2424719 0.0 0.0 -0.8855869
                                0.10616398 0.0 0.0 -1.2114078 0.45080692 0.0 0.0 -1.243207 0.0765886 0.0 0.0
                                -1.3267248 -0.037249595 0.0 0.0 -35.298428 14.280339 0.0 0.0 -1.3244181
                                -0.20365892 0.0 0.0 -28.497631 -6.7015944 0.0 0.0 -26.75088 -8.560288 0.0 0.0
                                -0.583256 -1.2014498 0.0 0.0 -1.1188589 -0.69314724 0.0 0.0 -28.341269
                                -25.36709 0.0 0.0 -1.2659894 -0.55512524 0.0 0.0 -26.937302 -5.179945 0.0 0.0
                                -0.9972019 0.8537863 0.0 0.0 -26.2403 -8.050935 0.0 0.0 -1.0818777 -0.6889695
                                0.0 0.0 -0.9302316 -0.05365789 0.0 0.0 -26.93105 -5.186817 0.0 0.0 -26.41969
                                -7.41623 0.0 0.0 -1.2984784 -0.27640045 0.0 0.0 -36.28554 11.824365 0.0 0.0
                                -583.4418 -380.3362 0.0 0.0 -1.3349187 0.095698886 0.0 0.0 -1.2901726
                                0.22543819 0.0 0.0 -548.91296 -73.20475 0.0 0.0 -26.8115 5.9220595 0.0 0.0
                                -21.266514 -11.100978 0.0 0.0 -1.333818 -0.060106542 0.0 0.0 -1.1928754
                                0.3805595 0.0 0.0 -0.9042397 0.39612755 0.0 0.0 -48.057117 -1.1000663 0.0 0.0
                                -1.2606281 -1.2308464 0.0 0.0 -26.769306 -8.681 0.0 0.0 -1.3026108
                                -0.116492726 0.0 0.0 -551.6093 -60.090336 0.0 0.0 -1.1641393 -0.59173626 0.0
                                0.0 -1.3389363 -0.023212435 0.0 0.0 -24.08134 -0.04035455 0.0 0.0 -586.6365
                                124.05795 0.0 0.0 -25.838106 -3.651025 0.0 0.0 -1.3190395 -0.14808813 0.0 0.0
                                -1.1987959 -0.521151 0.0 0.0 -30.555412 -6.157038 0.0 0.0 -23.139364
                                -12.10555 0.0 0.0 -1.2264184 0.1407837 0.0 0.0 -0.80685985 -0.32541066 0.0
                                0.0 -1.2913157 -0.12733515 0.0 0.0 -543.4347 -118.96677 0.0 0.0 -1.2724375
                                -0.34807244 0.0 0.0 -1.2444341 0.3228322 0.0 0.0 -28.209696 0.9570304 0.0 0.0
                                -40.64102 -7.8266587 0.0 0.0 -1.3164794 -0.2050383 0.0 0.0 -1.3135846
                                -0.55150497 0.0 0.0 -1.335698 -0.008283589 0.0 0.0 -1.335537 0.06357447 0.0
                                0.0 -27.53699 -0.8749998 0.0 0.0 -19.53479 19.32363 0.0 0.0 -0.98486227
                                -0.758715 0.0 0.0 -23.928776 3.662935 0.0 0.0 -1.1723778 -0.044622663 0.0 0.0
                                -1.2796782 0.13303493 0.0 0.0 -1.0565733 -0.6230111 0.0 0.0 -0.75706655
                                -0.93637633 0.0 0.0 -1.0962043 -0.76741064 0.0 0.0 -0.990313 -0.8811839 0.0
                                0.0 -1.399102 -0.08894998 0.0 0.0 -30.413076 -2.5498 0.0 0.0 -20.912458
                                -12.276104 0.0 0.0 -24.015516 -3.4515293 0.0 0.0 -24.171156 0.27126816 0.0
                                0.0 -1.2523477 -0.4316345 0.0 0.0 -1.3318028 -0.089397565 0.0 0.0 -1.2909559
                                0.26052016 0.0 0.0 -36.207024 17.110462 0.0 0.0 -1.3382578 -0.028863816 0.0
                                0.0 -1.3283763 0.1860133 0.0 0.0 -26.757725 0.67664546 0.0 0.0 -533.8105
                                -283.7933 0.0 0.0 -26.60639 -6.0862193 0.0 0.0 -37.130013 30.76039 0.0 0.0
                                -801.0585 190.44778 0.0 0.0 -33.794476 -10.781391 0.0 0.0 -1.305199
                                0.11829637 0.0 0.0 -521.12225 206.0744 0.0 0.0 -1.3187286 0.15465704 0.0 0.0
                                -1.3229562 0.21462609 0.0 0.0 -536.1188 281.81595 0.0 0.0 -27.304802
                                -1.0428294 0.0 0.0 -31.3602 -10.415019 0.0 0.0 -1.2101623 0.35437158 0.0 0.0
                                -38.092014 -5.985571 0.0 0.0 -1.0483866 -0.5379355 0.0 0.0 -561.08655
                                -18.27461 0.0 0.0 -34.410236 -17.326555 0.0 0.0 -26.331652 -7.2430277 0.0 0.0
                                -27.582104 0.5368711 0.0 0.0 -24.295973 -0.794978 0.0 0.0 -1.069515
                                -0.8024985 0.0 0.0 -26.401167 -5.6010184 0.0 0.0 -1.2354474 -0.39682248 0.0
                                0.0 -20.79475 -6.600449 0.0 0.0 -1.3153567 0.07677668 0.0 0.0 -1.2708696
                                -0.25232905 0.0 0.0 -1.3274604 0.037809066 0.0 0.0 -19.997063 4.5178485 0.0
                                0.0 -24.28598 -1.8701657 0.0 0.0 -25.072472 7.701292 0.0 0.0 -34.814754
                                -8.295192 0.0 0.0 -606.6902 -45.714756 0.0 0.0 -40.60276 -9.612533 0.0 0.0
                                -1.3310897 -0.12731569 0.0 0.0 -21.452429 11.143442 0.0 0.0 -1.2798499
                                -0.18649669 0.0 0.0 -1.0278611 -0.36768147 0.0 0.0 -27.670717 -1.0108168 0.0
                                0.0 -26.585136 -7.868583 0.0 0.0 -2.3262415 0.361094 0.0 0.0 -1.3185472
                                0.20138165 0.0 0.0 -1.1692445 0.1509896 0.0 0.0 -25.50008 10.787297 0.0 0.0
                                -27.124006 -4.685564 0.0 0.0 -22.453386 -16.252083 0.0 0.0 -35.126842
                                6.342291 0.0 0.0 -1.1311553 -0.6728217 0.0 0.0 -27.025202 8.858472 0.0 0.0
                                -0.7573392 0.58408046 0.0 0.0 -1.3342544 -0.11892322 0.0 0.0 -1.1638286
                                -0.6295004 0.0 0.0 -28.156902 2.9955041 0.0 0.0 -23.516392 -6.572056 0.0 0.0
                                -1.3346856 0.12565823 0.0 0.0 -1.1918949 -0.59976035 0.0 0.0 -32.380817
                                -7.3888807 0.0 0.0 -26.378716 0.13260484 0.0 0.0 -26.344034 -8.198281 0.0 0.0
                                -1.1531016 -0.03277371 0.0 0.0 -1.2934334 0.3017696 0.0 0.0 -1.3057909
                                0.30270243 0.0 0.0 -0.63712806 -1.1325305 0.0 0.0 -1.5050834 0.17212819 0.0
                                0.0 -20.928703 -12.428945 0.0 0.0 -1.2623783 -0.2240058 0.0 0.0 -24.353409
                                -2.1722226 0.0 0.0 -1.3367479 0.09161 0.0 0.0 -23.8258 5.463456 0.0 0.0
                                -1.2904046 0.3649567 0.0 0.0 -0.90867734 -0.89764625 0.0 0.0 -1.393769
                                0.27724501 0.0 0.0 -47.44577 8.461398 0.0 0.0 -27.761627 -1.7821496 0.0 0.0
                                -32.557888 9.664388 0.0 0.0 -1.3033422 -0.25871125 0.0 0.0 -26.314564
                                -6.5807405 0.0 0.0 -26.430761 -4.2457523 0.0 0.0 -1.2847755 -0.3689604 0.0
                                0.0 -1.0880071 -0.7022086 0.0 0.0 -653.2299 -119.18089 0.0 0.0 -775.76196
                                0.5391081 0.0 0.0 -1.1765102 0.059848975 0.0 0.0 -1.3036764 -0.14752042 0.0
                                0.0 -1.232109 0.4562321 0.0 0.0 -1.335458 -0.018231312 0.0 0.0 -1.2375813
                                0.49163973 0.0 0.0 -35.500877 -6.3318734 0.0 0.0 -1.3200392 -0.12768452 0.0
                                0.0 -1.3058721 -0.21385434 0.0 0.0 -28.43997 12.019596 0.0 0.0 -1.3321363
                                0.11380739 0.0 0.0 -26.477507 0.43950886 0.0 0.0 -1.1857728 -0.10511261 0.0
                                0.0 -942.3286 -278.0209 0.0 0.0 -1.2139466 -0.5335279 0.0 0.0 -24.373497
                                10.221011 0.0 0.0 -27.8762 -8.831523 0.0 0.0 -27.672945 3.2261412 0.0 0.0
                                -1.3040482 0.31009197 0.0 0.0 -1.1097733 -0.63380927 0.0 0.0 -19.99584
                                -14.132689 0.0 0.0 -1.1052636 -0.102575414 0.0 0.0 -1.3207601 -0.19472839 0.0
                                0.0 -1.3252485 -0.18755916 0.0 0.0 -1.4476873 0.15753733 0.0 0.0 -701.1783
                                -78.70318 0.0 0.0 -561.36304 -107.17 0.0 0.0 -1.0432357 -0.18224935 0.0 0.0
                                -1.2379005 -0.15323702 0.0 0.0 -24.38638 2.8628738 0.0 0.0 -725.4895
                                135.76317 0.0 0.0 -2.3042598 -0.58790064 0.0 0.0 -25.45002 -19.255867 0.0 0.0
                                -27.316309 5.8215566 0.0 0.0 -1.6009126 0.21466972 0.0 0.0 -0.9424922
                                -0.9290167 0.0 0.0 -372.46036 -423.36716 0.0 0.0 -1.2890797 -0.09355444 0.0
                                0.0 -1.452618 -0.09692845 0.0 0.0 -1.2805854 -0.32792968 0.0 0.0 -570.31476
                                56.08605 0.0 0.0 -35.84767 5.104947 0.0 0.0 -783.1466 -5.185014 0.0 0.0
                                -44.556873 -9.82249 0.0 0.0 -1.1457855 0.34525958 0.0 0.0 -38.509514
                                7.2206545 0.0 0.0 -27.874928 1.7161725 0.0 0.0 -24.25338 -4.00964 0.0 0.0
                                -1.2326022 0.2467861 0.0 0.0 -1.1671904 -0.2461588 0.0 0.0 -1.2465887
                                0.20231608 0.0 0.0 -1.2563088 -0.4691856 0.0 0.0 -1.2813252 -0.09057193 0.0
                                0.0 -35.384552 -8.071481 0.0 0.0 -24.612543 -0.27923605 0.0 0.0 -1.2668401
                                0.1905694 0.0 0.0 -25.629242 -2.914922 0.0 0.0 -26.566366 -1.5221152 0.0 0.0
                                -1.3313514 -0.09208809 0.0 0.0 -24.18416 -4.646757 0.0 0.0 -609.2767
                                125.42622 0.0 0.0 -1.2189888 0.26305127 0.0 0.0 -1.2213333 0.054597493 0.0
                                0.0 -26.285635 2.4518557 0.0 0.0 -1.5098633 0.098716415 0.0 0.0 -1.0971748
                                -0.5520138 0.0 0.0 -1.3365042 0.11602443 0.0 0.0 -24.56229 -1.96803 0.0 0.0
                                -26.335567 11.638166 0.0 0.0 -595.44073 -315.5212 0.0 0.0 -1.2747134
                                0.16237554 0.0 0.0 -1.2771748 0.09037284 0.0 0.0 -513.4026 -437.14218 0.0 0.0
                                -25.461462 17.785454 0.0 0.0 -1.3221745 0.1726849 0.0 0.0 -24.653727
                                0.6688289 0.0 0.0 -23.207312 -8.352552 0.0 0.0 -1.5951827 -0.2063238 0.0 0.0
                                -1.2348691 -0.4956636 0.0 0.0 -19.22037 -18.447586 0.0 0.0 -24.234327
                                4.6340985 0.0 0.0 -1.3136562 -0.23310444 0.0 0.0 -669.10266 -94.27679 0.0 0.0
                                -674.68945 -39.64896 0.0 0.0 -577.6726 -19.36278 0.0 0.0 -1.253135
                                -0.38063055 0.0 0.0 -31.212334 18.79646 0.0 0.0 -0.43829852 -1.225829 0.0 0.0
                                -38.827625 18.00873 0.0 0.0 -1.3240255 0.20625326 0.0 0.0 -19.217869
                                -15.47768 0.0 0.0 -539.41724 -209.80771 0.0 0.0 -1.2708215 0.13462126 0.0 0.0
                                -1.1077684 0.1147085 0.0 0.0 -24.58124 2.5103288 0.0 0.0 -50.069 19.848593
                                0.0 0.0 -1.2602385 -0.29349244 0.0 0.0 -31.125595 6.814925 0.0 0.0 -26.42653
                                3.6612463 0.0 0.0 -566.54034 -122.736465 0.0 0.0 -1.1351823 -0.53167665 0.0
                                0.0 -1.2249439 -0.014238447 0.0 0.0 -1.308876 0.28663796 0.0 0.0 -1.1620836
                                -0.12301904 0.0 0.0 -34.31183 -25.38648 0.0 0.0 -21.946144 -11.329846 0.0 0.0
                                -27.92175 3.2230039 0.0 0.0 -1.2408447 0.48889077 0.0 0.0 -1.271731 0.3858984
                                0.0 0.0 -0.8553151 0.7165587 0.0 0.0 -27.923227 3.4545498 0.0 0.0 -1.2109913
                                -0.42037788 0.0 0.0 -1.2392094 0.3421678 0.0 0.0 -1.1859183 -0.59985 0.0 0.0
                                -35.82612 7.447015 0.0 0.0 -0.755028 -1.0860745 0.0 0.0 -1.2920613 0.3477129
                                0.0 0.0 -28.107662 -0.06697869 0.0 0.0 -29.652206 9.964035 0.0 0.0 -1.1512595
                                0.008511081 0.0 0.0 -1.1284045 0.19665493 0.0 0.0 -1.158195 -0.6314389 0.0
                                0.0 -1.2622185 -0.305805 0.0 0.0 -1.2553979 0.35648438 0.0 0.0 -25.514292
                                5.830528 0.0 0.0 -1.9203929 -0.32544804 0.0 0.0 -1.0581154 0.058794677 0.0
                                0.0 -1.2507519 -0.3465175 0.0 0.0 -36.989548 14.187392 0.0 0.0 -1.1274745
                                -0.63322145 0.0 0.0 -1.1974101 -0.48171946 0.0 0.0 -24.63801 2.5802712 0.0
                                0.0 -30.325521 15.163965 0.0 0.0 -1.3139488 -0.17245972 0.0 0.0 -1.1820272
                                -0.519133 0.0 0.0 -738.7944 24.041458 0.0 0.0 -1.3510435 0.36395422 0.0 0.0
                                -1161.0248 241.6526 0.0 0.0 -1.253045 0.4740173 0.0 0.0 -20.402378 -4.1340523
                                0.0 0.0 -27.923368 -1.9180509 0.0 0.0 -1.3110988 0.26871264 0.0 0.0 -0.970971
                                -0.9228704 0.0 0.0 -1.1968946 0.582785 0.0 0.0 -26.235958 5.4777284 0.0 0.0
                                -31.237806 -13.32619 0.0 0.0 -23.296783 8.602327 0.0 0.0 -1.2668729
                                0.24895118 0.0 0.0 -1.2477157 0.2967754 0.0 0.0 -14.234382 -15.891107 0.0 0.0
                                -1.2778367 -0.16770937 0.0 0.0 -0.96611744 0.14178902 0.0 0.0 -721.1869
                                -295.29324 0.0 0.0 -26.023745 -1.9194124 0.0 0.0 -1.2825553 0.17340973 0.0
                                0.0 -1.3092049 -0.03027606 0.0 0.0 -26.08471 -5.641532 0.0 0.0 -638.3147
                                -239.4502 0.0 0.0 -1.332408 0.061465356 0.0 0.0 -1.2320372 -0.28504893 0.0
                                0.0 -22.763004 -10.012228 0.0 0.0 -1.1788027 -0.5353042 0.0 0.0 -1.240164
                                0.49209762 0.0 0.0 -1.1904379 -0.14672436 0.0 0.0 -22.142124 11.327982 0.0
                                0.0 -31.34156 -2.938088 0.0 0.0 -30.328985 8.42055 0.0 0.0 -26.274181
                                5.078433 0.0 0.0 -657.60785 -202.07834 0.0 0.0 -1.2433362 -0.44896156 0.0 0.0
                                -23.344667 -8.637431 0.0 0.0 -24.741129 2.674918 0.0 0.0 -1.2733502
                                -0.37488896 0.0 0.0 -1.281036 -0.10898104 0.0 0.0 -1.327004 -0.08579086 0.0
                                0.0 -1.3397696 0.06691174 0.0 0.0 -1.1144364 -0.7343526 0.0 0.0 -1.2538947
                                -0.041943442 0.0 0.0 -1.1748464 -0.38279957 0.0 0.0 -22.771101 -13.892595 0.0
                                0.0 -1.1788313 -0.6078055 0.0 0.0 -1.2964371 0.19069287 0.0 0.0 -1.0949154
                                -0.16085792 0.0 0.0 -1.3324522 0.08147923 0.0 0.0 -1.1655324 -0.64448947 0.0
                                0.0 -24.90096 1.1374583 0.0 0.0 -25.656113 7.9327235 0.0 0.0 -0.8080852
                                -0.946178 0.0 0.0 -1.3065449 -0.08280924 0.0 0.0 -24.396404 5.1618295 0.0 0.0
                                -588.344 -43.679 0.0 0.0 -1.3295913 0.11348267 0.0 0.0 -23.959202 15.074324
                                0.0 0.0 -1.2797099 -0.07804092 0.0 0.0 -1.1578186 -0.6377319 0.0 0.0
                                -24.688856 2.9521873 0.0 0.0 -0.99112535 0.3670553 0.0 0.0 -27.776505
                                -5.7997313 0.0 0.0 -28.370342 -0.1853823 0.0 0.0 -23.947926 16.673986 0.0 0.0
                                -42.430458 8.808087 0.0 0.0 -29.22069 0.4585462 0.0 0.0 -1.1999468 -0.4829485
                                0.0 0.0 -27.92824 -5.0210032 0.0 0.0 -1.3182685 0.048052974 0.0 0.0
                                -25.715286 -7.95242 0.0 0.0 -1.2431185 0.29666117 0.0 0.0 -1.13501 0.6559643
                                0.0 0.0 -742.87646 -329.92947 0.0 0.0 -1.2563379 0.40226418 0.0 0.0
                                -629.95056 119.00445 0.0 0.0 -28.246426 1.7645423 0.0 0.0 -1.2873474
                                -0.3411547 0.0 0.0 -28.68281 16.018997 0.0 0.0 -1.2268983 -0.23313151 0.0 0.0
                                -1.3040109 -0.09750307 0.0 0.0 -46.163696 -20.96944 0.0 0.0 -26.649734
                                9.907911 0.0 0.0 -29.338974 -6.292267 0.0 0.0 -1.057321 0.7949669 0.0 0.0
                                -555.35394 -418.55856 0.0 0.0 -499.10873 321.11667 0.0 0.0 -1.2427273
                                -0.002108276 0.0 0.0 -1.3254662 -0.20443895 0.0 0.0 -1.0309674 0.81272674 0.0
                                0.0 -31.11261 -6.130998 0.0 0.0 -1.2590362 0.1163534 0.0 0.0 -24.30826
                                5.855596 0.0 0.0 -17.834436 -14.537118 0.0 0.0 -1.1475985 0.64363235 0.0 0.0
                                -34.476894 1.6562395 0.0 0.0 -1.2924125 -0.18775193 0.0 0.0 -23.877832
                                7.5238404 0.0 0.0 -593.0282 46.547634 0.0 0.0 -1.0669236 -0.7430068 0.0 0.0
                                -1.0729333 -0.12781684 0.0 0.0 -1.2948036 -0.33056822 0.0 0.0 -28.46417
                                0.24089046 0.0 0.0 -1.3056993 -0.28726333 0.0 0.0 -609.4836 -210.49612 0.0
                                0.0 -1.2265445 0.15422107 0.0 0.0 -34.807636 5.215666 0.0 0.0 -1.3084117
                                0.10669601 0.0 0.0 -1.0925282 -0.74268377 0.0 0.0 -27.74896 -6.4476852 0.0
                                0.0 -1.2615744 -0.16987503 0.0 0.0 -1.0808337 0.7617637 0.0 0.0 -25.33513
                                -9.724247 0.0 0.0 -1.2247349 0.3805231 0.0 0.0 -1.2165334 -0.3285459 0.0 0.0
                                -0.8182696 -1.0348226 0.0 0.0 -1.2445037 -0.39228633 0.0 0.0 -1.0303895
                                -0.82320935 0.0 0.0 -1.3344489 -0.1304244 0.0 0.0 -33.524445 -4.8943276 0.0
                                0.0 -25.632818 -12.374374 0.0 0.0 -513.0771 306.15195 0.0 0.0 -26.540403
                                -5.7956386 0.0 0.0 -34.73671 -5.8747125 0.0 0.0 -638.8611 104.67101 0.0 0.0
                                -1.3319448 -0.07612219 0.0 0.0 -21.167976 19.09312 0.0 0.0 -588.63165
                                -270.39258 0.0 0.0 -1.290187 -0.14919128 0.0 0.0 -1.1845498 -0.60292774 0.0
                                0.0 -26.852003 2.9829478 0.0 0.0 -1.0846993 -0.20915323 0.0 0.0 -926.62646
                                -272.59933 0.0 0.0 -1.2168826 -0.34989363 0.0 0.0 -1.3356367 0.10910795 0.0
                                0.0 -1.2946818 -0.2933476 0.0 0.0 -1.2931176 -0.35661814 0.0 0.0 -1.3296105
                                -0.14833145 0.0 0.0 -1.0260291 -0.83074814 0.0 0.0 -893.22864 -13.001839 0.0
                                0.0 -1.2508719 0.156573 0.0 0.0 -1.2911779 -0.27934572 0.0 0.0 -23.784294
                                8.0798025 0.0 0.0 -24.945671 3.1192036 0.0 0.0 -28.14461 -21.389442 0.0 0.0
                                -26.644686 7.2363687 0.0 0.0 -21.996925 -11.423295 0.0 0.0 -50.813618
                                0.19030765 0.0 0.0 -629.22266 -164.89433 0.0 0.0 -1.0372862 -0.5765212 0.0
                                0.0 -1.3015679 0.32008448 0.0 0.0 -40.577324 -4.996738 0.0 0.0 -1.3218244
                                0.027286468 0.0 0.0 -1.058118 -0.8197245 0.0 0.0 -1.0654601 -0.7793922 0.0
                                0.0 -47.475838 -2.9545407 0.0 0.0 -2.6821878 0.7484733 0.0 0.0 -1.3344493
                                0.13260815 0.0 0.0 -1.0771326 -0.6596474 0.0 0.0 -1.2240064 -0.48293057 0.0
                                0.0 -28.339169 -3.9291232 0.0 0.0 -1.3291434 0.12514932 0.0 0.0 -1.1516787
                                -0.005823061 0.0 0.0 -34.246586 -9.089588 0.0 0.0 -1.3144987 0.1746255 0.0
                                0.0 -1.2795624 -0.30929348 0.0 0.0 -599.3031 -63.187824 0.0 0.0 -573.866
                                -184.31773 0.0 0.0 -1.0530998 -0.7920498 0.0 0.0 -1.3329439 0.013584141 0.0
                                0.0 -1.7695962 -0.53082263 0.0 0.0 -27.073915 -0.8459981 0.0 0.0 -1.2500336
                                0.043297224 0.0 0.0 -31.683302 -7.235814 0.0 0.0 -18.0924 17.510872 0.0 0.0
                                -24.155598 20.971762 0.0 0.0 -29.045155 -5.6062403 0.0 0.0 -1.3357223
                                -0.10785497 0.0 0.0 -25.266594 13.570379 0.0 0.0 -1.2981796 0.33849117 0.0
                                0.0 -26.527637 -10.720275 0.0 0.0 -1.3402884 -0.024127806 0.0 0.0 -947.0167
                                473.6564 0.0 0.0 -0.98257095 0.731958 0.0 0.0 -25.623472 -9.493727 0.0 0.0
                                -1.2742524 -0.41304937 0.0 0.0 -40.803505 3.2976806 0.0 0.0 -1.3196366
                                0.04996868 0.0 0.0 -1.045639 0.8289957 0.0 0.0 -695.70514 -144.16968 0.0 0.0
                                -1.0951405 0.4404095 0.0 0.0 -1.2833576 0.21568902 0.0 0.0 -1.0395073
                                -0.40134856 0.0 0.0 -1243.0151 -91.05382 0.0 0.0 -1.2755282 -0.28623444 0.0
                                0.0 -1.281812 -0.3558756 0.0 0.0 -605.90173 -14.293811 0.0 0.0 -1.3383859
                                0.031632617 0.0 0.0 -1.2852541 0.08704683 0.0 0.0 -604.5219 -47.883194 0.0
                                0.0 -26.988287 -12.240911 0.0 0.0 -21.64481 -5.430304 0.0 0.0 -1.3243246
                                -0.1293259 0.0 0.0 -1.3207916 0.13073601 0.0 0.0 -1.335839 0.09489733 0.0 0.0
                                -26.834309 -11.720513 0.0 0.0 -21.469694 -12.147309 0.0 0.0 -1.2305647
                                -0.057638798 0.0 0.0 -1.3321804 0.10449505 0.0 0.0 -94.469765 -1.0669742 0.0
                                0.0 -31.507687 6.4363174 0.0 0.0 -1.276744 0.41073054 0.0 0.0 -0.7393993
                                -0.5164399 0.0 0.0 -601.7783 86.94603 0.0 0.0 -0.9631257 -0.8087563 0.0 0.0
                                -980.1733 97.32037 0.0 0.0 -37.510548 -4.356639 0.0 0.0 -653.6771 -86.6921
                                0.0 0.0 -1.338881 0.02050396 0.0 0.0 -902.09015 118.05195 0.0 0.0 -1.1386411
                                -0.04065818 0.0 0.0 -1.4882157 -1.4354115 0.0 0.0 -26.98016 10.113163 0.0 0.0
                                -27.893295 -7.1364603 0.0 0.0 -22.580519 11.364104 0.0 0.0 -1.1966952
                                -0.5846536 0.0 0.0 -1.295896 -0.18453503 0.0 0.0 -37.70893 -2.6413522 0.0 0.0
                                -75.29843 -2.032657 0.0 0.0 -27.422878 -1.5238762 0.0 0.0 -1.2907051
                                0.10759546 0.0 0.0 -1.3315818 0.11823813 0.0 0.0 -27.099201 9.042982 0.0 0.0
                                -1.4979544 -0.1328155 0.0 0.0 -28.53857 4.2081275 0.0 0.0 -32.222324
                                -0.8868616 0.0 0.0 -1.3316176 -0.14743118 0.0 0.0 -1.2238709 -1.0082626 0.0
                                0.0 -34.67632 -7.524564 0.0 0.0 -25.711872 12.872718 0.0 0.0 -37.711777
                                -3.0359771 0.0 0.0 -29.787762 -0.4353632 0.0 0.0 -1.2203478 -0.5535373 0.0
                                0.0 -1.1513028 0.45007405 0.0 0.0 -1.3178345 -0.20864443 0.0 0.0 -27.421818
                                -0.14800736 0.0 0.0 -19.422081 16.355871 0.0 0.0 -1.2724968 0.010334969 0.0
                                0.0 -1.2880383 -0.34011337 0.0 0.0 -1.3622613 -0.8795176 0.0 0.0 -1.1125723
                                -0.7417563 0.0 0.0 -0.695766 0.510694 0.0 0.0 -27.55604 8.637413 0.0 0.0
                                -0.88837546 -0.23564163 0.0 0.0 -24.922352 4.9647393 0.0 0.0 -1.1727537
                                -0.5164799 0.0 0.0 -25.043726 4.1951485 0.0 0.0 -29.591196 3.7427704 0.0 0.0
                                -1.0735703 -0.7784754 0.0 0.0 -1.085984 -0.7539338 0.0 0.0 -1.3397675
                                0.04668631 0.0 0.0 -27.986017 3.199383 0.0 0.0 -35.836666 -0.18102965 0.0 0.0
                                -1.3316276 -0.088356495 0.0 0.0 -531.6974 -400.27066 0.0 0.0 -1.2301757
                                0.25801134 0.0 0.0 -1.317167 0.25414398 0.0 0.0 -1.2010409 -0.59254116 0.0
                                0.0 -1.1600903 -0.59174967 0.0 0.0 -1.2114339 -0.28833863 0.0 0.0 -781.68024
                                47.19171 0.0 0.0 -1583.1316 -345.11902 0.0 0.0 -618.1495 -249.403 0.0 0.0
                                -25.29781 13.821602 0.0 0.0 -1.2857469 0.3240411 0.0 0.0 -28.01788 -22.122946
                                0.0 0.0 -1.1649417 -0.45149833 0.0 0.0 -722.7781 29.452631 0.0 0.0 -1.3295597
                                -0.17467098 0.0 0.0 -1.2475735 -0.3616412 0.0 0.0 -15.898961 7.7295513 0.0
                                0.0 -0.9103461 -0.9442441 0.0 0.0 -1.2320782 -0.5204012 0.0 0.0 -1.2039909
                                -0.5473203 0.0 0.0 -1.2317683 -0.34043798 0.0 0.0 -28.069454 7.0197334 0.0
                                0.0 -27.07828 -5.167211 0.0 0.0 -1.2726022 -0.10059899 0.0 0.0 -1.2983949
                                -0.21705535 0.0 0.0 -1.2491856 0.101841815 0.0 0.0 -1.2405033 -0.38370892 0.0
                                0.0 -35.53723 5.0594954 0.0 0.0 -25.623371 15.375329 0.0 0.0 -1.1499196
                                0.48238158 0.0 0.0 -1.3301994 0.13142735 0.0 0.0 -576.76373 -220.59294 0.0
                                0.0 -1.2229702 0.04399423 0.0 0.0 -0.9519672 -0.94463676 0.0 0.0 -23.735298
                                9.190299 0.0 0.0 -1.2039233 -0.34963843 0.0 0.0 -0.98572195 -0.7710519 0.0
                                0.0 -15.9582615 5.3640203 0.0 0.0 -25.674526 15.424175 0.0 0.0 -0.86212426
                                -1.0144936 0.0 0.0 -0.85717595 0.97542185 0.0 0.0 -1.3383676 0.009283382 0.0
                                0.0 -1.3136907 -0.15202986 0.0 0.0 -27.628763 1.7039657 0.0 0.0 -27.91275
                                -5.080638 0.0 0.0 -26.371326 -8.280779 0.0 0.0 -1.2976904 0.32286268 0.0 0.0
                                -1.2802608 -0.39398134 0.0 0.0 -1.1171497 -0.6870372 0.0 0.0 -28.634317
                                -3.4030805 0.0 0.0 -41.595825 -0.31040514 0.0 0.0 -1.313116 -0.06909342 0.0
                                0.0 -1.306963 -0.15277466 0.0 0.0 -34.545418 -6.6987724 0.0 0.0 -1.2458203
                                -0.22066738 0.0 0.0 -24.724396 6.5153427 0.0 0.0 -23.583363 5.0135593 0.0 0.0
                                -27.584375 2.7502565 0.0 0.0 -1.2027187 -0.5813534 0.0 0.0 -29.956684
                                2.4838922 0.0 0.0 -1.4912382 -0.054284524 0.0 0.0 -1.0054506 0.8740703 0.0
                                0.0 -1.22297 0.4747222 0.0 0.0 -1.3066822 -0.16115202 0.0 0.0 -765.03674
                                -207.72395 0.0 0.0 -1.3013283 0.051378965 0.0 0.0 -1.3115057 -0.13904838 0.0
                                0.0 -1.2547232 -0.43413398 0.0 0.0 -26.813377 -6.670275 0.0 0.0 -28.858145
                                3.687038 0.0 0.0 -1.2088437 0.42101288 0.0 0.0 -1.2879298 0.08998019 0.0 0.0
                                -35.715458 -5.04519 0.0 0.0 -23.34742 16.42434 0.0 0.0 -1.4723191 -0.38231257
                                0.0 0.0 -44.880898 -4.7691736 0.0 0.0 -27.77275 -0.36034688 0.0 0.0
                                -30.107502 -0.5046868 0.0 0.0 -34.1914 2.4628904 0.0 0.0 -28.310972 -6.89976
                                0.0 0.0 -29.12829 -7.6769924 0.0 0.0 -1.3155458 -0.26286426 0.0 0.0
                                -1.1322143 -0.6621512 0.0 0.0 -29.947332 -3.344875 0.0 0.0 -25.651949
                                -13.704894 0.0 0.0 -26.25074 9.018816 0.0 0.0 -28.854555 -4.0624466 0.0 0.0
                                -1.3131124 -0.5059119 0.0 0.0 -1.2044705 -0.45649043 0.0 0.0 -677.1033
                                -11.126946 0.0 0.0 -1.1491387 -0.6236293 0.0 0.0 -1.2226151 0.52101177 0.0
                                0.0 -25.552658 -2.291597 0.0 0.0 -624.76984 262.62103 0.0 0.0 -1.2823263
                                -0.28199115 0.0 0.0 -25.43545 -3.366069 0.0 0.0 -567.3604 262.344 0.0 0.0
                                -1.2456416 -0.32800257 0.0 0.0 -25.543133 -2.4771388 0.0 0.0 -27.817179
                                1.0672588 0.0 0.0 -28.591778 9.695218 0.0 0.0 -1.4482527 -0.3843349 0.0 0.0
                                -25.674475 -0.312687 0.0 0.0 -1.2984695 0.23634878 0.0 0.0 -1.2324624
                                0.074379005 0.0 0.0 -0.9736061 -0.5659586 0.0 0.0 -2.2366798 0.3469177 0.0
                                0.0 -29.134598 -1.5907416 0.0 0.0 -28.947392 16.858631 0.0 0.0 -32.691372
                                -2.0425837 0.0 0.0 -1.3226905 -0.18471931 0.0 0.0 -1.33369 -0.048854873 0.0
                                0.0 -1.8359215 0.2954379 0.0 0.0 -1.3399297 0.02851838 0.0 0.0 -1.2713106
                                0.38369843 0.0 0.0 -43.388374 12.324491 0.0 0.0 -24.83892 5.640385 0.0 0.0
                                -23.983084 -14.0474 0.0 0.0 -26.875755 11.543183 0.0 0.0 -25.162334 -9.833137
                                0.0 0.0 -29.198517 1.7891215 0.0 0.0 -1.0719011 0.3185488 0.0 0.0 -1.2117033
                                0.3194879 0.0 0.0 -27.189798 -9.45494 0.0 0.0 -1.7868673 -0.3066396 0.0 0.0
                                -721.63666 163.72394 0.0 0.0 -25.030691 5.6112595 0.0 0.0 -1.3094649
                                0.19577664 0.0 0.0 -28.849 -4.9581156 0.0 0.0 -1.006357 -0.78590935 0.0 0.0
                                -25.219856 5.1833606 0.0 0.0 -1.1390696 -0.6741318 0.0 0.0 -1.1344904
                                0.49268273 0.0 0.0 -1.2200255 -0.041254222 0.0 0.0 -1.273466 0.07066645 0.0
                                0.0 -1.0804706 0.6134014 0.0 0.0 -573.8777 -259.3449 0.0 0.0 -1.2090467
                                -0.3429098 0.0 0.0 -28.87229 -4.862752 0.0 0.0 -30.223585 -2.4194994 0.0 0.0
                                -1.3268061 -0.0819855 0.0 0.0 -1.2723488 0.1673036 0.0 0.0 -1.2519646
                                -0.32387608 0.0 0.0 -1.3099254 -0.012045331 0.0 0.0 -28.929295 -4.6668158 0.0
                                0.0 -1.116087 -0.79518557 0.0 0.0 -28.394497 4.4155536 0.0 0.0 -1.1221005
                                0.09838136 0.0 0.0 -1.284166 -0.14412732 0.0 0.0 -712.1938 -213.68993 0.0 0.0
                                -720.219 -185.44682 0.0 0.0 -1.1599282 0.6658778 0.0 0.0 -24.84591 -6.943712
                                0.0 0.0 -1.1580476 -0.5031438 0.0 0.0 -889.60034 524.62415 0.0 0.0 -1.1121418
                                -0.69068563 0.0 0.0 -25.79151 -0.90576375 0.0 0.0 -63.276596 0.4238867 0.0
                                0.0 -25.784492 -5.0882096 0.0 0.0 -1.1016684 -0.118966624 0.0 0.0 -1.3223733
                                0.20449336 0.0 0.0 -0.9852099 0.9611181 0.0 0.0 -1.1431472 0.69428104 0.0 0.0
                                -25.703297 -1.7963744 0.0 0.0 -1.273852 -0.22730061 0.0 0.0 -1.3113664
                                0.24242394 0.0 0.0 -1.3069293 -0.07796453 0.0 0.0 -1.3327484 -0.040329665 0.0
                                0.0 -1.2643276 0.14241369 0.0 0.0 -688.1935 427.8594 0.0 0.0 -35.718174
                                2.64747 0.0 0.0 -1.1341555 -0.66354775 0.0 0.0 -944.10876 146.53514 0.0 0.0
                                -27.876446 0.1298075 0.0 0.0 -1.2216741 -0.4247837 0.0 0.0 -35.030365
                                -23.308844 0.0 0.0 -24.634865 -7.7890964 0.0 0.0 -1.3395368 0.039164722 0.0
                                0.0 -42.15464 2.1890967 0.0 0.0 -0.71752435 -0.4997683 0.0 0.0 -1.3285027
                                0.0036886632 0.0 0.0 -1.8931237 -0.1819687 0.0 0.0 -21.558296 -3.7955937 0.0
                                0.0 -33.857143 -19.277485 0.0 0.0 -1.3318697 -0.06341321 0.0 0.0 -1.274982
                                0.12972507 0.0 0.0 -1.1362356 -0.85997516 0.0 0.0 -1.2505821 -0.4491384 0.0
                                0.0 -1.3609453 0.040286146 0.0 0.0 -26.814245 8.288259 0.0 0.0 -1.329563
                                0.033593785 0.0 0.0 -32.88548 3.0176647 0.0 0.0 -25.028194 4.586253 0.0 0.0
                                -54.061348 1.9385259 0.0 0.0 -1.3268362 -0.19085202 0.0 0.0 -1.2349207
                                0.015076503 0.0 0.0 -1.2146213 0.08502783 0.0 0.0 -1.2388157 -0.5087581 0.0
                                0.0 -28.829165 -16.248526 0.0 0.0 -639.1521 264.64102 0.0 0.0 -26.694763
                                12.385616 0.0 0.0 -40.939156 -10.64628 0.0 0.0 -1.2221795 -0.34420854 0.0 0.0
                                -1.1152798 0.7166584 0.0 0.0 -28.054604 -0.20480055 0.0 0.0 -1.0943285
                                -0.3983331 0.0 0.0 -1.2161738 0.4587701 0.0 0.0 -1.3323941 -0.10140547 0.0
                                0.0 -41.589657 -8.177096 0.0 0.0 -1.1926793 0.47316188 0.0 0.0 -1.202567
                                0.32105726 0.0 0.0 -1.235199 -0.07475181 0.0 0.0 -613.46484 177.75752 0.0 0.0
                                -1.2020262 0.519528 0.0 0.0 -27.366907 -6.6397333 0.0 0.0 -1.3018851
                                0.27693355 0.0 0.0 -24.494267 -8.538195 0.0 0.0 -26.846186 12.123601 0.0 0.0
                                -44.931442 -9.977519 0.0 0.0 -22.896717 -17.635582 0.0 0.0 -24.358133
                                13.923813 0.0 0.0 -27.802437 -9.936313 0.0 0.0 -747.69775 -101.27728 0.0 0.0
                                -72.670074 -28.17153 0.0 0.0 -102.79937 -34.311905 0.0 0.0 -33.17709
                                1.4460782 0.0 0.0 -21.792143 -19.140263 0.0 0.0 -1.2923548 -0.021482913 0.0
                                0.0 -1.0868753 -0.73557496 0.0 0.0 -1.4551164 -0.27829492 0.0 0.0 -29.474443
                                2.1914015 0.0 0.0 -26.88154 -4.9156017 0.0 0.0 -1.2541382 0.43018028 0.0 0.0
                                -1.133033 -0.75160164 0.0 0.0 -28.173899 -1.4680549 0.0 0.0 -30.909391
                                -7.316086 0.0 0.0 -28.651371 -6.9394407 0.0 0.0 -1.3274825 0.016929578 0.0
                                0.0 -29.187582 4.4474025 0.0 0.0 -1.2635658 0.31573278 0.0 0.0 -1.2437401
                                -0.40912342 0.0 0.0 -20.428844 15.829664 0.0 0.0 -1.2467227 -0.2844652 0.0
                                0.0 -1.1185695 -0.15671147 0.0 0.0 -0.99606544 0.42659304 0.0 0.0 -26.016638
                                0.49542361 0.0 0.0 -1.2896892 0.27670267 0.0 0.0 -1.2744434 0.1649227 0.0 0.0
                                -0.9159007 -0.6886708 0.0 0.0 -27.846735 -4.8089094 0.0 0.0 -28.537062
                                6.386825 0.0 0.0 -29.584309 -1.3146114 0.0 0.0 -1.2754515 0.24933432 0.0 0.0
                                -44.516705 12.8012905 0.0 0.0 -1.2838595 -0.22960712 0.0 0.0 -26.001976
                                1.4490355 0.0 0.0 -1.0260056 -0.8508239 0.0 0.0 -1.9087906 -0.44709387 0.0
                                0.0 -1.0659512 0.72837186 0.0 0.0 -1509.4484 -530.0735 0.0 0.0 -26.46959
                                15.56111 0.0 0.0 -1.189093 0.11316514 0.0 0.0 -30.579525 -2.9657342 0.0 0.0
                                -26.014673 12.52252 0.0 0.0 -1.3212107 0.0021150184 0.0 0.0 -32.180706
                                16.628592 0.0 0.0 -29.61358 -1.3695132 0.0 0.0 -1.2671986 0.32399538 0.0 0.0
                                -1.3034959 -0.091940634 0.0 0.0 -1.259469 -0.30738398 0.0 0.0 -1.2829293
                                -0.058018435 0.0 0.0 -1.157498 -0.51446617 0.0 0.0 -1.2386668 -0.43556118 0.0
                                0.0 -670.1062 -208.09833 0.0 0.0 -27.249643 -7.72532 0.0 0.0 -1.3403646
                                0.018897215 0.0 0.0 -26.491098 -4.212799 0.0 0.0 -1.2108159 -0.5450885 0.0
                                0.0 -520.31903 -464.9203 0.0 0.0 -27.583927 -13.646056 0.0 0.0 -644.95715
                                48.157215 0.0 0.0 -1.3297781 -0.084389046 0.0 0.0 -1.2706741 0.4171782 0.0
                                0.0 -1.1953785 0.21921384 0.0 0.0 -1.2416564 0.117917426 0.0 0.0 -30.489367
                                -0.24805021 0.0 0.0 -27.656404 8.693548 0.0 0.0 -27.638212 6.3784122 0.0 0.0
                                -0.6448819 -0.5415947 0.0 0.0 -38.982414 6.163213 0.0 0.0 -1.239111
                                -0.49316975 0.0 0.0 -28.550327 -8.0035305 0.0 0.0 -1.3343838 -0.12209816 0.0
                                0.0 -1.2155384 -0.21384192 0.0 0.0 -1.328797 -0.10486243 0.0 0.0 -24.290846
                                14.687829 0.0 0.0 -1.145478 -0.6138096 0.0 0.0 -1.3097026 0.28762898 0.0 0.0
                                -29.21971 -8.93987 0.0 0.0 -648.9573 -8.412718 0.0 0.0 -1.2969187 0.3198539
                                0.0 0.0 -1.2438452 0.36622652 0.0 0.0 -23.746098 17.0009 0.0 0.0 -1.3361871
                                -5.793124e-4 0.0 0.0 -1.1328747 -0.6959333 0.0 0.0 -26.04953 1.8156443 0.0
                                0.0 -23.557272 -17.89543 0.0 0.0 -1.0666357 0.8082666 0.0 0.0 -27.97577
                                -12.673241 0.0 0.0 -1.2776704 0.10050362 0.0 0.0 -28.589079 8.136447 0.0 0.0
                                -1.3036723 -0.2496378 0.0 0.0 -1.3019222 -0.017401546 0.0 0.0 -29.077103
                                -18.425756 0.0 0.0 -1.1673261 0.63750684 0.0 0.0 -1.2608376 0.19609798 0.0
                                0.0 -1.6560513 0.34000543 0.0 0.0 -1.2536676 0.6557758 0.0 0.0 -2.0101666
                                0.093817 0.0 0.0 -27.108143 14.810921 0.0 0.0 -1.3398125 0.002006311 0.0 0.0
                                -27.811167 -6.9322047 0.0 0.0 -24.316164 9.199813 0.0 0.0 -1.1838552
                                -0.49367613 0.0 0.0 -700.85785 318.9006 0.0 0.0 -1.3167232 -0.19812068 0.0
                                0.0 -1.110701 -0.39562592 0.0 0.0 -1.2709904 -0.42199978 0.0 0.0 -1.3110949
                                0.26483917 0.0 0.0 -1.2822143 0.11159921 0.0 0.0 -30.578161 4.757564 0.0 0.0
                                -1.2361686 0.51067513 0.0 0.0 -1.2061524 -0.4992695 0.0 0.0 -1.1463257
                                -0.67345726 0.0 0.0 -28.16911 -8.085053 0.0 0.0 -18.466711 -13.987554 0.0 0.0
                                -0.7241801 0.9640977 0.0 0.0 -1.1993208 -0.280952 0.0 0.0 -1.2105812
                                -0.5780614 0.0 0.0 -1.2890855 0.116886474 0.0 0.0 -650.4484 -67.10093 0.0 0.0
                                -1.2167914 -0.54536676 0.0 0.0 -1.2077568 -0.39868432 0.0 0.0 -1.1113446
                                0.2865382 0.0 0.0 -24.992443 -15.993319 0.0 0.0 -25.474129 6.32627 0.0 0.0
                                -29.74391 2.7679389 0.0 0.0 -1.1798978 0.040374726 0.0 0.0 -1.3250242
                                0.20817009 0.0 0.0 -29.410885 0.06353219 0.0 0.0 -28.532646 8.822316 0.0 0.0
                                -28.262028 -9.587713 0.0 0.0 -1.1475844 -0.4317061 0.0 0.0 -39.873558
                                5.373639 0.0 0.0 -21.548363 18.730486 0.0 0.0 -1.4185671 0.14664973 0.0 0.0
                                -1.3131957 0.13363953 0.0 0.0 -594.9354 -74.78236 0.0 0.0 -1.2437259 0.231103
                                0.0 0.0 -23.023848 12.603269 0.0 0.0 -713.1232 -20.294586 0.0 0.0 -1.3119434
                                -0.07595091 0.0 0.0 -1.0586036 -0.2563888 0.0 0.0 -33.656075 -1.0335442 0.0
                                0.0 -33.184513 -6.132394 0.0 0.0 -1.3275405 -0.093819 0.0 0.0 -1.3136158
                                -0.11406111 0.0 0.0 -1.2768265 0.2645306 0.0 0.0 -0.7861951 0.7611131 0.0 0.0
                                -1.3313328 0.033673763 0.0 0.0 -1.3167983 0.093884245 0.0 0.0 -32.086384
                                10.546695 0.0 0.0 -1.2653786 -0.16231975 0.0 0.0 -1.2450991 0.15641245 0.0
                                0.0 -1.1265817 0.70916635 0.0 0.0 -1.3689978 -0.11066554 0.0 0.0 -1.2677847
                                -0.40919822 0.0 0.0 -1.0610746 -0.8171308 0.0 0.0 -1.0182567 -0.8335587 0.0
                                0.0 -28.343494 -3.888292 0.0 0.0 -40.9171 -23.350752 0.0 0.0 -1.2322505
                                0.48540497 0.0 0.0 -28.737877 1.5685785 0.0 0.0 -1.3021438 0.2342799 0.0 0.0
                                -1.2710826 0.2213746 0.0 0.0 -1.2860086 -0.37608114 0.0 0.0 -654.2938
                                81.95658 0.0 0.0 -39.327053 -7.1217546 0.0 0.0 -56.054756 -19.628841 0.0 0.0
                                -649.33655 116.85128 0.0 0.0 -1.4998006 -0.5286209 0.0 0.0 -24.465406
                                9.812899 0.0 0.0 -1.2895933 0.22229339 0.0 0.0 -26.293554 11.353318 0.0 0.0
                                -1.3016875 0.32277167 0.0 0.0 -539.5338 -380.9805 0.0 0.0 -29.940985
                                -1.7032079 0.0 0.0 -0.71078867 -1.0629796 0.0 0.0 -25.791763 -0.26310414 0.0
                                0.0 -39.875893 -3.4903088 0.0 0.0 -36.157898 9.480296 0.0 0.0 -650.3984
                                119.06799 0.0 0.0 -26.339436 1.5327525 0.0 0.0 -1240.7206 363.75125 0.0 0.0
                                -1.1687322 -0.60485744 0.0 0.0 -29.799664 3.5977538 0.0 0.0 -0.80808324
                                0.38348615 0.0 0.0 -1.2433544 0.2954335 0.0 0.0 -0.9799161 -0.49770218 0.0
                                0.0 -38.65129 9.968639 0.0 0.0 -28.192638 5.300295 0.0 0.0 -849.7779
                                -59.34764 0.0 0.0 -20.994385 -22.98042 0.0 0.0 -1.1620746 -0.08519217 0.0 0.0
                                -33.252922 -14.105453 0.0 0.0 -0.9710564 -0.71639174 0.0 0.0 -1.0980333
                                0.7049099 0.0 0.0 -28.680086 -12.335541 0.0 0.0 -28.99559 -0.973395 0.0 0.0
                                -652.4908 -119.655075 0.0 0.0 -1.224077 0.15916473 0.0 0.0 -29.43285
                                -6.1345835 0.0 0.0 -33.818264 2.5471942 0.0 0.0 -1.1891123 -0.5067064 0.0 0.0
                                -28.571167 3.2091808 0.0 0.0 -1.2784514 0.2950047 0.0 0.0 -1.3100785
                                -0.14411038 0.0 0.0 -779.6909 -97.85401 0.0 0.0 -18.237783 19.048317 0.0 0.0
                                -1.3239686 0.20259081 0.0 0.0 -39.125847 -5.764902 0.0 0.0 -1.3180615
                                -0.13960327 0.0 0.0 -613.07526 -383.61948 0.0 0.0 -24.857523 -9.015774 0.0
                                0.0 -1.245445 -0.3483797 0.0 0.0 -0.95780015 -0.9121115 0.0 0.0 -1.3008554
                                -0.31529212 0.0 0.0 -0.94974923 -0.47450584 0.0 0.0 -1.3294032 -0.15379527
                                0.0 0.0 -29.76257 4.4332147 0.0 0.0 -1.3018318 -0.21384317 0.0 0.0 -29.083668
                                -6.865155 0.0 0.0 -1.4180908 0.5539127 0.0 0.0 -1.3016719 -0.22316867 0.0 0.0
                                -24.929945 8.934881 0.0 0.0 -788.5854 2.2893605 0.0 0.0 -1.2688498
                                -0.0025689306 0.0 0.0 -706.2627 -351.50104 0.0 0.0 -832.37885 -209.35048 0.0
                                0.0 -0.9431704 -0.9455021 0.0 0.0 -52.48205 13.961743 0.0 0.0 -28.217382
                                -5.880174 0.0 0.0 -1.3370625 -0.04526971 0.0 0.0 -28.637417 -12.696567 0.0
                                0.0 -1.3335556 -0.1007272 0.0 0.0 -1.2895031 -0.24981253 0.0 0.0 -31.309383
                                -1.7849253 0.0 0.0 -1.2317604 -0.51193035 0.0 0.0 -1.3155857 0.2107792 0.0
                                0.0 -29.781849 -3.9140654 0.0 0.0 -1.2972386 0.33781844 0.0 0.0 -61.368637
                                2.0911076 0.0 0.0 -1.2683843 0.43444544 0.0 0.0 -1.1866053 0.22430152 0.0 0.0
                                -32.27024 2.7858324 0.0 0.0 -787.9948 -76.35772 0.0 0.0 -1.8357621 -1.150037
                                0.0 0.0 -23.855135 20.3699 0.0 0.0 -672.97076 -652.8128 0.0 0.0 -26.531052
                                -0.9462316 0.0 0.0 -861.519 -33.067394 0.0 0.0 -485.17822 380.1725 0.0 0.0
                                -30.113401 -2.4682288 0.0 0.0 -674.45465 276.18802 0.0 0.0 -24.617826
                                -9.925636 0.0 0.0 -647.9966 170.79152 0.0 0.0 -26.406685 -14.700345 0.0 0.0
                                -683.07477 -403.8885 0.0 0.0 -1.2757039 -0.019344412 0.0 0.0 -1.2142615
                                -0.43843552 0.0 0.0 -22.826197 13.358795 0.0 0.0 -51.01075 9.666352 0.0 0.0
                                -15.831478 13.524237 0.0 0.0 -1.0066344 0.8751234 0.0 0.0 -1.2822115
                                -0.20185046 0.0 0.0 -1.3154069 -0.5452359 0.0 0.0 -1.3392174 0.002563372 0.0
                                0.0 -26.349766 -14.774778 0.0 0.0 -25.904211 -6.0404015 0.0 0.0 -25.267792
                                7.9482694 0.0 0.0 -1.2968366 0.22552314 0.0 0.0 -74.11019 19.720558 0.0 0.0
                                -24.626225 -19.53823 0.0 0.0 -1.3931086 0.5365768 0.0 0.0 -1.1877662
                                -0.5745749 0.0 0.0 -1.2389588 0.29814267 0.0 0.0 -1.2709306 -0.31131077 0.0
                                0.0 -24.094257 -11.147223 0.0 0.0 -28.747925 -3.4827266 0.0 0.0 -26.84449
                                13.786755 0.0 0.0 -1.2561722 -0.45874912 0.0 0.0 -1.2671818 -0.18332894 0.0
                                0.0 -1.2266735 0.25621945 0.0 0.0 -37.11379 3.6487727 0.0 0.0 -1.2201965
                                -0.30100995 0.0 0.0 -1.1912895 -0.29569682 0.0 0.0 -1.5109261 0.26268685 0.0
                                0.0 -1.5874486 -0.07716461 0.0 0.0 -1.2212096 0.156567 0.0 0.0 -674.1847
                                8.953585 0.0 0.0 -1.319795 -0.036304273 0.0 0.0 -1.2340466 -0.39298403 0.0
                                0.0 -946.2641 9.034681 0.0 0.0 -1.1788976 -0.6121027 0.0 0.0 -1.0401605
                                0.33030394 0.0 0.0 -688.74884 -255.41583 0.0 0.0 -702.51514 185.40138 0.0 0.0
                                -796.0952 76.581726 0.0 0.0 -647.8043 -190.86308 0.0 0.0 -1.2361612
                                -0.50592715 0.0 0.0 -51.57573 9.058606 0.0 0.0 -1.223067 -0.5419387 0.0 0.0
                                -39.470383 -9.794564 0.0 0.0 -2.1822772 0.05056886 0.0 0.0 -23.781967
                                -12.101894 0.0 0.0 -1.2689061 -0.18185809 0.0 0.0 -31.04884 5.4485126 0.0 0.0
                                -1.1768433 -0.47598603 0.0 0.0 -1.339017 0.048214894 0.0 0.0 -35.283245
                                -11.918094 0.0 0.0 -40.350677 -5.320931 0.0 0.0 -1.2875391 -0.11566572 0.0
                                0.0 -26.642523 -0.58332336 0.0 0.0 -1.0474671 0.8136172 0.0 0.0 -1.2946423
                                0.34875277 0.0 0.0 -1.2499748 0.3895048 0.0 0.0 -39.69504 -9.173541 0.0 0.0
                                -1.2518203 0.24002363 0.0 0.0 -1.1824373 -0.5132214 0.0 0.0 -1.331926
                                0.024726838 0.0 0.0 -1.2830184 -0.21973774 0.0 0.0 -1.339482 -1.822915e-4 0.0
                                0.0 -1.2546766 -0.4404935 0.0 0.0 -25.586126 -7.7387843 0.0 0.0 -27.25889
                                -10.150348 0.0 0.0 -30.33224 9.049723 0.0 0.0 -30.190096 -2.595264 0.0 0.0
                                -1.2703662 -0.3025408 0.0 0.0 -1.3984641 -0.0013915822 0.0 0.0 -1.3262713
                                -0.1820131 0.0 0.0 -1.1652 0.5657887 0.0 0.0 -1.4575598 -0.4517572 0.0 0.0
                                -29.911955 4.4400578 0.0 0.0 -30.359509 1.0238062 0.0 0.0 -28.515299
                                5.2346926 0.0 0.0 -518.26416 -381.58517 0.0 0.0 -1.3108069 0.11257699 0.0 0.0
                                -1.2720089 -0.41383645 0.0 0.0 -52.40205 5.3114495 0.0 0.0 -29.917961 1.49351
                                0.0 0.0 -28.426907 -10.8892975 0.0 0.0 -1.091712 -0.66019005 0.0 0.0
                                -24.329742 -2.5780764 0.0 0.0 -1.2204612 -0.49497053 0.0 0.0 -0.9853491
                                -0.7766584 0.0 0.0 -1.4695174 0.4478095 0.0 0.0 -526.8872 295.5559 0.0 0.0
                                -30.472553 -0.19512933 0.0 0.0 -1.2838042 0.37991244 0.0 0.0 -29.339725
                                7.9307985 0.0 0.0 -1.1346253 0.71303463 0.0 0.0 -713.7635 203.89154 0.0 0.0
                                -30.46738 0.6588839 0.0 0.0 -1.2368935 -0.47455207 0.0 0.0 -30.24751 -3.75689
                                0.0 0.0 -1.1722096 0.6379841 0.0 0.0 -33.90161 -10.152085 0.0 0.0 -1.2777236
                                -0.266097 0.0 0.0 -0.81736195 -1.2121652 0.0 0.0 -1.2305557 -0.14891015 0.0
                                0.0 -1.3182304 0.18126866 0.0 0.0 -1.2967706 -0.17104828 0.0 0.0 -1.2116644
                                -0.30229995 0.0 0.0 -2.530729 -0.90210813 0.0 0.0 -21.019558 -23.783373 0.0
                                0.0 -1.1955953 0.48956236 0.0 0.0 -27.147493 2.3095574 0.0 0.0 -1.3167492
                                0.1333711 0.0 0.0 -0.931481 -0.8434072 0.0 0.0 -909.58655 -312.29288 0.0 0.0
                                -1139.0564 -495.21564 0.0 0.0 -34.634167 -21.979153 0.0 0.0 -502.76437
                                -464.28705 0.0 0.0 -27.470312 9.977088 0.0 0.0 -1.3064018 -0.30277616 0.0 0.0
                                -1.1871417 -0.553583 0.0 0.0 -860.2139 -205.46552 0.0 0.0 -1.6059173
                                0.3405153 0.0 0.0 -1.302861 0.26626295 0.0 0.0 -1.3314098 0.04880589 0.0 0.0
                                -1.2242864 0.715466 0.0 0.0 -1.1347157 0.64320225 0.0 0.0 -0.94437855
                                0.93616444 0.0 0.0 -1.3202431 -0.17737973 0.0 0.0 -1.2216125 0.31041357 0.0
                                0.0 -1.1459328 -0.66630715 0.0 0.0 -40.958214 -4.944045 0.0 0.0 -63.008736
                                -25.799126 0.0 0.0 -2.5851238 -0.8670806 0.0 0.0 -1.0114053 -0.54985344 0.0
                                0.0 -1.0370302 0.21761014 0.0 0.0 -25.868835 -7.3394833 0.0 0.0 -742.4981
                                90.570076 0.0 0.0 -1.2656661 0.07589092 0.0 0.0 -808.4739 102.75025 0.0 0.0
                                -23.271322 19.456905 0.0 0.0 -1.3345306 -0.11794459 0.0 0.0 -31.441078
                                -5.247631 0.0 0.0 -26.398615 -15.502026 0.0 0.0 -26.81245 -2.058138 0.0 0.0
                                -0.9133592 -0.9523673 0.0 0.0 -1.3379672 0.093595095 0.0 0.0 -29.997326
                                -5.896771 0.0 0.0 -37.688538 -6.524844 0.0 0.0 -17.33248 -20.585173 0.0 0.0
                                -1.2396668 -0.12041626 0.0 0.0 -1.2086707 -0.4726958 0.0 0.0 -0.97334427
                                -0.8810638 0.0 0.0 -1.3058449 -0.049832664 0.0 0.0 -31.002563 -6.7716303 0.0
                                0.0 -1.3044276 0.30759138 0.0 0.0 -665.4219 179.1804 0.0 0.0 -1.3347223
                                -0.021393163 0.0 0.0 -26.875246 1.731302 0.0 0.0 -22.784153 14.373277 0.0 0.0
                                -1.2565587 0.27516943 0.0 0.0 -958.0808 158.96472 0.0 0.0 -30.141891
                                -2.9440062 0.0 0.0 -1.2074795 0.23861997 0.0 0.0 -42.167606 14.600166 0.0 0.0
                                -1.3259025 -0.008280687 0.0 0.0 -1.178573 -0.27689838 0.0 0.0 -1.0279474
                                -0.4023947 0.0 0.0 -1.2933927 0.328633 0.0 0.0 -1.189393 0.057471227 0.0 0.0
                                -30.26026 -5.0386195 0.0 0.0 -26.799475 -3.0508986 0.0 0.0 -1.3238145
                                -0.10316757 0.0 0.0 -11.841358 12.654375 0.0 0.0 -1.2967526 -0.3416706 0.0
                                0.0 -1.306937 -0.2654526 0.0 0.0 -32.221916 21.195255 0.0 0.0 -26.720865
                                -12.201205 0.0 0.0 -1.25497 -0.44363517 0.0 0.0 -54.434002 -20.572718 0.0 0.0
                                -1.2537367 -0.03983905 0.0 0.0 -1.2629911 0.31469586 0.0 0.0 -1.2980866
                                0.04604893 0.0 0.0 -1.3341829 -0.12568267 0.0 0.0 -1.0655781 0.10383156 0.0
                                0.0 -26.7188 -12.223631 0.0 0.0 -691.2031 -47.126156 0.0 0.0 -28.132128
                                20.572998 0.0 0.0 -41.909153 -16.238274 0.0 0.0 -25.389095 -9.244509 0.0 0.0
                                -28.664694 5.992813 0.0 0.0 -1.2512542 0.014072087 0.0 0.0 -33.80653
                                -8.495333 0.0 0.0 -1.3299918 0.16255425 0.0 0.0 -1.113697 -0.60191107 0.0 0.0
                                -0.9639025 0.806063 0.0 0.0 -25.309935 9.170516 0.0 0.0 -38.476498 -2.7536693
                                0.0 0.0 -1.2746152 -0.19235478 0.0 0.0 -32.0378 1.4364535 0.0 0.0 -1.3050966
                                -0.1988818 0.0 0.0 -23.131071 -12.495364 0.0 0.0 -29.256624 -0.51643276 0.0
                                0.0 -29.493593 6.020459 0.0 0.0 -1.2919567 -0.038523473 0.0 0.0 -0.88691884
                                -1.0063541 0.0 0.0 -37.22054 8.004762 0.0 0.0 -1.3986211 0.21413685 0.0 0.0
                                -29.362885 2.6170204 0.0 0.0 -1.0620534 -0.23327765 0.0 0.0 -1.1277146
                                0.5390209 0.0 0.0 -25.09205 -9.935482 0.0 0.0 -1.3017707 0.32167763 0.0 0.0
                                -1.3350885 -0.45856306 0.0 0.0 -1.5186162 -0.32230136 0.0 0.0 -1.2675834
                                0.018085564 0.0 0.0 -1.3014714 0.10577908 0.0 0.0 -29.41416 9.056498 0.0 0.0
                                -29.915298 7.406148 0.0 0.0 -1.2898413 -0.12194639 0.0 0.0 -1.3216482
                                0.20304175 0.0 0.0 -1.1251262 0.6109321 0.0 0.0 -27.501535 3.8653104 0.0 0.0
                                -1.1092298 -0.4601174 0.0 0.0 -1.078336 -0.77306557 0.0 0.0 -1.0289531
                                -0.6658317 0.0 0.0 -29.133974 -9.676712 0.0 0.0 -30.809011 9.153498 0.0 0.0
                                -25.84244 -14.204308 0.0 0.0 -1.3151098 0.043655727 0.0 0.0 -1.2248037
                                -0.29977506 0.0 0.0 -29.314342 -9.614795 0.0 0.0 -1.1839964 0.5334437 0.0 0.0
                                -30.108494 -3.22319 0.0 0.0 -775.0735 -297.00128 0.0 0.0 -1.336686
                                -0.052628286 0.0 0.0 -38.68944 23.346218 0.0 0.0 -1.2483648 -0.2821568 0.0
                                0.0 -29.589457 12.719657 0.0 0.0 -1.2918314 -0.33589634 0.0 0.0 -1.3192519
                                0.049909085 0.0 0.0 -28.661203 3.854661 0.0 0.0 -1.2986995 0.33247048 0.0 0.0
                                -28.286858 15.349725 0.0 0.0 -1.3343346 -0.13761556 0.0 0.0 -29.10807
                                -4.4466376 0.0 0.0 -1.318133 0.24389929 0.0 0.0 -25.22786 10.056641 0.0 0.0
                                -27.705534 -10.3987465 0.0 0.0 -26.49214 5.9927535 0.0 0.0 -27.267246
                                12.912561 0.0 0.0 -1.2796959 0.23748183 0.0 0.0 -23.133596 -0.27847585 0.0
                                0.0 -1.3190401 0.001236096 0.0 0.0 -27.137405 1.4195858 0.0 0.0 -35.87658
                                2.113043 0.0 0.0 -1.3057076 -0.09027209 0.0 0.0 -1.3381724 -0.032239925 0.0
                                0.0 -26.840952 -4.0999527 0.0 0.0 -763.6485 335.29828 0.0 0.0 -34.233685
                                20.106857 0.0 0.0 -29.59741 1.222784 0.0 0.0 -25.677412 -8.901061 0.0 0.0
                                -1.3327801 -0.068880886 0.0 0.0 -38.878456 0.1417051 0.0 0.0 -27.052227
                                -2.598304 0.0 0.0 -1.3361808 -0.036833 0.0 0.0 -1.2977042 -0.0061660777 0.0
                                0.0 -1.2604706 0.073408715 0.0 0.0 -1.3373446 -0.04813914 0.0 0.0 -30.735275
                                3.7289767 0.0 0.0 -1.3211504 0.2316523 0.0 0.0 -27.847404 16.261372 0.0 0.0
                                -1.3385398 0.0072302795 0.0 0.0 -1.3213292 -0.1714988 0.0 0.0 -1.290605
                                0.24787928 0.0 0.0 -1.3386306 0.011612822 0.0 0.0 -1.3041127 0.2968774 0.0
                                0.0 -701.70966 58.76847 0.0 0.0 -29.249056 4.9749017 0.0 0.0 -35.433548
                                -14.871237 0.0 0.0 -34.807495 -16.291822 0.0 0.0 -1.3566864 -0.010204486 0.0
                                0.0 -1.284776 0.14124224 0.0 0.0 -1.1241156 -0.7260459 0.0 0.0 -765.6362
                                68.87278 0.0 0.0 -766.7153 -57.505848 0.0 0.0 -1.2163794 -0.11750172 0.0 0.0
                                -24.511446 -11.868566 0.0 0.0 -1.3248613 0.096652195 0.0 0.0 -30.89304
                                -7.778458 0.0 0.0 -479.04724 -631.9705 0.0 0.0 -1.280608 -0.18044427 0.0 0.0
                                -34.668995 -16.52776 0.0 0.0 -24.983335 -10.814221 0.0 0.0 -1.1729839
                                -0.6354069 0.0 0.0 -30.601734 3.944229 0.0 0.0 -30.433523 -1.0893688 0.0 0.0
                                -1.3058954 0.29786453 0.0 0.0 -28.710325 7.661151 0.0 0.0 -25.02225 10.559797
                                0.0 0.0 -29.904104 -8.1999445 0.0 0.0 -836.67755 -84.17024 0.0 0.0 -1.0701512
                                0.38750696 0.0 0.0 -1.2315048 -0.6910136 0.0 0.0 -706.3052 41.39691 0.0 0.0
                                -0.8288285 -1.0485194 0.0 0.0 -1.2867764 0.16526675 0.0 0.0 -1.2746631
                                -0.081290804 0.0 0.0 -1.2234683 -0.022984771 0.0 0.0 -27.116322 -2.6892996
                                0.0 0.0 -1.1202394 0.38300934 0.0 0.0 -28.325945 12.715655 0.0 0.0 -26.3289
                                -16.510313 0.0 0.0 -26.273666 -7.4764776 0.0 0.0 -659.48737 -259.64905 0.0
                                0.0 -696.3477 -132.7308 0.0 0.0 -1.7638898 -0.55925465 0.0 0.0 -27.071873
                                -2.84292 0.0 0.0 -1.2725977 0.06523358 0.0 0.0 -1.0762951 -0.77629334 0.0 0.0
                                -1.3207651 0.10256788 0.0 0.0 -52.93333 -8.435295 0.0 0.0 -1.2990845
                                0.15959169 0.0 0.0 -1.2923672 0.19615471 0.0 0.0 -1.293968 0.3428304 0.0 0.0
                                -1.3002375 0.30145976 0.0 0.0 -23.467684 14.148272 0.0 0.0 -29.524284
                                -3.3821163 0.0 0.0 -0.824788 -0.89890754 0.0 0.0 -31.117514 0.39187083 0.0
                                0.0 -1.28229 -0.012265905 0.0 0.0 -1.1536862 0.45054725 0.0 0.0 -0.9637686
                                0.39934126 0.0 0.0 -1.2973711 0.16083074 0.0 0.0 -1.8862123 -0.065635964 0.0
                                0.0 -54.540207 -4.0732327 0.0 0.0 -472.38162 -489.92093 0.0 0.0 -1.0344964
                                -0.0125470385 0.0 0.0 -642.5018 -306.23038 0.0 0.0 -30.82214 -2.1627665 0.0
                                0.0 -1.44146 -0.39243373 0.0 0.0 -1.3346317 0.042134997 0.0 0.0 -37.282192
                                -9.750506 0.0 0.0 -1.1745453 -0.5921882 0.0 0.0 -1.1147528 -0.7412596 0.0 0.0
                                -1.3334605 -0.12383654 0.0 0.0 -1.3311296 0.088135056 0.0 0.0 -638.67194
                                -316.67392 0.0 0.0 -1.262352 -0.33246964 0.0 0.0 -1.3324376 -0.12609524 0.0
                                0.0 -1.3248109 -0.1507299 0.0 0.0 -35.04931 -4.5615873 0.0 0.0 -1.3822478
                                -0.34052864 0.0 0.0 -27.327242 2.1692164 0.0 0.0 -37.93736 -0.827308 0.0 0.0
                                -28.717394 -11.646118 0.0 0.0 -1.2498097 0.21217579 0.0 0.0 -0.9205804
                                -0.863576 0.0 0.0 -1003.9879 -125.009254 0.0 0.0 -32.58758 0.7057816 0.0 0.0
                                -27.011091 -14.409827 0.0 0.0 -1.2786157 0.09761871 0.0 0.0 -21.293346
                                8.510203 0.0 0.0 -24.472706 -9.731859 0.0 0.0 -1.2505395 -0.28567925 0.0 0.0
                                -1.2625244 -0.38306597 0.0 0.0 -32.260143 4.941691 0.0 0.0 -25.027237
                                10.959669 0.0 0.0 -29.422949 20.04249 0.0 0.0 -1.2568161 0.4385898 0.0 0.0
                                -1.3144177 -0.13300437 0.0 0.0 -1.3293486 -0.13894433 0.0 0.0 -1.3261555
                                -0.075458705 0.0 0.0 -1.552206 0.365465 0.0 0.0 -1.3159896 -0.0062917396 0.0
                                0.0 -1.3165803 -0.08318987 0.0 0.0 -31.078438 3.1602576 0.0 0.0 -1.2967166
                                -0.32301876 0.0 0.0 -1.3064469 -0.25467598 0.0 0.0 -0.891165 -0.9660902 0.0
                                0.0 -1.3119742 -0.19249703 0.0 0.0 -1.182938 0.29527473 0.0 0.0 -25.979385
                                -10.289205 0.0 0.0 -1.2816566 -0.026970943 0.0 0.0 -28.916042 7.833282 0.0
                                0.0 -671.6102 -252.8144 0.0 0.0 -1.1391895 0.6382455 0.0 0.0 -0.8698807
                                0.27467442 0.0 0.0 -30.181038 8.04261 0.0 0.0 -36.13174 -14.4818325 0.0 0.0
                                -29.69812 4.219575 0.0 0.0 -27.379755 -6.2622147 0.0 0.0 -1.5357099
                                -0.07894523 0.0 0.0 -30.979647 4.384845 0.0 0.0 -32.607895 14.545658 0.0 0.0
                                -1.3249168 0.0051499084 0.0 0.0 -29.219625 14.757324 0.0 0.0 -38.45746
                                8.893618 0.0 0.0 -17.63044 -25.691845 0.0 0.0 -34.377075 -24.979366 0.0 0.0
                                -27.08459 -18.40371 0.0 0.0 -769.47925 -156.98024 0.0 0.0 -31.530312
                                -8.857437 0.0 0.0 -1.2088768 0.40561736 0.0 0.0 -1.1437328 0.46891525 0.0 0.0
                                -31.24976 0.22811304 0.0 0.0 -1.302312 0.02617289 0.0 0.0 -0.7996151
                                0.7312272 0.0 0.0 -1.3093417 0.03444028 0.0 0.0 -700.5562 357.4312 0.0 0.0
                                -22.530022 15.213607 0.0 0.0 -1.1340649 0.53400385 0.0 0.0 -1.314119
                                0.15297115 0.0 0.0 -1.5122749 -0.529433 0.0 0.0 -1.1557617 0.3540116 0.0 0.0
                                -1.2978019 0.017307457 0.0 0.0 -32.685074 -2.1871743 0.0 0.0 -1.324363
                                -0.056730926 0.0 0.0 -1.299228 0.0027064271 0.0 0.0 -1.509354 -0.17422473 0.0
                                0.0 -30.390068 -6.7382255 0.0 0.0 -693.44934 374.6523 0.0 0.0 -1.3305683
                                0.06070254 0.0 0.0 -720.67126 -49.673275 0.0 0.0 -29.36762 -8.130072 0.0 0.0
                                -1.2232481 -0.47562402 0.0 0.0 -741.7151 -268.74338 0.0 0.0 -1.1702685
                                -0.5303266 0.0 0.0 -1.188036 0.011976459 0.0 0.0 -0.9694332 -0.44165868 0.0
                                0.0 -1.3078358 -0.2973734 0.0 0.0 -1.2545197 -0.41185227 0.0 0.0 -26.998415
                                5.7374597 0.0 0.0 -1.2355016 -0.25514287 0.0 0.0 -38.950092 -3.7744 0.0 0.0
                                -1.8716097 0.37533087 0.0 0.0 -1.3035885 0.02041093 0.0 0.0 -920.63916
                                -376.9111 0.0 0.0 -70.01557 -36.112812 0.0 0.0 -689.6862 -221.53061 0.0 0.0
                                -1.2044021 0.21324214 0.0 0.0 -25.073645 11.485858 0.0 0.0 -1.3405564
                                0.026370171 0.0 0.0 -635.0836 -349.4865 0.0 0.0 -1.1211629 0.7281152 0.0 0.0
                                -0.75396866 -1.0110749 0.0 0.0 -30.698734 -11.714025 0.0 0.0 -31.177095
                                -3.8448641 0.0 0.0 -1.0787416 -0.9858487 0.0 0.0 -26.061949 10.762382 0.0 0.0
                                -851.62994 151.52927 0.0 0.0 -1.3177606 0.47088596 0.0 0.0 -1.2300795
                                0.011297107 0.0 0.0 -31.361578 0.48982844 0.0 0.0 -1.1685845 0.65516675 0.0
                                0.0 -1.6402678 0.21656887 0.0 0.0 -34.619827 -9.583656 0.0 0.0 -27.694063
                                14.056809 0.0 0.0 -704.77124 -364.57758 0.0 0.0 -29.871105 4.3859572 0.0 0.0
                                -29.598402 -6.5509186 0.0 0.0 -1.3013364 0.27228525 0.0 0.0 -1.2823187
                                -0.12084492 0.0 0.0 -31.274971 3.0152528 0.0 0.0 -1.1315991 0.48266143 0.0
                                0.0 -31.88919 8.204673 0.0 0.0 -1.052055 0.70341086 0.0 0.0 -1.2685778
                                -0.38318378 0.0 0.0 -1.2400278 -0.15586102 0.0 0.0 -1.3365022 -0.044171512
                                0.0 0.0 -1.2873591 -0.24096808 0.0 0.0 -1.2250766 -0.26187804 0.0 0.0
                                -1.222423 -0.39571345 0.0 0.0 -1.2241046 -0.019295152 0.0 0.0 -1.0720601
                                0.5193778 0.0 0.0 -1.3160126 -0.24295536 0.0 0.0 -25.105827 16.843716 0.0 0.0
                                -1.2766691 -0.3043482 0.0 0.0 -31.19262 -4.200972 0.0 0.0 -1.3318175
                                0.11526648 0.0 0.0 -31.126245 -3.748378 0.0 0.0 -1.2470049 0.40879595 0.0 0.0
                                -1.229612 -0.35022143 0.0 0.0 -1.1086223 -0.57136965 0.0 0.0 -1.2700831
                                -0.30228588 0.0 0.0 -1.3014162 0.12470855 0.0 0.0 -701.01404 -427.09796 0.0
                                0.0 -0.9242871 -0.32685396 0.0 0.0 -729.012 47.614517 0.0 0.0 -38.187996
                                -1.2880918 0.0 0.0 -1.2903647 -0.061274454 0.0 0.0 -1.3687958 -0.5163824 0.0
                                0.0 -30.390224 -6.645364 0.0 0.0 -0.9860307 -0.72023785 0.0 0.0 -26.81589
                                -4.56388 0.0 0.0 -1.3104122 -0.19994704 0.0 0.0 -1.262776 -0.37980607 0.0 0.0
                                -1.1789249 -0.6363019 0.0 0.0 -1.2965798 0.14353701 0.0 0.0 -1.2906619
                                -0.34112576 0.0 0.0 -30.495695 3.6156409 0.0 0.0 -1382.6809 -533.35095 0.0
                                0.0 -868.7254 394.2426 0.0 0.0 -1.1923255 -0.48906583 0.0 0.0 -1.2284818
                                -0.15938747 0.0 0.0 -1.3291559 0.031748317 0.0 0.0 -28.790014 9.48536 0.0 0.0
                                -1.2891433 0.23050241 0.0 0.0 -716.0635 -358.2438 0.0 0.0 -1.1507461
                                -0.5200591 0.0 0.0 -1.2416885 0.38603947 0.0 0.0 -1.0584984 -0.29966396 0.0
                                0.0 -29.332458 -11.810769 0.0 0.0 -0.96609426 -0.7911186 0.0 0.0 -31.544651
                                2.2972353 0.0 0.0 -26.45443 -8.427091 0.0 0.0 -1.0996135 -0.5843453 0.0 0.0
                                -1.2522748 -0.17741278 0.0 0.0 -29.979494 -10.011673 0.0 0.0 -3.2307932
                                -0.53192866 0.0 0.0 -1.2584482 -0.46261948 0.0 0.0 -26.430481 14.93519 0.0
                                0.0 -25.696299 -12.748778 0.0 0.0 -35.25277 -8.271528 0.0 0.0 -38.736485
                                7.161492 0.0 0.0 -1.3123295 0.23337586 0.0 0.0 -31.307808 10.965418 0.0 0.0
                                -1.2703936 -0.21225812 0.0 0.0 0.17665555 -1.1904752 0.0 0.0 -0.97145593
                                -0.15018049 0.0 0.0 -1.4029057 0.2996484 0.0 0.0 -1.336607 0.105452344 0.0
                                0.0 -1.3297284 -0.032360554 0.0 0.0 -27.127449 -6.143997 0.0 0.0 -0.84719294
                                0.848188 0.0 0.0 -1142.6692 -84.99286 0.0 0.0 -1.157544 -0.1496702 0.0 0.0
                                -696.63495 239.83951 0.0 0.0 -28.864285 -12.893598 0.0 0.0 -26.74063 7.77975
                                0.0 0.0 -1.2795573 0.22427349 0.0 0.0 -33.110817 -14.831044 0.0 0.0
                                -1.3287959 -0.15704645 0.0 0.0 -1.2552048 0.0155971935 0.0 0.0 -1.2570584
                                0.46420026 0.0 0.0 -1.2846073 0.36149985 0.0 0.0 -1.3360977 -0.076961964 0.0
                                0.0 -1.2594132 0.42930996 0.0 0.0 -1.3207111 0.08336437 0.0 0.0 -35.688625
                                -6.4568467 0.0 0.0 -31.059086 -6.4271574 0.0 0.0 -1.1803765 -0.5131667 0.0
                                0.0 -1.2796522 0.34217513 0.0 0.0 -1.2696887 -0.30957636 0.0 0.0 -1.1212759
                                0.53144985 0.0 0.0 -1.2748418 -0.38305417 0.0 0.0 -1.2447224 -0.46511704 0.0
                                0.0 -1.2177407 0.4959278 0.0 0.0 -51.20065 0.39290795 0.0 0.0 -1.286339
                                -0.37494543 0.0 0.0 -31.738163 -0.95131373 0.0 0.0 -1.3293163 -0.17399648 0.0
                                0.0 -27.129307 6.49519 0.0 0.0 -1.2320176 0.3844522 0.0 0.0 -0.6543825
                                0.7949951 0.0 0.0 -1.2317581 -0.48308536 0.0 0.0 -27.837698 -15.292414 0.0
                                0.0 -1.3244936 0.015560649 0.0 0.0 -882.89954 51.034058 0.0 0.0 -27.744373
                                -3.1277661 0.0 0.0 -1.2601501 -0.4010022 0.0 0.0 -29.134356 4.365486 0.0 0.0
                                -1.2860987 -0.24888799 0.0 0.0 -858.58954 215.40979 0.0 0.0 -1.1899074
                                0.5654763 0.0 0.0 -2.373804 0.10824096 0.0 0.0 -810.0197 -28.371548 0.0 0.0
                                -33.09848 3.6112113 0.0 0.0 -1.229935 0.24903454 0.0 0.0 -1.2552935
                                0.19374709 0.0 0.0 -31.755604 -1.3679122 0.0 0.0 -616.1719 -527.6801 0.0 0.0
                                -31.766352 1.602331 0.0 0.0 -27.94048 -0.9800024 0.0 0.0 -38.837234
                                -19.461092 0.0 0.0 -1.2452614 -0.34916294 0.0 0.0 -1.1845942 -1.0682976 0.0
                                0.0 -20.90066 -23.643095 0.0 0.0 -1.0571313 -0.75514674 0.0 0.0 -29.087538
                                -9.3290825 0.0 0.0 -26.855406 17.049599 0.0 0.0 -35.53576 8.127038 0.0 0.0
                                -1.2814496 0.3751229 0.0 0.0 -689.27405 -279.7562 0.0 0.0 -840.91406
                                -287.4102 0.0 0.0 -1.2771423 0.40582433 0.0 0.0 -30.09983 9.361478 0.0 0.0
                                -33.749767 -13.900686 0.0 0.0 -1.3093475 0.17691535 0.0 0.0 -31.017418
                                2.4514854 0.0 0.0 -0.979545 0.8558637 0.0 0.0 -1.2738203 -0.09446806 0.0 0.0
                                -1.2609091 0.4366331 0.0 0.0 -30.335096 4.0099473 0.0 0.0 -1.2674214
                                0.10171707 0.0 0.0 -1.133033 -0.6285722 0.0 0.0 -0.91831785 -0.8831763 0.0
                                0.0 -29.69941 1.7946695 0.0 0.0 -25.457035 -11.701551 0.0 0.0 -15.331456
                                -27.56244 0.0 0.0 -26.42945 -15.410952 0.0 0.0 -40.04957 -3.5133817 0.0 0.0
                                -1.1900312 -0.6136597 0.0 0.0 -27.45278 13.421547 0.0 0.0 -1.2134082
                                0.44220126 0.0 0.0 -1.2508137 -0.4168953 0.0 0.0 -1.2799416 0.3588248 0.0 0.0
                                -1.3112223 0.049527403 0.0 0.0 -30.995466 2.3355448 0.0 0.0 -1.17184 0.437621
                                0.0 0.0 -31.39258 -5.7522464 0.0 0.0 -39.365864 -18.942564 0.0 0.0 -1.2941458
                                0.16090274 0.0 0.0 -1.1050371 0.7298125 0.0 0.0 -1.2053503 -0.14489765 0.0
                                0.0 -29.808638 7.181683 0.0 0.0 -27.510336 -4.6246343 0.0 0.0 -43.61554
                                -3.1726565 0.0 0.0 -1.3132447 0.26414728 0.0 0.0 -1.3350366 0.011193984 0.0
                                0.0 -1.1406429 -0.6590894 0.0 0.0 -26.98065 -20.224789 0.0 0.0 -30.954882
                                4.587423 0.0 0.0 -27.081968 -7.3700814 0.0 0.0 -86.64268 -61.521835 0.0 0.0
                                -1.3231986 -0.19747958 0.0 0.0 -1.1126802 0.31250876 0.0 0.0 -1.2202998
                                0.41316965 0.0 0.0 -743.2734 -306.16202 0.0 0.0 -1.3190943 0.11280095 0.0 0.0
                                -1.2651987 -0.68287957 0.0 0.0 -1.3216443 0.058684185 0.0 0.0 -55.247715
                                29.071548 0.0 0.0 -1.2876468 0.29760715 0.0 0.0 -31.392332 -3.8009307 0.0 0.0
                                -1.3283008 0.17181017 0.0 0.0 -1.4750081 0.27793765 0.0 0.0 -32.627575
                                -7.9319186 0.0 0.0 -28.11121 -0.4019752 0.0 0.0 -1.3069597 -0.20779695 0.0
                                0.0 -27.295853 5.197584 0.0 0.0 -1.2743374 -0.06283621 0.0 0.0 -1.2445385
                                -0.45363805 0.0 0.0 -27.037067 -7.7523966 0.0 0.0 -24.359474 -6.631247 0.0
                                0.0 -35.459587 9.541132 0.0 0.0 -1.0442054 -0.6999589 0.0 0.0 -1.0161645
                                -0.8479633 0.0 0.0 -29.301702 4.5112004 0.0 0.0 -47.84852 0.7722886 0.0 0.0
                                -28.945438 -9.444423 0.0 0.0 -1.3228508 0.21858367 0.0 0.0 -1.8667593
                                -0.27855211 0.0 0.0 -1.292996 -0.13091435 0.0 0.0 -681.731 319.66678 0.0 0.0
                                -1.253737 -0.3723495 0.0 0.0 -1.3095375 0.28694895 0.0 0.0 -1.3044212
                                -0.13917077 0.0 0.0 -0.4006348 -1.2751752 0.0 0.0 -31.0093 -13.072909 0.0 0.0
                                -1.1866045 0.10759355 0.0 0.0 -1.1147531 0.54384196 0.0 0.0 -1.1965884
                                0.4886957 0.0 0.0 -20.667288 8.455891 0.0 0.0 -1.1432996 -0.48731807 0.0 0.0
                                -1.2658468 -0.42047644 0.0 0.0 -32.05225 -0.98327 0.0 0.0 -1.205458
                                0.46358457 0.0 0.0 -885.7007 -174.10156 0.0 0.0 -40.704044 -0.7938015 0.0 0.0
                                -39.301113 10.587685 0.0 0.0 -698.7013 286.44275 0.0 0.0 -1.2399395
                                -0.28802344 0.0 0.0 -1.1981168 -0.5276123 0.0 0.0 -1.5243292 0.22953288 0.0
                                0.0 -1.1751223 0.5952846 0.0 0.0 -59.39261 20.738602 0.0 0.0 -1.2952373
                                -0.33725902 0.0 0.0 -904.3019 -6.0457096 0.0 0.0 -1.1758335 -0.25203654 0.0
                                0.0 -3.0540357 0.37156183 0.0 0.0 -623.2374 -428.65967 0.0 0.0 -29.794577
                                10.443535 0.0 0.0 -1.2154704 -0.52879757 0.0 0.0 -1.2381419 -0.37647712 0.0
                                0.0 -756.8222 13.113582 0.0 0.0 -27.96333 3.8792934 0.0 0.0 -1.2541322
                                0.20522968 0.0 0.0 -1.214075 -0.41924158 0.0 0.0 -23.94668 -14.786095 0.0 0.0
                                -1.1638038 -0.4834549 0.0 0.0 -29.989399 7.32718 0.0 0.0 -0.9636455
                                -0.9280165 0.0 0.0 -1.2066147 -0.51936615 0.0 0.0 -31.227736 -0.5906698 0.0
                                0.0 -47.77446 4.060013 0.0 0.0 -780.10004 -281.998 0.0 0.0 -1.2004958
                                -0.34431717 0.0 0.0 -53.743706 -18.007517 0.0 0.0 -1.1674391 0.60520697 0.0
                                0.0 -1.327333 0.022018876 0.0 0.0 -1.1270118 -0.5382025 0.0 0.0 -26.562132
                                17.89357 0.0 0.0 -26.58557 -9.411382 0.0 0.0 -37.02802 16.075819 0.0 0.0
                                -26.96608 -8.232428 0.0 0.0 -1.3895323 0.23055081 0.0 0.0 -1146.8048
                                318.32114 0.0 0.0 -1.2878798 -0.23447645 0.0 0.0 -28.28075 -0.4740035 0.0 0.0
                                -29.744587 -8.438794 0.0 0.0 -45.349247 -16.512135 0.0 0.0 -1.2812613
                                -0.31906 0.0 0.0 -1.2943171 -0.123586036 0.0 0.0 -1.3317593 -0.12161382 0.0
                                0.0 -30.876825 -13.847481 0.0 0.0 -0.88405114 0.9438341 0.0 0.0 -1.2243352
                                -0.42839122 0.0 0.0 -31.31048 -12.786778 0.0 0.0 -0.79844797 0.12258016 0.0
                                0.0 -1.278689 -0.030122409 0.0 0.0 -1.2593577 -0.40958333 0.0 0.0 -28.30608
                                0.78448313 0.0 0.0 -30.655912 9.929454 0.0 0.0 -894.63293 -177.32336 0.0 0.0
                                -1.3170737 -0.120640546 0.0 0.0 -23.921267 21.112984 0.0 0.0 -0.9865875
                                -0.4202723 0.0 0.0 -1.2500495 0.18862681 0.0 0.0 -1.3090888 0.26965472 0.0
                                0.0 -66.42282 -8.792654 0.0 0.0 -1.2337025 -0.64024055 0.0 0.0 -1.2070733
                                0.53655297 0.0 0.0 -44.023876 4.7000756 0.0 0.0 -1.2925242 -0.31771222 0.0
                                0.0 -1.3050741 -0.23965542 0.0 0.0 -1.3100716 -0.17037137 0.0 0.0 -27.408155
                                -7.0509434 0.0 0.0 -1.3326049 0.13959752 0.0 0.0 -991.32117 136.66971 0.0 0.0
                                -1.0977759 -0.52211267 0.0 0.0 -1.2554296 0.1321636 0.0 0.0 -1.3318644
                                0.1064665 0.0 0.0 -30.754763 8.519485 0.0 0.0 -1.1182438 -0.54246104 0.0 0.0
                                -1.3249797 0.20905936 0.0 0.0 -1.0846086 -0.46505365 0.0 0.0 -1.0944482
                                0.7712825 0.0 0.0 -56.81124 12.384348 0.0 0.0 -53.04579 -3.7890038 0.0 0.0
                                -747.513 -164.0982 0.0 0.0 -30.215437 -11.284996 0.0 0.0 -30.012798 7.721579
                                0.0 0.0 -91.089165 5.818374 0.0 0.0 -1.2265426 -0.00943239 0.0 0.0 -28.068916
                                4.295384 0.0 0.0 -796.5974 261.27075 0.0 0.0 -1.0989763 0.32721958 0.0 0.0
                                -28.683767 -7.50816 0.0 0.0 -1.5025463 0.32325053 0.0 0.0 -1.0164704
                                -0.8260474 0.0 0.0 -78.54988 -28.36662 0.0 0.0 -1.607533 -0.38681367 0.0 0.0
                                -1.2879312 0.25019726 0.0 0.0 -1.4756 0.7563906 0.0 0.0 -1.3074723 0.29072425
                                0.0 0.0 -1.2822452 -0.22488095 0.0 0.0 -1.2080204 -0.40332383 0.0 0.0
                                -1.6557928 1.088713 0.0 0.0 -1.1645781 0.1332257 0.0 0.0 -32.32567 1.2280667
                                0.0 0.0 -31.793245 5.999581 0.0 0.0 -30.158411 7.345325 0.0 0.0 -29.776438
                                8.581204 0.0 0.0 -0.82192594 -1.0236757 0.0 0.0 -30.756845 4.67237 0.0 0.0
                                -839.307 57.998943 0.0 0.0 -1.3272288 -0.1597677 0.0 0.0 -1.2777554
                                0.39655545 0.0 0.0 -29.412062 -12.537069 0.0 0.0 -1.2465051 -0.20796293 0.0
                                0.0 -32.3716 -0.8076066 0.0 0.0 -1.3816329 -0.11289917 0.0 0.0 -1.2943723
                                0.3286763 0.0 0.0 -1.229394 -0.412693 0.0 0.0 -1.2272675 0.04911158 0.0 0.0
                                -1.2626246 0.30581367 0.0 0.0 -1.2807635 0.20236282 0.0 0.0 -1.2244437
                                0.072365016 0.0 0.0 -37.66562 -24.151052 0.0 0.0 -1.2639133 -0.23061042 0.0
                                0.0 -30.290665 -11.445376 0.0 0.0 -0.662047 -0.75815016 0.0 0.0 -1.3063571
                                -0.27454466 0.0 0.0 -694.5584 -609.1688 0.0 0.0 -1.3497875 0.4555875 0.0 0.0
                                -34.104847 -0.4137312 0.0 0.0 -1.0443155 -0.81370807 0.0 0.0 -42.268192
                                14.492393 0.0 0.0 -35.25378 -12.291569 0.0 0.0 -30.900503 -4.1892977 0.0 0.0
                                -28.424213 -1.4926324 0.0 0.0 -28.025187 5.2002177 0.0 0.0 -27.059341
                                -15.195524 0.0 0.0 -1.3801805 -0.2349715 0.0 0.0 -949.7633 353.4714 0.0 0.0
                                -24.953747 -18.70964 0.0 0.0 -924.0157 -61.394615 0.0 0.0 -1.331707
                                0.15473369 0.0 0.0 -1.2789161 -0.36519077 0.0 0.0 -1.2297237 -0.4458332 0.0
                                0.0 -841.01404 96.22674 0.0 0.0 -31.65086 -7.2223783 0.0 0.0 -40.860306
                                0.11495831 0.0 0.0 -45.850792 -36.710667 0.0 0.0 -1.328457 -0.14936209 0.0
                                0.0 -1.2929581 -0.35183844 0.0 0.0 -29.894915 -1.922773 0.0 0.0 -1.2996379
                                -0.3185539 0.0 0.0 -29.359081 -13.273049 0.0 0.0 -1.145389 -0.24577875 0.0
                                0.0 -1.2562684 0.21599358 0.0 0.0 -1.1827017 0.5911891 0.0 0.0 -1.3184147
                                -0.07505193 0.0 0.0 -1.3002214 -0.29068622 0.0 0.0 -1.079812 -0.25749955 0.0
                                0.0 -1.2687745 -0.27182803 0.0 0.0 -1.5381494 0.10254822 0.0 0.0 -779.04016
                                -337.5607 0.0 0.0 -41.174015 -4.220812 0.0 0.0 -0.79069823 -1.0461636 0.0 0.0
                                -1.3004373 0.2232031 0.0 0.0 -1.2791775 0.33815685 0.0 0.0 -1.3271236
                                0.10966388 0.0 0.0 -714.192 -445.12964 0.0 0.0 -771.07135 90.269226 0.0 0.0
                                -1.4781207 -0.030264288 0.0 0.0 -77.077156 -4.432928 0.0 0.0 -774.67993
                                56.365173 0.0 0.0 -1.3233594 0.0031151252 0.0 0.0 -43.258698 10.8400545 0.0
                                0.0 -1.0884879 0.76556665 0.0 0.0 -40.112476 8.630498 0.0 0.0 -0.9257125
                                -0.36895072 0.0 0.0 -617.9029 585.747 0.0 0.0 -37.138172 -5.3401895 0.0 0.0
                                -1.261198 0.41778475 0.0 0.0 -850.7746 42.987835 0.0 0.0 -1.0554327
                                -0.57358885 0.0 0.0 -1.2728492 -0.18247184 0.0 0.0 -1.2932285 -0.14174485 0.0
                                0.0 -1.4622451 0.4718521 0.0 0.0 -34.138004 0.9283562 0.0 0.0 -31.170702
                                -3.1650875 0.0 0.0 -852.15125 -35.827763 0.0 0.0 -1.298025 0.3240676 0.0 0.0
                                -31.616104 7.2800813 0.0 0.0 -0.93044245 -0.8480898 0.0 0.0 -29.484715
                                -7.3293157 0.0 0.0 -1.0633214 -0.33557191 0.0 0.0 -31.260675 -1.3024594 0.0
                                0.0 -1215.0989 -833.65045 0.0 0.0 -1.2499897 0.05045775 0.0 0.0 -1.2604804
                                0.18978912 0.0 0.0 -789.2369 -327.26007 0.0 0.0 -32.120567 2.478442 0.0 0.0
                                -1.06975 0.22696604 0.0 0.0 -27.905434 -6.5409226 0.0 0.0 -37.41416 3.8714426
                                0.0 0.0 -1434.8179 346.983 0.0 0.0 -31.635937 1.8545284 0.0 0.0 -762.78516
                                -167.8294 0.0 0.0 -1.2202445 0.30758083 0.0 0.0 -1.2669327 -0.08501273 0.0
                                0.0 -2.6360328 0.34187523 0.0 0.0 -1.3176795 0.11905392 0.0 0.0 -1.3238593
                                -0.19148052 0.0 0.0 -1.2576333 0.435415 0.0 0.0 -1.2652711 -0.22690961 0.0
                                0.0 -34.170135 -15.76974 0.0 0.0 -28.622387 -1.2264427 0.0 0.0 -29.261309
                                10.757355 0.0 0.0 -1.311534 -0.0064067724 0.0 0.0 -37.446186 5.5235577 0.0
                                0.0 -1.2930343 -0.35327005 0.0 0.0 -851.66644 100.16238 0.0 0.0 -38.379307
                                -15.151271 0.0 0.0 -815.0296 -267.59753 0.0 0.0 -32.132263 -5.8965516 0.0 0.0
                                -1.32365 -0.02166293 0.0 0.0 -1.3271555 0.15026844 0.0 0.0 -1.3113824
                                0.26937205 0.0 0.0 -822.69946 245.62628 0.0 0.0 -1.246163 0.36493304 0.0 0.0
                                -1.2102054 0.56602234 0.0 0.0 -1.3076013 0.26419404 0.0 0.0 -49.001217
                                7.3473682 0.0 0.0 -1236.3734 56.00396 0.0 0.0 -1.1407788 0.42865643 0.0 0.0
                                -1.060614 -0.61858517 0.0 0.0 -1.3373424 0.10349908 0.0 0.0 -1.3088009
                                0.11040804 0.0 0.0 -1.2622439 -0.3430517 0.0 0.0 -31.814396 7.1537986 0.0 0.0
                                -32.650173 -10.299067 0.0 0.0 -32.46182 4.097321 0.0 0.0 -2.4311 -0.37715885
                                0.0 0.0 -28.681425 1.8189092 0.0 0.0 -27.984428 -6.6341786 0.0 0.0 -850.8767
                                132.50156 0.0 0.0 -34.016796 5.729524 0.0 0.0 -0.97069585 -0.9241796 0.0 0.0
                                -1.239224 0.1490314 0.0 0.0 -30.347229 -12.267509 0.0 0.0 -1.1954051
                                0.4607292 0.0 0.0 -1.4329765 0.13354146 0.0 0.0 -767.27545 -174.71445 0.0 0.0
                                -1.3700205 -0.8889986 0.0 0.0 -1.33753 -0.061150867 0.0 0.0 -28.535091
                                9.992638 0.0 0.0 -728.6805 -298.47397 0.0 0.0 -945.2114 23.559193 0.0 0.0
                                -1.3355047 0.0950364 0.0 0.0 -1.2938291 0.16221625 0.0 0.0 -1.3242193
                                -0.0913434 0.0 0.0 -37.28017 -4.8891397 0.0 0.0 -37.84329 0.29245737 0.0 0.0
                                -1.3148324 -0.14398932 0.0 0.0 -1.3333259 0.02794813 0.0 0.0 -1.1209319
                                -0.61169666 0.0 0.0 -1.2969172 -0.09161331 0.0 0.0 -1.260905 -0.2693023 0.0
                                0.0 -1.334897 0.099963404 0.0 0.0 -31.215334 -9.254194 0.0 0.0 -32.001568
                                7.1863394 0.0 0.0 -1.2996242 0.29912314 0.0 0.0 -40.959972 -6.664731 0.0 0.0
                                -1.1996036 -0.28215742 0.0 0.0 -726.77795 -309.16074 0.0 0.0 -833.30994
                                234.35641 0.0 0.0 -1.1051186 -0.723626 0.0 0.0 -658.4284 280.9843 0.0 0.0
                                -0.7134993 -1.073227 0.0 0.0 -1.3068435 0.050241135 0.0 0.0 -1.3265314
                                0.18850634 0.0 0.0 -1.3065422 0.029748337 0.0 0.0 -1.2929627 -0.31442857 0.0
                                0.0 -1.3234409 -0.0021001063 0.0 0.0 -1.3582532 0.1584666 0.0 0.0 -1.3018135
                                -0.14033608 0.0 0.0 -1.3045 -0.23471709 0.0 0.0 -31.322075 -22.56791 0.0 0.0
                                -1.269607 0.07219354 0.0 0.0 -63.345097 16.667252 0.0 0.0 -2.2684386
                                -1.1724373 0.0 0.0 -1196.5048 672.54865 0.0 0.0 -1.2067057 -0.5439152 0.0 0.0
                                -48.002377 -13.019697 0.0 0.0 -1.2131821 -0.5415118 0.0 0.0 -1.1211925
                                -0.5095916 0.0 0.0 -1.2385404 0.110351965 0.0 0.0 -1.3368495 -0.10181497 0.0
                                0.0 -31.280659 4.054699 0.0 0.0 -29.583998 -14.349425 0.0 0.0 -1.3401945
                                -0.03882049 0.0 0.0 -28.643799 15.828469 0.0 0.0 -1.3046745 0.15065104 0.0
                                0.0 -35.50536 -13.542747 0.0 0.0 -1.0755594 0.7748509 0.0 0.0 -28.529783
                                -13.578176 0.0 0.0 -1.3391603 0.030862466 0.0 0.0 -794.0729 -10.3106985 0.0
                                0.0 -32.71506 2.9584055 0.0 0.0 -1.2498432 -0.24813278 0.0 0.0 -1.2509605
                                0.28775403 0.0 0.0 -947.3286 -119.21466 0.0 0.0 -1366.6409 -181.70192 0.0 0.0
                                -1.2246808 -0.0674777 0.0 0.0 -0.99743193 0.3550315 0.0 0.0 -54.36319
                                7.512074 0.0 0.0 -27.921587 14.85086 0.0 0.0 -1.2473426 -0.46380207 0.0 0.0
                                -1.3396195 -0.03304855 0.0 0.0 -30.508106 -11.969241 0.0 0.0 -1.3003186
                                -0.073197745 0.0 0.0 -5.689472 0.75080097 0.0 0.0 -32.396965 -4.597715 0.0
                                0.0 -29.693708 -7.987001 0.0 0.0 -1.2247057 -0.42804682 0.0 0.0 -1.2952676
                                -0.2438746 0.0 0.0 -1.247709 -0.33801168 0.0 0.0 -1.2692971 0.20123783 0.0
                                0.0 -30.394499 7.926434 0.0 0.0 -1.2985066 -0.12549406 0.0 0.0 -28.927174
                                1.4867991 0.0 0.0 -34.667843 1.370076 0.0 0.0 -34.60005 3.1937082 0.0 0.0
                                -1.207629 -0.58428085 0.0 0.0 -1.1792213 -0.342599 0.0 0.0 -1.2926205
                                0.07016989 0.0 0.0 -1.2195082 0.3163175 0.0 0.0 -1.3152418 -0.2622879 0.0 0.0
                                -32.831165 3.197857 0.0 0.0 -26.272911 -11.640859 0.0 0.0 -30.491838
                                -12.59679 0.0 0.0 -1.3146741 0.1497935 0.0 0.0 -1.3291441 -0.10590061 0.0 0.0
                                -790.793 113.42622 0.0 0.0 -1.157822 -0.102275565 0.0 0.0 -1.2437636
                                0.45125362 0.0 0.0 -1.2961403 0.23894733 0.0 0.0 -28.360226 -6.0477824 0.0
                                0.0 -1.1854626 0.05124259 0.0 0.0 -29.008465 0.3286483 0.0 0.0 -1.1779991
                                0.0031996516 0.0 0.0 -28.369917 -6.0844254 0.0 0.0 -31.295633 -10.532494 0.0
                                0.0 -25.840109 -18.516144 0.0 0.0 -22.3438 13.934862 0.0 0.0 -30.753572
                                -8.134707 0.0 0.0 -1.239803 0.49891233 0.0 0.0 -34.821293 1.2750181 0.0 0.0
                                -1.3255429 0.034994118 0.0 0.0 -1.1065518 -0.7581347 0.0 0.0 -32.064213
                                7.5733285 0.0 0.0 -32.884407 0.48163018 0.0 0.0 -1.2811214 -0.30428734 0.0
                                0.0 -28.831408 -3.4917583 0.0 0.0 -33.395008 12.444501 0.0 0.0 -33.186363
                                -10.803361 0.0 0.0 -1724.9111 637.0103 0.0 0.0 -34.863415 -1.1627249 0.0 0.0
                                -1.2476419 0.21550626 0.0 0.0 -1050.7218 -124.395874 0.0 0.0 -54.581406
                                -7.7581177 0.0 0.0 -1.141592 -0.6086128 0.0 0.0 -36.04152 12.751097 0.0 0.0
                                -1.3201776 -0.1857985 0.0 0.0 -45.075695 9.286934 0.0 0.0 -1.2992705
                                -0.0870933 0.0 0.0 -1.0443285 -0.22976722 0.0 0.0 -1.8150189 0.542003 0.0 0.0
                                -29.039543 1.4573097 0.0 0.0 -1.2185287 -0.53910047 0.0 0.0 -1.3082827
                                -0.069582924 0.0 0.0 -30.104351 -10.374516 0.0 0.0 -30.238682 10.115934 0.0
                                0.0 -1.0414503 -0.51067656 0.0 0.0 -28.41421 -6.124445 0.0 0.0 -31.95844
                                -8.675735 0.0 0.0 -1.1842468 0.4355713 0.0 0.0 -30.869867 -7.8472276 0.0 0.0
                                -1.3121762 0.06074631 0.0 0.0 -28.690544 -4.42911 0.0 0.0 -1.337328
                                0.08036173 0.0 0.0 -1.3307083 -0.019885926 0.0 0.0 -814.88495 505.74423 0.0
                                0.0 -1.3390677 -0.031238178 0.0 0.0 -1.2906473 -0.30253607 0.0 0.0
                                -0.99058974 0.833214 0.0 0.0 -30.229933 -10.216849 0.0 0.0 -732.1383
                                -337.1366 0.0 0.0 -31.710413 -3.741239 0.0 0.0 -1.260442 -0.4550839 0.0 0.0
                                -30.613955 -8.568166 0.0 0.0 -28.92566 3.437465 0.0 0.0 -1.1601691
                                -0.54438275 0.0 0.0 -850.5058 -800.53143 0.0 0.0 -32.3311 0.25632703 0.0 0.0
                                -1.2025486 -0.5480798 0.0 0.0 -1.3402209 0.03720255 0.0 0.0 -1.309671
                                0.033564243 0.0 0.0 -29.360243 -2.3892868 0.0 0.0 -29.090487 -1.8133619 0.0
                                0.0 -95.00371 -18.033659 0.0 0.0 -22.818745 -26.50512 0.0 0.0 -1.3142914
                                0.25931168 0.0 0.0 -1.3383313 -0.03880893 0.0 0.0 -1.3090173 -0.017678995 0.0
                                0.0 -1.255823 0.22024806 0.0 0.0 -701.5353 -402.0046 0.0 0.0 -1.3395622
                                -0.0434123 0.0 0.0 -1.2203659 0.19279785 0.0 0.0 -1.2806298 0.32829735 0.0
                                0.0 -28.721025 -5.1545534 0.0 0.0 -28.943132 -3.1868556 0.0 0.0 -1.1759528
                                -0.4093315 0.0 0.0 -1.047627 0.7560352 0.0 0.0 -42.885113 -17.435545 0.0 0.0
                                -1.3350477 0.06390017 0.0 0.0 -1.2498069 -0.42755032 0.0 0.0 -930.2026
                                291.96313 0.0 0.0 -1.3413633 -0.008790675 0.0 0.0 -861.59564 -218.89868 0.0
                                0.0 -29.867224 6.57737 0.0 0.0 -0.6855231 -0.25117838 0.0 0.0 -836.90497
                                301.11142 0.0 0.0 -26.280495 -9.669091 0.0 0.0 -1.3199847 0.043953642 0.0 0.0
                                -34.389507 -21.055643 0.0 0.0 -1.2930428 0.06017779 0.0 0.0 -1.2276541
                                -0.31722438 0.0 0.0 -1.2339268 -0.21617408 0.0 0.0 -1.2827559 -0.019294456
                                0.0 0.0 -1154.5414 577.17194 0.0 0.0 -1.2376819 0.37333283 0.0 0.0 -28.700802
                                5.5431924 0.0 0.0 -27.905094 8.628512 0.0 0.0 -887.1012 85.982605 0.0 0.0
                                -1.3339466 0.12777811 0.0 0.0 -32.889065 4.7498593 0.0 0.0 -28.556337
                                -6.145997 0.0 0.0 -1.8086252 -0.014073825 0.0 0.0 -32.05725 0.8823765 0.0 0.0
                                -1.3228277 -0.06167459 0.0 0.0 -1.1815059 -0.5780419 0.0 0.0 -1.3287797
                                0.1088106 0.0 0.0 -1.3094279 0.29155934 0.0 0.0 -1.30733 0.20768967 0.0 0.0
                                -764.2018 -461.8842 0.0 0.0 -1.0913891 -0.371938 0.0 0.0 -1.2195342 0.2833593
                                0.0 0.0 -1.2315043 -0.517542 0.0 0.0 -41.555637 -8.300626 0.0 0.0 -1.0071993
                                -0.7944983 0.0 0.0 -1.2870914 0.3627523 0.0 0.0 -1.2948897 -0.0931928 0.0 0.0
                                -807.81165 106.55749 0.0 0.0 -32.339718 3.9899604 0.0 0.0 -890.6111 -82.99735
                                0.0 0.0 -1.1865138 0.14484638 0.0 0.0 -1.1769146 0.29764706 0.0 0.0
                                -1.0847334 -0.55355877 0.0 0.0 -1.1444358 -0.5737946 0.0 0.0 -795.6854
                                179.78076 0.0 0.0 -1.3224595 -0.21070153 0.0 0.0 -1.2487133 -0.4403125 0.0
                                0.0 -1.2283446 0.24463165 0.0 0.0 -1.2058216 -0.58279604 0.0 0.0 -1.1797454
                                -0.5304591 0.0 0.0 -1.3155383 0.1340712 0.0 0.0 -0.98772144 0.39600563 0.0
                                0.0 -1.1628388 -0.45423678 0.0 0.0 -1.0723171 -0.7863919 0.0 0.0 -33.11632
                                0.26633847 0.0 0.0 -1.3006672 0.21142058 0.0 0.0 -1.1083384 -0.14804833 0.0
                                0.0 -1.237484 -0.31248796 0.0 0.0 -1091.4696 -465.26465 0.0 0.0 -41.53577
                                -8.882092 0.0 0.0 -848.8262 -292.12708 0.0 0.0 -893.215 -91.03075 0.0 0.0
                                -1.2395136 0.467836 0.0 0.0 -1.2905215 -0.11820662 0.0 0.0 -1.313467
                                -0.25434577 0.0 0.0 -1.1617991 0.6117906 0.0 0.0 -748.5341 331.5644 0.0 0.0
                                -47.177143 19.929235 0.0 0.0 -27.89164 -9.013178 0.0 0.0 -23.23434 17.845673
                                0.0 0.0 -1.3286573 0.03155934 0.0 0.0 -1.2276175 -0.07491592 0.0 0.0
                                -1.1132116 0.6949489 0.0 0.0 -1.2147491 -0.32377318 0.0 0.0 -24.26384
                                -9.818946 0.0 0.0 -32.202827 0.44402742 0.0 0.0 -1.0961962 -0.17082843 0.0
                                0.0 -1.096269 -0.69081783 0.0 0.0 -0.9612243 0.23734245 0.0 0.0 -1.3390043
                                0.04445521 0.0 0.0 -1.2371217 -0.48489 0.0 0.0 -1.2727839 0.36506873 0.0 0.0
                                -1.3379939 -0.04793453 0.0 0.0 -1.2262932 -0.5409883 0.0 0.0 -1.2032478
                                -0.408672 0.0 0.0 -38.11699 -10.125795 0.0 0.0 -1.2587279 0.17967944 0.0 0.0
                                -33.301693 3.0921617 0.0 0.0 -1.2273357 0.47995397 0.0 0.0 -0.6878337
                                -0.98553413 0.0 0.0 -1557.0089 -266.3972 0.0 0.0 -1.2837969 0.17011937 0.0
                                0.0 -31.893953 -10.153073 0.0 0.0 -1.3184836 -0.17084965 0.0 0.0 -29.39225
                                1.0468369 0.0 0.0 -1.3295627 -0.059310425 0.0 0.0 -46.171894 -7.866086 0.0
                                0.0 -31.159555 -11.225791 0.0 0.0 -32.51623 6.692967 0.0 0.0 -31.745905
                                -5.81704 0.0 0.0 -1.2000996 0.26664856 0.0 0.0 -29.141607 -4.1405234 0.0 0.0
                                -1.3049915 0.18292738 0.0 0.0 -1.4438155 -0.7967499 0.0 0.0 -1.0711917
                                -0.44660497 0.0 0.0 -28.592506 -6.9034534 0.0 0.0 -1.0586549 -0.77155346 0.0
                                0.0 -1.2772532 -0.35674614 0.0 0.0 -1.3572803 0.40814167 0.0 0.0 -1.2651708
                                -0.27102107 0.0 0.0 -32.30239 0.124987066 0.0 0.0 -42.829918 3.0423973 0.0
                                0.0 -33.045918 5.665213 0.0 0.0 -30.249868 -14.469933 0.0 0.0 -33.44521
                                2.378376 0.0 0.0 -38.38171 6.6611676 0.0 0.0 -28.624725 6.452976 0.0 0.0
                                -1.2197781 -0.29920167 0.0 0.0 -1.6669366 -0.88080066 0.0 0.0 -1.2892027
                                -0.0712367 0.0 0.0 -1.8363464 -0.9185567 0.0 0.0 -882.8125 -208.37717 0.0 0.0
                                -1.2896041 0.021249479 0.0 0.0 -30.031113 -6.578693 0.0 0.0 -1.0071226
                                -0.85529417 0.0 0.0 -1.1452366 0.60146785 0.0 0.0 -42.721394 2.122597 0.0 0.0
                                -1.3022994 -0.31722322 0.0 0.0 -26.16329 5.323037 0.0 0.0 -28.985476
                                -5.490672 0.0 0.0 -30.873411 -15.178691 0.0 0.0 -902.5911 -104.45142 0.0 0.0
                                -1.2628834 -0.40334004 0.0 0.0 -47.041508 0.36382285 0.0 0.0 -1445.3098
                                -140.15184 0.0 0.0 -1.2171568 0.55586594 0.0 0.0 -1.3227979 -0.053857572 0.0
                                0.0 -1.2433149 0.43714687 0.0 0.0 -59.091637 -34.413853 0.0 0.0 -1.2157301
                                0.29806638 0.0 0.0 -1204.9115 34.96117 0.0 0.0 -28.969898 5.7240386 0.0 0.0
                                -31.432106 10.044778 0.0 0.0 -28.89694 -5.8551087 0.0 0.0 -1.2854444
                                0.30697373 0.0 0.0 -1.2798591 -0.34739247 0.0 0.0 -678.0513 -477.66647 0.0
                                0.0 -28.830227 -13.759396 0.0 0.0 -0.79323 0.29461244 0.0 0.0 -1.2956964
                                -0.028587947 0.0 0.0 -28.187521 8.148753 0.0 0.0 -1.2915031 0.21801552 0.0
                                0.0 -1.3407685 -0.043667328 0.0 0.0 -42.698387 4.4868073 0.0 0.0 -1.2363338
                                0.36120483 0.0 0.0 -33.817707 20.769289 0.0 0.0 -739.5273 -378.48734 0.0 0.0
                                -589.58374 557.2456 0.0 0.0 -1327.6254 -51.15786 0.0 0.0 -32.33704 2.4409106
                                0.0 0.0 -1.2143868 -0.4981384 0.0 0.0 -1.1619506 -0.5923236 0.0 0.0
                                -1.3381118 -0.03811466 0.0 0.0 -1.1570864 0.07830958 0.0 0.0 -1.3404707
                                -0.032203317 0.0 0.0 -32.33781 -9.39911 0.0 0.0 -1.0642762 -0.77697474 0.0
                                0.0 -28.663988 17.540897 0.0 0.0 -1.3059843 0.0630481 0.0 0.0 -31.223175
                                12.573883 0.0 0.0 -1.2844746 -0.10689456 0.0 0.0 -1.1831045 -0.58943146 0.0
                                0.0 -1.318876 0.23045766 0.0 0.0 -33.57977 -2.389931 0.0 0.0 -911.2935
                                -85.19607 0.0 0.0 -1.1967297 -0.4801568 0.0 0.0 -0.9704986 -0.8884846 0.0 0.0
                                -1.1442512 0.032727454 0.0 0.0 -1.2040586 -0.5162548 0.0 0.0 -0.84140706
                                -0.6234085 0.0 0.0 -30.809929 -11.428418 0.0 0.0 -31.211008 12.3081 0.0 0.0
                                -1.2843698 -0.2838479 0.0 0.0 -0.4057939 -0.37370652 0.0 0.0 -35.42911
                                4.6121306 0.0 0.0 -29.16827 -5.231473 0.0 0.0 -1.2766795 -0.31349903 0.0 0.0
                                -33.657547 -2.0767632 0.0 0.0 -1.1239548 -0.6541004 0.0 0.0 -18.781317
                                -22.873276 0.0 0.0 -1.3296056 -0.1764719 0.0 0.0 -1.2605516 -0.20633976 0.0
                                0.0 -1.2987838 -0.120535895 0.0 0.0 -47.19671 1.5587541 0.0 0.0 -1.3402135
                                -0.03323685 0.0 0.0 -1.200801 -0.44067594 0.0 0.0 -1.2176405 0.2988674 0.0
                                0.0 -1.3282447 0.09103368 0.0 0.0 -23.800047 -31.136248 0.0 0.0 -1017.7066
                                442.13824 0.0 0.0 -1.2895497 -0.2622664 0.0 0.0 -1.2500395 -0.47119075 0.0
                                0.0 -47.97602 -30.093597 0.0 0.0 -28.011656 -9.755663 0.0 0.0 -38.158215
                                -9.483912 0.0 0.0 -33.269547 -4.529247 0.0 0.0 -29.73077 15.502101 0.0 0.0
                                -812.0588 205.41231 0.0 0.0 -1.7140269 -0.966667 0.0 0.0 -1.3365809
                                -0.08383949 0.0 0.0 -1.2666417 0.017311312 0.0 0.0 -47.95984 20.377144 0.0
                                0.0 -57.18877 3.609816 0.0 0.0 -1.0788046 -0.2226093 0.0 0.0 -1.2014804
                                -0.39889118 0.0 0.0 -1.2250832 0.37219223 0.0 0.0 -1.283199 -0.29553467 0.0
                                0.0 -57.25959 -3.159009 0.0 0.0 -1.2012788 0.52468395 0.0 0.0 -1.3190424
                                -0.19586822 0.0 0.0 -1.2415898 -0.2579455 0.0 0.0 -1.312909 0.18097611 0.0
                                0.0 -0.86089665 0.9594785 0.0 0.0 -31.384235 12.6426935 0.0 0.0 -766.2342
                                -514.66486 0.0 0.0 -1.2455876 0.40030736 0.0 0.0 -30.710667 -1.5395883 0.0
                                0.0 -0.9235315 0.9668022 0.0 0.0 -26.664696 1.4592649 0.0 0.0 -1.2644329
                                -0.43340465 0.0 0.0 -1.553545 -0.0807333 0.0 0.0 -27.860441 -17.02976 0.0 0.0
                                -1.2911718 -0.1550597 0.0 0.0 -31.777168 9.961804 0.0 0.0 -1.3220809
                                0.21586913 0.0 0.0 -1.2486733 -0.33543745 0.0 0.0 -1.3054186 -0.6076252 0.0
                                0.0 -51.10099 -23.794584 0.0 0.0 -27.523636 19.524744 0.0 0.0 -29.626917
                                2.8438299 0.0 0.0 -1.2532861 0.24204564 0.0 0.0 -1.2830627 -0.0666956 0.0 0.0
                                -35.265213 -17.734251 0.0 0.0 -53.56243 -20.880854 0.0 0.0 -28.349623
                                9.042215 0.0 0.0 -1.2787077 0.28655985 0.0 0.0 -51.7964 0.11048432 0.0 0.0
                                -1.1215383 0.7171237 0.0 0.0 -1434.6564 -782.34436 0.0 0.0 -33.56308
                                -27.50518 0.0 0.0 -22.60347 -15.261263 0.0 0.0 -1.2522008 -0.3837927 0.0 0.0
                                -1.2370381 0.42428222 0.0 0.0 -31.82746 7.6092777 0.0 0.0 -1.2408159 0.460906
                                0.0 0.0 -0.65571135 -1.1685798 0.0 0.0 -29.367218 -3.3835032 0.0 0.0
                                -838.0039 -103.80981 0.0 0.0 -1.2123643 -0.40170226 0.0 0.0 -1.1762285
                                0.015373677 0.0 0.0 -1.3557239 0.36049482 0.0 0.0 -1.1899716 0.45318753 0.0
                                0.0 -1.2709777 0.2615052 0.0 0.0 -1.2587357 -0.29286402 0.0 0.0 -1011.03107
                                146.02571 0.0 0.0 -1.2852018 -0.29592425 0.0 0.0 -1.1123276 -0.6583531 0.0
                                0.0 -1.2879908 -0.33506474 0.0 0.0 -1.3336823 0.12989809 0.0 0.0 -1.2794869
                                0.087803364 0.0 0.0 -1.2913238 -0.13177532 0.0 0.0 -1.1725672 -0.6441278 0.0
                                0.0 -0.7785827 -1.0897895 0.0 0.0 -1.2414173 0.42754015 0.0 0.0 -44.000645
                                -18.672262 0.0 0.0 -33.6907 -12.611774 0.0 0.0 -39.668438 -5.9625287 0.0 0.0
                                -1.1816155 0.5078121 0.0 0.0 -31.857681 8.435154 0.0 0.0 -1.2235385 0.4025503
                                0.0 0.0 -0.7924789 -0.8754561 0.0 0.0 -36.362152 -16.388851 0.0 0.0
                                -33.844257 -1.3466494 0.0 0.0 -33.925407 -1.9890162 0.0 0.0 -31.519695
                                -12.7398405 0.0 0.0 -991.03314 -74.256424 0.0 0.0 -63.571823 1.0414652 0.0
                                0.0 -1.2839175 0.3135059 0.0 0.0 -0.97889847 -0.8913582 0.0 0.0 -925.1388
                                -122.30094 0.0 0.0 -1.3041825 0.24578927 0.0 0.0 -51.511467 -10.998889 0.0
                                0.0 -30.582172 -14.553624 0.0 0.0 -1.3086001 -0.04972689 0.0 0.0 -31.339676
                                13.16829 0.0 0.0 -112.4288 0.75202817 0.0 0.0 -1.2357934 -0.18117858 0.0 0.0
                                -1.2269691 -0.43627292 0.0 0.0 -847.0744 -70.27087 0.0 0.0 -57.474705
                                6.6005087 0.0 0.0 -1.1924324 -0.42592493 0.0 0.0 -1.1764144 0.15894718 0.0
                                0.0 -1.2061725 0.18963784 0.0 0.0 -1.2269665 0.17729159 0.0 0.0 -1.5016617
                                -0.4158595 0.0 0.0 -1.2656673 0.3637841 0.0 0.0 -56.70524 7.564241 0.0 0.0
                                -1345.988 247.36598 0.0 0.0 -1.146252 0.32132477 0.0 0.0 -1.1235001
                                -0.7155532 0.0 0.0 -1.2707269 -0.25659922 0.0 0.0 -1.2932235 0.35257015 0.0
                                0.0 -1.2325861 0.24780375 0.0 0.0 -1.2678494 -0.13061331 0.0 0.0 -63.85977
                                0.058371853 0.0 0.0 -41.159554 -14.946363 0.0 0.0 -1.1984756 0.50036734 0.0
                                0.0 -1.3260282 -0.15615468 0.0 0.0 -33.223957 3.9038572 0.0 0.0 -1.2802109
                                0.06938843 0.0 0.0 -33.35466 -2.3715641 0.0 0.0 -1.3126918 0.16743408 0.0 0.0
                                -1.2090741 0.23523453 0.0 0.0 -29.314478 -6.2022862 0.0 0.0 -29.893927
                                -16.290604 0.0 0.0 -1.3056172 -0.1745789 0.0 0.0 -1.253081 0.33356866 0.0 0.0
                                -33.991863 1.3962442 0.0 0.0 -28.861519 -7.798409 0.0 0.0 -28.94133 15.758146
                                0.0 0.0 -935.5484 -87.40393 0.0 0.0 -1.2060634 -0.4660137 0.0 0.0 -1.2034774
                                -0.55410904 0.0 0.0 -775.3075 -249.70822 0.0 0.0 -27.319487 -12.363611 0.0
                                0.0 -1.2080929 0.097457044 0.0 0.0 -918.99915 474.99 0.0 0.0 -1.4094406
                                0.30636504 0.0 0.0 -1.2578676 0.26611367 0.0 0.0 -1.3347701 0.041900624 0.0
                                0.0 -824.2462 -785.5525 0.0 0.0 -37.326256 11.44401 0.0 0.0 -1.3285899
                                0.08138354 0.0 0.0 -1.1594849 0.5903571 0.0 0.0 -1.3201864 0.19937435 0.0 0.0
                                -667.5663 -536.4436 0.0 0.0 -1.1726917 -0.0013812335 0.0 0.0 -34.080315
                                -0.38886273 0.0 0.0 -1.1335678 0.29412878 0.0 0.0 -34.61384 -10.917265 0.0
                                0.0 -19.807178 16.256212 0.0 0.0 -44.012833 0.7956404 0.0 0.0 -34.779747
                                -10.153155 0.0 0.0 -1.4567055 -1.039718 0.0 0.0 -1.1001551 0.36205447 0.0 0.0
                                -1.2178272 -0.49790785 0.0 0.0 -31.07314 -10.613071 0.0 0.0 -28.539494
                                9.390597 0.0 0.0 -41.815723 13.009977 0.0 0.0 -34.970757 9.785309 0.0 0.0
                                -1.122048 -0.73445773 0.0 0.0 -1.1753433 -0.24312422 0.0 0.0 -1.2338762
                                0.478255 0.0 0.0 -32.23138 7.049501 0.0 0.0 -106.806496 -9.501309 0.0 0.0
                                -60.645157 21.40207 0.0 0.0 -36.31036 -1.8185583 0.0 0.0 -1.3088654
                                0.21537386 0.0 0.0 -34.13484 1.7578545 0.0 0.0 -1102.4583 307.93323 0.0 0.0
                                -1.3262805 0.070626564 0.0 0.0 -844.0407 -164.67749 0.0 0.0 -1.2023664
                                -0.32392806 0.0 0.0 -1382.9236 -643.5756 0.0 0.0 -1.327372 0.14438258 0.0 0.0
                                -51.979004 -5.6694384 0.0 0.0 -1.5437932 -0.11047479 0.0 0.0 -1.2342834
                                0.2516577 0.0 0.0 -1.1867744 -0.6136271 0.0 0.0 -0.9775208 -0.3908538 0.0 0.0
                                -1.2353258 -0.4581962 0.0 0.0 -35.11004 7.5584526 0.0 0.0 -1386.5376 81.32892
                                0.0 0.0 -24.807327 -17.043879 0.0 0.0 -30.56099 15.268048 0.0 0.0 -922.2799
                                -22.001036 0.0 0.0 -1.1729623 0.61392254 0.0 0.0 -1.2769665 -0.07355574 0.0
                                0.0 -1.1554127 0.5449737 0.0 0.0 -32.748386 -5.404917 0.0 0.0 -1.3277204
                                0.045200933 0.0 0.0 -30.546318 -14.613797 0.0 0.0 -1037.9536 -118.05644 0.0
                                0.0 -1.3126788 0.15259017 0.0 0.0 -31.924673 8.8884325 0.0 0.0 -41.496128
                                15.367387 0.0 0.0 -1.3104243 -0.103953086 0.0 0.0 -1.2004806 -0.58339465 0.0
                                0.0 -1.3113021 0.13368021 0.0 0.0 -0.8635425 0.10547896 0.0 0.0 -964.73364
                                -404.49585 0.0 0.0 -1016.369 -540.8808 0.0 0.0 -36.308155 3.524217 0.0 0.0
                                -1.3319197 0.098497234 0.0 0.0 -43.712826 -6.896303 0.0 0.0 -1.2325486
                                0.14792667 0.0 0.0 -1.2938619 0.3518828 0.0 0.0 -1.2639582 -0.42358148 0.0
                                0.0 -1.2482219 0.05433771 0.0 0.0 -1.2299666 -0.52649295 0.0 0.0 -30.166609
                                -0.46431345 0.0 0.0 -35.7335 16.102804 0.0 0.0 -48.552086 2.4528198 0.0 0.0
                                -1.2516675 -0.444646 0.0 0.0 -1.2256069 0.53852606 0.0 0.0 -33.159424
                                -1.5995755 0.0 0.0 -60.38293 -23.45926 0.0 0.0 -27.156555 15.059378 0.0 0.0
                                -52.136112 -11.849254 0.0 0.0 -863.6328 70.96522 0.0 0.0 -766.3803 -567.85114
                                0.0 0.0 -32.3459 -11.523781 0.0 0.0 -40.695633 17.276505 0.0 0.0 -1.1708035
                                -0.1586963 0.0 0.0 -33.37899 14.8947935 0.0 0.0 -1.3961041 0.3399141 0.0 0.0
                                -1.3263638 -0.08782465 0.0 0.0 -1.1237596 0.60170907 0.0 0.0 -1.1045511
                                -0.30744117 0.0 0.0 -1.3062156 -0.2846239 0.0 0.0 -32.926605 4.5389686 0.0
                                0.0 -34.234657 3.381599 0.0 0.0 -26.003353 -15.399107 0.0 0.0 -2.712581
                                0.20758207 0.0 0.0 -34.06139 -4.258374 0.0 0.0 -1.3005813 0.326261 0.0 0.0
                                -1.3252894 -0.06578342 0.0 0.0 -1.2005099 -0.40237248 0.0 0.0 -1.1560746
                                -0.3615537 0.0 0.0 -57.956116 11.335772 0.0 0.0 -1.1463429 0.41607344 0.0 0.0
                                -1.2927874 0.30775687 0.0 0.0 -1.2271876 -0.46093708 0.0 0.0 -1.135737
                                -0.6282371 0.0 0.0 -1.2945397 0.29840505 0.0 0.0 -57.742214 12.017334 0.0 0.0
                                -36.620083 -0.7235401 0.0 0.0 -1402.2262 -112.81253 0.0 0.0 -1405.3792
                                68.18249 0.0 0.0 -28.781437 -9.320861 0.0 0.0 -30.246578 -0.7959576 0.0 0.0
                                -0.33508894 -0.38281372 0.0 0.0 -1.11067 -0.6819697 0.0 0.0 -1.2960104
                                -0.33288485 0.0 0.0 -1.2347686 0.46611845 0.0 0.0 -1.8104696 0.0410315 0.0
                                0.0 -33.078056 4.0024242 0.0 0.0 -1.5396434 0.2522297 0.0 0.0 -1.2862998
                                0.10113158 0.0 0.0 -33.31663 -15.332938 0.0 0.0 -1.2908347 -0.36120674 0.0
                                0.0 -1.4500542 0.28319246 0.0 0.0 -39.767963 6.8865066 0.0 0.0 -1.0770997
                                -0.3220238 0.0 0.0 -1.3738152 -0.42710188 0.0 0.0 -1.2749623 -0.37530556 0.0
                                0.0 -1.3272848 0.18140684 0.0 0.0 -50.391983 -18.577797 0.0 0.0 -1.292514
                                0.1846108 0.0 0.0 -32.679752 -10.052361 0.0 0.0 -1.3328607 -0.078586176 0.0
                                0.0 -1.1728578 0.46742043 0.0 0.0 -1.3107716 -0.15766238 0.0 0.0 -45.789654
                                -17.330929 0.0 0.0 -43.890205 6.4008617 0.0 0.0 -29.000376 -15.666198 0.0 0.0
                                -1.3352032 0.048954353 0.0 0.0 -1.3246129 -0.06021782 0.0 0.0 -1.2725095
                                -0.17855291 0.0 0.0 -1.2732377 0.41430557 0.0 0.0 -784.573 -387.28107 0.0 0.0
                                -1.2410735 -0.28157276 0.0 0.0 -1.3112409 0.1307602 0.0 0.0 -30.53107
                                -13.502803 0.0 0.0 -1.3248099 0.20270802 0.0 0.0 -71.32936 9.794916 0.0 0.0
                                -40.92134 0.28440756 0.0 0.0 -1.3204204 0.23317723 0.0 0.0 -1.4637125
                                -0.5467105 0.0 0.0 -1.3032291 -0.06040901 0.0 0.0 -16.450428 25.33492 0.0 0.0
                                -32.373417 -8.193616 0.0 0.0 -29.815468 -5.756217 0.0 0.0 -1.1977417
                                -0.37190142 0.0 0.0 -1.1188667 -0.6434363 0.0 0.0 -1.0352994 -0.62289697 0.0
                                0.0 -34.54356 -1.2789525 0.0 0.0 -1.3337913 0.09855003 0.0 0.0 -1.3084267
                                -0.19971439 0.0 0.0 -1.1455824 0.2648365 0.0 0.0 -40.724514 -18.420214 0.0
                                0.0 -1.3202671 -0.045684647 0.0 0.0 -32.834896 -1.3973248 0.0 0.0 -1.5013118
                                0.19839422 0.0 0.0 -24.479044 -11.110647 0.0 0.0 -1.3044971 -0.16756299 0.0
                                0.0 -30.050524 4.281418 0.0 0.0 -1.2677313 -0.2902913 0.0 0.0 -1.218345
                                -0.05363722 0.0 0.0 -1.1849257 0.5050685 0.0 0.0 -1.2818927 -0.70887464 0.0
                                0.0 -33.456997 -1.0506873 0.0 0.0 -1.3354295 -0.001472503 0.0 0.0 -1.2625712
                                0.4295488 0.0 0.0 -1.4460167 0.049214236 0.0 0.0 -36.087414 -7.5481153 0.0
                                0.0 -1.2557192 0.050948687 0.0 0.0 -1.0788498 -0.28803533 0.0 0.0 -2.3416247
                                -0.05239025 0.0 0.0 -1.3325026 0.07359892 0.0 0.0 -1.2494282 0.46367928 0.0
                                0.0 -1.2182419 -0.47421393 0.0 0.0 -1.2789147 -0.37698805 0.0 0.0 -1.2830389
                                -0.28523245 0.0 0.0 -1.3094536 -0.12653589 0.0 0.0 -1.3145046 -0.16866933 0.0
                                0.0 -1.3267332 -0.032449022 0.0 0.0 -810.5171 -501.68903 0.0 0.0 -0.6215755
                                0.4484849 0.0 0.0 -1.1706816 -0.5275435 0.0 0.0 -1.3360859 -0.060404964 0.0
                                0.0 -1.2178603 -0.35254815 0.0 0.0 -1.1275498 -0.6928796 0.0 0.0 -36.485798
                                -5.6045246 0.0 0.0 -1.0934877 -0.7619114 0.0 0.0 -1.300188 -0.3160123 0.0 0.0
                                -1.0907975 -0.0047331154 0.0 0.0 -1.2833873 -0.33369642 0.0 0.0 -1.2141136
                                -0.50716203 0.0 0.0 -28.108877 -11.76737 0.0 0.0 -33.36664 -3.2871222 0.0 0.0
                                -882.4143 -41.751682 0.0 0.0 -1.2508676 -0.36855105 0.0 0.0 -1.2098944
                                0.50638276 0.0 0.0 -1016.1636 -602.672 0.0 0.0 -874.84216 427.61487 0.0 0.0
                                -1430.1799 107.483406 0.0 0.0 -1.3360928 -0.06972124 0.0 0.0 -1.2634858
                                0.35818624 0.0 0.0 -1.1938653 -0.16416757 0.0 0.0 -1.297799 0.06672256 0.0
                                0.0 -1.326443 -0.19771354 0.0 0.0 -922.5275 -315.1724 0.0 0.0 -47.509464
                                13.545783 0.0 0.0 -31.005468 2.830387 0.0 0.0 -1.2345939 -0.276134 0.0 0.0
                                -33.535374 -2.1755247 0.0 0.0 -817.4369 340.77518 0.0 0.0 -1.2274629
                                0.44051468 0.0 0.0 -1135.023 339.21005 0.0 0.0 -1.2679116 0.15687615 0.0 0.0
                                -1.4102156 -0.07873403 0.0 0.0 -1.1811106 -0.5950811 0.0 0.0 -1.0633998
                                -0.5475774 0.0 0.0 -1.1086192 -0.08911545 0.0 0.0 -1.2689716 -0.4129453 0.0
                                0.0 -29.634417 -15.911452 0.0 0.0 -1.3252084 0.07661712 0.0 0.0 -63.819168
                                28.671114 0.0 0.0 -0.9736567 -0.7961191 0.0 0.0 -1.327833 0.1815306 0.0 0.0
                                -72.43893 -21.326822 0.0 0.0 -715.17065 -667.2275 0.0 0.0 -607.6236 426.85458
                                0.0 0.0 -48.423756 10.445509 0.0 0.0 -1.3080658 -0.20939718 0.0 0.0 -33.01114
                                6.60372 0.0 0.0 -1.324147 -0.14839713 0.0 0.0 -1.2223079 0.4787708 0.0 0.0
                                -32.7393 -7.8341503 0.0 0.0 -101.77181 3.6087582 0.0 0.0 -33.940437 7.5619345
                                0.0 0.0 -30.47322 -2.5362601 0.0 0.0 -36.924267 3.2392242 0.0 0.0 -1.3246543
                                -0.02593703 0.0 0.0 -1.169225 -0.22575071 0.0 0.0 -1.0221491 -0.85054123 0.0
                                0.0 -1.2971332 0.34052765 0.0 0.0 -1.339748 0.0052461945 0.0 0.0 -1.330728
                                -0.0521414 0.0 0.0 -54.58447 2.827035 0.0 0.0 -1.1410838 0.18530531 0.0 0.0
                                -1.279052 -0.07297311 0.0 0.0 -31.969437 -10.608556 0.0 0.0 -1.2649492
                                -0.23886195 0.0 0.0 -1.2525641 0.4804403 0.0 0.0 -1.3256505 -0.15891409 0.0
                                0.0 -24.350315 13.915195 0.0 0.0 -1.3143157 0.028070217 0.0 0.0 -1.3102356
                                -0.28598374 0.0 0.0 -3.3669827 -1.9878864 0.0 0.0 -945.7188 267.25848 0.0 0.0
                                -1.2687256 0.34126738 0.0 0.0 -44.569244 6.859611 0.0 0.0 -1.2039102
                                -0.41151097 0.0 0.0 -3.243808 -0.73940605 0.0 0.0 -43.59027 -4.829937 0.0 0.0
                                -1.2790806 0.32286206 0.0 0.0 -1.2841307 0.35172313 0.0 0.0 -1.3249867
                                0.19110425 0.0 0.0 -30.34526 2.0606217 0.0 0.0 -30.450756 -3.495787 0.0 0.0
                                -49.117786 -7.882018 0.0 0.0 -34.260574 -5.926784 0.0 0.0 -1.1692214
                                -0.6326994 0.0 0.0 -32.898518 10.5941305 0.0 0.0 -43.730362 5.240847 0.0 0.0
                                -33.481937 6.208557 0.0 0.0 -33.0502 10.49128 0.0 0.0 -0.95136917 -0.25196308
                                0.0 0.0 -1.3175894 0.08446205 0.0 0.0 -29.923979 6.7425475 0.0 0.0 -1.0457441
                                0.526026 0.0 0.0 -32.56692 12.280769 0.0 0.0 -1.1336209 0.45451054 0.0 0.0
                                -40.86157 3.7805345 0.0 0.0 -34.384857 5.9500513 0.0 0.0 -1.3029449
                                -0.08465981 0.0 0.0 -34.671627 -3.407176 0.0 0.0 -30.034622 -10.290416 0.0
                                0.0 -1.2608645 0.39683747 0.0 0.0 -1.0899936 -0.69767684 0.0 0.0 -34.896305
                                -1.5857356 0.0 0.0 -36.65419 -6.412177 0.0 0.0 -1.3246592 -0.009731532 0.0
                                0.0 -986.98035 49.93235 0.0 0.0 -1.3070931 0.25071356 0.0 0.0 -1.2343099
                                0.42167214 0.0 0.0 -1.329495 -0.17577417 0.0 0.0 -33.832367 0.8239032 0.0 0.0
                                -44.595432 0.6827698 0.0 0.0 -29.63785 -3.6226263 0.0 0.0 -30.590105
                                13.010119 0.0 0.0 -1.2729667 -0.1428473 0.0 0.0 -40.69948 -5.592364 0.0 0.0
                                -767.76715 -465.57364 0.0 0.0 -1.3150777 -0.12134085 0.0 0.0 -1.3261725
                                -0.12587054 0.0 0.0 -33.933125 -7.311047 0.0 0.0 -1.1721066 0.5942374 0.0 0.0
                                -1076.6033 183.73479 0.0 0.0 -32.4553 9.59765 0.0 0.0 -1.1940061 0.30965066
                                0.0 0.0 -0.41209725 -1.2237004 0.0 0.0 -71.08007 19.748508 0.0 0.0 -1.326435
                                -0.13013355 0.0 0.0 -36.89142 5.843938 0.0 0.0 -1.2612625 -0.382462 0.0 0.0
                                -1.0962987 0.58776915 0.0 0.0 -24.648245 -19.974348 0.0 0.0 -1.2119353
                                -0.57215744 0.0 0.0 -1.2639172 -0.1911492 0.0 0.0 -108.8889 6.8497915 0.0 0.0
                                -34.89286 1.4399372 0.0 0.0 -1.2750671 0.20297958 0.0 0.0 -30.53502
                                -3.8200798 0.0 0.0 -35.81347 -10.69337 0.0 0.0 -1.3329988 0.0071840403 0.0
                                0.0 -28.138828 -12.373797 0.0 0.0 -1.3081341 0.20429862 0.0 0.0 -34.37482
                                -5.4007015 0.0 0.0 -31.90361 -11.840428 0.0 0.0 -0.906627 0.061652243 0.0 0.0
                                -1.2804497 -0.3496549 0.0 0.0 -34.07374 -6.338271 0.0 0.0 -1.2116791
                                -0.571246 0.0 0.0 -1.2063808 0.08481893 0.0 0.0 -1619.4673 -93.12519 0.0 0.0
                                -37.27791 -3.166314 0.0 0.0 -32.942055 8.248196 0.0 0.0 -1.3033249 0.2865999
                                0.0 0.0 -1.291013 -0.2668919 0.0 0.0 -0.8267665 -1.0412102 0.0 0.0 -1.3208224
                                0.23424308 0.0 0.0 -1.2766658 -0.40627208 0.0 0.0 -75.01123 -18.873392 0.0
                                0.0 -99.346695 -1.7790922 0.0 0.0 -800.1512 -420.22974 0.0 0.0 -814.3363
                                -392.35858 0.0 0.0 -2.5318255 -1.1376858 0.0 0.0 -1.1004931 0.7072953 0.0 0.0
                                -1.3086272 0.29479572 0.0 0.0 -1.7893481 0.42434677 0.0 0.0 -30.99236
                                15.825222 0.0 0.0 -1.252992 0.33090848 0.0 0.0 -0.676298 0.58388746 0.0 0.0
                                -1.2289244 -0.51673 0.0 0.0 -34.94541 -1.4288344 0.0 0.0 -60.15152 -10.633899
                                0.0 0.0 -1.314619 0.11304057 0.0 0.0 -33.445568 8.826056 0.0 0.0 -1.2153741
                                -0.4623136 0.0 0.0 -30.790688 0.7772229 0.0 0.0 -1.1835809 0.33132538 0.0 0.0
                                -0.8896098 -1.0037189 0.0 0.0 -39.388187 12.615869 0.0 0.0 -1.1747913
                                0.42152625 0.0 0.0 -1.3075932 0.2790395 0.0 0.0 -32.623123 -9.693614 0.0 0.0
                                -1.3277115 -0.06543313 0.0 0.0 -1.1654134 -0.49875635 0.0 0.0 -1.2881023
                                0.37173206 0.0 0.0 -30.741955 -16.715902 0.0 0.0 -1.2511884 0.3966214 0.0 0.0
                                -1.0897651 -0.5835227 0.0 0.0 -32.48583 -13.108658 0.0 0.0 -30.898098
                                -0.22556086 0.0 0.0 -41.081608 -7.845357 0.0 0.0 -33.20735 9.942227 0.0 0.0
                                -1.4027122 -0.058221318 0.0 0.0 -1.0743153 0.06170298 0.0 0.0 -30.860691
                                1.7688054 0.0 0.0 -35.09807 2.6196997 0.0 0.0 -1.3382306 0.0099589415 0.0 0.0
                                -62.751625 24.790262 0.0 0.0 -33.243183 -40.67853 0.0 0.0 -1.2148958
                                -0.47972423 0.0 0.0 -121.09369 12.262972 0.0 0.0 -1.3302728 -0.16881667 0.0
                                0.0 -34.75937 -4.0562143 0.0 0.0 -43.746662 -13.066313 0.0 0.0 -1.3193436
                                0.24117379 0.0 0.0 -1002.3401 57.443127 0.0 0.0 -34.89618 -4.608233 0.0 0.0
                                -1.2863266 -0.02646179 0.0 0.0 -30.94506 -0.010665493 0.0 0.0 -1.2458199
                                -0.28173763 0.0 0.0 -36.9587 7.052619 0.0 0.0 -34.30637 -7.483198 0.0 0.0
                                -1.3029097 0.31164846 0.0 0.0 -1.3053559 -0.05865722 0.0 0.0 -1.3341265
                                -0.096507885 0.0 0.0 -1.1757993 -0.5836742 0.0 0.0 -33.369755 7.220442 0.0
                                0.0 -38.713947 5.7096257 0.0 0.0 -33.78206 -9.654537 0.0 0.0 -1.171371
                                -0.5332126 0.0 0.0 -2.55326 -0.42591637 0.0 0.0 -1.3330672 0.13435833 0.0 0.0
                                -41.515156 -0.42821434 0.0 0.0 -48.9376 12.65826 0.0 0.0 -0.6695328 0.4996156
                                0.0 0.0 -30.480711 -15.4423685 0.0 0.0 -32.194427 19.513493 0.0 0.0
                                -31.828892 12.435305 0.0 0.0 -972.14703 -539.598 0.0 0.0 -1.2833441 0.0845086
                                0.0 0.0 -992.142 -178.45824 0.0 0.0 -0.9881236 -0.60633844 0.0 0.0 -1.3257364
                                0.08861627 0.0 0.0 -35.143986 0.3967821 0.0 0.0 -1.224342 -0.5157729 0.0 0.0
                                -1.3165402 0.23602203 0.0 0.0 -1.2724628 0.2050111 0.0 0.0 -37.039856
                                -27.062866 0.0 0.0 -31.859716 13.927673 0.0 0.0 -30.706255 -4.3945823 0.0 0.0
                                -1.1023502 -0.65616256 0.0 0.0 -1.2860422 0.056879986 0.0 0.0 -1.3370683
                                0.10952007 0.0 0.0 -33.26342 -7.957216 0.0 0.0 -1.3201851 0.11125874 0.0 0.0
                                -1.2509516 -0.36585757 0.0 0.0 -1393.2394 691.18994 0.0 0.0 -1.3287206
                                -0.16757677 0.0 0.0 -91.01036 -8.52897 0.0 0.0 -33.21804 8.249553 0.0 0.0
                                -1.3071661 0.001673434 0.0 0.0 -1.3252251 -0.0424752 0.0 0.0 -905.1001
                                -451.9425 0.0 0.0 -1.3242615 0.14112407 0.0 0.0 -28.319654 -12.647492 0.0 0.0
                                -1.2954131 -0.3352204 0.0 0.0 -1.2896106 -0.13128002 0.0 0.0 -1.2340797
                                -0.1842559 0.0 0.0 -34.204357 1.5271704 0.0 0.0 -893.5834 -209.20511 0.0 0.0
                                -34.79838 -5.9330473 0.0 0.0 -1.1065089 -0.023823164 0.0 0.0 -1.3037748
                                -0.124448135 0.0 0.0 -1002.8579 146.22397 0.0 0.0 -1.3353103 0.10847368 0.0
                                0.0 -0.78150874 -1.0208997 0.0 0.0 -1.0827266 0.73890114 0.0 0.0 -1.2821268
                                -0.28660348 0.0 0.0 -34.77343 -0.061383333 0.0 0.0 -1116.8928 -77.90108 0.0
                                0.0 -919.1036 -19.173943 0.0 0.0 -1.274399 0.29599816 0.0 0.0 -1.2014711
                                -0.015374682 0.0 0.0 -37.797066 -2.029102 0.0 0.0 -1.3337032 0.11415167 0.0
                                0.0 -32.831516 -11.955402 0.0 0.0 -1.3396108 0.06620383 0.0 0.0 -1.2578989
                                -0.29301712 0.0 0.0 -1.198784 -0.4838939 0.0 0.0 -37.254757 6.584185 0.0 0.0
                                -1366.279 25.926498 0.0 0.0 -1.1476266 0.27439392 0.0 0.0 -1.3393706
                                -0.0032905415 0.0 0.0 -1016.73456 -3.7681847 0.0 0.0 -31.08994 1.4929899 0.0
                                0.0 -0.49792695 -1.0606444 0.0 0.0 -1.3240286 0.09557111 0.0 0.0 -1.3149289
                                -0.18997501 0.0 0.0 -0.97192854 -0.65355384 0.0 0.0 -1.2060487 0.5467222 0.0
                                0.0 -70.26781 -18.01064 0.0 0.0 -1002.0452 -179.83679 0.0 0.0 -1.2862691
                                0.10159475 0.0 0.0 -25.528221 17.578886 0.0 0.0 -1.200629 0.48992684 0.0 0.0
                                -1.1740339 -0.5716811 0.0 0.0 -1.2241151 -0.48150286 0.0 0.0 -53.813484
                                -16.413452 0.0 0.0 -34.36861 0.87182534 0.0 0.0 -34.098587 -4.394796 0.0 0.0
                                -31.816795 -12.936605 0.0 0.0 -50.88486 0.22000924 0.0 0.0 -1105.8047
                                418.30838 0.0 0.0 -31.114895 -1.7798623 0.0 0.0 -78.056366 -29.82485 0.0 0.0
                                -62.08326 -2.9036322 0.0 0.0 -1.3101739 -0.28327274 0.0 0.0 -46.0446
                                -3.0840583 0.0 0.0 -1.3306447 0.007889003 0.0 0.0 -1.2417481 0.0568786 0.0
                                0.0 -1.2127587 -0.37324208 0.0 0.0 -28.391922 12.873175 0.0 0.0 -1.3127251
                                0.07567194 0.0 0.0 -51.704624 22.42148 0.0 0.0 -1.1611735 0.12591624 0.0 0.0
                                -1.3175222 0.04284454 0.0 0.0 -32.706806 -11.157692 0.0 0.0 -1.3265884
                                -0.04088097 0.0 0.0 -1.1059138 -0.7509155 0.0 0.0 -1.3156118 -0.21185194 0.0
                                0.0 -1.3395101 0.04758125 0.0 0.0 -35.126038 5.3932443 0.0 0.0 -0.79456025
                                -1.0374595 0.0 0.0 -30.332203 7.1570306 0.0 0.0 -33.302845 12.431357 0.0 0.0
                                -1.2595698 -0.34293565 0.0 0.0 -1.2624464 0.44596058 0.0 0.0 -0.79268724
                                -0.8554637 0.0 0.0 -1.2926075 0.34342462 0.0 0.0)
             by #'cddddr
             collect (sqrt (+ (* x x) (* y y)))))

19736.22



19736.22

(vel-array-max
 #(-1.0508349 -0.20026743 0.0 0.0 -1.2924111 -0.6433141 0.0 0.0 -1.0522245
   -0.08897748 0.0 0.0 -1.0220407 0.29418644 0.0 0.0 -1.0599064 0.16021626 0.0
   0.0 -1.057147 0.22975288 0.0 0.0 -1.0728908 -0.16583887 0.0 0.0 -1.0518849
   -0.2949693 0.0 0.0 -1.0933961 0.19053715 0.0 0.0 -1.1074722 -0.029625535 0.0
   0.0 -1.1397549 0.049810052 0.0 0.0 -1.1300913 0.028561553 0.0 0.0 -1.3198816
   -0.068301804 0.0 0.0 -1.1375151 -0.036141858 0.0 0.0 -1.1369094 0.13772611
   0.0 0.0 -1.0958196 -0.3654928 0.0 0.0 -1.1079022 -0.5366998 0.0 0.0
   -1.1977782 0.101822704 0.0 0.0 -1.1374768 0.31089452 0.0 0.0 -1.1863451
   -0.02591045 0.0 0.0 -1.1807687 0.21600394 0.0 0.0 -1.2928439 0.16462964 0.0
   0.0 -1.2163767 0.01349516 0.0 0.0 -1.3036516 -0.13959765 0.0 0.0 -1.3710276
   0.4521944 0.0 0.0 -1.4492687 -0.31525648 0.0 0.0 -1.2596511 0.10909885 0.0
   0.0 -1.3961464 -0.1464537 0.0 0.0 -1.3263397 0.16768092 0.0 0.0 -1.2000326
   -0.39592707 0.0 0.0 -1.2370985 -0.3137174 0.0 0.0 -1.2806966 -0.13638328 0.0
   0.0 -1.2842213 -0.10651209 0.0 0.0 -1.2768767 0.22308087 0.0 0.0 -1.2935683
   -0.17967442 0.0 0.0 -1.3346272 -0.2615772 0.0 0.0 -1.3357089 -0.33535606 0.0
   0.0 -1.2845428 0.49372602 0.0 0.0 -1.4171602 -0.012442972 0.0 0.0 -1.4080553
   0.06653445 0.0 0.0 -0.79226357 -0.6746433 0.0 0.0 -1.3661809 -0.16549277 0.0
   0.0 -1.2307453 -0.045237046 0.0 0.0 -1.3039011 -0.45601305 0.0 0.0 -1.4078687
   0.34661543 0.0 0.0 -1.3885448 -0.02933759 0.0 0.0 -1.4195412 0.15292111 0.0
   0.0 -1.4355109 -0.17382728 0.0 0.0 -1.462919 0.17513825 0.0 0.0 -1.4148015
   0.34155902 0.0 0.0 -1.2822504 -0.63767123 0.0 0.0 -0.4229422 -1.1647745 0.0
   0.0 -1.4690825 0.11270329 0.0 0.0 -1.0889864 0.36280164 0.0 0.0 -1.4181924
   0.41662717 0.0 0.0 -1.508724 0.4179721 0.0 0.0 -1.4210746 0.06816288 0.0 0.0
   -1.366968 -0.019410012 0.0 0.0 -1.3754174 -0.47886238 0.0 0.0 -1.482963
   -0.37549466 0.0 0.0 -1.2728631 0.060300544 0.0 0.0 -1.5621617 0.43979603 0.0
   0.0 -1.5583415 -0.22770414 0.0 0.0 -1.1726017 0.15657885 0.0 0.0 -1.3212264
   0.42521974 0.0 0.0 -1.4995553 0.42958677 0.0 0.0 -0.97093356 1.0261699 0.0
   0.0 -1.3624511 -0.71849144 0.0 0.0 -1.3662024 -0.46987495 0.0 0.0 -1.6065229
   -0.4693631 0.0 0.0 -1.6922561 -0.3371876 0.0 0.0 -1.4485073 0.1021747 0.0 0.0
   -1.5583915 -0.19517009 0.0 0.0 -1.5304519 -0.34569559 0.0 0.0 -1.6694026
   -0.2637091 0.0 0.0 -1.5269879 -0.34294698 0.0 0.0 -1.6720115 0.23393303 0.0
   0.0 -1.3685247 0.24836278 0.0 0.0 -1.4123341 0.46573612 0.0 0.0 -1.6358168
   -0.35597697 0.0 0.0 -1.5061735 -0.68187016 0.0 0.0 -1.7752922 -0.435165 0.0
   0.0 -1.4616308 0.46872652 0.0 0.0 -1.7607623 0.33060643 0.0 0.0 -1.1996192
   -1.0132754 0.0 0.0 -1.4798566 -0.07364336 0.0 0.0 -1.784857 0.23983167 0.0
   0.0 -1.6866828 -0.6204029 0.0 0.0 -1.6068314 -0.58826274 0.0 0.0 -1.5811578
   -0.54368216 0.0 0.0 -1.8228269 0.1725776 0.0 0.0 -1.5557557 0.08481219 0.0
   0.0 -1.3699147 -0.23084863 0.0 0.0 -1.4538808 0.12081444 0.0 0.0 -1.9017038
   -0.05496037 0.0 0.0 -1.1467401 -0.1020246 0.0 0.0 -1.5561135 0.37629464 0.0
   0.0 -1.4019599 0.2700786 0.0 0.0 -1.8155841 0.69524497 0.0 0.0 -1.911884
   0.30678892 0.0 0.0 -1.6144296 0.74237293 0.0 0.0 -1.3061408 -0.67433447 0.0
   0.0 -1.9228301 -0.37741607 0.0 0.0 -1.7507764 -0.43092325 0.0 0.0 -1.5811405
   -0.91357476 0.0 0.0 -1.9870405 -0.2784045 0.0 0.0 -1.930993 0.6092953 0.0 0.0
   -1.5268222 -0.6066861 0.0 0.0 -1.5163869 -0.9552388 0.0 0.0 -1.4472995
   0.125622 0.0 0.0 -2.0954792 0.091157034 0.0 0.0 -1.2263216 -0.018941306 0.0
   0.0 -1.9956456 -0.68466765 0.0 0.0 -2.1742153 0.70012254 0.0 0.0 -1.2733991
   0.42298254 0.0 0.0 -1.4353802 0.14864102 0.0 0.0 -2.0392008 0.54542714 0.0
   0.0 -1.6095784 -0.09402196 0.0 0.0 -2.0229392 0.67906237 0.0 0.0 -2.183621
   -0.48048127 0.0 0.0 -1.576686 -0.043371443 0.0 0.0 -2.413706 0.102446355 0.0
   0.0 -1.5716232 0.2815833 0.0 0.0 -1.5722866 -0.5037886 0.0 0.0 -1.411629
   -0.888344 0.0 0.0 -1.0618159 0.4250188 0.0 0.0 -2.2065215 0.19846462 0.0 0.0
   -1.9277618 0.13724239 0.0 0.0 -2.1720984 -0.74713415 0.0 0.0 -1.7833933
   -0.77760184 0.0 0.0 -1.6515831 -0.20032401 0.0 0.0 -2.513544 0.9348229 0.0
   0.0 -2.2397923 -0.6129674 0.0 0.0 -1.7088053 0.13636531 0.0 0.0 -1.4540489
   0.30869287 0.0 0.0 -1.9250597 0.11650048 0.0 0.0 -1.4018208 0.20053843 0.0
   0.0 -1.1803852 0.07660457 0.0 0.0 -2.4423378 0.3037182 0.0 0.0 -2.116891
   -1.1348386 0.0 0.0 -1.9481255 -0.54326653 0.0 0.0 -1.5293486 0.16448951 0.0
   0.0 -1.6771318 0.5361349 0.0 0.0 -1.714592 -0.27462703 0.0 0.0 -1.711766
   0.36952728 0.0 0.0 -2.438722 0.32839197 0.0 0.0 -2.4528286 -0.9410782 0.0 0.0
   -2.4433212 -0.5064781 0.0 0.0 -1.6400629 0.42613396 0.0 0.0 -0.9903402
   -1.0409939 0.0 0.0 -2.3702066 -0.8786783 0.0 0.0 -1.5157015 0.37742704 0.0
   0.0 -2.2798011 1.17207 0.0 0.0 -2.643149 -0.17962392 0.0 0.0 -1.4235504
   -0.38653848 0.0 0.0 -2.4454896 -0.8821849 0.0 0.0 -2.604698 0.2469238 0.0 0.0
   -1.3151269 -0.21339509 0.0 0.0 -2.5952413 0.616104 0.0 0.0 -2.6133246
   0.41523278 0.0 0.0 -2.4615908 -1.1568946 0.0 0.0 -1.68804 -0.7127223 0.0 0.0
   -1.6231356 -0.598499 0.0 0.0 -1.2278458 -1.0855252 0.0 0.0 -2.2869747
   0.22690666 0.0 0.0 -1.6436013 0.11336221 0.0 0.0 -2.7618065 -0.5732085 0.0
   0.0 -2.3577952 -0.29084444 0.0 0.0 -1.7408633 0.055355027 0.0 0.0 -1.4417683
   0.13005653 0.0 0.0 -2.6146996 -1.0329838 0.0 0.0 -2.9149413 -0.8653722 0.0
   0.0 -1.7977648 -0.40704527 0.0 0.0 -1.2938272 -0.6907631 0.0 0.0 -2.9098713
   0.2130157 0.0 0.0 -2.8958488 0.12880564 0.0 0.0 -2.132022 0.733311 0.0 0.0
   -1.3256761 -1.9068301 0.0 0.0 -1.3611412 0.36621928 0.0 0.0 -1.6168622
   -0.69917834 0.0 0.0 -2.8841157 -0.7510271 0.0 0.0 -2.1653965 -0.63573736 0.0
   0.0 -2.0332055 -0.076647505 0.0 0.0 -1.2906877 -0.44265455 0.0 0.0 -1.4548347
   0.30870688 0.0 0.0 -1.1476853 0.45621982 0.0 0.0 -3.0334122 0.22313718 0.0
   0.0 -1.1971114 -0.27535704 0.0 0.0 -2.8535821 0.7966654 0.0 0.0 -2.3404183
   -0.10913946 0.0 0.0 -1.7085875 0.34070987 0.0 0.0 -2.4354851 0.17705768 0.0
   0.0 -3.091662 0.5548972 0.0 0.0 -1.7202401 -0.6812968 0.0 0.0 -1.9360461
   -0.051778745 0.0 0.0 -1.1794207 -1.067522 0.0 0.0 -2.6830812 -1.5240031 0.0
   0.0 -1.4464066 0.13166305 0.0 0.0 -1.7223003 0.29118717 0.0 0.0 -2.3968463
   -0.3232352 0.0 0.0 -3.475212 0.033927843 0.0 0.0 -1.3142464 -0.21424565 0.0
   0.0 -1.3145021 0.2861579 0.0 0.0 -1.9016167 -0.49202025 0.0 0.0 -3.3899605
   -0.38490644 0.0 0.0 -1.1011205 -0.62599015 0.0 0.0 -1.862986 0.4741514 0.0
   0.0 -1.7686851 0.0034601537 0.0 0.0 -0.69566005 -0.35655433 0.0 0.0
   -1.8035274 0.48381174 0.0 0.0 -3.6700938 -0.27833533 0.0 0.0 -3.5943978
   0.398056 0.0 0.0 -3.4519384 0.12861845 0.0 0.0 -2.8277733 -1.3847119 0.0 0.0
   -3.4905214 0.38330373 0.0 0.0 -1.43642 -0.15917659 0.0 0.0 -1.783255
   -0.38164315 0.0 0.0 -2.5601099 -0.7545985 0.0 0.0 -1.1206241 0.46642387 0.0
   0.0 -3.138694 1.738866 0.0 0.0 -1.3313212 -0.5377806 0.0 0.0 -1.5536022
   0.6666326 0.0 0.0 -1.6780597 2.1144626 0.0 0.0 -2.3347707 -0.8738187 0.0 0.0
   -2.3451905 -0.96379954 0.0 0.0 -1.8446459 -0.22653025 0.0 0.0 -1.9419422
   -0.19670291 0.0 0.0 -3.7864804 -0.4686985 0.0 0.0 -3.4434927 -0.8927993 0.0
   0.0 -1.4107441 0.02198302 0.0 0.0 -1.7487775 -0.69420683 0.0 0.0 -2.4105952
   -1.3378953 0.0 0.0 -3.7566786 0.13534115 0.0 0.0 -2.6737478 -0.070161335 0.0
   0.0 -3.8224564 -0.026754074 0.0 0.0 -2.5952942 0.40903607 0.0 0.0 -0.8383215
   -1.2190096 0.0 0.0 -1.4447669 -0.19299486 0.0 0.0 -1.2860004 -0.5631362 0.0
   0.0 -2.6859531 0.38136056 0.0 0.0 -2.2272213 -1.196593 0.0 0.0 -2.0196378
   0.3182854 0.0 0.0 -1.2147908 0.38182554 0.0 0.0 -1.2176418 -0.3557876 0.0 0.0
   -0.4338266 -0.93729174 0.0 0.0 -3.4991026 1.9213638 0.0 0.0 -2.8672318
   0.4581179 0.0 0.0 -1.4718236 -0.016328871 0.0 0.0 -2.6841857 0.45856565 0.0
   0.0 -1.4608334 0.22168162 0.0 0.0 -1.8676403 0.7295323 0.0 0.0 -1.3239924
   0.09067337 0.0 0.0 -1.0812675 -0.99015284 0.0 0.0 -4.124463 -0.13020994 0.0
   0.0 -1.5471201 -0.5412318 0.0 0.0 -1.241052 -0.03168659 0.0 0.0 -2.796306
   1.2313861 0.0 0.0 -1.2128478 0.0897264 0.0 0.0 -4.388827 -0.5218295 0.0 0.0
   -1.472108 -0.14918968 0.0 0.0 -3.510711 -2.3864267 0.0 0.0 -2.0028737
   0.73888826 0.0 0.0 -4.2048397 0.34995142 0.0 0.0 -1.3712968 0.007503152 0.0
   0.0 -0.7347476 -0.6026892 0.0 0.0 -2.8187046 0.8009103 0.0 0.0 -1.9839272
   0.410975 0.0 0.0 -1.343652 0.11686136 0.0 0.0 -3.1051745 0.7808165 0.0 0.0
   -2.580241 -0.39138204 0.0 0.0 -1.8999422 -0.20761958 0.0 0.0 -2.477737
   -1.5317613 0.0 0.0 -1.4066256 0.070977576 0.0 0.0 -2.9084172 -0.117457174 0.0
   0.0 -1.487222 0.06421054 0.0 0.0 -4.920259 0.4190139 0.0 0.0 -1.4908246
   1.1160187 0.0 0.0 -1.9140868 -0.5361653 0.0 0.0 -1.4085264 -0.29230174 0.0
   0.0 -1.109943 0.9503856 0.0 0.0 -4.392375 1.7860432 0.0 0.0 -4.1271806
   2.1011932 0.0 0.0 -4.461303 -1.4247367 0.0 0.0 -1.2382689 0.15858537 0.0 0.0
   -2.7226002 -1.6614809 0.0 0.0 -3.198878 -0.4055834 0.0 0.0 -1.4650341
   0.019827388 0.0 0.0 -1.4249582 0.29257292 0.0 0.0 -3.193533 -0.33074945 0.0
   0.0 -4.695859 0.8752108 0.0 0.0 -1.3978251 -0.095189944 0.0 0.0 -1.1890036
   0.6898676 0.0 0.0 -2.8844824 1.0478289 0.0 0.0 -1.9589962 -0.971646 0.0 0.0
   -1.1980691 -0.3082993 0.0 0.0 -2.1761193 -0.28948444 0.0 0.0 -4.9442606
   0.5670223 0.0 0.0 -4.863294 0.9143836 0.0 0.0 -3.0355942 0.54211986 0.0 0.0
   -5.098547 -0.64454406 0.0 0.0 -1.244084 0.81439894 0.0 0.0 -1.1582106
   -1.4757118 0.0 0.0 -2.8796816 -1.7118571 0.0 0.0 -5.050168 0.5839182 0.0 0.0
   -3.1519055 0.835192 0.0 0.0 -3.0770872 -1.363352 0.0 0.0 -1.3634759
   0.12360463 0.0 0.0 -5.3779697 -0.17604221 0.0 0.0 -5.3507066 0.5205715 0.0
   0.0 -5.3270106 -0.56812453 0.0 0.0 -3.1483295 0.52708495 0.0 0.0 -2.1962938
   -0.01544556 0.0 0.0 -5.1796117 -0.8274021 0.0 0.0 -3.496929 -0.03003165 0.0
   0.0 -2.9218025 0.78252137 0.0 0.0 -1.4892213 0.03447014 0.0 0.0 -5.4747124
   -0.95219654 0.0 0.0 -3.2273443 -0.06539251 0.0 0.0 -4.958768 -2.1750853 0.0
   0.0 -5.4142413 0.29391465 0.0 0.0 -4.6072063 -3.320052 0.0 0.0 -5.415578
   -1.4152199 0.0 0.0 -1.9699955 -0.7081849 0.0 0.0 -5.064809 -2.9335122 0.0 0.0
   -1.2477964 0.6537357 0.0 0.0 -1.2981104 -0.24955 0.0 0.0 -2.3353825
   -0.17209804 0.0 0.0 -6.3561215 0.9235129 0.0 0.0 -1.4815316 -0.038685907 0.0
   0.0 -0.597054 0.7677821 0.0 0.0 -3.5577142 -0.27279866 0.0 0.0 -4.0788555
   0.61319077 0.0 0.0 -1.2421347 0.18766713 0.0 0.0 -6.0204587 -1.505485 0.0 0.0
   -5.5453515 0.92896205 0.0 0.0 -3.5350587 0.14372958 0.0 0.0 -1.4802774
   0.06363205 0.0 0.0 -3.533388 -0.48400956 0.0 0.0 -5.5971394 -1.7958211 0.0
   0.0 -1.9536253 0.584723 0.0 0.0 -1.2356198 0.79938996 0.0 0.0 -1.2084849
   -0.69342464 0.0 0.0 -1.3268883 0.1955134 0.0 0.0 -3.1328373 1.7757118 0.0 0.0
   -2.7303724 -1.8388934 0.0 0.0 -3.3360116 1.8359731 0.0 0.0 -3.8298805
   -0.4548698 0.0 0.0 -2.050836 -0.1575659 0.0 0.0 -1.4065483 0.019376533 0.0
   0.0 -2.3660698 0.44540444 0.0 0.0 -5.2020664 3.2240617 0.0 0.0 -2.2812934
   -0.53137547 0.0 0.0 -1.4740115 0.21994734 0.0 0.0 -6.154345 -1.7278546 0.0
   0.0 -1.3640347 -0.4113518 0.0 0.0 -1.3510572 0.53904265 0.0 0.0 -3.3646266
   1.5311832 0.0 0.0 -3.4160218 -1.2103186 0.0 0.0 -1.3952104 0.010813876 0.0
   0.0 -3.5509531 -1.0363097 0.0 0.0 -3.2522123 1.8620439 0.0 0.0 -1.2928945
   0.18899311 0.0 0.0 -1.4163917 -1.9631695 0.0 0.0 -1.3890052 -0.11583001 0.0
   0.0 -5.8662257 -2.644508 0.0 0.0 -5.1404033 4.0387583 0.0 0.0 -1.4803792
   -0.100292526 0.0 0.0 -2.1615226 -0.016459165 0.0 0.0 -1.4437182 0.33059964
   0.0 0.0 -3.6691902 0.8361001 0.0 0.0 -1.8933206 1.0203238 0.0 0.0 -2.4665663
   0.023635859 0.0 0.0 -2.1265342 -0.34256008 0.0 0.0 -2.1887984 -0.12954396 0.0
   0.0 -2.2435534 -0.079866484 0.0 0.0 -3.3345408 1.3516611 0.0 0.0 -1.4511474
   -0.25302073 0.0 0.0 -1.2114706 -0.82470185 0.0 0.0 -1.4566563 -0.049689434
   0.0 0.0 -3.690975 -0.81259394 0.0 0.0 -1.206216 0.81160223 0.0 0.0 -2.239274
   -0.057541106 0.0 0.0 -3.8428829 0.5013094 0.0 0.0 -8.135962 -0.6730309 0.0
   0.0 -1.4506029 0.14782415 0.0 0.0 -1.4169906 0.22670051 0.0 0.0 -1.3161278
   0.69527227 0.0 0.0 -1.0977914 -0.8256524 0.0 0.0 -7.218099 0.5208391 0.0 0.0
   -1.4104235 -0.17420998 0.0 0.0 -2.1297827 0.71244425 0.0 0.0 -2.3086088
   0.4706045 0.0 0.0 -1.4430879 -0.023486987 0.0 0.0 -6.9502883 -2.0788264 0.0
   0.0 -7.564538 1.3604982 0.0 0.0 -1.4550239 0.20777428 0.0 0.0 -3.8958776
   -0.6961704 0.0 0.0 -2.3590133 0.2229223 0.0 0.0 -1.1121609 0.4321687 0.0 0.0
   -2.197259 0.644873 0.0 0.0 -1.4143964 0.32482895 0.0 0.0 -2.2817285
   -0.011245891 0.0 0.0 -1.4715561 0.083634704 0.0 0.0 -7.430881 0.5097729 0.0
   0.0 -3.9968264 1.0949448 0.0 0.0 -1.4028422 -0.06572549 0.0 0.0 -3.3075464
   -2.9266727 0.0 0.0 -3.1214993 2.5853884 0.0 0.0 -3.7662694 -1.419169 0.0 0.0
   -1.1834078 0.775896 0.0 0.0 -1.3851676 0.24891227 0.0 0.0 -1.4305925
   -0.13362484 0.0 0.0 -4.0591264 0.53114194 0.0 0.0 -1.259276 0.5451488 0.0 0.0
   -8.283397 2.2444627 0.0 0.0 -6.374436 4.402794 0.0 0.0 -3.933651 -1.4677233
   0.0 0.0 -7.3632965 2.7378356 0.0 0.0 -1.3948454 -0.040757507 0.0 0.0
   -1.5766064 1.3611581 0.0 0.0 -1.2948946 -0.666961 0.0 0.0 -4.6812043
   0.40121302 0.0 0.0 -1.4059379 -0.26120573 0.0 0.0 -4.560835 -0.463363 0.0 0.0
   -1.4533017 0.14197092 0.0 0.0 -2.4521682 0.84026706 0.0 0.0 -1.4182198
   -0.03500703 0.0 0.0 -1.360066 0.2898951 0.0 0.0 -1.286695 -0.7291139 0.0 0.0
   -2.3693109 -0.23510389 0.0 0.0 -2.3921335 -0.8145163 0.0 0.0 -2.209948
   0.45469522 0.0 0.0 -1.060892 0.12318349 0.0 0.0 -1.1998895 -0.5768097 0.0 0.0
   -6.902437 -4.5703673 0.0 0.0 -4.651065 0.4234176 0.0 0.0 -7.972107 -2.3305185
   0.0 0.0 -2.5728202 0.64011616 0.0 0.0 -1.3725067 0.47001296 0.0 0.0
   -1.4357723 0.27279064 0.0 0.0 -2.2746885 0.43830213 0.0 0.0 -1.2353306
   0.20620766 0.0 0.0 -4.0039134 -1.7529517 0.0 0.0 -1.3173829 0.5541875 0.0 0.0
   -1.327546 0.057946995 0.0 0.0 -4.250131 5.008727e-4 0.0 0.0 -1.4531975
   0.3265653 0.0 0.0 -2.462007 -0.90527374 0.0 0.0 -4.585966 -1.1509879 0.0 0.0
   -4.4730887 0.44484952 0.0 0.0 -1.442912 -0.02088472 0.0 0.0 -8.849694
   -0.6341423 0.0 0.0 -1.4160868 -0.02263555 0.0 0.0 -9.350849 0.33022457 0.0
   0.0 -1.453607 0.051235374 0.0 0.0 -4.572016 0.066050075 0.0 0.0 -8.695997
   1.2530806 0.0 0.0 -2.307988 0.3608952 0.0 0.0 -4.6520905 0.37579134 0.0 0.0
   -8.409856 -3.3377228 0.0 0.0 -9.041297 -0.22454253 0.0 0.0 -1.3956457
   -0.18514267 0.0 0.0 -4.517358 1.242679 0.0 0.0 -7.8450813 -4.6807623 0.0 0.0
   -7.825277 0.63551366 0.0 0.0 -2.2594073 -0.482305 0.0 0.0 -5.010398
   -0.84181565 0.0 0.0 -2.4216142 0.46447304 0.0 0.0 -1.3805952 -0.2124187 0.0
   0.0 -1.186468 0.6334864 0.0 0.0 -9.347603 0.24203542 0.0 0.0 -2.4217012
   1.3728582 0.0 0.0 -1.2001512 -0.079407334 0.0 0.0 -10.996122 -0.041574415 0.0
   0.0 -1.3772984 0.34555244 0.0 0.0 -2.7664626 -0.4002189 0.0 0.0 -1.3044913
   0.5342083 0.0 0.0 -1.1622292 0.1007838 0.0 0.0 -1.0195899 -0.53480417 0.0 0.0
   -2.735215 -0.4848883 0.0 0.0 -2.5198798 -0.20678863 0.0 0.0 -2.2319798
   -1.078468 0.0 0.0 -12.069116 0.3729715 0.0 0.0 -1.3728788 -0.27129817 0.0 0.0
   -1.2680526 -0.5624185 0.0 0.0 -9.928052 -0.5307482 0.0 0.0 -0.63945055
   0.27275226 0.0 0.0 -1.3102833 0.17455709 0.0 0.0 -0.98286134 -0.78565097 0.0
   0.0 -3.1151643 3.1301422 0.0 0.0 -1.3630124 0.0884845 0.0 0.0 -2.6429923
   -0.39997053 0.0 0.0 -1.7607226 -0.5547689 0.0 0.0 -1.4456313 0.18016326 0.0
   0.0 -1.4281559 0.13743065 0.0 0.0 -2.779991 0.47696862 0.0 0.0 -1.4581141
   -0.20813602 0.0 0.0 -1.2008194 -0.74987745 0.0 0.0 -4.5913076 2.1552815 0.0
   0.0 -10.235416 0.17684965 0.0 0.0 -1.2759833 -0.8159512 0.0 0.0 -1.4580407
   0.123351574 0.0 0.0 -2.0985427 -1.3931838 0.0 0.0 -1.3899972 -0.44103405 0.0
   0.0 -4.930653 -1.3917415 0.0 0.0 -2.458203 -0.8349647 0.0 0.0 -10.464874
   1.6886066 0.0 0.0 -10.678526 -0.079134464 0.0 0.0 -4.9606576 0.5134996 0.0
   0.0 -2.4076207 0.39678812 0.0 0.0 -2.2343543 -1.5692685 0.0 0.0 -10.44598
   2.433942 0.0 0.0 -2.1633391 1.0850896 0.0 0.0 -2.4719272 -0.110985935 0.0 0.0
   -1.3222079 -0.205378 0.0 0.0 -4.9285746 0.884381 0.0 0.0 -1.327169
   0.027842196 0.0 0.0 -4.7216835 -1.9672252 0.0 0.0 -1.1489644 -0.6544229 0.0
   0.0 -2.5591044 0.5189122 0.0 0.0 -1.0330234 -0.7879179 0.0 0.0 -2.200333
   0.9743426 0.0 0.0 -1.3069268 0.050953653 0.0 0.0 -4.333241 -1.9432311 0.0 0.0
   -1.3059701 0.10022166 0.0 0.0 -2.204813 -0.3261251 0.0 0.0 -1.3340375
   0.13761695 0.0 0.0 -1.2263929 0.28705725 0.0 0.0 -1.2419962 0.41516292 0.0
   0.0 -4.6645703 2.0380833 0.0 0.0 -4.4133205 -2.7327535 0.0 0.0 -5.421458
   -0.96411765 0.0 0.0 -0.5937917 0.88062465 0.0 0.0 -2.4046605 -0.39016917 0.0
   0.0 -1.2343794 0.4249298 0.0 0.0 -2.3744586 -0.66826695 0.0 0.0 -1.2560809
   0.114109464 0.0 0.0 -1.1729467 0.17448978 0.0 0.0 -1.2297473 -0.4038161 0.0
   0.0 -2.4797153 -0.4048906 0.0 0.0 -5.536696 0.78096783 0.0 0.0 -1.2679497
   -0.110203795 0.0 0.0 -0.9730717 -0.8352336 0.0 0.0 -5.195065 0.97699994 0.0
   0.0 -5.257233 -0.8202211 0.0 0.0 -1.1103365 0.4904955 0.0 0.0 -2.5033083
   1.0718639 0.0 0.0 -2.4151945 0.038870826 0.0 0.0 -1.2186885 0.39834103 0.0
   0.0 -5.368437 0.93577534 0.0 0.0 -2.4839346 -0.08349773 0.0 0.0 -1.2728841
   0.011154431 0.0 0.0 -4.5887933 -2.7225873 0.0 0.0 -0.97306675 0.1744943 0.0
   0.0 -1.2697206 0.40791628 0.0 0.0 -2.2669122 1.1312124 0.0 0.0 -2.5328286
   0.8613759 0.0 0.0 -5.2731504 -1.4335902 0.0 0.0 -2.2789028 -1.4321768 0.0 0.0
   -2.677436 -0.15264267 0.0 0.0 -1.2598065 0.3484268 0.0 0.0 -2.6258957
   0.6621722 0.0 0.0 -2.7476807 -1.1786206 0.0 0.0 -1.933597 -1.312276 0.0 0.0
   -5.4695673 1.1758813 0.0 0.0 -1.3142836 -0.08975014 0.0 0.0 -1.2439809
   -0.4417427 0.0 0.0 -5.4460173 -0.92811614 0.0 0.0 -5.708364 0.3658671 0.0 0.0
   -1.271479 -0.39227274 0.0 0.0 -5.9939823 -1.0001401 0.0 0.0 -5.710327
   -0.91124225 0.0 0.0 -2.874896 0.63953084 0.0 0.0 -1.2119915 -0.4179049 0.0
   0.0 -2.4996936 -0.6478813 0.0 0.0 -5.831275 -0.98452526 0.0 0.0 -5.9099755
   -1.3779103 0.0 0.0 -1.0694509 0.7139685 0.0 0.0 -1.297817 -0.03863508 0.0 0.0
   -6.4724054 -1.553748 0.0 0.0 -1.2545635 0.99193835 0.0 0.0 -1.221385
   0.3078851 0.0 0.0 -2.6460648 -0.30239972 0.0 0.0 -5.975616 1.3268464 0.0 0.0
   -5.588359 -1.0522963 0.0 0.0 -2.37624 1.391612 0.0 0.0 -1.2691053 0.43095738
   0.0 0.0 -0.41389528 1.2374437 0.0 0.0 -2.5796087 0.3122072 0.0 0.0 -2.6065657
   -0.98201895 0.0 0.0 -1.0720799 -0.7803385 0.0 0.0 -2.3079536 1.274318 0.0 0.0
   -6.1120076 -0.39000195 0.0 0.0 -1.3174834 -0.24416304 0.0 0.0 -1.1438179
   -0.5939736 0.0 0.0 -2.3670049 -1.0947989 0.0 0.0 -2.637899 1.0526565 0.0 0.0
   -6.4768476 0.8420774 0.0 0.0 -2.7612975 -0.5224899 0.0 0.0 -1.2158955
   -0.44881094 0.0 0.0 -1.2002745 -0.49669877 0.0 0.0 -0.91157985 -0.84987706
   0.0 0.0 -2.4555984 -0.71687496 0.0 0.0 -5.9562936 0.62359756 0.0 0.0
   -5.889823 -0.5063529 0.0 0.0 -2.646583 -0.35082573 0.0 0.0 -5.0117435
   3.1777642 0.0 0.0 -5.9709477 -0.2331719 0.0 0.0 -2.6163602 -0.3585325 0.0 0.0
   -0.8760997 -1.0238401 0.0 0.0 -1.2406152 -0.4939082 0.0 0.0 -2.7240088
   0.85755634 0.0 0.0 -2.5891256 1.2756196 0.0 0.0 -1.0196334 -0.80012816 0.0
   0.0 -2.6532547 0.103024475 0.0 0.0 -0.8175356 -1.0772411 0.0 0.0 -2.6734908
   0.869535 0.0 0.0 -1.2816374 0.16669615 0.0 0.0 -1.1645583 0.018406183 0.0 0.0
   -1.1532294 0.6607663 0.0 0.0 -2.3958235 -1.0965868 0.0 0.0 -2.5040734
   -0.9546347 0.0 0.0 -1.2006607 -0.4519529 0.0 0.0 -2.512465 1.4831362 0.0 0.0
   -0.73009926 -1.0443074 0.0 0.0 -1.3094783 -0.22634624 0.0 0.0 -1.280032
   0.35155016 0.0 0.0 -6.379336 -1.5747502 0.0 0.0 -5.701153 2.404025 0.0 0.0
   -1.1756704 0.5394429 0.0 0.0 -1.2705895 0.17183208 0.0 0.0 -1.1713566
   0.44643924 0.0 0.0 -1.316125 0.077044755 0.0 0.0 -2.8602173 -0.33642396 0.0
   0.0 -1.3772014 -0.068977766 0.0 0.0 -0.77405244 -0.3633732 0.0 0.0 -6.2463603
   0.71580285 0.0 0.0 -2.8560755 -0.35409927 0.0 0.0 -1.1921493 -0.5786635 0.0
   0.0 -2.8275905 0.7158241 0.0 0.0 -1.3203032 0.1917631 0.0 0.0 -2.6566901
   -0.62655634 0.0 0.0 -2.7930768 -0.8703565 0.0 0.0 -1.278681 0.37298393 0.0
   0.0 -6.374165 0.07443995 0.0 0.0 -2.890377 -0.5929548 0.0 0.0 -1.2340324
   -0.054002672 0.0 0.0 -2.5476894 -4.02767 0.0 0.0 -1.2563659 0.0687931 0.0 0.0
   -2.8875153 0.77321845 0.0 0.0 -1.3040375 0.29214475 0.0 0.0 -2.728818
   -1.1644539 0.0 0.0 -1.2385509 0.39469847 0.0 0.0 -1.1412283 -0.62523943 0.0
   0.0 -6.5714025 0.60231304 0.0 0.0 -1.4637386 -0.047593933 0.0 0.0 -2.7022085
   0.38793376 0.0 0.0 -2.9228017 -0.9251015 0.0 0.0 -1.1222187 -0.539286 0.0 0.0
   -1.0559858 -0.38834676 0.0 0.0 -6.587891 -1.0606081 0.0 0.0 -2.7386212
   -0.17216459 0.0 0.0 -1.2322743 0.03820935 0.0 0.0 -0.9955187 -0.3606386 0.0
   0.0 -1.073582 -0.700312 0.0 0.0 -6.545449 1.0215701 0.0 0.0 -1.2279112
   0.27674362 0.0 0.0 -7.806262 0.7359497 0.0 0.0 -1.2236173 -0.54757273 0.0 0.0
   -2.7801862 0.42171037 0.0 0.0 -1.1579806 0.42033437 0.0 0.0 -2.8006768
   0.41847354 0.0 0.0 -1.0845902 0.69597036 0.0 0.0 -1.0127959 -0.87957627 0.0
   0.0 -7.598426 0.8953555 0.0 0.0 -2.9087484 0.6171467 0.0 0.0 -1.3059925
   -0.21280606 0.0 0.0 -1.1455528 -0.5003733 0.0 0.0 -1.146304 -0.23243779 0.0
   0.0 -7.0332646 1.0081964 0.0 0.0 -6.6048083 -1.9370202 0.0 0.0 -2.7739787
   -0.3945968 0.0 0.0 -2.4874775 0.7654249 0.0 0.0 -1.261029 -0.34563795 0.0 0.0
   -1.0063921 0.7079878 0.0 0.0 -3.0306394 0.4174511 0.0 0.0 -7.141506
   -1.1822292 0.0 0.0 -7.0628796 -0.61656505 0.0 0.0 -4.9462814 -1.5419843 0.0
   0.0 -6.5905023 4.4033923 0.0 0.0 -7.0404916 0.32316062 0.0 0.0 -6.965571
   -0.8764681 0.0 0.0 -2.754726 -0.7376924 0.0 0.0 -2.805036 0.30107048 0.0 0.0
   -1.2754402 0.40559196 0.0 0.0 -1.2745849 0.1893394 0.0 0.0 -0.9676571
   0.87633055 0.0 0.0 -3.002236 0.697071 0.0 0.0 -1.1314151 0.59244895 0.0 0.0
   -7.548955 0.7610108 0.0 0.0 -2.6561296 0.25980565 0.0 0.0 -7.3309546 1.50946
   0.0 0.0 -1.2615418 -0.10572321 0.0 0.0 -1.2328143 0.48449254 0.0 0.0
   -7.0650115 1.3064717 0.0 0.0 -1.9079366 -1.3635458 0.0 0.0 -10.170682
   -1.0262433 0.0 0.0 -3.0993993 0.11997202 0.0 0.0 -7.246048 -1.7309291 0.0 0.0
   -3.0425034 0.034792557 0.0 0.0 -2.7178774 1.0799958 0.0 0.0 -6.5183926
   -3.228397 0.0 0.0 -1.241165 0.31093433 0.0 0.0 -6.9273067 2.434638 0.0 0.0
   -3.0647485 0.27097753 0.0 0.0 -7.2413516 1.1059794 0.0 0.0 -1.2552445
   -0.30378512 0.0 0.0 -7.384418 -0.38764253 0.0 0.0 -6.74214 2.7390115 0.0 0.0
   -1.2074344 0.49604768 0.0 0.0 -1.323103 -0.20919397 0.0 0.0 -2.7368374
   0.9817342 0.0 0.0 -1.1030065 -0.3302249 0.0 0.0 -3.1120348 -0.21858788 0.0
   0.0 -7.341663 1.2138538 0.0 0.0 -1.0563401 -0.7683494 0.0 0.0 -2.9990869
   -0.87535745 0.0 0.0 -7.710606 3.0232322 0.0 0.0 -7.324486 -1.7825639 0.0 0.0
   -2.7911034 0.7812218 0.0 0.0 -8.047194 -1.4669799 0.0 0.0 -6.4681253
   -3.6806169 0.0 0.0 -1.224023 -0.3301206 0.0 0.0 -2.919301 -0.29145187 0.0 0.0
   -6.9703608 -2.6532912 0.0 0.0 -1.3359694 0.11517077 0.0 0.0 -1.3234355
   0.09140334 0.0 0.0 -7.627599 -1.3745526 0.0 0.0 -7.272177 1.9592799 0.0 0.0
   -7.9643726 -0.27989933 0.0 0.0 -1.3087455 0.06373304 0.0 0.0 -2.864707
   0.60463804 0.0 0.0 -1.2746497 0.3158014 0.0 0.0 -2.7483454 -1.2768356 0.0 0.0
   -1.2829188 -0.019022187 0.0 0.0 -7.396348 1.8388232 0.0 0.0 -2.4115958
   -1.7961189 0.0 0.0 -2.990632 -0.2557446 0.0 0.0 -7.1721025 -3.6498249 0.0 0.0
   -2.7587378 -1.1121075 0.0 0.0 -1.2230647 -0.4051059 0.0 0.0 -3.2157192
   0.32484087 0.0 0.0 -1.2373956 0.20203619 0.0 0.0 -1.2855877 0.047533587 0.0
   0.0 -7.0765095 3.3624847 0.0 0.0 -8.429816 -1.1584246 0.0 0.0 -7.8006516
   0.9749658 0.0 0.0 -1.2389896 -0.5004033 0.0 0.0 -2.8139524 -0.051231395 0.0
   0.0 -2.792996 1.0744611 0.0 0.0 -6.9728456 -3.7445211 0.0 0.0 -7.9481997
   0.68766 0.0 0.0 -1.2601178 0.16871938 0.0 0.0 -1.2025341 0.42253554 0.0 0.0
   -7.559659 -2.1828575 0.0 0.0 -1.3169364 -0.20145872 0.0 0.0 -0.82676244
   -0.21183251 0.0 0.0 -7.874858 -0.7217197 0.0 0.0 -6.460618 4.862274 0.0 0.0
   -3.9226155 -0.25120842 0.0 0.0 -7.647248 3.033478 0.0 0.0 -1.4054674
   0.4960907 0.0 0.0 -3.5552113 -0.94352823 0.0 0.0 -3.2725217 -1.0615653 0.0
   0.0 -9.172054 -1.8357277 0.0 0.0 -2.9296288 -1.1570708 0.0 0.0 -3.4145865
   -0.30228794 0.0 0.0 -0.8244221 0.72396654 0.0 0.0 -19.691614 11.545186 0.0
   0.0 -7.7890277 3.4666348 0.0 0.0 -1.0530782 -0.6391561 0.0 0.0 -1.3853235
   -0.54807067 0.0 0.0 -3.1750307 -1.3587176 0.0 0.0 -2.6441069 1.0994843 0.0
   0.0 -8.559892 -2.2036054 0.0 0.0 -8.177945 -2.148611 0.0 0.0 -2.8289263
   -0.34947175 0.0 0.0 -25.271849 -3.8311682 0.0 0.0 -23.35312 5.6042533 0.0 0.0
   -1.4774388 -0.15803732 0.0 0.0 -2.8026357 -0.53046006 0.0 0.0 -23.34669
   -3.2708018 0.0 0.0 -9.01906 -2.1135654 0.0 0.0 -8.231284 -4.697927 0.0 0.0
   -1.4105896 0.3711675 0.0 0.0 -8.518046 -0.7869024 0.0 0.0 -1.4124036
   -0.17343742 0.0 0.0 -1.4780406 0.16574503 0.0 0.0 -3.0776503 0.82942784 0.0
   0.0 -8.4076605 -2.5047243 0.0 0.0 -3.1227064 1.0979488 0.0 0.0 -8.504178
   1.9394267 0.0 0.0 -8.530519 1.8986471 0.0 0.0 -1.3109753 0.5784205 0.0 0.0
   -3.1970873 -0.15947033 0.0 0.0 -9.498652 -1.3265499 0.0 0.0 -29.838818
   -0.8916197 0.0 0.0 -3.6959062 -0.51982635 0.0 0.0 -25.629093 -2.4911177 0.0
   0.0 -3.343614 0.3041216 0.0 0.0 -3.233749 1.5212237 0.0 0.0 -2.7312374
   0.034104034 0.0 0.0 -8.485456 -2.7811303 0.0 0.0 -7.319773 5.3934727 0.0 0.0
   -24.257227 2.9985218 0.0 0.0 -8.909971 0.6490939 0.0 0.0 -10.053924 3.4955924
   0.0 0.0 -3.7379737 -0.8411886 0.0 0.0 -0.82640547 0.73814416 0.0 0.0
   -1.4104098 0.44345823 0.0 0.0 -9.517067 -1.5704682 0.0 0.0 -8.977768
   0.87010944 0.0 0.0 -3.1770866 0.7846809 0.0 0.0 -3.6582053 -1.1429363 0.0 0.0
   -24.904905 3.8660796 0.0 0.0 -8.946929 1.1142062 0.0 0.0 -1.4053125
   0.28436822 0.0 0.0 -3.6182597 0.45732465 0.0 0.0 -1.3965863 0.036882844 0.0
   0.0 -3.183629 1.4442723 0.0 0.0 -24.469488 -13.091957 0.0 0.0 -3.6380663
   -0.83550924 0.0 0.0 -1.4828423 0.15160878 0.0 0.0 -10.495422 -0.2380495 0.0
   0.0 -3.055537 -1.1831145 0.0 0.0 -8.506884 -2.4772427 0.0 0.0 -27.909407
   -3.7921402 0.0 0.0 -1.1147493 0.29077747 0.0 0.0 -9.121664 2.8744085 0.0 0.0
   -2.8572726 -0.8635402 0.0 0.0 -8.991129 -1.7767019 0.0 0.0 -3.342609
   -0.43533337 0.0 0.0 -1.4690078 -0.0051154904 0.0 0.0 -1.4057295 0.43966785
   0.0 0.0 -1.4217584 0.3699316 0.0 0.0 -3.2259812 0.6918316 0.0 0.0 -3.6549146
   -1.3881366 0.0 0.0 -28.329283 -0.6628691 0.0 0.0 -3.0633173 -1.8666836 0.0
   0.0 -3.4032273 1.1657726 0.0 0.0 -9.629573 -3.92129 0.0 0.0 -1.4474086
   0.32547918 0.0 0.0 -9.244633 -2.887204 0.0 0.0 -9.682917 -3.5505888 0.0 0.0
   -0.96125984 -0.43006468 0.0 0.0 -3.354114 -1.4194354 0.0 0.0 -27.403666
   2.97009 0.0 0.0 -9.062038 3.307197 0.0 0.0 -9.360627 -1.5853726 0.0 0.0
   -3.4115028 -1.166197 0.0 0.0 -1.337376 -0.0057718605 0.0 0.0 -4.1381507
   -0.23821941 0.0 0.0 -8.686426 4.502857 0.0 0.0 -9.244767 -3.1566894 0.0 0.0
   -3.5118408 1.038506 0.0 0.0 -1.1074817 0.66463757 0.0 0.0 -1.3684285
   -0.21231902 0.0 0.0 -25.827663 14.293895 0.0 0.0 -27.840178 -10.633002 0.0
   0.0 -1.4341952 -0.4015741 0.0 0.0 -9.169797 2.3053808 0.0 0.0 -3.5788472
   1.1099129 0.0 0.0 -34.353065 -3.0085583 0.0 0.0 -3.6682045 1.2870308 0.0 0.0
   -1.3101707 -0.30505988 0.0 0.0 -10.080431 -1.318281 0.0 0.0 -27.411264
   6.870429 0.0 0.0 -1.1638709 -0.32492596 0.0 0.0 -1.2558411 -0.6607568 0.0 0.0
   -0.91974276 1.158076 0.0 0.0 -3.7177002 0.25120562 0.0 0.0 -1.5462937
   0.3861017 0.0 0.0 -1.2770895 0.10654622 0.0 0.0 -3.5048428 0.9242082 0.0 0.0
   -7.2090583 3.9977105 0.0 0.0 -8.82595 6.9570074 0.0 0.0 -27.789867 10.04477
   0.0 0.0 -9.212566 -3.8880098 0.0 0.0 -4.001933 -0.30369624 0.0 0.0 -2.637503
   -0.9636861 0.0 0.0 -8.686264 4.401793 0.0 0.0 -4.0465074 -0.47306266 0.0 0.0
   -9.078947 -3.088459 0.0 0.0 -3.0671039 -2.6826305 0.0 0.0 -27.864414
   -11.369677 0.0 0.0 -21.835587 -21.131659 0.0 0.0 -9.8669405 4.032442 0.0 0.0
   -3.230324 -1.2829763 0.0 0.0 -29.609793 2.3593357 0.0 0.0 -33.557266
   -5.5530334 0.0 0.0 -30.96103 0.4038718 0.0 0.0 -2.580271 -2.7543721 0.0 0.0
   -3.4481604 -0.39767936 0.0 0.0 -1.4270828 -0.07264629 0.0 0.0 -9.839626
   -2.322662 0.0 0.0 -10.063956 1.7197238 0.0 0.0 -9.92196 -3.5204065 0.0 0.0
   -10.088159 0.7778772 0.0 0.0 -3.7106225 -1.55719 0.0 0.0 -1.4183924
   -0.03272856 0.0 0.0 -1.401911 -0.067107335 0.0 0.0 -10.06441 1.6372229 0.0
   0.0 -9.388206 -4.818711 0.0 0.0 -3.8469522 -0.7519534 0.0 0.0 -3.9534671
   1.1479206 0.0 0.0 -1.220503 0.14889805 0.0 0.0 -1.2012421 -0.43276796 0.0 0.0
   -10.345998 1.9454851 0.0 0.0 -46.10633 -9.465002 0.0 0.0 -2.6844113
   -1.1380792 0.0 0.0 -11.709023 -0.41513246 0.0 0.0 -3.7533624 0.8496592 0.0
   0.0 -28.185904 -5.1902413 0.0 0.0 -41.437073 3.682268 0.0 0.0 -10.739117
   2.2387638 0.0 0.0 -1.4716734 -0.19479394 0.0 0.0 -3.6361713 -0.9220476 0.0
   0.0 -31.47728 -3.5942652 0.0 0.0 -32.22472 -1.0078198 0.0 0.0 -10.4465685
   -1.4336221 0.0 0.0 -1.2535772 0.41632026 0.0 0.0 -1.2840238 -0.696156 0.0 0.0
   -9.415507 -6.564497 0.0 0.0 -1.3402495 -0.41494474 0.0 0.0 -1.4117265
   0.11684735 0.0 0.0 -11.675966 0.89848465 0.0 0.0 -1.3173605 -0.252907 0.0 0.0
   -1.1500297 -0.61130977 0.0 0.0 -4.125876 -0.12107175 0.0 0.0 -3.0975413
   0.17713253 0.0 0.0 -3.5736046 -1.2933091 0.0 0.0 -10.710351 5.177132 0.0 0.0
   -28.644272 -16.884691 0.0 0.0 -1.4521313 0.11291887 0.0 0.0 -32.420025
   -9.040438 0.0 0.0 -1.3786935 -0.28125507 0.0 0.0 -11.007079 -4.5045414 0.0
   0.0 -3.5741823 -0.13420324 0.0 0.0 -3.7726045 0.1629839 0.0 0.0 -1.3947968
   -0.29801506 0.0 0.0 -32.342175 9.008304 0.0 0.0 -13.893719 0.9877748 0.0 0.0
   -10.286556 2.7792473 0.0 0.0 -1.4907752 -0.02978557 0.0 0.0 -11.039428
   3.4427402 0.0 0.0 -1.4031801 -0.31401828 0.0 0.0 -9.240716 4.7654514 0.0 0.0
   -11.524695 0.32309225 0.0 0.0 -4.0472274 -1.185473 0.0 0.0 -11.04004
   -0.62965596 0.0 0.0 -3.5448275 1.2688898 0.0 0.0 -10.799336 3.0750296 0.0 0.0
   -1.4732382 -0.20793147 0.0 0.0 -1.4887747 -0.10389792 0.0 0.0 -11.40848
   -3.9330692 0.0 0.0 -1.4339503 -0.24074085 0.0 0.0 -3.4586203 -1.1916738 0.0
   0.0 -1.3732713 -0.1788591 0.0 0.0 -4.0636606 -0.7017894 0.0 0.0 -1.4053283
   -0.4806449 0.0 0.0 -1.323918 0.5424222 0.0 0.0 -3.6182234 -0.015300685 0.0
   0.0 -1.3560024 0.48174942 0.0 0.0 -3.2253654 1.5475706 0.0 0.0 -3.1540818
   -2.5809999 0.0 0.0 -3.9837914 -1.1704754 0.0 0.0 -12.770209 -2.0847237 0.0
   0.0 -1.3687183 0.48427638 0.0 0.0 -11.556171 -1.0145812 0.0 0.0 -1.4752178
   0.19957092 0.0 0.0 -3.930238 0.6329839 0.0 0.0 -1.4351425 -0.06577904 0.0 0.0
   -29.68619 27.690584 0.0 0.0 -3.9177115 -0.2192461 0.0 0.0 -11.978983
   -1.5091164 0.0 0.0 -1.4470521 -0.16835003 0.0 0.0 -36.266655 -0.086257875 0.0
   0.0 -11.491355 2.005394 0.0 0.0 -12.548124 -0.61743784 0.0 0.0 -1.3690058
   -0.12814847 0.0 0.0 -4.34267 0.90911084 0.0 0.0 -1.364051 0.5034118 0.0 0.0
   -3.6605082 -0.5566953 0.0 0.0 -13.092783 2.6918223 0.0 0.0 -4.0791097
   0.8498437 0.0 0.0 -10.944158 3.291977 0.0 0.0 -11.7902565 0.34928474 0.0 0.0
   -4.276716 -1.4788357 0.0 0.0 -3.4883146 -0.74214655 0.0 0.0 -1.2993455
   0.39659968 0.0 0.0 -3.267338 1.7759972 0.0 0.0 -11.414593 -1.3811816 0.0 0.0
   -1.172787 0.78304154 0.0 0.0 -4.0969586 0.49495336 0.0 0.0 -3.7138226
   0.963399 0.0 0.0 -3.6887033 -1.628877 0.0 0.0 -12.690759 2.3085203 0.0 0.0
   -1.4299084 0.33247638 0.0 0.0 -3.7484984 -1.4424732 0.0 0.0 -9.23892
   -2.6459825 0.0 0.0 -1.1702178 0.81667084 0.0 0.0 -12.27403 -3.1686532 0.0 0.0
   -38.488335 10.625584 0.0 0.0 -11.542563 4.8161016 0.0 0.0 -3.933895 1.6719763
   0.0 0.0 -11.904979 0.6635768 0.0 0.0 -12.925745 -3.3342023 0.0 0.0 -1.4520068
   -0.15108734 0.0 0.0 -1.3341519 -0.59305257 0.0 0.0 -3.676982 1.4046364 0.0
   0.0 -34.291122 -17.753595 0.0 0.0 -1.3902891 0.5315429 0.0 0.0 -13.165364
   1.5454212 0.0 0.0 -11.011286 4.149513 0.0 0.0 -1.469574 0.1013191 0.0 0.0
   -3.5471363 -1.8893224 0.0 0.0 -1.4062158 -0.17562304 0.0 0.0 -0.56627977
   0.43565077 0.0 0.0 -1.3970538 -0.12814908 0.0 0.0 -4.420857 0.5327281 0.0 0.0
   -1.1633078 -0.50163674 0.0 0.0 -38.957417 15.458797 0.0 0.0 -1.4125215
   0.07297084 0.0 0.0 -13.306846 2.039527 0.0 0.0 -8.106201 -8.378434 0.0 0.0
   -1.2556356 0.2890206 0.0 0.0 -3.4250622 1.9694387 0.0 0.0 -1.2292138
   -0.43829843 0.0 0.0 -1.4790744 -0.052739576 0.0 0.0 -13.765174 -0.5309446 0.0
   0.0 -47.613937 7.1436043 0.0 0.0 -13.591277 -3.069333 0.0 0.0 -3.9980938
   -0.2511878 0.0 0.0 -1.3648775 -0.47682613 0.0 0.0 -38.519173 23.184553 0.0
   0.0 -10.800927 -5.4853177 0.0 0.0 -4.477673 -0.20346254 0.0 0.0 -11.987443
   3.4340963 0.0 0.0 -3.8272097 1.7338238 0.0 0.0 -13.369161 0.49270275 0.0 0.0
   -12.454517 -5.300834 0.0 0.0 -3.0819683 2.2928164 0.0 0.0 -1.4880121
   -0.08521942 0.0 0.0 -3.8082087 0.13917986 0.0 0.0 -1.2337464 0.51066184 0.0
   0.0 -13.4766865 -3.3665724 0.0 0.0 -1.1734906 0.5219716 0.0 0.0 -1.388322
   0.46949762 0.0 0.0 -52.748417 -1.4840628 0.0 0.0 -1.4594762 -0.0070249843 0.0
   0.0 -1.1957066 -0.7008424 0.0 0.0 -12.3909 -2.563866 0.0 0.0 -1.4429235
   0.22860129 0.0 0.0 -15.033418 -3.8277235 0.0 0.0 -3.6309485 1.3685788 0.0 0.0
   -1.4167616 -0.0028336644 0.0 0.0 -12.399594 0.5915263 0.0 0.0 -4.0100727
   -1.2469109 0.0 0.0 -45.934284 -9.35579 0.0 0.0 -10.579205 9.357056 0.0 0.0
   -4.5714054 0.22760269 0.0 0.0 -1.4726712 0.14053726 0.0 0.0 -39.97078
   18.509928 0.0 0.0 -3.8500717 -0.5765818 0.0 0.0 -45.315594 -2.992978 0.0 0.0
   -1.150248 0.53662264 0.0 0.0 -1.383416 -0.19900748 0.0 0.0 -1.3952737
   -0.23742257 0.0 0.0 -42.921597 -12.056427 0.0 0.0 -14.054119 -1.6774715 0.0
   0.0 -17.5075 4.2671356 0.0 0.0 -1.3650675 0.23054035 0.0 0.0 -3.580127
   1.4004397 0.0 0.0 -54.86965 -12.465814 0.0 0.0 -1.4842682 0.07898645 0.0 0.0
   -43.300106 13.006524 0.0 0.0 -1.4497322 0.056681227 0.0 0.0 -44.566223
   -1.3728584 0.0 0.0 -1.3389893 -0.40894535 0.0 0.0 -1.1635518 -0.619958 0.0
   0.0 -1.2967349 0.5038939 0.0 0.0 -13.762305 4.7385645 0.0 0.0 -3.9027114
   1.7603719 0.0 0.0 -4.184072 -0.594192 0.0 0.0 -4.62962 -0.25475875 0.0 0.0
   -1.4254657 -0.23233613 0.0 0.0 -4.003698 -0.095334075 0.0 0.0 -13.276881
   0.52445096 0.0 0.0 -12.492975 3.5198514 0.0 0.0 -3.6847272 -0.90367776 0.0
   0.0 -13.287083 1.6329877 0.0 0.0 -4.268547 -0.75172466 0.0 0.0 -13.030305
   -0.69377357 0.0 0.0 -12.816878 5.485917 0.0 0.0 -1.446607 0.4175753 0.0 0.0
   -1.212581 0.53294015 0.0 0.0 -13.7357645 6.3713856 0.0 0.0 -13.825847
   -2.2179713 0.0 0.0 -14.865021 3.6037412 0.0 0.0 -4.894137 1.5785428 0.0 0.0
   -1.4527258 0.0021263806 0.0 0.0 -13.412514 5.008689 0.0 0.0 -49.63776
   -20.528301 0.0 0.0 -11.952209 9.034414 0.0 0.0 -0.9480506 0.01917085 0.0 0.0
   -1.3357106 -0.13399692 0.0 0.0 -1.2442338 -0.30351126 0.0 0.0 -3.752562
   1.179994 0.0 0.0 -13.498238 2.396934 0.0 0.0 -3.555538 -1.5885717 0.0 0.0
   -4.224254 -0.521064 0.0 0.0 -14.971682 -2.0896137 0.0 0.0 -13.439301
   -3.4712143 0.0 0.0 -4.745728 0.4216851 0.0 0.0 -12.6010895 6.0513935 0.0 0.0
   -12.67708 -5.7033386 0.0 0.0 -14.229803 4.2812796 0.0 0.0 -1.4371625
   -0.24399225 0.0 0.0 -3.9513316 -0.5659854 0.0 0.0 -1.4745128 0.01588843 0.0
   0.0 -1.1861773 -0.4306677 0.0 0.0 -1.3851328 0.027071156 0.0 0.0 -5.4139805
   -0.24257079 0.0 0.0 -45.742588 18.180332 0.0 0.0 -1.3740389 0.32068405 0.0
   0.0 -1.2810643 -0.22421277 0.0 0.0 -1.411461 -0.42825392 0.0 0.0 -14.834602
   0.14213383 0.0 0.0 -4.27229 -1.7472724 0.0 0.0 -42.635235 26.620033 0.0 0.0
   -1.4765977 -0.18461938 0.0 0.0 -18.730528 4.951751 0.0 0.0 -3.3747892
   -1.8888831 0.0 0.0 -14.128635 0.31382364 0.0 0.0 -1.3495337 -0.4947854 0.0
   0.0 -4.458677 -1.6448852 0.0 0.0 -14.193278 -0.62607944 0.0 0.0 -1.0849516
   -0.9542178 0.0 0.0 -13.737825 3.234705 0.0 0.0 -15.486827 2.2327023 0.0 0.0
   -1.3910488 -0.41357207 0.0 0.0 -4.6905255 0.6895054 0.0 0.0 -4.2123427
   1.1595536 0.0 0.0 -13.843639 -5.501567 0.0 0.0 -1.0177019 0.940021 0.0 0.0
   -15.917521 0.7283983 0.0 0.0 -4.4283915 0.46059194 0.0 0.0 -15.722522
   -0.5183919 0.0 0.0 -1.3829476 0.1655789 0.0 0.0 -4.097269 -0.87656015 0.0 0.0
   -3.6197507 -1.9845147 0.0 0.0 -65.90737 -1.7234821 0.0 0.0 -4.005915 1.843267
   0.0 0.0 -3.251538 -0.14642632 0.0 0.0 -16.132376 -2.7075846 0.0 0.0 -15.2777
   4.7922435 0.0 0.0 -4.5608025 -0.45494786 0.0 0.0 -54.839535 -5.3734226 0.0
   0.0 -10.920883 8.880367 0.0 0.0 -16.198019 -2.417957 0.0 0.0 -52.775764
   -7.6592803 0.0 0.0 -51.760715 3.9060082 0.0 0.0 -4.0287104 0.9158489 0.0 0.0
   -4.4432335 0.97320473 0.0 0.0 -15.990756 1.0459677 0.0 0.0 -48.624756
   25.456305 0.0 0.0 -1.4680967 0.017046135 0.0 0.0 -11.843529 8.801801 0.0 0.0
   -1.3434153 -0.11141769 0.0 0.0 -3.7439318 2.661815 0.0 0.0 -4.1358724
   -1.0379815 0.0 0.0 -14.787836 0.36974666 0.0 0.0 -1.1928153 0.5922511 0.0 0.0
   -14.471487 -7.603229 0.0 0.0 -1.3790032 0.07266113 0.0 0.0 -1.4536692
   -0.039960157 0.0 0.0 -1.2635815 0.5832069 0.0 0.0 -15.007518 1.5723933 0.0
   0.0 -1.383473 -0.32757717 0.0 0.0 -14.96564 -0.43305302 0.0 0.0 -1.3974273
   -0.22891876 0.0 0.0 -4.8882723 0.54521966 0.0 0.0 -60.291546 25.99861 0.0 0.0
   -3.96842 1.6074594 0.0 0.0 -4.1571465 0.09967422 0.0 0.0 -4.1933126
   -0.3015138 0.0 0.0 -1.3817832 0.40420687 0.0 0.0 -1.372412 0.43289614 0.0 0.0
   -14.5476 1.8961159 0.0 0.0 -1.3891338 -0.5440304 0.0 0.0 -14.6044445
   -2.154317 0.0 0.0 -1.4063263 -0.46620706 0.0 0.0 -1.3743242 0.41653302 0.0
   0.0 -12.426278 10.1022215 0.0 0.0 -57.401756 -11.522103 0.0 0.0 -16.222013
   2.3442461 0.0 0.0 -1.1803094 -0.37804094 0.0 0.0 -1.4501204 0.21567397 0.0
   0.0 -15.478558 4.876457 0.0 0.0 -4.0189357 0.57071716 0.0 0.0 -1.3890089
   -0.20231815 0.0 0.0 -1.3766547 0.22955413 0.0 0.0 -1.3622739 -0.4360028 0.0
   0.0 -14.221462 -7.0314684 0.0 0.0 -1.4839078 -0.01911377 0.0 0.0 -3.0830035
   0.35544658 0.0 0.0 -0.92458874 -0.9313723 0.0 0.0 -4.1259956 -0.44508523 0.0
   0.0 -16.827436 -1.0208585 0.0 0.0 -15.086766 -0.83457863 0.0 0.0 -4.7746634
   0.6612812 0.0 0.0 -16.716349 -2.2661023 0.0 0.0 -1.4431179 -0.10840383 0.0
   0.0 -14.418744 -5.64653 0.0 0.0 -20.521952 2.4392488 0.0 0.0 -16.96111
   -3.0552728 0.0 0.0 -5.05282 -0.19952904 0.0 0.0 -1.2153882 -0.5080454 0.0 0.0
   -1.2820725 0.51711667 0.0 0.0 -2.8560693 -3.4849887 0.0 0.0 -56.361687
   -11.84299 0.0 0.0 -16.422207 -4.6511717 0.0 0.0 -58.198215 16.318604 0.0 0.0
   -1.3002567 -0.3364614 0.0 0.0 -15.119503 6.66927 0.0 0.0 -4.1452584
   -2.7128332 0.0 0.0 -4.2133827 -1.4753287 0.0 0.0 -4.0981526 0.94647694 0.0
   0.0 -58.209522 -7.341998 0.0 0.0 -1.4524947 0.2693365 0.0 0.0 -1.4671459
   -0.24222544 0.0 0.0 -1.4407066 -0.074695446 0.0 0.0 -4.062013 1.5388389 0.0
   0.0 -86.15428 -18.83572 0.0 0.0 -13.443795 9.195864 0.0 0.0 -3.7537897
   2.1095324 0.0 0.0 -1.1722306 -0.84637934 0.0 0.0 -1.4850678 0.05224325 0.0
   0.0 -13.687441 -10.302239 0.0 0.0 -1.3218309 0.6217059 0.0 0.0 -1.3236893
   0.21056269 0.0 0.0 -60.467426 4.93267 0.0 0.0 -3.9945688 -0.62969506 0.0 0.0
   -3.9642553 -1.88373 0.0 0.0 -16.237036 -2.8382447 0.0 0.0 -4.803693
   -0.6540354 0.0 0.0 -1.4436412 0.04604768 0.0 0.0 -1.1927778 0.49723026 0.0
   0.0 -16.242264 0.40474048 0.0 0.0 -60.781544 -3.8805468 0.0 0.0 -3.1018314
   2.583084 0.0 0.0 -1.2104794 -0.8556628 0.0 0.0 -4.2243395 1.4845427 0.0 0.0
   -3.7907124 -0.35299808 0.0 0.0 -15.812514 3.9237263 0.0 0.0 -58.698746
   -18.529797 0.0 0.0 -0.6890819 1.1990117 0.0 0.0 -15.975304 4.0880284 0.0 0.0
   -68.20708 48.553967 0.0 0.0 -16.213886 -1.8858482 0.0 0.0 -4.849809
   -0.48891565 0.0 0.0 -20.206106 -2.4208894 0.0 0.0 -1.0702626 -0.017931528 0.0
   0.0 -1.4355032 -0.3920741 0.0 0.0 -87.36291 -3.5786462 0.0 0.0 -1.354173
   -0.099488325 0.0 0.0 -1.3400053 -0.53294826 0.0 0.0 -4.576708 0.8458446 0.0
   0.0 -4.6368694 1.5833528 0.0 0.0 -4.2127237 2.2103605 0.0 0.0 -3.7565222
   1.9646208 0.0 0.0 -16.79348 -7.6741867 0.0 0.0 -17.803823 1.9651128 0.0 0.0
   -1.3308884 0.047621246 0.0 0.0 -4.5596914 -0.23340856 0.0 0.0 -20.460073
   2.6080463 0.0 0.0 -14.133681 -2.972367 0.0 0.0 -1.2828206 -0.010093719 0.0
   0.0 -18.263136 2.4915633 0.0 0.0 -1.03017 -0.8248585 0.0 0.0 -1.2286388
   -0.51892626 0.0 0.0 -16.81637 0.04184747 0.0 0.0 -1.3118316 0.12208699 0.0
   0.0 -4.12796 -1.2200698 0.0 0.0 -16.324495 0.838937 0.0 0.0 -17.489185
   -2.2321105 0.0 0.0 -16.555025 0.37720957 0.0 0.0 -4.6120586 -0.90110177 0.0
   0.0 -1.2834282 -0.27655992 0.0 0.0 -1.2602333 -0.44040415 0.0 0.0 -16.113197
   4.8076873 0.0 0.0 -21.168934 2.3648112 0.0 0.0 -14.527054 10.581522 0.0 0.0
   -1.3159562 -0.1482857 0.0 0.0 -1.3205678 -0.16014445 0.0 0.0 -4.813514
   -0.2879887 0.0 0.0 -15.714802 -7.2359424 0.0 0.0 -15.778913 5.684761 0.0 0.0
   -4.6564035 0.29823732 0.0 0.0 -5.306233 1.4694387 0.0 0.0 -18.451385
   -3.2956197 0.0 0.0 -1.0695665 0.77124697 0.0 0.0 -1.2843403 0.38158423 0.0
   0.0 -4.770557 -1.0198148 0.0 0.0 -1.2379162 0.4851276 0.0 0.0 -17.912273
   -3.5339 0.0 0.0 -4.630516 -0.9343733 0.0 0.0 -1.3361498 0.08741699 0.0 0.0
   -17.154165 2.6493034 0.0 0.0 -20.819471 -3.5663476 0.0 0.0 -5.0353518
   1.4905027 0.0 0.0 -17.365456 11.308812 0.0 0.0 -19.897453 4.0420914 0.0 0.0
   -17.215103 1.3746936 0.0 0.0 -4.2944603 0.88264346 0.0 0.0 -1.2686434
   -0.13251747 0.0 0.0 -0.63753235 1.1304909 0.0 0.0 -1.0819267 -0.62359923 0.0
   0.0 -17.177114 3.6480522 0.0 0.0 -1.3257022 -0.08921777 0.0 0.0 -1.3377852
   -0.067278616 0.0 0.0 -1.2966678 0.23043239 0.0 0.0 -3.8234637 2.8147697 0.0
   0.0 -0.9887953 0.525044 0.0 0.0 -4.6680155 1.0278702 0.0 0.0 -4.0130105
   2.0433626 0.0 0.0 -4.39703 -1.912861 0.0 0.0 -4.019102 1.665953 0.0 0.0
   -4.7693233 0.5829094 0.0 0.0 -17.49493 -1.8257269 0.0 0.0 -1.062252
   0.07399425 0.0 0.0 -4.7367983 0.95597625 0.0 0.0 -4.4339414 0.40237167 0.0
   0.0 -1.3402783 -0.037325375 0.0 0.0 -3.999987 -1.7573783 0.0 0.0 -4.404552
   -1.6163497 0.0 0.0 -19.522633 -5.3716183 0.0 0.0 -1.3213927 3.2179058e-4 0.0
   0.0 -1.3202246 0.08069418 0.0 0.0 -1.267159 0.11822194 0.0 0.0 -15.032662
   8.803616 0.0 0.0 -16.958527 5.5124125 0.0 0.0 -4.516644 -1.7832358 0.0 0.0
   -3.799388 2.3237195 0.0 0.0 -21.550365 9.041916 0.0 0.0 -20.815157 2.2395113
   0.0 0.0 -4.4340944 -0.52677554 0.0 0.0 -4.377642 -0.02179104 0.0 0.0
   -1.2354054 0.5178845 0.0 0.0 -4.317543 -2.058734 0.0 0.0 -18.46057 4.7020845
   0.0 0.0 -18.598516 1.3899293 0.0 0.0 -12.4724245 -12.496315 0.0 0.0 -1.313555
   -0.02861562 0.0 0.0 -24.219053 -0.12250973 0.0 0.0 -20.617222 -2.1303892 0.0
   0.0 -20.625326 -2.292806 0.0 0.0 -4.816266 0.9401439 0.0 0.0 -15.31617
   8.635259 0.0 0.0 -1.0629492 -0.23602363 0.0 0.0 -3.904668 1.3041656 0.0 0.0
   -16.247152 7.828258 0.0 0.0 -3.714228 -3.1682422 0.0 0.0 -17.029018
   -6.0594025 0.0 0.0 -1.2845953 0.23934568 0.0 0.0 -24.023039 -0.5192366 0.0
   0.0 -1.3018439 -0.32242364 0.0 0.0 -21.209614 -1.6305734 0.0 0.0 -4.2147264
   1.4847454 0.0 0.0 -4.5167394 0.3212248 0.0 0.0 -4.344738 1.2197816 0.0 0.0
   -18.78412 -3.3652728 0.0 0.0 -4.956756 0.13306132 0.0 0.0 -4.4907184
   2.1134331 0.0 0.0 -3.5223315 -2.8636415 0.0 0.0 -3.8462584 -2.31893 0.0 0.0
   -18.20784 -3.533482 0.0 0.0 -1.2496257 -0.43828225 0.0 0.0 -1.284167
   -0.0932025 0.0 0.0 -4.56153 2.5968475 0.0 0.0 -4.642944 -0.06540683 0.0 0.0
   -4.4288177 -0.57060313 0.0 0.0 -1.2180377 0.49988824 0.0 0.0 -1.2272305
   -0.3666273 0.0 0.0 -20.275259 -0.08553016 0.0 0.0 -1.1353077 0.6859544 0.0
   0.0 -20.273874 -3.401364 0.0 0.0 -4.332256 -0.79976827 0.0 0.0 -18.236166
   -2.2074072 0.0 0.0 -1.1798197 -0.6334026 0.0 0.0 -1.2852613 0.23919046 0.0
   0.0 -1.3305546 0.13153617 0.0 0.0 -4.711462 1.7177933 0.0 0.0 -5.044501
   0.44931397 0.0 0.0 -17.670721 5.44161 0.0 0.0 -0.86931574 0.97091264 0.0 0.0
   -4.4568667 0.22553834 0.0 0.0 -4.554871 -0.67784196 0.0 0.0 -21.22151
   3.9390805 0.0 0.0 -5.0734954 -1.3946608 0.0 0.0 -1.3168358 -0.13601452 0.0
   0.0 -1.2993245 -0.32927555 0.0 0.0 -23.624718 4.215967 0.0 0.0 -4.4887366
   -0.4414786 0.0 0.0 -5.038968 1.4773198 0.0 0.0 -4.8854733 -1.2019824 0.0 0.0
   -1.3832345 -0.004102271 0.0 0.0 -1.0726117 0.8043493 0.0 0.0 -18.887453
   -1.9889158 0.0 0.0 -4.5804033 -0.5530093 0.0 0.0 -4.687477 -1.1058569 0.0 0.0
   -1.2082994 -0.4921985 0.0 0.0 -1.3145285 -0.19271071 0.0 0.0 -1.2023747
   -0.40343115 0.0 0.0 -1.1557667 0.50636226 0.0 0.0 -3.9568822 -2.3231137 0.0
   0.0 -1.2840986 -0.38279158 0.0 0.0 -18.569796 -4.791638 0.0 0.0 -4.906347
   -1.2783697 0.0 0.0 -1.2966992 0.22994749 0.0 0.0 -19.51167 -2.7011585 0.0 0.0
   -1.2696859 -0.1600309 0.0 0.0 -1.2840087 0.35261104 0.0 0.0 -21.404034
   1.5530572 0.0 0.0 -18.91017 -2.6656559 0.0 0.0 -3.8396618 -2.1277997 0.0 0.0
   -1.329635 0.15994115 0.0 0.0 -22.217178 -5.4264517 0.0 0.0 -5.2880526
   0.52243525 0.0 0.0 -4.5078807 -0.38282812 0.0 0.0 -4.9308677 -0.21961136 0.0
   0.0 -4.8383746 -1.3072522 0.0 0.0 -4.8945193 -1.9520515 0.0 0.0 -4.7687345
   1.709388 0.0 0.0 -1.1968632 0.4171516 0.0 0.0 -1.3043479 -0.1982054 0.0 0.0
   -2.2536244 -4.6132717 0.0 0.0 -17.151703 -9.950963 0.0 0.0 -3.8572037
   -3.1846614 0.0 0.0 -21.85436 -0.38116756 0.0 0.0 -4.5520725 0.9737156 0.0 0.0
   -20.136967 -0.8223076 0.0 0.0 -1.2546704 0.37267816 0.0 0.0 -1.2365444
   0.36575255 0.0 0.0 -35.028873 -13.746046 0.0 0.0 -5.2780147 0.19695371 0.0
   0.0 -1.3405099 -0.008590421 0.0 0.0 -1.2703862 -0.120009676 0.0 0.0
   -1.2432656 -0.18209887 0.0 0.0 -17.157528 9.497706 0.0 0.0 -27.54421
   3.7490025 0.0 0.0 -22.10739 -1.5030954 0.0 0.0 -6.5456476 0.33735818 0.0 0.0
   -1.2792771 0.39507106 0.0 0.0 -18.711672 -6.9279075 0.0 0.0 -1.2018653
   -0.45154724 0.0 0.0 -1.3037755 -0.08616562 0.0 0.0 -4.8659005 0.46128353 0.0
   0.0 -3.3859358 3.340955 0.0 0.0 -1.3166095 -0.18974786 0.0 0.0 -19.271347
   4.7123036 0.0 0.0 -20.092543 -0.5957028 0.0 0.0 -1.3022141 -0.31459352 0.0
   0.0 -4.596641 1.3717346 0.0 0.0 -20.875593 7.6006827 0.0 0.0 -1.2833799
   -0.47955796 0.0 0.0 -25.623322 2.5831215 0.0 0.0 -1.3358523 -0.08187626 0.0
   0.0 -20.554585 -2.265098 0.0 0.0 -1.3118128 -0.10837442 0.0 0.0 -0.56354165
   0.6464449 0.0 0.0 -21.64812 -2.982261 0.0 0.0 -4.698521 1.3096055 0.0 0.0
   -4.2439237 -3.0586696 0.0 0.0 -4.642054 0.87746525 0.0 0.0 -20.899002
   0.43789846 0.0 0.0 -4.1140347 3.2410176 0.0 0.0 -5.1164823 1.1045834 0.0 0.0
   -5.024399 0.15983658 0.0 0.0 -4.229581 -1.9532049 0.0 0.0 -5.7018037
   -0.5729226 0.0 0.0 -1.2394336 -0.5020116 0.0 0.0 -4.645158 0.23752706 0.0 0.0
   -1.2539401 -0.19627975 0.0 0.0 -22.151226 0.81645924 0.0 0.0 -1.1497735
   -0.63209146 0.0 0.0 -4.7056556 -1.899485 0.0 0.0 -20.402082 0.33859554 0.0
   0.0 -1.2828302 0.015543008 0.0 0.0 -1.4565 -0.007317695 0.0 0.0 -20.46809
   -0.07982088 0.0 0.0 -5.298206 -0.41654554 0.0 0.0 -20.288118 -3.0123758 0.0
   0.0 -1.0686481 0.15832385 0.0 0.0 -5.0469065 -1.2287617 0.0 0.0 -24.047161
   5.9217978 0.0 0.0 -20.139135 5.4040728 0.0 0.0 -1.0146067 0.7953114 0.0 0.0
   -25.44986 1.1219931 0.0 0.0 -1.3135368 0.10022475 0.0 0.0 -20.641209
   1.2682564 0.0 0.0 -1.2527807 0.47333503 0.0 0.0 -22.911135 -9.918221 0.0 0.0
   -4.9090157 1.9746528 0.0 0.0 -4.953118 -1.5330905 0.0 0.0 -1.3201163
   0.046307143 0.0 0.0 -23.548029 -3.859025 0.0 0.0 -4.2839127 2.0113392 0.0 0.0
   -20.844765 0.48628882 0.0 0.0 -1.1623402 -0.5758148 0.0 0.0 -1.2674137
   0.43642816 0.0 0.0 -1.3382888 0.015243017 0.0 0.0 -17.700094 -11.66672 0.0
   0.0 -4.009268 2.6110265 0.0 0.0 -20.345615 -6.982373 0.0 0.0 -21.588179
   12.0293 0.0 0.0 -1.2623295 -0.28094682 0.0 0.0 -21.408457 4.368583 0.0 0.0
   -20.771944 12.968208 0.0 0.0 -1.3206073 0.14732473 0.0 0.0 -4.932307
   -1.2157427 0.0 0.0 -22.074858 4.35141 0.0 0.0 -1.189942 -0.4512309 0.0 0.0
   -1.1763587 0.39190197 0.0 0.0 -0.892506 -0.9649813 0.0 0.0 -1.3008803
   -0.11718104 0.0 0.0 -71.77968 63.578342 0.0 0.0 -1.4146568 -0.22943223 0.0
   0.0 -7.1366267 -1.1128992 0.0 0.0 -21.536974 5.661895 0.0 0.0 -1.4517615
   0.18953773 0.0 0.0 -24.912128 0.32317927 0.0 0.0 -6.680252 1.0882176 0.0 0.0
   -4.657647 -2.889541 0.0 0.0 -0.7890933 -0.8365439 0.0 0.0 -24.257887 6.114669
   0.0 0.0 -22.99162 -0.7921924 0.0 0.0 -5.559768 -0.36322376 0.0 0.0 -5.289806
   2.8378382 0.0 0.0 -4.94923 1.1410658 0.0 0.0 -5.556096 -0.030101372 0.0 0.0
   -4.7738996 -1.840483 0.0 0.0 -4.7904468 -2.0676842 0.0 0.0 -1.4637331
   -0.07414253 0.0 0.0 -93.270134 -31.78278 0.0 0.0 -4.3796825 2.0819907 0.0 0.0
   -96.93328 24.998533 0.0 0.0 -23.574448 5.6505876 0.0 0.0 -1.3419919
   0.032663763 0.0 0.0 -5.014843 -0.03694203 0.0 0.0 -4.6832943 -2.2006962 0.0
   0.0 -24.262856 5.861744 0.0 0.0 -99.572365 -5.591002 0.0 0.0 -1.2259148
   -0.71555895 0.0 0.0 -4.9849663 1.3596472 0.0 0.0 -21.379715 6.2589397 0.0 0.0
   -102.90397 -29.292166 0.0 0.0 -102.89544 6.473354 0.0 0.0 -1.2552358
   0.3645978 0.0 0.0 -21.452627 -13.049408 0.0 0.0 -5.2067084 0.70689696 0.0 0.0
   -4.8000875 -1.6518289 0.0 0.0 -21.478832 -9.111878 0.0 0.0 -4.4500294
   2.0926988 0.0 0.0 -6.11013 0.31945586 0.0 0.0 -22.76491 -7.490166 0.0 0.0
   -1.2472988 0.6259605 0.0 0.0 -118.72729 9.876343 0.0 0.0 -25.447773 3.2863805
   0.0 0.0 -5.5372844 2.734669 0.0 0.0 -5.287986 -0.6242244 0.0 0.0 -1.1745673
   0.39998704 0.0 0.0 -1.4279174 0.08792243 0.0 0.0 -1.2175926 0.29100397 0.0
   0.0 -5.7625813 -0.4069912 0.0 0.0 -22.768185 3.4248917 0.0 0.0 -24.546139
   1.7296016 0.0 0.0 -25.586517 3.939324 0.0 0.0 -23.878242 0.44682395 0.0 0.0
   -114.52691 -22.733562 0.0 0.0 -108.128456 -0.9062431 0.0 0.0 -6.169489
   0.42269638 0.0 0.0 -111.477745 25.1507 0.0 0.0 -1.3824574 -0.49497056 0.0 0.0
   -1.433093 0.40281627 0.0 0.0 -22.564262 -5.3511066 0.0 0.0 -1.4004982
   -0.2941639 0.0 0.0 -6.2103 -2.7892048 0.0 0.0 -21.84229 -8.216908 0.0 0.0
   -111.57542 -14.542713 0.0 0.0 -17.977795 -13.97531 0.0 0.0 -6.12306
   -1.0418205 0.0 0.0 -17.350151 15.245553 0.0 0.0 -23.168919 -0.009599031 0.0
   0.0 -23.932358 2.4646182 0.0 0.0 -1.3058962 0.28441328 0.0 0.0 -122.9894
   4.6736116 0.0 0.0 -1.3373045 -0.6189671 0.0 0.0 -1.2411786 0.79950964 0.0 0.0
   -20.241642 13.883598 0.0 0.0 -110.26351 40.50824 0.0 0.0 -1.3092668
   -0.06697947 0.0 0.0 -1.2610183 -0.5124407 0.0 0.0 -135.39859 -17.397379 0.0
   0.0 -5.5412326 -1.0208279 0.0 0.0 -1.2455107 0.06752642 0.0 0.0 -1.4212666
   -0.24490815 0.0 0.0 -0.96988213 -1.107192 0.0 0.0 -4.704406 -2.002121 0.0 0.0
   -97.248825 60.3089 0.0 0.0 -103.59306 41.49279 0.0 0.0 -1.419245 -0.16339466
   0.0 0.0 -109.43783 35.149696 0.0 0.0 -1.1821712 -0.74326885 0.0 0.0
   -5.6979117 -2.1767576 0.0 0.0 -1.2838823 -0.4088014 0.0 0.0 -96.58967
   -54.879166 0.0 0.0 -24.524015 9.939104 0.0 0.0 -1.3282714 0.41350394 0.0 0.0
   -1.0325801 -0.9671933 0.0 0.0 -4.9172664 -1.7381712 0.0 0.0 -5.7576394
   1.8255931 0.0 0.0 -1.1915176 0.5490492 0.0 0.0 -6.431446 0.19096746 0.0 0.0
   -1.4302338 -0.1322967 0.0 0.0 -1.3457533 0.5347229 0.0 0.0 -23.179956
   -8.507695 0.0 0.0 -4.8476024 -2.1684742 0.0 0.0 -1.4211015 -0.057193022 0.0
   0.0 -26.55126 -3.7949557 0.0 0.0 -6.1273327 -1.7506313 0.0 0.0 -108.744576
   -37.675312 0.0 0.0 -24.979685 1.5803057 0.0 0.0 -116.47527 47.813442 0.0 0.0
   -1.3996624 0.09184641 0.0 0.0 -1.4571347 0.11105625 0.0 0.0 -24.173136
   -3.2438505 0.0 0.0 -25.177958 -3.2437117 0.0 0.0 -114.68968 -1.8171618 0.0
   0.0 -1.342306 -0.32997677 0.0 0.0 -3.0504944 -4.1272407 0.0 0.0 -1.2418376
   0.66408527 0.0 0.0 -147.102 -6.9237714 0.0 0.0 -24.94438 2.8581066 0.0 0.0
   -88.430725 -72.1702 0.0 0.0 -1.6416799 -0.33806553 0.0 0.0 -6.263033
   -0.6876861 0.0 0.0 -28.7698 -3.9967656 0.0 0.0 -1.3922313 -0.3675189 0.0 0.0
   -25.684214 0.13831426 0.0 0.0 -6.0525975 -0.36605996 0.0 0.0 -5.536954
   0.47771928 0.0 0.0 -1.453225 0.30841866 0.0 0.0 -1.365841 -0.22530217 0.0 0.0
   -4.8927717 2.1298785 0.0 0.0 -4.387343 2.7837067 0.0 0.0 -30.360405 9.5990305
   0.0 0.0 -114.40713 20.81278 0.0 0.0 -23.296574 -8.526588 0.0 0.0 -1.3126602
   -0.58533543 0.0 0.0 -29.684984 10.41249 0.0 0.0 -116.035164 -14.594019 0.0
   0.0 -118.087975 12.371249 0.0 0.0 -24.893373 -3.3407326 0.0 0.0 -1.4664465
   -0.19651651 0.0 0.0 -26.36885 -5.3818803 0.0 0.0 -24.244024 6.299502 0.0 0.0
   -121.22005 -2.3597457 0.0 0.0 -4.1700025 3.4143066 0.0 0.0 -5.880025
   2.5502205 0.0 0.0 -26.0725 1.9430805 0.0 0.0 -5.497569 -1.6225111 0.0 0.0
   -27.800499 6.839533 0.0 0.0 -27.064495 2.2459056 0.0 0.0 -6.479596 0.23175555
   0.0 0.0 -25.952168 9.331195 0.0 0.0 -0.8118279 -1.2492259 0.0 0.0 -26.857204
   7.933866 0.0 0.0 -1.4641007 -0.22929925 0.0 0.0 -1.4831337 -0.009851668 0.0
   0.0 -136.9128 -17.412064 0.0 0.0 -5.3442135 0.16953145 0.0 0.0 -122.73987
   16.713978 0.0 0.0 -1.0573004 -0.91130257 0.0 0.0 -27.824541 5.387014 0.0 0.0
   -5.237277 1.1341335 0.0 0.0 -0.9354058 0.08415771 0.0 0.0 -1.2005669
   0.41621575 0.0 0.0 -1.2654285 0.6943011 0.0 0.0 -1.3112979 -0.42809474 0.0
   0.0 -6.221205 -2.1210747 0.0 0.0 -28.457449 7.715024 0.0 0.0 -21.69629
   -12.854273 0.0 0.0 -132.88193 6.8809276 0.0 0.0 -115.07429 -63.439255 0.0 0.0
   -1.4476303 0.2565034 0.0 0.0 -25.446665 3.6094031 0.0 0.0 -1.4408756
   0.09696343 0.0 0.0 -23.367912 -10.348848 0.0 0.0 -97.791756 78.06844 0.0 0.0
   -29.154434 -4.380462 0.0 0.0 -1.3736632 -0.39370602 0.0 0.0 -6.3682246
   0.6561401 0.0 0.0 -6.3886333 0.15022512 0.0 0.0 -1.4165212 0.20560692 0.0 0.0
   -30.544426 12.040764 0.0 0.0 -1.4186099 0.04504164 0.0 0.0 -1.4435911
   0.017714541 0.0 0.0 -5.8178825 -1.2175698 0.0 0.0 -155.93828 31.215574 0.0
   0.0 -5.5214896 -0.45144787 0.0 0.0 -26.043472 3.3569894 0.0 0.0 -25.555445
   0.81850874 0.0 0.0 -135.96758 -61.151028 0.0 0.0 -1.1828022 -0.6575797 0.0
   0.0 -4.3348627 -2.5021245 0.0 0.0 -1.3811389 0.21376419 0.0 0.0 -2.6534965
   2.247951 0.0 0.0 -6.3487577 1.4638234 0.0 0.0 -6.1703267 1.2643925 0.0 0.0
   -0.9768839 0.28174993 0.0 0.0 -23.026247 -11.878229 0.0 0.0 -0.9331913
   0.4100661 0.0 0.0 -1.3755388 -0.41949096 0.0 0.0 -6.244395 2.481142 0.0 0.0
   -1.1312556 -0.054627344 0.0 0.0 -1.0486943 0.19093807 0.0 0.0 -1.043361
   0.12851217 0.0 0.0 -26.443127 -11.432907 0.0 0.0 -1.2951206 -0.2725931 0.0
   0.0 -1.4574156 -0.0061797723 0.0 0.0 -26.27727 -11.944477 0.0 0.0 -1.2532084
   -0.75016075 0.0 0.0 -0.9651271 -0.98686624 0.0 0.0 -28.109097 -9.409433 0.0
   0.0 -126.89133 -26.86196 0.0 0.0 -6.1570168 -2.6073701 0.0 0.0 -1.4512833
   -0.31116375 0.0 0.0 -1.2218606 0.70522314 0.0 0.0 -5.530303 1.2202945 0.0 0.0
   -5.2364626 -2.9041271 0.0 0.0 -5.7369866 -0.06981097 0.0 0.0 -4.381601
   2.7700505 0.0 0.0 -26.429346 -5.8827224 0.0 0.0 -27.374947 11.6739 0.0 0.0
   -6.6140976 -1.343063 0.0 0.0 -5.222011 2.3552637 0.0 0.0 -130.87593 -59.50503
   0.0 0.0 -1.4384354 0.17700164 0.0 0.0 -1.4192917 -0.09053463 0.0 0.0
   -24.031282 11.999273 0.0 0.0 -38.3657 -3.573903 0.0 0.0 -27.618229 -2.117655
   0.0 0.0 -6.95776 -25.641914 0.0 0.0 -22.541542 15.461857 0.0 0.0 -6.4706984
   -1.1610464 0.0 0.0 -24.284857 18.07409 0.0 0.0 -6.184671 -2.332247 0.0 0.0
   -1.4698919 0.34228766 0.0 0.0 -1.4225847 0.17724223 0.0 0.0 -5.6577377
   -0.75636613 0.0 0.0 -1.257411 -0.6773605 0.0 0.0 -24.035467 -12.569792 0.0
   0.0 -1.4731468 -0.012497942 0.0 0.0 -136.09013 44.024082 0.0 0.0 -23.74586
   12.490233 0.0 0.0 -1.4354597 -0.31383 0.0 0.0 -28.247156 1.0461127 0.0 0.0
   -139.58966 -5.41274 0.0 0.0 -1.5973481 -0.58527994 0.0 0.0 -1.3717153
   -0.4756913 0.0 0.0 -5.215813 1.5107527 0.0 0.0 -6.082213 1.2620704 0.0 0.0
   -1.2710643 0.7526784 0.0 0.0 -5.2170386 1.6064596 0.0 0.0 -1.1024591
   -0.7199554 0.0 0.0 -4.9939814 -1.9201443 0.0 0.0 -137.23819 -5.2456493 0.0
   0.0 -25.683203 8.753183 0.0 0.0 -1.2538533 -0.76795286 0.0 0.0 -5.5366364
   1.2561871 0.0 0.0 -1.2436816 -0.09799724 0.0 0.0 -1.3663404 0.34036523 0.0
   0.0 -31.120829 3.7828674 0.0 0.0 -1.262419 0.5546478 0.0 0.0 -27.066523
   -13.559855 0.0 0.0 -1.2616616 -0.55283433 0.0 0.0 -35.240124 8.132613 0.0 0.0
   -5.77556 -2.3180437 0.0 0.0 -30.51807 -3.3911333 0.0 0.0 -28.266594 13.27563
   0.0 0.0 -176.25307 57.204926 0.0 0.0 -148.67226 -0.35145417 0.0 0.0
   -29.373121 -6.249425 0.0 0.0 -4.3961425 3.9219086 0.0 0.0 -1.3742846
   0.25100517 0.0 0.0 -3.1125636 -1.9441683 0.0 0.0 -1.3170929 0.36474115 0.0
   0.0 -22.285563 -15.9283905 0.0 0.0 -109.83367 89.140274 0.0 0.0 -1.4830751
   -0.10519099 0.0 0.0 -6.6894107 -1.6131327 0.0 0.0 -1.377321 -0.30725187 0.0
   0.0 -1.4484766 -0.010101721 0.0 0.0 -1.4056697 0.29056025 0.0 0.0 -1.3281361
   0.044992268 0.0 0.0 -6.4251523 -2.9648528 0.0 0.0 -1.4429873 0.003743142 0.0
   0.0 -1.4303036 -0.10264361 0.0 0.0 -1.273029 0.5461044 0.0 0.0 -1.2815987
   0.55709267 0.0 0.0 -119.570114 83.60037 0.0 0.0 -5.147599 0.4144115 0.0 0.0
   -34.934696 -2.1208923 0.0 0.0 -31.879147 -0.9392867 0.0 0.0 -22.03671
   -17.529943 0.0 0.0 -1.4586726 0.14590779 0.0 0.0 -1.4604628 -0.12366625 0.0
   0.0 -26.663597 9.15815 0.0 0.0 -6.862429 -0.9870289 0.0 0.0 -121.42104
   -80.09661 0.0 0.0 -5.5734158 2.336043 0.0 0.0 -135.09586 -54.953564 0.0 0.0
   -5.0203524 -3.8530502 0.0 0.0 -1.3862536 0.29669988 0.0 0.0 -5.597152
   -3.9505546 0.0 0.0 -153.23138 -55.339947 0.0 0.0 -1.2367064 -0.64778703 0.0
   0.0 -141.22215 40.826756 0.0 0.0 -17.847313 18.391806 0.0 0.0 -0.87043166
   0.4282302 0.0 0.0 -1.4438144 -0.3365257 0.0 0.0 -7.051815 1.0801094 0.0 0.0
   -29.418974 1.0914394 0.0 0.0 -31.18294 1.3151697 0.0 0.0 -6.5224476
   -0.38306725 0.0 0.0 -151.80653 33.53002 0.0 0.0 -5.5676455 -1.7707275 0.0 0.0
   -1.4207189 -0.12547928 0.0 0.0 -1.2191128 -0.78241134 0.0 0.0 -5.742506
   -0.21634792 0.0 0.0 -151.82742 -0.009346662 0.0 0.0 -1.1221489 -0.79371893
   0.0 0.0 -1.095557 0.5344043 0.0 0.0 -131.78635 -76.59632 0.0 0.0 -140.5764
   -53.254288 0.0 0.0 -29.24552 -1.0392965 0.0 0.0 -147.2263 -42.089695 0.0 0.0
   -1.261506 0.17811738 0.0 0.0 -5.786101 -0.9111383 0.0 0.0 -6.1727605
   1.7285652 0.0 0.0 -5.885224 -2.6744297 0.0 0.0 -5.6962404 -1.2868835 0.0 0.0
   -150.82924 -18.046839 0.0 0.0 -1.3916194 0.35438454 0.0 0.0 -5.5623775
   -1.5797926 0.0 0.0 -1.3907297 0.10978769 0.0 0.0 -156.63216 -59.048023 0.0
   0.0 -1.3946807 0.32276195 0.0 0.0 -1.3249105 -0.6030939 0.0 0.0 -34.223404
   -3.4559364 0.0 0.0 -1.3106244 -0.5884556 0.0 0.0 -29.024294 -13.567483 0.0
   0.0 -5.891995 2.9307976 0.0 0.0 -1.1789547 -0.50891614 0.0 0.0 -30.665445
   -5.530332 0.0 0.0 -194.51756 5.6747074 0.0 0.0 -155.75568 -44.57131 0.0 0.0
   -1.5624636 -0.41278863 0.0 0.0 -5.6997805 0.4514962 0.0 0.0 -4.7766123
   -0.44361934 0.0 0.0 -29.45607 0.5723353 0.0 0.0 -6.822148 -0.066826336 0.0
   0.0 -1.4170979 0.2787113 0.0 0.0 -30.81069 0.5499121 0.0 0.0 -36.198
   1.8714172 0.0 0.0 -6.201466 1.63569 0.0 0.0 -1.4558403 -0.29761 0.0 0.0
   -5.4279885 1.5936837 0.0 0.0 -1.4042561 -0.2691638 0.0 0.0 -5.229698
   2.4346805 0.0 0.0 -198.3829 -63.31189 0.0 0.0 -31.546886 -1.9558284 0.0 0.0
   -1.3970258 0.33124068 0.0 0.0 -1.3681809 0.17638879 0.0 0.0 -7.2736917
   -0.069419265 0.0 0.0 -33.653408 -3.5398405 0.0 0.0 -32.04521 3.703567 0.0 0.0
   -6.118363 -1.7154902 0.0 0.0 -6.8599224 2.4769154 0.0 0.0 -1.3018008
   -0.38860708 0.0 0.0 -1.2619599 0.050572757 0.0 0.0 -32.183155 1.0959003 0.0
   0.0 -5.172048 -2.921882 0.0 0.0 -155.81956 32.424152 0.0 0.0 -6.159491
   1.9527133 0.0 0.0 -192.61746 53.333527 0.0 0.0 -35.828922 -1.1354566 0.0 0.0
   -5.3392053 -0.2772274 0.0 0.0 -7.3542895 1.8828788 0.0 0.0 -31.674685
   -13.356077 0.0 0.0 -32.11697 0.42450842 0.0 0.0 -1.3951341 -0.089192234 0.0
   0.0 -4.6286826 3.4912817 0.0 0.0 -30.16923 8.130148 0.0 0.0 -31.045403
   -6.8010154 0.0 0.0 -39.268906 -8.530673 0.0 0.0 -32.096107 -10.287322 0.0 0.0
   -30.765112 -4.9878025 0.0 0.0 -6.254094 -2.9843931 0.0 0.0 -5.5585313
   2.005388 0.0 0.0 -4.8204684 -3.875711 0.0 0.0 -1.3666366 -0.4504806 0.0 0.0
   -1.4439992 0.102670096 0.0 0.0 -1.7775221 -0.2857874 0.0 0.0 -7.1648993
   0.93613404 0.0 0.0 -31.905378 -13.296325 0.0 0.0 -40.337982 -7.4707384 0.0
   0.0 -33.442604 -9.487458 0.0 0.0 -0.8779407 -0.2598057 0.0 0.0 -5.8733788
   -1.2734987 0.0 0.0 -1.0846748 0.65334827 0.0 0.0 -1.4035536 0.047217946 0.0
   0.0 -44.12658 0.6256347 0.0 0.0 -28.73662 18.158262 0.0 0.0 -30.260935
   5.9602637 0.0 0.0 -7.9119644 -0.9352191 0.0 0.0 -0.81212777 -0.36625847 0.0
   0.0 -0.9981623 -0.8880562 0.0 0.0 -5.88438 1.666095 0.0 0.0 -1.2252816
   0.50425124 0.0 0.0 -6.003673 0.42748278 0.0 0.0 -1.4266819 -0.4145065 0.0 0.0
   -6.2237496 4.195939 0.0 0.0 -1.392876 0.2566837 0.0 0.0 -5.610327 1.8176813
   0.0 0.0 -32.008614 -8.858093 0.0 0.0 -1.0839148 -0.34393996 0.0 0.0
   -1.4335827 -0.12157098 0.0 0.0 -6.4213967 0.29035506 0.0 0.0 -5.9872165
   1.3862903 0.0 0.0 -1.4390975 -0.45806375 0.0 0.0 -1.3903595 0.3334303 0.0 0.0
   -5.3257365 1.617071 0.0 0.0 -1.3490762 -0.34388012 0.0 0.0 -6.9044976
   0.10046837 0.0 0.0 -239.17505 -45.504112 0.0 0.0 -1.2738179 0.7915845 0.0 0.0
   -33.6712 -9.914905 0.0 0.0 -0.9469397 -0.67723423 0.0 0.0 -31.675335
   -3.7432775 0.0 0.0 -172.12842 -3.4077811 0.0 0.0 -30.541445 -11.241009 0.0
   0.0 -34.968346 -7.326047 0.0 0.0 -1.5351648 0.14169249 0.0 0.0 -1.2950746
   0.72026587 0.0 0.0 -1.383225 -0.46500304 0.0 0.0 -34.31242 -8.71137 0.0 0.0
   -41.49789 14.901244 0.0 0.0 -1.3913599 -0.080039024 0.0 0.0 -35.247528
   -8.908326 0.0 0.0 -34.04878 -3.9691224 0.0 0.0 -1.4103409 -0.2597315 0.0 0.0
   -222.96016 -39.189156 0.0 0.0 -5.5837793 2.0319905 0.0 0.0 -8.191207
   -2.6182175 0.0 0.0 -33.51824 -3.953621 0.0 0.0 -1.4649203 -0.16988407 0.0 0.0
   -1.4014349 -0.25480315 0.0 0.0 -33.797558 7.784169 0.0 0.0 -1.100881
   -0.88264537 0.0 0.0 -34.5489 -6.463861 0.0 0.0 -33.261223 7.836525 0.0 0.0
   -36.22924 -4.7215357 0.0 0.0 -1.3983321 -0.16825637 0.0 0.0 -6.254407
   -0.26991686 0.0 0.0 -5.409144 1.8851705 0.0 0.0 -28.99934 -14.383619 0.0 0.0
   -33.386463 -4.912905 0.0 0.0 -6.1977296 -0.04206789 0.0 0.0 -33.839905
   -5.0434427 0.0 0.0 -1.3328797 -0.31882927 0.0 0.0 -1.3432739 -0.37991655 0.0
   0.0 -189.96565 -22.083218 0.0 0.0 -7.7949815 2.7239087 0.0 0.0 -1.4332719
   -0.29152688 0.0 0.0 -1.3638909 0.5954815 0.0 0.0 -1.2601911 -0.08620807 0.0
   0.0 -1.4285417 0.4216215 0.0 0.0 -7.7038794 0.16122048 0.0 0.0 -1.3884829
   0.46061337 0.0 0.0 -5.4609547 -2.739891 0.0 0.0 -31.055368 -9.384552 0.0 0.0
   -35.344517 -1.9998039 0.0 0.0 -205.49515 -25.67841 0.0 0.0 -1.4639289
   -0.2578279 0.0 0.0 -201.25797 -23.32965 0.0 0.0 -182.36014 -47.97041 0.0 0.0
   -1.2125279 0.6352748 0.0 0.0 -257.89044 -68.52293 0.0 0.0 -32.806667 6.577754
   0.0 0.0 -198.76987 6.984862 0.0 0.0 -183.22179 -7.666718 0.0 0.0 -1.294962
   -0.054281782 0.0 0.0 -1.4142115 0.23518585 0.0 0.0 -28.84995 17.298498 0.0
   0.0 -6.522022 -0.22515142 0.0 0.0 -32.25946 -9.217244 0.0 0.0 -23.13643
   -25.808678 0.0 0.0 -1.3769968 -0.11282011 0.0 0.0 -1.3817061 0.34828195 0.0
   0.0 -6.748774 2.8988645 0.0 0.0 -7.2948284 1.5921212 0.0 0.0 -189.96895
   -68.46651 0.0 0.0 -31.464731 -26.248869 0.0 0.0 -5.5586395 2.820656 0.0 0.0
   -1.3534415 0.42054817 0.0 0.0 -33.13738 16.781143 0.0 0.0 -53.47822
   -18.378733 0.0 0.0 -47.084137 0.6443095 0.0 0.0 -5.152064 1.1425818 0.0 0.0
   -37.95952 -0.6300724 0.0 0.0 -7.1389966 1.0701109 0.0 0.0 -1.4640619
   0.0015342756 0.0 0.0 -1.3039397 -0.138562 0.0 0.0 -184.35754 -39.766685 0.0
   0.0 -0.89143753 0.8774358 0.0 0.0 -1.3406202 -0.10548404 0.0 0.0 -39.492584
   8.03795 0.0 0.0 -6.548138 -1.8655576 0.0 0.0 -6.448595 -2.0061843 0.0 0.0
   -0.8466667 -1.1442863 0.0 0.0 -195.14162 -24.539772 0.0 0.0 -6.5110598
   -2.0327752 0.0 0.0 -5.1939425 -3.5557487 0.0 0.0 -6.6573305 3.8370566 0.0 0.0
   -1.4532374 -0.032474216 0.0 0.0 -1.4233882 -0.20209894 0.0 0.0 -6.0185184
   1.2014209 0.0 0.0 -5.7343817 -3.6642218 0.0 0.0 -1.4565425 0.27415326 0.0 0.0
   -7.171184 -2.1470206 0.0 0.0 -6.3363404 -4.042065 0.0 0.0 -1.3983563
   0.46612555 0.0 0.0 -34.53264 -2.7975047 0.0 0.0 -7.468367 -1.2254163 0.0 0.0
   -35.498653 -7.790142 0.0 0.0 -148.61337 124.19851 0.0 0.0 -215.14297
   -79.99944 0.0 0.0 -6.7788286 -1.417995 0.0 0.0 -40.736805 3.818392 0.0 0.0
   -1.4852422 -0.02884286 0.0 0.0 -7.123706 -2.6586642 0.0 0.0 -34.38679
   6.2739305 0.0 0.0 -33.693787 -6.270885 0.0 0.0 -198.73705 7.6761827 0.0 0.0
   -225.07782 94.1714 0.0 0.0 -6.328942 -0.42540285 0.0 0.0 -1.3222576
   -0.66972524 0.0 0.0 -6.3954077 -0.15009421 0.0 0.0 -1.5508407 -0.3811243 0.0
   0.0 -1.249077 0.58242583 0.0 0.0 -329.5612 -103.16697 0.0 0.0 -1.3902261
   0.045459438 0.0 0.0 -1.2879286 -0.6745114 0.0 0.0 -38.117344 9.101013 0.0 0.0
   -7.3235884 -1.8851156 0.0 0.0 -34.072536 5.9416313 0.0 0.0 -166.1979
   108.74269 0.0 0.0 -1.2446338 0.6927591 0.0 0.0 -26.721283 -22.080814 0.0 0.0
   -1.4123319 -0.17082103 0.0 0.0 -1.4642446 -0.21426828 0.0 0.0 -6.015636
   1.923905 0.0 0.0 -36.025894 0.08509355 0.0 0.0 -0.94659156 -0.81155926 0.0
   0.0 -6.629718 2.0575008 0.0 0.0 -1.4808543 -0.13724743 0.0 0.0 -199.5005
   44.755146 0.0 0.0 -1.3985387 -0.37618512 0.0 0.0 -6.305815 -2.9344275 0.0 0.0
   -35.078197 -6.591599 0.0 0.0 -42.690643 -9.083864 0.0 0.0 -7.025553
   -0.3148684 0.0 0.0 -1.2908096 0.18690833 0.0 0.0 -1.3626474 0.28479883 0.0
   0.0 -180.54065 -92.608734 0.0 0.0 -1.2886304 -0.34791756 0.0 0.0 -1.2586058
   -0.6800808 0.0 0.0 -37.440926 -5.270697 0.0 0.0 -1.4184124 -0.33018157 0.0
   0.0 -35.491253 -14.291397 0.0 0.0 -1.3738679 -0.2645193 0.0 0.0 -1.3560989
   0.46911913 0.0 0.0 -1.7076051 -0.2903063 0.0 0.0 -215.65523 24.725182 0.0 0.0
   -1.4564551 -0.14809595 0.0 0.0 -1.7064534 0.5821052 0.0 0.0 -36.904396
   -10.351612 0.0 0.0 -6.3707166 2.9801898 0.0 0.0 -221.78763 -56.364105 0.0 0.0
   -40.351208 -3.3501906 0.0 0.0 -1.4027716 -0.044056922 0.0 0.0 -1.4020035
   -0.25827128 0.0 0.0 -1.2497492 -0.7960284 0.0 0.0 -1.2608078 0.36166227 0.0
   0.0 -6.7240787 3.2382214 0.0 0.0 -311.7779 -114.76971 0.0 0.0 -0.9925157
   -1.0656958 0.0 0.0 -1.4519303 0.075678036 0.0 0.0 -53.907646 -18.985378 0.0
   0.0 -1.4170929 -0.444951 0.0 0.0 -193.24037 80.194115 0.0 0.0 -1.0355253
   -0.9890045 0.0 0.0 -33.731026 -17.166561 0.0 0.0 -198.74902 43.739285 0.0 0.0
   -6.724218 -2.821187 0.0 0.0 -6.0359583 -2.0253334 0.0 0.0 -5.8557324
   2.3153708 0.0 0.0 -1.3571752 0.08820432 0.0 0.0 -1.3781934 0.14986117 0.0 0.0
   -7.024658 0.6754941 0.0 0.0 -2.5239244 -4.750966 0.0 0.0 -1.4411451
   0.14165595 0.0 0.0 -32.95784 -16.34634 0.0 0.0 -193.5603 -87.51373 0.0 0.0
   -7.4798646 1.2188026 0.0 0.0 -34.41346 -11.1559925 0.0 0.0 -42.751137
   11.023401 0.0 0.0 -1.2628698 0.8047765 0.0 0.0 -36.34622 -1.154903 0.0 0.0
   -1.2435118 -0.7652552 0.0 0.0 -1.4758596 0.14344564 0.0 0.0 -1.3151758
   -0.25509414 0.0 0.0 -38.16093 8.30291 0.0 0.0 -7.7021804 -0.47988915 0.0 0.0
   -43.411385 -11.255884 0.0 0.0 -250.90744 -113.915726 0.0 0.0 -37.787292
   -19.986914 0.0 0.0 -1.4070201 -0.2593969 0.0 0.0 -6.6193805 -2.1842337 0.0
   0.0 -43.564228 -3.1369715 0.0 0.0 -31.019176 -25.438774 0.0 0.0 -29.99504
   -21.810041 0.0 0.0 -203.02507 87.38758 0.0 0.0 -7.864085 0.5825186 0.0 0.0
   -1.2206839 0.8159356 0.0 0.0 -1.4686261 0.2459046 0.0 0.0 -7.7167163
   0.9026933 0.0 0.0 -34.767838 19.923777 0.0 0.0 -4.787678 5.2268295 0.0 0.0
   -6.467846 -0.29260448 0.0 0.0 -1.416801 -0.32017666 0.0 0.0 -1.3763536
   0.5079251 0.0 0.0 -1.3374736 0.10423615 0.0 0.0 -1.37891 0.23928645 0.0 0.0
   -244.38937 16.321157 0.0 0.0 -32.911163 17.208652 0.0 0.0 -1.2134339
   -0.07243808 0.0 0.0 -4.3201923 -3.1287417 0.0 0.0 -7.057004 2.8567808 0.0 0.0
   -39.807953 2.6266718 0.0 0.0 -220.19278 -26.021643 0.0 0.0 -7.9146423
   -0.4422138 0.0 0.0 -8.1664505 1.6452597 0.0 0.0 -7.972384 -0.8605318 0.0 0.0
   -7.6598797 -1.8428426 0.0 0.0 -6.394596 -1.319287 0.0 0.0 -30.20468
   -27.048834 0.0 0.0 -1.3731784 0.35185382 0.0 0.0 -6.6544433 -0.7372325 0.0
   0.0 -0.9517904 -0.7667738 0.0 0.0 -1.4390315 -0.0011885986 0.0 0.0 -8.516864
   0.81023216 0.0 0.0 -39.84092 -14.1376 0.0 0.0 -236.77382 18.169552 0.0 0.0
   -39.28078 -8.975862 0.0 0.0 -48.672707 0.12813158 0.0 0.0 -1.4913876
   9.3867956e-4 0.0 0.0 -1.3228862 -0.5338172 0.0 0.0 -308.45605 50.767864 0.0
   0.0 -1.4032843 0.46194965 0.0 0.0 -39.14625 14.434125 0.0 0.0 -38.183426
   9.130529 0.0 0.0 -8.019049 -2.3553684 0.0 0.0 -46.9965 2.6775596 0.0 0.0
   -228.05331 -61.68295 0.0 0.0 -7.591319 -0.9186344 0.0 0.0 -62.41387 -18.69651
   0.0 0.0 -1.3790396 -0.19112343 0.0 0.0 -6.615635 0.8357851 0.0 0.0 -6.17285
   2.1528163 0.0 0.0 -1.4287146 0.020982483 0.0 0.0 -38.392643 9.751871 0.0 0.0
   -1.1800703 0.23022181 0.0 0.0 -283.03986 -119.889145 0.0 0.0 -1.2668705
   0.71970165 0.0 0.0 -1.2596288 0.7780574 0.0 0.0 -33.3415 5.3080554 0.0 0.0
   -0.72710997 0.051224142 0.0 0.0 -6.614922 -0.20780842 0.0 0.0 -1.1005818
   -1.0035884 0.0 0.0 -1.4638419 0.13096525 0.0 0.0 -238.09695 -75.60833 0.0 0.0
   -4.8671417 -4.255449 0.0 0.0 -247.64803 -60.70518 0.0 0.0 -37.456528
   10.880259 0.0 0.0 -37.68246 11.069114 0.0 0.0 -6.769113 2.927356 0.0 0.0
   -231.89256 54.519615 0.0 0.0 -1.4481783 0.010921224 0.0 0.0 -1.9637263
   0.24366008 0.0 0.0 -7.471189 0.092750154 0.0 0.0 -7.966591 1.8703717 0.0 0.0
   -7.8971877 2.1997237 0.0 0.0 -8.559539 -0.16160625 0.0 0.0 -1.2066988
   -0.7766339 0.0 0.0 -1.4341409 0.3723442 0.0 0.0 -38.940414 10.66177 0.0 0.0
   -1.479597 0.15864332 0.0 0.0 -1.1491501 0.3487654 0.0 0.0 -5.9032917
   3.0181212 0.0 0.0 -6.413042 -1.9873904 0.0 0.0 -38.28523 10.584677 0.0 0.0
   -40.91875 4.631504 0.0 0.0 -1.3691245 -0.4297836 0.0 0.0 -1.4056998
   0.35046026 0.0 0.0 -38.48914 7.1628366 0.0 0.0 -7.007806 2.956937 0.0 0.0
   -1.4521002 0.059313953 0.0 0.0 -1.348626 0.029496526 0.0 0.0 -215.34572
   -115.21026 0.0 0.0 -6.6872997 0.5146512 0.0 0.0 -1.4171618 -0.09130105 0.0
   0.0 -1.1059393 0.92970806 0.0 0.0 -39.342514 -6.6833158 0.0 0.0 -7.2799106
   2.1689005 0.0 0.0 -50.83307 3.973062 0.0 0.0 -6.690431 1.7951715 0.0 0.0
   -7.4032884 -0.03292087 0.0 0.0 -1.0033171 1.0684716 0.0 0.0 -7.093275
   1.5501488 0.0 0.0 -20.564407 -25.181332 0.0 0.0 -230.53867 -90.18218 0.0 0.0
   -244.52574 106.76367 0.0 0.0 -37.45903 16.515476 0.0 0.0 -1.200628 -0.7027359
   0.0 0.0 -38.021152 -13.845541 0.0 0.0 -29.403765 26.501915 0.0 0.0 -39.235153
   10.2101345 0.0 0.0 -6.478547 -1.6557419 0.0 0.0 -40.539932 -11.377484 0.0 0.0
   -39.262886 -14.802059 0.0 0.0 -6.647186 1.6392053 0.0 0.0 -40.962994
   -18.046587 0.0 0.0 -41.252144 -4.3804917 0.0 0.0 -1.317363 -0.5611578 0.0 0.0
   -1.383372 0.41369763 0.0 0.0 -6.889166 -1.150472 0.0 0.0 -36.458942
   -16.555141 0.0 0.0 -1.3934742 0.15623923 0.0 0.0 -282.05142 14.092789 0.0 0.0
   -1.2849327 0.3234156 0.0 0.0 -55.416 8.996804 0.0 0.0 -6.532281 -0.8918475
   0.0 0.0 -1.1726437 0.9425417 0.0 0.0 -1.3151249 0.6115081 0.0 0.0 -6.990102
   1.8998789 0.0 0.0 -1.2428161 -0.69474953 0.0 0.0 -1.1854224 0.51965845 0.0
   0.0 -246.34373 -66.397484 0.0 0.0 -292.09134 -129.67744 0.0 0.0 -38.274765
   14.4297085 0.0 0.0 -40.906376 21.28459 0.0 0.0 -6.5487514 -2.011263 0.0 0.0
   -8.142414 -1.5103817 0.0 0.0 -1.4239537 0.20259643 0.0 0.0 -37.425568
   -17.63089 0.0 0.0 -7.3682165 -1.5933962 0.0 0.0 -6.4332967 3.229644 0.0 0.0
   -44.240826 14.027186 0.0 0.0 -40.40479 5.1379175 0.0 0.0 -1.2721882
   0.12827021 0.0 0.0 -39.94329 -28.186195 0.0 0.0 -7.9667525 0.16541192 0.0 0.0
   -1.4054523 0.13937885 0.0 0.0 -1.3348265 0.2655737 0.0 0.0 -1.1548179
   -0.9397276 0.0 0.0 -247.07832 -81.83326 0.0 0.0 -33.889442 28.307087 0.0 0.0
   -1.4782398 -0.043474354 0.0 0.0 -8.238774 1.6883059 0.0 0.0 -6.5091825
   4.5895157 0.0 0.0 -51.095924 -9.505566 0.0 0.0 -6.6287074 1.9013357 0.0 0.0
   -1.3890136 0.05181679 0.0 0.0 -1.37897 -0.060983524 0.0 0.0 -8.450275
   -0.8887494 0.0 0.0 -1.3409803 -0.020574221 0.0 0.0 -1.2358238 -0.33005992 0.0
   0.0 -4.4293666 -5.1000795 0.0 0.0 -40.93204 4.661965 0.0 0.0 -1.2516857
   -0.29199374 0.0 0.0 -50.063686 11.4694 0.0 0.0 -1.3480026 -0.057552338 0.0
   0.0 -7.307001 3.309344 0.0 0.0 -6.809805 1.761095 0.0 0.0 -1.0231688
   0.38864917 0.0 0.0 -1.288617 0.21895212 0.0 0.0 -8.205233 0.7088802 0.0 0.0
   -7.416806 0.805805 0.0 0.0 -1.2808181 -0.3328075 0.0 0.0 -45.47692 -9.909665
   0.0 0.0 -1.2687082 0.429095 0.0 0.0 -32.772293 -25.602491 0.0 0.0 -1.3144158
   -0.08531496 0.0 0.0 -39.804096 -12.254044 0.0 0.0 -1.2813497 -0.22227281 0.0
   0.0 -1.0645658 0.69546366 0.0 0.0 -8.920285 -0.29135105 0.0 0.0 -1.0856744
   0.03268788 0.0 0.0 -6.8637342 -2.4433815 0.0 0.0 -0.9985573 0.5791736 0.0 0.0
   -6.2264347 2.5484557 0.0 0.0 -40.330982 -18.473003 0.0 0.0 -1.2238505
   0.44917297 0.0 0.0 -1.2518885 0.45571333 0.0 0.0 -54.80641 -2.6976612 0.0 0.0
   -1.206769 -0.56132936 0.0 0.0 -1.2680109 0.3543334 0.0 0.0 -1.1433711
   0.047563344 0.0 0.0 -48.51452 -12.203364 0.0 0.0 -1.202517 0.26159155 0.0 0.0
   -6.853396 -0.8405625 0.0 0.0 -6.928464 -1.7161313 0.0 0.0 -1.3399704
   -0.043602303 0.0 0.0 -45.48493 3.5886438 0.0 0.0 -42.236763 12.113118 0.0 0.0
   -1.1514344 0.59925693 0.0 0.0 -6.507817 1.9409226 0.0 0.0 -6.853651 0.6652011
   0.0 0.0 -7.302464 -1.3941739 0.0 0.0 -5.2339435 5.5116615 0.0 0.0 -1.0643623
   -0.77675 0.0 0.0 -44.564194 -6.424565 0.0 0.0 -40.07441 14.231887 0.0 0.0
   -7.697249 1.466463 0.0 0.0 -1.209585 0.57569885 0.0 0.0 -31.99632 -33.10257
   0.0 0.0 -1.2416326 0.48891935 0.0 0.0 -8.677961 -1.0516272 0.0 0.0 -40.67813
   -17.776022 0.0 0.0 -1.2834436 -0.07124194 0.0 0.0 -1.1542039 0.28906178 0.0
   0.0 -7.086199 -2.8497152 0.0 0.0 -1.2564663 0.37404415 0.0 0.0 -1.3361177
   -0.058102276 0.0 0.0 -1.2279925 0.59929025 0.0 0.0 -1.1171838 -0.64556456 0.0
   0.0 -7.3132815 -2.206777 0.0 0.0 -63.166862 -4.916905 0.0 0.0 -54.29026
   -0.702702 0.0 0.0 -1.2328532 -0.42628545 0.0 0.0 -1.111521 0.043503035 0.0
   0.0 -1.2132101 0.25600928 0.0 0.0 -1.3353103 -0.12529196 0.0 0.0 -40.23372
   -15.645491 0.0 0.0 -1.3196663 0.17951694 0.0 0.0 -1.3348562 0.06509338 0.0
   0.0 -7.614973 0.42005074 0.0 0.0 -5.8658395 -4.040849 0.0 0.0 -6.9624147
   -0.36948216 0.0 0.0 -1.3265971 -0.11279727 0.0 0.0 -6.5053096 -3.4055305 0.0
   0.0 -41.29525 -15.954012 0.0 0.0 -6.2459784 -3.1682906 0.0 0.0 -1.2251009
   0.41195375 0.0 0.0 -6.976864 0.6800581 0.0 0.0 -41.5898 20.041378 0.0 0.0
   -6.763572 -1.1044911 0.0 0.0 -7.0218997 -3.0765052 0.0 0.0 -36.582447
   28.327976 0.0 0.0 -6.8216333 -0.9374775 0.0 0.0 -9.754987 1.7167233 0.0 0.0
   -1.2522298 -0.34750706 0.0 0.0 -42.42047 -16.463034 0.0 0.0 -1.2764096
   0.18456583 0.0 0.0 -1.330486 -0.027020903 0.0 0.0 -47.66753 -12.681869 0.0
   0.0 -49.23689 14.542909 0.0 0.0 -7.0424123 1.903825 0.0 0.0 -0.99504274
   -0.985879 0.0 0.0 -7.9095683 -0.29671153 0.0 0.0 -6.14297 -5.236485 0.0 0.0
   -42.76533 -13.703336 0.0 0.0 -1.2585757 -0.3175363 0.0 0.0 -0.98513085
   0.47189564 0.0 0.0 -1.3366227 0.11491007 0.0 0.0 -1.5499284 -0.540884 0.0 0.0
   -7.2433195 -1.2183832 0.0 0.0 -1.3074309 -0.29913214 0.0 0.0 -6.4539814
   -2.4890625 0.0 0.0 -1.3246746 0.2021803 0.0 0.0 -1.302612 -0.017881135 0.0
   0.0 -1.3960342 0.1598253 0.0 0.0 -1.0957711 0.7492843 0.0 0.0 -1.3217232
   -0.052547574 0.0 0.0 -1.1641197 0.65593225 0.0 0.0 -42.664597 12.533193 0.0
   0.0 -1.4775476 0.018646859 0.0 0.0 -40.065292 26.796608 0.0 0.0 -1.2294288
   -0.25980407 0.0 0.0 -1.3826436 0.16488126 0.0 0.0 -1.3092662 0.28021044 0.0
   0.0 -7.7554216 0.21421658 0.0 0.0 -46.658604 -8.50081 0.0 0.0 -1.2115618
   0.52501 0.0 0.0 -5.554325 4.8365006 0.0 0.0 -43.682827 -9.849332 0.0 0.0
   -47.429058 -22.589287 0.0 0.0 -40.82039 1.6240367 0.0 0.0 -0.9859734
   -0.88150877 0.0 0.0 -51.607952 -0.94038 0.0 0.0 -1.2909521 -0.33525366 0.0
   0.0 -1.2670226 0.3185295 0.0 0.0 -44.963978 21.202742 0.0 0.0 -1.235767
   -0.46809837 0.0 0.0 -1.3002938 0.11809217 0.0 0.0 -7.3482823 3.3589158 0.0
   0.0 -1.0987966 -0.7696633 0.0 0.0 -6.954721 -3.1281207 0.0 0.0 -7.063076
   -1.7852691 0.0 0.0 -44.22837 -27.359125 0.0 0.0 -1.121525 -0.19822639 0.0 0.0
   -1.2886482 -0.047239386 0.0 0.0 -7.733511 -0.34674683 0.0 0.0 -45.83028
   11.073268 0.0 0.0 -46.284058 0.9104646 0.0 0.0 -45.496853 4.251204 0.0 0.0
   -11.881521 -2.7984104 0.0 0.0 -1.3402902 0.052136492 0.0 0.0 -42.472412
   18.740086 0.0 0.0 -67.21628 -10.370925 0.0 0.0 -0.6767781 -0.7583372 0.0 0.0
   -7.5751543 -2.688302 0.0 0.0 -6.7777576 -2.3068957 0.0 0.0 -1.2454233
   -0.6480535 0.0 0.0 -27.764652 38.62066 0.0 0.0 -1.2495246 0.46115598 0.0 0.0
   -72.458275 -30.886309 0.0 0.0 -6.5083566 -3.0372698 0.0 0.0 -0.91687256
   0.009940922 0.0 0.0 -1.2725079 0.253506 0.0 0.0 -1.0765984 0.20466574 0.0 0.0
   -1.2921982 0.06627503 0.0 0.0 -45.82374 -3.315694 0.0 0.0 -7.068935
   -3.1330748 0.0 0.0 -15.795932 2.4534104 0.0 0.0 -1.1633278 -0.5691467 0.0 0.0
   -48.626663 -11.409648 0.0 0.0 -13.210002 -3.4272957 0.0 0.0 -1.2817044
   -0.37333745 0.0 0.0 -45.0854 9.381412 0.0 0.0 -47.62616 6.769819 0.0 0.0
   -7.801714 -3.2577727 0.0 0.0 -41.562176 -20.313545 0.0 0.0 -47.913948
   -5.3026767 0.0 0.0 -38.90021 28.529062 0.0 0.0 -44.237793 -13.852995 0.0 0.0
   -7.6407375 -1.6565528 0.0 0.0 -7.8335986 0.6338628 0.0 0.0 -7.8694515
   -2.5650709 0.0 0.0 -1.2715595 -0.08860384 0.0 0.0 -1.0526226 0.23093063 0.0
   0.0 -7.034328 -2.2828476 0.0 0.0 -47.84457 -16.237999 0.0 0.0 -0.6980651
   -0.16158271 0.0 0.0 -1.2680004 0.20579475 0.0 0.0 -45.806175 13.070371 0.0
   0.0 -1.282097 -0.38577378 0.0 0.0 -51.84187 -21.55097 0.0 0.0 -8.096727
   -2.1317067 0.0 0.0 -1.4438609 -0.5079627 0.0 0.0 -1.2842935 -0.12289699 0.0
   0.0 -43.696255 -16.94389 0.0 0.0 -7.14093 -3.5865743 0.0 0.0 -41.34577
   22.2033 0.0 0.0 -55.2416 -2.526094 0.0 0.0 -1.1945752 -0.6759556 0.0 0.0
   -42.745186 19.604425 0.0 0.0 -7.3329244 0.93299526 0.0 0.0 -1.2970059
   -0.15733628 0.0 0.0 -39.036892 29.76027 0.0 0.0 -42.632355 -21.373375 0.0 0.0
   -7.2169657 -5.3750725 0.0 0.0 -12.912679 0.5473348 0.0 0.0 -38.313164
   -27.654156 0.0 0.0 -53.065273 12.7783165 0.0 0.0 -1.336109 -0.03881325 0.0
   0.0 -1.0965351 0.25125295 0.0 0.0 -49.3375 -1.6644518 0.0 0.0 -7.998121
   0.48661563 0.0 0.0 -47.437637 9.747643 0.0 0.0 -1.2156652 -0.3690682 0.0 0.0
   -1.1664182 0.16264239 0.0 0.0 -1.0665691 -0.68185544 0.0 0.0 -48.81886
   8.606013 0.0 0.0 -7.5917416 2.503033 0.0 0.0 -1.4177849 0.6707311 0.0 0.0
   -1.3168138 0.23968054 0.0 0.0 -1.1877614 0.5175147 0.0 0.0 -1.190325
   -0.4992906 0.0 0.0 -6.764731 -4.3458657 0.0 0.0 -7.8195767 1.1933495 0.0 0.0
   -1.4023889 0.0785489 0.0 0.0 -62.44006 4.535024 0.0 0.0 -6.0576267 5.008169
   0.0 0.0 -1.333042 -0.07308528 0.0 0.0 -47.89441 2.507987 0.0 0.0 -1.1072916
   -0.70301217 0.0 0.0 -6.9325066 -2.834944 0.0 0.0 -71.467865 26.047104 0.0 0.0
   -51.808617 -6.722545 0.0 0.0 -1.2863317 0.29845047 0.0 0.0 -1.2665709
   -0.3851499 0.0 0.0 -7.2643104 -0.8293296 0.0 0.0 -8.0968485 -1.1281575 0.0
   0.0 -6.326353 -3.3500788 0.0 0.0 -1.2958138 0.19671157 0.0 0.0 -1.1810226
   -0.35956714 0.0 0.0 -7.4496098 -1.204816 0.0 0.0 -1.3330443 0.13093312 0.0
   0.0 -1.2851918 -0.016693452 0.0 0.0 -8.263606 -1.2882009 0.0 0.0 -1.3390478
   0.047812477 0.0 0.0 -62.37634 29.749695 0.0 0.0 -1.2654552 0.3899991 0.0 0.0
   -1.1015977 -0.6684021 0.0 0.0 -47.060535 -15.771081 0.0 0.0 -8.23571
   -3.3754203 0.0 0.0 -1.2729338 0.4043541 0.0 0.0 -1.2452613 -0.39948484 0.0
   0.0 -6.5689254 -3.7474284 0.0 0.0 -7.674959 -1.7086256 0.0 0.0 -1.0638431
   0.39494124 0.0 0.0 -8.295079 -1.2158958 0.0 0.0 -7.782682 0.46989116 0.0 0.0
   -7.378026 0.6055609 0.0 0.0 -7.361855 3.4948814 0.0 0.0 -0.18311875
   0.59872663 0.0 0.0 -46.667763 -15.37463 0.0 0.0 -56.271538 14.2800255 0.0 0.0
   -37.11032 -38.074734 0.0 0.0 -54.023132 -13.141256 0.0 0.0 -1.4830247
   -0.14228418 0.0 0.0 -51.601173 -13.3762 0.0 0.0 -1.2755344 -0.5991076 0.0 0.0
   -7.6038504 -3.3948214 0.0 0.0 -1.0639184 0.4953537 0.0 0.0 -1.4043232
   -0.16961312 0.0 0.0 -52.80056 19.291094 0.0 0.0 -1.0418277 -0.09283342 0.0
   0.0 -1.4494231 0.32985342 0.0 0.0 -62.285316 13.573898 0.0 0.0 -1.4346395
   -0.29791206 0.0 0.0 -54.99016 16.767351 0.0 0.0 -8.486785 -2.6473742 0.0 0.0
   -1.483303 0.06883254 0.0 0.0 -8.331427 1.7655846 0.0 0.0 -1.4853649
   0.0052094012 0.0 0.0 -6.80402 -4.5910945 0.0 0.0 -1.3897452 0.20284912 0.0
   0.0 -1.3946168 -0.29213378 0.0 0.0 -8.198325 4.0031962 0.0 0.0 -58.738083
   17.322113 0.0 0.0 -1.5488027 -0.26751277 0.0 0.0 -46.85705 -22.180887 0.0 0.0
   -6.326715 -4.0350814 0.0 0.0 -1.4380049 0.019391574 0.0 0.0 -8.225834
   1.2416857 0.0 0.0 -1.3535433 0.27980363 0.0 0.0 -5.858175 -4.574585 0.0 0.0
   -7.307137 -1.9116868 0.0 0.0 -326.8094 -117.57438 0.0 0.0 -0.7485132
   -1.2367572 0.0 0.0 -65.51511 30.385504 0.0 0.0 -7.5950093 0.63980436 0.0 0.0
   -5.7431045 -5.179954 0.0 0.0 -6.406646 -5.4224987 0.0 0.0 -1.43515 0.2966648
   0.0 0.0 -6.574916 1.198347 0.0 0.0 -7.4534426 -2.3831549 0.0 0.0 -8.262716
   -1.1670953 0.0 0.0 -54.74665 18.107147 0.0 0.0 -351.57486 -70.979675 0.0 0.0
   -8.148246 -3.5777116 0.0 0.0 -8.12622 -1.8895649 0.0 0.0 -357.95096 35.82941
   0.0 0.0 -1.2950301 0.3755234 0.0 0.0 -1.3595655 0.018826753 0.0 0.0
   -1.2285602 -0.27845973 0.0 0.0 -7.5965686 -3.089961 0.0 0.0 -376.19147
   195.62119 0.0 0.0 -48.87284 -17.380726 0.0 0.0 -58.40396 15.115268 0.0 0.0
   -1.4067084 0.099262506 0.0 0.0 -1.3473256 -0.6898259 0.0 0.0 -412.79425
   15.886753 0.0 0.0 -14.32624 0.058953386 0.0 0.0 -96.884575 -0.7322722 0.0 0.0
   -1.3998946 -0.14525503 0.0 0.0 -53.80494 -15.337441 0.0 0.0 -55.351555
   -10.639913 0.0 0.0 -59.34722 -20.976439 0.0 0.0 -48.158367 -27.162111 0.0 0.0
   -7.793638 5.5142565 0.0 0.0 -5.082951 -5.1569796 0.0 0.0 -45.293842
   -40.225807 0.0 0.0 -1.221622 0.756251 0.0 0.0 -1.4147626 -0.13328652 0.0 0.0
   -347.66556 -163.51173 0.0 0.0 -52.601665 -13.680361 0.0 0.0 -53.27836
   -21.898714 0.0 0.0 -50.803757 -17.485756 0.0 0.0 -1.4748695 -0.05157984 0.0
   0.0 -56.04379 -11.29343 0.0 0.0 -58.39498 -3.3767273 0.0 0.0 -1.2365905
   -0.7210842 0.0 0.0 -1.4494878 -0.110445805 0.0 0.0 -1.0050663 0.55723083 0.0
   0.0 -517.2515 -7.2678146 0.0 0.0 -377.4195 -45.49836 0.0 0.0 -43.43395
   -35.90651 0.0 0.0 -1.4343507 -0.14738381 0.0 0.0 -1.2079232 -0.110386044 0.0
   0.0 -59.099133 4.641292 0.0 0.0 -316.16895 -199.52602 0.0 0.0 -1.4278737
   0.15500511 0.0 0.0 -1.4664754 -0.25784802 0.0 0.0 -1.2374977 -0.7295721 0.0
   0.0 -7.816579 2.142394 0.0 0.0 -363.56018 54.652496 0.0 0.0 -53.310127
   23.254627 0.0 0.0 -8.67764 -5.8732657 0.0 0.0 -1.2836461 0.12643848 0.0 0.0
   -50.37055 -26.091799 0.0 0.0 -1.392202 -0.13239197 0.0 0.0 -343.3889
   -157.8036 0.0 0.0 -7.4398203 -6.3988023 0.0 0.0 -63.256542 -6.555476 0.0 0.0
   -287.98312 -246.42142 0.0 0.0 -1.1878952 -0.52667856 0.0 0.0 -326.37933
   -177.63481 0.0 0.0 -39.72224 34.4228 0.0 0.0 -1.443929 0.06464155 0.0 0.0
   -358.32947 -102.37948 0.0 0.0 -51.25989 -31.052332 0.0 0.0 -1.3078165
   0.3715226 0.0 0.0 -1.3333974 0.5624066 0.0 0.0 -1.3084509 -0.60872865 0.0 0.0
   -50.596596 -21.281368 0.0 0.0 -8.801769 -2.2803197 0.0 0.0 -8.026869
   1.6512048 0.0 0.0 -1.3298715 0.66135067 0.0 0.0 -63.711067 -5.3061495 0.0 0.0
   -1.2627908 0.5069419 0.0 0.0 -9.453118 -2.7367308 0.0 0.0 -369.0515
   -137.62256 0.0 0.0 -63.08217 13.755388 0.0 0.0 -7.406766 1.1151218 0.0 0.0
   -50.85254 18.830362 0.0 0.0 -8.309253 -3.1781275 0.0 0.0 -6.81432 -3.3015265
   0.0 0.0 -1.3161204 0.42646977 0.0 0.0 -1.4710779 0.09161902 0.0 0.0 -54.7887
   -9.287724 0.0 0.0 -7.622399 1.3471165 0.0 0.0 -9.025435 -2.972274 0.0 0.0
   -1.3943607 -0.17124403 0.0 0.0 -70.745865 -15.736093 0.0 0.0 -0.9308831
   -0.24391642 0.0 0.0 -1.2803288 -0.60243845 0.0 0.0 -1.4261714 0.35174525 0.0
   0.0 -0.7446505 0.7334398 0.0 0.0 -1.399917 -0.26031688 0.0 0.0 -1.3845955
   -0.28495222 0.0 0.0 -57.097687 5.216026 0.0 0.0 -54.591026 -4.82101 0.0 0.0
   -43.912624 -34.191418 0.0 0.0 -1.3277903 0.6567537 0.0 0.0 -8.473991
   -2.7934291 0.0 0.0 -8.003742 -3.2087321 0.0 0.0 -57.306305 -10.377193 0.0 0.0
   -1.1916859 0.0027018937 0.0 0.0 -1.4240915 -0.15343529 0.0 0.0 -1.254833
   -0.617723 0.0 0.0 -395.82697 122.11444 0.0 0.0 -1.3832889 0.08871124 0.0 0.0
   -1.3119982 -0.16430375 0.0 0.0 -362.3698 140.77214 0.0 0.0 -1.4289712
   0.23925619 0.0 0.0 -56.552055 -9.83868 0.0 0.0 -45.579456 -6.842364 0.0 0.0
   -1.0894752 -0.9854043 0.0 0.0 -1.4426404 0.083819844 0.0 0.0 -57.89377
   -32.28482 0.0 0.0 -441.5855 -70.062706 0.0 0.0 -1.3431484 0.41847324 0.0 0.0
   -6.1640897 -6.0824203 0.0 0.0 -8.53107 -1.6565127 0.0 0.0 -65.72093
   -15.585399 0.0 0.0 -8.783976 -2.8482742 0.0 0.0 -418.6857 -41.70048 0.0 0.0
   -1.4434066 -0.30095524 0.0 0.0 -7.931627 1.9768364 0.0 0.0 -46.128376
   33.65327 0.0 0.0 -62.60764 9.731502 0.0 0.0 -1.4731746 -0.18989693 0.0 0.0
   -60.335793 -25.378063 0.0 0.0 -1.1965052 0.13537826 0.0 0.0 -52.114014
   -29.024494 0.0 0.0 -61.79508 -9.8229065 0.0 0.0 -38.92794 38.748108 0.0 0.0
   -38.466846 38.886616 0.0 0.0 -1.4751003 0.079803094 0.0 0.0 -51.84023
   29.648836 0.0 0.0 -1.3364822 0.53308636 0.0 0.0 -7.5742345 -1.5774177 0.0 0.0
   -9.47503 1.8101367 0.0 0.0 -367.13947 -219.52187 0.0 0.0 -1.1954526 0.8507555
   0.0 0.0 -374.74496 165.8748 0.0 0.0 -7.5906487 -3.3767037 0.0 0.0 -9.349397
   -2.7977247 0.0 0.0 -7.1946673 5.0842657 0.0 0.0 -7.188177 -4.9591813 0.0 0.0
   -7.566273 3.0806851 0.0 0.0 -6.8702083 -3.3873122 0.0 0.0 -408.31387
   -106.291145 0.0 0.0 -59.85366 -16.566479 0.0 0.0 -40.584713 -41.58352 0.0 0.0
   -101.310326 -36.710205 0.0 0.0 -60.368282 -7.4734077 0.0 0.0 -7.876662
   0.13843456 0.0 0.0 -58.446304 -24.952168 0.0 0.0 -9.132353 1.4850171 0.0 0.0
   -1.2890905 -0.56056774 0.0 0.0 -69.84594 1.3363537 0.0 0.0 -9.908753
   2.2664096 0.0 0.0 -9.473323 -2.069145 0.0 0.0 -56.31602 -14.116235 0.0 0.0
   -8.293216 -5.2532406 0.0 0.0 -1.4473919 -0.25181 0.0 0.0 -63.708195 -5.001992
   0.0 0.0 -1.479216 -0.041714706 0.0 0.0 -52.15515 -26.790636 0.0 0.0 -9.703374
   0.7879369 0.0 0.0 -87.88908 -4.1349607 0.0 0.0 -1.2956007 0.7164025 0.0 0.0
   -58.716064 -12.068778 0.0 0.0 -362.10516 -196.1264 0.0 0.0 -67.43351
   -1.1048952 0.0 0.0 -426.919 -147.57571 0.0 0.0 -1.246009 0.56209654 0.0 0.0
   -9.041571 1.7929373 0.0 0.0 -59.122017 -25.189068 0.0 0.0 -7.583412 1.8778324
   0.0 0.0 -0.7896357 -0.029926388 0.0 0.0 -473.53226 -152.60968 0.0 0.0
   -401.39438 -166.55998 0.0 0.0 -65.55645 -11.886421 0.0 0.0 -1.3653573
   -0.5262636 0.0 0.0 -7.780712 1.5170486 0.0 0.0 -7.5925426 -2.8667839 0.0 0.0
   -53.529175 -36.294704 0.0 0.0 -1.4482881 -0.16018057 0.0 0.0 -38.433422
   -33.190346 0.0 0.0 -59.578968 -26.90961 0.0 0.0 -6.418196 -4.515229 0.0 0.0
   -68.81576 4.092596 0.0 0.0 -6.5337424 4.857086 0.0 0.0 -1.3403565 0.62171346
   0.0 0.0 -1.2314298 -0.6861499 0.0 0.0 -60.300934 -23.37714 0.0 0.0 -9.688845
   -3.3564956 0.0 0.0 -8.1773405 -4.5925317 0.0 0.0 -1.4397672 0.15506788 0.0
   0.0 -55.8825 -23.549292 0.0 0.0 -53.104782 21.365463 0.0 0.0 -1.3581026
   -0.16871351 0.0 0.0 -8.927486 -0.76388526 0.0 0.0 -8.107176 1.0179313 0.0 0.0
   -1.3705846 0.39732826 0.0 0.0 -63.210415 31.271208 0.0 0.0 -8.001268
   -3.9395483 0.0 0.0 -62.316284 -27.861176 0.0 0.0 -1.171745 -0.5381711 0.0 0.0
   -1.3752477 0.41845733 0.0 0.0 -1.3707662 0.022713749 0.0 0.0 -1.4550991
   0.30292666 0.0 0.0 -8.220317 -6.1206207 0.0 0.0 -1.4544238 -0.28713763 0.0
   0.0 -7.3536973 -2.9875455 0.0 0.0 -1.3029053 0.03031621 0.0 0.0 -7.802303
   -4.7936344 0.0 0.0 -7.6424813 2.3491352 0.0 0.0 -1.1050025 -0.2745162 0.0 0.0
   -7.0442533 -4.293586 0.0 0.0 -8.521404 -2.9304056 0.0 0.0 -1.3693179
   0.5033291 0.0 0.0 -8.360257 3.4680676 0.0 0.0 -10.206092 -1.4010848 0.0 0.0
   -61.4662 -5.2125654 0.0 0.0 -64.1528 27.59909 0.0 0.0 -1.0117556 -0.9153171
   0.0 0.0 -1.1188534 -0.802498 0.0 0.0 -8.771402 1.8336325 0.0 0.0 -531.37146
   -307.4488 0.0 0.0 -66.3682 3.7823834 0.0 0.0 -54.446552 -39.996887 0.0 0.0
   -9.439452 -0.3821162 0.0 0.0 -10.01535 -0.21842545 0.0 0.0 -1.3940825
   -0.04690489 0.0 0.0 -36.96445 -48.834354 0.0 0.0 -1.4784737 0.05410403 0.0
   0.0 -1.3742685 -0.5661509 0.0 0.0 -8.327308 1.8781074 0.0 0.0 -68.21874
   12.977899 0.0 0.0 -376.22 -263.6022 0.0 0.0 -1.3768858 -0.14353082 0.0 0.0
   -55.97038 -34.77435 0.0 0.0 -8.435348 -4.187484 0.0 0.0 -1.4473442 0.18717021
   0.0 0.0 -10.054099 -0.5166118 0.0 0.0 -1.4773972 -0.1790304 0.0 0.0
   -63.494614 29.446285 0.0 0.0 -407.96616 -195.0049 0.0 0.0 -1.4831439
   0.0033923408 0.0 0.0 -9.652106 -4.442288 0.0 0.0 -9.776222 -1.5115979 0.0 0.0
   -65.29777 23.34692 0.0 0.0 -0.6929381 -1.2905056 0.0 0.0 -9.359302 2.2958 0.0
   0.0 -7.8010426 3.8363407 0.0 0.0 -9.248343 -3.6661353 0.0 0.0 -595.06885
   -98.58615 0.0 0.0 -351.43616 -264.05893 0.0 0.0 -50.315105 -43.684887 0.0 0.0
   -60.761883 -0.37094235 0.0 0.0 -1.2525127 -0.45798317 0.0 0.0 -1.2876896
   -0.20023753 0.0 0.0 -9.106037 -0.4326629 0.0 0.0 -8.983846 -1.059058 0.0 0.0
   -67.793365 17.906214 0.0 0.0 -1.2768723 -0.6560687 0.0 0.0 -60.97184
   -2.6836042 0.0 0.0 -7.49266 -5.1713443 0.0 0.0 -9.106843 -3.4379804 0.0 0.0
   -9.030392 -4.351718 0.0 0.0 -61.0003 -11.848005 0.0 0.0 -60.781013 1.374043
   0.0 0.0 -1.1939973 0.51271725 0.0 0.0 -1.3177435 -0.39417982 0.0 0.0
   -58.991932 21.381235 0.0 0.0 -1.3542405 -0.38869444 0.0 0.0 -8.049944
   1.4138676 0.0 0.0 -62.39251 -6.747095 0.0 0.0 -56.581165 -20.050058 0.0 0.0
   -67.75354 -8.390885 0.0 0.0 -79.26018 -32.048862 0.0 0.0 -8.324446
   0.119112805 0.0 0.0 -8.323815 3.288543 0.0 0.0 -1.4700365 0.04511837 0.0 0.0
   -1.3977503 -0.05947709 0.0 0.0 -46.839127 34.566425 0.0 0.0 -64.14962
   -8.396783 0.0 0.0 -1.3932773 -0.15501733 0.0 0.0 -1.3947208 -0.014533729 0.0
   0.0 -1.5220866 -0.267988 0.0 0.0 -426.41443 170.86282 0.0 0.0 -1.453838
   -0.46027982 0.0 0.0 -430.71536 -191.07986 0.0 0.0 -1.2548472 0.61643213 0.0
   0.0 -57.686558 22.960482 0.0 0.0 -9.2267685 0.23703861 0.0 0.0 -7.642572
   -4.366984 0.0 0.0 -54.698284 -27.765062 0.0 0.0 -10.04395 3.3580356 0.0 0.0
   -2.0345125 -0.3648446 0.0 0.0 -1.0099419 -1.0749838 0.0 0.0 -64.78077
   -16.820496 0.0 0.0 -7.540982 3.3618832 0.0 0.0 -1.44461 -0.34080517 0.0 0.0
   -63.885365 -27.677343 0.0 0.0 -1.4385858 -0.15382253 0.0 0.0 -387.4328
   -316.7167 0.0 0.0 -68.27633 -2.8526883 0.0 0.0 -467.521 -145.28372 0.0 0.0
   -680.7392 -161.89774 0.0 0.0 -418.89304 -255.12529 0.0 0.0 -69.18144
   22.954306 0.0 0.0 -1.4718785 -0.20258817 0.0 0.0 -63.137207 -16.723919 0.0
   0.0 -1.2607532 0.64151144 0.0 0.0 -6.420577 -5.0261025 0.0 0.0 -9.181682
   -4.175932 0.0 0.0 -61.360138 3.846196 0.0 0.0 -60.584225 10.675887 0.0 0.0
   -681.65967 244.08081 0.0 0.0 -70.71177 -27.190304 0.0 0.0 -9.405325
   -7.0165396 0.0 0.0 -1.4089059 -0.399043 0.0 0.0 -473.01364 -12.646061 0.0 0.0
   -10.358523 -0.8385801 0.0 0.0 -1.3333853 -0.6233243 0.0 0.0 -63.89003
   -1.9463336 0.0 0.0 -61.639 -0.643198 0.0 0.0 -334.40314 -537.6882 0.0 0.0
   -58.368717 -20.675287 0.0 0.0 -1.2029557 0.32625198 0.0 0.0 -361.4247
   -310.63272 0.0 0.0 -1.4881237 -0.019521952 0.0 0.0 -10.082316 2.077459 0.0
   0.0 -8.119383 -6.4078474 0.0 0.0 -9.800826 2.9967484 0.0 0.0 -1.2121793
   0.82369614 0.0 0.0 -10.147721 2.5870073 0.0 0.0 -1.4619691 -0.21939535 0.0
   0.0 -1.4118716 -0.44104785 0.0 0.0 -1.4613307 0.0749239 0.0 0.0 -1.4631277
   -0.21275103 0.0 0.0 -66.24334 14.566439 0.0 0.0 -9.072285 -4.4722605 0.0 0.0
   -56.903656 -29.218996 0.0 0.0 -8.315774 0.04057425 0.0 0.0 -8.643596
   -2.9966686 0.0 0.0 -7.6209507 -1.7312069 0.0 0.0 -1.452863 -0.012889795 0.0
   0.0 -1.3491633 0.27447215 0.0 0.0 -9.380596 0.0999375 0.0 0.0 -1.2128234
   -0.81026447 0.0 0.0 -8.393296 1.5907551 0.0 0.0 -55.12657 -30.027819 0.0 0.0
   -1.308925 -0.011008427 0.0 0.0 -1.3196919 0.19462845 0.0 0.0 -9.295096
   -4.178397 0.0 0.0 -9.142918 0.05202147 0.0 0.0 -61.15089 -23.915985 0.0 0.0
   -7.9591837 -3.176989 0.0 0.0 -64.65845 -33.5318 0.0 0.0 -9.11949 -2.2470226
   0.0 0.0 -8.033507 -2.3217974 0.0 0.0 -1.260263 -0.6752063 0.0 0.0 -61.7688
   14.758867 0.0 0.0 -1.3028688 -0.5717558 0.0 0.0 -500.97098 168.72278 0.0 0.0
   -1.396686 -0.4291286 0.0 0.0 -757.2539 -188.27399 0.0 0.0 -10.432884
   -0.3572504 0.0 0.0 -69.55062 13.770757 0.0 0.0 -0.95007765 -0.8962806 0.0 0.0
   -1.426983 -0.07209191 0.0 0.0 -8.320357 -0.78477585 0.0 0.0 -11.97892
   -5.524105 0.0 0.0 -63.340652 -5.0087595 0.0 0.0 -6.888427 5.5460696 0.0 0.0
   -1.4319577 -0.39353523 0.0 0.0 -1.0738183 -0.39133403 0.0 0.0 -9.650523
   -3.6530113 0.0 0.0 -79.04321 3.0058987 0.0 0.0 -85.09665 -20.559166 0.0 0.0
   -55.780758 -34.036423 0.0 0.0 -9.025829 2.5818737 0.0 0.0 -8.84428 2.8675697
   0.0 0.0 -59.85906 -22.352322 0.0 0.0 -1.2173644 -0.2833234 0.0 0.0 -1.277137
   0.76009065 0.0 0.0 -1.3910991 0.435653 0.0 0.0 -63.669678 16.284945 0.0 0.0
   -1.1687946 0.40337947 0.0 0.0 -7.895692 -4.890112 0.0 0.0 -10.422547 0.325586
   0.0 0.0 -9.491889 -5.2827945 0.0 0.0 -8.37669 6.1412864 0.0 0.0 -5.5201325
   5.115073 0.0 0.0 -1.1273632 0.50156325 0.0 0.0 -9.513215 0.3124389 0.0 0.0
   -434.46524 -371.11047 0.0 0.0 -503.32574 124.82014 0.0 0.0 -477.29636
   -169.42836 0.0 0.0 -0.8899761 -0.9556943 0.0 0.0 -6.600826 -7.2924905 0.0 0.0
   -72.3122 -14.017135 0.0 0.0 -40.547695 -53.516525 0.0 0.0 -9.603822 -3.461289
   0.0 0.0 -1.4843711 0.020184375 0.0 0.0 -8.9495945 3.2908003 0.0 0.0
   -525.59814 237.15793 0.0 0.0 -1.1071194 0.6597886 0.0 0.0 -7.5847473
   -3.833662 0.0 0.0 -68.06564 -15.889464 0.0 0.0 -521.64777 -54.97966 0.0 0.0
   -1.0642534 0.6939234 0.0 0.0 -47.73663 -46.450294 0.0 0.0 -0.8900285
   -0.8995031 0.0 0.0 -59.415966 32.662 0.0 0.0 -73.713615 -6.0841966 0.0 0.0
   -73.98711 6.6116753 0.0 0.0 -1.3940614 -0.51514405 0.0 0.0 -1.4207693
   -0.42450172 0.0 0.0 -616.1372 187.2301 0.0 0.0 -79.45137 -25.605003 0.0 0.0
   -64.98329 20.29682 0.0 0.0 -1.1828853 0.7688357 0.0 0.0 -1.3804998 0.46303406
   0.0 0.0 -8.406001 3.6738338 0.0 0.0 -9.043209 5.722387 0.0 0.0 -9.382337
   -4.3888235 0.0 0.0 -0.7144078 -0.9450775 0.0 0.0 -506.86188 -203.56477 0.0
   0.0 -1.3225577 -0.5636976 0.0 0.0 -1.1624246 -0.4838289 0.0 0.0 -61.941364
   35.504635 0.0 0.0 -68.228874 18.37061 0.0 0.0 -68.62735 20.575022 0.0 0.0
   -9.175329 0.38442644 0.0 0.0 -61.217533 -22.385506 0.0 0.0 -532.56995
   65.685234 0.0 0.0 -1.2101951 -0.35330132 0.0 0.0 -1.4813639 -0.065903 0.0 0.0
   -1.4204273 -0.20014288 0.0 0.0 -1.3161925 -0.6244484 0.0 0.0 -1.2216798
   -0.5427614 0.0 0.0 -9.614308 -2.116862 0.0 0.0 -79.29987 15.014063 0.0 0.0
   -85.1667 -18.15942 0.0 0.0 -1.2135271 -0.8276232 0.0 0.0 -8.34406 3.618664
   0.0 0.0 -1.4394758 0.26327306 0.0 0.0 -90.894066 11.523415 0.0 0.0 -9.060917
   4.665812 0.0 0.0 -8.08674 4.291801 0.0 0.0 -73.20184 -39.575848 0.0 0.0
   -65.87828 -9.736886 0.0 0.0 -1.4646747 0.16443503 0.0 0.0 -1.2000117
   -0.53815037 0.0 0.0 -8.585548 -0.8125222 0.0 0.0 -1.4692147 -0.02456644 0.0
   0.0 -67.9269 2.488455 0.0 0.0 -9.564741 -0.23360918 0.0 0.0 -399.64923
   -394.10138 0.0 0.0 -1.3321087 0.57089025 0.0 0.0 -1.4856627 0.2969025 0.0 0.0
   -10.079476 -3.889889 0.0 0.0 -1.3423882 0.43715268 0.0 0.0 -9.054616
   -0.20650174 0.0 0.0 -9.288967 -2.7205243 0.0 0.0 -69.78811 3.394267 0.0 0.0
   -64.01958 20.262486 0.0 0.0 -528.99677 444.91382 0.0 0.0 -9.40332 -5.2410126
   0.0 0.0 -1.4226501 -0.13314174 0.0 0.0 -8.805831 1.1185148 0.0 0.0 -116.09695
   -11.858416 0.0 0.0 -7.7187915 -6.1489635 0.0 0.0 -1.2585174 -0.16685326 0.0
   0.0 -76.05069 -25.655617 0.0 0.0 -1.0339464 -0.21470255 0.0 0.0 -1.2954391
   -0.34879076 0.0 0.0 -43.407352 -51.6161 0.0 0.0 -1.3310152 -0.026664734 0.0
   0.0 -6.641112 -6.5633783 0.0 0.0 -1.3260005 -0.14480689 0.0 0.0 -1.3157694
   -0.011188767 0.0 0.0 -8.447789 3.9232538 0.0 0.0 -1.3140746 0.033639833 0.0
   0.0 -1.3184633 0.23049203 0.0 0.0 -57.23568 -39.38567 0.0 0.0 -1.2965686
   -0.18648463 0.0 0.0 -8.667928 -1.5404049 0.0 0.0 -91.5439 -7.4511137 0.0 0.0
   -1.3268113 0.0027611859 0.0 0.0 -0.9306917 0.25613284 0.0 0.0 -7.778841
   -2.9811926 0.0 0.0 -1.231988 -0.08461355 0.0 0.0 -1.318066 -0.16919602 0.0
   0.0 -1.2501795 0.48326987 0.0 0.0 -10.287491 -3.0303192 0.0 0.0 -8.393377
   1.7613168 0.0 0.0 -7.6593657 -4.1024966 0.0 0.0 -1.2149364 0.5221303 0.0 0.0
   -0.99828213 0.89369816 0.0 0.0 -6.7958736 5.43608 0.0 0.0 -1.2326881
   0.36411476 0.0 0.0 -1.289263 0.33568978 0.0 0.0 -10.0592985 -2.849932 0.0 0.0
   -1.2764965 -0.3067017 0.0 0.0 -60.42272 -35.893787 0.0 0.0 -8.167596
   5.4293137 0.0 0.0 -25.823332 41.13195 0.0 0.0 -68.636 0.26011786 0.0 0.0
   -1.3282173 0.08845697 0.0 0.0 -8.640404 1.7165865 0.0 0.0 -1.1230624
   -0.7001671 0.0 0.0 -1.161558 -0.3899395 0.0 0.0 -81.16521 -13.216878 0.0 0.0
   -92.57839 -12.66353 0.0 0.0 -8.222787 -2.5226424 0.0 0.0 -8.801223 0.06461396
   0.0 0.0 -1.2996297 0.21470597 0.0 0.0 -1.2342141 0.50874966 0.0 0.0
   -0.84352654 0.6619351 0.0 0.0 -7.9941044 4.235863 0.0 0.0 -1.2926152
   -0.12486009 0.0 0.0 -1.2288781 0.5104407 0.0 0.0 -68.5154 -24.72409 0.0 0.0
   -6.8628335 5.5338507 0.0 0.0 -1.2874383 0.30283764 0.0 0.0 -64.94969
   -28.993689 0.0 0.0 -87.39928 19.51864 0.0 0.0 -9.002939 3.1732435 0.0 0.0
   -9.395318 -3.5113723 0.0 0.0 -10.779535 -2.5598736 0.0 0.0 -89.62745
   29.927197 0.0 0.0 -8.387393 -1.9774332 0.0 0.0 -69.45738 4.5682306 0.0 0.0
   -1.288008 0.080742806 0.0 0.0 -9.14613 -1.8987613 0.0 0.0 -1.2769663
   0.0072653294 0.0 0.0 -58.47296 -44.417233 0.0 0.0 -12.34171 -0.53625077 0.0
   0.0 -8.675806 -0.2391902 0.0 0.0 -8.370125 -4.1288285 0.0 0.0 -9.694176
   -0.08449703 0.0 0.0 -11.622771 1.3228368 0.0 0.0 -9.852092 -7.477459 0.0 0.0
   -8.513985 4.624045 0.0 0.0 -1.2978238 -0.57842714 0.0 0.0 -1.3292363
   -0.09973316 0.0 0.0 -0.9937288 0.79091406 0.0 0.0 -61.938362 -33.026295 0.0
   0.0 -8.829201 1.2150079 0.0 0.0 -8.475661 -4.878504 0.0 0.0 -9.374907
   2.6455734 0.0 0.0 -1.1636186 -0.026095945 0.0 0.0 -74.13472 -35.380974 0.0
   0.0 -1.1505144 0.6421361 0.0 0.0 -86.51758 -3.5885751 0.0 0.0 -12.934994
   4.710945 0.0 0.0 -10.124052 0.6892644 0.0 0.0 -7.856076 3.711669 0.0 0.0
   -8.407136 -7.885544 0.0 0.0 -10.191849 -3.878621 0.0 0.0 -9.447053 -2.6693351
   0.0 0.0 -1.2884067 -0.049019013 0.0 0.0 -7.7521634 -3.9605782 0.0 0.0
   -82.666916 2.0620494 0.0 0.0 -1.2252996 -0.2899917 0.0 0.0 -1.0900683
   -0.2179885 0.0 0.0 -8.684549 0.4402172 0.0 0.0 -70.77138 -5.415194 0.0 0.0
   -9.709711 -1.3846054 0.0 0.0 -9.470695 2.6565537 0.0 0.0 -75.750694
   -12.877964 0.0 0.0 -0.8053687 -1.0457482 0.0 0.0 -8.812342 -4.2147675 0.0 0.0
   -8.1598215 -3.6313238 0.0 0.0 -69.38363 -28.594637 0.0 0.0 -1.3006355
   -0.29407993 0.0 0.0 -1.0981227 -0.37194297 0.0 0.0 -8.263516 4.6232886 0.0
   0.0 -1.1149397 -0.681493 0.0 0.0 -1.1425565 -0.42027318 0.0 0.0 -1.2063304
   -0.52968544 0.0 0.0 -80.93166 -20.927378 0.0 0.0 -1.2011682 -0.5187332 0.0
   0.0 -11.934477 -0.019079966 0.0 0.0 -1.3257216 -0.4149732 0.0 0.0 -1.2119893
   0.3778617 0.0 0.0 -9.121748 -1.5628103 0.0 0.0 -8.444552 5.1473126 0.0 0.0
   -89.34344 15.994494 0.0 0.0 -56.20922 44.749023 0.0 0.0 -6.477001 -6.2511463
   0.0 0.0 -1.138545 0.5844176 0.0 0.0 -79.534164 7.3507495 0.0 0.0 -9.1777115
   -2.7332585 0.0 0.0 -9.726918 -1.8551987 0.0 0.0 -1.0775895 0.7676485 0.0 0.0
   -10.551034 -0.25738928 0.0 0.0 -1.3382094 0.04852144 0.0 0.0 -10.0048275
   -1.6274779 0.0 0.0 -1.1535337 0.60289377 0.0 0.0 -8.216145 -2.7998717 0.0 0.0
   -62.9408 -35.62338 0.0 0.0 -1.2941825 0.1921149 0.0 0.0 -1.2881832
   -0.13913313 0.0 0.0 -0.6489167 -1.1514549 0.0 0.0 -8.129461 -5.7026634 0.0
   0.0 -8.823072 -0.56228745 0.0 0.0 -76.464485 -25.401146 0.0 0.0 -83.42693
   -25.408018 0.0 0.0 -7.283733 -6.1253686 0.0 0.0 -9.040579 0.0719662 0.0 0.0
   -78.52736 4.747201 0.0 0.0 -76.63946 2.439989 0.0 0.0 -1.3215148 -0.19225387
   0.0 0.0 -80.02585 -23.952417 0.0 0.0 -8.849207 -0.1397181 0.0 0.0 -0.6672502
   0.8758173 0.0 0.0 -10.507015 -3.0334003 0.0 0.0 -1.5598477 0.6092542 0.0 0.0
   -1.2146292 -0.24878135 0.0 0.0 -87.4466 0.90620166 0.0 0.0 -9.252743
   -1.3001059 0.0 0.0 -9.500708 1.4404281 0.0 0.0 -178.718 -11.321887 0.0 0.0
   -11.959324 -1.1710355 0.0 0.0 -65.699 -32.457565 0.0 0.0 -1.080598
   0.010203816 0.0 0.0 -1.3533798 -0.27624637 0.0 0.0 -1.0292965 0.46027106 0.0
   0.0 -8.223138 -3.3737755 0.0 0.0 -10.50194 1.8757015 0.0 0.0 -1.3136982
   0.057391778 0.0 0.0 -78.22437 -30.425251 0.0 0.0 -74.67031 27.761374 0.0 0.0
   -9.720735 -1.618605 0.0 0.0 -12.175645 -5.182389 0.0 0.0 -1.3289227
   0.16375162 0.0 0.0 -102.9015 -15.042232 0.0 0.0 -9.41688 -4.5937967 0.0 0.0
   -1.3991456 0.34080023 0.0 0.0 -1.141631 -0.76135516 0.0 0.0 -1.1730043
   -0.5623635 0.0 0.0 -92.46196 -27.162977 0.0 0.0 -1.3126096 -0.09454809 0.0
   0.0 -11.724122 -1.3905941 0.0 0.0 -10.504678 0.5843165 0.0 0.0 -68.07534
   29.321259 0.0 0.0 -9.091224 -4.2453575 0.0 0.0 -1.324437 0.05372622 0.0 0.0
   -1.2397062 -0.27221388 0.0 0.0 -10.970971 -4.6679225 0.0 0.0 -1.2123888
   -0.46526942 0.0 0.0 -1.0951357 -0.63791806 0.0 0.0 -9.65133 -0.6162014 0.0
   0.0 -1.0587147 -0.8117438 0.0 0.0 -1.3169976 -0.20699124 0.0 0.0 -9.359644
   0.30229315 0.0 0.0 -1.251373 -0.27980286 0.0 0.0 -9.663376 -0.48635313 0.0
   0.0 -10.155225 -3.5910366 0.0 0.0 -8.33494 -3.799889 0.0 0.0 -44.571598
   -67.55978 0.0 0.0 -8.901454 -3.1942303 0.0 0.0 -1.0873659 -0.5659986 0.0 0.0
   -1.3003136 -0.28670347 0.0 0.0 -1.3505478 -0.14786784 0.0 0.0 -8.981109
   0.23688823 0.0 0.0 -1.2881289 -0.3615109 0.0 0.0 -11.037159 -0.32109508 0.0
   0.0 -9.935569 0.954906 0.0 0.0 -9.154889 1.1775776 0.0 0.0 -7.353807
   5.1771226 0.0 0.0 -8.640714 -5.254926 0.0 0.0 -8.660657 -3.175217 0.0 0.0
   -1.3003788 -0.123568945 0.0 0.0 -0.8698059 0.85273665 0.0 0.0 -59.788868
   -49.113033 0.0 0.0 -1.2289821 -0.331723 0.0 0.0 -1.1917676 -0.59885025 0.0
   0.0 -1.2685549 -0.23986177 0.0 0.0 -82.02694 33.62165 0.0 0.0 -8.9752445
   -0.81443536 0.0 0.0 -10.839989 -0.9879243 0.0 0.0 -1.3173622 -0.16235216 0.0
   0.0 -1.320528 -0.030885627 0.0 0.0 -1.1989096 0.49187127 0.0 0.0 -92.68994
   14.800517 0.0 0.0 -9.737517 -0.61430955 0.0 0.0 -6.6483693 7.645308 0.0 0.0
   -1.3608019 -0.052782066 0.0 0.0 -77.90007 3.237514 0.0 0.0 -1.329331
   0.12811273 0.0 0.0 -73.58282 26.03299 0.0 0.0 -8.974418 1.0260985 0.0 0.0
   -9.676346 -3.4658294 0.0 0.0 -1.2785413 -0.28971967 0.0 0.0 -8.814084
   2.0679886 0.0 0.0 -7.979058 -5.2127466 0.0 0.0 -0.9823258 -0.44522953 0.0 0.0
   -9.242863 0.8993277 0.0 0.0 -9.293682 -3.1282587 0.0 0.0 -89.17784 10.071133
   0.0 0.0 -1.2663898 -0.4310924 0.0 0.0 -1.2556576 0.3197907 0.0 0.0 -0.8383261
   -0.8987799 0.0 0.0 -6.9205146 6.3861256 0.0 0.0 -8.995565 2.328859 0.0 0.0
   -80.707664 -50.214184 0.0 0.0 -91.71065 1.6263887 0.0 0.0 -1.2477372 0.312608
   0.0 0.0 -93.744545 -16.721962 0.0 0.0 -10.227098 -0.14618224 0.0 0.0
   -1.0697658 -0.53105044 0.0 0.0 -1.0579442 -0.7206791 0.0 0.0 -1.2318712
   0.39503783 0.0 0.0 -8.145932 -6.1137476 0.0 0.0 -8.723331 -3.2753458 0.0 0.0
   -1.1600897 -0.032188408 0.0 0.0 -1.5363853 0.47191727 0.0 0.0 -9.331954
   0.67051005 0.0 0.0 -1.2490199 -0.4819478 0.0 0.0 -1.2746497 0.04429802 0.0
   0.0 -8.821551 1.3636547 0.0 0.0 -77.455414 31.98006 0.0 0.0 -1.1425616
   0.26153654 0.0 0.0 -69.72997 -58.6319 0.0 0.0 -1.3667889 -0.41176903 0.0 0.0
   -82.76879 -16.093206 0.0 0.0 -1.4053818 -0.41345116 0.0 0.0 -11.736551
   1.2965174 0.0 0.0 -75.85226 15.496346 0.0 0.0 -8.540764 5.8517046 0.0 0.0
   -1.2735782 0.73000133 0.0 0.0 -8.26314 -3.673375 0.0 0.0 -0.9912945
   -1.0759149 0.0 0.0 -73.832664 27.787048 0.0 0.0 -0.91107774 0.28630975 0.0
   0.0 -0.9072687 0.10795732 0.0 0.0 -1.1468523 0.7766231 0.0 0.0 -82.06424
   33.526505 0.0 0.0 -8.991414 5.2832427 0.0 0.0 -71.94821 -38.05298 0.0 0.0
   -10.468769 -1.2701315 0.0 0.0 -1.4724369 0.06058429 0.0 0.0 -1.1517547
   -0.7173447 0.0 0.0 -10.935765 3.6836028 0.0 0.0 -11.746594 -1.4410572 0.0 0.0
   -7.3943343 -5.573707 0.0 0.0 -590.2222 -473.98877 0.0 0.0 -9.420135 2.3924582
   0.0 0.0 -72.955086 45.55944 0.0 0.0 -11.323412 2.5476289 0.0 0.0 -1.1443124
   0.4448383 0.0 0.0 -84.21606 -30.731907 0.0 0.0 -1.4866167 -0.026455307 0.0
   0.0 -10.62933 -0.6878351 0.0 0.0 -84.40623 -19.26328 0.0 0.0 -10.528315
   3.1082978 0.0 0.0 -10.698332 -3.4343436 0.0 0.0 -82.67516 30.369495 0.0 0.0
   -1.3435339 -0.59758663 0.0 0.0 -86.91468 19.215147 0.0 0.0 -9.507372
   -2.3257337 0.0 0.0 -70.646545 -37.96885 0.0 0.0 -79.59629 -10.208798 0.0 0.0
   -13.295692 2.2265258 0.0 0.0 -698.1753 -114.57001 0.0 0.0 -1.396727 0.2161359
   0.0 0.0 -1.4771792 -0.256524 0.0 0.0 -767.1723 -67.83992 0.0 0.0 -90.23553
   -8.071044 0.0 0.0 -1.2663985 -0.26985037 0.0 0.0 -9.7711525 3.619889 0.0 0.0
   -77.76044 -17.705288 0.0 0.0 -1.2550732 -0.5220319 0.0 0.0 -1.426924
   0.010722898 0.0 0.0 -10.258745 -1.8121974 0.0 0.0 -1.4044789 -0.26781133 0.0
   0.0 -1.3597288 -0.4445867 0.0 0.0 -660.4812 -408.30484 0.0 0.0 -11.324049
   0.6109677 0.0 0.0 -19.919851 -3.55857 0.0 0.0 -11.142448 3.5874467 0.0 0.0
   -9.870374 3.3459601 0.0 0.0 -398.76147 152.77661 0.0 0.0 -1.3396968
   -0.48854113 0.0 0.0 -9.63008 1.9951608 0.0 0.0 -88.39543 -14.6248255 0.0 0.0
   -83.9406 30.273935 0.0 0.0 -100.851685 19.562222 0.0 0.0 -1.3625333
   -0.32969332 0.0 0.0 -91.10529 9.345844 0.0 0.0 -1.1321069 -0.888976 0.0 0.0
   -1.4681498 0.17540412 0.0 0.0 -76.67619 -36.37278 0.0 0.0 -10.889858
   -2.7126904 0.0 0.0 -8.495744 -8.000111 0.0 0.0 -74.47985 53.795536 0.0 0.0
   -1.2825086 0.15469691 0.0 0.0 -1.4134177 0.28567106 0.0 0.0 -12.400229
   -3.4318373 0.0 0.0 -680.62115 -193.20798 0.0 0.0 -1297.7896 -335.92645 0.0
   0.0 -85.20929 4.2749734 0.0 0.0 -10.571108 4.2960153 0.0 0.0 -90.769775
   -16.496418 0.0 0.0 -9.508038 1.7134143 0.0 0.0 -67.86447 -26.155832 0.0 0.0
   -1.3674994 0.32851207 0.0 0.0 -9.781503 1.7866149 0.0 0.0 -1.1073859
   0.81501645 0.0 0.0 -9.321439 -2.745926 0.0 0.0 -703.3349 -209.0658 0.0 0.0
   -591.377 -435.32736 0.0 0.0 -1.3081608 0.28243378 0.0 0.0 -1.4073616
   -0.18184939 0.0 0.0 -6.047515 -7.1354055 0.0 0.0 -11.786505 -0.3593969 0.0
   0.0 -963.5413 570.99133 0.0 0.0 -1.42937 0.12086716 0.0 0.0 -5.1494856
   -8.7195 0.0 0.0 -1.2529643 -0.13942231 0.0 0.0 -76.70619 -33.766567 0.0 0.0
   -1.372536 -0.41369542 0.0 0.0 -73.78961 -24.187271 0.0 0.0 -8.840181
   -5.9105744 0.0 0.0 -1.3401561 -0.59564644 0.0 0.0 -85.349815 -34.335636 0.0
   0.0 -9.611929 6.8822627 0.0 0.0 -10.004051 -0.14530775 0.0 0.0 -10.083637
   -3.5815244 0.0 0.0 -1.4314175 0.27910003 0.0 0.0 -11.478433 -2.1394897 0.0
   0.0 -1.4297715 -0.37124225 0.0 0.0 -80.05861 22.33784 0.0 0.0 -80.888214
   -13.858787 0.0 0.0 -11.27138 -0.6215066 0.0 0.0 -93.51887 -26.118979 0.0 0.0
   -11.35669 -3.2601402 0.0 0.0 -110.57112 -16.199205 0.0 0.0 -82.14698
   -22.598942 0.0 0.0 -9.385568 3.6187553 0.0 0.0 -11.262144 -3.898784 0.0 0.0
   -11.408878 -2.6924858 0.0 0.0 -1.4668857 -0.24815577 0.0 0.0 -10.249684
   2.6883821 0.0 0.0 -9.332264 1.9459873 0.0 0.0 -10.253501 -6.2965484 0.0 0.0
   -0.43941906 -0.026186889 0.0 0.0 -700.86847 -219.28104 0.0 0.0 -1.3029273
   0.5071403 0.0 0.0 -84.94127 0.064855814 0.0 0.0 -79.7871 -32.571877 0.0 0.0
   -4.0513306 -9.846365 0.0 0.0 -10.40618 -2.7530074 0.0 0.0 -9.725784 4.1808167
   0.0 0.0 -1.3695681 -0.6511545 0.0 0.0 -87.72418 2.5188477 0.0 0.0 -82.88053
   3.5529454 0.0 0.0 -1.354894 0.44195518 0.0 0.0 -1.3897312 0.5303098 0.0 0.0
   -9.709777 1.7223463 0.0 0.0 -9.872175 -2.944179 0.0 0.0 -12.146173 -4.4279404
   0.0 0.0 -81.25727 18.029654 0.0 0.0 -85.11739 17.290413 0.0 0.0 -98.81903
   -33.975792 0.0 0.0 -99.852554 -30.689182 0.0 0.0 -1.4016806 0.42476943 0.0
   0.0 -1.1596725 -0.8050113 0.0 0.0 -127.51926 5.861242 0.0 0.0 -1.4603653
   -0.21762972 0.0 0.0 -1.4799125 0.26644206 0.0 0.0 -11.647066 0.62598896 0.0
   0.0 -11.064836 -2.872046 0.0 0.0 -1.2501203 0.7045452 0.0 0.0 -1.3712536
   0.32230866 0.0 0.0 -914.56323 -223.21793 0.0 0.0 -78.99509 -40.45232 0.0 0.0
   -9.005509 3.0717344 0.0 0.0 -10.043868 2.9021833 0.0 0.0 -1.270823 0.5914332
   0.0 0.0 -10.4453125 2.8072462 0.0 0.0 -1.3834568 -0.24173318 0.0 0.0
   -8.711573 -7.462657 0.0 0.0 -1.3275514 0.41364524 0.0 0.0 -98.9546 -19.960176
   0.0 0.0 -1.4361895 0.07902089 0.0 0.0 -7.472053 -5.0538473 0.0 0.0 -80.20848
   44.7724 0.0 0.0 -86.40879 -7.362972 0.0 0.0 -106.45301 -35.11417 0.0 0.0
   -86.75663 10.313208 0.0 0.0 -8.012944 -5.6682196 0.0 0.0 -1.0611309
   0.69304717 0.0 0.0 -10.1511 -0.58592814 0.0 0.0 -105.46875 62.07688 0.0 0.0
   -9.570882 -3.3936496 0.0 0.0 -73.32215 42.42507 0.0 0.0 -152.7537 28.099129
   0.0 0.0 -1.3983018 -0.4371472 0.0 0.0 -95.65033 -9.234415 0.0 0.0 -127.24542
   10.585572 0.0 0.0 -0.96505266 -1.1089965 0.0 0.0 -1.3553052 0.014754921 0.0
   0.0 -1.4835528 -0.10255719 0.0 0.0 -84.24866 -44.67855 0.0 0.0 -83.48692
   13.24624 0.0 0.0 -1.3170062 -0.066034615 0.0 0.0 -7.1424956 -7.349227 0.0 0.0
   -1.2010663 -0.45978358 0.0 0.0 -10.762204 1.3363856 0.0 0.0 -90.80384
   19.021383 0.0 0.0 -1.4293895 -0.08410545 0.0 0.0 -8.980116 6.7672415 0.0 0.0
   -97.57667 2.639816 0.0 0.0 -754.371 -252.36913 0.0 0.0 -102.20833 -57.25394
   0.0 0.0 -1.3816658 -0.12380589 0.0 0.0 -1.3791537 -0.3042212 0.0 0.0 -9.96604
   -5.4742455 0.0 0.0 -11.854755 -1.2335981 0.0 0.0 -1.3614277 -0.08454488 0.0
   0.0 -86.02556 13.190242 0.0 0.0 -10.439566 -4.891143 0.0 0.0 -1.1048009
   0.31027752 0.0 0.0 -43.59005 -59.099472 0.0 0.0 -111.26588 1.6729418 0.0 0.0
   -1.4218438 -0.31108302 0.0 0.0 -1.0793117 -0.7315769 0.0 0.0 -10.69266
   -5.7766395 0.0 0.0 -9.152716 -3.194553 0.0 0.0 -9.765148 -0.2496573 0.0 0.0
   -1.2904222 0.6513657 0.0 0.0 -10.293101 -5.9849243 0.0 0.0 -98.557686
   4.417684 0.0 0.0 -11.8298025 -0.5488307 0.0 0.0 -9.306735 6.1791835 0.0 0.0
   -8.494697 -4.6034174 0.0 0.0 -86.797005 -8.79577 0.0 0.0 -68.2444 -52.35505
   0.0 0.0 -78.53265 -36.510025 0.0 0.0 -89.90646 18.174904 0.0 0.0 -8.112616
   -4.4445024 0.0 0.0 -1.4394637 0.063037015 0.0 0.0 -12.96259 -5.5863895 0.0
   0.0 -10.433354 0.7788055 0.0 0.0 -83.88262 -30.96609 0.0 0.0 -1.3954087
   0.3098622 0.0 0.0 -10.8363285 1.4556489 0.0 0.0 -1.2441161 -0.4574051 0.0 0.0
   -69.74547 -60.268353 0.0 0.0 -11.769274 1.4532267 0.0 0.0 -1.4772877
   0.1674475 0.0 0.0 -1.3209982 -0.6384876 0.0 0.0 -821.6291 471.42044 0.0 0.0
   -9.6839 -5.0789175 0.0 0.0 -1.4639255 -0.14888234 0.0 0.0 -91.5418 -26.319405
   0.0 0.0 -1.2426103 -0.69251406 0.0 0.0 -9.700819 6.66954 0.0 0.0 -89.1265
   -31.440016 0.0 0.0 -99.045975 6.483125 0.0 0.0 -91.84583 -42.54585 0.0 0.0
   -16.284151 0.6231625 0.0 0.0 -90.65876 17.638882 0.0 0.0 -9.868864 -5.6082687
   0.0 0.0 -1.332671 0.2846459 0.0 0.0 -88.76332 6.6548834 0.0 0.0 -1.2414725
   0.80396056 0.0 0.0 -1.4501119 0.31588435 0.0 0.0 -135.13649 -14.806076 0.0
   0.0 -120.429375 31.553959 0.0 0.0 -10.003979 -7.517187 0.0 0.0 -111.38507
   38.224056 0.0 0.0 -9.109815 5.494565 0.0 0.0 -9.940553 -1.4375213 0.0 0.0
   -8.905678 -4.0403285 0.0 0.0 -10.854699 -4.5336676 0.0 0.0 -1.0912709
   0.87321246 0.0 0.0 -1.3924125 -0.494439 0.0 0.0 -11.759832 -2.6613266 0.0 0.0
   -8.458071 7.1762414 0.0 0.0 -11.749382 -1.731461 0.0 0.0 -1167.4884
   -275.77875 0.0 0.0 -88.75471 32.58185 0.0 0.0 -9.910467 -6.869333 0.0 0.0
   -8.251601 -4.6311026 0.0 0.0 -10.25718 -1.5115894 0.0 0.0 -11.156247
   -5.3366084 0.0 0.0 -85.9973 -50.42692 0.0 0.0 -1.109817 -0.8909057 0.0 0.0
   -1.3854764 0.38261652 0.0 0.0 -98.687836 15.365354 0.0 0.0 -1.3225648
   -0.49270847 0.0 0.0 -9.798542 -1.3800157 0.0 0.0 -100.294174 -14.019927 0.0
   0.0 -88.30041 32.8968 0.0 0.0 -11.082215 -1.0013312 0.0 0.0 -7.0949903
   -7.8301964 0.0 0.0 -1.2429006 0.608696 0.0 0.0 -0.94869477 -1.0860211 0.0 0.0
   -10.283922 -4.225079 0.0 0.0 -0.5046287 0.12948456 0.0 0.0 -7.208642
   -8.181048 0.0 0.0 -1.4111769 0.15300004 0.0 0.0 -85.34883 -26.56656 0.0 0.0
   -11.146362 4.0250487 0.0 0.0 -1.4191623 -0.20182484 0.0 0.0 -91.03103
   39.11878 0.0 0.0 -1.3883835 -0.23478465 0.0 0.0 -12.3043995 -0.19960034 0.0
   0.0 -1184.2778 -284.28128 0.0 0.0 -89.39126 7.424997 0.0 0.0 -824.56915
   -109.94603 0.0 0.0 -1.2369502 -0.06694533 0.0 0.0 -76.00247 -47.92318 0.0 0.0
   -118.08772 24.594418 0.0 0.0 -1.3896364 -0.20694643 0.0 0.0 -1.4357831
   0.20228854 0.0 0.0 -10.813301 4.949309 0.0 0.0 -66.95153 -60.265247 0.0 0.0
   -91.153564 -57.172276 0.0 0.0 -1.472194 0.045342725 0.0 0.0 -1.4234489
   -0.0062105544 0.0 0.0 -117.495735 18.8665 0.0 0.0 -1.37082 0.050406784 0.0
   0.0 -88.705086 27.711744 0.0 0.0 -11.383662 -5.1280932 0.0 0.0 -1.0602182
   -0.9930429 0.0 0.0 -89.40367 -41.93752 0.0 0.0 -1.2707835 0.22979152 0.0 0.0
   -154.60863 70.0657 0.0 0.0 -93.76908 -21.369226 0.0 0.0 -107.48493 -21.19034
   0.0 0.0 -1.4597386 -0.013745977 0.0 0.0 -1.3441454 0.27318147 0.0 0.0
   -9.862433 2.6066053 0.0 0.0 -61.29669 -81.46046 0.0 0.0 -10.77637 0.5974055
   0.0 0.0 -1.4721715 -0.07336613 0.0 0.0 -1.310572 -0.6730309 0.0 0.0 -862.2566
   -147.63986 0.0 0.0 -10.066124 -7.2485924 0.0 0.0 -1.3450618 0.6312277 0.0 0.0
   -103.829475 -0.7807802 0.0 0.0 -1.5278087 0.1631819 0.0 0.0 -1.3502456
   -0.3154653 0.0 0.0 -81.37022 -41.451122 0.0 0.0 -1.4593347 0.0012688879 0.0
   0.0 -110.83929 44.312527 0.0 0.0 -1.3315752 0.597434 0.0 0.0 -102.92995
   12.82545 0.0 0.0 -9.76608 -4.979924 0.0 0.0 -1.3886944 0.35914385 0.0 0.0
   -99.31607 23.848352 0.0 0.0 -1.4525611 -0.15980507 0.0 0.0 -10.520366
   -1.4902389 0.0 0.0 -9.772418 2.241525 0.0 0.0 -1.2285527 -0.43134683 0.0 0.0
   -128.20448 44.07622 0.0 0.0 -101.669655 -23.343327 0.0 0.0 -1.3436531
   -0.20893009 0.0 0.0 -91.03497 -7.82473 0.0 0.0 -127.858246 -47.326256 0.0 0.0
   -107.85819 43.068745 0.0 0.0 -95.878555 -47.32545 0.0 0.0 -1.2560692
   -0.7279362 0.0 0.0 -9.61892 -3.9139218 0.0 0.0 -864.10846 59.956303 0.0 0.0
   -1.4546428 -0.04064941 0.0 0.0 -9.560695 -3.7197893 0.0 0.0 -13.2394495
   -3.6967318 0.0 0.0 -92.17044 7.01908 0.0 0.0 -13.132691 -0.1454439 0.0 0.0
   -91.61403 12.857639 0.0 0.0 -1.3414892 -0.39438665 0.0 0.0 -1.4224144
   0.263849 0.0 0.0 -1.4276078 0.014728308 0.0 0.0 -1050.874 -232.28229 0.0 0.0
   -1.2747732 0.41714978 0.0 0.0 -94.737144 12.796324 0.0 0.0 -0.90471905
   -1.1183474 0.0 0.0 -101.091576 -30.93987 0.0 0.0 -1.2204905 0.40623525 0.0
   0.0 -11.786409 -1.0114667 0.0 0.0 -128.09703 -69.51808 0.0 0.0 -1.1654352
   -0.816528 0.0 0.0 -11.322577 0.15199919 0.0 0.0 -878.56085 -24.266167 0.0 0.0
   -1.383719 0.34194633 0.0 0.0 -1.3663619 -0.26015815 0.0 0.0 -1.4271033
   0.36509416 0.0 0.0 -112.34081 -2.937581 0.0 0.0 -874.6653 -114.22874 0.0 0.0
   -1.2907887 -0.46158558 0.0 0.0 -9.668146 -5.917934 0.0 0.0 -1.4176532
   -0.11236953 0.0 0.0 -1.3665721 -0.25199586 0.0 0.0 -11.8299885 -4.6248417 0.0
   0.0 -1.0868723 -0.9919831 0.0 0.0 -10.761381 -6.1199417 0.0 0.0 -757.93994
   -560.0234 0.0 0.0 -9.719585 -5.6592126 0.0 0.0 -11.184345 -2.4566236 0.0 0.0
   -11.798333 4.2299056 0.0 0.0 -92.259964 -47.713387 0.0 0.0 -80.00636 54.24864
   0.0 0.0 -107.17223 -3.2062392 0.0 0.0 -0.9131655 -1.0891304 0.0 0.0
   -94.135155 33.48149 0.0 0.0 -1.1442586 0.7456531 0.0 0.0 -160.25275
   -30.951412 0.0 0.0 -11.52735 4.2990484 0.0 0.0 -94.31351 -12.831176 0.0 0.0
   -95.0793 -52.478592 0.0 0.0 -9.770163 -5.4832315 0.0 0.0 -847.30493
   -435.98495 0.0 0.0 -105.748665 15.927542 0.0 0.0 -1.014072 0.777156 0.0 0.0
   -63.718735 67.91262 0.0 0.0 -10.833417 -6.9736905 0.0 0.0 -650.1615 622.52606
   0.0 0.0 -1.5023496 0.1778863 0.0 0.0 -12.258769 -2.2420983 0.0 0.0 -1.192584
   -0.0589425 0.0 0.0 -1.1653718 -0.7467863 0.0 0.0 -100.79449 13.747811 0.0 0.0
   -1.4066502 0.06581342 0.0 0.0 -141.98029 -48.12598 0.0 0.0 -1.4578952
   0.3111343 0.0 0.0 -1.4362018 -0.29101852 0.0 0.0 -1.2878387 -0.31812087 0.0
   0.0 -901.3659 -487.2836 0.0 0.0 -97.94458 30.010159 0.0 0.0 -1.3627806
   0.50530386 0.0 0.0 -88.64061 33.361214 0.0 0.0 -1.246366 -0.68702203 0.0 0.0
   -93.39899 -21.43759 0.0 0.0 -10.906985 -1.4171823 0.0 0.0 -87.44302
   -53.784435 0.0 0.0 -1.4835626 0.046599105 0.0 0.0 -9.131355 -8.952267 0.0 0.0
   -10.142107 5.427589 0.0 0.0 -1.4244894 -0.3541945 0.0 0.0 -9.818005 1.4324416
   0.0 0.0 -117.63888 -2.9590907 0.0 0.0 -10.258353 0.13856244 0.0 0.0 -87.30082
   -52.46929 0.0 0.0 -11.443262 5.004013 0.0 0.0 -82.791016 -23.521553 0.0 0.0
   -12.77488 -0.78915024 0.0 0.0 -1.2283149 -0.70455754 0.0 0.0 -931.4792
   -657.2588 0.0 0.0 -12.959441 -0.34617049 0.0 0.0 -0.89850503 -1.1769458 0.0
   0.0 -1.4378489 -0.2674691 0.0 0.0 -5.475398 -8.73783 0.0 0.0 -1.3872082
   -0.43374118 0.0 0.0 -1.2529024 -0.559002 0.0 0.0 -118.107605 -17.341166 0.0
   0.0 -1.3281393 0.4772323 0.0 0.0 -118.42486 -20.203173 0.0 0.0 -72.76837
   -4.802829 0.0 0.0 -109.465935 13.408704 0.0 0.0 -12.652552 2.2884455 0.0 0.0
   -116.62927 -27.267935 0.0 0.0 -917.3832 150.53743 0.0 0.0 -1.5006238
   0.28305182 0.0 0.0 -92.27869 30.423845 0.0 0.0 -12.388453 -1.3780944 0.0 0.0
   -109.76931 -11.508991 0.0 0.0 -1.4842246 -0.13818456 0.0 0.0 -1.1302754
   -0.7932388 0.0 0.0 -10.283291 -1.9817537 0.0 0.0 -95.617386 -16.71919 0.0 0.0
   -7.648072 -9.121704 0.0 0.0 -97.12954 -16.040274 0.0 0.0 -78.9551 -77.93033
   0.0 0.0 -88.008865 -67.48437 0.0 0.0 -1.4176422 -0.13834926 0.0 0.0 -96.05548
   -19.477768 0.0 0.0 -114.64908 -3.8615954 0.0 0.0 -11.752721 4.495176 0.0 0.0
   -10.930633 -0.23553604 0.0 0.0 -1.2925209 -0.62554085 0.0 0.0 -10.461518
   0.42192504 0.0 0.0 -69.68719 -68.32404 0.0 0.0 -1.1061826 -0.477879 0.0 0.0
   -15.640211 -4.3252907 0.0 0.0 -10.623878 -0.51484865 0.0 0.0 -1.4139
   0.0052014887 0.0 0.0 -1.3642207 -0.51451397 0.0 0.0 -13.737083 0.91554075 0.0
   0.0 -11.174838 2.7790682 0.0 0.0 -97.7943 -6.1557612 0.0 0.0 -1.3639866
   0.1436241 0.0 0.0 -892.7265 -403.08337 0.0 0.0 -105.75995 -25.372858 0.0 0.0
   -11.917437 -1.9211719 0.0 0.0 -102.97973 -41.707336 0.0 0.0 -14.424711
   1.4497195 0.0 0.0 -1.324281 -0.06712225 0.0 0.0 -103.04148 -31.875765 0.0 0.0
   -685.7842 -663.7583 0.0 0.0 -15.982347 -6.9357514 0.0 0.0 -1.3257275
   -0.24493879 0.0 0.0 -11.3973 1.3410947 0.0 0.0 -1.2596742 -0.3765852 0.0 0.0
   -0.9318729 0.22733906 0.0 0.0 -112.26861 -3.8829405 0.0 0.0 -12.676008
   -5.5583677 0.0 0.0 -8.900649 -7.1369805 0.0 0.0 -104.92024 -69.51895 0.0 0.0
   -1.3777289 -0.19410673 0.0 0.0 -1.3627931 -0.7800026 0.0 0.0 -108.36086
   6.674376 0.0 0.0 -8.841463 -6.776337 0.0 0.0 -1.4696518 -0.014897194 0.0 0.0
   -10.8502445 -2.1592321 0.0 0.0 -12.674036 -4.9073358 0.0 0.0 -11.219297
   -1.9804956 0.0 0.0 -12.424353 -0.42289156 0.0 0.0 -1.2334552 -0.8366803 0.0
   0.0 -1.3953615 -0.30343786 0.0 0.0 -81.72647 48.0798 0.0 0.0 -111.8372
   10.860203 0.0 0.0 -103.73659 33.835503 0.0 0.0 -1.358972 -0.5762304 0.0 0.0
   -1.406275 -0.4932403 0.0 0.0 -1.392468 -0.024313316 0.0 0.0 -9.79301
   -6.4455914 0.0 0.0 -11.072202 -0.5748175 0.0 0.0 -1.4377564 0.07459962 0.0
   0.0 -0.9717619 -1.0439613 0.0 0.0 -11.390968 -6.276591 0.0 0.0 -0.7939052
   -1.183615 0.0 0.0 -1.3477648 0.19461197 0.0 0.0 -1.2060782 -0.31099212 0.0
   0.0 -1.1129524 -0.3969292 0.0 0.0 -9.870409 5.759536 0.0 0.0 -1.2592587
   0.67078483 0.0 0.0 -136.79697 4.3437896 0.0 0.0 -1.430685 -0.2777031 0.0 0.0
   -1.2192328 0.4439342 0.0 0.0 -100.858864 42.72 0.0 0.0 -10.193401 -6.7879844
   0.0 0.0 -11.515011 2.661245 0.0 0.0 -11.716915 -1.6862663 0.0 0.0 -0.9341139
   -0.9029803 0.0 0.0 -82.04133 -95.86307 0.0 0.0 -1.3619772 0.28292286 0.0 0.0
   -1.3765461 0.016279744 0.0 0.0 -0.9344305 -0.8759506 0.0 0.0 -0.8613928
   -1.165761 0.0 0.0 -104.436195 49.381573 0.0 0.0 -12.431079 2.4270914 0.0 0.0
   -11.528823 -2.1672726 0.0 0.0 -1.0984228 -0.9048464 0.0 0.0 -103.57024
   -10.575328 0.0 0.0 -109.40248 -1.2568777 0.0 0.0 -1.4410506 -0.29798618 0.0
   0.0 -1.0255847 -0.8666642 0.0 0.0 -1.4125111 -0.36259678 0.0 0.0 -1.3845954
   0.474779 0.0 0.0 -1.3809154 -0.29266486 0.0 0.0 -9.938708 -3.4659748 0.0 0.0
   -10.748562 -5.093313 0.0 0.0 -1.316563 0.39436162 0.0 0.0 -1.4082716
   -0.47509986 0.0 0.0 -10.258734 -1.935348 0.0 0.0 -130.02222 22.383463 0.0 0.0
   -1.4782728 -0.30756876 0.0 0.0 -97.28595 31.131191 0.0 0.0 -7.8119435
   -10.431689 0.0 0.0 -130.42047 -34.637768 0.0 0.0 -1.2177942 -0.8432208 0.0
   0.0 -10.978057 -4.9302406 0.0 0.0 -1.3451612 0.44582832 0.0 0.0 -92.82483
   41.944855 0.0 0.0 -11.789157 1.7099309 0.0 0.0 -10.267799 -4.5673666 0.0 0.0
   -14.410987 -3.6898549 0.0 0.0 -89.970924 -50.822437 0.0 0.0 -10.5053425
   -1.1500597 0.0 0.0 -1.4346938 -0.11072925 0.0 0.0 -1.4659523 -0.2130708 0.0
   0.0 -22.051287 -0.25795597 0.0 0.0 -106.39717 -8.351604 0.0 0.0 -1.4521425
   -0.04021015 0.0 0.0 -9.126617 -9.3658495 0.0 0.0 -1.0588502 0.9869886 0.0 0.0
   -98.97166 -26.670866 0.0 0.0 -83.23247 -70.81517 0.0 0.0 -1277.554 442.41016
   0.0 0.0 -132.05257 63.736706 0.0 0.0 -1.2603242 -0.4547673 0.0 0.0 -98.14059
   -40.119736 0.0 0.0 -9.090569 -5.2611446 0.0 0.0 -7.9589086 -7.4771214 0.0 0.0
   -99.0369 -48.384956 0.0 0.0 -10.2659235 -0.91910905 0.0 0.0 -10.731872
   -1.7829767 0.0 0.0 -9.802545 -6.3410664 0.0 0.0 -1.3607113 -0.25962973 0.0
   0.0 -999.8343 -343.67422 0.0 0.0 -11.164643 7.1837454 0.0 0.0 -12.914104
   1.594738 0.0 0.0 -1.3695091 0.09217348 0.0 0.0 -1.4368484 -0.085682765 0.0
   0.0 -88.432076 -66.337265 0.0 0.0 -1.4098102 -0.47461084 0.0 0.0 -14.254757
   -0.8355399 0.0 0.0 -8.257211 1.9661652 0.0 0.0 -1019.8795 -302.90732 0.0 0.0
   -108.56734 -34.62742 0.0 0.0 -1.323674 -0.589879 0.0 0.0 -1.1450812
   -0.63231516 0.0 0.0 -10.425084 -2.0687501 0.0 0.0 -160.24527 24.482882 0.0
   0.0 -1.418094 -0.23562059 0.0 0.0 -1.2944267 -0.596681 0.0 0.0 -12.439819
   -1.4862766 0.0 0.0 -13.108993 -1.6455433 0.0 0.0 -99.09513 31.500105 0.0 0.0
   -10.741701 -0.10015747 0.0 0.0 -104.86064 -4.546788 0.0 0.0 -1.3648046
   -0.18602473 0.0 0.0 -103.16516 -59.2895 0.0 0.0 -90.96872 59.46565 0.0 0.0
   -10.229226 -1.7099048 0.0 0.0 -1.2940658 0.32750982 0.0 0.0 -10.89222
   -1.6305885 0.0 0.0 -114.64701 8.382145 0.0 0.0 -115.30692 30.384748 0.0 0.0
   -12.932613 -6.412913 0.0 0.0 -1.4154971 -0.2688585 0.0 0.0 -10.4660225
   -6.025671 0.0 0.0 -1.4010655 0.20056455 0.0 0.0 -218.74861 24.390991 0.0 0.0
   -122.609215 69.5351 0.0 0.0 -924.26276 -497.9004 0.0 0.0 -1.400788
   -0.09058077 0.0 0.0 -117.07818 -17.157919 0.0 0.0 -1.0832305 -0.9853271 0.0
   0.0 -1.4186201 -0.20194599 0.0 0.0 -89.63809 57.384247 0.0 0.0 -112.29696
   -10.541107 0.0 0.0 -105.12782 -2.048694 0.0 0.0 -1.41162 -0.42667833 0.0 0.0
   -102.46983 13.230214 0.0 0.0 -10.064565 7.5143976 0.0 0.0 -1.4161487
   0.32818508 0.0 0.0 -103.11402 -57.75836 0.0 0.0 -1.4257859 -0.068251014 0.0
   0.0 -14.169601 -6.001319 0.0 0.0 -106.08766 13.420417 0.0 0.0 -1.3867598
   0.4500562 0.0 0.0 -11.965764 2.0310454 0.0 0.0 -10.090586 -4.6739683 0.0 0.0
   -1.4528495 -0.19110104 0.0 0.0 -1367.0712 -168.28667 0.0 0.0 -113.456635
   -7.7042375 0.0 0.0 -1.4203861 0.49865648 0.0 0.0 -90.81208 -79.79282 0.0 0.0
   -11.182295 4.605715 0.0 0.0 -10.045717 8.812475 0.0 0.0 -11.09196 1.1223407
   0.0 0.0 -10.850119 2.353228 0.0 0.0 -9.384235 3.4164212 0.0 0.0 -1.4812235
   -0.06791032 0.0 0.0 -152.83301 1.5408138 0.0 0.0 -11.78197 2.6609263 0.0 0.0
   -9.397031 6.507342 0.0 0.0 -118.82192 23.495728 0.0 0.0 -10.425666 -8.9842005
   0.0 0.0 -13.04655 2.7341518 0.0 0.0 -1.1801469 -0.83219695 0.0 0.0 -1.450045
   -0.16631758 0.0 0.0 -105.19855 17.224512 0.0 0.0 -171.0113 -33.61826 0.0 0.0
   -11.398602 4.243952 0.0 0.0 -113.19122 -88.8829 0.0 0.0 -12.471088
   -0.36241895 0.0 0.0 -0.9025338 -0.42380762 0.0 0.0 -10.212095 3.5604753 0.0
   0.0 -8.977552 -7.7614446 0.0 0.0 -1.4614532 0.101820245 0.0 0.0 -113.07755
   -58.21927 0.0 0.0 -11.842915 -5.478832 0.0 0.0 -1.2962267 -0.3512878 0.0 0.0
   -9.250184 9.532519 0.0 0.0 -1.4384075 0.1453901 0.0 0.0 -1.3802423 0.41752854
   0.0 0.0 -1.520545 -0.0064075748 0.0 0.0 -9.264437 6.0569363 0.0 0.0
   -128.69595 -41.842796 0.0 0.0 -1.1629357 -0.723374 0.0 0.0 -1068.0979
   -360.96133 0.0 0.0 -1.274158 0.71579874 0.0 0.0 -10.792561 -5.820917 0.0 0.0
   -12.153922 0.5284883 0.0 0.0 -1.2419972 -0.5963886 0.0 0.0 -13.539733
   0.93097216 0.0 0.0 -10.586152 -6.063603 0.0 0.0 -118.33107 -26.372028 0.0 0.0
   -12.755851 4.6807804 0.0 0.0 -11.57069 7.3527446 0.0 0.0 -1.5883296
   -0.5321403 0.0 0.0 -0.9712555 -1.10026 0.0 0.0 -110.7734 -22.821056 0.0 0.0
   -12.835717 -1.9988965 0.0 0.0 -115.302986 -90.47919 0.0 0.0 -156.29 -4.429165
   0.0 0.0 -7.767533 -10.027045 0.0 0.0 -11.791429 3.3641646 0.0 0.0 -1.4420978
   -0.14885312 0.0 0.0 -1.3947086 -0.27101558 0.0 0.0 -12.052977 1.417108 0.0
   0.0 -1.4613025 -0.5846726 0.0 0.0 -1071.625 500.03714 0.0 0.0 -1.4727694
   -0.22701174 0.0 0.0 -112.26087 -61.648144 0.0 0.0 -108.87036 50.497982 0.0
   0.0 -1.2895397 0.27172807 0.0 0.0 -1.4791005 -0.10777962 0.0 0.0 -110.488556
   -51.556736 0.0 0.0 -108.22487 23.992289 0.0 0.0 -11.064868 6.159309 0.0 0.0
   -1.3331268 0.40243486 0.0 0.0 -13.795979 4.1438565 0.0 0.0 -1.2645674
   -0.36704588 0.0 0.0 -11.263542 0.7687932 0.0 0.0 -1.4538854 0.15976724 0.0
   0.0 -124.60045 2.2978473 0.0 0.0 -1.3969766 -0.22907355 0.0 0.0 -109.0124
   -29.935863 0.0 0.0 -1.108579 -0.76027703 0.0 0.0 -1.3672786 -0.5511608 0.0
   0.0 -11.448303 -5.0241523 0.0 0.0 -1.4817472 -0.12812148 0.0 0.0 -1.4700192
   -0.14534885 0.0 0.0 -1.2358717 -0.6187019 0.0 0.0 -1.3809528 0.23368913 0.0
   0.0 -9.650892 -5.8165774 0.0 0.0 -1.4162362 -0.3931849 0.0 0.0 -1.4056035
   0.33613157 0.0 0.0 -13.166641 -0.15698834 0.0 0.0 -9.576414 7.5557127 0.0 0.0
   -1.3943117 0.3745955 0.0 0.0 -124.93079 -14.635728 0.0 0.0 -10.121399
   0.80330074 0.0 0.0 -1573.54 -8.1668 0.0 0.0 -118.976036 -52.34738 0.0 0.0
   -10.282455 3.9056804 0.0 0.0 -1.4195744 0.13475591 0.0 0.0 -804.1877
   -800.52423 0.0 0.0 -104.738174 -70.15707 0.0 0.0 -1135.3009 45.697514 0.0 0.0
   -12.042143 4.792298 0.0 0.0 -1035.6896 470.94788 0.0 0.0 -1.4740375
   0.19459619 0.0 0.0 -139.15643 -6.057842 0.0 0.0 -1.3361946 0.22777867 0.0 0.0
   -11.335961 5.093409 0.0 0.0 -1.4277837 -0.3806298 0.0 0.0 -1.1445838
   0.0831343 0.0 0.0 -114.02358 -37.21936 0.0 0.0 -121.96361 93.15342 0.0 0.0
   -105.37492 -70.41673 0.0 0.0 -111.794716 -50.525257 0.0 0.0 -1183.3259
   56.833145 0.0 0.0 -1.4604306 -0.041255508 0.0 0.0 -128.3943 -77.279686 0.0
   0.0 -1.3027344 -0.20227987 0.0 0.0 -10.652039 4.653316 0.0 0.0 -1.4551798
   0.2939203 0.0 0.0 -1.4105973 -0.030169278 0.0 0.0 -1.4628313 0.04191912 0.0
   0.0 -1.4605194 0.0017723516 0.0 0.0 -9.5371275 -2.868112 0.0 0.0 -104.23319
   -65.81959 0.0 0.0 -10.127833 6.3051267 0.0 0.0 -1.4127492 -0.34120834 0.0 0.0
   -1.3610762 0.10175915 0.0 0.0 -13.834206 -0.106758595 0.0 0.0 -1.3035284
   0.62836903 0.0 0.0 -1.4266319 -0.030896166 0.0 0.0 -1.2034009 0.8500668 0.0
   0.0 -148.04344 -102.06785 0.0 0.0 -11.32548 0.81082726 0.0 0.0 -1.3234023
   -0.46199942 0.0 0.0 -1.3984982 0.062496275 0.0 0.0 -10.674756 -7.0797467 0.0
   0.0 -10.178918 -6.992762 0.0 0.0 -1.0441041 -0.6448585 0.0 0.0 -1.225326
   0.5417964 0.0 0.0 -10.870884 -1.0203365 0.0 0.0 -1.2397509 0.39481014 0.0 0.0
   -1.1105138 -0.7474188 0.0 0.0 -14.0041275 -3.1533084 0.0 0.0 -1.3145486
   0.22653091 0.0 0.0 -11.946461 -4.4650197 0.0 0.0 -9.5671215 -7.3780866 0.0
   0.0 -12.322645 -0.112574436 0.0 0.0 -12.932352 -0.3871423 0.0 0.0 -11.193981
   5.070875 0.0 0.0 -1.3745352 -0.33207494 0.0 0.0 -100.38181 -87.79888 0.0 0.0
   -1.3166981 -0.22760177 0.0 0.0 -12.367674 0.93870896 0.0 0.0 -12.895479
   -3.230827 0.0 0.0 -10.291026 -3.7572453 0.0 0.0 -1.2732835 -0.40258145 0.0
   0.0 -1.1353273 0.49030158 0.0 0.0 -105.527084 -50.628147 0.0 0.0 -1.2870486
   -0.07055967 0.0 0.0 -115.879166 35.301807 0.0 0.0 -1.229798 -0.19550836 0.0
   0.0 -1.2667199 -0.41373035 0.0 0.0 -11.722515 -4.6416135 0.0 0.0 -9.351116
   5.823613 0.0 0.0 -10.882962 0.027655484 0.0 0.0 -99.26217 -55.222324 0.0 0.0
   -97.97789 57.56851 0.0 0.0 -1.2804292 -0.39215502 0.0 0.0 -1.2526422
   0.32289493 0.0 0.0 -11.257765 -7.3666883 0.0 0.0 -132.88649 21.684671 0.0 0.0
   -10.491338 -6.5769563 0.0 0.0 -0.43851322 -0.2600664 0.0 0.0 -1.199492
   0.30999517 0.0 0.0 -1.1387038 -0.6560044 0.0 0.0 -11.236894 2.0565298 0.0 0.0
   -13.598772 -2.948559 0.0 0.0 -13.572083 7.303678 0.0 0.0 -10.72758 6.6566052
   0.0 0.0 -11.000359 -1.1161683 0.0 0.0 -19.471045 7.1668057 0.0 0.0 -1.1815957
   -0.63049644 0.0 0.0 -1.33939 -0.032817993 0.0 0.0 -1.2707274 -0.3232573 0.0
   0.0 -1.3190317 -0.0655454 0.0 0.0 -1.2522172 0.45707247 0.0 0.0 -1.2018571
   -0.59518784 0.0 0.0 -1.1555943 -0.6188591 0.0 0.0 -11.567963 4.724486 0.0 0.0
   -10.907346 3.4978838 0.0 0.0 -103.9103 73.1334 0.0 0.0 -1.2547766 -0.46234247
   0.0 0.0 -101.60694 -61.71747 0.0 0.0 -120.219986 19.579823 0.0 0.0 -1.2434554
   -0.5003819 0.0 0.0 -12.503716 -2.7158456 0.0 0.0 -12.20388 -1.615098 0.0 0.0
   -1.2990395 0.2543389 0.0 0.0 -112.10196 40.51629 0.0 0.0 -12.541552
   -3.2931287 0.0 0.0 -12.236723 2.70958 0.0 0.0 -1.2842319 -0.2797481 0.0 0.0
   -226.96341 7.123201 0.0 0.0 -1.2031332 0.08327972 0.0 0.0 -11.856447
   -2.2888846 0.0 0.0 -1.276426 0.3875488 0.0 0.0 -11.398559 4.9700933 0.0 0.0
   -1.0981704 -0.61328447 0.0 0.0 -118.0941 19.71191 0.0 0.0 -9.397138 -6.620605
   0.0 0.0 -1.3265722 0.09802428 0.0 0.0 -1.3304784 -0.16784045 0.0 0.0
   -19.355627 8.184459 0.0 0.0 -1.314578 -0.17429549 0.0 0.0 -1.3549229
   -0.40186077 0.0 0.0 -1.2917039 0.2758047 0.0 0.0 -113.64003 -23.979473 0.0
   0.0 -1.3265576 0.09076628 0.0 0.0 -0.8523163 -1.0181594 0.0 0.0 -11.634057
   4.00233 0.0 0.0 -1.4160212 -0.27236125 0.0 0.0 -162.92006 92.394005 0.0 0.0
   -1.1827986 -0.8020654 0.0 0.0 -1.1275489 0.69630283 0.0 0.0 -1.2579013
   -0.44764933 0.0 0.0 -1.3354796 -0.017800398 0.0 0.0 -1.1148214 -0.3525178 0.0
   0.0 -10.317826 -8.802282 0.0 0.0 -1.0018806 0.508944 0.0 0.0 -10.8498
   6.363403 0.0 0.0 -1.2936968 0.09483071 0.0 0.0 -1.2065686 -0.5588393 0.0 0.0
   -10.937559 11.188179 0.0 0.0 -1.2926162 0.026613362 0.0 0.0 -17.044245
   -6.683651 0.0 0.0 -114.72636 38.962307 0.0 0.0 -12.614518 0.05794671 0.0 0.0
   -1.0530446 -0.03132724 0.0 0.0 -10.338693 -3.2535858 0.0 0.0 -129.88446
   4.047027 0.0 0.0 -14.259714 -7.7626476 0.0 0.0 -1.0525287 -0.18542907 0.0 0.0
   -1.2944615 -0.19564223 0.0 0.0 -1.3137089 -0.09445856 0.0 0.0 -1.0525873
   0.4984082 0.0 0.0 -1.3974532 -0.15097919 0.0 0.0 -11.528696 0.29084474 0.0
   0.0 -1.0840555 -0.41219217 0.0 0.0 -1.0219151 0.6797932 0.0 0.0 -1.061507
   -0.6703481 0.0 0.0 -1.31825 -0.03392008 0.0 0.0 -1.0581381 -0.07299401 0.0
   0.0 -1.2977954 -0.07304722 0.0 0.0 -111.223404 -50.431267 0.0 0.0 -1.27609
   0.29839447 0.0 0.0 -1.2634966 -0.44162953 0.0 0.0 -1.8634386 -0.09836769 0.0
   0.0 -0.9121667 -0.16115671 0.0 0.0 -11.963958 -1.3087225 0.0 0.0 -1.337813
   0.073170796 0.0 0.0 -120.60574 -21.444845 0.0 0.0 -1.0847975 -0.6758289 0.0
   0.0 -1.2629586 -0.31545806 0.0 0.0 -11.1749325 -1.3857545 0.0 0.0 -0.9603614
   -0.91025525 0.0 0.0 -12.275389 -2.8328128 0.0 0.0 -1.321137 -0.20852025 0.0
   0.0 -12.364375 -1.6373998 0.0 0.0 -1.0662155 -0.97380906 0.0 0.0 -1.3312868
   0.045011986 0.0 0.0 -1.2975359 0.14336854 0.0 0.0 -1.1439112 -0.70084846 0.0
   0.0 -1.2973343 0.14575419 0.0 0.0 -12.034581 -0.06543097 0.0 0.0 -12.170025
   -4.3670716 0.0 0.0 -1.0083221 -0.8873638 0.0 0.0 -1.2829757 -0.30295146 0.0
   0.0 -13.600341 -4.1999087 0.0 0.0 -7.2993464 -8.573049 0.0 0.0 -1.1232641
   0.5590643 0.0 0.0 -0.9808567 -0.89510065 0.0 0.0 -138.83582 29.304962 0.0 0.0
   -1.1491164 0.66684604 0.0 0.0 -10.509137 -7.1097403 0.0 0.0 -11.389176
   -6.3753047 0.0 0.0 -1.2815626 -0.47417516 0.0 0.0 -18.428555 -9.868732 0.0
   0.0 -11.222066 -3.8794682 0.0 0.0 -12.377581 1.9827468 0.0 0.0 -121.886055
   -23.102972 0.0 0.0 -13.567214 0.6477005 0.0 0.0 -1.2229685 -0.39501548 0.0
   0.0 -117.73572 -39.60348 0.0 0.0 -1.3092022 -0.02918331 0.0 0.0 -132.37369
   -15.026973 0.0 0.0 -10.979965 2.5660527 0.0 0.0 -1.2502197 -0.41905266 0.0
   0.0 -1.2883781 0.2577395 0.0 0.0 -132.498 -16.028366 0.0 0.0 -1.2953964
   0.17984332 0.0 0.0 -134.67928 73.476105 0.0 0.0 -1.4357663 0.17852667 0.0 0.0
   -10.880205 -3.1411083 0.0 0.0 -11.1988325 -7.0152783 0.0 0.0 -12.324516
   -3.447245 0.0 0.0 -1.3149438 -0.18170634 0.0 0.0 -1.3747923 -0.3166349 0.0
   0.0 -11.74541 0.46273807 0.0 0.0 -115.71881 34.73762 0.0 0.0 -1.2899234
   -0.037739627 0.0 0.0 -12.308539 3.5915115 0.0 0.0 -1.2813231 -0.28017476 0.0
   0.0 -12.777879 0.9572216 0.0 0.0 -124.14594 -37.830208 0.0 0.0 -1.2190478
   -0.5402331 0.0 0.0 -1.2501596 0.4780853 0.0 0.0 -122.638275 -26.726358 0.0
   0.0 -1.1922216 -0.44926196 0.0 0.0 -1.3077075 -0.20181182 0.0 0.0 -12.583284
   -1.201522 0.0 0.0 -11.35296 -0.29181695 0.0 0.0 -11.263416 4.9970083 0.0 0.0
   -1.2523482 0.19511265 0.0 0.0 -9.89478 7.973619 0.0 0.0 -125.41545 -61.792683
   0.0 0.0 -85.19699 -86.89703 0.0 0.0 -1.2487001 -0.41456044 0.0 0.0 -154.02364
   -20.797058 0.0 0.0 -10.044348 6.2143397 0.0 0.0 -104.896 -77.9672 0.0 0.0
   -0.8298218 0.1519515 0.0 0.0 -1.3063928 0.3321914 0.0 0.0 -1.2903671
   -0.07222383 0.0 0.0 -12.579837 0.9733982 0.0 0.0 -11.531918 -2.5704165 0.0
   0.0 -11.100782 -2.7258997 0.0 0.0 -12.762955 -1.0022795 0.0 0.0 -121.96774
   -9.196754 0.0 0.0 -24.458975 6.6237054 0.0 0.0 -1.3281366 0.07688305 0.0 0.0
   -1.240106 0.179705 0.0 0.0 -1.3356831 0.025172183 0.0 0.0 -1.2096874
   0.32118255 0.0 0.0 -12.558105 -1.8972732 0.0 0.0 -129.53537 -22.995413 0.0
   0.0 -1.1109539 0.68471444 0.0 0.0 -1.3182452 0.08765585 0.0 0.0 -1.1275085
   -0.33399612 0.0 0.0 -21.036882 2.3033276 0.0 0.0 -0.9123285 -0.84665143 0.0
   0.0 -1.2270238 0.19092654 0.0 0.0 -1.2593611 -0.41316292 0.0 0.0 -11.128842
   6.9381495 0.0 0.0 -162.74907 -8.591052 0.0 0.0 -1.2278808 0.21392713 0.0 0.0
   -12.680737 2.1180542 0.0 0.0 -1.1702763 0.5279653 0.0 0.0 -1.1866657
   -0.56460613 0.0 0.0 -1.2343324 -0.44213274 0.0 0.0 -12.624345 -1.4377253 0.0
   0.0 -9.983885 5.4279017 0.0 0.0 -119.87032 -44.805744 0.0 0.0 -135.14029
   24.464865 0.0 0.0 -115.728806 43.57609 0.0 0.0 -1.3152966 -0.12498098 0.0 0.0
   -9.978757 -8.41908 0.0 0.0 -10.46101 4.783947 0.0 0.0 -13.798893 6.068164 0.0
   0.0 -1.3602374 0.7096721 0.0 0.0 -12.854566 -1.856893 0.0 0.0 -11.816273
   -1.4982917 0.0 0.0 -12.670078 -1.9016188 0.0 0.0 -111.01359 81.88731 0.0 0.0
   -122.0857 -22.715458 0.0 0.0 -1.3146493 -0.010241024 0.0 0.0 -9.135536
   -8.291164 0.0 0.0 -1.2903651 0.036515534 0.0 0.0 -12.168134 -4.5971003 0.0
   0.0 -0.9762848 -0.6491696 0.0 0.0 -9.157183 6.234979 0.0 0.0 -1.3169659
   -0.13162044 0.0 0.0 -0.85542655 -0.1326516 0.0 0.0 -1.2750424 0.3232802 0.0
   0.0 -12.151508 2.295966 0.0 0.0 -12.735825 -4.6685123 0.0 0.0 -1.2364671
   0.47896704 0.0 0.0 -1.1489373 -0.6649926 0.0 0.0 -1.1857266 0.6266149 0.0 0.0
   -1.3856899 -0.65640235 0.0 0.0 -10.8350935 -7.166869 0.0 0.0 -13.047566
   -0.3667743 0.0 0.0 -10.436332 -5.1190104 0.0 0.0 -1.2909044 -0.6068005 0.0
   0.0 -1.4858279 -0.10830398 0.0 0.0 -1.3612165 0.4071479 0.0 0.0 -1.3248968
   -0.20887342 0.0 0.0 -13.714078 3.8707032 0.0 0.0 -15.429641 4.450352 0.0 0.0
   -77.88733 -98.43311 0.0 0.0 -1.255479 -0.43081877 0.0 0.0 -1036.9203
   -1056.406 0.0 0.0 -189.32121 -82.15657 0.0 0.0 -120.81023 34.967476 0.0 0.0
   -1.3844975 -0.40976375 0.0 0.0 -1.3259093 0.60551155 0.0 0.0 -1.4723016
   -0.04510878 0.0 0.0 -19.78524 -0.2980909 0.0 0.0 -1.3870645 -0.3913494 0.0
   0.0 -1.4083569 -0.43212602 0.0 0.0 -12.125008 2.4599235 0.0 0.0 -1.4060225
   -0.39834177 0.0 0.0 -1.3610984 -0.47536448 0.0 0.0 -13.044454 0.6876712 0.0
   0.0 -1123.1904 -466.0618 0.0 0.0 -1374.7803 212.95578 0.0 0.0 -1.3265376
   -0.29310814 0.0 0.0 -11.373157 -6.477069 0.0 0.0 -0.83296585 -1.1777276 0.0
   0.0 -121.07197 -37.096226 0.0 0.0 -1.3497806 0.26918465 0.0 0.0 -11.488233
   -6.5864835 0.0 0.0 -11.719626 1.2486883 0.0 0.0 -125.452774 18.313963 0.0 0.0
   -10.334537 -6.0196986 0.0 0.0 -1.3955469 -0.22724065 0.0 0.0 -1.3295791
   -0.6564396 0.0 0.0 -1.4428612 0.09249578 0.0 0.0 -147.22182 -55.43272 0.0 0.0
   -1.41117 0.33574224 0.0 0.0 -13.808511 -4.562951 0.0 0.0 -13.66023 2.6728866
   0.0 0.0 -1.325787 -0.50006884 0.0 0.0 -1.3795477 -0.47796395 0.0 0.0
   -0.8665764 -0.64326864 0.0 0.0 -1563.2294 -118.72089 0.0 0.0 -11.185342
   -8.369641 0.0 0.0 -1.4189004 -0.31201023 0.0 0.0 -1.362672 -0.23653322 0.0
   0.0 -1.2576538 -0.71922237 0.0 0.0 -1.3712647 0.163876 0.0 0.0 -131.42046
   -18.398697 0.0 0.0 -1.4274997 0.0084043145 0.0 0.0 -2.2653449 -0.12303388 0.0
   0.0 -1.3610591 0.43758002 0.0 0.0 -1.4909244 0.006516641 0.0 0.0 -14.412161
   0.7809804 0.0 0.0 -1.3749607 -0.34703383 0.0 0.0 -14.473289 1.9603621 0.0 0.0
   -122.75936 35.592537 0.0 0.0 -20.182354 -4.5200086 0.0 0.0 -13.872314
   4.799102 0.0 0.0 -14.099777 -4.458642 0.0 0.0 -1251.8406 679.55725 0.0 0.0
   -1.3961477 0.21798871 0.0 0.0 -1.3812485 -0.11777809 0.0 0.0 -12.759917
   -5.728895 0.0 0.0 -1.0690697 -0.9933252 0.0 0.0 -137.99496 -9.049887 0.0 0.0
   -140.40193 -44.121777 0.0 0.0 -0.5516519 -0.5782686 0.0 0.0 -1.2812145
   -0.53763247 0.0 0.0 -1.4133594 -0.118927 0.0 0.0 -1.2935675 0.17028263 0.0
   0.0 -118.87477 -61.349274 0.0 0.0 -14.53938 -1.9269568 0.0 0.0 -18.968084
   -4.301661 0.0 0.0 -135.14366 -31.70667 0.0 0.0 -1.2548828 -0.7197207 0.0 0.0
   -1.3794004 0.7018458 0.0 0.0 -11.081705 -5.3811827 0.0 0.0 -10.03144
   -8.530195 0.0 0.0 -13.018628 -6.9603477 0.0 0.0 -141.11473 40.397503 0.0 0.0
   -1.3986627 0.24588151 0.0 0.0 -1.4471062 0.12056751 0.0 0.0 -1.4677341
   -0.15649487 0.0 0.0 -1.3407356 -0.62816846 0.0 0.0 -14.667408 -2.7935653 0.0
   0.0 -14.96704 -6.1860027 0.0 0.0 -9.021412 7.899742 0.0 0.0 -1.4607576
   -0.05449738 0.0 0.0 -1.1085883 -0.82843405 0.0 0.0 -13.369621 0.6724123 0.0
   0.0 -1.1767697 -0.8370005 0.0 0.0 -95.68493 -87.98115 0.0 0.0 -14.569019
   3.2326543 0.0 0.0 -1.2864344 0.2877359 0.0 0.0 -0.9379936 0.7120199 0.0 0.0
   -1.3595494 -0.51897144 0.0 0.0 -1.4609182 0.0192402 0.0 0.0 -1.1851411
   -0.46519747 0.0 0.0 -129.16553 -18.850483 0.0 0.0 -14.93069 -3.15986 0.0 0.0
   -136.78348 63.74385 0.0 0.0 -140.25414 21.569052 0.0 0.0 -12.681819 8.296907
   0.0 0.0 -128.02919 -58.13127 0.0 0.0 -11.937286 -4.733651 0.0 0.0 -150.00432
   -19.125872 0.0 0.0 -13.861636 -2.3613484 0.0 0.0 -15.8963375 0.025434637 0.0
   0.0 -1.4815055 0.11006132 0.0 0.0 -2118.1003 -1023.20825 0.0 0.0 -137.03427
   -33.272034 0.0 0.0 -141.46774 -42.299618 0.0 0.0 -179.24637 78.76424 0.0 0.0
   -1.460879 0.08925692 0.0 0.0 -1.332238 0.07893343 0.0 0.0 -13.034203
   -3.3585677 0.0 0.0 -1.3205001 0.18081345 0.0 0.0 -1.3890975 -0.16448478 0.0
   0.0 -1.4163486 0.16013536 0.0 0.0 -12.734351 1.6089633 0.0 0.0 -1.4552169
   -0.22103478 0.0 0.0 -12.329966 -4.531739 0.0 0.0 -1465.451 -760.64215 0.0 0.0
   -13.984957 -2.216334 0.0 0.0 -12.99157 -4.2931166 0.0 0.0 -161.62578 54.87431
   0.0 0.0 -136.97746 -36.52761 0.0 0.0 -12.222377 -5.8205333 0.0 0.0 -142.9848
   37.215824 0.0 0.0 -150.0973 9.938273 0.0 0.0 -1.5663083 -0.41794083 0.0 0.0
   -122.79945 -49.179646 0.0 0.0 -109.58354 -90.821846 0.0 0.0 -132.96054
   15.974845 0.0 0.0 -1412.9563 -629.4649 0.0 0.0 -1.3005066 0.013966933 0.0 0.0
   -148.32149 -61.29205 0.0 0.0 -1.2181667 0.56487817 0.0 0.0 -15.07961
   1.1940497 0.0 0.0 -1.3870177 0.026421886 0.0 0.0 -14.236958 -2.1340652 0.0
   0.0 -1.3804955 -0.25085622 0.0 0.0 -1862.0724 113.95218 0.0 0.0 -1.4461391
   -0.053500365 0.0 0.0 -1.4154053 -0.10321872 0.0 0.0 -1.339088 -0.28993645 0.0
   0.0 -10.496204 -5.5229497 0.0 0.0 -13.426594 1.4930317 0.0 0.0 -12.896641
   -4.2673826 0.0 0.0 -12.168289 6.058683 0.0 0.0 -13.197749 2.5061471 0.0 0.0
   -136.23859 -31.476564 0.0 0.0 -133.3446 -5.192064 0.0 0.0 -1.3030106
   -0.07212195 0.0 0.0 -138.10176 6.634632 0.0 0.0 -136.34727 -60.27108 0.0 0.0
   -137.4836 -26.482246 0.0 0.0 -129.75005 -32.159805 0.0 0.0 -15.38977
   7.1953382 0.0 0.0 -153.81822 -107.22644 0.0 0.0 -12.434206 -5.055204 0.0 0.0
   -1.3987048 -0.32242954 0.0 0.0 -1.4103926 0.4048285 0.0 0.0 -1.388617
   -0.33299583 0.0 0.0 -120.36948 58.870834 0.0 0.0 -13.845536 -1.0637093 0.0
   0.0 -124.143654 62.904408 0.0 0.0 -1.4261216 -0.111641295 0.0 0.0 -138.57843
   -64.19479 0.0 0.0 -1.3564172 -0.2643488 0.0 0.0 -133.7403 65.35494 0.0 0.0
   -1709.1046 661.7514 0.0 0.0 -21.699402 -5.061122 0.0 0.0 -11.917021 6.4747624
   0.0 0.0 -1.3003262 -0.506135 0.0 0.0 -1.2370763 -0.7577537 0.0 0.0 -13.340898
   2.1481338 0.0 0.0 -1.373848 -0.47063854 0.0 0.0 -1.3857936 -0.039797924 0.0
   0.0 -13.714591 -9.397183 0.0 0.0 -149.2275 29.522509 0.0 0.0 -1.1766473
   0.8734781 0.0 0.0 -14.711676 2.7861598 0.0 0.0 -1.3208452 0.0735384 0.0 0.0
   -1353.2345 -844.3643 0.0 0.0 -162.50044 94.59051 0.0 0.0 -121.51237 70.00408
   0.0 0.0 -1.4366217 0.051881995 0.0 0.0 -1.7118728 -0.8046134 0.0 0.0
   -1.2949831 0.47041276 0.0 0.0 -1.1721765 -0.8815284 0.0 0.0 -16.50429
   4.248672 0.0 0.0 -13.234691 4.082909 0.0 0.0 -1.4120824 -0.18369232 0.0 0.0
   -1.4691721 -0.19397064 0.0 0.0 -1524.4509 -945.4062 0.0 0.0 -1.4888501
   -0.019903984 0.0 0.0 -148.7369 -43.049137 0.0 0.0 -13.393302 1.8123224 0.0
   0.0 -155.32631 2.0822997 0.0 0.0 -145.9847 -42.117725 0.0 0.0 -1.3422204
   0.08281483 0.0 0.0 -138.20735 -28.35432 0.0 0.0 -208.95142 44.945587 0.0 0.0
   -133.76335 -32.04329 0.0 0.0 -253.4402 -31.91936 0.0 0.0 -133.36707
   -27.584164 0.0 0.0 -1542.3815 -28.211159 0.0 0.0 -1.4499679 0.04543232 0.0
   0.0 -1.0686723 -0.71786827 0.0 0.0 -12.96339 4.639873 0.0 0.0 -1.2277638
   0.35175726 0.0 0.0 -151.81313 36.79128 0.0 0.0 -1.1905557 -0.861653 0.0 0.0
   -187.3793 -35.761524 0.0 0.0 -14.01231 2.337309 0.0 0.0 -145.00172 -33.836697
   0.0 0.0 -143.90475 -56.717037 0.0 0.0 -1.3601593 -0.36384255 0.0 0.0
   -1.323675 -0.6259305 0.0 0.0 -1.3514324 -0.27091026 0.0 0.0 -12.463193
   -7.809199 0.0 0.0 -139.95276 26.43731 0.0 0.0 -15.256174 1.6250653 0.0 0.0
   -13.554523 -6.7960873 0.0 0.0 -13.682318 1.9762771 0.0 0.0 -1.3107096
   -0.2264404 0.0 0.0 -125.76204 -55.60717 0.0 0.0 -160.17966 -46.247875 0.0 0.0
   -1.3834845 0.21725813 0.0 0.0 -19.129139 -3.7477887 0.0 0.0 -12.548711
   -2.0404375 0.0 0.0 -1.5157255 -0.072336815 0.0 0.0 -279.86426 6.546309 0.0
   0.0 -1.4864708 0.08394987 0.0 0.0 -142.54112 -72.730965 0.0 0.0 -124.873085
   -83.20836 0.0 0.0 -15.241539 0.5708928 0.0 0.0 -1.4413804 -0.015930936 0.0
   0.0 -139.06744 9.483411 0.0 0.0 -1.4107797 0.18568079 0.0 0.0 -143.30821
   -8.073087 0.0 0.0 -13.696382 -1.0864457 0.0 0.0 -14.915218 -2.5842857 0.0 0.0
   -1155.0898 -1357.4259 0.0 0.0 -11.247068 4.9896398 0.0 0.0 -13.02054 1.858405
   0.0 0.0 -1656.8179 -37.929276 0.0 0.0 -1.2712159 -0.25658727 0.0 0.0
   -1.3003781 -0.66906446 0.0 0.0 -11.47648 4.3241363 0.0 0.0 -1.4663895
   -0.03650553 0.0 0.0 -13.8448715 0.56395173 0.0 0.0 -14.299662 -1.315976 0.0
   0.0 -96.80002 -128.98766 0.0 0.0 -1.382304 -0.26992974 0.0 0.0 -1.0262643
   -0.65061843 0.0 0.0 -1.3979027 0.123269744 0.0 0.0 -14.047783 -2.3219466 0.0
   0.0 -1.3167415 0.6552508 0.0 0.0 -3.4941742 0.21067534 0.0 0.0 -142.09546
   -64.01878 0.0 0.0 -12.910369 4.1747537 0.0 0.0 -162.20103 -80.59055 0.0 0.0
   -155.39531 6.7000747 0.0 0.0 -1.4756395 0.17076127 0.0 0.0 -120.966415
   -69.81103 0.0 0.0 -159.3007 -2.63712 0.0 0.0 -14.206817 -5.400402 0.0 0.0
   -116.0741 -109.79452 0.0 0.0 -1.4081435 0.011109479 0.0 0.0 -1.466734
   0.24914852 0.0 0.0 -14.796086 -4.490094 0.0 0.0 -132.25415 94.53781 0.0 0.0
   -148.68782 -34.29725 0.0 0.0 -13.52842 6.6151376 0.0 0.0 -1.4188812
   0.33669195 0.0 0.0 -139.81088 -21.586502 0.0 0.0 -158.94171 -8.606729 0.0 0.0
   -1.4291335 -0.31937537 0.0 0.0 -14.450029 -4.3386354 0.0 0.0 -12.254058
   -1.0620936 0.0 0.0 -25.932213 4.6480727 0.0 0.0 -8.765682 -8.445831 0.0 0.0
   -12.726708 5.792524 0.0 0.0 -136.10843 27.391106 0.0 0.0 -13.745164
   0.51310515 0.0 0.0 -14.550521 -2.8302326 0.0 0.0 -1.2425799 -0.45077047 0.0
   0.0 -130.6836 52.73818 0.0 0.0 -0.9949992 -1.0563489 0.0 0.0 -0.974153
   -0.7432406 0.0 0.0 -149.48875 -48.934647 0.0 0.0 -1.1452444 -0.63905495 0.0
   0.0 -1.3642612 0.33796534 0.0 0.0 -142.77794 4.7870345 0.0 0.0 -141.17227
   -5.7135177 0.0 0.0 -10.633847 -11.195547 0.0 0.0 -163.22084 -46.98911 0.0 0.0
   -135.12106 -86.06128 0.0 0.0 -1.1328725 -0.82042634 0.0 0.0 -1204.9446
   -1201.5046 0.0 0.0 -146.47173 -62.083485 0.0 0.0 -1.2015101 0.703357 0.0 0.0
   -140.61696 17.95682 0.0 0.0 -1.3381132 -0.4928881 0.0 0.0 -1.4136353
   0.26330277 0.0 0.0 -1.4539131 0.20410636 0.0 0.0 -150.95787 55.998394 0.0 0.0
   -1.4362689 0.13368551 0.0 0.0 -12.333489 6.4375477 0.0 0.0 -122.9711
   -71.05651 0.0 0.0 -153.14555 -50.362003 0.0 0.0 -1854.6194 137.6043 0.0 0.0
   -1.3256474 0.3622 0.0 0.0 -1.4072855 -0.35143784 0.0 0.0 -13.576727
   -4.3425922 0.0 0.0 -13.576832 3.296081 0.0 0.0 -1.4664664 0.10858461 0.0 0.0
   -1.3826014 0.36042657 0.0 0.0 -155.28293 11.45691 0.0 0.0 -153.45406
   10.670694 0.0 0.0 -15.191702 -3.6481502 0.0 0.0 -1.4173928 0.1190814 0.0 0.0
   -163.00243 -5.186893 0.0 0.0 -1.4772986 0.04740305 0.0 0.0 -1.3315964
   -0.61239976 0.0 0.0 -1.0106565 -0.92805547 0.0 0.0 -1.270082 0.21287912 0.0
   0.0 -1943.646 -572.3302 0.0 0.0 -212.76175 -194.74904 0.0 0.0 -144.0644
   36.707092 0.0 0.0 -15.739364 5.795205 0.0 0.0 -140.75778 -77.19173 0.0 0.0
   -1.3202333 -0.005977091 0.0 0.0 -13.102011 -4.8819404 0.0 0.0 -1.3458076
   0.15152606 0.0 0.0 -156.33234 49.28849 0.0 0.0 -10.809151 10.584759 0.0 0.0
   -1.4079425 0.002969898 0.0 0.0 -167.2641 -2.7001817 0.0 0.0 -1.4686096
   0.51071376 0.0 0.0 -1.4555266 -0.16892798 0.0 0.0 -14.852406 4.8641534 0.0
   0.0 -151.2833 63.003117 0.0 0.0 -1.4759481 -0.1500193 0.0 0.0 -139.19743
   37.31703 0.0 0.0 -1.386839 -0.15801486 0.0 0.0 -142.05042 -8.062179 0.0 0.0
   -16.648512 -2.9901845 0.0 0.0 -0.77449214 1.0839713 0.0 0.0 -1.3525956
   0.53554785 0.0 0.0 -1.487514 0.3739962 0.0 0.0 -1635.579 -664.9047 0.0 0.0
   -1.3428364 0.3495469 0.0 0.0 -1.4494395 -0.4082699 0.0 0.0 -1.2401059
   0.65530664 0.0 0.0 -1.4157051 -0.28291675 0.0 0.0 -4139.535 -1021.05347 0.0
   0.0 -1.4794513 0.06542651 0.0 0.0 -1.430025 0.2619261 0.0 0.0 -1761.8141
   -1214.5566 0.0 0.0 -116.33507 -98.09142 0.0 0.0 -143.72527 -19.54625 0.0 0.0
   -14.795108 -3.0317538 0.0 0.0 -11.953778 7.4841905 0.0 0.0 -1.4030409
   -0.47660068 0.0 0.0 -1.3259643 0.38573095 0.0 0.0 -1.1421546 -0.6293716 0.0
   0.0 -1.387925 -0.022330835 0.0 0.0 -1.3972446 -0.14673313 0.0 0.0 -98.00164
   -109.380646 0.0 0.0 -149.49977 -65.63352 0.0 0.0 -10.655193 -8.322469 0.0 0.0
   -146.18694 -25.717964 0.0 0.0 -1.4784423 -0.019045105 0.0 0.0 -14.047683
   -6.1245966 0.0 0.0 -1.2936149 -0.6360557 0.0 0.0 -213.19366 17.632696 0.0 0.0
   -16.358467 -2.851958 0.0 0.0 -13.422232 -4.397589 0.0 0.0 -2343.9133
   -143.2603 0.0 0.0 -13.407303 -4.082889 0.0 0.0 -1.461756 -0.113501586 0.0 0.0
   -1.4833235 -0.034092017 0.0 0.0 -145.07071 18.072226 0.0 0.0 -128.56459
   69.60059 0.0 0.0 -161.37674 27.142681 0.0 0.0 -1.4606456 -0.25592226 0.0 0.0
   -146.16953 -23.053278 0.0 0.0 -156.26073 -54.983078 0.0 0.0 -133.41159
   -60.517696 0.0 0.0 -1.0439572 -0.8375924 0.0 0.0 -13.32963 -4.970838 0.0 0.0
   -1.1823256 -0.32508588 0.0 0.0 -1737.179 -121.48233 0.0 0.0 -1.3145374
   0.34850186 0.0 0.0 -104.99236 -102.622604 0.0 0.0 -1.3519124 -0.26083234 0.0
   0.0 -11.950422 -5.4346538 0.0 0.0 -14.082305 -6.7876563 0.0 0.0 -1.4825088
   0.12440488 0.0 0.0 -155.39008 -87.58355 0.0 0.0 -1.2713469 0.6609046 0.0 0.0
   -1.4203333 0.14496954 0.0 0.0 -15.757183 -3.616932 0.0 0.0 -2335.463
   -1091.0472 0.0 0.0 -159.4079 -22.188696 0.0 0.0 -1.4898559 -0.076343715 0.0
   0.0 -13.041951 -6.1246395 0.0 0.0 -13.110496 -3.9409573 0.0 0.0 -142.31456
   57.66342 0.0 0.0 -139.71342 52.41113 0.0 0.0 -135.9744 -40.23877 0.0 0.0
   -168.97253 -6.1980524 0.0 0.0 -1.4405799 0.182909 0.0 0.0 -15.691841
   -2.390281 0.0 0.0 -12.877691 2.300089 0.0 0.0 -1842.2103 -730.6907 0.0 0.0
   -1.0693973 0.40114433 0.0 0.0 -256.71133 11.687064 0.0 0.0 -12.000454
   -4.22864 0.0 0.0 -147.09744 -94.97923 0.0 0.0 -154.5658 -67.24698 0.0 0.0
   -1.3840871 0.17933337 0.0 0.0 -147.71136 -26.42265 0.0 0.0 -1.3555454
   -0.07467764 0.0 0.0 -1.2972629 -0.7986279 0.0 0.0 -218.88733 9.525531 0.0 0.0
   -1.479983 -0.14270125 0.0 0.0 -149.89494 -9.7124405 0.0 0.0 -1.4658972
   0.055540714 0.0 0.0 -1.1144785 -0.0047313417 0.0 0.0 -183.55879 -34.698666
   0.0 0.0 -1342.6085 -1170.2069 0.0 0.0 -1.2201319 0.6457323 0.0 0.0 -1.420338
   -0.14013276 0.0 0.0 -1.4383422 0.08107249 0.0 0.0 -176.8799 34.533886 0.0 0.0
   -1.4532543 -0.29273286 0.0 0.0 -235.0173 -104.56339 0.0 0.0 -1.3575828
   0.4089852 0.0 0.0 -1.3256227 0.10093467 0.0 0.0 -281.88098 61.13812 0.0 0.0
   -15.067563 3.2817852 0.0 0.0 -149.38783 9.639889 0.0 0.0 -12.101948 7.7685843
   0.0 0.0 -1.4129575 -0.1814001 0.0 0.0 -211.81636 -19.052387 0.0 0.0
   -161.99171 -3.1060364 0.0 0.0 -1797.2977 20.773342 0.0 0.0 -170.31122
   -68.68946 0.0 0.0 -250.47395 -6.774443 0.0 0.0 -1.4766977 0.16495724 0.0 0.0
   -153.68669 -27.851858 0.0 0.0 -274.26248 -57.456192 0.0 0.0 -15.973946
   0.12056543 0.0 0.0 -1.3444173 -0.23477153 0.0 0.0 -128.81972 -88.75663 0.0
   0.0 -1.4734393 -0.0059406534 0.0 0.0 -16.590536 -9.840033 0.0 0.0 -1.3660492
   -0.4410314 0.0 0.0 -1.3729907 -0.52716917 0.0 0.0 -1.2932003 -0.2146673 0.0
   0.0 -1.2363254 -0.052813765 0.0 0.0 -154.06998 -71.779755 0.0 0.0 -161.2604
   9.633126 0.0 0.0 -129.97267 -76.81195 0.0 0.0 -137.36267 -104.33231 0.0 0.0
   -1.2186831 -0.43457767 0.0 0.0 -190.28581 7.8605623 0.0 0.0 -1.3133963
   -0.33943728 0.0 0.0 -206.6141 7.156924 0.0 0.0 -1.2795069 -0.7456867 0.0 0.0
   -14.069919 -2.8315322 0.0 0.0 -15.219165 -5.0490727 0.0 0.0 -0.5669666
   -0.010213204 0.0 0.0 -229.13277 -78.77489 0.0 0.0 -163.69505 -8.939566 0.0
   0.0 -150.05074 -56.73533 0.0 0.0 -1765.5826 -475.38004 0.0 0.0 -14.335607
   -1.781242 0.0 0.0 -1.4512393 0.17381917 0.0 0.0 -1.3988868 0.22063194 0.0 0.0
   -171.5489 26.521732 0.0 0.0 -0.6693668 -0.9231507 0.0 0.0 -1.4753263
   -0.11890766 0.0 0.0 -1.4587009 0.21180746 0.0 0.0 -12.430876 10.915969 0.0
   0.0 -15.161011 5.366911 0.0 0.0 -166.48187 -40.377296 0.0 0.0 -1.4535828
   -0.14770482 0.0 0.0 -26.543116 -11.682541 0.0 0.0 -1.370084 -0.16662334 0.0
   0.0 -222.91113 0.50734335 0.0 0.0 -127.359 -94.63281 0.0 0.0 -1.4869514
   0.036932133 0.0 0.0 -1.2472918 0.7770657 0.0 0.0 -1.3534534 -0.1314767 0.0
   0.0 -1530.3906 -1163.4734 0.0 0.0 -1.3626205 -0.53130245 0.0 0.0 -141.23135
   -100.94936 0.0 0.0 -1.3456391 -0.5874932 0.0 0.0 -16.440666 -6.2488275 0.0
   0.0 -13.539513 4.950453 0.0 0.0 -14.102887 -2.2524981 0.0 0.0 -14.075372
   -2.9688895 0.0 0.0 -135.67706 -71.313965 0.0 0.0 -1.2849463 0.0019473693 0.0
   0.0 -13.773594 2.268526 0.0 0.0 -14.061566 -2.8307166 0.0 0.0 -1.529851
   0.20912126 0.0 0.0 -109.092766 107.87167 0.0 0.0 -1.1887512 -0.5544427 0.0
   0.0 -0.9081679 -0.61003953 0.0 0.0 -208.33188 -67.73407 0.0 0.0 -14.748342
   -1.3742075 0.0 0.0 -244.28156 -35.335743 0.0 0.0 -1.2619123 -0.24968925 0.0
   0.0 -12.521756 -2.6317835 0.0 0.0 -172.18347 83.8777 0.0 0.0 -1.3192734
   0.16884951 0.0 0.0 -13.696336 0.068575665 0.0 0.0 -1.3410405 0.003278605 0.0
   0.0 -1.3266847 -0.5520841 0.0 0.0 -145.3723 -32.787693 0.0 0.0 -21.616398
   3.8828347 0.0 0.0 -1.1095515 0.4757502 0.0 0.0 -0.91652834 0.3590613 0.0 0.0
   -154.19655 -45.025795 0.0 0.0 -1.2158626 -0.36354095 0.0 0.0 -182.89456
   -44.942436 0.0 0.0 -1.3011851 -0.10847204 0.0 0.0 -1.3235937 -0.09618231 0.0
   0.0 -136.008 -73.7048 0.0 0.0 -13.631608 -4.9887633 0.0 0.0 -1.0540109
   -0.81467444 0.0 0.0 -247.73666 106.637535 0.0 0.0 -0.96677846 0.8555544 0.0
   0.0 -1.326046 -0.0019038365 0.0 0.0 -125.60448 -90.89621 0.0 0.0 -14.306221
   1.6018249 0.0 0.0 -150.90793 -36.07634 0.0 0.0 -16.935425 0.025715986 0.0 0.0
   -1.2348378 -0.38082018 0.0 0.0 -15.218696 3.3443522 0.0 0.0 -145.4022
   -84.62157 0.0 0.0 -1.3687224 -0.35774955 0.0 0.0 -14.55491 -0.37313598 0.0
   0.0 -12.694885 -2.160443 0.0 0.0 -1.2263279 0.5086167 0.0 0.0 -193.21382
   -41.415615 0.0 0.0 -1.2883692 -0.23198877 0.0 0.0 -13.330378 -1.3657948 0.0
   0.0 -13.395902 0.23804677 0.0 0.0 -0.95537966 -0.8442325 0.0 0.0 -14.346728
   1.5867388 0.0 0.0 -1.1010718 0.5080365 0.0 0.0 -1.2215567 -0.47118264 0.0 0.0
   -284.55322 34.006493 0.0 0.0 -152.79092 -72.58368 0.0 0.0 -13.65221
   -2.8653538 0.0 0.0 -1.1828159 -0.502526 0.0 0.0 -173.35713 31.718838 0.0 0.0
   -15.060245 -0.6776539 0.0 0.0 -13.266884 -1.8378885 0.0 0.0 -12.512561
   -2.7497625 0.0 0.0 -1.2254027 0.32159767 0.0 0.0 -13.453608 -3.7881503 0.0
   0.0 -1.0336516 -0.8454772 0.0 0.0 -0.69720626 -1.1317652 0.0 0.0 -11.278448
   -7.3230944 0.0 0.0 -0.98843896 -0.7959708 0.0 0.0 -0.9462207 -0.87188435 0.0
   0.0 -1.3344916 -0.023242502 0.0 0.0 -1.2985952 -0.097944535 0.0 0.0
   -145.79587 64.06095 0.0 0.0 -1.2275068 -0.48468468 0.0 0.0 -214.0095
   -32.661736 0.0 0.0 -1.1107869 -0.4296944 0.0 0.0 -14.503929 -1.4779719 0.0
   0.0 -16.192228 9.484086 0.0 0.0 -11.6084385 -6.292317 0.0 0.0 -14.462332
   6.1828203 0.0 0.0 -1.1323923 0.71153307 0.0 0.0 -17.718025 -0.2757695 0.0 0.0
   -1.2959087 0.1459096 0.0 0.0 -13.947851 -6.0112214 0.0 0.0 -164.42247
   -46.99296 0.0 0.0 -17.076788 -1.0183464 0.0 0.0 -142.47136 94.817604 0.0 0.0
   -18.06581 4.1878963 0.0 0.0 -14.246275 -1.1480551 0.0 0.0 -1.1682292
   -0.6324822 0.0 0.0 -1.3290747 -0.046926018 0.0 0.0 -1.1604525 -0.66299117 0.0
   0.0 -0.95787346 -1.0549624 0.0 0.0 -141.19852 -71.7377 0.0 0.0 -12.883876
   -1.2614615 0.0 0.0 -1.1940236 -0.5701768 0.0 0.0 -5.1626544 -13.625096 0.0
   0.0 -1.2973833 -0.094041035 0.0 0.0 -1.1675525 -0.63760185 0.0 0.0 -141.49411
   -71.935074 0.0 0.0 -152.28728 36.319073 0.0 0.0 -19.873728 3.3728995 0.0 0.0
   -185.59445 57.368565 0.0 0.0 -1.1123295 -0.7494157 0.0 0.0 -1.2340653
   0.306205 0.0 0.0 -1.2085856 0.37355378 0.0 0.0 -1.2964177 -0.32173446 0.0 0.0
   -15.77487 -0.33839083 0.0 0.0 -1.2178763 0.6476966 0.0 0.0 -156.15602
   -31.589563 0.0 0.0 -1.218015 -0.51777107 0.0 0.0 -13.889431 -1.0312686 0.0
   0.0 -1.3138082 0.1909821 0.0 0.0 -1.269268 0.21443155 0.0 0.0 -12.780697
   -6.5185657 0.0 0.0 -171.93683 -53.879395 0.0 0.0 -1.1078771 -0.69014204 0.0
   0.0 -11.789594 5.392205 0.0 0.0 -1.2160132 0.4967354 0.0 0.0 -1.2893351
   -0.061102215 0.0 0.0 -12.507616 -7.846737 0.0 0.0 -15.046287 -2.7443314 0.0
   0.0 -0.12433635 -1.2680635 0.0 0.0 -1.218386 -0.31706232 0.0 0.0 -184.35126
   -38.188637 0.0 0.0 -249.08833 -19.146082 0.0 0.0 -1.301551 -0.09740281 0.0
   0.0 -14.432799 2.7426794 0.0 0.0 -1.2553611 0.025413686 0.0 0.0 -173.99135
   2.066729 0.0 0.0 -1.1855853 -0.08216911 0.0 0.0 -13.916139 2.317836 0.0 0.0
   -9.476913 -11.351709 0.0 0.0 -1.2612383 0.3585445 0.0 0.0 -1.2586614
   -0.3411831 0.0 0.0 -0.94978076 -0.9328282 0.0 0.0 -1.2941986 0.19981799 0.0
   0.0 -1.2986041 0.17549159 0.0 0.0 -13.54176 -4.1351533 0.0 0.0 -16.330109
   -1.6303194 0.0 0.0 -1.4908875 0.31064162 0.0 0.0 -1.2430631 -0.42319536 0.0
   0.0 -420.9197 -190.80461 0.0 0.0 -14.66224 -4.6737795 0.0 0.0 -15.381669
   -7.9347515 0.0 0.0 -1.2027234 0.5725292 0.0 0.0 -1.3677282 0.3669165 0.0 0.0
   -1.1404736 -0.670702 0.0 0.0 -1.2910722 0.07222486 0.0 0.0 -15.875223
   7.0383873 0.0 0.0 -1.2668054 -0.3086454 0.0 0.0 -0.86792386 -1.0818821 0.0
   0.0 -1.0025831 0.21588714 0.0 0.0 -152.20113 -55.26532 0.0 0.0 -1.3228942
   0.21784452 0.0 0.0 -168.65077 5.977313 0.0 0.0 -1.2898377 0.36561224 0.0 0.0
   -13.283027 -5.143032 0.0 0.0 -13.17958 -8.631635 0.0 0.0 -10.805183 6.612219
   0.0 0.0 -1.206482 -0.005860552 0.0 0.0 -1.2614748 -0.31529555 0.0 0.0
   -14.559188 3.0607812 0.0 0.0 -1.2803609 0.24627216 0.0 0.0 -158.27986
   -60.15787 0.0 0.0 -1.9036113 -0.40238404 0.0 0.0 -0.9466983 -0.83771014 0.0
   0.0 -12.375826 8.282656 0.0 0.0 -165.77136 -35.73923 0.0 0.0 -12.976267
   2.2238772 0.0 0.0 -1.2405435 -0.50625926 0.0 0.0 -232.6125 -34.456875 0.0 0.0
   -13.524073 -4.60656 0.0 0.0 -15.875018 2.786805 0.0 0.0 -1.113314 0.62026036
   0.0 0.0 -1.1595988 -0.36074907 0.0 0.0 -1.2577485 0.21548967 0.0 0.0
   -1.1983358 0.59724545 0.0 0.0 -1.3294303 -0.13612145 0.0 0.0 -13.412628
   -2.9586458 0.0 0.0 -1.162239 -0.41880172 0.0 0.0 -1.2404513 0.5057861 0.0 0.0
   -12.888032 2.878257 0.0 0.0 -1.335234 0.050052017 0.0 0.0 -465.7576 -84.716
   0.0 0.0 -1.2431223 0.021297565 0.0 0.0 -1.3233691 -0.21586554 0.0 0.0
   -241.6618 -87.33328 0.0 0.0 -147.20546 -86.721924 0.0 0.0 -1.3017654
   -0.14996132 0.0 0.0 -10.62689 -7.597082 0.0 0.0 -1.0295587 -1.0382477 0.0 0.0
   -1.0739442 0.5643445 0.0 0.0 -13.992105 -2.898737 0.0 0.0 -1.248693
   0.48605344 0.0 0.0 -10.52645 7.9718566 0.0 0.0 -13.724664 0.53461516 0.0 0.0
   -14.683107 -2.8834703 0.0 0.0 -0.9120889 -0.52801484 0.0 0.0 -170.18593
   21.609585 0.0 0.0 -1.3062799 0.14926133 0.0 0.0 -1.1598144 0.49234694 0.0 0.0
   -19.667572 -3.4796064 0.0 0.0 -1.336263 0.07525283 0.0 0.0 -13.636448
   -4.555481 0.0 0.0 -10.108802 -8.577646 0.0 0.0 -15.444635 7.454721 0.0 0.0
   -1.2817378 -0.35093868 0.0 0.0 -14.156997 1.8601297 0.0 0.0 -14.659771
   3.038404 0.0 0.0 -13.437603 -2.235909 0.0 0.0 -133.49454 -120.054756 0.0 0.0
   -12.239179 -5.027174 0.0 0.0 -175.2529 -39.61401 0.0 0.0 -0.8352773
   -0.9993671 0.0 0.0 -15.288745 2.133585 0.0 0.0 -1.4276018 -0.43661165 0.0 0.0
   -2.058463 -0.57567936 0.0 0.0 -197.84373 -48.215508 0.0 0.0 -1.293351
   0.3163279 0.0 0.0 -13.856538 -3.9640138 0.0 0.0 -160.81667 81.34525 0.0 0.0
   -0.7181599 -0.019136896 0.0 0.0 -11.837492 -8.245155 0.0 0.0 -1.186572
   0.40662846 0.0 0.0 -1.1550114 0.2821561 0.0 0.0 -14.958546 0.98691684 0.0 0.0
   -1.1871506 -0.31060237 0.0 0.0 -1.2394557 -0.34055176 0.0 0.0 -287.9924
   97.41873 0.0 0.0 -1.3338364 0.06663608 0.0 0.0 -1.3375475 0.07495256 0.0 0.0
   -1.0573137 0.57799995 0.0 0.0 -1.3340486 -0.016482677 0.0 0.0 -15.02904
   0.45198828 0.0 0.0 -15.638972 1.2774379 0.0 0.0 -1.2386144 -0.49186912 0.0
   0.0 -15.68129 -4.6435356 0.0 0.0 -1.338159 -0.07901696 0.0 0.0 -0.99328
   -0.82239383 0.0 0.0 -200.45566 -75.20248 0.0 0.0 -205.52074 -1.200206 0.0 0.0
   -9.847278 -8.88211 0.0 0.0 -1.2524499 -0.47063336 0.0 0.0 -15.104659
   0.048129674 0.0 0.0 -1.1388763 -0.6924235 0.0 0.0 -14.618199 -3.4352257 0.0
   0.0 -18.887367 -9.09681 0.0 0.0 -11.601988 8.578434 0.0 0.0 -1.2277492
   -0.51146686 0.0 0.0 -13.262285 -4.2138042 0.0 0.0 -159.03601 41.061455 0.0
   0.0 -1.3400419 -0.036961563 0.0 0.0 -1.3512996 0.28483337 0.0 0.0 -1.3177452
   -0.04393688 0.0 0.0 -1.0497178 -0.75803566 0.0 0.0 -1.3091109 0.12906107 0.0
   0.0 -1.3225708 0.12807629 0.0 0.0 -1.3325933 -0.1181607 0.0 0.0 -158.23358
   -75.68678 0.0 0.0 -12.5102 -4.777045 0.0 0.0 -13.8399105 0.4011358 0.0 0.0
   -13.242985 -5.2512574 0.0 0.0 -10.389235 11.103985 0.0 0.0 -122.3666
   94.593475 0.0 0.0 -1.7036967 0.20159374 0.0 0.0 -1.4494928 -0.26174384 0.0
   0.0 -15.238997 -9.515373 0.0 0.0 -15.111739 -1.1502428 0.0 0.0 -16.99974
   -0.93978244 0.0 0.0 -161.28004 -106.20651 0.0 0.0 -117.0835 -141.34822 0.0
   0.0 -2292.6274 -834.8347 0.0 0.0 -16.997992 -15.214337 0.0 0.0 -173.5635
   85.223175 0.0 0.0 -162.79216 -46.582134 0.0 0.0 -16.619303 4.226995 0.0 0.0
   -196.00345 40.57948 0.0 0.0 -1.3113717 -0.6911347 0.0 0.0 -1.3087368
   -0.18529025 0.0 0.0 -1.317663 0.56206983 0.0 0.0 -2266.444 -1401.9515 0.0 0.0
   -246.82455 0.7146223 0.0 0.0 -0.7954058 -0.6199886 0.0 0.0 -1.3678627
   0.5744337 0.0 0.0 -1.3655629 0.37464255 0.0 0.0 -1.0966275 -1.0008901 0.0 0.0
   -11.111742 -12.824425 0.0 0.0 -13.465571 -7.233412 0.0 0.0 -1.2504798
   -0.301113 0.0 0.0 -13.344058 -2.386192 0.0 0.0 -1.4694101 0.06902578 0.0 0.0
   -192.63084 -63.4844 0.0 0.0 -187.69836 73.06308 0.0 0.0 -1.2548349
   -0.39141282 0.0 0.0 -218.15361 -34.49657 0.0 0.0 -17.919529 2.6226976 0.0 0.0
   -155.44621 -74.473076 0.0 0.0 -1.4651656 -0.03013855 0.0 0.0 -12.619839
   -1.3514555 0.0 0.0 -1.4728395 -0.0021598262 0.0 0.0 -1.4097513 -0.115589686
   0.0 0.0 -179.78514 2.9460554 0.0 0.0 -14.513418 5.2048507 0.0 0.0 -14.106879
   1.4471661 0.0 0.0 -10.9241495 8.622232 0.0 0.0 -1.1319354 -0.6056708 0.0 0.0
   -1.4578003 0.30060026 0.0 0.0 -1.2472667 -0.79360807 0.0 0.0 -10.485437
   8.458051 0.0 0.0 -198.20625 -49.620377 0.0 0.0 -17.128366 -4.72586 0.0 0.0
   -13.339783 2.5648553 0.0 0.0 -13.950528 -2.4215186 0.0 0.0 -14.479259
   -4.488595 0.0 0.0 -13.279147 3.2693875 0.0 0.0 -13.552873 -1.706263 0.0 0.0
   -1.4439081 -0.052481413 0.0 0.0 -186.26088 30.343382 0.0 0.0 -16.729193
   -3.1945543 0.0 0.0 -15.251015 -1.5105917 0.0 0.0 -15.531553 7.4578104 0.0 0.0
   -1.2242979 -0.36275885 0.0 0.0 -1.4315467 -0.12373372 0.0 0.0 -1.3385962
   -0.52828175 0.0 0.0 -13.867279 -3.0918934 0.0 0.0 -1.450298 0.04832667 0.0
   0.0 -281.11932 -64.549835 0.0 0.0 -10.880712 -10.76653 0.0 0.0 -191.15063
   -18.612112 0.0 0.0 -1.3502116 -0.18171841 0.0 0.0 -181.84694 46.506123 0.0
   0.0 -1.4148221 -0.008543453 0.0 0.0 -0.9976305 -1.081877 0.0 0.0 -1.0740497
   -1.0178766 0.0 0.0 -203.96977 62.752083 0.0 0.0 -17.793503 -6.729565 0.0 0.0
   -16.636093 1.9762565 0.0 0.0 -227.3636 48.565323 0.0 0.0 -228.2487 117.67786
   0.0 0.0 -1.3349874 0.5879007 0.0 0.0 -18.148993 1.7960796 0.0 0.0 -1.3499508
   -0.4360552 0.0 0.0 -151.16438 -115.4723 0.0 0.0 -1.3201064 0.40825823 0.0 0.0
   -12.921171 8.436792 0.0 0.0 -16.248306 -5.347426 0.0 0.0 -191.3383 136.68156
   0.0 0.0 -16.721281 -2.2741482 0.0 0.0 -1.382056 -0.6987658 0.0 0.0 -1.4321766
   0.14189951 0.0 0.0 -1.0255494 -0.35250264 0.0 0.0 -1.1120301 -0.96800256 0.0
   0.0 -15.475777 -4.849052 0.0 0.0 -15.999532 -2.7685738 0.0 0.0 -174.65817
   18.835655 0.0 0.0 -15.869522 -3.0928998 0.0 0.0 -166.33401 52.11483 0.0 0.0
   -1.2679684 -0.5557988 0.0 0.0 -17.344732 0.48834231 0.0 0.0 -197.61809
   14.335373 0.0 0.0 -192.14124 11.428236 0.0 0.0 -164.49512 -58.830418 0.0 0.0
   -15.265653 2.1654441 0.0 0.0 -1.5892457 -0.10735209 0.0 0.0 -1.3796637
   0.47615892 0.0 0.0 -165.71768 -61.438736 0.0 0.0 -2249.7188 273.63342 0.0 0.0
   -1.0329763 -1.0625243 0.0 0.0 -133.78043 75.810905 0.0 0.0 -1.4245278
   -0.055563428 0.0 0.0 -16.478548 -3.9264996 0.0 0.0 -10.211369 -13.7696 0.0
   0.0 -1.4726185 0.12753922 0.0 0.0 -176.17116 16.132341 0.0 0.0 -174.90648
   -14.4395485 0.0 0.0 -14.524734 5.2969894 0.0 0.0 -18.17526 -0.10544768 0.0
   0.0 -1.3680125 0.3560468 0.0 0.0 -1.3817908 0.32524562 0.0 0.0 -1.4916953
   0.14498192 0.0 0.0 -1.3483139 -1.0007862 0.0 0.0 -174.79716 -56.68826 0.0 0.0
   -2329.9285 163.7098 0.0 0.0 -194.17174 -98.281166 0.0 0.0 -14.960078
   4.2305117 0.0 0.0 -15.552959 6.5397406 0.0 0.0 -2268.1614 -891.2632 0.0 0.0
   -14.51062 -2.5649788 0.0 0.0 -13.233337 -3.5452647 0.0 0.0 -11.366263
   -12.712431 0.0 0.0 -16.15006 -3.0533412 0.0 0.0 -1.4683702 -0.22316404 0.0
   0.0 -179.05801 40.984943 0.0 0.0 -1.3072609 0.3043329 0.0 0.0 -1.4241321
   -0.4133159 0.0 0.0 -179.56375 42.11207 0.0 0.0 -15.014695 -0.7778445 0.0 0.0
   -15.505249 1.6775796 0.0 0.0 -19.99238 -1.1822599 0.0 0.0 -177.06836
   -1.8095886 0.0 0.0 -1.2525144 0.7611398 0.0 0.0 -15.470454 0.5236626 0.0 0.0
   -200.28415 -7.2389445 0.0 0.0 -1.6490945 0.22564931 0.0 0.0 -2319.1143
   -665.85876 0.0 0.0 -1.08558 0.84644634 0.0 0.0 -146.70099 -44.211334 0.0 0.0
   -1.4857308 -0.015636712 0.0 0.0 -1.3324146 -0.66513854 0.0 0.0 -1.2761623
   -0.6934996 0.0 0.0 -16.17188 -2.0255914 0.0 0.0 -1.4274776 -0.034352563 0.0
   0.0 -1.3451056 -0.4867258 0.0 0.0 -8.86986 3.7260242 0.0 0.0 -2901.4304
   772.09564 0.0 0.0 -1.3906397 0.40147427 0.0 0.0 -1.0700302 0.87286496 0.0 0.0
   -1.4642495 0.25267068 0.0 0.0 -152.0486 -146.99648 0.0 0.0 -1.4664104
   -0.14570694 0.0 0.0 -1.3721001 -0.3720727 0.0 0.0 -1.3876398 -0.12639225 0.0
   0.0 -2359.9792 -1448.7566 0.0 0.0 -14.365567 1.331145 0.0 0.0 -15.909412
   3.3982708 0.0 0.0 -1.2310337 0.55644065 0.0 0.0 -1.0892475 -0.5246839 0.0 0.0
   -1.3705591 -0.27859426 0.0 0.0 -15.202417 -8.519232 0.0 0.0 -1.3009766
   -0.43782255 0.0 0.0 -1.3534542 -0.5775046 0.0 0.0 -15.813026 -4.312966 0.0
   0.0 -16.169 -4.9511266 0.0 0.0 -186.31975 16.400135 0.0 0.0 -187.19159
   -55.355404 0.0 0.0 -1.3537738 -0.48383725 0.0 0.0 -1.4850144 -0.106038935 0.0
   0.0 -22.090796 -6.879997 0.0 0.0 -1.0143716 -1.015917 0.0 0.0 -1.5029525
   0.6115367 0.0 0.0 -1.3801687 -0.0074392552 0.0 0.0 -1.4291303 -0.16054285 0.0
   0.0 -249.93213 40.428535 0.0 0.0 -1.4793124 0.026108036 0.0 0.0 -13.20024
   11.32368 0.0 0.0 -13.602592 -10.204234 0.0 0.0 -1.2981973 0.6165194 0.0 0.0
   -17.387058 5.015143 0.0 0.0 -1.2631547 -0.6833824 0.0 0.0 -1.4551743
   0.23602858 0.0 0.0 -168.97849 -62.75306 0.0 0.0 -1.125713 -0.6026 0.0 0.0
   -210.32077 40.181637 0.0 0.0 -1.4608614 0.06906913 0.0 0.0 -1.4836193
   0.09658667 0.0 0.0 -1.3979803 -0.17065898 0.0 0.0 -1.4589471 -0.19785209 0.0
   0.0 -242.34213 -28.662527 0.0 0.0 -2466.398 -1113.5511 0.0 0.0 -1.473276
   0.21226385 0.0 0.0 -18.02529 -7.484221 0.0 0.0 -159.03409 -85.81926 0.0 0.0
   -1.1904621 0.12150869 0.0 0.0 -260.02774 65.52468 0.0 0.0 -15.116975
   -6.760199 0.0 0.0 -15.3398075 -3.8037632 0.0 0.0 -1.3023148 0.14950898 0.0
   0.0 -14.929432 -3.5280337 0.0 0.0 -13.13773 -8.759364 0.0 0.0 -10.929395
   8.810778 0.0 0.0 -168.7122 104.20423 0.0 0.0 -244.01814 40.301098 0.0 0.0
   -17.568962 2.1981936 0.0 0.0 -1.3189795 -0.11092062 0.0 0.0 -201.87035
   -44.95601 0.0 0.0 -2037.1326 -1268.3683 0.0 0.0 -14.248548 9.7127905 0.0 0.0
   -1.2226084 0.1372445 0.0 0.0 -1.4577218 0.2824508 0.0 0.0 -16.312572
   -1.0347538 0.0 0.0 -255.97256 -25.376846 0.0 0.0 -184.89917 14.491583 0.0 0.0
   -14.25994 6.302549 0.0 0.0 -1.2847912 0.28937313 0.0 0.0 -1.3838623
   0.083677225 0.0 0.0 -2864.5105 129.75133 0.0 0.0 -1.1997947 -0.3823047 0.0
   0.0 -1.4011539 -0.39425114 0.0 0.0 -187.03006 90.81776 0.0 0.0 -14.005721
   0.5583524 0.0 0.0 -15.746282 1.9190651 0.0 0.0 -234.78448 77.75355 0.0 0.0
   -13.089608 -5.1499095 0.0 0.0 -15.4563675 3.6794684 0.0 0.0 -1.4480412
   -0.08143784 0.0 0.0 -171.8151 -83.71987 0.0 0.0 -1.4322565 0.106275536 0.0
   0.0 -1.4144121 -0.37245858 0.0 0.0 -1.3132548 -0.5085213 0.0 0.0 -1.2750995
   -0.34562618 0.0 0.0 -14.459058 -2.362286 0.0 0.0 -1.1987985 0.70096874 0.0
   0.0 -15.296953 4.3593616 0.0 0.0 -188.18225 -68.3015 0.0 0.0 -179.14798
   -71.2189 0.0 0.0 -1.3507859 0.3526524 0.0 0.0 -17.790787 0.6687211 0.0 0.0
   -14.258489 -8.609047 0.0 0.0 -1.4848984 0.12044279 0.0 0.0 -1.5003504
   -0.5925043 0.0 0.0 -1.4105864 0.19434762 0.0 0.0 -0.7896546 -0.9832556 0.0
   0.0 -1.4149513 0.3377828 0.0 0.0 -154.74043 -99.86018 0.0 0.0 -13.235063
   -10.332358 0.0 0.0 -27.292776 -14.584917 0.0 0.0 -186.89061 -45.78398 0.0 0.0
   -1.3066405 -0.30094007 0.0 0.0 -16.265547 -2.2977674 0.0 0.0 -1.2803003
   0.03752553 0.0 0.0 -192.6829 4.779859 0.0 0.0 -15.271082 -4.223615 0.0 0.0
   -1.413018 -0.30452776 0.0 0.0 -1.1274983 -0.36866876 0.0 0.0 -1.3089496
   -0.5926587 0.0 0.0 -19.470404 3.0592408 0.0 0.0 -215.61794 44.203766 0.0 0.0
   -160.8188 76.00935 0.0 0.0 -184.38348 -15.650034 0.0 0.0 -1.2785156 0.2605473
   0.0 0.0 -17.351519 -1.4916466 0.0 0.0 -1.3229368 0.20983231 0.0 0.0
   -13.605797 -6.998184 0.0 0.0 -176.83218 -78.87273 0.0 0.0 -210.77298
   -15.521743 0.0 0.0 -15.832883 -1.2848401 0.0 0.0 -12.567586 8.749521 0.0 0.0
   -1.3236725 -0.011937253 0.0 0.0 -13.5181465 -5.7164125 0.0 0.0 -14.320495
   -7.084176 0.0 0.0 -15.7064705 2.1493976 0.0 0.0 -221.32457 -66.92362 0.0 0.0
   -1.282499 -0.12347981 0.0 0.0 -1.332594 0.014277664 0.0 0.0 -13.142755
   -8.828745 0.0 0.0 -1.3740151 0.29714948 0.0 0.0 -1.3047328 -0.06741838 0.0
   0.0 -15.939899 1.6785482 0.0 0.0 -182.27588 -90.13427 0.0 0.0 -174.15929
   -66.38752 0.0 0.0 -0.83724356 -0.96131825 0.0 0.0 -310.3112 -110.357056 0.0
   0.0 -14.308785 6.8546815 0.0 0.0 -184.50703 -28.126398 0.0 0.0 -234.97932
   -95.45604 0.0 0.0 -246.00275 -152.30653 0.0 0.0 -11.800471 -8.41953 0.0 0.0
   -13.37704 -4.4125137 0.0 0.0 -1.2179246 0.26013276 0.0 0.0 -14.684746
   -1.1719158 0.0 0.0 -14.291969 -3.5693989 0.0 0.0 -1.2947032 -0.30309775 0.0
   0.0 -299.2794 96.981346 0.0 0.0 -1.3355473 -0.0920689 0.0 0.0 -1.3214086
   -0.14809823 0.0 0.0 -1.1650975 0.47208023 0.0 0.0 -1.3300203 -0.81155646 0.0
   0.0 -210.1868 39.740032 0.0 0.0 -1.306241 0.05897333 0.0 0.0 -1.2492791
   0.4092631 0.0 0.0 -161.79916 -7.2211905 0.0 0.0 -244.37727 -0.4118266 0.0 0.0
   -1.284659 0.04586821 0.0 0.0 -201.40753 39.103527 0.0 0.0 -192.56752
   -38.720627 0.0 0.0 -193.89325 -31.841131 0.0 0.0 -15.819436 2.4442608 0.0 0.0
   -15.612206 -0.8157774 0.0 0.0 -17.86342 -4.2804093 0.0 0.0 -175.96248
   -67.04241 0.0 0.0 -1.3260084 -0.055956665 0.0 0.0 -1.256461 0.07306488 0.0
   0.0 -1.126194 -0.7287113 0.0 0.0 -1.31316 -0.189909 0.0 0.0 -1.2841494
   -0.05798148 0.0 0.0 -13.412413 -4.434305 0.0 0.0 -14.699638 6.3570657 0.0 0.0
   -11.61706 -9.143021 0.0 0.0 -215.53036 -3.1274142 0.0 0.0 -185.65053
   -35.119537 0.0 0.0 -1.3255762 0.17251322 0.0 0.0 -213.57191 30.848785 0.0 0.0
   -1.2304465 -0.40370995 0.0 0.0 -1.3189694 -0.20092049 0.0 0.0 -1.1916031
   0.45008966 0.0 0.0 -1.1755563 -0.63407034 0.0 0.0 -1.2994589 -0.20289415 0.0
   0.0 -15.86269 -0.5089318 0.0 0.0 -13.804715 -3.3011045 0.0 0.0 -13.887645
   -2.9677854 0.0 0.0 -21.619661 -12.139514 0.0 0.0 -305.65817 40.15148 0.0 0.0
   -246.14383 78.943016 0.0 0.0 -1.2187345 -0.52876884 0.0 0.0 -14.715023
   1.6137265 0.0 0.0 -15.531445 1.072274 0.0 0.0 -281.48987 -27.362728 0.0 0.0
   -171.54692 117.03005 0.0 0.0 -1.4673145 0.32584494 0.0 0.0 -13.565383
   -4.2587533 0.0 0.0 -14.461625 -5.7031016 0.0 0.0 -1.331407 0.33947366 0.0 0.0
   -17.415693 -4.7643805 0.0 0.0 -1.3407702 0.037189156 0.0 0.0 -16.5246
   -2.7625613 0.0 0.0 -1.299888 0.13214679 0.0 0.0 -207.15384 -22.082388 0.0 0.0
   -171.89006 -82.68972 0.0 0.0 -1.2402868 -0.337645 0.0 0.0 -13.377648
   -4.8074584 0.0 0.0 -1.3251963 -0.14262365 0.0 0.0 -175.6085 -94.991615 0.0
   0.0 -1.2335354 -0.49644265 0.0 0.0 -216.06909 -31.173172 0.0 0.0 -1.3201087
   -0.19066878 0.0 0.0 -257.94333 -38.800503 0.0 0.0 -1.4597383 0.13785519 0.0
   0.0 -191.39098 -0.18533643 0.0 0.0 -0.9816624 -0.6769376 0.0 0.0 -1.2937459
   0.44973156 0.0 0.0 -14.409686 -7.2841434 0.0 0.0 -1.3067262 -0.051341943 0.0
   0.0 -12.04734 -7.6395254 0.0 0.0 -20.79987 7.6971745 0.0 0.0 -1.2370837
   -0.48159212 0.0 0.0 -17.31405 -4.3844776 0.0 0.0 -14.243209 -1.1020542 0.0
   0.0 -15.884432 -2.6253917 0.0 0.0 -1.3371389 0.08428287 0.0 0.0 -1.3108102
   0.20875072 0.0 0.0 -18.023703 -5.8190665 0.0 0.0 -1.286458 -0.34982985 0.0
   0.0 -262.02228 -17.289022 0.0 0.0 -19.705208 8.081264 0.0 0.0 -1.2731739
   -0.24314646 0.0 0.0 -340.74246 -157.23883 0.0 0.0 -1.1046265 0.6475543 0.0
   0.0 -32.22097 -12.702741 0.0 0.0 -16.204039 -10.667609 0.0 0.0 -13.460037
   -4.8496842 0.0 0.0 -24.722668 4.3913918 0.0 0.0 -17.228596 -7.154448 0.0 0.0
   -13.615737 -6.091999 0.0 0.0 -18.740759 0.21993297 0.0 0.0 -13.962308
   7.0248895 0.0 0.0 -207.44418 -39.73445 0.0 0.0 -24.212826 -7.88032 0.0 0.0
   -1.2151963 0.36928564 0.0 0.0 -17.169674 4.585331 0.0 0.0 -1.3316182
   -0.007658564 0.0 0.0 -19.177238 3.627031 0.0 0.0 -1.2024066 -0.59225315 0.0
   0.0 -22.049358 -2.4884245 0.0 0.0 -14.133636 2.399753 0.0 0.0 -13.977792
   8.167075 0.0 0.0 -18.209833 0.085370265 0.0 0.0 -1.3341736 0.13853942 0.0 0.0
   -16.209803 -1.2799938 0.0 0.0 -16.067118 5.244346 0.0 0.0 -242.58475
   7.4389324 0.0 0.0 -1.3149999 -0.1002365 0.0 0.0 -12.928946 -9.524098 0.0 0.0
   -1.2376343 0.06064359 0.0 0.0 -1.1955358 -0.57958585 0.0 0.0 -7.093026
   -12.248604 0.0 0.0 -1.0013895 -0.87645584 0.0 0.0 -186.95715 -101.59736 0.0
   0.0 -14.327866 -0.43661675 0.0 0.0 -216.96173 50.106007 0.0 0.0 -1.1598526
   -0.05997868 0.0 0.0 -1.3065957 -0.019364975 0.0 0.0 -1.2347169 -0.4808723 0.0
   0.0 -13.902415 -5.767697 0.0 0.0 -19.363398 -3.2756038 0.0 0.0 -1.3220365
   -0.026912354 0.0 0.0 -16.332848 -1.953315 0.0 0.0 -16.281189 -5.3672466 0.0
   0.0 -14.152766 -11.707249 0.0 0.0 -184.85527 -63.178795 0.0 0.0 -16.5042
   -4.7868257 0.0 0.0 -1.0458345 -0.83445585 0.0 0.0 -13.770526 -10.171863 0.0
   0.0 -0.89938736 -0.5536242 0.0 0.0 -1.266194 0.38755056 0.0 0.0 -1.3349873
   0.10531663 0.0 0.0 -1.1643047 -0.6651678 0.0 0.0 -1.3353634 0.07177862 0.0
   0.0 -1.3191437 0.05720917 0.0 0.0 -1.2266452 0.2714171 0.0 0.0 -17.047749
   5.888046 0.0 0.0 -14.501202 -11.558427 0.0 0.0 -1.2872165 -0.072936624 0.0
   0.0 -191.00458 45.151855 0.0 0.0 -18.008404 0.028774915 0.0 0.0 -12.209687
   7.7259703 0.0 0.0 -15.190864 -5.1658444 0.0 0.0 -1.2592018 -0.44392532 0.0
   0.0 -13.425407 -7.8612723 0.0 0.0 -13.371387 7.393159 0.0 0.0 -174.29654
   -91.22658 0.0 0.0 -181.69829 96.74739 0.0 0.0 -12.55698 7.1764536 0.0 0.0
   -14.424903 -1.065112 0.0 0.0 -252.06073 -178.7496 0.0 0.0 -1.2862446
   -0.11112671 0.0 0.0 -1.2774758 0.42630458 0.0 0.0 -30.524641 5.0601363 0.0
   0.0 -2.8448331 -0.0642355 0.0 0.0 -1.2360971 -0.38221171 0.0 0.0 -14.373328
   -7.520986 0.0 0.0 -21.907661 -0.1319406 0.0 0.0 -16.293543 -6.5135665 0.0 0.0
   -1.0678002 -0.71880966 0.0 0.0 -198.93405 -184.05257 0.0 0.0 -215.65504
   17.667524 0.0 0.0 -0.96763057 -0.5836582 0.0 0.0 -1.1307696 -0.612521 0.0 0.0
   -1.3535999 0.74774075 0.0 0.0 -193.96318 -96.58172 0.0 0.0 -1.266889
   0.26959068 0.0 0.0 -1.2736917 0.30618265 0.0 0.0 -1.0355505 0.14820123 0.0
   0.0 -1.1478758 -0.5677157 0.0 0.0 -1.2604071 -0.16642098 0.0 0.0 -1.3227553
   -0.103658326 0.0 0.0 -1.2683144 0.40066233 0.0 0.0 -13.3804035 -1.9798279 0.0
   0.0 -1.334729 -0.035401013 0.0 0.0 -13.2247925 1.2390891 0.0 0.0 -235.11386
   37.594788 0.0 0.0 -184.80006 -47.199203 0.0 0.0 -15.534 -15.254668 0.0 0.0
   -1.3334372 -0.29498684 0.0 0.0 -17.45947 7.0243444 0.0 0.0 -1.2406133
   0.26902464 0.0 0.0 -1.2672352 -0.0755987 0.0 0.0 -13.125837 9.8105 0.0 0.0
   -1.3106065 -0.2191964 0.0 0.0 -1.3258954 0.102836624 0.0 0.0 -181.7819
   81.844025 0.0 0.0 -1.2925142 -0.33344325 0.0 0.0 -15.082613 -1.8676947 0.0
   0.0 -189.71657 61.884632 0.0 0.0 -1.2036227 -0.58340764 0.0 0.0 -1.2384773
   -0.39177695 0.0 0.0 -16.333843 -1.7729645 0.0 0.0 -13.430121 -9.074613 0.0
   0.0 -1.271236 -0.39418292 0.0 0.0 -198.66971 22.598192 0.0 0.0 -1.1454765
   0.6512869 0.0 0.0 -1.2340523 -0.095250696 0.0 0.0 -13.779557 -4.790319 0.0
   0.0 -15.837858 -6.6214485 0.0 0.0 -0.4771072 0.4512855 0.0 0.0 -161.42606
   -118.66211 0.0 0.0 -35.1296 -9.031064 0.0 0.0 -142.09206 -154.35587 0.0 0.0
   -143.96292 -139.61835 0.0 0.0 -13.702712 5.6356754 0.0 0.0 -1.0912923
   -0.6944512 0.0 0.0 -16.170156 0.6157784 0.0 0.0 -1.2215302 -0.49086285 0.0
   0.0 -1.2896794 -0.24557544 0.0 0.0 -179.16031 -162.04991 0.0 0.0 -14.777712
   -10.940237 0.0 0.0 -15.8108015 5.355691 0.0 0.0 -196.17326 -49.799496 0.0 0.0
   -198.32857 -8.120692 0.0 0.0 -17.600157 -3.4705484 0.0 0.0 -1.450038 0.098042
   0.0 0.0 -18.015656 -1.938058 0.0 0.0 -1.1902426 -0.23048602 0.0 0.0
   -14.647003 -1.6494536 0.0 0.0 -17.267252 -3.840264 0.0 0.0 -1.4438375
   0.23043793 0.0 0.0 -170.31232 -108.11835 0.0 0.0 -0.73768425 -0.12525487 0.0
   0.0 -1.4067315 0.19991054 0.0 0.0 -1.3788698 -0.49761033 0.0 0.0 -1.3981831
   0.23003215 0.0 0.0 -15.413661 0.014245866 0.0 0.0 -14.479915 -2.7585797 0.0
   0.0 -1.4827524 -0.2743902 0.0 0.0 -1.309217 0.1799814 0.0 0.0 -1.373501
   -0.31378034 0.0 0.0 -250.73082 -89.795 0.0 0.0 -357.691 -3.5470567 0.0 0.0
   -15.430046 -1.0897056 0.0 0.0 -16.622898 -6.1917253 0.0 0.0 -214.98744
   118.33029 0.0 0.0 -284.03345 -50.197144 0.0 0.0 -15.42534 -6.4133554 0.0 0.0
   -200.2592 138.83513 0.0 0.0 -1.4580011 0.51750857 0.0 0.0 -18.562893
   -1.2253886 0.0 0.0 -229.99217 23.235308 0.0 0.0 -212.6956 3.7431753 0.0 0.0
   -1.3460008 -0.11531526 0.0 0.0 -236.37012 52.108658 0.0 0.0 -174.10052
   122.670105 0.0 0.0 -14.673315 1.3165954 0.0 0.0 -16.544666 -8.339519 0.0 0.0
   -20.301075 0.6979019 0.0 0.0 -205.99892 -45.165024 0.0 0.0 -1.3581291
   -0.14766622 0.0 0.0 -1.4083728 0.016561106 0.0 0.0 -1.2999933 -0.72794306 0.0
   0.0 -17.401402 4.230903 0.0 0.0 -3298.7168 1798.5695 0.0 0.0 -1.5476549
   0.1142045 0.0 0.0 -13.876175 -11.748521 0.0 0.0 -1.3535614 -0.05478648 0.0
   0.0 -15.6000595 5.993556 0.0 0.0 -18.66901 -1.2931335 0.0 0.0 -257.807
   -77.3847 0.0 0.0 -1.4708787 -0.2251019 0.0 0.0 -16.439129 3.169966 0.0 0.0
   -1.3223919 -0.48629645 0.0 0.0 -2853.7397 281.2978 0.0 0.0 -10.907765
   -14.338221 0.0 0.0 -15.940974 4.442052 0.0 0.0 -12.237846 11.410849 0.0 0.0
   -1.5097184 -0.64841676 0.0 0.0 -188.56522 -85.47906 0.0 0.0 -1.3623167
   -0.028542645 0.0 0.0 -1.3580694 0.52823955 0.0 0.0 -203.92989 21.780542 0.0
   0.0 -224.78934 64.97087 0.0 0.0 -161.79724 156.39273 0.0 0.0 -1.5491655
   -0.08657251 0.0 0.0 -23.326023 -15.289417 0.0 0.0 -15.509266 -1.7018098 0.0
   0.0 -1.3609079 0.3703586 0.0 0.0 -16.724472 -0.6073241 0.0 0.0 -18.316666
   5.0153933 0.0 0.0 -1.4523622 0.1720367 0.0 0.0 -17.7877 -1.0712559 0.0 0.0
   -1.4146017 -0.3078049 0.0 0.0 -15.44659 10.389725 0.0 0.0 -17.572107
   -6.560955 0.0 0.0 -1.3168297 -0.6723118 0.0 0.0 -271.85788 7.1670017 0.0 0.0
   -3169.8987 -274.59894 0.0 0.0 -15.748835 -7.2505374 0.0 0.0 -233.07756
   16.97117 0.0 0.0 -166.66747 121.5761 0.0 0.0 -217.08354 -22.86606 0.0 0.0
   -1.4047797 0.43997735 0.0 0.0 -1.4196148 -0.39576513 0.0 0.0 -14.336531
   -7.8544254 0.0 0.0 -16.628054 -0.2689391 0.0 0.0 -13.563106 6.195439 0.0 0.0
   -15.854962 -7.7632723 0.0 0.0 -202.41727 -43.456734 0.0 0.0 -16.391306
   -4.213624 0.0 0.0 -15.920696 5.6860495 0.0 0.0 -207.58214 -26.304996 0.0 0.0
   -1.4421169 -0.36422524 0.0 0.0 -1.4226041 -0.056088153 0.0 0.0 -18.347897
   3.5512648 0.0 0.0 -3816.0186 602.975 0.0 0.0 -1.5114757 0.045386985 0.0 0.0
   -1.2839202 -0.15578847 0.0 0.0 -14.724311 -1.8196186 0.0 0.0 -194.40758
   -157.01683 0.0 0.0 -1.4466009 0.052379575 0.0 0.0 -1.3927522 -0.504019 0.0
   0.0 -1.3943794 -0.51542133 0.0 0.0 -209.8922 -58.471195 0.0 0.0 -180.3063
   -155.18507 0.0 0.0 -1.3837123 0.12559955 0.0 0.0 -17.452898 -0.4130066 0.0
   0.0 -17.795822 6.304599 0.0 0.0 -1.4076936 0.31666836 0.0 0.0 -1.2515682
   -0.80097926 0.0 0.0 -1.3807276 -0.042609364 0.0 0.0 -244.65 -152.77803 0.0
   0.0 -1.3118095 -0.041592363 0.0 0.0 -17.279068 -5.4915743 0.0 0.0 -2771.1265
   -1023.55695 0.0 0.0 -1.2086827 -0.7938109 0.0 0.0 -186.64186 96.237854 0.0
   0.0 -1.4218588 -0.05548741 0.0 0.0 -1.1374803 -0.18691386 0.0 0.0 -227.6062
   -63.67681 0.0 0.0 -1.1203549 -0.6334531 0.0 0.0 -1.4355867 -0.9274795 0.0 0.0
   -1.3914311 0.30164987 0.0 0.0 -16.050198 -9.833053 0.0 0.0 -1.1482213
   -0.79797095 0.0 0.0 -230.57956 -65.0518 0.0 0.0 -1.2818071 0.025111623 0.0
   0.0 -1.2789271 -0.9358467 0.0 0.0 -249.26929 46.355885 0.0 0.0 -3263.4219
   -1027.7125 0.0 0.0 -18.127804 -5.483777 0.0 0.0 -182.84157 -151.00714 0.0 0.0
   -7.239398 -1.0988623 0.0 0.0 -14.019778 -6.600809 0.0 0.0 -1.3338673
   -0.61587036 0.0 0.0 -17.997066 -4.9356065 0.0 0.0 -1.4577615 -0.3095393 0.0
   0.0 -4024.1914 510.37213 0.0 0.0 -1.3924158 0.19547951 0.0 0.0 -1.4861157
   0.019494422 0.0 0.0 -187.26976 96.06295 0.0 0.0 -17.871447 -5.9475274 0.0 0.0
   -1.4459945 0.30115336 0.0 0.0 -1.2436398 -0.3248043 0.0 0.0 -1.0244737
   -0.8096025 0.0 0.0 -1.8215686 -0.61559814 0.0 0.0 -222.07811 19.457277 0.0
   0.0 -3964.3987 -240.67917 0.0 0.0 -234.51749 57.08645 0.0 0.0 -2721.6604
   -1582.2262 0.0 0.0 -230.58868 107.837456 0.0 0.0 -16.594316 -0.49815053 0.0
   0.0 -1.437078 -0.034197003 0.0 0.0 -1.2030905 -0.8134292 0.0 0.0 -275.9354
   -83.99044 0.0 0.0 -15.064433 1.2092353 0.0 0.0 -13.38523 12.270939 0.0 0.0
   -1.423968 -0.29433036 0.0 0.0 -1.2971064 -0.57440394 0.0 0.0 -285.11295
   -119.75305 0.0 0.0 -1.3298742 -0.06350956 0.0 0.0 -200.52477 74.63114 0.0 0.0
   -16.95746 9.939358 0.0 0.0 -19.223167 5.127934 0.0 0.0 -3146.2466 398.3177
   0.0 0.0 -206.90964 81.476875 0.0 0.0 -1.3934753 0.50054073 0.0 0.0 -227.90034
   91.65005 0.0 0.0 -14.192773 -9.340534 0.0 0.0 -1.3045976 -0.45675096 0.0 0.0
   -1.4454467 -0.0302471 0.0 0.0 -1.3855686 0.45397043 0.0 0.0 -1.5103794
   -0.2841037 0.0 0.0 -237.93996 24.967075 0.0 0.0 -1.3516105 -0.4180983 0.0 0.0
   -1.4451989 -0.10297311 0.0 0.0 -16.847292 -5.335315 0.0 0.0 -226.42572
   88.99141 0.0 0.0 -176.55614 -162.23596 0.0 0.0 -1.4167738 -0.15070859 0.0 0.0
   -15.734685 -2.3153443 0.0 0.0 -1.430555 -0.45089757 0.0 0.0 -18.89982
   -8.774527 0.0 0.0 -17.386238 5.063908 0.0 0.0 -1.4494791 -0.32637554 0.0 0.0
   -14.814311 -8.307929 0.0 0.0 -232.0589 -35.268753 0.0 0.0 -225.18153
   72.987206 0.0 0.0 -212.94876 25.762682 0.0 0.0 -12.653906 8.0131235 0.0 0.0
   -1.4206759 0.27482796 0.0 0.0 -1.3338985 0.6472293 0.0 0.0 -1.3372922
   -0.6231218 0.0 0.0 -242.9344 -30.520935 0.0 0.0 -244.95766 -1.5565975 0.0 0.0
   -1.4322318 0.11001378 0.0 0.0 -16.986464 1.1221738 0.0 0.0 -233.92679
   -28.335625 0.0 0.0 -1.2083608 -0.76314527 0.0 0.0 -17.048222 0.3272371 0.0
   0.0 -1.3892436 -0.31000596 0.0 0.0 -1.8029487 -0.7699915 0.0 0.0 -1.3704121
   -0.18705349 0.0 0.0 -248.96785 -108.90041 0.0 0.0 -1.451447 0.21722656 0.0
   0.0 -192.0024 -49.047047 0.0 0.0 -18.537647 -4.899882 0.0 0.0 -1.4550773
   0.053114533 0.0 0.0 -15.64065 -5.412188 0.0 0.0 -1.3625323 0.010247715 0.0
   0.0 -14.797321 -8.264939 0.0 0.0 -1.3773438 0.26837978 0.0 0.0 -1.448391
   0.29906452 0.0 0.0 -159.92824 -174.498 0.0 0.0 -286.39798 -93.87643 0.0 0.0
   -23.026543 -4.3669777 0.0 0.0 -0.82666844 0.8573183 0.0 0.0 -1.4204891
   -0.31941262 0.0 0.0 -1.4116162 -0.33844027 0.0 0.0 -14.181764 -4.6500053 0.0
   0.0 -210.7957 -53.92226 0.0 0.0 -19.892279 -1.3163749 0.0 0.0 -1.3196605
   0.6354317 0.0 0.0 -15.339982 7.9349585 0.0 0.0 -17.416306 -10.25156 0.0 0.0
   -16.127186 6.378449 0.0 0.0 -280.06015 69.00033 0.0 0.0 -19.155727 3.3415363
   0.0 0.0 -1.4382414 -0.057121146 0.0 0.0 -4144.059 -155.32648 0.0 0.0
   -225.44647 -27.267502 0.0 0.0 -22.234741 6.7484145 0.0 0.0 -15.978526
   -6.7089624 0.0 0.0 -17.256172 1.4092656 0.0 0.0 -16.098402 -4.2044964 0.0 0.0
   -13.546163 -10.424004 0.0 0.0 -17.44756 4.9224834 0.0 0.0 -1.3956099
   -0.1192683 0.0 0.0 -247.115 25.323502 0.0 0.0 -18.957869 -3.6982849 0.0 0.0
   -1.3215352 0.22951493 0.0 0.0 -204.23734 -145.2192 0.0 0.0 -1.5620594
   -0.30234352 0.0 0.0 -1.4546288 0.15712303 0.0 0.0 -232.77136 -124.712654 0.0
   0.0 -15.628722 -0.38360354 0.0 0.0 -1.420262 -0.10452157 0.0 0.0 -1.1818374
   -0.7282349 0.0 0.0 -281.44012 -63.13638 0.0 0.0 -19.000166 3.6346164 0.0 0.0
   -1.3701799 -0.3075858 0.0 0.0 -237.1681 76.89113 0.0 0.0 -218.13452
   -6.3218465 0.0 0.0 -285.30246 42.393883 0.0 0.0 -1.2687097 0.38910505 0.0 0.0
   -1.2059175 -0.5813683 0.0 0.0 -249.83156 119.58898 0.0 0.0 -1.0246807
   0.599247 0.0 0.0 -22.951504 -8.20941 0.0 0.0 -17.012825 -2.9055054 0.0 0.0
   -1.3299879 -0.14822368 0.0 0.0 -1.216603 -0.5593723 0.0 0.0 -17.04653
   2.755176 0.0 0.0 -15.061859 -9.16637 0.0 0.0 -12.65539 -4.463944 0.0 0.0
   -224.7345 -140.32938 0.0 0.0 -16.150188 -4.495339 0.0 0.0 -1.3391807
   0.05191435 0.0 0.0 -0.87658715 -0.97364396 0.0 0.0 -15.08502 -7.536712 0.0
   0.0 -1.1862581 -0.419165 0.0 0.0 -0.95273584 0.7758878 0.0 0.0 -16.774961
   0.44576788 0.0 0.0 -1.4663787 -0.31730166 0.0 0.0 -16.453003 1.5758817 0.0
   0.0 -1.2869182 -0.15950713 0.0 0.0 -1.333535 -0.02681723 0.0 0.0 -18.338842
   -3.306719 0.0 0.0 -212.15688 -57.886517 0.0 0.0 -15.646071 7.4159155 0.0 0.0
   -15.880165 12.504731 0.0 0.0 -218.00104 30.469906 0.0 0.0 -17.029495
   2.8004365 0.0 0.0 -1.2247534 -0.54069394 0.0 0.0 -1.3300986 0.6513129 0.0 0.0
   -1.2713189 0.34406188 0.0 0.0 -1.2859169 -0.33889252 0.0 0.0 -225.02379
   -55.525135 0.0 0.0 -1.0749414 -0.673668 0.0 0.0 -178.9196 -129.17114 0.0 0.0
   -228.21097 39.192413 0.0 0.0 -16.56244 3.010569 0.0 0.0 -1.3049369 -0.202115
   0.0 0.0 -1.2289065 0.48096913 0.0 0.0 -1.3214147 -0.11203331 0.0 0.0
   -1.1742235 -0.6195382 0.0 0.0 -19.698027 -0.15430875 0.0 0.0 -229.11183
   -82.315605 0.0 0.0 -17.74928 -3.4984436 0.0 0.0 -250.73727 94.74004 0.0 0.0
   -1.2893811 -0.363226 0.0 0.0 -1.3078922 0.26711714 0.0 0.0 -16.136133
   -6.4411507 0.0 0.0 -16.81318 -3.7537222 0.0 0.0 -15.368338 4.473346 0.0 0.0
   -143.1765 -183.40419 0.0 0.0 -229.74075 -37.29119 0.0 0.0 -14.847933
   3.8153408 0.0 0.0 -14.980092 3.0930638 0.0 0.0 -282.1706 -129.8939 0.0 0.0
   -21.658957 -5.409529 0.0 0.0 -281.96054 -16.221205 0.0 0.0 -255.3894
   -25.70068 0.0 0.0 -216.39638 -51.080776 0.0 0.0 -18.5073 -1.7309318 0.0 0.0
   -1.023345 -0.85761684 0.0 0.0 -1.3167095 0.23689358 0.0 0.0 -317.08316
   170.07614 0.0 0.0 -0.72245246 0.038793437 0.0 0.0 -233.7213 -0.27910876 0.0
   0.0 -243.36026 -30.795404 0.0 0.0 -17.599108 -6.047437 0.0 0.0 -14.706879
   -8.355061 0.0 0.0 -1.4045709 0.13197654 0.0 0.0 -181.55396 -147.78154 0.0 0.0
   -248.86382 106.00937 0.0 0.0 -1.1347823 0.82640535 0.0 0.0 -31.235048
   -3.9163332 0.0 0.0 -1.1754963 -0.6450158 0.0 0.0 -1.1511568 0.80230296 0.0
   0.0 -22.557661 -0.011429946 0.0 0.0 -270.9892 6.226372 0.0 0.0 -1.0715858
   -0.7693626 0.0 0.0 -182.3482 -218.54034 0.0 0.0 -1.2347449 0.18671991 0.0 0.0
   -1.3179336 -0.046199255 0.0 0.0 -249.0563 36.65561 0.0 0.0 -1.3332617
   -0.08108395 0.0 0.0 -1.320097 0.13506033 0.0 0.0 -1.3315626 -0.11462711 0.0
   0.0 -17.50691 -3.028574 0.0 0.0 -245.06763 30.8155 0.0 0.0 -1.2594807
   -0.3729205 0.0 0.0 -1.2619221 -0.20451978 0.0 0.0 -1.2661653 -0.14918965 0.0
   0.0 -14.739859 -4.4078403 0.0 0.0 -197.8814 -102.481674 0.0 0.0 -0.9777151
   -0.7862793 0.0 0.0 -1.3144792 -0.16158502 0.0 0.0 -1.3369975 -0.094643 0.0
   0.0 -15.317849 1.9043037 0.0 0.0 -1.2778882 0.17756677 0.0 0.0 -14.281667
   9.965258 0.0 0.0 -235.21286 22.415482 0.0 0.0 -15.235251 2.4717584 0.0 0.0
   -275.84686 -78.616806 0.0 0.0 -17.265594 -2.2912338 0.0 0.0 -1.2720652
   0.0038121343 0.0 0.0 -17.189362 -3.4510794 0.0 0.0 -1.3025066 0.31168887 0.0
   0.0 -14.103449 -7.1097016 0.0 0.0 -185.39291 -107.06286 0.0 0.0 -1.1407963
   -0.578172 0.0 0.0 -20.730547 6.0665693 0.0 0.0 -0.89438546 -0.973065 0.0 0.0
   -1.1938725 -0.5987112 0.0 0.0 -14.882958 -7.780355 0.0 0.0 -18.17161 2.292411
   0.0 0.0 -15.853214 6.3001 0.0 0.0 -1.0305858 -0.12673095 0.0 0.0 -1.2006626
   0.5901454 0.0 0.0 -188.52853 -181.6646 0.0 0.0 -1.2925841 0.03838695 0.0 0.0
   -225.7054 -19.45832 0.0 0.0 -1.0756391 -0.22354779 0.0 0.0 -226.63757
   -4.5507617 0.0 0.0 -1.3394383 0.054585226 0.0 0.0 -245.31174 47.774075 0.0
   0.0 -1.3336463 -0.011419792 0.0 0.0 -1.264644 0.3382037 0.0 0.0 -1.1847165
   -0.5239873 0.0 0.0 -1.094876 -0.630578 0.0 0.0 -11.04165 -8.95606 0.0 0.0
   -16.893398 -4.9082136 0.0 0.0 -240.03969 71.60057 0.0 0.0 -0.97010833
   0.566242 0.0 0.0 -14.79015 -4.0861382 0.0 0.0 -15.764616 2.5989006 0.0 0.0
   -226.91255 17.657331 0.0 0.0 -1.1338619 -0.71662563 0.0 0.0 -1.0927956
   -0.7729391 0.0 0.0 -15.188479 8.904238 0.0 0.0 -13.4107485 -11.369958 0.0 0.0
   -1.5008941 -0.419562 0.0 0.0 -1.2071791 -0.55336154 0.0 0.0 -1.3797529
   -0.7865213 0.0 0.0 -1.3341701 0.122259796 0.0 0.0 -0.74245226 -0.6226317 0.0
   0.0 -1.2411551 -0.4148444 0.0 0.0 -1.5531404 0.21201907 0.0 0.0 -1.3717192
   0.46021065 0.0 0.0 -238.09346 -29.49435 0.0 0.0 -21.747877 -1.7105175 0.0 0.0
   -264.35574 11.791535 0.0 0.0 -1.2944906 -0.28296864 0.0 0.0 -33.782322
   -1.0954818 0.0 0.0 -0.92953926 0.9622693 0.0 0.0 -222.31104 -91.408035 0.0
   0.0 -1.3063138 -0.06681402 0.0 0.0 -214.22285 -81.15804 0.0 0.0 -1.3314708
   -0.068451 0.0 0.0 -1.0907865 0.72144413 0.0 0.0 -13.871696 -6.341708 0.0 0.0
   -1.3766832 -0.5998902 0.0 0.0 -240.71104 9.608994 0.0 0.0 -1.3020438
   0.19949111 0.0 0.0 -1.1984849 -0.06507591 0.0 0.0 -1.2946593 -0.12451438 0.0
   0.0 -1.3197689 -0.20968994 0.0 0.0 -16.459251 -6.5068736 0.0 0.0 -1.129737
   -0.5025508 0.0 0.0 -1.3147593 -0.05222202 0.0 0.0 -1.1386594 -0.7029098 0.0
   0.0 -17.301939 -3.7777395 0.0 0.0 -1.1333451 -0.36682624 0.0 0.0 -1.2892443
   -0.14414516 0.0 0.0 -1.1249384 -0.7146542 0.0 0.0 -250.81523 -90.77111 0.0
   0.0 -21.585602 -3.2074502 0.0 0.0 -1.265297 -0.35255468 0.0 0.0 -245.09113
   -136.17723 0.0 0.0 -242.09467 7.1379294 0.0 0.0 -17.710285 -0.74591297 0.0
   0.0 -17.231848 -7.7414446 0.0 0.0 -14.434235 -5.861173 0.0 0.0 -0.8112217
   -1.029224 0.0 0.0 -1.2077619 -0.5592332 0.0 0.0 -17.693476 0.03394011 0.0 0.0
   -260.14624 -106.60839 0.0 0.0 -1.2495979 -0.45733884 0.0 0.0 -252.9142
   -33.17651 0.0 0.0 -16.686779 -4.3668523 0.0 0.0 -283.38867 84.2991 0.0 0.0
   -0.9271372 -0.9618626 0.0 0.0 -230.39099 23.26094 0.0 0.0 -16.89062
   -3.3232243 0.0 0.0 -231.40056 11.86303 0.0 0.0 -10.181577 -11.825761 0.0 0.0
   -1.1782275 0.047503665 0.0 0.0 -235.78378 61.121784 0.0 0.0 -1.304324
   -0.2542831 0.0 0.0 -1.1492391 0.15351264 0.0 0.0 -1.3008875 0.27486086 0.0
   0.0 -21.019705 2.015544 0.0 0.0 -15.5334425 -2.0035121 0.0 0.0 -254.27974
   -32.26104 0.0 0.0 -18.008608 -6.3200746 0.0 0.0 -1.208063 -0.38032266 0.0 0.0
   -17.457249 -3.4128582 0.0 0.0 -17.020445 -3.4422925 0.0 0.0 -15.693504
   -0.8870917 0.0 0.0 -21.201096 6.183928 0.0 0.0 -351.3178 -88.931915 0.0 0.0
   -1.3390607 -0.008270309 0.0 0.0 -17.780838 0.19835179 0.0 0.0 -1.3105121
   0.14017282 0.0 0.0 -14.097425 16.55808 0.0 0.0 -1.2010193 -0.5783225 0.0 0.0
   -1.3789749 0.19430134 0.0 0.0 -282.76318 27.573612 0.0 0.0 -15.604463
   1.787204 0.0 0.0 -14.244464 6.690546 0.0 0.0 -15.661424 -1.5860549 0.0 0.0
   -338.0468 -252.32405 0.0 0.0 -13.436402 -8.086472 0.0 0.0 -1.2753834
   0.39361006 0.0 0.0 -1.3150573 0.17438115 0.0 0.0 -20.762993 -4.557725 0.0 0.0
   -1.4314154 0.114453115 0.0 0.0 -1.2075537 -0.42373464 0.0 0.0 -15.68411
   -1.602002 0.0 0.0 -18.746803 -9.775556 0.0 0.0 -1.3403647 0.041372225 0.0 0.0
   -1.3065782 -0.29045734 0.0 0.0 -24.159426 -1.7184292 0.0 0.0 -253.2048
   -53.534252 0.0 0.0 -1.4802791 -0.41926578 0.0 0.0 -12.189696 9.975791 0.0 0.0
   -16.3011 -2.7288518 0.0 0.0 -17.403456 -0.45464402 0.0 0.0 -1.052312
   -0.79110444 0.0 0.0 -15.641101 -8.693444 0.0 0.0 -1.284056 0.3327002 0.0 0.0
   -16.172768 -3.6332254 0.0 0.0 -17.60269 -2.9614058 0.0 0.0 -1.2619889
   -0.34356752 0.0 0.0 -245.56436 -84.562 0.0 0.0 -14.964752 6.4716077 0.0 0.0
   -14.921414 5.221881 0.0 0.0 -18.580524 -4.97711 0.0 0.0 -1.288426 0.060153235
   0.0 0.0 -1.1318032 0.05360383 0.0 0.0 -1.3231676 0.21753958 0.0 0.0
   -15.5981865 -4.986289 0.0 0.0 -1.3180544 -0.24796121 0.0 0.0 -223.56017
   75.35613 0.0 0.0 -1.0075996 -0.8568191 0.0 0.0 -16.473959 1.4359723 0.0 0.0
   -245.46217 87.86903 0.0 0.0 -17.510866 0.48330596 0.0 0.0 -1.4522254
   -0.036166944 0.0 0.0 -19.155363 -6.399329 0.0 0.0 -1.4419571 -0.12676854 0.0
   0.0 -272.45483 -94.67375 0.0 0.0 -16.938337 -3.9686697 0.0 0.0 -269.146
   -103.70721 0.0 0.0 -19.888659 -3.4527345 0.0 0.0 -231.32649 -59.004253 0.0
   0.0 -2.1292763 -0.23642838 0.0 0.0 -231.95285 -47.977283 0.0 0.0 -17.172398
   -5.6999617 0.0 0.0 -13.896652 -14.827463 0.0 0.0 -17.833189 -8.30063 0.0 0.0
   -284.33224 48.476032 0.0 0.0 -275.32245 -85.97855 0.0 0.0 -288.2224 11.071827
   0.0 0.0 -208.05489 114.340904 0.0 0.0 -1.4297216 -0.13901281 0.0 0.0
   -1.5992069 -0.046116903 0.0 0.0 -17.967783 4.47502 0.0 0.0 -257.7581
   -50.434082 0.0 0.0 -16.013762 -12.765909 0.0 0.0 -282.1976 -59.659554 0.0 0.0
   -20.250963 -0.9810318 0.0 0.0 -262.93274 -3.0649886 0.0 0.0 -1.3976518
   -0.08597274 0.0 0.0 -17.644297 -5.2916036 0.0 0.0 -1.1522949 0.9194431 0.0
   0.0 -232.16716 54.042923 0.0 0.0 -1.112601 -0.47714737 0.0 0.0 -1.3893367
   0.2340288 0.0 0.0 -3556.4092 614.89575 0.0 0.0 -1.4296712 -0.06481635 0.0 0.0
   -1.490724 0.28324723 0.0 0.0 -1.2994944 0.078854606 0.0 0.0 -265.68927
   123.276405 0.0 0.0 -16.824993 -4.871016 0.0 0.0 -16.992369 5.875402 0.0 0.0
   -1.4768807 -0.6195188 0.0 0.0 -1.4186387 0.3004124 0.0 0.0 -1.4359722
   -0.12960109 0.0 0.0 -250.46716 23.554525 0.0 0.0 -230.2644 -72.35579 0.0 0.0
   -0.9134797 -1.001343 0.0 0.0 -3624.3335 -211.59492 0.0 0.0 -1.4803274
   -0.14077985 0.0 0.0 -19.493748 5.5648475 0.0 0.0 -282.98404 -55.810223 0.0
   0.0 -202.9211 127.68143 0.0 0.0 -11.039265 -11.657511 0.0 0.0 -18.25918
   2.7546134 0.0 0.0 -19.474426 0.755205 0.0 0.0 -1.1036719 -0.9805258 0.0 0.0
   -13.3661785 -14.6182995 0.0 0.0 -17.874117 2.9834452 0.0 0.0 -225.69705
   -113.603096 0.0 0.0 -241.4227 -74.61546 0.0 0.0 -1.3778734 -0.43226567 0.0
   0.0 -17.023056 -4.679456 0.0 0.0 -235.28282 -98.4253 0.0 0.0 -1.4660206
   -0.14372666 0.0 0.0 -645.6665 115.77651 0.0 0.0 -10.884975 -16.649694 0.0 0.0
   -269.13083 -81.217155 0.0 0.0 -19.501528 -2.3001287 0.0 0.0 -1.9698302
   0.101552784 0.0 0.0 -1.4664735 -0.25296327 0.0 0.0 -1.2717749 0.33263543 0.0
   0.0 -15.53645 8.982461 0.0 0.0 -19.599384 1.3701879 0.0 0.0 -1.268889
   0.28302944 0.0 0.0 -204.2013 -3.3445456 0.0 0.0 -22.45319 -2.9172328 0.0 0.0
   -18.73091 -0.32544294 0.0 0.0 -288.4305 1.6080403 0.0 0.0 -0.8796579
   -0.8706672 0.0 0.0 -20.59708 -2.5973039 0.0 0.0 -1.0156801 -0.81222236 0.0
   0.0 -18.095991 -0.21079282 0.0 0.0 -19.777325 -6.5315413 0.0 0.0 -238.99644
   38.941452 0.0 0.0 -240.28893 30.2791 0.0 0.0 -0.81051517 0.77544135 0.0 0.0
   -16.378336 -7.0096517 0.0 0.0 -14.495755 15.9905 0.0 0.0 -1.4252837
   0.27504146 0.0 0.0 -238.8992 -42.120773 0.0 0.0 -1.3223697 -0.21024896 0.0
   0.0 -16.344017 -7.425023 0.0 0.0 -18.573229 2.7775931 0.0 0.0 -17.555616
   -4.395509 0.0 0.0 -1.3507322 -0.3598374 0.0 0.0 -17.212662 4.562506 0.0 0.0
   -1.0519327 -0.9769906 0.0 0.0 -20.809011 0.017628781 0.0 0.0 -16.36489
   8.125559 0.0 0.0 -32.527668 3.0886781 0.0 0.0 -1.404592 0.047204476 0.0 0.0
   -1.324976 0.14059159 0.0 0.0 -280.00266 -69.23334 0.0 0.0 -1.4536602
   0.28621712 0.0 0.0 -191.87318 215.35884 0.0 0.0 -17.21708 -5.961535 0.0 0.0
   -1.471039 -0.0797217 0.0 0.0 -32.226635 -4.2155128 0.0 0.0 -16.026152
   -2.5477707 0.0 0.0 -251.04305 52.950798 0.0 0.0 -17.591188 -5.129043 0.0 0.0
   -1.4383972 -0.37847096 0.0 0.0 -14.123902 -11.544268 0.0 0.0 -1.4930553
   0.29275113 0.0 0.0 -1.0559125 -0.7301995 0.0 0.0 -16.757553 -2.7962682 0.0
   0.0 -243.23026 -118.35459 0.0 0.0 -1.4678159 -0.12182688 0.0 0.0 -19.609602
   1.5143971 0.0 0.0 -1.2113106 0.54235524 0.0 0.0 -1.2838116 -0.25815994 0.0
   0.0 -1.2044985 0.22944377 0.0 0.0 -14.829243 10.64489 0.0 0.0 -18.12775
   2.507257 0.0 0.0 -1.3408462 0.024792407 0.0 0.0 -19.315548 3.5193934 0.0 0.0
   -1.3230165 0.42233676 0.0 0.0 -1.4151855 0.22606248 0.0 0.0 -238.21553
   -59.17262 0.0 0.0 -17.843956 2.472605 0.0 0.0 -15.39477 8.912604 0.0 0.0
   -1.3028095 0.09404256 0.0 0.0 -16.217024 0.52104956 0.0 0.0 -1.3707585
   -0.44370252 0.0 0.0 -1.3911307 -0.5158809 0.0 0.0 -1.0748448 -0.83207786 0.0
   0.0 -1.0169883 -0.7327901 0.0 0.0 -1.4605325 -0.21035774 0.0 0.0 -1.3893331
   -0.17810223 0.0 0.0 -1.3383137 0.64657426 0.0 0.0 -1.2997391 0.41433385 0.0
   0.0 -1.260141 -0.24484241 0.0 0.0 -16.24749 -5.255229 0.0 0.0 -233.58614
   64.852806 0.0 0.0 -15.690634 -6.2724247 0.0 0.0 -231.60759 -84.6656 0.0 0.0
   -279.31128 66.70705 0.0 0.0 -18.730892 -11.269794 0.0 0.0 -233.52734
   -169.29185 0.0 0.0 -1.4749422 0.17838976 0.0 0.0 -18.78946 3.858955 0.0 0.0
   -0.9371063 -0.95800984 0.0 0.0 -16.102598 8.02436 0.0 0.0 -252.22432
   -63.723553 0.0 0.0 -1.4814558 -0.025187105 0.0 0.0 -1.3027773 0.25845683 0.0
   0.0 -260.11237 -124.6447 0.0 0.0 -14.635063 10.511922 0.0 0.0 -1.2247524
   -0.67982835 0.0 0.0 -17.419868 -3.1666822 0.0 0.0 -1.3313262 -0.4862804 0.0
   0.0 -16.800194 -3.3466167 0.0 0.0 -245.2705 -36.18375 0.0 0.0 -1.3042699
   -0.035463464 0.0 0.0 -1.1450912 0.64235085 0.0 0.0 -15.590784 -5.0008593 0.0
   0.0 -0.42591503 -1.2196733 0.0 0.0 -26.519117 -4.388926 0.0 0.0 -247.98701
   12.932085 0.0 0.0 -1.2426586 0.7173403 0.0 0.0 -0.99869955 -0.962141 0.0 0.0
   -18.08596 -1.1072793 0.0 0.0 -287.9401 -16.889503 0.0 0.0 -1.3128377
   -0.018066792 0.0 0.0 -1.4711748 -0.1142069 0.0 0.0 -15.434067 -14.101634 0.0
   0.0 -262.97122 82.456924 0.0 0.0 -18.652697 6.806815 0.0 0.0 -286.81186
   30.556383 0.0 0.0 -15.793994 3.8868463 0.0 0.0 -16.492508 7.2954774 0.0 0.0
   -1.4112904 -0.2348398 0.0 0.0 -1.4657462 0.21647121 0.0 0.0 -1.461476
   -0.2837192 0.0 0.0 -1.3809824 -0.51566404 0.0 0.0 -1.4701585 -0.21804807 0.0
   0.0 -16.471998 5.0842953 0.0 0.0 -1.3807564 -0.32005277 0.0 0.0 -249.56493
   -11.865614 0.0 0.0 -276.05154 19.977411 0.0 0.0 -288.19058 -11.871191 0.0 0.0
   -16.358799 -0.84362215 0.0 0.0 -250.00061 -5.8559585 0.0 0.0 -17.143469
   2.1241608 0.0 0.0 -15.024772 -5.690117 0.0 0.0 -283.28992 17.92784 0.0 0.0
   -1.3407845 -0.5229286 0.0 0.0 -1.109506 -0.84159017 0.0 0.0 -1.3845719
   0.22417116 0.0 0.0 -16.392933 0.81933147 0.0 0.0 -4541.33 2137.365 0.0 0.0
   -1.3206578 -0.6183132 0.0 0.0 -250.5366 13.960568 0.0 0.0 -1.3084149
   0.18019432 0.0 0.0 -273.41068 -87.19034 0.0 0.0 -200.99525 150.29123 0.0 0.0
   -246.15947 49.82644 0.0 0.0 -16.717442 4.5174284 0.0 0.0 -250.73462 16.908674
   0.0 0.0 -16.447914 -0.50239927 0.0 0.0 -1.4859459 0.06495378 0.0 0.0
   -18.354883 -0.55057603 0.0 0.0 -251.45729 -141.29395 0.0 0.0 -1.2455252
   -0.09700633 0.0 0.0 -1.3474654 0.47484577 0.0 0.0 -17.91928 4.1673646 0.0 0.0
   -17.673306 -5.140206 0.0 0.0 -4033.311 855.5753 0.0 0.0 -1.4832429
   0.082195394 0.0 0.0 -717.4319 -186.7595 0.0 0.0 -1.4083918 -0.6013227 0.0 0.0
   -1.301366 0.19134532 0.0 0.0 -1.4469131 0.35012168 0.0 0.0 -19.343327
   4.5997915 0.0 0.0 -19.034548 2.2407296 0.0 0.0 -288.41373 -3.5017436 0.0 0.0
   -1.4483949 -0.11038079 0.0 0.0 -17.932514 -1.1090329 0.0 0.0 -240.54445
   77.60552 0.0 0.0 -15.783623 -9.959444 0.0 0.0 -1.3645421 -0.42976204 0.0 0.0
   -1.3847444 -0.31751353 0.0 0.0 -19.06377 -7.1924314 0.0 0.0 -1.3136587
   -0.33854076 0.0 0.0 -4275.597 -920.3552 0.0 0.0 -1.4409899 0.26734927 0.0 0.0
   -1.3259965 -0.66775006 0.0 0.0 -574.197 -54.911407 0.0 0.0 -21.199068
   -0.57204366 0.0 0.0 -299.12558 16.162218 0.0 0.0 -18.299665 -3.036148 0.0 0.0
   -1.6206641 0.31263816 0.0 0.0 -16.110106 -7.9214582 0.0 0.0 -1.4198556
   -0.44325936 0.0 0.0 -285.67767 39.78699 0.0 0.0 -15.683402 5.220582 0.0 0.0
   -1.3112799 -0.2966358 0.0 0.0 -0.982057 -1.0566449 0.0 0.0 -1.1885122
   -0.48445097 0.0 0.0 -277.7219 77.88009 0.0 0.0 -330.9947 -10.97623 0.0 0.0
   -248.84355 -53.3001 0.0 0.0 -0.9633953 0.13666774 0.0 0.0 -248.65251
   54.154903 0.0 0.0 -17.827534 -10.729689 0.0 0.0 -15.3322 5.946152 0.0 0.0
   -21.236525 7.3441653 0.0 0.0 -1.1319506 -0.85207087 0.0 0.0 -245.71059
   -108.202774 0.0 0.0 -198.39299 -160.12706 0.0 0.0 -4378.7637 -1593.5891 0.0
   0.0 -1.3983577 -0.08690402 0.0 0.0 -1.3191402 -0.4704103 0.0 0.0 -0.8423944
   -1.285 0.0 0.0 -1.4299328 0.058708027 0.0 0.0 -1.1126947 -0.3893451 0.0 0.0
   -1.0365897 0.8727683 0.0 0.0 -281.70212 61.95701 0.0 0.0 -1.6710159 0.4606011
   0.0 0.0 -1.3940557 -0.09932414 0.0 0.0 -219.43413 -158.289 0.0 0.0 -1.3719695
   0.12998313 0.0 0.0 -253.61436 -132.40913 0.0 0.0 -252.8686 40.44867 0.0 0.0
   -22.588768 -8.56362 0.0 0.0 -17.614618 7.5070415 0.0 0.0 -271.7212 -96.759186
   0.0 0.0 -12.942551 -11.292795 0.0 0.0 -238.27477 -95.048615 0.0 0.0
   -1.4230684 -0.20506781 0.0 0.0 -237.83388 -96.24589 0.0 0.0 -1.3693403
   0.34465605 0.0 0.0 -331.6583 -36.908928 0.0 0.0 -1.2958326 -0.46273398 0.0
   0.0 -20.460396 -0.15085922 0.0 0.0 -256.1419 -132.61246 0.0 0.0 -283.7271
   51.900574 0.0 0.0 -286.2331 35.572033 0.0 0.0 -1.3270799 0.6681947 0.0 0.0
   -452.67084 -62.436302 0.0 0.0 -0.8713272 -1.1526059 0.0 0.0 -226.66135
   -77.86881 0.0 0.0 -8896.194 -4029.665 0.0 0.0 -1.372386 -0.36643654 0.0 0.0
   -257.02396 130.89474 0.0 0.0 -3988.4097 -724.46875 0.0 0.0 -14.365706
   -10.090234 0.0 0.0 -288.3861 5.3106494 0.0 0.0 -245.5746 -78.930145 0.0 0.0
   -264.7694 -49.649178 0.0 0.0 -1.4297972 -0.2841072 0.0 0.0 -1.2752188
   -0.2690546 0.0 0.0 -1.3866587 0.47309315 0.0 0.0 -18.519283 2.1341956 0.0 0.0
   -16.648558 -5.642282 0.0 0.0 -1.2304524 -0.797097 0.0 0.0 -1.408934
   -0.39776096 0.0 0.0 -17.401697 -9.559706 0.0 0.0 -269.54776 -39.80494 0.0 0.0
   -299.43878 -224.68736 0.0 0.0 -272.6542 5.207489 0.0 0.0 -220.79533
   -196.75726 0.0 0.0 -1.480171 0.04176091 0.0 0.0 -19.994362 -6.139277 0.0 0.0
   -288.50662 -107.36387 0.0 0.0 -1.3971689 -0.502391 0.0 0.0 -14.626359
   -4.0135922 0.0 0.0 -195.11053 -157.86641 0.0 0.0 -263.0859 -118.23945 0.0 0.0
   -323.0884 -103.66155 0.0 0.0 -1.758868 0.50305927 0.0 0.0 -14.921157
   7.3269567 0.0 0.0 -258.31592 127.84053 0.0 0.0 -19.774834 -8.629369 0.0 0.0
   -1.3593043 -0.23560174 0.0 0.0 -16.29788 2.555162 0.0 0.0 -1.2137415
   -0.5326898 0.0 0.0 -18.099276 -5.5783744 0.0 0.0 -1.3271897 0.5623042 0.0 0.0
   -1.0745643 0.7459382 0.0 0.0 -18.183271 4.9789333 0.0 0.0 -1.3743778
   0.24134102 0.0 0.0 -261.78897 -5.877629 0.0 0.0 -3372.0725 2369.4104 0.0 0.0
   -274.51642 11.293625 0.0 0.0 -245.22128 88.58823 0.0 0.0 -288.31653
   -8.2665415 0.0 0.0 -1.3537941 -0.36417612 0.0 0.0 -255.50816 53.373962 0.0
   0.0 -307.52707 4.671614 0.0 0.0 -17.265856 6.642412 0.0 0.0 -225.2991
   -161.8571 0.0 0.0 -0.3670741 -0.067171596 0.0 0.0 -1.4813262 -0.1557438 0.0
   0.0 -1.1217479 -0.71707547 0.0 0.0 -245.0526 -129.81694 0.0 0.0 -401.04996
   -187.61597 0.0 0.0 -266.23868 -71.69349 0.0 0.0 -17.673952 -6.799624 0.0 0.0
   -14.7225685 -3.452257 0.0 0.0 -4373.4507 95.72288 0.0 0.0 -299.55817 6.591553
   0.0 0.0 -20.557377 4.745827 0.0 0.0 -15.052255 -3.9675932 0.0 0.0 -17.853552
   4.005493 0.0 0.0 -331.21555 -88.90616 0.0 0.0 -17.681673 -0.67977303 0.0 0.0
   -1.4124299 -0.10680739 0.0 0.0 -11.213386 14.964326 0.0 0.0 -20.503153
   -5.7388997 0.0 0.0 -1.3684962 -0.2315796 0.0 0.0 -1.4332699 0.17393085 0.0
   0.0 -1.3252777 -0.2082006 0.0 0.0 -16.574493 2.0390449 0.0 0.0 -1.3051853
   -0.3555639 0.0 0.0 -22.569862 1.1185046 0.0 0.0 -0.98420197 0.46774346 0.0
   0.0 -18.694525 -3.1501055 0.0 0.0 -1.4311299 -0.32699633 0.0 0.0 -16.51765
   -3.2143123 0.0 0.0 -23.795717 -5.847411 0.0 0.0 -17.928383 -15.543467 0.0 0.0
   -24.1371 -1.8876387 0.0 0.0 -15.350354 1.7422134 0.0 0.0 -1.4289308
   -0.47899845 0.0 0.0 -1.1646254 0.59415114 0.0 0.0 -1.3736719 0.45898604 0.0
   0.0 -1.2995453 0.5372908 0.0 0.0 -1.4146168 0.45160085 0.0 0.0 -18.192259
   3.1180863 0.0 0.0 -1.3603805 0.41695312 0.0 0.0 -1.4563178 -0.2725533 0.0 0.0
   -1.253345 0.45204002 0.0 0.0 -281.4543 -74.15905 0.0 0.0 -1.423504 0.12876058
   0.0 0.0 -272.11624 95.64256 0.0 0.0 -262.29105 119.99229 0.0 0.0 -1.4533534
   0.22922781 0.0 0.0 -4196.8364 -445.97644 0.0 0.0 -329.2556 -111.57512 0.0 0.0
   -1.2649614 0.20028228 0.0 0.0 -1.4843882 0.025341658 0.0 0.0 -13.983218
   -8.684694 0.0 0.0 -1.182442 -0.8911824 0.0 0.0 -1.2845354 -0.40336475 0.0 0.0
   -16.920277 -12.096254 0.0 0.0 -139.66376 -89.26403 0.0 0.0 -1.4689971
   0.15539813 0.0 0.0 -262.8431 24.741251 0.0 0.0 -280.3576 67.78171 0.0 0.0
   -1.4857619 -0.10114829 0.0 0.0 -1.339033 -0.63566774 0.0 0.0 -28.299435
   2.0725904 0.0 0.0 -1.017215 -0.70320356 0.0 0.0 -1.4150745 0.19875123 0.0 0.0
   -266.3254 -45.086304 0.0 0.0 -13.200539 -11.75611 0.0 0.0 -15.596682
   -6.6239233 0.0 0.0 -13.594913 -11.369915 0.0 0.0 -1.2622374 0.2714827 0.0 0.0
   -1.4037517 0.47125316 0.0 0.0 -265.34476 -24.845003 0.0 0.0 -1.1333282
   0.09672776 0.0 0.0 -16.916996 -0.7033125 0.0 0.0 -1.5012808 -0.14895093 0.0
   0.0 -1.2819191 -0.6512047 0.0 0.0 -4586.0547 1225.8838 0.0 0.0 -1.4111134
   -0.19818583 0.0 0.0 -18.841045 -0.28351203 0.0 0.0 -14.081692 -9.44658 0.0
   0.0 -279.56415 70.98338 0.0 0.0 -245.93617 -36.402508 0.0 0.0 -20.501877
   5.2022886 0.0 0.0 -477.71362 -51.682182 0.0 0.0 -1.58998 0.12312277 0.0 0.0
   -1.6618661 0.05722589 0.0 0.0 -1.4761496 -0.18707325 0.0 0.0 -1.237229
   -0.8001903 0.0 0.0 -20.554077 3.0439618 0.0 0.0 -21.02135 -3.8642335 0.0 0.0
   -22.014261 -15.907727 0.0 0.0 -1.4277636 0.30875695 0.0 0.0 -274.87314
   -66.117325 0.0 0.0 -248.6411 -63.002228 0.0 0.0 -11.973563 -13.100932 0.0 0.0
   -19.234396 -0.1013769 0.0 0.0 -16.246777 -7.558817 0.0 0.0 -16.479677
   3.7851913 0.0 0.0 -14.239147 -12.282181 0.0 0.0 -288.29898 8.857619 0.0 0.0
   -19.0929 -8.7438755 0.0 0.0 -12.444065 -16.343632 0.0 0.0 -1.3692069
   0.26604283 0.0 0.0 -1.4278039 -0.38852656 0.0 0.0 -267.9689 127.12525 0.0 0.0
   -453.2964 74.20687 0.0 0.0 -46.07875 -2.2318473 0.0 0.0 -4001.0166 -1651.902
   0.0 0.0 -16.273767 -14.636212 0.0 0.0 -15.052537 6.082396 0.0 0.0 -174.59946
   -205.18036 0.0 0.0 -1.4601686 -0.28171375 0.0 0.0 -236.86136 128.5937 0.0 0.0
   -1.3852606 0.5244995 0.0 0.0 -1.4071151 -0.43141675 0.0 0.0 -266.73453
   109.76079 0.0 0.0 -282.59933 34.464027 0.0 0.0 -1.2906488 0.71338385 0.0 0.0
   -261.61212 -67.21261 0.0 0.0 -4436.741 -1168.9932 0.0 0.0 -1.388172
   0.08754115 0.0 0.0 -186.85641 216.1319 0.0 0.0 -1.3198396 0.4905504 0.0 0.0
   -1.3706129 -0.32788634 0.0 0.0 -1.4869503 0.055086717 0.0 0.0 -1.1940087
   0.33017868 0.0 0.0 -21.378555 -1.2708856 0.0 0.0 -1.356273 0.20482148 0.0 0.0
   -287.93542 16.968697 0.0 0.0 -4820.2705 -618.9566 0.0 0.0 -18.77852
   -3.8602808 0.0 0.0 -1.3737861 0.4781106 0.0 0.0 -18.22466 5.5726533 0.0 0.0
   -1.2019614 -0.8007753 0.0 0.0 -18.888237 3.9776518 0.0 0.0 -1.4376377
   -0.345274 0.0 0.0 -248.7561 -109.69065 0.0 0.0 -1.1385878 -0.7782136 0.0 0.0
   -234.07828 -168.52927 0.0 0.0 -0.7644069 -1.196138 0.0 0.0 -277.64847
   78.14142 0.0 0.0 -10035.192 -4164.611 0.0 0.0 -1.2937375 -0.2965984 0.0 0.0
   -15.564593 -7.0971217 0.0 0.0 -1.4815459 -0.12655218 0.0 0.0 -30.139837
   -4.7246895 0.0 0.0 -200.59914 -207.25523 0.0 0.0 -1.2987789 0.27351144 0.0
   0.0 -19.357702 1.5157706 0.0 0.0 -17.809795 1.5262278 0.0 0.0 -12.73578
   -17.289728 0.0 0.0 -1.3267324 -0.044904273 0.0 0.0 -1.2328215 -0.82415724 0.0
   0.0 -0.8732629 -0.41316727 0.0 0.0 -287.7761 -19.484896 0.0 0.0 -1.4844979
   -0.12072356 0.0 0.0 -18.601112 -12.394774 0.0 0.0 -1.3714345 -0.5784761 0.0
   0.0 -1.3451602 -0.6131637 0.0 0.0 -1.3527173 -0.26627514 0.0 0.0 -15.977939
   8.351125 0.0 0.0 -1.36506 0.18985836 0.0 0.0 -1.4382278 0.2099748 0.0 0.0
   -1.4360597 0.3181859 0.0 0.0 -1.4717535 -0.06235082 0.0 0.0 -20.816458
   4.485816 0.0 0.0 -21.370497 -2.958188 0.0 0.0 -271.01443 -98.72147 0.0 0.0
   -265.98898 111.55545 0.0 0.0 -272.75372 -136.42703 0.0 0.0 -4191.6914
   1285.0502 0.0 0.0 -1.3225954 -0.83843184 0.0 0.0 -18.967598 -4.115058 0.0 0.0
   -19.422653 -8.484396 0.0 0.0 -16302.063 -11124.798 0.0 0.0 -27.009706
   0.49979565 0.0 0.0 -1.314481 -0.26788908 0.0 0.0 -1.3066614 -0.1776758 0.0
   0.0 -18.473333 5.5302596 0.0 0.0 -1.2082478 0.56946236 0.0 0.0 -1.3809538
   0.06644945 0.0 0.0 -1.2139436 -0.48257726 0.0 0.0 -210.52513 -52.737286 0.0
   0.0 -1.1538209 0.57928514 0.0 0.0 -317.97546 49.14366 0.0 0.0 -275.02264
   11.118975 0.0 0.0 -17.666397 -7.749445 0.0 0.0 -18.893269 -4.2818427 0.0 0.0
   -446.30374 12.294446 0.0 0.0 -1.1758983 0.83422476 0.0 0.0 -16.955307
   6.126291 0.0 0.0 -1.2889528 -0.31519926 0.0 0.0 -1.3739065 0.177713 0.0 0.0
   -1.2550426 -0.47330046 0.0 0.0 -0.9377242 0.41059107 0.0 0.0 -1.3074625
   -0.08246108 0.0 0.0 -1.2877532 0.20319009 0.0 0.0 -1.3162502 -0.23806274 0.0
   0.0 -1.3065199 0.29564726 0.0 0.0 -17.882898 -6.427767 0.0 0.0 -261.02893
   -87.44641 0.0 0.0 -1.2643644 -0.419884 0.0 0.0 -1.3018554 0.29425853 0.0 0.0
   -7.3614793 -17.893833 0.0 0.0 -18.564798 3.9011297 0.0 0.0 -287.99182
   109.86208 0.0 0.0 -23.680466 7.4530697 0.0 0.0 -233.88408 -175.26035 0.0 0.0
   -284.92902 -65.442184 0.0 0.0 -17.38704 -7.4305563 0.0 0.0 -1.3374848
   -0.025505282 0.0 0.0 -1.2340913 -0.1919935 0.0 0.0 -1.3227268 0.20017344 0.0
   0.0 -14.212359 -12.967208 0.0 0.0 -14.195967 -9.6220045 0.0 0.0 -15.149546
   -9.893568 0.0 0.0 -277.3459 -13.102082 0.0 0.0 -1.3088318 0.10498174 0.0 0.0
   -550.9515 -213.09482 0.0 0.0 -271.22647 5.3753085 0.0 0.0 -17.564861
   7.3474636 0.0 0.0 -16.55364 -9.5271225 0.0 0.0 -272.76126 -54.34483 0.0 0.0
   -289.98282 -187.22717 0.0 0.0 -387.46613 -363.9096 0.0 0.0 -0.97917235
   0.95213526 0.0 0.0 -1.1165287 -0.54196906 0.0 0.0 -1.0835813 0.030117378 0.0
   0.0 -1.3166875 -0.17249668 0.0 0.0 -1.2505006 0.4765688 0.0 0.0 -278.4839
   -12.085021 0.0 0.0 -15.150663 -11.918512 0.0 0.0 -29.35172 -1.0960855 0.0 0.0
   -294.2965 -9.820975 0.0 0.0 -1.3275052 0.13537599 0.0 0.0 -1.165436
   0.33949506 0.0 0.0 -316.88205 45.88054 0.0 0.0 -18.629213 5.5897484 0.0 0.0
   -0.98124576 0.8794154 0.0 0.0 -42.015972 -8.709561 0.0 0.0 -17.503487
   -14.618803 0.0 0.0 -231.48155 134.63591 0.0 0.0 -1.0046382 -0.04070769 0.0
   0.0 -1.0307039 -0.84330726 0.0 0.0 -339.90485 137.71794 0.0 0.0 -21.212688
   6.8823977 0.0 0.0 -1.1896367 -0.58180964 0.0 0.0 -25.04554 -0.7633901 0.0 0.0
   -14.563703 -9.083878 0.0 0.0 -28.739374 6.6115966 0.0 0.0 -1.3305476
   0.040171083 0.0 0.0 -18.068184 -1.5085113 0.0 0.0 -20.17203 1.8482443 0.0 0.0
   -1.4014037 0.020113587 0.0 0.0 -19.146906 -2.4987493 0.0 0.0 -1.2022418
   0.5859167 0.0 0.0 -1.2370337 -0.44995892 0.0 0.0 -20.462893 1.4672511 0.0 0.0
   -18.68101 -5.7787294 0.0 0.0 -1.2705985 -0.4283266 0.0 0.0 -17.932268
   7.4563355 0.0 0.0 -1.249622 -0.47479844 0.0 0.0 -1.1490242 -0.67166066 0.0
   0.0 -1.1065617 0.28279775 0.0 0.0 -1.0707645 -0.74775213 0.0 0.0 -15.846424
   -3.41556 0.0 0.0 -294.7025 -107.90726 0.0 0.0 -1.2356311 0.49732065 0.0 0.0
   -1.149899 -0.47287494 0.0 0.0 -0.5794842 -1.1883578 0.0 0.0 -1.3101604
   0.054327354 0.0 0.0 -20.894808 -4.7828755 0.0 0.0 -15.862062 -6.8312874 0.0
   0.0 -332.0152 -3.8504336 0.0 0.0 -388.9194 39.583717 0.0 0.0 -1.1828717
   0.5924634 0.0 0.0 -0.81114 -0.6007373 0.0 0.0 -1.165547 0.35612434 0.0 0.0
   -19.053288 1.395818 0.0 0.0 -1.3365855 -0.05442612 0.0 0.0 -1.3093033
   0.26173386 0.0 0.0 -1.7275529 0.15167774 0.0 0.0 -0.97819924 0.9130173 0.0
   0.0 -1.41261 0.26588213 0.0 0.0 -17.291954 0.17196096 0.0 0.0 -1.2729999
   0.010772608 0.0 0.0 -1.1942446 0.5256452 0.0 0.0 -492.66412 -151.28159 0.0
   0.0 -1.125848 -0.5618976 0.0 0.0 -1.2240415 0.53725016 0.0 0.0 -1.2878419
   0.35837346 0.0 0.0 -275.58255 154.93303 0.0 0.0 -1.2424921 -0.36840653 0.0
   0.0 -1.3371055 -0.061593886 0.0 0.0 -19.190287 -0.36273652 0.0 0.0 -1.0006934
   -0.24720965 0.0 0.0 -1.2275013 0.49278662 0.0 0.0 -1.2951903 0.26940677 0.0
   0.0 -313.10785 -117.834305 0.0 0.0 -23.609661 3.961214 0.0 0.0 -207.39302
   194.3608 0.0 0.0 -19.062052 7.3057265 0.0 0.0 -1.2982496 -0.78807294 0.0 0.0
   -389.56195 63.00791 0.0 0.0 -409.80426 160.91743 0.0 0.0 -14.003271 3.9231758
   0.0 0.0 -1.2904055 -0.23558445 0.0 0.0 -256.26816 -157.4275 0.0 0.0 -296.4982
   49.924084 0.0 0.0 -20.110233 -3.3343494 0.0 0.0 -21.120237 4.4452667 0.0 0.0
   -366.3066 149.52196 0.0 0.0 -18.254292 -9.192015 0.0 0.0 -228.4832 -170.7836
   0.0 0.0 -18.0068 -3.4717307 0.0 0.0 -1.2348684 -0.2992847 0.0 0.0 -1.3347136
   -0.016422726 0.0 0.0 -1.2903806 -0.24695961 0.0 0.0 -16.495401 -5.534605 0.0
   0.0 -1.2731378 -0.3948993 0.0 0.0 -1.3035823 -0.2657233 0.0 0.0 -301.71136
   12.254708 0.0 0.0 -1.317284 -0.22820866 0.0 0.0 -1.4691045 0.18304136 0.0 0.0
   -282.11365 47.74646 0.0 0.0 -21.293617 -3.7862089 0.0 0.0 -1.2026876
   0.30918422 0.0 0.0 -418.61923 210.7547 0.0 0.0 -1.2791088 -0.36123466 0.0 0.0
   -1.2439646 0.06797765 0.0 0.0 -21.628708 1.0166732 0.0 0.0 -22.787497
   -7.887458 0.0 0.0 -14.00722 -10.742202 0.0 0.0 -16.01594 -12.666508 0.0 0.0
   -288.44736 -306.72693 0.0 0.0 -16.167877 10.316764 0.0 0.0 -291.1093
   -133.67459 0.0 0.0 -19.587412 8.910902 0.0 0.0 -311.94183 -73.65787 0.0 0.0
   -37.642296 -12.050588 0.0 0.0 -285.74237 97.47153 0.0 0.0 -1.244526
   -0.3990412 0.0 0.0 -1.269324 0.10725807 0.0 0.0 -22.489853 -2.914877 0.0 0.0
   -17.06987 -3.5979395 0.0 0.0 -1.305526 -0.03452605 0.0 0.0 -17.297335
   9.598888 0.0 0.0 -287.9218 -3.725569 0.0 0.0 -1.0819209 -0.46275747 0.0 0.0
   -1.3054988 0.27762175 0.0 0.0 -1.2652707 -0.4230313 0.0 0.0 -1.3138673
   -0.22741018 0.0 0.0 -1.2361022 0.4447337 0.0 0.0 -17.277916 -13.158922 0.0
   0.0 -23.546282 5.816891 0.0 0.0 -339.23035 -27.058872 0.0 0.0 -282.8247
   -114.09314 0.0 0.0 -1.2461894 -0.05254802 0.0 0.0 -1.4594284 0.09547625 0.0
   0.0 -1.3110126 0.11763994 0.0 0.0 -302.57962 40.783066 0.0 0.0 -19.82268
   0.9025064 0.0 0.0 -1.3919339 0.24706973 0.0 0.0 -1.3156912 0.25059712 0.0 0.0
   -1.1190387 -0.4996588 0.0 0.0 -1.3253502 0.08398196 0.0 0.0 -1.274915
   -0.2692286 0.0 0.0 -0.9716193 -0.24893059 0.0 0.0 -31.645056 -4.5080624 0.0
   0.0 -37.041824 -14.581161 0.0 0.0 -18.270706 7.457491 0.0 0.0 -1.241481
   -0.4994059 0.0 0.0 -0.49249437 -1.1127087 0.0 0.0 -1.3207186 0.16098858 0.0
   0.0 -250.9215 -145.57045 0.0 0.0 -1.1193136 0.28285766 0.0 0.0 -289.79974
   -16.149044 0.0 0.0 -357.96548 -53.637356 0.0 0.0 -1.0332415 -0.97832936 0.0
   0.0 -288.97244 -103.52703 0.0 0.0 -1.2537893 -0.16077565 0.0 0.0 -0.99130446
   -0.78374124 0.0 0.0 -415.61096 -101.24591 0.0 0.0 -1.1401778 0.6537032 0.0
   0.0 -1.2079648 0.58312166 0.0 0.0 -19.332014 -3.7937045 0.0 0.0 -19.316866
   2.2865021 0.0 0.0 -16.480833 6.0303273 0.0 0.0 -1.3314079 0.15109302 0.0 0.0
   -22.66838 -1.742232 0.0 0.0 -17.673609 10.631063 0.0 0.0 -325.13156 15.258141
   0.0 0.0 -18.887768 -6.1889033 0.0 0.0 -289.3973 35.805656 0.0 0.0 -1.175892
   -0.6370009 0.0 0.0 -21.201887 -5.43787 0.0 0.0 -1.1332469 -0.68792754 0.0 0.0
   -20.168982 1.9983888 0.0 0.0 -19.723314 3.007936 0.0 0.0 -345.4709 -170.1953
   0.0 0.0 -39.453556 -7.3700094 0.0 0.0 -15.587483 -10.1256695 0.0 0.0
   -633.77167 24.37236 0.0 0.0 -1.3138908 0.06387155 0.0 0.0 -292.29376
   -10.492502 0.0 0.0 -1.097153 0.7050527 0.0 0.0 -290.86295 6.7056184 0.0 0.0
   -20.364664 3.7298055 0.0 0.0 -288.74707 -48.558872 0.0 0.0 -18.566835
   -0.53224564 0.0 0.0 -1.3462343 0.21190663 0.0 0.0 -18.287273 4.38627 0.0 0.0
   -1.2706329 -0.07694576 0.0 0.0 -15.269196 9.588625 0.0 0.0 -1.1168867
   -0.56822896 0.0 0.0 -22.028051 -0.65311104 0.0 0.0 -1.250623 0.36520877 0.0
   0.0 -30.561697 -0.15496612 0.0 0.0 -19.03108 5.758312 0.0 0.0 -293.67828
   1.408065 0.0 0.0 -17.488516 -2.3172677 0.0 0.0 -18.941425 6.46078 0.0 0.0
   -1.1490164 0.6181502 0.0 0.0 -1.2499402 -0.4045049 0.0 0.0 -1.2027538
   -0.55797434 0.0 0.0 -1.2370163 0.46561593 0.0 0.0 -1.3054283 -0.45846123 0.0
   0.0 -19.503119 2.8388963 0.0 0.0 -1.4877025 -0.33520418 0.0 0.0 -392.79248
   185.53758 0.0 0.0 -11.029114 -17.677637 0.0 0.0 -19.750935 -1.61172 0.0 0.0
   -1.3304031 -0.551085 0.0 0.0 -1.401055 0.07525445 0.0 0.0 -248.5478
   -146.35143 0.0 0.0 -1.462383 0.033759702 0.0 0.0 -18.742052 1.798346 0.0 0.0
   -1.4148265 -0.40471256 0.0 0.0 -1.4387184 -0.3502124 0.0 0.0 -5158.4766
   -1008.4873 0.0 0.0 -275.64587 -84.93586 0.0 0.0 -1.2888242 0.15677872 0.0 0.0
   -1.2481763 0.41204628 0.0 0.0 -1.3187566 -0.48563778 0.0 0.0 -1.4192681
   -0.084517725 0.0 0.0 -1.3502843 -0.36567345 0.0 0.0 -247.94217 147.3751 0.0
   0.0 -18.255848 7.925075 0.0 0.0 -22.014818 -13.722427 0.0 0.0 -1.254387
   -0.46161875 0.0 0.0 -274.92175 87.25118 0.0 0.0 -343.37427 80.35727 0.0 0.0
   -253.94344 136.7753 0.0 0.0 -5822.283 -3826.3015 0.0 0.0 -263.31775
   -172.47847 0.0 0.0 -0.9336168 -1.0422404 0.0 0.0 -21.66194 2.634724 0.0 0.0
   -17.101053 -7.8168483 0.0 0.0 -1.4000981 -0.45246777 0.0 0.0 -1.284374
   -0.5393073 0.0 0.0 -22.365505 0.5543589 0.0 0.0 -260.49658 -123.83969 0.0 0.0
   -18.634747 -7.6237493 0.0 0.0 -18.331179 -12.562968 0.0 0.0 -1.8329899
   -0.15113306 0.0 0.0 -279.529 71.12161 0.0 0.0 -1.3510534 0.47685724 0.0 0.0
   -19.703827 -1.2491117 0.0 0.0 -18.172216 -11.101134 0.0 0.0 -19.551584
   3.9113126 0.0 0.0 -1.2671307 0.3461705 0.0 0.0 -36.365704 4.140851 0.0 0.0
   -5161.059 -1325.5057 0.0 0.0 -1.1784048 -0.77440995 0.0 0.0 -1.3236078
   -0.4519797 0.0 0.0 -288.2717 -9.704436 0.0 0.0 -17.726082 2.0327365 0.0 0.0
   -1.1879454 -0.64016515 0.0 0.0 -1.3736312 -0.22177067 0.0 0.0 -389.47736
   71.1287 0.0 0.0 -1.4393295 -0.26567626 0.0 0.0 -1.4805455 -0.16570383 0.0 0.0
   -17.790157 -10.855993 0.0 0.0 -1.4371796 0.19496611 0.0 0.0 -1.3899404
   -0.2715521 0.0 0.0 -16.521557 0.49697584 0.0 0.0 -0.7970659 -1.1064103 0.0
   0.0 -13.075929 -12.291047 0.0 0.0 -253.21399 -138.12103 0.0 0.0 -5889.8574
   -3222.073 0.0 0.0 -627.93335 22.045963 0.0 0.0 -1.4019794 -0.15548865 0.0 0.0
   -1.442696 0.22608441 0.0 0.0 -16.643763 13.0821085 0.0 0.0 -1.4805527
   0.14011897 0.0 0.0 -19.678783 -5.8430734 0.0 0.0 -1.3771425 -0.479621 0.0 0.0
   -1.3771038 -0.4402717 0.0 0.0 -1.5039098 -1.0287907 0.0 0.0 -284.37704
   48.21245 0.0 0.0 -272.37006 94.91737 0.0 0.0 -21.002728 -8.5924015 0.0 0.0
   -1.3648732 0.5090794 0.0 0.0 -21.15889 0.2343755 0.0 0.0 -0.9875954
   -0.9783445 0.0 0.0 -280.97525 -65.17399 0.0 0.0 -1.3618723 0.2676573 0.0 0.0
   -288.32068 8.119699 0.0 0.0 -1.3577844 0.37893945 0.0 0.0 -1.429588
   -0.3434204 0.0 0.0 -1.3193827 -0.18853919 0.0 0.0 -1.4345661 -0.033804096 0.0
   0.0 -22.312634 -3.6384008 0.0 0.0 -286.21048 -35.753475 0.0 0.0 -7980.1714
   -938.2229 0.0 0.0 -277.94702 77.07272 0.0 0.0 -21.50676 -6.613565 0.0 0.0
   -16.67909 10.926118 0.0 0.0 -221.1053 -185.22202 0.0 0.0 -288.0951 -13.998711
   0.0 0.0 -1.2818173 0.19897941 0.0 0.0 -1.4825007 0.064542085 0.0 0.0
   -1.3975236 0.4270131 0.0 0.0 -1.4389904 0.1766878 0.0 0.0 -329.39636
   -84.579796 0.0 0.0 -277.81937 -77.53147 0.0 0.0 -20.069021 -2.9106581 0.0 0.0
   -775.33386 -103.37716 0.0 0.0 -1.2442987 0.53278464 0.0 0.0 -20.394985
   10.037454 0.0 0.0 -1.444522 0.04166261 0.0 0.0 -4771.577 -524.0222 0.0 0.0
   -17.280825 -10.566818 0.0 0.0 -1.2574099 -0.7050433 0.0 0.0 -21.777964
   -2.3554566 0.0 0.0 -1.2356495 0.21548241 0.0 0.0 -21.085152 -8.663172 0.0 0.0
   -19.65155 -4.4091034 0.0 0.0 -18.76543 -3.2544713 0.0 0.0 -22.811333
   -1.4520628 0.0 0.0 -237.91663 251.37257 0.0 0.0 -270.3389 -100.55661 0.0 0.0
   -24.158205 -9.940245 0.0 0.0 -314.95837 73.36511 0.0 0.0 -1.3603889
   -0.17304565 0.0 0.0 -18.84535 4.0552363 0.0 0.0 -1.334342 0.048380226 0.0 0.0
   -1.0880805 0.3798263 0.0 0.0 -1.3971376 -0.30402815 0.0 0.0 -277.35364
   -79.18147 0.0 0.0 -19.951756 0.6368571 0.0 0.0 -1.449182 0.10169733 0.0 0.0
   -267.5902 -107.657936 0.0 0.0 -269.65582 102.37424 0.0 0.0 -8.042294
   -16.188313 0.0 0.0 -273.44135 91.7855 0.0 0.0 -21.71832 4.6842017 0.0 0.0
   -21.226744 -2.4675193 0.0 0.0 -21.697361 5.825635 0.0 0.0 -19.644413 4.619343
   0.0 0.0 -0.7334019 -1.1451794 0.0 0.0 -281.7954 61.53131 0.0 0.0 -14.874237
   -12.077401 0.0 0.0 -0.9329669 -1.151796 0.0 0.0 -18.047241 0.9368749 0.0 0.0
   -305.902 -36.353325 0.0 0.0 -1.5943403 0.9767131 0.0 0.0 -336.29828 -91.64322
   0.0 0.0 -1.3763252 0.20598516 0.0 0.0 -19.664646 11.523346 0.0 0.0 -285.69437
   157.34969 0.0 0.0 -15.81765 8.731929 0.0 0.0 -1.3281671 0.49926496 0.0 0.0
   -1.4036442 0.46533838 0.0 0.0 -315.3493 101.56 0.0 0.0 -24.407469 -5.9660864
   0.0 0.0 -16.559156 -7.215422 0.0 0.0 -21.117502 3.858282 0.0 0.0 -261.06323
   -122.64067 0.0 0.0 -2.0585308 -0.10849112 0.0 0.0 -1.357187 0.5657904 0.0 0.0
   -21.111393 2.001181 0.0 0.0 -15.680195 9.090166 0.0 0.0 -280.3891 -67.65128
   0.0 0.0 -231.79108 -205.22682 0.0 0.0 -1.4054059 0.40869236 0.0 0.0
   -1.4577763 0.26923835 0.0 0.0 -273.4957 -78.16707 0.0 0.0 -259.99557
   -124.88817 0.0 0.0 -23.938368 0.15668568 0.0 0.0 -22.455576 3.387073 0.0 0.0
   -417.17233 -249.07721 0.0 0.0 -1.2748408 0.46798477 0.0 0.0 -1.250745
   -0.7598108 0.0 0.0 -1.3808352 0.3506282 0.0 0.0 -20.286129 -3.6711938 0.0 0.0
   -1.2176119 -1.0092262 0.0 0.0 -1.2449504 -0.64643425 0.0 0.0 -20.678146
   -1.8386337 0.0 0.0 -18.842724 -8.4349575 0.0 0.0 -18.552042 -5.174384 0.0 0.0
   -1.1227111 -0.69558066 0.0 0.0 -1.3328912 -0.6282941 0.0 0.0 -23.81939
   1.9792708 0.0 0.0 -1.3424464 -0.1455923 0.0 0.0 -21.787512 6.45737 0.0 0.0
   -1.2882702 -0.8418736 0.0 0.0 -1.1288251 -0.1881224 0.0 0.0 -1.2334049
   -0.75350714 0.0 0.0 -249.72643 -144.33107 0.0 0.0 -1.422597 -0.32975304 0.0
   0.0 -21.368347 -3.0641751 0.0 0.0 -0.8480089 0.6739487 0.0 0.0 -22.293694
   -1.3985695 0.0 0.0 -286.04797 37.030987 0.0 0.0 -1.2228838 -0.5393633 0.0 0.0
   -19.024487 2.9359121 0.0 0.0 -1.4237124 -0.19502683 0.0 0.0 -21.43515
   -0.23939002 0.0 0.0 -21.627573 -6.4429026 0.0 0.0 -1.4103533 0.10108121 0.0
   0.0 -288.35147 6.9405026 0.0 0.0 -17.319086 -5.6826897 0.0 0.0 -15.736751
   4.062039 0.0 0.0 -1.3569275 -0.7162814 0.0 0.0 -372.4294 -24.096651 0.0 0.0
   -311.01404 30.665056 0.0 0.0 -0.5821084 -0.60452044 0.0 0.0 -5281.1953
   -2091.0586 0.0 0.0 -1.3480048 0.48832783 0.0 0.0 -20.486658 10.059178 0.0 0.0
   -17.06432 -10.7627735 0.0 0.0 -16.653376 -8.970132 0.0 0.0 -1.4327939
   -0.37669766 0.0 0.0 -326.77594 -140.23726 0.0 0.0 -19.92339 5.2734356 0.0 0.0
   -853.5216 87.69511 0.0 0.0 -229.50148 168.79433 0.0 0.0 -1.483123 0.06013263
   0.0 0.0 -21.288252 3.8998382 0.0 0.0 -340.90738 -104.108055 0.0 0.0
   -1.4858682 0.12540542 0.0 0.0 -314.2079 -11.000303 0.0 0.0 -24.396648
   4.2049336 0.0 0.0 -17.632853 -4.965448 0.0 0.0 -1.1144205 0.5897112 0.0 0.0
   -332.64432 -14.513403 0.0 0.0 -278.29965 -75.78947 0.0 0.0 -241.63618
   -157.50142 0.0 0.0 -18.734272 -11.345274 0.0 0.0 -1.4021047 0.3887846 0.0 0.0
   -279.93466 -69.50772 0.0 0.0 -1.2468165 -0.481827 0.0 0.0 -7417.1177 799.097
   0.0 0.0 -729.4978 120.74893 0.0 0.0 -18.806948 -3.9945414 0.0 0.0 -322.5189
   86.841995 0.0 0.0 -1.4643394 0.029252548 0.0 0.0 -0.5994802 -0.8044172 0.0
   0.0 -324.43677 133.27974 0.0 0.0 -21.440195 11.315697 0.0 0.0 -22.812698
   3.596619 0.0 0.0 -1.4092743 -0.33497104 0.0 0.0 -1.4004934 -0.50424343 0.0
   0.0 -200.74619 -207.1128 0.0 0.0 -1.2463043 0.7588723 0.0 0.0 -1.329876
   -0.12974197 0.0 0.0 -22.513306 1.5284109 0.0 0.0 -258.26785 -128.42297 0.0
   0.0 -1.4051926 -0.2495931 0.0 0.0 -1.4749742 0.17661916 0.0 0.0 -20.659298
   -1.2259905 0.0 0.0 -1.3897015 -0.05273016 0.0 0.0 -1.4453723 0.3304505 0.0
   0.0 -267.3297 108.303085 0.0 0.0 -1.4874414 -0.07893552 0.0 0.0 -287.91776
   -237.33594 0.0 0.0 -1.0996654 -0.8622031 0.0 0.0 -261.6084 121.473366 0.0 0.0
   -1.4394084 -0.58747 0.0 0.0 -14.793762 -11.134516 0.0 0.0 -1.396974 0.2323034
   0.0 0.0 -1.2892492 0.2537657 0.0 0.0 -272.84894 93.53188 0.0 0.0 -1.4107946
   -0.39105225 0.0 0.0 -325.31705 -153.95274 0.0 0.0 -1.4490005 0.12741795 0.0
   0.0 -1.1740768 -0.4635798 0.0 0.0 -20.394945 -0.5009339 0.0 0.0 -23.778227
   -5.1609883 0.0 0.0 -1.3193916 0.08739894 0.0 0.0 -17.57875 -11.02408 0.0 0.0
   -19.718964 -6.4465885 0.0 0.0 -17.84604 3.984193 0.0 0.0 -1.2671506
   0.23420338 0.0 0.0 -391.9376 70.020775 0.0 0.0 -1.3145348 -0.24644464 0.0 0.0
   -1.3301401 -0.039468702 0.0 0.0 -21.164192 -7.619584 0.0 0.0 -1.2593769
   -0.3595261 0.0 0.0 -588.5074 -100.13427 0.0 0.0 -19.992664 4.668666 0.0 0.0
   -19.818653 -3.333281 0.0 0.0 -1.3347114 -0.03432095 0.0 0.0 -1.1561158
   -0.58574957 0.0 0.0 -0.82793087 -0.80472815 0.0 0.0 -1.3196336 -0.182932 0.0
   0.0 -397.9533 -35.670753 0.0 0.0 -1.2562317 -0.44479826 0.0 0.0 -0.8156183
   -0.99562013 0.0 0.0 -18.96117 2.9159083 0.0 0.0 -608.6871 -370.52118 0.0 0.0
   -19.274374 -7.107513 0.0 0.0 -367.66608 -86.87694 0.0 0.0 -20.439129
   2.0544064 0.0 0.0 -21.515364 2.7667007 0.0 0.0 -1.2870575 -0.2619468 0.0 0.0
   -19.204432 -6.780327 0.0 0.0 -1.3394129 -0.0598148 0.0 0.0 -17.279621
   -8.67472 0.0 0.0 -1.1411158 -0.33929288 0.0 0.0 -1.2653029 -0.33854064 0.0
   0.0 -1.2760491 -0.17199454 0.0 0.0 -1.1584408 0.63688374 0.0 0.0 -0.8530535
   -0.9745541 0.0 0.0 -1.3874482 -0.07242282 0.0 0.0 -1.2442107 -0.45407343 0.0
   0.0 -1.4579744 -0.35666966 0.0 0.0 -1.2781149 0.06392528 0.0 0.0 -528.69226
   -94.66718 0.0 0.0 -1.3842685 0.43611744 0.0 0.0 -18.21784 -2.1255744 0.0 0.0
   -1.2889495 -0.24461995 0.0 0.0 -17.881687 -10.07813 0.0 0.0 -15.253535
   -10.224366 0.0 0.0 -1.3053825 0.28926203 0.0 0.0 -1.2678704 0.24054073 0.0
   0.0 -20.359802 -1.9140313 0.0 0.0 -1.1838286 -0.61718595 0.0 0.0 -1.1283658
   0.71636176 0.0 0.0 -2.4828095 0.36462906 0.0 0.0 -18.828848 -4.937431 0.0 0.0
   -24.4734 -1.8762347 0.0 0.0 -20.87312 6.384336 0.0 0.0 -304.91043 111.67078
   0.0 0.0 -1.2625624 0.43094033 0.0 0.0 -25.919321 2.0791507 0.0 0.0 -1.2763765
   -0.20452528 0.0 0.0 -20.345085 8.046766 0.0 0.0 -305.69586 -96.92658 0.0 0.0
   -33.540283 9.1387205 0.0 0.0 -1.2810594 -0.3920911 0.0 0.0 -329.36957
   -84.87933 0.0 0.0 -17.69255 12.329175 0.0 0.0 -1.2890246 -0.20077118 0.0 0.0
   -19.203894 -3.542772 0.0 0.0 -17.63237 -10.836531 0.0 0.0 -1.2857323
   0.18532072 0.0 0.0 -293.87198 -130.26027 0.0 0.0 -17.541006 3.1994102 0.0 0.0
   -1.2025099 -0.56609774 0.0 0.0 -13.548486 8.135089 0.0 0.0 -18.918402
   4.9387836 0.0 0.0 -51.36279 2.2159138 0.0 0.0 -1.1889002 0.25220498 0.0 0.0
   -0.9698185 -0.72709465 0.0 0.0 -1.2565795 -0.42701045 0.0 0.0 -1.2979043
   -0.006595283 0.0 0.0 -1.2868868 0.28708175 0.0 0.0 -28.506783 -1.6832854 0.0
   0.0 -1.2739507 -0.22311775 0.0 0.0 -362.32285 -5.080819 0.0 0.0 -340.92645
   -123.066216 0.0 0.0 -1.1893483 0.27451897 0.0 0.0 -1.0737509 0.2338757 0.0
   0.0 -11.991434 16.332077 0.0 0.0 -20.561735 -2.3741024 0.0 0.0 -1.2788001
   -0.40449315 0.0 0.0 -17.961168 4.404919 0.0 0.0 -19.703907 -6.502081 0.0 0.0
   -1.311944 0.1579813 0.0 0.0 -688.1042 -356.9686 0.0 0.0 -17.22121 -2.6094718
   0.0 0.0 -1.165697 -0.51272064 0.0 0.0 -330.6309 -151.42891 0.0 0.0 -19.322187
   -8.237322 0.0 0.0 -13.183509 -12.19968 0.0 0.0 -52.421318 -16.852411 0.0 0.0
   -320.08347 49.999218 0.0 0.0 -0.87438387 0.9830294 0.0 0.0 -19.31368
   -0.11292856 0.0 0.0 -19.856012 -6.8980336 0.0 0.0 -18.173616 10.563376 0.0
   0.0 -1.309055 0.20319968 0.0 0.0 -1.1806066 -0.63688827 0.0 0.0 -31.19816
   -11.0963745 0.0 0.0 -18.943634 7.8708405 0.0 0.0 -18.43986 -0.868028 0.0 0.0
   -22.121819 -7.571287 0.0 0.0 -0.970965 -0.8555325 0.0 0.0 -1.4150195
   -0.1743356 0.0 0.0 -1.191579 0.5216244 0.0 0.0 -342.37585 40.081284 0.0 0.0
   -1.456423 -0.04012966 0.0 0.0 -18.514267 -1.1690358 0.0 0.0 -1.0164635
   -0.59349924 0.0 0.0 -1.0702295 -0.7863464 0.0 0.0 -341.01416 -230.09106 0.0
   0.0 -1.1835895 -0.23640022 0.0 0.0 -404.7291 74.98891 0.0 0.0 -19.531712
   -7.913432 0.0 0.0 -0.8796496 -0.6520598 0.0 0.0 -1.3250122 -0.1352713 0.0 0.0
   -19.597292 2.122197 0.0 0.0 -410.4131 38.497074 0.0 0.0 -313.70978 -145.74147
   0.0 0.0 -1.2224993 0.41404966 0.0 0.0 -20.329094 -4.6598864 0.0 0.0
   -18.260511 -10.271614 0.0 0.0 -0.96958494 -0.5265719 0.0 0.0 -1.3080846
   -0.16463813 0.0 0.0 -1.0526177 -0.7556144 0.0 0.0 -0.56069964 -0.1581579 0.0
   0.0 -1.2597766 -0.32613942 0.0 0.0 -1.2497554 0.27161175 0.0 0.0 -0.55400527
   -0.83175695 0.0 0.0 -1.2537353 0.3868023 0.0 0.0 -461.62958 -174.08078 0.0
   0.0 -17.133234 -8.360668 0.0 0.0 -34.937107 13.118785 0.0 0.0 -509.78665
   -165.95866 0.0 0.0 -1.2800997 0.11847664 0.0 0.0 -1.4834098 -0.4085573 0.0
   0.0 -1.3817459 0.16174506 0.0 0.0 -19.82814 -5.8514843 0.0 0.0 -1.1857336
   -0.6207931 0.0 0.0 -1.2175918 0.3875558 0.0 0.0 -1.1130396 -0.06700966 0.0
   0.0 -18.766468 9.747796 0.0 0.0 -20.261244 6.042892 0.0 0.0 -1.200335
   0.567035 0.0 0.0 -0.91024745 0.44916967 0.0 0.0 -1.167391 -0.5952851 0.0 0.0
   -1.2443787 -0.48301035 0.0 0.0 -319.13715 -78.67053 0.0 0.0 -369.4101
   16.829542 0.0 0.0 -298.63974 -137.70726 0.0 0.0 -326.98285 -121.61514 0.0 0.0
   -1.3357632 0.33400133 0.0 0.0 -18.646633 -0.77886707 0.0 0.0 -17.07916
   9.881104 0.0 0.0 -1.2858878 0.06455577 0.0 0.0 -20.143167 6.3880568 0.0 0.0
   -32.985977 -1.2777671 0.0 0.0 -18.654516 -0.85335004 0.0 0.0 -1.1541256
   0.4193322 0.0 0.0 -1.27038 0.057613086 0.0 0.0 -1.2153871 0.548532 0.0 0.0
   -1.325313 -0.10680452 0.0 0.0 -1.2241976 -0.5372659 0.0 0.0 -24.6728
   -4.265671 0.0 0.0 -23.287012 12.716077 0.0 0.0 -529.02325 -5.504191 0.0 0.0
   -19.822918 0.19719493 0.0 0.0 -1.3164936 -0.0968294 0.0 0.0 -18.330822
   -10.683203 0.0 0.0 -28.852913 -1.1703175 0.0 0.0 -1.3040297 -0.13814062 0.0
   0.0 -1.3958312 0.108443424 0.0 0.0 -366.0841 -203.44637 0.0 0.0 -24.606173
   4.7981453 0.0 0.0 -0.85783255 -1.1118585 0.0 0.0 -1.023621 -0.86368877 0.0
   0.0 -1.2893094 -0.29253992 0.0 0.0 -0.89330065 -0.96399903 0.0 0.0 -21.82207
   3.8980963 0.0 0.0 -1.217093 0.26290452 0.0 0.0 -1.1370592 -1.2591708 0.0 0.0
   -1.3335235 -0.114962816 0.0 0.0 -1.2132747 -0.21297601 0.0 0.0 -1.33347
   0.029656706 0.0 0.0 -1.192097 -0.5910181 0.0 0.0 -1.2841244 0.09056194 0.0
   0.0 -1.0044161 -0.7827726 0.0 0.0 -1.0983595 0.731578 0.0 0.0 -17.477755
   -12.109995 0.0 0.0 -1.3214128 -0.03206899 0.0 0.0 -19.914688 6.8205013 0.0
   0.0 -1.3266748 0.08272822 0.0 0.0 -586.70966 -335.80002 0.0 0.0 -21.897781
   -4.542743 0.0 0.0 -1.2941813 -0.32699078 0.0 0.0 -447.27774 -2.940062 0.0 0.0
   -1.2706094 -0.29905486 0.0 0.0 -20.012018 7.241438 0.0 0.0 -1.3251635
   -0.19687228 0.0 0.0 -1.5421264 0.7093053 0.0 0.0 -14.352562 -15.330961 0.0
   0.0 -20.923658 2.7699482 0.0 0.0 -561.4427 -20.114704 0.0 0.0 -1.1282877
   -0.70346564 0.0 0.0 -19.55949 -3.4569666 0.0 0.0 -18.754442 0.25288698 0.0
   0.0 -441.44977 80.56146 0.0 0.0 -1.2758279 0.2681524 0.0 0.0 -19.930809
   -7.567508 0.0 0.0 -16.719547 11.641895 0.0 0.0 -1.2970335 0.22733818 0.0 0.0
   -18.610455 -7.1089344 0.0 0.0 -1.1561292 0.15036008 0.0 0.0 -1.0503224
   0.7788668 0.0 0.0 -1.3310574 -0.12426176 0.0 0.0 -1.1647873 -0.4061272 0.0
   0.0 -1.2703779 0.016077382 0.0 0.0 -16.643972 8.781504 0.0 0.0 -25.15119
   1.548462 0.0 0.0 -17.176645 -14.47517 0.0 0.0 -21.017052 -3.7397919 0.0 0.0
   -1.303286 0.30547976 0.0 0.0 -20.261412 -4.467122 0.0 0.0 -614.14264
   -193.73901 0.0 0.0 -1.3026328 -0.28112724 0.0 0.0 -20.967045 3.1037009 0.0
   0.0 -1.1202573 -0.39516437 0.0 0.0 -1.1581982 -0.6640205 0.0 0.0 -0.8878936
   -0.55460405 0.0 0.0 -768.0967 69.1696 0.0 0.0 -1.215168 -0.03335828 0.0 0.0
   -1.2687644 -0.20493151 0.0 0.0 -21.242393 -0.9095717 0.0 0.0 -1.8187965
   -0.7013337 0.0 0.0 -19.096224 -6.9622974 0.0 0.0 -535.57874 -206.7866 0.0 0.0
   -14.629506 13.651329 0.0 0.0 -21.242077 -2.6910653 0.0 0.0 -1.2941891
   0.34519848 0.0 0.0 -1.3003606 0.013993631 0.0 0.0 -412.45898 110.74586 0.0
   0.0 -19.422998 -6.3098006 0.0 0.0 -24.779829 -5.3031583 0.0 0.0 -1.3029783
   -0.27523816 0.0 0.0 -20.386978 -6.2138166 0.0 0.0 -1.1465682 -0.5258423 0.0
   0.0 -21.974293 9.415824 0.0 0.0 -1.1604643 0.34331983 0.0 0.0 -1.1747955
   -0.4044927 0.0 0.0 -404.05704 -141.65135 0.0 0.0 -1.2618406 0.44913715 0.0
   0.0 -17.988003 -5.78194 0.0 0.0 -0.8828628 -0.71227676 0.0 0.0 -1.1802641
   -0.51305646 0.0 0.0 -1.1927375 -0.33532408 0.0 0.0 -1.3108481 -0.18915045 0.0
   0.0 -1.2818305 -0.37044787 0.0 0.0 -19.931128 2.1012633 0.0 0.0 -1.3019786
   0.34292892 0.0 0.0 -0.86901534 -1.0024433 0.0 0.0 -1.1365876 -2.4022162e-4
   0.0 0.0 -1.283758 0.10198644 0.0 0.0 -21.088411 3.0458863 0.0 0.0 -15.235943
   13.0742235 0.0 0.0 -501.58423 215.60449 0.0 0.0 -1.4351108 -0.128638 0.0 0.0
   -1.286721 -0.14134227 0.0 0.0 -1.3489429 -0.47161818 0.0 0.0 -1.172779
   0.65083396 0.0 0.0 -25.061934 16.98463 0.0 0.0 -1.4038471 0.048929714 0.0 0.0
   -1.286006 -0.36325258 0.0 0.0 -1.238599 -0.43410575 0.0 0.0 -21.318615
   -2.8398654 0.0 0.0 -20.164587 6.993674 0.0 0.0 -326.80338 -92.42204 0.0 0.0
   -1.3093668 -0.2316922 0.0 0.0 -1.0615562 -0.60004723 0.0 0.0 -1.2519556
   0.43076473 0.0 0.0 -1.2167975 -0.54882985 0.0 0.0 -1.3179121 -0.07422105 0.0
   0.0 -1.1600734 0.55984426 0.0 0.0 -21.150099 0.4611797 0.0 0.0 -1.290672
   0.0361636 0.0 0.0 -1.6105627 -0.6943104 0.0 0.0 -25.103851 4.6503963 0.0 0.0
   -1.2961252 0.32565567 0.0 0.0 -1.2693583 -0.40097448 0.0 0.0 -1.0880649
   -0.7759096 0.0 0.0 -19.538315 3.8260498 0.0 0.0 -21.176136 -1.6955643 0.0 0.0
   -18.876598 2.1291764 0.0 0.0 -17.234003 12.649872 0.0 0.0 -1.3292271
   -0.18116128 0.0 0.0 -19.307331 -5.8216496 0.0 0.0 -1.3398027 0.0039077885 0.0
   0.0 -1.1491053 0.51702744 0.0 0.0 -20.349525 -0.090794034 0.0 0.0 -19.2629
   5.700253 0.0 0.0 -1.3126895 0.22893372 0.0 0.0 -16.627127 -13.714941 0.0 0.0
   -1.3069103 0.041713655 0.0 0.0 -1.3002257 0.11200348 0.0 0.0 -799.2314
   510.57632 0.0 0.0 -338.0204 -185.84521 0.0 0.0 -24.801662 9.627496 0.0 0.0
   -25.293922 -1.1347615 0.0 0.0 -1.1992881 -0.58425707 0.0 0.0 -1.3064605
   -0.28733826 0.0 0.0 -20.201536 0.4371439 0.0 0.0 -1.3314312 -0.11350265 0.0
   0.0 -451.74997 -100.33474 0.0 0.0 -30.01724 -6.2246213 0.0 0.0 -0.90908176
   -0.95694923 0.0 0.0 -1.1901349 -0.40675557 0.0 0.0 -1.090873 0.76308733 0.0
   0.0 -1.5805886 0.09386315 0.0 0.0 -425.0745 -13.246573 0.0 0.0 -1.2708517
   -0.09823779 0.0 0.0 -1.3356228 -0.06014632 0.0 0.0 -21.440342 -2.7712758 0.0
   0.0 -15.417496 15.188097 0.0 0.0 -21.287148 3.8890038 0.0 0.0 -18.738989
   3.5513346 0.0 0.0 -12.907187 -14.76349 0.0 0.0 -1.1623499 0.45596775 0.0 0.0
   -21.522398 -0.5865866 0.0 0.0 -388.0567 7.223175 0.0 0.0 -491.82178 45.286453
   0.0 0.0 -20.840887 -5.914647 0.0 0.0 -1.7601959 -0.8879356 0.0 0.0 -17.103361
   -11.282608 0.0 0.0 -376.4066 -80.40099 0.0 0.0 -18.948803 -1.7110898 0.0 0.0
   -1.0155991 -0.08027047 0.0 0.0 -17.46212 -6.3663454 0.0 0.0 -1.1985128
   0.51439536 0.0 0.0 -17.235146 4.7329216 0.0 0.0 -336.75925 -239.85683 0.0 0.0
   -21.271772 -3.054176 0.0 0.0 -1.3065345 0.10987022 0.0 0.0 -348.34708
   -114.83053 0.0 0.0 -1.3219914 0.20246409 0.0 0.0 -18.567797 0.33167365 0.0
   0.0 -1.1014962 0.7266117 0.0 0.0 -46.852882 -1.50371 0.0 0.0 -2.3645332
   -0.30548802 0.0 0.0 -1.3592407 -0.35445905 0.0 0.0 -390.18665 9.681767 0.0
   0.0 -585.62476 -108.80819 0.0 0.0 -23.27227 -11.100444 0.0 0.0 -24.524845
   5.1738234 0.0 0.0 -18.43437 -5.155493 0.0 0.0 -19.83329 -8.661041 0.0 0.0
   -1.2276837 -0.51420027 0.0 0.0 -19.857546 4.2846336 0.0 0.0 -25.61397
   3.484992 0.0 0.0 -409.05457 44.822052 0.0 0.0 -1.3301004 -0.008662227 0.0 0.0
   -1.2636938 0.4496597 0.0 0.0 -19.655966 11.278883 0.0 0.0 -390.49335 30.22718
   0.0 0.0 -31.071016 -10.842263 0.0 0.0 -1.305755 0.30150294 0.0 0.0 -1.2987194
   0.6767145 0.0 0.0 -1.2602857 0.35754284 0.0 0.0 -1.2820406 0.02746154 0.0 0.0
   -315.13858 146.64417 0.0 0.0 -1.1941104 0.37990406 0.0 0.0 -529.3321
   -195.51207 0.0 0.0 -1.3099265 0.16321321 0.0 0.0 -20.34956 2.1553855 0.0 0.0
   -1.0162617 -0.6299828 0.0 0.0 -1.1428419 -0.69576705 0.0 0.0 -0.8726277
   -0.11179916 0.0 0.0 -1.2519282 -0.0123089785 0.0 0.0 -1.1966585 -0.5653026
   0.0 0.0 -438.31903 -174.3093 0.0 0.0 -1.1741534 -0.5694498 0.0 0.0 -22.640322
   -3.9350083 0.0 0.0 -1.2103072 -0.23644216 0.0 0.0 -1.3020117 0.106117755 0.0
   0.0 -33.663216 10.689999 0.0 0.0 -269.6966 -250.15352 0.0 0.0 -1.2492217
   0.20368661 0.0 0.0 -1.3032602 -0.22684516 0.0 0.0 -19.058706 -1.3532832 0.0
   0.0 -19.388918 9.672945 0.0 0.0 -19.06334 2.3606532 0.0 0.0 -1.0476134
   0.76264 0.0 0.0 -1.3224068 0.20860015 0.0 0.0 -19.096527 -1.7236263 0.0 0.0
   -34.135956 8.433626 0.0 0.0 -343.17307 142.9251 0.0 0.0 -19.109278 9.740631
   0.0 0.0 -20.105162 -2.9058228 0.0 0.0 -1.257658 -0.45366883 0.0 0.0
   -20.486452 -10.555952 0.0 0.0 -21.753942 0.7414863 0.0 0.0 -1.29981
   -0.0806771 0.0 0.0 -1.2744875 -0.2713238 0.0 0.0 -20.028046 2.896288 0.0 0.0
   -1.325485 -0.4145788 0.0 0.0 -16.902308 -15.655712 0.0 0.0 -1.2940748
   0.19225724 0.0 0.0 -18.833538 11.007218 0.0 0.0 -38.843407 -5.7812986 0.0 0.0
   -50.390713 5.759711 0.0 0.0 -1.3906652 -0.02707978 0.0 0.0 -0.5071551
   -0.16786781 0.0 0.0 -1.3133965 -0.27153298 0.0 0.0 -19.001974 3.2605858 0.0
   0.0 -1.2687978 -0.29502153 0.0 0.0 -1.3225061 -0.18217692 0.0 0.0 -1.4622412
   -0.009543866 0.0 0.0 -30.349144 -7.638379 0.0 0.0 -1.2852366 -0.27619714 0.0
   0.0 -374.04578 -1.20493 0.0 0.0 -20.4917 -0.34459224 0.0 0.0 -1.0560611
   0.22401461 0.0 0.0 -1.3072524 -1.0268313 0.0 0.0 -1.3348856 0.07267105 0.0
   0.0 -21.578873 3.504974 0.0 0.0 -21.413286 -3.65046 0.0 0.0 -1.2220643
   -0.45313647 0.0 0.0 -1.2170346 0.43350628 0.0 0.0 -20.175041 -8.317879 0.0
   0.0 -1.2414746 -0.19837435 0.0 0.0 -20.21631 -8.168968 0.0 0.0 -0.9357267
   -0.66950727 0.0 0.0 -352.91754 -185.92085 0.0 0.0 -340.30847 -158.46321 0.0
   0.0 -17.92763 -12.599131 0.0 0.0 -1.276161 -0.19072895 0.0 0.0 -1.0829333
   -0.77969813 0.0 0.0 -1.2994813 0.0698525 0.0 0.0 -1.1725625 -0.36469126 0.0
   0.0 -1.2597966 -0.45785677 0.0 0.0 -357.22052 -117.56012 0.0 0.0 -269.9979
   -261.9169 0.0 0.0 -542.4058 -18.988049 0.0 0.0 -1.2435949 0.12878418 0.0 0.0
   -337.1801 -108.31311 0.0 0.0 -1.0604885 -0.7978203 0.0 0.0 -1.3293701
   0.17879246 0.0 0.0 -1.0794445 -0.7967385 0.0 0.0 -18.106348 -9.715334 0.0 0.0
   -1.5199435 -0.08478255 0.0 0.0 -1.2921568 0.33678648 0.0 0.0 -22.96492
   1.5600154 0.0 0.0 -19.217178 2.4551108 0.0 0.0 -25.15467 7.3865495 0.0 0.0
   -1.1997454 -0.4005901 0.0 0.0 -394.34274 224.03653 0.0 0.0 -0.896784 0.968067
   0.0 0.0 -294.06946 -186.11774 0.0 0.0 -29.662315 -0.6790224 0.0 0.0
   -401.17917 21.331078 0.0 0.0 -19.06753 -3.0755603 0.0 0.0 -352.22427
   -137.45016 0.0 0.0 -342.53522 160.30362 0.0 0.0 -1.2677413 0.11544752 0.0 0.0
   -434.9452 -273.72855 0.0 0.0 -19.479624 -9.913176 0.0 0.0 -1.3330474
   0.1307964 0.0 0.0 -1.1842241 0.19608757 0.0 0.0 -1.3200978 0.09840912 0.0 0.0
   -1.025835 -0.8530266 0.0 0.0 -351.59665 196.76544 0.0 0.0 -19.06222 7.5099845
   0.0 0.0 -1.277542 0.33341593 0.0 0.0 -1.2117853 -0.2536901 0.0 0.0 -19.631834
   -5.450765 0.0 0.0 -21.639458 -4.268953 0.0 0.0 -1.3249115 0.16158903 0.0 0.0
   -22.774027 -0.8372657 0.0 0.0 -1.2937914 0.18054618 0.0 0.0 -1.3233786
   -0.17237489 0.0 0.0 -1.2440994 -0.35404456 0.0 0.0 -18.524218 -11.843687 0.0
   0.0 -1.3247577 0.33187163 0.0 0.0 -515.35394 38.4918 0.0 0.0 -19.622484
   -9.884745 0.0 0.0 -376.51498 -54.33504 0.0 0.0 -20.345982 -8.315414 0.0 0.0
   -20.128868 -8.790469 0.0 0.0 -1.2809998 -0.28981134 0.0 0.0 -1.2158188
   -0.5630315 0.0 0.0 -0.9728167 -0.9154303 0.0 0.0 -1.2949507 -0.34532163 0.0
   0.0 -1.5408611 -0.053600296 0.0 0.0 -379.6332 -34.427097 0.0 0.0 -371.57523
   85.51276 0.0 0.0 -380.32596 -28.404533 0.0 0.0 -1.3214521 0.084690675 0.0 0.0
   -1.2104231 0.35374364 0.0 0.0 -354.29355 -57.39872 0.0 0.0 -1.1386967
   -0.4899867 0.0 0.0 -1.2966955 -0.083770424 0.0 0.0 -1.2774985 -0.2501273 0.0
   0.0 -1.2541102 -0.4613373 0.0 0.0 -19.399776 -1.0861408 0.0 0.0 -516.0737
   -63.641376 0.0 0.0 -17.489517 8.311097 0.0 0.0 -1.3329598 0.12661885 0.0 0.0
   -1.0655875 0.29280683 0.0 0.0 -1.2347276 -0.34613594 0.0 0.0 -1.1426302
   -0.4987211 0.0 0.0 -1.3252634 0.18565342 0.0 0.0 -20.7356 -6.3230066 0.0 0.0
   -1.3268615 0.09682155 0.0 0.0 -505.99417 125.62389 0.0 0.0 -1.2948527
   0.016529493 0.0 0.0 -20.214916 9.016091 0.0 0.0 -355.8739 -142.72055 0.0 0.0
   -22.607208 -2.2691972 0.0 0.0 -588.1954 -53.590004 0.0 0.0 -1.259126
   -0.142331 0.0 0.0 -1.3100125 -0.14722212 0.0 0.0 -404.81155 53.52267 0.0 0.0
   -383.4742 -20.278252 0.0 0.0 -23.928823 5.5346866 0.0 0.0 -496.98895
   162.99983 0.0 0.0 -21.910654 -0.49368545 0.0 0.0 -1.2833917 -0.38628003 0.0
   0.0 -29.265894 12.790837 0.0 0.0 -1.1290408 -0.7185087 0.0 0.0 -16.98531
   11.9772415 0.0 0.0 -1.6901336 -0.2524998 0.0 0.0 -20.66817 -2.2958953 0.0 0.0
   -1.2675854 0.05695321 0.0 0.0 -1.2628021 -0.022310093 0.0 0.0 -20.727396
   10.807552 0.0 0.0 -1.200681 -0.19413109 0.0 0.0 -1.3367685 0.11223351 0.0 0.0
   -1.2614074 -0.3357378 0.0 0.0 -521.47894 -62.238407 0.0 0.0 -1.1425561
   -0.18657134 0.0 0.0 -20.437489 8.743446 0.0 0.0 -22.227192 -13.469475 0.0 0.0
   -1.4474427 0.2902271 0.0 0.0 -20.077251 -9.556805 0.0 0.0 -1.103691 0.1739124
   0.0 0.0 -1.2969598 -0.32479814 0.0 0.0 -15.984544 11.285588 0.0 0.0
   -23.179642 -10.708315 0.0 0.0 -587.1118 -103.172714 0.0 0.0 -1.2859862
   -0.26301 0.0 0.0 -1.2364836 0.07326143 0.0 0.0 -1.2756013 -0.30988774 0.0 0.0
   -338.6968 -233.96817 0.0 0.0 -436.38174 -38.31392 0.0 0.0 -19.15561 -3.869795
   0.0 0.0 -1.3089622 0.09301244 0.0 0.0 -22.832777 10.336059 0.0 0.0 -1.3401047
   -0.06172408 0.0 0.0 -1.222088 0.54662037 0.0 0.0 -1.1847721 0.6108713 0.0 0.0
   -1.3111979 0.08823575 0.0 0.0 -519.5379 -98.079765 0.0 0.0 -363.2139
   31.755136 0.0 0.0 -363.62714 -27.8054 0.0 0.0 -1.3210337 -0.040837064 0.0 0.0
   -1.076778 -0.39385834 0.0 0.0 -1.3148861 -0.26225975 0.0 0.0 -22.005878
   3.092801 0.0 0.0 -1.2069262 0.0997726 0.0 0.0 -21.178764 -7.0160675 0.0 0.0
   -363.5551 50.976643 0.0 0.0 -23.33152 1.7309353 0.0 0.0 -1.286848 -0.36959845
   0.0 0.0 -1.2838885 -0.054297395 0.0 0.0 -781.0106 -248.52917 0.0 0.0
   -1.234215 -0.47682732 0.0 0.0 -611.43695 -188.28922 0.0 0.0 -1.2022926
   0.56706095 0.0 0.0 -407.3931 -76.12483 0.0 0.0 -31.354488 7.2408338 0.0 0.0
   -31.257458 -13.969703 0.0 0.0 -365.43497 25.10264 0.0 0.0 -1.2266723
   -0.26349896 0.0 0.0 -384.91428 -62.624134 0.0 0.0 -1.4781052 0.048146565 0.0
   0.0 -21.747206 3.1025264 0.0 0.0 -19.875889 -10.102438 0.0 0.0 -21.570301
   -5.5946555 0.0 0.0 -15.320719 12.76488 0.0 0.0 -1.262389 -0.44881344 0.0 0.0
   -1.241443 -0.23885846 0.0 0.0 -389.79028 -27.531944 0.0 0.0 -20.91237
   7.885268 0.0 0.0 -360.2471 -151.8885 0.0 0.0 -1.3282007 -0.16390446 0.0 0.0
   -1.271061 0.15084098 0.0 0.0 -23.08892 -7.9371443 0.0 0.0 -21.824177 4.521114
   0.0 0.0 -20.36098 2.456103 0.0 0.0 -20.983364 -0.047072016 0.0 0.0 -1.2503527
   0.14096045 0.0 0.0 -1.3039187 -0.30020034 0.0 0.0 -0.7583563 -0.39069423 0.0
   0.0 -1.2829674 -0.20769696 0.0 0.0 -1.1728936 0.5325143 0.0 0.0 -1.3311008
   0.045889813 0.0 0.0 -1.3605584 -0.46845797 0.0 0.0 -1.0807799 -0.7128606 0.0
   0.0 -1.277453 -0.10407144 0.0 0.0 -1.2606329 0.31599727 0.0 0.0 -1.204741
   0.29388562 0.0 0.0 -1.2238437 -0.5449538 0.0 0.0 -1.1591091 -0.5469947 0.0
   0.0 -1.0627161 -0.64841026 0.0 0.0 -1.2586578 -0.4411581 0.0 0.0 -1.2741627
   -0.4132246 0.0 0.0 -1.2621729 0.27210575 0.0 0.0 -1.1069063 0.09941221 0.0
   0.0 -16.84794 14.718282 0.0 0.0 -1.3388691 0.027663792 0.0 0.0 -1.1813315
   0.5883965 0.0 0.0 -14.384899 13.47246 0.0 0.0 -28.576746 -26.654072 0.0 0.0
   -445.1814 32.002266 0.0 0.0 -20.639807 -3.4243064 0.0 0.0 -1.0122383
   -0.85887647 0.0 0.0 -1.2633862 -0.058937643 0.0 0.0 -1.2802619 0.04566869 0.0
   0.0 -1.3051775 -0.07082266 0.0 0.0 -1.304605 -0.15745363 0.0 0.0 -21.135973
   14.04015 0.0 0.0 -1.3094242 -0.062325004 0.0 0.0 -26.092413 -0.052584283 0.0
   0.0 -15.585453 -16.12499 0.0 0.0 -1.2964147 -0.19453852 0.0 0.0 -367.20175
   -53.924114 0.0 0.0 -262.57996 -295.35263 0.0 0.0 -1.2252579 0.04082108 0.0
   0.0 -21.514835 -3.1282845 0.0 0.0 -418.9561 -228.42935 0.0 0.0 -0.8186594
   -0.6713773 0.0 0.0 -1.0949719 0.51671654 0.0 0.0 -22.267227 -3.283456 0.0 0.0
   -477.6464 -7.53674 0.0 0.0 -17.286594 -12.687484 0.0 0.0 -1.3086848
   -0.28818005 0.0 0.0 -25.316277 -7.637817 0.0 0.0 -19.806623 0.94017106 0.0
   0.0 -342.37973 -30.830074 0.0 0.0 -0.9907949 -0.903429 0.0 0.0 -19.004051
   5.6746173 0.0 0.0 -19.574879 3.198908 0.0 0.0 -1.1919503 0.5934916 0.0 0.0
   -1.2700399 -0.38349852 0.0 0.0 -22.526394 -0.5959256 0.0 0.0 -23.929865
   -0.57551277 0.0 0.0 -1.3999611 -0.13665882 0.0 0.0 -22.189394 0.25909078 0.0
   0.0 -1.277269 0.22431566 0.0 0.0 -1.04595 -0.8295282 0.0 0.0 -21.516382
   -6.4531674 0.0 0.0 -22.233372 3.8479524 0.0 0.0 -18.426863 4.764044 0.0 0.0
   -1.0963205 -0.13180886 0.0 0.0 -1.1257589 -0.3425 0.0 0.0 -370.1727 52.26964
   0.0 0.0 -25.457136 -1.1711681 0.0 0.0 -30.338394 4.8381095 0.0 0.0 -22.579536
   0.099728055 0.0 0.0 -442.49078 -91.30986 0.0 0.0 -19.74878 1.760464 0.0 0.0
   -1.0257019 0.08788583 0.0 0.0 -1.3362772 0.081688724 0.0 0.0 -1.4558556
   0.33208054 0.0 0.0 -19.513165 11.097182 0.0 0.0 -19.832863 10.731548 0.0 0.0
   -21.729656 -1.9242533 0.0 0.0 -19.449926 3.9504063 0.0 0.0 -19.066452
   -5.661481 0.0 0.0 -20.75445 3.0575714 0.0 0.0 -1.2290845 -0.4441375 0.0 0.0
   -1.3046182 0.30060792 0.0 0.0 -1.3200346 -0.14332587 0.0 0.0 -1.164236
   -0.6502845 0.0 0.0 -26.616282 -5.7254286 0.0 0.0 -421.27844 63.586586 0.0 0.0
   -1.303283 0.28573233 0.0 0.0 -19.736292 -0.17833504 0.0 0.0 -661.466
   -37.99145 0.0 0.0 -1.2602364 -0.07351765 0.0 0.0 -1.0007836 -0.87234086 0.0
   0.0 -1.2790346 -0.090167545 0.0 0.0 -317.41064 -202.09604 0.0 0.0 -1.2986763
   -0.3259948 0.0 0.0 -21.067436 -7.685051 0.0 0.0 -22.338335 3.7319007 0.0 0.0
   -21.93808 -4.17721 0.0 0.0 -26.752422 4.075053 0.0 0.0 -1.2973351 -0.29124382
   0.0 0.0 -19.736414 8.276135 0.0 0.0 -25.970547 -20.265207 0.0 0.0 -253.38055
   -279.2944 0.0 0.0 -584.76416 -46.04876 0.0 0.0 -1.2737333 0.3940221 0.0 0.0
   -517.2003 -12.112354 0.0 0.0 -20.892094 8.706665 0.0 0.0 -1.2756922 -0.140077
   0.0 0.0 -21.579128 15.346642 0.0 0.0 -17.282463 14.053707 0.0 0.0 -1.2423828
   -0.24221785 0.0 0.0 -375.90958 -38.93362 0.0 0.0 -1.2110356 0.419456 0.0 0.0
   -35.474308 -4.384547 0.0 0.0 -1.2811366 -0.3852721 0.0 0.0 -913.02 -73.94855
   0.0 0.0 -1.2304403 0.53386927 0.0 0.0 -1.1468141 0.6125672 0.0 0.0 -31.95814
   8.504744 0.0 0.0 -1.2438394 -0.43077472 0.0 0.0 -367.39294 92.00554 0.0 0.0
   -467.8259 -138.23875 0.0 0.0 -21.72226 12.955396 0.0 0.0 -22.461329
   -2.4311688 0.0 0.0 -1.3391747 0.07745924 0.0 0.0 -22.29511 3.7117193 0.0 0.0
   -1.2536867 -0.056127004 0.0 0.0 -1.2816979 -0.53148705 0.0 0.0 -553.9327
   -28.773804 0.0 0.0 -1.2439599 0.063292325 0.0 0.0 -1.2634504 -0.0675417 0.0
   0.0 -1.1963608 0.18826467 0.0 0.0 -1.1257633 0.327825 0.0 0.0 -1.2368081
   -0.27016306 0.0 0.0 -32.947834 -12.059922 0.0 0.0 -35.093735 3.9011111 0.0
   0.0 -430.61023 -233.42471 0.0 0.0 -1.3082176 0.10612876 0.0 0.0 -22.320168
   1.9240546 0.0 0.0 -1.306944 0.01895674 0.0 0.0 -1.1855557 -0.45922512 0.0 0.0
   -1.2835127 -0.3787847 0.0 0.0 -450.16806 -123.48793 0.0 0.0 -1.2049716
   -0.007846266 0.0 0.0 -1.3242131 -0.10477371 0.0 0.0 -22.170387 3.727651 0.0
   0.0 -20.467655 10.02957 0.0 0.0 -22.431536 2.2317882 0.0 0.0 -37.114113
   -8.424044 0.0 0.0 -506.90695 -233.30972 0.0 0.0 -1.0479535 -0.83376557 0.0
   0.0 -1.2514298 -0.45394418 0.0 0.0 -18.931965 -6.716539 0.0 0.0 -1.3151858
   0.09205919 0.0 0.0 -19.153883 11.908981 0.0 0.0 -36.381893 10.169221 0.0 0.0
   -1.3311437 -0.15022524 0.0 0.0 -20.81746 7.183944 0.0 0.0 -1.7038434
   -0.5153866 0.0 0.0 -1.2462674 -0.3485288 0.0 0.0 -0.99859357 -0.7758982 0.0
   0.0 -1.2038307 0.5694837 0.0 0.0 -1.148577 0.6342181 0.0 0.0 -1.3237127
   0.21169241 0.0 0.0 -15.619731 -6.8629656 0.0 0.0 -26.937792 5.9090204 0.0 0.0
   -1.2759649 0.3818179 0.0 0.0 -1.3311241 0.15954715 0.0 0.0 -1.0363142
   -0.6525947 0.0 0.0 -1.2716116 0.092146054 0.0 0.0 -1.1688309 -0.6077256 0.0
   0.0 -14.906203 -11.010032 0.0 0.0 -1.164363 0.34382623 0.0 0.0 -17.27222
   10.260995 0.0 0.0 -17.782898 -9.408873 0.0 0.0 -1.3120351 0.27823982 0.0 0.0
   -1.1606655 -0.5786277 0.0 0.0 -1.2182103 0.09658568 0.0 0.0 -1.2928773
   0.22380517 0.0 0.0 -385.83554 -121.209915 0.0 0.0 -1.2540461 0.2756686 0.0
   0.0 -369.6097 -105.253746 0.0 0.0 -1.4072024 -0.06658715 0.0 0.0 -1.1706295
   -0.6264625 0.0 0.0 -1.1920488 -0.10792042 0.0 0.0 -21.356413 2.2781935 0.0
   0.0 -1.3100291 0.15401123 0.0 0.0 -410.17532 -1.5732467 0.0 0.0 -1.484997
   -0.24286047 0.0 0.0 -19.98649 -7.41843 0.0 0.0 -23.419256 14.785876 0.0 0.0
   -1.3009868 -0.17047799 0.0 0.0 -588.4619 -127.42947 0.0 0.0 -19.599546
   -4.786122 0.0 0.0 -22.26206 -13.071782 0.0 0.0 -1.3297884 0.15195131 0.0 0.0
   -1.0875207 0.53009033 0.0 0.0 -1.0245528 -0.031191396 0.0 0.0 -354.98245
   -151.25258 0.0 0.0 -26.943584 6.382003 0.0 0.0 -1.2122376 0.32173854 0.0 0.0
   -1.216887 -0.47889566 0.0 0.0 -22.881712 0.61225253 0.0 0.0 -0.97824895
   0.8989923 0.0 0.0 -1.0554467 -0.40018946 0.0 0.0 -25.673256 10.183686 0.0 0.0
   -20.751877 9.804092 0.0 0.0 -354.233 155.07173 0.0 0.0 -28.341965 -5.1530337
   0.0 0.0 -19.432241 -12.13918 0.0 0.0 -1.2592599 -0.12801345 0.0 0.0
   -0.46343917 -1.2035847 0.0 0.0 -23.544748 -6.0052805 0.0 0.0 -25.541578
   -10.169097 0.0 0.0 -410.78882 -41.763115 0.0 0.0 -1.2732217 0.28943062 0.0
   0.0 -350.73154 -218.27995 0.0 0.0 -512.28815 -149.59193 0.0 0.0 -1.2262205
   -0.24216612 0.0 0.0 -512.0839 135.47905 0.0 0.0 -1.2679185 0.36097068 0.0 0.0
   -20.163622 1.7266649 0.0 0.0 -1.1816992 -0.5559858 0.0 0.0 -1.1140597
   0.16919193 0.0 0.0 -1.3270351 -0.14950676 0.0 0.0 -18.657978 -10.839662 0.0
   0.0 -1.0075672 -0.8803714 0.0 0.0 -22.817327 2.9551892 0.0 0.0 -21.724054
   7.289898 0.0 0.0 -1.3108919 0.23918419 0.0 0.0 -1.4680501 0.5094328 0.0 0.0
   -1.2841442 0.06280584 0.0 0.0 -0.9460503 -0.9139845 0.0 0.0 -1.2761933
   -0.40522248 0.0 0.0 -393.2914 -132.2547 0.0 0.0 -28.292183 -5.314454 0.0 0.0
   -1.0838393 0.76399845 0.0 0.0 -1.3248882 0.06095246 0.0 0.0 -21.483105
   -2.182644 0.0 0.0 -1.1824417 0.6668116 0.0 0.0 -21.550026 8.088931 0.0 0.0
   -27.856075 0.13467816 0.0 0.0 -501.62387 -192.72678 0.0 0.0 -722.4672
   156.5188 0.0 0.0 -22.951977 -1.1392738 0.0 0.0 -27.227736 -0.24641874 0.0 0.0
   -1.3132793 -0.23242815 0.0 0.0 -1.1153741 0.07155211 0.0 0.0 -1.3187022
   -0.05248474 0.0 0.0 -1.2298857 -0.47322217 0.0 0.0 -1.1399262 0.6053357 0.0
   0.0 -1.3277725 -0.15840511 0.0 0.0 -1.2353783 -0.50222117 0.0 0.0 -18.601364
   13.562978 0.0 0.0 -1.2917231 0.29709262 0.0 0.0 -1.360744 0.0041570365 0.0
   0.0 -1.4809785 -0.044887707 0.0 0.0 -1.0168595 -0.7548828 0.0 0.0 -21.398094
   -6.759507 0.0 0.0 -0.9806672 0.72764426 0.0 0.0 -21.303322 8.641821 0.0 0.0
   -36.611095 -12.138297 0.0 0.0 -1.0651387 0.038969796 0.0 0.0 -1.2902495
   -0.26455274 0.0 0.0 -21.69561 0.096518196 0.0 0.0 -572.16644 72.301796 0.0
   0.0 -1.3406606 -0.01333178 0.0 0.0 -18.190456 -8.915716 0.0 0.0 -0.95014566
   0.0035621524 0.0 0.0 -302.00977 85.10535 0.0 0.0 -21.116869 3.2904742 0.0 0.0
   -275.7752 279.41943 0.0 0.0 -1.3762517 -0.29553425 0.0 0.0 -1.1412431
   -0.6701441 0.0 0.0 -1.048146 -0.6163934 0.0 0.0 -1.1950837 -0.38523975 0.0
   0.0 -22.11342 6.4391494 0.0 0.0 -1.3358568 0.11897852 0.0 0.0 -20.082022
   3.4762475 0.0 0.0 -1.3177825 -0.122086294 0.0 0.0 -287.42953 -288.5317 0.0
   0.0 -396.48224 -137.71011 0.0 0.0 -1.2700727 0.37354803 0.0 0.0 -18.993208
   -10.567613 0.0 0.0 -1.2521752 -0.2435608 0.0 0.0 -1.2314081 -0.46066266 0.0
   0.0 -438.39468 -93.351036 0.0 0.0 -1.2932022 0.1577463 0.0 0.0 -34.18
   10.884189 0.0 0.0 -1.2722201 -0.059861887 0.0 0.0 -20.328436 -10.294917 0.0
   0.0 -1.3402327 0.029578632 0.0 0.0 -1.1340733 -0.40015873 0.0 0.0 -21.712357
   -1.5628535 0.0 0.0 -1.2004828 -0.124456875 0.0 0.0 -1.3164762 -0.11545912 0.0
   0.0 -1.2987745 -0.056691162 0.0 0.0 -24.5692 -3.104581 0.0 0.0 -1.3231124
   0.07933183 0.0 0.0 -23.122189 2.0204363 0.0 0.0 -22.112879 7.057485 0.0 0.0
   -386.63702 82.649086 0.0 0.0 -1.2876167 0.30102333 0.0 0.0 -479.22656
   -180.94035 0.0 0.0 -23.164616 -1.6329964 0.0 0.0 -1.2426456 0.34766716 0.0
   0.0 -1.0904553 0.27302814 0.0 0.0 -22.380901 -4.6395006 0.0 0.0 -1.3306992
   0.06357771 0.0 0.0 -22.695782 4.901111 0.0 0.0 -1.192984 0.46373093 0.0 0.0
   -1.3179148 -0.222777 0.0 0.0 -1.3524141 0.7194226 0.0 0.0 -19.79723 11.888681
   0.0 0.0 -20.309792 7.9661136 0.0 0.0 -1.2532847 -0.2763578 0.0 0.0 -1.2163644
   -0.44770846 0.0 0.0 -406.11093 -119.75827 0.0 0.0 -1.3074473 -0.07733373 0.0
   0.0 -21.784332 -1.5737991 0.0 0.0 -1.5699723 -1.3404119 0.0 0.0 -1.2880929
   -0.3412198 0.0 0.0 -20.228136 -11.292126 0.0 0.0 -23.651024 7.5273848 0.0 0.0
   -21.781706 -1.8207507 0.0 0.0 -1.3280594 0.07153508 0.0 0.0 -23.114822
   12.939757 0.0 0.0 -1.2344203 -0.3941844 0.0 0.0 -1.2712319 -0.30744386 0.0
   0.0 -1.2576685 0.2159925 0.0 0.0 -1.2463555 0.0688183 0.0 0.0 -547.17615
   -600.67 0.0 0.0 -26.283348 2.3815162 0.0 0.0 -24.824413 1.5834361 0.0 0.0
   -19.900509 4.8228354 0.0 0.0 -1044.8225 -143.39606 0.0 0.0 -43.4317 9.062474
   0.0 0.0 -1.2143557 -0.019144103 0.0 0.0 -378.5659 125.46848 0.0 0.0
   -1.1775507 -0.49295458 0.0 0.0 -21.661997 -2.952503 0.0 0.0 -1.1859524
   -0.33883145 0.0 0.0 -1.2151815 0.05129321 0.0 0.0 -546.95026 -219.93286 0.0
   0.0 -21.800758 7.248795 0.0 0.0 -1.2303445 -0.44592562 0.0 0.0 -469.86707
   -122.3536 0.0 0.0 -1.1611434 0.36977232 0.0 0.0 -1.2895666 -0.20658095 0.0
   0.0 -390.01715 -88.0978 0.0 0.0 -27.162111 -4.8582835 0.0 0.0 -1.071661
   -0.74720895 0.0 0.0 -0.6536474 0.25934428 0.0 0.0 -22.46532 -6.3933606 0.0
   0.0 -22.832947 -0.9335335 0.0 0.0 -21.551876 -4.1238327 0.0 0.0 -806.39624
   -143.33408 0.0 0.0 -389.9245 91.82496 0.0 0.0 -1.3041896 -0.23744752 0.0 0.0
   -1.3366741 0.022405708 0.0 0.0 -425.88806 -40.644093 0.0 0.0 -427.91724
   2.7807531 0.0 0.0 -1.2523392 0.54186875 0.0 0.0 -21.058863 2.948973 0.0 0.0
   -1250.9316 -335.51526 0.0 0.0 -1.1941974 0.44807652 0.0 0.0 -1.3311862
   0.03236866 0.0 0.0 -421.80283 -75.72002 0.0 0.0 -20.077633 -4.618941 0.0 0.0
   -1.2926773 -0.18673632 0.0 0.0 -1.3127873 -0.19634661 0.0 0.0 -1.3341889
   0.09244772 0.0 0.0 -369.47443 -43.910442 0.0 0.0 -21.822826 2.3005838 0.0 0.0
   -23.197758 -3.1599128 0.0 0.0 -26.658909 -1.7459146 0.0 0.0 -1.1030368
   -0.7497853 0.0 0.0 -1.0026222 -0.8270164 0.0 0.0 -1.1304002 0.71169865 0.0
   0.0 -391.94498 -92.23057 0.0 0.0 -1.2991415 0.19893686 0.0 0.0 -1.5603538
   -0.7362329 0.0 0.0 -1.075715 0.73213893 0.0 0.0 -17.551664 -15.190621 0.0 0.0
   -1.4958196 -0.84979194 0.0 0.0 -558.7908 -1.6312659 0.0 0.0 -1.1930534
   -0.5912201 0.0 0.0 -1.2733562 -0.19429979 0.0 0.0 -1.2879065 0.1286453 0.0
   0.0 -31.042824 9.730141 0.0 0.0 -1.4577767 -0.28557786 0.0 0.0 -1.3043333
   -0.10613621 0.0 0.0 -1.095363 0.6234351 0.0 0.0 -1.4513634 0.23604643 0.0 0.0
   -22.024971 -1.0499413 0.0 0.0 -1.0966852 -0.23515494 0.0 0.0 -22.957945
   -15.551698 0.0 0.0 -45.29252 -15.163756 0.0 0.0 -44.261414 8.5809355 0.0 0.0
   -1.317693 -0.2349573 0.0 0.0 -1.269305 -0.3237633 0.0 0.0 -1.3073504
   0.09158429 0.0 0.0 -372.2282 -159.11227 0.0 0.0 -19.99151 -4.765375 0.0 0.0
   -1.3830861 0.59825474 0.0 0.0 -1.0582143 0.41920418 0.0 0.0 -1.1882476
   -0.58175963 0.0 0.0 -1.3467528 -0.4472335 0.0 0.0 -18.8488 13.918324 0.0 0.0
   -22.999563 -4.848317 0.0 0.0 -1.5355994 -0.1907565 0.0 0.0 -1.1243674
   0.24676722 0.0 0.0 -1.3208989 0.20004353 0.0 0.0 -444.00174 -129.95772 0.0
   0.0 -21.171377 -9.504927 0.0 0.0 -22.558119 6.558941 0.0 0.0 -1.3121448
   -0.027622294 0.0 0.0 -22.106295 -0.52157784 0.0 0.0 -20.831734 2.1205647 0.0
   0.0 -1.3207016 -0.06441921 0.0 0.0 -391.08887 110.87886 0.0 0.0 -22.875443
   4.3740716 0.0 0.0 -1.1253744 0.6583077 0.0 0.0 -427.76617 -75.32006 0.0 0.0
   -316.4704 -297.64706 0.0 0.0 -516.84686 112.86577 0.0 0.0 -388.9463
   -120.10537 0.0 0.0 -1.2631893 0.009885162 0.0 0.0 -1.2354205 -0.13153231 0.0
   0.0 -0.87890124 -0.78410447 0.0 0.0 -26.986282 -14.609576 0.0 0.0 -21.90359
   -0.8930749 0.0 0.0 -0.67084676 -0.6461936 0.0 0.0 -1.2317345 0.49305066 0.0
   0.0 -20.579542 2.6290407 0.0 0.0 -17.384548 15.043118 0.0 0.0 -22.140987
   -0.95610833 0.0 0.0 -17.772577 -10.543145 0.0 0.0 -1.1768987 0.029478922 0.0
   0.0 -0.9686604 -0.83250153 0.0 0.0 -21.864386 8.838817 0.0 0.0 -23.015167
   -4.609829 0.0 0.0 -28.15417 -5.1021757 0.0 0.0 -1.2289615 -0.27994168 0.0 0.0
   -20.617386 -2.5918324 0.0 0.0 -326.85214 -245.63174 0.0 0.0 -1.2859564
   -0.27274996 0.0 0.0 -0.99663734 -0.83808446 0.0 0.0 -1.3111937 -0.27175686
   0.0 0.0 -27.855206 -3.7568278 0.0 0.0 -23.070074 5.075701 0.0 0.0 -1.1660105
   0.11890243 0.0 0.0 -20.552004 14.423468 0.0 0.0 -21.774137 4.325254 0.0 0.0
   -498.62552 -22.18398 0.0 0.0 -1.0433489 -0.8321475 0.0 0.0 -26.317936
   9.552939 0.0 0.0 -1.2606637 0.34821343 0.0 0.0 -1.2059863 -0.3661911 0.0 0.0
   -1.2462862 0.27093568 0.0 0.0 -1.3312486 -0.08970687 0.0 0.0 -20.44536
   -8.65324 0.0 0.0 -20.803385 1.1242397 0.0 0.0 -21.537552 5.5314345 0.0 0.0
   -1.2528236 -0.4665537 0.0 0.0 -1.175282 0.6317301 0.0 0.0 -22.761969
   -6.4769287 0.0 0.0 -1.2327633 0.36808115 0.0 0.0 -85.74063 68.75242 0.0 0.0
   -24.187492 14.494638 0.0 0.0 -1.2179644 -0.44938385 0.0 0.0 -1.2650383
   -0.15860179 0.0 0.0 -1.2110784 -0.3321481 0.0 0.0 -20.64321 -1.0037664 0.0
   0.0 -19.629322 -6.5480027 0.0 0.0 -23.434633 -4.014011 0.0 0.0 -0.9954378
   -0.4249233 0.0 0.0 -1.3371792 0.05090467 0.0 0.0 -1.2824152 -0.32933074 0.0
   0.0 -25.417126 -13.888005 0.0 0.0 -1.3091092 -0.5267444 0.0 0.0 -1.3327751
   0.15316461 0.0 0.0 -21.821003 -3.470388 0.0 0.0 -1.239264 -0.40925822 0.0 0.0
   -1.2724749 -0.40109643 0.0 0.0 -1.3277588 -0.0948787 0.0 0.0 -1.1034114
   0.6663978 0.0 0.0 -1.2530937 0.046686538 0.0 0.0 -1.5665276 -0.094786674 0.0
   0.0 -23.64401 -1.8817213 0.0 0.0 -0.9229978 -0.9519521 0.0 0.0 -1.2923428
   0.5260932 0.0 0.0 -1.1727008 0.21112552 0.0 0.0 -1.2860659 0.23485695 0.0 0.0
   -21.468966 -13.664055 0.0 0.0 -1.3147736 0.23446089 0.0 0.0 -1.0512233
   -1.1629207 0.0 0.0 -21.341154 1.7814914 0.0 0.0 -1.1735247 0.55939895 0.0 0.0
   -371.75766 -52.736515 0.0 0.0 -2.290815 0.19970635 0.0 0.0 -1.1853042
   0.5545576 0.0 0.0 -0.9843514 0.59585387 0.0 0.0 -51.603336 -10.249519 0.0 0.0
   -442.81024 0.86028403 0.0 0.0 -11.849348 -17.112827 0.0 0.0 -1.1585605
   -0.022329532 0.0 0.0 -1.1850885 0.21749376 0.0 0.0 -432.68906 -96.09474 0.0
   0.0 -0.9077435 -0.13312046 0.0 0.0 -1.2641422 0.25973767 0.0 0.0 -22.140165
   -3.1689253 0.0 0.0 -1.3196633 -0.10871271 0.0 0.0 -1.0717137 0.4945384 0.0
   0.0 -1.3236852 -0.1645113 0.0 0.0 -1.1530566 -0.6289759 0.0 0.0 -21.953074
   8.903152 0.0 0.0 -1.28335 0.13293484 0.0 0.0 -27.746807 1.0199177 0.0 0.0
   -1.178754 -0.58759165 0.0 0.0 -576.79364 -55.93734 0.0 0.0 -1.1785403
   0.023940336 0.0 0.0 -21.641983 -5.4459076 0.0 0.0 -1.296692 -0.15340282 0.0
   0.0 -471.11267 63.928833 0.0 0.0 -22.943783 4.5499473 0.0 0.0 -1.255171
   0.46431583 0.0 0.0 -1.2755042 -0.14674957 0.0 0.0 -1.3156015 0.1396613 0.0
   0.0 -1.2589447 -0.4007138 0.0 0.0 -23.740074 -0.79757893 0.0 0.0 -21.16242
   -6.9186273 0.0 0.0 -26.502678 -6.6924176 0.0 0.0 -414.27637 235.38301 0.0 0.0
   -1.1719627 0.5990552 0.0 0.0 -22.360224 -1.3662587 0.0 0.0 -1.255149
   -0.4097337 0.0 0.0 -1.3284074 0.18114984 0.0 0.0 -34.7125 -13.010666 0.0 0.0
   -1.4567893 0.0833588 0.0 0.0 -22.4056 -1.1621442 0.0 0.0 -1.3143753
   0.14334154 0.0 0.0 -1.2391584 0.45783597 0.0 0.0 -1.3131963 0.17854482 0.0
   0.0 -21.78157 5.444475 0.0 0.0 -0.7051779 -0.9224596 0.0 0.0 -36.795673
   -9.7648735 0.0 0.0 -1.3265096 0.118737005 0.0 0.0 -23.529207 -4.116237 0.0
   0.0 -1.2529836 0.121504106 0.0 0.0 -349.1253 114.77016 0.0 0.0 -1.3314527
   -0.15372628 0.0 0.0 -1.1851094 -0.013354339 0.0 0.0 -20.259687 12.44833 0.0
   0.0 -417.20386 -163.45038 0.0 0.0 -1.329586 0.49151087 0.0 0.0 -1.2352642
   -0.32608846 0.0 0.0 -410.35648 -175.36807 0.0 0.0 -1.0260992 -0.18548416 0.0
   0.0 -1.245918 -0.41929355 0.0 0.0 -1.254033 -0.47491637 0.0 0.0 -23.956898
   -2.0277753 0.0 0.0 -1.2950556 -0.52848303 0.0 0.0 -1.2411969 -0.44396123 0.0
   0.0 -21.033049 -0.3195781 0.0 0.0 -48.66308 -7.9615498 0.0 0.0 -21.861084
   5.3528757 0.0 0.0 -1.3977427 0.47337118 0.0 0.0 -1.3128588 -0.0864316 0.0 0.0
   -1.128473 0.21559723 0.0 0.0 -1.4615519 0.27201408 0.0 0.0 -1.29243
   -0.1394462 0.0 0.0 -1.3150613 0.26291794 0.0 0.0 -1.202686 0.47856024 0.0 0.0
   -1.2515597 -0.47389716 0.0 0.0 -23.919273 -1.2455883 0.0 0.0 -1.3042833
   -0.30957016 0.0 0.0 -1.1227592 -0.7209574 0.0 0.0 -1.3384004 0.09103964 0.0
   0.0 -1.3305501 -0.01028195 0.0 0.0 -0.8143498 -0.801255 0.0 0.0 -1.3371811
   -0.042484283 0.0 0.0 -1.2644311 -0.38428333 0.0 0.0 -1.2480028 0.0072869803
   0.0 0.0 -1.1172475 -0.59771216 0.0 0.0 -25.618597 -9.898468 0.0 0.0
   -922.51605 -188.24275 0.0 0.0 -1.2761575 0.18420719 0.0 0.0 -23.469698
   -4.889228 0.0 0.0 -480.8937 45.238426 0.0 0.0 -1.2964242 0.26663485 0.0 0.0
   -22.477009 -12.606615 0.0 0.0 -1.3397496 -0.016532892 0.0 0.0 -1.2553086
   -0.14251354 0.0 0.0 -23.700308 0.17049623 0.0 0.0 -1.1527661 0.39703575 0.0
   0.0 -25.1406 -4.603907 0.0 0.0 -57.405655 -1.5523489 0.0 0.0 -21.13878
   0.458237 0.0 0.0 -427.87732 -119.09716 0.0 0.0 -24.763243 -3.182534 0.0 0.0
   -20.583815 -4.8400617 0.0 0.0 -1.241402 0.4158757 0.0 0.0 -1.3209586
   -0.12641546 0.0 0.0 -26.064001 -12.056148 0.0 0.0 -1.3150935 -0.17665282 0.0
   0.0 -1.0854297 0.45603654 0.0 0.0 -24.093752 -2.1133769 0.0 0.0 -0.995623
   -0.79032403 0.0 0.0 -490.60727 169.29637 0.0 0.0 -440.6865 -109.219444 0.0
   0.0 -20.310604 -13.130174 0.0 0.0 -0.8067282 -1.0321195 0.0 0.0 -16.958372
   -14.726073 0.0 0.0 -1.1764629 -0.5820764 0.0 0.0 -517.2282 -51.38598 0.0 0.0
   -1.0904659 -0.6987809 0.0 0.0 -1.2003446 0.1263882 0.0 0.0 -1.3340117
   0.16852589 0.0 0.0 -1.0078497 -0.49444386 0.0 0.0 -30.050665 -15.518175 0.0
   0.0 -18.81151 9.761949 0.0 0.0 -18.142885 13.541568 0.0 0.0 -772.98474
   -442.92548 0.0 0.0 -1.1934179 0.22458057 0.0 0.0 -425.77515 -15.025657 0.0
   0.0 -19.35887 -8.685455 0.0 0.0 -1.2518737 0.07925253 0.0 0.0 -0.96492636
   -0.6396032 0.0 0.0 -1.2616172 0.0010523946 0.0 0.0 -22.216988 5.9245524 0.0
   0.0 -21.9022 -10.390101 0.0 0.0 -49.901043 8.239207 0.0 0.0 -21.256845
   11.080697 0.0 0.0 -25.247473 -0.33831325 0.0 0.0 -21.222876 -0.622804 0.0 0.0
   -27.055983 12.139546 0.0 0.0 -1.1858565 0.26381698 0.0 0.0 -24.183456
   1.7161664 0.0 0.0 -29.668053 -0.76776594 0.0 0.0 -29.2662 8.90619 0.0 0.0
   -1.2732297 0.019720301 0.0 0.0 -22.063728 -22.773735 0.0 0.0 -21.575167
   20.249708 0.0 0.0 -19.987637 7.2135344 0.0 0.0 -1.1605774 0.51111144 0.0 0.0
   -1.322532 -0.0038177667 0.0 0.0 -1.3400474 0.025022702 0.0 0.0 -1.2676276
   -0.42446977 0.0 0.0 -1.2250525 -0.37514642 0.0 0.0 -36.116318 3.9135232 0.0
   0.0 -1.2096044 -0.5009965 0.0 0.0 -1.2516469 0.12469224 0.0 0.0 -1.212239
   0.5444926 0.0 0.0 -478.64954 -101.01582 0.0 0.0 -502.11823 -153.24547 0.0 0.0
   -415.86874 105.46955 0.0 0.0 -25.972445 -1.6809827 0.0 0.0 -24.073605
   3.3187802 0.0 0.0 -23.96392 -0.29793638 0.0 0.0 -1.1658274 0.30738834 0.0 0.0
   -1.3023078 -0.094279476 0.0 0.0 -1.3023717 -0.29787067 0.0 0.0 -1.3328792
   -0.008232216 0.0 0.0 -403.2349 220.91838 0.0 0.0 -1.2761126 0.14557943 0.0
   0.0 -543.42236 -147.72798 0.0 0.0 -421.2062 -254.66754 0.0 0.0 -15.7938795
   8.840675 0.0 0.0 -24.223312 23.997694 0.0 0.0 -22.16308 -4.896847 0.0 0.0
   -430.40457 -8.42946 0.0 0.0 -23.893839 -3.8025868 0.0 0.0 -1.1804622
   -0.625786 0.0 0.0 -1.3260338 0.13448688 0.0 0.0 -1.1800916 -0.6127122 0.0 0.0
   -1.2106922 0.24037038 0.0 0.0 -0.48296198 -0.37480062 0.0 0.0 -24.241032
   0.3672032 0.0 0.0 -21.281195 1.4872442 0.0 0.0 -21.45004 17.847263 0.0 0.0
   -23.238579 -7.449774 0.0 0.0 -22.141178 5.4959354 0.0 0.0 -0.732997
   -1.0216361 0.0 0.0 -1.2988474 -0.22871904 0.0 0.0 -1.2930574 -0.10241254 0.0
   0.0 -1.2131544 0.50916934 0.0 0.0 -21.526524 7.633138 0.0 0.0 -22.6757
   7.895629 0.0 0.0 -1.197255 -0.59502655 0.0 0.0 -430.66687 -168.82915 0.0 0.0
   -1.0345078 -0.7031118 0.0 0.0 -24.22853 -1.5539792 0.0 0.0 -1.3157842
   0.17503071 0.0 0.0 -24.089197 1.6050655 0.0 0.0 -23.620098 5.564554 0.0 0.0
   -495.54648 10.229767 0.0 0.0 -1.2625338 -0.32619342 0.0 0.0 -1.0161189
   0.8194682 0.0 0.0 -21.066103 -11.943642 0.0 0.0 -38.412468 -7.820846 0.0 0.0
   -22.831013 1.573333 0.0 0.0 -691.95056 -78.34972 0.0 0.0 -374.61032 14.290673
   0.0 0.0 -1.3267664 0.11881664 0.0 0.0 -405.66156 153.66046 0.0 0.0 -1.3193696
   -0.16189629 0.0 0.0 -1.2606466 -0.21287286 0.0 0.0 -1.1721966 0.58026403 0.0
   0.0 -21.745544 -7.193554 0.0 0.0 -1.3142309 -0.0052842796 0.0 0.0 -1.2121339
   0.14401755 0.0 0.0 -1.1785223 0.057226863 0.0 0.0 -404.11136 346.9072 0.0 0.0
   -1.153356 -0.43981418 0.0 0.0 -1.1873405 0.4778959 0.0 0.0 -15.246057
   -14.969067 0.0 0.0 -1.120764 -0.14202182 0.0 0.0 -1.740666 -0.6343093 0.0 0.0
   -1.0963721 -0.75435084 0.0 0.0 -1.3365761 -0.11128861 0.0 0.0 -23.949999
   17.867186 0.0 0.0 -1.6685579 -0.6823876 0.0 0.0 -1.3003688 0.024196334 0.0
   0.0 -1.175465 -0.48900926 0.0 0.0 -1.2203274 0.19089027 0.0 0.0 -1.2815329
   -0.36240253 0.0 0.0 -1.3208665 -0.13369018 0.0 0.0 -26.249065 -2.9204795 0.0
   0.0 -444.7537 -141.69342 0.0 0.0 -421.89124 -110.90424 0.0 0.0 -1.3133149
   -0.1724324 0.0 0.0 -0.98962003 -0.8878066 0.0 0.0 -1.0555786 -0.8098038 0.0
   0.0 -21.20581 -10.528281 0.0 0.0 -1.2288066 -0.53546226 0.0 0.0 -24.211916
   -3.0209658 0.0 0.0 -1.0879748 -0.5128615 0.0 0.0 -453.75964 113.552635 0.0
   0.0 -516.4754 -143.41974 0.0 0.0 -22.964514 -8.06583 0.0 0.0 -1.2518148
   -0.13022462 0.0 0.0 -20.830296 -9.139559 0.0 0.0 -22.857948 2.4256213 0.0 0.0
   -34.475384 -19.323362 0.0 0.0 -0.8482356 -1.0219822 0.0 0.0 -1.1982888
   -0.6013325 0.0 0.0 -1.2786087 -0.03274944 0.0 0.0 -1.2545619 0.007212699 0.0
   0.0 -29.750355 0.22092034 0.0 0.0 -1.3002295 0.43520445 0.0 0.0 -17.536028
   12.384592 0.0 0.0 -20.732967 -5.755293 0.0 0.0 -1.4750705 5.7661533e-4 0.0
   0.0 -1.7686383 -0.8758675 0.0 0.0 -18.29988 -14.624947 0.0 0.0 -481.17056
   -145.94556 0.0 0.0 -1.3360746 -0.098964006 0.0 0.0 -1.2010899 -0.5737876 0.0
   0.0 -22.462336 5.089525 0.0 0.0 -1.2435689 -0.49472585 0.0 0.0 -1.3006032
   -0.26067773 0.0 0.0 -1.0679142 -0.72159916 0.0 0.0 -403.2902 -174.56714 0.0
   0.0 -1.0152164 -0.45885405 0.0 0.0 -452.14395 130.77548 0.0 0.0 -1.0697039
   -1.0103495 0.0 0.0 -1.265125 -0.23399207 0.0 0.0 -1.2061952 -0.05306644 0.0
   0.0 -1.293743 -0.21701619 0.0 0.0 -1.2374752 -0.5174109 0.0 0.0 -1.1236159
   0.11064753 0.0 0.0 -708.68866 -43.681564 0.0 0.0 -1.1935393 -0.31675634 0.0
   0.0 -22.03868 -10.7147 0.0 0.0 -23.716717 -6.8522434 0.0 0.0 -24.199446
   3.439732 0.0 0.0 -1.3137043 -0.20540895 0.0 0.0 -0.82885844 0.85889685 0.0
   0.0 -1.3039238 0.3145582 0.0 0.0 -27.339506 7.3840795 0.0 0.0 -1.2359229
   -0.13588692 0.0 0.0 -1.3316325 -0.057256952 0.0 0.0 -1.297531 0.041850023 0.0
   0.0 -1.3402547 -0.045149412 0.0 0.0 -23.904528 -15.204799 0.0 0.0 -1.1759858
   -0.0434716 0.0 0.0 -45.467907 -3.6862524 0.0 0.0 -1.1967782 0.40924212 0.0
   0.0 -1.3266461 0.16730039 0.0 0.0 -1.289302 0.08787884 0.0 0.0 -1.3263206
   -0.09463285 0.0 0.0 -27.385897 -6.408334 0.0 0.0 -0.98299176 -0.85987926 0.0
   0.0 -1.2808574 0.18346089 0.0 0.0 -24.854404 12.200548 0.0 0.0 -504.3259
   -57.79026 0.0 0.0 -1.3351694 0.10949593 0.0 0.0 -1.0607257 -0.7513402 0.0 0.0
   -1.2369108 -0.5058888 0.0 0.0 -90.60977 -1.1117841 0.0 0.0 -1.2250899
   0.2928586 0.0 0.0 -1.3052602 -0.017469965 0.0 0.0 -24.23927 -0.90283585 0.0
   0.0 -430.92377 -270.12866 0.0 0.0 -21.940056 -10.964392 0.0 0.0 -23.849936
   5.994646 0.0 0.0 -21.1755 -12.317435 0.0 0.0 -30.052374 3.903649 0.0 0.0
   -22.387577 -10.158412 0.0 0.0 -1.0972327 -0.765172 0.0 0.0 -30.408861
   1.6172802 0.0 0.0 -1.0780132 -0.7969142 0.0 0.0 -19.780945 -1.5811887 0.0 0.0
   -1.1235436 -0.647415 0.0 0.0 -17.222992 -12.07673 0.0 0.0 -22.159163
   -5.699757 0.0 0.0 -1.319926 -0.18844213 0.0 0.0 -1.4270912 0.0523757 0.0 0.0
   -2.6002898 -0.47121236 0.0 0.0 -40.72154 -21.290968 0.0 0.0 -435.7244
   -35.4519 0.0 0.0 -1.1964173 -0.4918859 0.0 0.0 -1.3256558 -0.30174974 0.0 0.0
   -510.70157 -17.680893 0.0 0.0 -1.3285291 -0.022147095 0.0 0.0 -21.170385
   -4.7328486 0.0 0.0 -24.637177 -0.7725053 0.0 0.0 -23.841177 -5.78703 0.0 0.0
   -23.176764 -5.528702 0.0 0.0 -1.0095876 -0.8819213 0.0 0.0 -23.092918
   -6.925906 0.0 0.0 -24.631208 0.4348614 0.0 0.0 -23.687817 -2.2183325 0.0 0.0
   -1.1756523 -0.32801592 0.0 0.0 -1.2733217 0.17079943 0.0 0.0 -22.28177
   -10.2558155 0.0 0.0 -1.268248 0.30773112 0.0 0.0 -0.4526484 -1.2588178 0.0
   0.0 -1.3504118 -0.20629176 0.0 0.0 -16.705101 -2.6749816 0.0 0.0 -442.18265
   66.27705 0.0 0.0 -1.18883 -0.4974038 0.0 0.0 -19.172327 -10.234992 0.0 0.0
   -1.1530206 0.24031946 0.0 0.0 -1.0601206 -0.6886842 0.0 0.0 -21.598707
   -2.475054 0.0 0.0 -1.2914333 0.08115683 0.0 0.0 -418.41483 -159.58119 0.0 0.0
   -624.1387 99.18362 0.0 0.0 -0.9691842 0.060548715 0.0 0.0 -26.78589 7.2404013
   0.0 0.0 -1.4021354 0.47690305 0.0 0.0 -1.2626524 -0.17287824 0.0 0.0
   -1.333596 -0.21390301 0.0 0.0 -21.707756 -1.5514662 0.0 0.0 -1.2773359
   -0.3994571 0.0 0.0 -1.2373314 -0.36044636 0.0 0.0 -1.3150206 -0.26166216 0.0
   0.0 -1.2497681 0.018088065 0.0 0.0 -1.2572342 -0.28351396 0.0 0.0 -1.1953759
   -0.30020756 0.0 0.0 -21.387178 9.297873 0.0 0.0 -22.74939 -9.977371 0.0 0.0
   -449.53647 172.46082 0.0 0.0 -447.4931 42.384224 0.0 0.0 -17.15845 -12.987304
   0.0 0.0 -1.3050277 -0.0877828 0.0 0.0 -1.3257866 -0.10881127 0.0 0.0
   -26.400793 -9.054782 0.0 0.0 -396.00482 -213.7107 0.0 0.0 -1.000364
   -0.06873695 0.0 0.0 -1.2270507 -0.5230603 0.0 0.0 -1.2222036 -0.5338068 0.0
   0.0 -21.74248 1.2461923 0.0 0.0 -591.45404 52.625187 0.0 0.0 -1.3119959
   -0.17050439 0.0 0.0 -19.350134 6.786329 0.0 0.0 -1.3159349 0.2573928 0.0 0.0
   -1.2635775 -0.3223715 0.0 0.0 -503.45853 121.0576 0.0 0.0 -1.1532791
   -0.39838785 0.0 0.0 -784.0585 16.174496 0.0 0.0 -27.017653 -6.123062 0.0 0.0
   -1.2680674 -0.38444874 0.0 0.0 -24.094404 5.886302 0.0 0.0 -22.053228
   -7.7430725 0.0 0.0 -24.28856 2.3345788 0.0 0.0 -1.3245584 0.01093741 0.0 0.0
   -480.36868 -61.05009 0.0 0.0 -1.3096069 -0.24815486 0.0 0.0 -20.0181 8.707583
   0.0 0.0 -2.3782818 0.03685087 0.0 0.0 -451.46454 -27.034689 0.0 0.0
   -1.2976967 -0.31056193 0.0 0.0 -590.1907 -88.408264 0.0 0.0 -500.34116
   28.170593 0.0 0.0 -21.537895 10.474335 0.0 0.0 -536.2879 -151.50839 0.0 0.0
   -1.0657207 0.30810297 0.0 0.0 -25.055708 -0.46881914 0.0 0.0 -1.3383433
   0.046379287 0.0 0.0 -1.2421383 -0.41764304 0.0 0.0 -1.2027576 -0.35502684 0.0
   0.0 -19.879642 -5.113739 0.0 0.0 -416.82977 -178.56267 0.0 0.0 -641.29584
   8.692151 0.0 0.0 -20.663063 10.997737 0.0 0.0 -1.3087249 0.010037519 0.0 0.0
   -1.1519611 0.6840239 0.0 0.0 -1.3317534 -0.15908894 0.0 0.0 -1.1615552
   -0.43499315 0.0 0.0 -1.1543572 0.65933096 0.0 0.0 -29.530521 -1.7112838 0.0
   0.0 -1.0797766 -0.7920378 0.0 0.0 -21.882154 1.0319028 0.0 0.0 -20.890587
   3.3589597 0.0 0.0 -1.1002041 -0.75614667 0.0 0.0 -21.416336 -4.0609283 0.0
   0.0 -519.8156 -53.62376 0.0 0.0 -20.495998 11.454856 0.0 0.0 -1.2976618
   -0.23773123 0.0 0.0 -23.355532 8.305845 0.0 0.0 -21.55481 3.5380623 0.0 0.0
   -434.08118 355.06546 0.0 0.0 -1.3161447 -0.1450023 0.0 0.0 -35.338017
   -14.056079 0.0 0.0 -0.9532772 0.21494663 0.0 0.0 -21.911472 -0.9813573 0.0
   0.0 -1.291601 -0.042260554 0.0 0.0 -888.2079 212.88237 0.0 0.0 -1.0410166
   -0.81518334 0.0 0.0 -1.0508299 -0.7970959 0.0 0.0 -1.2920011 0.10777535 0.0
   0.0 -24.229416 5.9190755 0.0 0.0 -1.6102655 0.13990733 0.0 0.0 -38.820778
   12.928651 0.0 0.0 -25.844915 16.946268 0.0 0.0 -19.631172 15.232581 0.0 0.0
   -1.2906607 -0.034028668 0.0 0.0 -28.97792 15.91563 0.0 0.0 -29.34661
   -5.941342 0.0 0.0 -1.0736295 0.39679882 0.0 0.0 -24.522118 -1.2810044 0.0 0.0
   -21.957006 0.91384023 0.0 0.0 -1.1031693 -0.6982688 0.0 0.0 -1.3183402
   0.14081825 0.0 0.0 -1.2471198 0.27787215 0.0 0.0 -490.695 7.636453 0.0 0.0
   -1.316936 -0.016397096 0.0 0.0 -18.138737 -16.261412 0.0 0.0 -1.3150305
   -0.039524604 0.0 0.0 -31.383886 16.866236 0.0 0.0 -481.54028 -97.48811 0.0
   0.0 -1.2967027 -0.023805201 0.0 0.0 -1.2433212 0.31396025 0.0 0.0 -28.915882
   0.63051015 0.0 0.0 -1.0605613 0.76711017 0.0 0.0 -2.5526114 0.8463252 0.0 0.0
   -23.583544 -8.176535 0.0 0.0 -1.347127 0.41181773 0.0 0.0 -1.3541652
   -0.5601643 0.0 0.0 -1.3009884 0.13523878 0.0 0.0 -25.958122 7.6761775 0.0 0.0
   -1.2013555 -0.17945254 0.0 0.0 -1.2540867 -0.47283757 0.0 0.0 -24.70927
   -2.333609 0.0 0.0 -1.3354279 0.12194233 0.0 0.0 -1.1198651 0.5126881 0.0 0.0
   -25.305937 0.56348026 0.0 0.0 -1.389833 0.16481726 0.0 0.0 -1.2909807
   -0.33894622 0.0 0.0 -1.1016577 -0.7298458 0.0 0.0 -1.195286 -0.24814044 0.0
   0.0 -846.80817 -165.94542 0.0 0.0 -0.590917 -1.1773489 0.0 0.0 -21.853825
   -2.7871957 0.0 0.0 -25.587002 -9.052136 0.0 0.0 -20.401596 11.599255 0.0 0.0
   -1.3000158 -0.12755609 0.0 0.0 -1.331922 -0.052128028 0.0 0.0 -1.3142016
   0.040521998 0.0 0.0 -32.28938 -7.404601 0.0 0.0 -19.93809 -12.202182 0.0 0.0
   -19.330404 -10.623683 0.0 0.0 -1.3022476 0.22601426 0.0 0.0 -1.2947122
   -0.013766699 0.0 0.0 -29.112823 -1.5531663 0.0 0.0 -1.2818958 0.09412621 0.0
   0.0 -1.2931504 0.26658294 0.0 0.0 -1.1921548 -0.27076906 0.0 0.0 -27.048033
   -2.959704 0.0 0.0 -1.3890793 0.46233538 0.0 0.0 -427.6125 315.9693 0.0 0.0
   -20.25349 8.501904 0.0 0.0 -24.934504 1.1191074 0.0 0.0 -1.2943428
   -0.30952466 0.0 0.0 -472.5637 -151.34192 0.0 0.0 -1.0628806 0.6851619 0.0 0.0
   -555.62646 131.76297 0.0 0.0 -496.49567 6.7226925 0.0 0.0 -21.408611
   5.4543467 0.0 0.0 -0.93181366 -0.23656677 0.0 0.0 -1.1542343 -0.051945705 0.0
   0.0 -21.003141 -13.756887 0.0 0.0 -24.873556 -3.4775715 0.0 0.0 -1.3999052
   0.52489865 0.0 0.0 -1.0517707 -0.7880686 0.0 0.0 -23.270258 -9.418031 0.0 0.0
   -1.1364489 -0.68696874 0.0 0.0 -0.78184557 0.38466665 0.0 0.0 -1.2792739
   0.29992214 0.0 0.0 -0.85315734 -0.62070733 0.0 0.0 -22.701622 -6.058191 0.0
   0.0 -1.2287382 0.3516787 0.0 0.0 -22.452536 7.6258154 0.0 0.0 -22.086601
   11.672183 0.0 0.0 -1.338769 0.044116784 0.0 0.0 -16.481777 -14.801378 0.0 0.0
   -1.1335386 0.61412454 0.0 0.0 -1.2986759 -0.33036843 0.0 0.0 -1.3368479
   -0.07109928 0.0 0.0 -21.431007 -5.551428 0.0 0.0 -523.2363 236.82018 0.0 0.0
   -1.253178 0.39832696 0.0 0.0 -1.0800397 -0.78695196 0.0 0.0 -1.2861345
   0.27399173 0.0 0.0 -25.031834 -4.8311396 0.0 0.0 -1071.3967 -150.35191 0.0
   0.0 -1.2275139 -0.25185862 0.0 0.0 -24.518362 -5.832681 0.0 0.0 -1.2093266
   0.3685018 0.0 0.0 -24.451525 -6.004742 0.0 0.0 -1.2633674 0.42950374 0.0 0.0
   -1.1402955 -0.67719007 0.0 0.0 -1.31505 0.21026954 0.0 0.0 -556.2788
   -149.91522 0.0 0.0 -32.20383 2.182007 0.0 0.0 -25.035421 -2.921817 0.0 0.0
   -1.3219088 -0.21152565 0.0 0.0 -0.9051408 -0.93960327 0.0 0.0 -1.2815425
   -0.23049727 0.0 0.0 -1.1899438 -0.55677384 0.0 0.0 -1.3166546 0.044303667 0.0
   0.0 -1.1550639 0.31273094 0.0 0.0 -0.7966594 -1.340359 0.0 0.0 -1.1844151
   -0.31951386 0.0 0.0 -423.40018 -269.329 0.0 0.0 -1.1219301 -0.6960369 0.0 0.0
   -16.868624 11.50053 0.0 0.0 -1.1820598 -0.43885082 0.0 0.0 -1.7642393
   0.14306211 0.0 0.0 -1.059598 0.028349131 0.0 0.0 -25.202251 -1.627269 0.0 0.0
   -662.3622 -268.56836 0.0 0.0 -1.337503 0.034434218 0.0 0.0 -1.3216171
   0.04178059 0.0 0.0 -1.2549803 -0.1242804 0.0 0.0 -1.237875 0.4432312 0.0 0.0
   -21.272854 4.883386 0.0 0.0 -1.138094 -0.06315985 0.0 0.0 -0.94778967
   -0.8902504 0.0 0.0 -1.9384526 -0.33513147 0.0 0.0 -1.2903441 -0.064859726 0.0
   0.0 -1.0974345 0.62456197 0.0 0.0 -1.150335 -0.6538413 0.0 0.0 -1.3199906
   -0.21655977 0.0 0.0 -1.2063757 0.092400685 0.0 0.0 -30.016922 -5.3104854 0.0
   0.0 -1.3911135 0.13412747 0.0 0.0 -0.9425631 -0.8549756 0.0 0.0 -1.323935
   0.16535836 0.0 0.0 -21.50182 -12.89746 0.0 0.0 -0.9761669 -0.877785 0.0 0.0
   -1.2319909 -0.18700019 0.0 0.0 -1.2759012 0.3466464 0.0 0.0 -430.8867
   -189.3021 0.0 0.0 -467.72372 -53.184425 0.0 0.0 -467.99136 51.70744 0.0 0.0
   -1.3076818 -0.21854822 0.0 0.0 -1.2031571 0.5616405 0.0 0.0 -489.63687
   84.05374 0.0 0.0 -17.314686 -13.84192 0.0 0.0 -1.2257373 -0.4701937 0.0 0.0
   -522.5128 147.7859 0.0 0.0 -22.139757 2.707696 0.0 0.0 -1.1353561 0.013108223
   0.0 0.0 -1.1945122 0.398177 0.0 0.0 -1.2809649 0.38468063 0.0 0.0 -24.941303
   -7.5204635 0.0 0.0 -540.1046 -62.959408 0.0 0.0 -1.3184851 0.14759058 0.0 0.0
   -1.1017021 -0.6092422 0.0 0.0 -25.598785 -1.9600903 0.0 0.0 -29.513361
   -8.165672 0.0 0.0 -509.01007 193.04793 0.0 0.0 -399.83612 252.07874 0.0 0.0
   -1.3369179 0.0748629 0.0 0.0 -14.393331 -17.73945 0.0 0.0 -472.3052
   -232.79103 0.0 0.0 -1.2882544 -0.3346491 0.0 0.0 -0.8019327 -1.0070558 0.0
   0.0 -587.147 223.3932 0.0 0.0 -20.808971 -14.284924 0.0 0.0 -520.0578
   -269.0852 0.0 0.0 -1.2484756 0.29833135 0.0 0.0 -16.1995 -15.4058075 0.0 0.0
   -28.30644 -8.78479 0.0 0.0 -1.156479 -0.57864493 0.0 0.0 -461.87238 106.47665
   0.0 0.0 -25.545958 2.6828828 0.0 0.0 -16.707623 -13.894765 0.0 0.0 -1.1555549
   0.6234904 0.0 0.0 -34.270573 12.310149 0.0 0.0 -21.559875 -23.828009 0.0 0.0
   -19.505798 16.211605 0.0 0.0 -1.2724161 -0.2969817 0.0 0.0 -469.75653
   -197.77847 0.0 0.0 -1.1474282 0.31115967 0.0 0.0 -497.223 113.08216 0.0 0.0
   -30.659048 -8.692672 0.0 0.0 -25.011055 -6.199961 0.0 0.0 -502.42084
   -89.09633 0.0 0.0 -31.540455 -15.535283 0.0 0.0 -18.145744 -0.45972353 0.0
   0.0 -1.1983285 0.4768617 0.0 0.0 -1.3106501 -0.2827471 0.0 0.0 -36.715645
   -11.956173 0.0 0.0 -1.247635 0.408737 0.0 0.0 -1.1847967 0.5143651 0.0 0.0
   -1.3066667 0.29604512 0.0 0.0 -17.568201 16.389313 0.0 0.0 -727.3767
   54.926323 0.0 0.0 -31.07882 7.240623 0.0 0.0 -29.983122 6.953279 0.0 0.0
   -22.221191 3.0151398 0.0 0.0 -1.2928132 0.1779432 0.0 0.0 -1.2966783
   -0.3414674 0.0 0.0 -1.2364761 -0.45667613 0.0 0.0 -22.29578 -2.0722685 0.0
   0.0 -1.2811859 0.0667305 0.0 0.0 -727.3792 74.22801 0.0 0.0 -26.512762
   -7.9167404 0.0 0.0 -1.2810166 0.2065635 0.0 0.0 -1.2233394 -0.49180278 0.0
   0.0 -1.3085431 -0.040795635 0.0 0.0 -22.24578 26.034384 0.0 0.0 -19.69512
   -22.35052 0.0 0.0 -1.2901894 -0.2901978 0.0 0.0 -518.4909 -186.99922 0.0 0.0
   -26.812132 7.1860237 0.0 0.0 -22.301954 -2.356026 0.0 0.0 -20.331345
   9.5533085 0.0 0.0 -454.62524 -149.16975 0.0 0.0 -1.2565148 0.010840252 0.0
   0.0 -1.0433201 -0.28555337 0.0 0.0 -21.46336 6.6149764 0.0 0.0 -1.1978295
   -0.10508148 0.0 0.0 -39.94831 -1.3280739 0.0 0.0 -22.940243 7.498505 0.0 0.0
   -1.0550516 0.8180903 0.0 0.0 -1.1468226 0.6632791 0.0 0.0 -28.678806
   1.8674148 0.0 0.0 -30.744444 -15.4702015 0.0 0.0 -20.235256 -9.7226 0.0 0.0
   -0.8330388 -0.99668366 0.0 0.0 -1.1766107 -0.40986118 0.0 0.0 -23.733025
   -2.7679646 0.0 0.0 -1.3309695 -0.12091043 0.0 0.0 -25.408428 -1.7289952 0.0
   0.0 -0.9232715 -0.8421913 0.0 0.0 -1.1636058 -0.4880111 0.0 0.0 -24.76603
   5.8919945 0.0 0.0 -1.3264345 -0.19596502 0.0 0.0 -489.96252 410.7753 0.0 0.0
   -683.93243 63.087055 0.0 0.0 -1.341142 -0.0100804055 0.0 0.0 -1.2594516
   0.37545142 0.0 0.0 -1.3254083 0.16544911 0.0 0.0 -1.3078324 0.27568233 0.0
   0.0 -517.2892 201.37477 0.0 0.0 -18.537909 15.307556 0.0 0.0 -1.2549902
   0.35766885 0.0 0.0 -1.1495711 0.25672114 0.0 0.0 -20.164759 -15.363589 0.0
   0.0 -1.2292422 -0.5045053 0.0 0.0 -511.86774 76.38546 0.0 0.0 -1.1654383
   0.52398545 0.0 0.0 -25.324738 3.165238 0.0 0.0 -24.628912 8.330406 0.0 0.0
   -614.08795 -313.38504 0.0 0.0 -1.281064 0.27488664 0.0 0.0 -24.663881
   -6.7759914 0.0 0.0 -1.3125676 0.26303262 0.0 0.0 -585.9893 263.47632 0.0 0.0
   -614.606 414.77478 0.0 0.0 -435.74255 208.08145 0.0 0.0 -1.3088928
   -0.28226846 0.0 0.0 -27.697521 3.757321 0.0 0.0 -23.626469 -5.4141536 0.0 0.0
   -1.3250587 0.11008842 0.0 0.0 -483.06653 17.672155 0.0 0.0 -24.471357
   7.4723296 0.0 0.0 -1.481218 -0.19059165 0.0 0.0 -39.26608 7.254909 0.0 0.0
   -1.1702447 0.5702556 0.0 0.0 -1.3330017 0.13743128 0.0 0.0 -26.595726
   11.56752 0.0 0.0 -1.2611126 -0.06506013 0.0 0.0 -483.44513 -27.235142 0.0 0.0
   -20.635 -9.233297 0.0 0.0 -55.82395 -4.939491 0.0 0.0 -407.72937 -261.75635
   0.0 0.0 -1.3091521 -0.18444026 0.0 0.0 -1.2408855 -0.02143918 0.0 0.0
   -23.5857 -10.217456 0.0 0.0 -21.0004 -8.39471 0.0 0.0 -1.3067845 -0.17378582
   0.0 0.0 -1.4789362 -0.27759454 0.0 0.0 -29.590265 -5.3965917 0.0 0.0
   -397.88303 -277.93347 0.0 0.0 -1.2644461 0.2018451 0.0 0.0 -1.254348
   0.16864058 0.0 0.0 -0.58933175 -1.197584 0.0 0.0 -1.3232331 -0.17337401 0.0
   0.0 -1.0692885 -0.7389074 0.0 0.0 -1.2986265 -0.077882245 0.0 0.0 -1.281046
   -0.05284029 0.0 0.0 -0.9775509 -0.773724 0.0 0.0 -0.6023893 -1.1839858 0.0
   0.0 -21.633547 -17.678144 0.0 0.0 -24.198397 9.158232 0.0 0.0 -1.2659655
   -0.4241269 0.0 0.0 -1.3392246 -0.04891611 0.0 0.0 -1.3026702 0.038069095 0.0
   0.0 -562.06415 -6.302016 0.0 0.0 -464.63876 145.84633 0.0 0.0 -1.2313684
   0.38029024 0.0 0.0 -25.911427 -3.56705 0.0 0.0 -1.2352822 0.17969792 0.0 0.0
   -26.27872 9.92472 0.0 0.0 -23.246843 7.0754957 0.0 0.0 -1.3105942 -0.03430147
   0.0 0.0 -22.74159 -12.91206 0.0 0.0 -439.18854 212.31581 0.0 0.0 -1.0940408
   -0.6526645 0.0 0.0 -1.0516943 0.24249335 0.0 0.0 -22.69731 0.20203298 0.0 0.0
   -1.3058081 -0.22379455 0.0 0.0 -1.3000631 -0.14191292 0.0 0.0 -23.734213
   10.110796 0.0 0.0 -25.39635 -4.562841 0.0 0.0 -586.5613 153.71942 0.0 0.0
   -1.388488 0.31076705 0.0 0.0 -41.768463 -27.336966 0.0 0.0 -1.1778531
   -0.14833301 0.0 0.0 -25.20083 -5.596097 0.0 0.0 -26.207584 0.6738572 0.0 0.0
   -1.1055434 -0.5942063 0.0 0.0 -603.8295 65.43639 0.0 0.0 -56.50383 5.0145073
   0.0 0.0 -1.2563915 0.3624674 0.0 0.0 -1.2233982 -0.42283762 0.0 0.0
   -1.1174681 0.64609945 0.0 0.0 -1.0409129 -0.19281054 0.0 0.0 -29.947172
   -4.3358645 0.0 0.0 -26.27359 -10.020186 0.0 0.0 -1.1875427 -0.5191256 0.0 0.0
   -692.0417 -123.77102 0.0 0.0 -24.944649 -1.8288745 0.0 0.0 -480.34937
   -99.282845 0.0 0.0 -490.41064 -13.840881 0.0 0.0 -1.3360301 0.63551116 0.0
   0.0 -25.724262 1.7840934 0.0 0.0 -27.577314 6.0037017 0.0 0.0 -13.036676
   -8.240553 0.0 0.0 -489.80038 -363.22833 0.0 0.0 -1.3557289 -0.048803084 0.0
   0.0 -1.4607091 -0.3270508 0.0 0.0 -25.751066 2.1722271 0.0 0.0 -1.0866963
   0.17264415 0.0 0.0 -483.58267 88.65019 0.0 0.0 -1.3204811 0.025215462 0.0 0.0
   -1.3166064 0.037505616 0.0 0.0 -24.753378 -7.575 0.0 0.0 -1.2545145
   -0.35505012 0.0 0.0 -1.1416075 0.64156526 0.0 0.0 -22.421753 1.4091498 0.0
   0.0 -24.905396 7.093149 0.0 0.0 -1.0122527 0.8597421 0.0 0.0 -1.3278322
   0.18284118 0.0 0.0 -1.1792072 -0.5780079 0.0 0.0 -24.483604 -0.97490853 0.0
   0.0 -1.247662 -0.39607793 0.0 0.0 -1.3213272 -0.19394945 0.0 0.0 -25.946375
   -4.368244 0.0 0.0 -23.895699 5.4610176 0.0 0.0 -38.940563 11.294699 0.0 0.0
   -24.844807 7.3228354 0.0 0.0 -1.3204341 -0.14241616 0.0 0.0 -25.955948
   8.77244 0.0 0.0 -25.7961 1.7980592 0.0 0.0 -1.4254205 -0.25697517 0.0 0.0
   -22.808344 0.89529425 0.0 0.0 -1.3124759 0.26852322 0.0 0.0 -658.8975
   -38.15193 0.0 0.0 -1.2735825 0.2682953 0.0 0.0 -22.199764 -5.3695374 0.0 0.0
   -1.3045636 0.2957327 0.0 0.0 -491.6228 -202.44643 0.0 0.0 -1.0140318
   0.5545817 0.0 0.0 -1.2996354 0.17681357 0.0 0.0 -0.64004767 0.35501185 0.0
   0.0 -1.155922 -0.6767217 0.0 0.0 -1.2265538 -0.39752212 0.0 0.0 -24.079784
   0.7416002 0.0 0.0 -23.155802 12.687928 0.0 0.0 -1.3118756 0.19078094 0.0 0.0
   -1.3336445 0.011974469 0.0 0.0 -1.2814072 -0.11485953 0.0 0.0 -423.7217
   257.2307 0.0 0.0 -25.338888 -1.4988633 0.0 0.0 -1.3197669 -0.13549218 0.0 0.0
   -1.0869626 -0.6894935 0.0 0.0 -1.2122327 0.14038193 0.0 0.0 -23.073677
   8.481836 0.0 0.0 -25.119844 6.327244 0.0 0.0 -26.191677 10.870997 0.0 0.0
   -1.2130824 0.5385137 0.0 0.0 -1.2699527 0.10361257 0.0 0.0 -1.4906057
   -0.06215401 0.0 0.0 -486.3593 221.02122 0.0 0.0 -1.2901677 -0.2253925 0.0 0.0
   -1.1413599 0.15398489 0.0 0.0 -59.345016 -28.731478 0.0 0.0 -528.5269
   80.94161 0.0 0.0 -664.3127 -28.914839 0.0 0.0 -3.0729697 0.17338735 0.0 0.0
   -452.55173 -206.79904 0.0 0.0 -28.0581 -4.726448 0.0 0.0 -21.995493
   -13.949692 0.0 0.0 -1.265456 -0.18598418 0.0 0.0 -1.8381082 0.68480384 0.0
   0.0 -56.524017 -28.118929 0.0 0.0 -1.6665144 -0.16173863 0.0 0.0 -1.299602
   -0.21741636 0.0 0.0 -1.2094522 -0.12221926 0.0 0.0 -0.60518575 -0.077202834
   0.0 0.0 -25.216309 2.116943 0.0 0.0 -1.2452056 -0.027434535 0.0 0.0 -573.689
   60.65978 0.0 0.0 -1.2981783 0.073192656 0.0 0.0 -1.1272889 -0.64972955 0.0
   0.0 -1.2832111 0.3341849 0.0 0.0 -1.2257982 0.45327675 0.0 0.0 -1.4097551
   -0.68324363 0.0 0.0 -38.399487 2.899171 0.0 0.0 -1.2951494 0.3293432 0.0 0.0
   -1.3257385 -0.2016526 0.0 0.0 -1.1059395 0.018992573 0.0 0.0 -1.2556057
   0.2592956 0.0 0.0 -1.3171468 -0.24141009 0.0 0.0 -24.680487 8.489547 0.0 0.0
   -499.34378 28.762259 0.0 0.0 -25.066633 6.4284368 0.0 0.0 -1.3071921
   0.2700542 0.0 0.0 -24.876434 9.247315 0.0 0.0 -1.1485904 0.09662146 0.0 0.0
   -1.0657841 0.11590096 0.0 0.0 -1.1818705 0.0617645 0.0 0.0 -23.070787
   -8.852219 0.0 0.0 -1.4156228 -0.40357125 0.0 0.0 -1.2878578 0.3168542 0.0 0.0
   -25.524696 1.4778109 0.0 0.0 -19.445166 -12.285607 0.0 0.0 -527.32947
   113.207954 0.0 0.0 -481.4257 -243.40857 0.0 0.0 -35.3911 0.8256243 0.0 0.0
   -1.5973532 -0.53304404 0.0 0.0 -1.1816422 0.59978586 0.0 0.0 -471.34875
   -136.26611 0.0 0.0 -1.1910456 0.06249474 0.0 0.0 -58.807808 -4.2621737 0.0
   0.0 -26.091412 -0.46747947 0.0 0.0 -26.075188 -2.1452198 0.0 0.0 -0.79588616
   -1.0773046 0.0 0.0 -32.992844 -2.6817997 0.0 0.0 -535.9364 71.95697 0.0 0.0
   -20.745214 -15.400957 0.0 0.0 -1.2746772 -0.4128123 0.0 0.0 -1.3049706
   -0.20970964 0.0 0.0 -0.9248094 0.5113354 0.0 0.0 -1.3274813 -0.19401523 0.0
   0.0 -22.776775 -2.635209 0.0 0.0 -1.2666967 -0.4249421 0.0 0.0 -1.2316524
   0.4541439 0.0 0.0 -1.2926387 -0.21588516 0.0 0.0 -18.800802 13.343433 0.0 0.0
   -41.87752 14.614112 0.0 0.0 -1.3252622 0.18022253 0.0 0.0 -24.468058
   4.0164733 0.0 0.0 -1.2154177 0.3237911 0.0 0.0 -22.96811 -12.534574 0.0 0.0
   -1.2979877 0.27043003 0.0 0.0 -1.0482507 0.7280457 0.0 0.0 -1.2325212
   0.5144359 0.0 0.0 -26.51183 -6.282852 0.0 0.0 -17.308289 -20.055376 0.0 0.0
   -1.2919174 0.2262872 0.0 0.0 -26.465282 3.3122969 0.0 0.0 -532.29114
   109.49304 0.0 0.0 -1.2838349 -0.36892763 0.0 0.0 -32.70198 -5.888799 0.0 0.0
   -23.795406 10.978974 0.0 0.0 -492.22296 115.15522 0.0 0.0 -1.1197131
   -0.3818208 0.0 0.0 -1.2509426 -0.20590179 0.0 0.0 -1.2774704 -0.3804021 0.0
   0.0 -274.279 234.32343 0.0 0.0 -446.93817 -444.55188 0.0 0.0 -0.9857534
   0.7704704 0.0 0.0 -3.845661 -0.68717074 0.0 0.0 -19.877262 -8.345825 0.0 0.0
   -1.3322252 -0.14069939 0.0 0.0 -0.7946704 -0.92690873 0.0 0.0 -1.3121077
   0.047130723 0.0 0.0 -18.377325 -13.97769 0.0 0.0 -1.2421259 0.38216528 0.0
   0.0 -1.3057854 -0.24219522 0.0 0.0 -1.1997395 0.5795871 0.0 0.0 -26.898586
   -10.188146 0.0 0.0 -1.0340168 -0.20354146 0.0 0.0 -26.200188 -0.50560105 0.0
   0.0 -1.2857629 0.33898914 0.0 0.0 -1.2532989 -0.27946818 0.0 0.0 -21.881672
   7.055952 0.0 0.0 -16.481123 -16.245956 0.0 0.0 -1.161062 0.6359391 0.0 0.0
   -1.3391558 0.04649232 0.0 0.0 -509.0817 -286.43542 0.0 0.0 -1.2463676
   -0.20534827 0.0 0.0 -22.357332 -6.041196 0.0 0.0 -1.2820697 0.39414895 0.0
   0.0 -1.2992454 -0.0766986 0.0 0.0 -24.349468 6.3656206 0.0 0.0 -1.2613705
   -0.3833031 0.0 0.0 -1.2288169 0.23118652 0.0 0.0 -1.328413 0.020355036 0.0
   0.0 -1.3028477 -0.31262016 0.0 0.0 -507.84143 37.124928 0.0 0.0 -94.85929
   32.49245 0.0 0.0 -0.68193734 -0.41012433 0.0 0.0 -64.519516 -3.2506678 0.0
   0.0 -1.314422 -0.24920434 0.0 0.0 -1.1706378 0.64526016 0.0 0.0 -27.119352
   -9.807527 0.0 0.0 -1.3090017 0.16935776 0.0 0.0 -678.27625 91.66108 0.0 0.0
   -1.3037066 0.15239818 0.0 0.0 -29.00385 6.6375465 0.0 0.0 -1.2531753
   -0.27483657 0.0 0.0 -1.1376727 0.5751449 0.0 0.0 -1.2435265 0.22175251 0.0
   0.0 -1.1172916 0.59481096 0.0 0.0 -1.1844116 -0.5366467 0.0 0.0 -23.997444
   8.472909 0.0 0.0 -1.2912844 0.20792624 0.0 0.0 -26.22993 -5.6381097 0.0 0.0
   -1.28801 -0.27671126 0.0 0.0 -1.3038518 -0.0878616 0.0 0.0 -1.3242284
   0.18035102 0.0 0.0 -1.2395344 -0.25949797 0.0 0.0 -24.56602 9.646289 0.0 0.0
   -1.2096663 -0.2415636 0.0 0.0 -1.2180637 -0.55125684 0.0 0.0 -21.163612
   -11.252176 0.0 0.0 -723.08435 334.455 0.0 0.0 -54.675495 12.346433 0.0 0.0
   -22.28137 -6.5494967 0.0 0.0 -1.2609826 0.10357244 0.0 0.0 -1.3171554
   0.15502411 0.0 0.0 -22.575722 -5.4329247 0.0 0.0 -1.2905246 -0.24002169 0.0
   0.0 -1.2279309 -0.44402444 0.0 0.0 -42.607212 14.565242 0.0 0.0 -543.8034
   96.268005 0.0 0.0 -1.1871967 -0.15536174 0.0 0.0 -28.441927 -5.496723 0.0 0.0
   -1.2419512 -0.27718797 0.0 0.0 -22.652143 10.645749 0.0 0.0 -1.2051839
   -0.54748887 0.0 0.0 -1.2063679 0.673441 0.0 0.0 -1.0354855 -0.8124993 0.0 0.0
   -1.0030286 0.15520722 0.0 0.0 -37.726646 -18.68363 0.0 0.0 -0.77145493
   0.2819473 0.0 0.0 -1.2687851 -0.049900655 0.0 0.0 -1.1594679 0.62457037 0.0
   0.0 -0.89811605 -0.99552816 0.0 0.0 -25.911263 -5.3706555 0.0 0.0 -1.4917986
   -0.18919365 0.0 0.0 -22.717728 -5.190971 0.0 0.0 -1.1642946 -0.61897665 0.0
   0.0 -716.0254 205.76704 0.0 0.0 -55.263836 11.062786 0.0 0.0 -0.7580591
   -0.99973816 0.0 0.0 -1.3193941 6.2953675e-4 0.0 0.0 -1.2574893 0.39190564 0.0
   0.0 -1.3146296 -0.2666722 0.0 0.0 -23.283243 -0.22457707 0.0 0.0 -1.1554476
   -0.30763707 0.0 0.0 -26.475368 0.5847262 0.0 0.0 -1.23629 -0.50928795 0.0 0.0
   -26.678532 -18.145939 0.0 0.0 -1.2239106 -0.29052854 0.0 0.0 -26.954426
   -2.0772939 0.0 0.0 -24.125586 -6.758797 0.0 0.0 -1.3049551 -0.24721539 0.0
   0.0 -1.3105035 -0.048780654 0.0 0.0 -1.1622006 0.55066437 0.0 0.0 -550.7796
   78.89863 0.0 0.0 -25.888744 7.7711806 0.0 0.0 -1.4589462 -0.89095706 0.0 0.0
   -1.259762 0.42257625 0.0 0.0 -1.2816384 -0.38778836 0.0 0.0 -51.09371
   24.33579 0.0 0.0 -599.89825 -6.983372 0.0 0.0 -1.3258307 0.18387084 0.0 0.0
   -1.2684864 0.3175268 0.0 0.0 -555.38776 -48.13955 0.0 0.0 -1.2242124
   -0.067457326 0.0 0.0 -1.0568056 0.8116399 0.0 0.0 -1.2936952 0.33290288 0.0
   0.0 -1.2322145 -0.5027015 0.0 0.0 -1.3360935 0.025502719 0.0 0.0 -1.3593398
   0.0312595 0.0 0.0 -1.5835984 0.3724937 0.0 0.0 -25.799622 -6.409841 0.0 0.0
   -25.581161 -7.184213 0.0 0.0 -1.0345694 -0.73706377 0.0 0.0 -1.3270117
   -0.65804976 0.0 0.0 -22.206036 -14.033147 0.0 0.0 -1.3343717 -0.080357976 0.0
   0.0 -21.548502 -8.795478 0.0 0.0 -559.2358 -4.343699 0.0 0.0 -1.2218678
   -0.40822884 0.0 0.0 -635.42474 132.10262 0.0 0.0 -1.2663393 -0.46701086 0.0
   0.0 -0.801682 0.9795708 0.0 0.0 -1.340068 -0.034151968 0.0 0.0 -558.6172
   -38.85127 0.0 0.0 -21.799425 16.087255 0.0 0.0 -1.1442622 -0.6999111 0.0 0.0
   -24.915056 3.9131598 0.0 0.0 -1.217035 -0.5324115 0.0 0.0 -0.9681138
   0.7833059 0.0 0.0 -24.825539 -4.530148 0.0 0.0 -27.165756 -0.34063092 0.0 0.0
   -30.953247 -13.856996 0.0 0.0 -1.3041198 -0.11368964 0.0 0.0 -28.836569
   4.375487 0.0 0.0 -1.298615 0.113278665 0.0 0.0 -24.1243 -0.5687343 0.0 0.0
   -1.3499448 0.55913866 0.0 0.0 -1.2977338 -0.33968067 0.0 0.0 -1.2731373
   0.15391348 0.0 0.0 -1.2017343 -0.5154783 0.0 0.0 -29.263744 -0.77770233 0.0
   0.0 -0.72156894 -1.0503206 0.0 0.0 -519.78687 310.85645 0.0 0.0 -1.2862433
   0.372994 0.0 0.0 -465.5955 -315.58228 0.0 0.0 -499.18246 153.48183 0.0 0.0
   -29.625923 -10.887073 0.0 0.0 -26.339443 -3.719438 0.0 0.0 -1.3797208
   0.27141115 0.0 0.0 -1.2003527 -0.026653685 0.0 0.0 -22.15796 9.167454 0.0 0.0
   -1.6425996 -0.65909535 0.0 0.0 -683.89435 -168.96141 0.0 0.0 -14.311577
   -12.017641 0.0 0.0 -1.2615948 -0.4476653 0.0 0.0 -22.953156 -10.624109 0.0
   0.0 -21.254194 3.4092824 0.0 0.0 -0.863511 -1.0060338 0.0 0.0 -29.81233
   21.345074 0.0 0.0 -0.98751724 3.7741847e-4 0.0 0.0 -626.3549 -78.77912 0.0
   0.0 -1.1355046 0.20290336 0.0 0.0 -1.2979012 0.11272368 0.0 0.0 -31.035103
   -9.80094 0.0 0.0 -1.2339723 0.4222938 0.0 0.0 -1.2872511 -0.3352135 0.0 0.0
   -1.2158397 -0.4025352 0.0 0.0 -1.1255252 -0.06463586 0.0 0.0 -1.1298467
   0.6736803 0.0 0.0 -39.682274 -15.486225 0.0 0.0 -1.5498259 -0.07943902 0.0
   0.0 -1.1175674 -0.5658994 0.0 0.0 -0.8057784 -0.7972568 0.0 0.0 -1.306592
   0.24994385 0.0 0.0 -1.3232371 -0.2187807 0.0 0.0 -1.2448746 -0.29275188 0.0
   0.0 -40.161877 -35.072556 0.0 0.0 -1.5705854 0.27993092 0.0 0.0 -1.3041304
   0.14833619 0.0 0.0 -1.2413365 0.18851899 0.0 0.0 -1.1129318 -0.06367807 0.0
   0.0 -25.486834 8.010058 0.0 0.0 -561.74347 77.118286 0.0 0.0 -1.7475098
   -0.7637877 0.0 0.0 -27.254688 2.0741549 0.0 0.0 -41.837223 -7.3894467 0.0 0.0
   -438.76135 -291.25394 0.0 0.0 -643.11237 -144.37555 0.0 0.0 -22.966263
   -10.83097 0.0 0.0 -1.3078828 0.2856871 0.0 0.0 -40.992672 18.211946 0.0 0.0
   -29.339811 -2.8119183 0.0 0.0 -26.019926 -8.453305 0.0 0.0 -1.2943187
   0.11648312 0.0 0.0 -1.2757845 0.3628814 0.0 0.0 -1.3288198 -0.16868395 0.0
   0.0 -1.3268399 -0.08528422 0.0 0.0 -760.9121 -98.26889 0.0 0.0 -1.266731
   -0.41016537 0.0 0.0 -503.0318 -160.5311 0.0 0.0 -1.095206 -0.25419402 0.0 0.0
   -1.2603766 -0.14606763 0.0 0.0 -23.032454 0.9123485 0.0 0.0 -1.2573917
   -0.46777007 0.0 0.0 -514.4815 121.19094 0.0 0.0 -20.161367 15.3729105 0.0 0.0
   -1.3227297 0.08290886 0.0 0.0 -488.44223 -202.8382 0.0 0.0 -23.621346
   0.25611573 0.0 0.0 -1.1731142 -0.6013211 0.0 0.0 -22.258247 7.459004 0.0 0.0
   -1.4764093 -0.2896351 0.0 0.0 -0.96345663 -0.018873418 0.0 0.0 -1.1902205
   0.35269526 0.0 0.0 -0.87043744 -0.21434024 0.0 0.0 -18.991026 -16.965378 0.0
   0.0 -1.2348467 0.42244494 0.0 0.0 -1.1133552 -0.02976378 0.0 0.0 -1.3041816
   -0.30106926 0.0 0.0 -455.97015 -270.51157 0.0 0.0 -1.3259342 0.19208276 0.0
   0.0 -428.76242 -312.2118 0.0 0.0 -26.708452 -2.488186 0.0 0.0 -28.16174
   8.955822 0.0 0.0 -0.7775393 -0.92587465 0.0 0.0 -27.751003 4.2293878 0.0 0.0
   -553.35986 -146.00418 0.0 0.0 -22.973766 -10.644688 0.0 0.0 -1.2989821
   -0.2574198 0.0 0.0 -17.655653 -15.562142 0.0 0.0 -26.676022 0.18409199 0.0
   0.0 -26.812922 1.758364 0.0 0.0 -1.1535704 0.6020219 0.0 0.0 -1.0256047
   -0.46561506 0.0 0.0 -26.890396 -1.1609571 0.0 0.0 -23.23733 -4.59233 0.0 0.0
   -529.03253 -56.159184 0.0 0.0 -22.939146 -5.3694677 0.0 0.0 -1.3002547
   -0.051846802 0.0 0.0 -27.462711 1.5134816 0.0 0.0 -26.205145 5.939858 0.0 0.0
   -1.2580819 0.41644803 0.0 0.0 -1.3371847 -0.054999366 0.0 0.0 -574.48224
   230.98424 0.0 0.0 -29.081896 4.065713 0.0 0.0 -1.1978106 -0.53860956 0.0 0.0
   -23.944366 -10.296777 0.0 0.0 -1326.177 -499.53317 0.0 0.0 -1.3286293
   -0.1612007 0.0 0.0 -1.3108212 -0.21075536 0.0 0.0 -26.696154 -1.0882396 0.0
   0.0 -25.78946 7.5574317 0.0 0.0 -27.1848 4.422452 0.0 0.0 -1.3019106
   -0.3080823 0.0 0.0 -22.931728 -6.114542 0.0 0.0 -1.3254638 0.06421108 0.0 0.0
   -25.262697 9.476344 0.0 0.0 -26.921719 1.8801185 0.0 0.0 -1.2097967 0.4725254
   0.0 0.0 -1.1169764 0.66244304 0.0 0.0 -1.2962132 0.32641956 0.0 0.0
   -1.0935876 -0.5749208 0.0 0.0 -0.9589754 -0.90045094 0.0 0.0 -1.3363472
   -0.09283396 0.0 0.0 -534.8792 -12.539582 0.0 0.0 -534.1617 32.24855 0.0 0.0
   -20.356714 -12.1961155 0.0 0.0 -27.173283 -4.810086 0.0 0.0 -34.326168
   4.100992 0.0 0.0 -0.624544 -1.1109655 0.0 0.0 -24.683762 -6.8364997 0.0 0.0
   -1.2798129 0.26483247 0.0 0.0 -25.590755 -1.338388 0.0 0.0 -21.916107
   16.71846 0.0 0.0 -587.0709 -209.60408 0.0 0.0 -1.2739515 -0.31569102 0.0 0.0
   -471.28323 255.99835 0.0 0.0 -25.152855 -8.833602 0.0 0.0 -22.682405
   13.445608 0.0 0.0 -1.241239 0.22105242 0.0 0.0 -31.946022 -14.500781 0.0 0.0
   -559.58453 -148.4505 0.0 0.0 -25.084293 5.369095 0.0 0.0 -1.3397734
   -0.06818315 0.0 0.0 -34.40123 -2.9689164 0.0 0.0 -23.30746 10.288884 0.0 0.0
   -1.3246768 -0.07809877 0.0 0.0 -1.1236929 -0.38817018 0.0 0.0 -23.427269
   -4.221522 0.0 0.0 -1.2165833 -0.3710855 0.0 0.0 -1.4727833 0.32852438 0.0 0.0
   -535.85846 47.3644 0.0 0.0 -1.263812 0.38247666 0.0 0.0 -433.03244 -319.53677
   0.0 0.0 -1.3207006 -0.009396198 0.0 0.0 -26.5658 -5.163473 0.0 0.0 -1.6463038
   0.83612937 0.0 0.0 -1.324496 0.20315765 0.0 0.0 -21.127743 -14.667319 0.0 0.0
   -1.3132976 -0.19751891 0.0 0.0 -27.589968 2.5708666 0.0 0.0 -458.06998
   -284.1251 0.0 0.0 -1.2549859 -0.16319987 0.0 0.0 -28.754593 -1.652416 0.0 0.0
   -24.5155 -11.062802 0.0 0.0 -1.2960911 -0.21852824 0.0 0.0 -1.1798965
   0.5408682 0.0 0.0 -26.133762 -3.694759 0.0 0.0 -25.610924 -2.4083624 0.0 0.0
   -489.68347 227.38 0.0 0.0 -1.312122 0.25139162 0.0 0.0 -1.2468903 -0.4148074
   0.0 0.0 -30.53785 10.316092 0.0 0.0 -539.83 23.330305 0.0 0.0 -0.6507667
   -0.3693653 0.0 0.0 -1.2215638 -0.5104467 0.0 0.0 -1.4734088 0.3215373 0.0 0.0
   -1.3009288 0.2991833 0.0 0.0 -1.2941595 -0.2991733 0.0 0.0 -27.118912
   -1.0763267 0.0 0.0 -32.952854 -4.1714764 0.0 0.0 -1.3137884 -0.22056827 0.0
   0.0 -1.4116789 -0.39099935 0.0 0.0 -1.3320026 0.15269135 0.0 0.0 -1.2680964
   0.34361598 0.0 0.0 -26.609135 -3.6742165 0.0 0.0 -1.1598692 -0.65750647 0.0
   0.0 -31.98289 4.557268 0.0 0.0 -24.946167 -10.317103 0.0 0.0 -25.464071
   -3.526489 0.0 0.0 -25.74729 -4.3798976 0.0 0.0 -26.86891 -7.1573567 0.0 0.0
   -1.2599854 0.32423213 0.0 0.0 -26.886093 -3.7060616 0.0 0.0 -1.3847069
   -0.14825918 0.0 0.0 -28.36161 6.8593397 0.0 0.0 -25.040565 -6.220491 0.0 0.0
   -1.0092775 -0.81833506 0.0 0.0 -1.5062271 0.10687328 0.0 0.0 -1.1385095
   0.53731173 0.0 0.0 -1.3199773 0.010421257 0.0 0.0 -1.6064367 0.05718839 0.0
   0.0 -1.2305014 -0.46915567 0.0 0.0 -1.310816 0.20392264 0.0 0.0 -499.35812
   215.07457 0.0 0.0 -542.5332 -179.1097 0.0 0.0 -1.3308836 -0.11347355 0.0 0.0
   -1.2737546 0.32887748 0.0 0.0 -1.148657 -0.6803078 0.0 0.0 -0.9055039
   -0.9858548 0.0 0.0 -1.2955306 0.5841903 0.0 0.0 -24.852499 6.6911306 0.0 0.0
   -27.209988 0.33028474 0.0 0.0 -1.2300099 0.095618114 0.0 0.0 -1.3391824
   0.06913046 0.0 0.0 -0.8652782 -0.31742844 0.0 0.0 -1.230862 0.5267653 0.0 0.0
   -1.0565445 -0.6506668 0.0 0.0 -33.31059 0.92610675 0.0 0.0 -1.3608775
   -0.55094105 0.0 0.0 -537.7498 -91.326 0.0 0.0 -27.801527 -2.0349813 0.0 0.0
   -25.197807 -20.426754 0.0 0.0 -1.1577483 0.48489448 0.0 0.0 -22.785803
   -11.752387 0.0 0.0 -458.2948 -296.77725 0.0 0.0 -1.1975912 -0.4219731 0.0 0.0
   -1.2237598 0.48980922 0.0 0.0 -26.602686 5.414448 0.0 0.0 -42.44823 11.60799
   0.0 0.0 -26.848347 4.855465 0.0 0.0 -27.003878 -7.1552415 0.0 0.0 -1.2337502
   -0.61542904 0.0 0.0 -1.0522428 -0.18366832 0.0 0.0 -26.47576 6.6779327 0.0
   0.0 -741.965 -1.8909994 0.0 0.0 -1.2924966 0.35559314 0.0 0.0 -1.2925788
   -0.075634375 0.0 0.0 -21.611387 -10.469261 0.0 0.0 -1.2929413 -0.22967443 0.0
   0.0 -1.3145068 0.009685327 0.0 0.0 -558.04114 194.98271 0.0 0.0 -1.2188191
   0.4506398 0.0 0.0 -1.3413554 -0.012823652 0.0 0.0 -1.2552963 0.4491834 0.0
   0.0 -1.2689302 -0.19683158 0.0 0.0 -1.1235071 0.04710364 0.0 0.0 -1.5736457
   -0.2169011 0.0 0.0 -26.24634 -7.0200443 0.0 0.0 -23.952833 12.087228 0.0 0.0
   -1.3167914 -0.08648543 0.0 0.0 -27.88975 2.4886112 0.0 0.0 -1.3391802
   -0.05856924 0.0 0.0 -1.2390969 -0.5111558 0.0 0.0 -1.1889213 -0.4923124 0.0
   0.0 -21.037916 -17.250265 0.0 0.0 -14.784579 18.784399 0.0 0.0 -18.921146
   15.419846 0.0 0.0 -1.2735025 -0.35664472 0.0 0.0 -27.106451 3.7091734 0.0 0.0
   -28.457314 -11.383524 0.0 0.0 -1.0414939 0.658617 0.0 0.0 -1.2393361
   0.3600785 0.0 0.0 -1.2746719 -0.3693043 0.0 0.0 -33.440247 11.069816 0.0 0.0
   -1.3063953 0.28004384 0.0 0.0 -40.49078 -17.9138 0.0 0.0 -1.5419624
   0.45161286 0.0 0.0 -1.2740469 -0.06359518 0.0 0.0 -0.69517577 0.17530282 0.0
   0.0 -1.2820568 -0.37396696 0.0 0.0 -1.1283664 -0.2424719 0.0 0.0 -0.8855869
   0.10616398 0.0 0.0 -1.2114078 0.45080692 0.0 0.0 -1.243207 0.0765886 0.0 0.0
   -1.3267248 -0.037249595 0.0 0.0 -35.298428 14.280339 0.0 0.0 -1.3244181
   -0.20365892 0.0 0.0 -28.497631 -6.7015944 0.0 0.0 -26.75088 -8.560288 0.0 0.0
   -0.583256 -1.2014498 0.0 0.0 -1.1188589 -0.69314724 0.0 0.0 -28.341269
   -25.36709 0.0 0.0 -1.2659894 -0.55512524 0.0 0.0 -26.937302 -5.179945 0.0 0.0
   -0.9972019 0.8537863 0.0 0.0 -26.2403 -8.050935 0.0 0.0 -1.0818777 -0.6889695
   0.0 0.0 -0.9302316 -0.05365789 0.0 0.0 -26.93105 -5.186817 0.0 0.0 -26.41969
   -7.41623 0.0 0.0 -1.2984784 -0.27640045 0.0 0.0 -36.28554 11.824365 0.0 0.0
   -583.4418 -380.3362 0.0 0.0 -1.3349187 0.095698886 0.0 0.0 -1.2901726
   0.22543819 0.0 0.0 -548.91296 -73.20475 0.0 0.0 -26.8115 5.9220595 0.0 0.0
   -21.266514 -11.100978 0.0 0.0 -1.333818 -0.060106542 0.0 0.0 -1.1928754
   0.3805595 0.0 0.0 -0.9042397 0.39612755 0.0 0.0 -48.057117 -1.1000663 0.0 0.0
   -1.2606281 -1.2308464 0.0 0.0 -26.769306 -8.681 0.0 0.0 -1.3026108
   -0.116492726 0.0 0.0 -551.6093 -60.090336 0.0 0.0 -1.1641393 -0.59173626 0.0
   0.0 -1.3389363 -0.023212435 0.0 0.0 -24.08134 -0.04035455 0.0 0.0 -586.6365
   124.05795 0.0 0.0 -25.838106 -3.651025 0.0 0.0 -1.3190395 -0.14808813 0.0 0.0
   -1.1987959 -0.521151 0.0 0.0 -30.555412 -6.157038 0.0 0.0 -23.139364
   -12.10555 0.0 0.0 -1.2264184 0.1407837 0.0 0.0 -0.80685985 -0.32541066 0.0
   0.0 -1.2913157 -0.12733515 0.0 0.0 -543.4347 -118.96677 0.0 0.0 -1.2724375
   -0.34807244 0.0 0.0 -1.2444341 0.3228322 0.0 0.0 -28.209696 0.9570304 0.0 0.0
   -40.64102 -7.8266587 0.0 0.0 -1.3164794 -0.2050383 0.0 0.0 -1.3135846
   -0.55150497 0.0 0.0 -1.335698 -0.008283589 0.0 0.0 -1.335537 0.06357447 0.0
   0.0 -27.53699 -0.8749998 0.0 0.0 -19.53479 19.32363 0.0 0.0 -0.98486227
   -0.758715 0.0 0.0 -23.928776 3.662935 0.0 0.0 -1.1723778 -0.044622663 0.0 0.0
   -1.2796782 0.13303493 0.0 0.0 -1.0565733 -0.6230111 0.0 0.0 -0.75706655
   -0.93637633 0.0 0.0 -1.0962043 -0.76741064 0.0 0.0 -0.990313 -0.8811839 0.0
   0.0 -1.399102 -0.08894998 0.0 0.0 -30.413076 -2.5498 0.0 0.0 -20.912458
   -12.276104 0.0 0.0 -24.015516 -3.4515293 0.0 0.0 -24.171156 0.27126816 0.0
   0.0 -1.2523477 -0.4316345 0.0 0.0 -1.3318028 -0.089397565 0.0 0.0 -1.2909559
   0.26052016 0.0 0.0 -36.207024 17.110462 0.0 0.0 -1.3382578 -0.028863816 0.0
   0.0 -1.3283763 0.1860133 0.0 0.0 -26.757725 0.67664546 0.0 0.0 -533.8105
   -283.7933 0.0 0.0 -26.60639 -6.0862193 0.0 0.0 -37.130013 30.76039 0.0 0.0
   -801.0585 190.44778 0.0 0.0 -33.794476 -10.781391 0.0 0.0 -1.305199
   0.11829637 0.0 0.0 -521.12225 206.0744 0.0 0.0 -1.3187286 0.15465704 0.0 0.0
   -1.3229562 0.21462609 0.0 0.0 -536.1188 281.81595 0.0 0.0 -27.304802
   -1.0428294 0.0 0.0 -31.3602 -10.415019 0.0 0.0 -1.2101623 0.35437158 0.0 0.0
   -38.092014 -5.985571 0.0 0.0 -1.0483866 -0.5379355 0.0 0.0 -561.08655
   -18.27461 0.0 0.0 -34.410236 -17.326555 0.0 0.0 -26.331652 -7.2430277 0.0 0.0
   -27.582104 0.5368711 0.0 0.0 -24.295973 -0.794978 0.0 0.0 -1.069515
   -0.8024985 0.0 0.0 -26.401167 -5.6010184 0.0 0.0 -1.2354474 -0.39682248 0.0
   0.0 -20.79475 -6.600449 0.0 0.0 -1.3153567 0.07677668 0.0 0.0 -1.2708696
   -0.25232905 0.0 0.0 -1.3274604 0.037809066 0.0 0.0 -19.997063 4.5178485 0.0
   0.0 -24.28598 -1.8701657 0.0 0.0 -25.072472 7.701292 0.0 0.0 -34.814754
   -8.295192 0.0 0.0 -606.6902 -45.714756 0.0 0.0 -40.60276 -9.612533 0.0 0.0
   -1.3310897 -0.12731569 0.0 0.0 -21.452429 11.143442 0.0 0.0 -1.2798499
   -0.18649669 0.0 0.0 -1.0278611 -0.36768147 0.0 0.0 -27.670717 -1.0108168 0.0
   0.0 -26.585136 -7.868583 0.0 0.0 -2.3262415 0.361094 0.0 0.0 -1.3185472
   0.20138165 0.0 0.0 -1.1692445 0.1509896 0.0 0.0 -25.50008 10.787297 0.0 0.0
   -27.124006 -4.685564 0.0 0.0 -22.453386 -16.252083 0.0 0.0 -35.126842
   6.342291 0.0 0.0 -1.1311553 -0.6728217 0.0 0.0 -27.025202 8.858472 0.0 0.0
   -0.7573392 0.58408046 0.0 0.0 -1.3342544 -0.11892322 0.0 0.0 -1.1638286
   -0.6295004 0.0 0.0 -28.156902 2.9955041 0.0 0.0 -23.516392 -6.572056 0.0 0.0
   -1.3346856 0.12565823 0.0 0.0 -1.1918949 -0.59976035 0.0 0.0 -32.380817
   -7.3888807 0.0 0.0 -26.378716 0.13260484 0.0 0.0 -26.344034 -8.198281 0.0 0.0
   -1.1531016 -0.03277371 0.0 0.0 -1.2934334 0.3017696 0.0 0.0 -1.3057909
   0.30270243 0.0 0.0 -0.63712806 -1.1325305 0.0 0.0 -1.5050834 0.17212819 0.0
   0.0 -20.928703 -12.428945 0.0 0.0 -1.2623783 -0.2240058 0.0 0.0 -24.353409
   -2.1722226 0.0 0.0 -1.3367479 0.09161 0.0 0.0 -23.8258 5.463456 0.0 0.0
   -1.2904046 0.3649567 0.0 0.0 -0.90867734 -0.89764625 0.0 0.0 -1.393769
   0.27724501 0.0 0.0 -47.44577 8.461398 0.0 0.0 -27.761627 -1.7821496 0.0 0.0
   -32.557888 9.664388 0.0 0.0 -1.3033422 -0.25871125 0.0 0.0 -26.314564
   -6.5807405 0.0 0.0 -26.430761 -4.2457523 0.0 0.0 -1.2847755 -0.3689604 0.0
   0.0 -1.0880071 -0.7022086 0.0 0.0 -653.2299 -119.18089 0.0 0.0 -775.76196
   0.5391081 0.0 0.0 -1.1765102 0.059848975 0.0 0.0 -1.3036764 -0.14752042 0.0
   0.0 -1.232109 0.4562321 0.0 0.0 -1.335458 -0.018231312 0.0 0.0 -1.2375813
   0.49163973 0.0 0.0 -35.500877 -6.3318734 0.0 0.0 -1.3200392 -0.12768452 0.0
   0.0 -1.3058721 -0.21385434 0.0 0.0 -28.43997 12.019596 0.0 0.0 -1.3321363
   0.11380739 0.0 0.0 -26.477507 0.43950886 0.0 0.0 -1.1857728 -0.10511261 0.0
   0.0 -942.3286 -278.0209 0.0 0.0 -1.2139466 -0.5335279 0.0 0.0 -24.373497
   10.221011 0.0 0.0 -27.8762 -8.831523 0.0 0.0 -27.672945 3.2261412 0.0 0.0
   -1.3040482 0.31009197 0.0 0.0 -1.1097733 -0.63380927 0.0 0.0 -19.99584
   -14.132689 0.0 0.0 -1.1052636 -0.102575414 0.0 0.0 -1.3207601 -0.19472839 0.0
   0.0 -1.3252485 -0.18755916 0.0 0.0 -1.4476873 0.15753733 0.0 0.0 -701.1783
   -78.70318 0.0 0.0 -561.36304 -107.17 0.0 0.0 -1.0432357 -0.18224935 0.0 0.0
   -1.2379005 -0.15323702 0.0 0.0 -24.38638 2.8628738 0.0 0.0 -725.4895
   135.76317 0.0 0.0 -2.3042598 -0.58790064 0.0 0.0 -25.45002 -19.255867 0.0 0.0
   -27.316309 5.8215566 0.0 0.0 -1.6009126 0.21466972 0.0 0.0 -0.9424922
   -0.9290167 0.0 0.0 -372.46036 -423.36716 0.0 0.0 -1.2890797 -0.09355444 0.0
   0.0 -1.452618 -0.09692845 0.0 0.0 -1.2805854 -0.32792968 0.0 0.0 -570.31476
   56.08605 0.0 0.0 -35.84767 5.104947 0.0 0.0 -783.1466 -5.185014 0.0 0.0
   -44.556873 -9.82249 0.0 0.0 -1.1457855 0.34525958 0.0 0.0 -38.509514
   7.2206545 0.0 0.0 -27.874928 1.7161725 0.0 0.0 -24.25338 -4.00964 0.0 0.0
   -1.2326022 0.2467861 0.0 0.0 -1.1671904 -0.2461588 0.0 0.0 -1.2465887
   0.20231608 0.0 0.0 -1.2563088 -0.4691856 0.0 0.0 -1.2813252 -0.09057193 0.0
   0.0 -35.384552 -8.071481 0.0 0.0 -24.612543 -0.27923605 0.0 0.0 -1.2668401
   0.1905694 0.0 0.0 -25.629242 -2.914922 0.0 0.0 -26.566366 -1.5221152 0.0 0.0
   -1.3313514 -0.09208809 0.0 0.0 -24.18416 -4.646757 0.0 0.0 -609.2767
   125.42622 0.0 0.0 -1.2189888 0.26305127 0.0 0.0 -1.2213333 0.054597493 0.0
   0.0 -26.285635 2.4518557 0.0 0.0 -1.5098633 0.098716415 0.0 0.0 -1.0971748
   -0.5520138 0.0 0.0 -1.3365042 0.11602443 0.0 0.0 -24.56229 -1.96803 0.0 0.0
   -26.335567 11.638166 0.0 0.0 -595.44073 -315.5212 0.0 0.0 -1.2747134
   0.16237554 0.0 0.0 -1.2771748 0.09037284 0.0 0.0 -513.4026 -437.14218 0.0 0.0
   -25.461462 17.785454 0.0 0.0 -1.3221745 0.1726849 0.0 0.0 -24.653727
   0.6688289 0.0 0.0 -23.207312 -8.352552 0.0 0.0 -1.5951827 -0.2063238 0.0 0.0
   -1.2348691 -0.4956636 0.0 0.0 -19.22037 -18.447586 0.0 0.0 -24.234327
   4.6340985 0.0 0.0 -1.3136562 -0.23310444 0.0 0.0 -669.10266 -94.27679 0.0 0.0
   -674.68945 -39.64896 0.0 0.0 -577.6726 -19.36278 0.0 0.0 -1.253135
   -0.38063055 0.0 0.0 -31.212334 18.79646 0.0 0.0 -0.43829852 -1.225829 0.0 0.0
   -38.827625 18.00873 0.0 0.0 -1.3240255 0.20625326 0.0 0.0 -19.217869
   -15.47768 0.0 0.0 -539.41724 -209.80771 0.0 0.0 -1.2708215 0.13462126 0.0 0.0
   -1.1077684 0.1147085 0.0 0.0 -24.58124 2.5103288 0.0 0.0 -50.069 19.848593
   0.0 0.0 -1.2602385 -0.29349244 0.0 0.0 -31.125595 6.814925 0.0 0.0 -26.42653
   3.6612463 0.0 0.0 -566.54034 -122.736465 0.0 0.0 -1.1351823 -0.53167665 0.0
   0.0 -1.2249439 -0.014238447 0.0 0.0 -1.308876 0.28663796 0.0 0.0 -1.1620836
   -0.12301904 0.0 0.0 -34.31183 -25.38648 0.0 0.0 -21.946144 -11.329846 0.0 0.0
   -27.92175 3.2230039 0.0 0.0 -1.2408447 0.48889077 0.0 0.0 -1.271731 0.3858984
   0.0 0.0 -0.8553151 0.7165587 0.0 0.0 -27.923227 3.4545498 0.0 0.0 -1.2109913
   -0.42037788 0.0 0.0 -1.2392094 0.3421678 0.0 0.0 -1.1859183 -0.59985 0.0 0.0
   -35.82612 7.447015 0.0 0.0 -0.755028 -1.0860745 0.0 0.0 -1.2920613 0.3477129
   0.0 0.0 -28.107662 -0.06697869 0.0 0.0 -29.652206 9.964035 0.0 0.0 -1.1512595
   0.008511081 0.0 0.0 -1.1284045 0.19665493 0.0 0.0 -1.158195 -0.6314389 0.0
   0.0 -1.2622185 -0.305805 0.0 0.0 -1.2553979 0.35648438 0.0 0.0 -25.514292
   5.830528 0.0 0.0 -1.9203929 -0.32544804 0.0 0.0 -1.0581154 0.058794677 0.0
   0.0 -1.2507519 -0.3465175 0.0 0.0 -36.989548 14.187392 0.0 0.0 -1.1274745
   -0.63322145 0.0 0.0 -1.1974101 -0.48171946 0.0 0.0 -24.63801 2.5802712 0.0
   0.0 -30.325521 15.163965 0.0 0.0 -1.3139488 -0.17245972 0.0 0.0 -1.1820272
   -0.519133 0.0 0.0 -738.7944 24.041458 0.0 0.0 -1.3510435 0.36395422 0.0 0.0
   -1161.0248 241.6526 0.0 0.0 -1.253045 0.4740173 0.0 0.0 -20.402378 -4.1340523
   0.0 0.0 -27.923368 -1.9180509 0.0 0.0 -1.3110988 0.26871264 0.0 0.0 -0.970971
   -0.9228704 0.0 0.0 -1.1968946 0.582785 0.0 0.0 -26.235958 5.4777284 0.0 0.0
   -31.237806 -13.32619 0.0 0.0 -23.296783 8.602327 0.0 0.0 -1.2668729
   0.24895118 0.0 0.0 -1.2477157 0.2967754 0.0 0.0 -14.234382 -15.891107 0.0 0.0
   -1.2778367 -0.16770937 0.0 0.0 -0.96611744 0.14178902 0.0 0.0 -721.1869
   -295.29324 0.0 0.0 -26.023745 -1.9194124 0.0 0.0 -1.2825553 0.17340973 0.0
   0.0 -1.3092049 -0.03027606 0.0 0.0 -26.08471 -5.641532 0.0 0.0 -638.3147
   -239.4502 0.0 0.0 -1.332408 0.061465356 0.0 0.0 -1.2320372 -0.28504893 0.0
   0.0 -22.763004 -10.012228 0.0 0.0 -1.1788027 -0.5353042 0.0 0.0 -1.240164
   0.49209762 0.0 0.0 -1.1904379 -0.14672436 0.0 0.0 -22.142124 11.327982 0.0
   0.0 -31.34156 -2.938088 0.0 0.0 -30.328985 8.42055 0.0 0.0 -26.274181
   5.078433 0.0 0.0 -657.60785 -202.07834 0.0 0.0 -1.2433362 -0.44896156 0.0 0.0
   -23.344667 -8.637431 0.0 0.0 -24.741129 2.674918 0.0 0.0 -1.2733502
   -0.37488896 0.0 0.0 -1.281036 -0.10898104 0.0 0.0 -1.327004 -0.08579086 0.0
   0.0 -1.3397696 0.06691174 0.0 0.0 -1.1144364 -0.7343526 0.0 0.0 -1.2538947
   -0.041943442 0.0 0.0 -1.1748464 -0.38279957 0.0 0.0 -22.771101 -13.892595 0.0
   0.0 -1.1788313 -0.6078055 0.0 0.0 -1.2964371 0.19069287 0.0 0.0 -1.0949154
   -0.16085792 0.0 0.0 -1.3324522 0.08147923 0.0 0.0 -1.1655324 -0.64448947 0.0
   0.0 -24.90096 1.1374583 0.0 0.0 -25.656113 7.9327235 0.0 0.0 -0.8080852
   -0.946178 0.0 0.0 -1.3065449 -0.08280924 0.0 0.0 -24.396404 5.1618295 0.0 0.0
   -588.344 -43.679 0.0 0.0 -1.3295913 0.11348267 0.0 0.0 -23.959202 15.074324
   0.0 0.0 -1.2797099 -0.07804092 0.0 0.0 -1.1578186 -0.6377319 0.0 0.0
   -24.688856 2.9521873 0.0 0.0 -0.99112535 0.3670553 0.0 0.0 -27.776505
   -5.7997313 0.0 0.0 -28.370342 -0.1853823 0.0 0.0 -23.947926 16.673986 0.0 0.0
   -42.430458 8.808087 0.0 0.0 -29.22069 0.4585462 0.0 0.0 -1.1999468 -0.4829485
   0.0 0.0 -27.92824 -5.0210032 0.0 0.0 -1.3182685 0.048052974 0.0 0.0
   -25.715286 -7.95242 0.0 0.0 -1.2431185 0.29666117 0.0 0.0 -1.13501 0.6559643
   0.0 0.0 -742.87646 -329.92947 0.0 0.0 -1.2563379 0.40226418 0.0 0.0
   -629.95056 119.00445 0.0 0.0 -28.246426 1.7645423 0.0 0.0 -1.2873474
   -0.3411547 0.0 0.0 -28.68281 16.018997 0.0 0.0 -1.2268983 -0.23313151 0.0 0.0
   -1.3040109 -0.09750307 0.0 0.0 -46.163696 -20.96944 0.0 0.0 -26.649734
   9.907911 0.0 0.0 -29.338974 -6.292267 0.0 0.0 -1.057321 0.7949669 0.0 0.0
   -555.35394 -418.55856 0.0 0.0 -499.10873 321.11667 0.0 0.0 -1.2427273
   -0.002108276 0.0 0.0 -1.3254662 -0.20443895 0.0 0.0 -1.0309674 0.81272674 0.0
   0.0 -31.11261 -6.130998 0.0 0.0 -1.2590362 0.1163534 0.0 0.0 -24.30826
   5.855596 0.0 0.0 -17.834436 -14.537118 0.0 0.0 -1.1475985 0.64363235 0.0 0.0
   -34.476894 1.6562395 0.0 0.0 -1.2924125 -0.18775193 0.0 0.0 -23.877832
   7.5238404 0.0 0.0 -593.0282 46.547634 0.0 0.0 -1.0669236 -0.7430068 0.0 0.0
   -1.0729333 -0.12781684 0.0 0.0 -1.2948036 -0.33056822 0.0 0.0 -28.46417
   0.24089046 0.0 0.0 -1.3056993 -0.28726333 0.0 0.0 -609.4836 -210.49612 0.0
   0.0 -1.2265445 0.15422107 0.0 0.0 -34.807636 5.215666 0.0 0.0 -1.3084117
   0.10669601 0.0 0.0 -1.0925282 -0.74268377 0.0 0.0 -27.74896 -6.4476852 0.0
   0.0 -1.2615744 -0.16987503 0.0 0.0 -1.0808337 0.7617637 0.0 0.0 -25.33513
   -9.724247 0.0 0.0 -1.2247349 0.3805231 0.0 0.0 -1.2165334 -0.3285459 0.0 0.0
   -0.8182696 -1.0348226 0.0 0.0 -1.2445037 -0.39228633 0.0 0.0 -1.0303895
   -0.82320935 0.0 0.0 -1.3344489 -0.1304244 0.0 0.0 -33.524445 -4.8943276 0.0
   0.0 -25.632818 -12.374374 0.0 0.0 -513.0771 306.15195 0.0 0.0 -26.540403
   -5.7956386 0.0 0.0 -34.73671 -5.8747125 0.0 0.0 -638.8611 104.67101 0.0 0.0
   -1.3319448 -0.07612219 0.0 0.0 -21.167976 19.09312 0.0 0.0 -588.63165
   -270.39258 0.0 0.0 -1.290187 -0.14919128 0.0 0.0 -1.1845498 -0.60292774 0.0
   0.0 -26.852003 2.9829478 0.0 0.0 -1.0846993 -0.20915323 0.0 0.0 -926.62646
   -272.59933 0.0 0.0 -1.2168826 -0.34989363 0.0 0.0 -1.3356367 0.10910795 0.0
   0.0 -1.2946818 -0.2933476 0.0 0.0 -1.2931176 -0.35661814 0.0 0.0 -1.3296105
   -0.14833145 0.0 0.0 -1.0260291 -0.83074814 0.0 0.0 -893.22864 -13.001839 0.0
   0.0 -1.2508719 0.156573 0.0 0.0 -1.2911779 -0.27934572 0.0 0.0 -23.784294
   8.0798025 0.0 0.0 -24.945671 3.1192036 0.0 0.0 -28.14461 -21.389442 0.0 0.0
   -26.644686 7.2363687 0.0 0.0 -21.996925 -11.423295 0.0 0.0 -50.813618
   0.19030765 0.0 0.0 -629.22266 -164.89433 0.0 0.0 -1.0372862 -0.5765212 0.0
   0.0 -1.3015679 0.32008448 0.0 0.0 -40.577324 -4.996738 0.0 0.0 -1.3218244
   0.027286468 0.0 0.0 -1.058118 -0.8197245 0.0 0.0 -1.0654601 -0.7793922 0.0
   0.0 -47.475838 -2.9545407 0.0 0.0 -2.6821878 0.7484733 0.0 0.0 -1.3344493
   0.13260815 0.0 0.0 -1.0771326 -0.6596474 0.0 0.0 -1.2240064 -0.48293057 0.0
   0.0 -28.339169 -3.9291232 0.0 0.0 -1.3291434 0.12514932 0.0 0.0 -1.1516787
   -0.005823061 0.0 0.0 -34.246586 -9.089588 0.0 0.0 -1.3144987 0.1746255 0.0
   0.0 -1.2795624 -0.30929348 0.0 0.0 -599.3031 -63.187824 0.0 0.0 -573.866
   -184.31773 0.0 0.0 -1.0530998 -0.7920498 0.0 0.0 -1.3329439 0.013584141 0.0
   0.0 -1.7695962 -0.53082263 0.0 0.0 -27.073915 -0.8459981 0.0 0.0 -1.2500336
   0.043297224 0.0 0.0 -31.683302 -7.235814 0.0 0.0 -18.0924 17.510872 0.0 0.0
   -24.155598 20.971762 0.0 0.0 -29.045155 -5.6062403 0.0 0.0 -1.3357223
   -0.10785497 0.0 0.0 -25.266594 13.570379 0.0 0.0 -1.2981796 0.33849117 0.0
   0.0 -26.527637 -10.720275 0.0 0.0 -1.3402884 -0.024127806 0.0 0.0 -947.0167
   473.6564 0.0 0.0 -0.98257095 0.731958 0.0 0.0 -25.623472 -9.493727 0.0 0.0
   -1.2742524 -0.41304937 0.0 0.0 -40.803505 3.2976806 0.0 0.0 -1.3196366
   0.04996868 0.0 0.0 -1.045639 0.8289957 0.0 0.0 -695.70514 -144.16968 0.0 0.0
   -1.0951405 0.4404095 0.0 0.0 -1.2833576 0.21568902 0.0 0.0 -1.0395073
   -0.40134856 0.0 0.0 -1243.0151 -91.05382 0.0 0.0 -1.2755282 -0.28623444 0.0
   0.0 -1.281812 -0.3558756 0.0 0.0 -605.90173 -14.293811 0.0 0.0 -1.3383859
   0.031632617 0.0 0.0 -1.2852541 0.08704683 0.0 0.0 -604.5219 -47.883194 0.0
   0.0 -26.988287 -12.240911 0.0 0.0 -21.64481 -5.430304 0.0 0.0 -1.3243246
   -0.1293259 0.0 0.0 -1.3207916 0.13073601 0.0 0.0 -1.335839 0.09489733 0.0 0.0
   -26.834309 -11.720513 0.0 0.0 -21.469694 -12.147309 0.0 0.0 -1.2305647
   -0.057638798 0.0 0.0 -1.3321804 0.10449505 0.0 0.0 -94.469765 -1.0669742 0.0
   0.0 -31.507687 6.4363174 0.0 0.0 -1.276744 0.41073054 0.0 0.0 -0.7393993
   -0.5164399 0.0 0.0 -601.7783 86.94603 0.0 0.0 -0.9631257 -0.8087563 0.0 0.0
   -980.1733 97.32037 0.0 0.0 -37.510548 -4.356639 0.0 0.0 -653.6771 -86.6921
   0.0 0.0 -1.338881 0.02050396 0.0 0.0 -902.09015 118.05195 0.0 0.0 -1.1386411
   -0.04065818 0.0 0.0 -1.4882157 -1.4354115 0.0 0.0 -26.98016 10.113163 0.0 0.0
   -27.893295 -7.1364603 0.0 0.0 -22.580519 11.364104 0.0 0.0 -1.1966952
   -0.5846536 0.0 0.0 -1.295896 -0.18453503 0.0 0.0 -37.70893 -2.6413522 0.0 0.0
   -75.29843 -2.032657 0.0 0.0 -27.422878 -1.5238762 0.0 0.0 -1.2907051
   0.10759546 0.0 0.0 -1.3315818 0.11823813 0.0 0.0 -27.099201 9.042982 0.0 0.0
   -1.4979544 -0.1328155 0.0 0.0 -28.53857 4.2081275 0.0 0.0 -32.222324
   -0.8868616 0.0 0.0 -1.3316176 -0.14743118 0.0 0.0 -1.2238709 -1.0082626 0.0
   0.0 -34.67632 -7.524564 0.0 0.0 -25.711872 12.872718 0.0 0.0 -37.711777
   -3.0359771 0.0 0.0 -29.787762 -0.4353632 0.0 0.0 -1.2203478 -0.5535373 0.0
   0.0 -1.1513028 0.45007405 0.0 0.0 -1.3178345 -0.20864443 0.0 0.0 -27.421818
   -0.14800736 0.0 0.0 -19.422081 16.355871 0.0 0.0 -1.2724968 0.010334969 0.0
   0.0 -1.2880383 -0.34011337 0.0 0.0 -1.3622613 -0.8795176 0.0 0.0 -1.1125723
   -0.7417563 0.0 0.0 -0.695766 0.510694 0.0 0.0 -27.55604 8.637413 0.0 0.0
   -0.88837546 -0.23564163 0.0 0.0 -24.922352 4.9647393 0.0 0.0 -1.1727537
   -0.5164799 0.0 0.0 -25.043726 4.1951485 0.0 0.0 -29.591196 3.7427704 0.0 0.0
   -1.0735703 -0.7784754 0.0 0.0 -1.085984 -0.7539338 0.0 0.0 -1.3397675
   0.04668631 0.0 0.0 -27.986017 3.199383 0.0 0.0 -35.836666 -0.18102965 0.0 0.0
   -1.3316276 -0.088356495 0.0 0.0 -531.6974 -400.27066 0.0 0.0 -1.2301757
   0.25801134 0.0 0.0 -1.317167 0.25414398 0.0 0.0 -1.2010409 -0.59254116 0.0
   0.0 -1.1600903 -0.59174967 0.0 0.0 -1.2114339 -0.28833863 0.0 0.0 -781.68024
   47.19171 0.0 0.0 -1583.1316 -345.11902 0.0 0.0 -618.1495 -249.403 0.0 0.0
   -25.29781 13.821602 0.0 0.0 -1.2857469 0.3240411 0.0 0.0 -28.01788 -22.122946
   0.0 0.0 -1.1649417 -0.45149833 0.0 0.0 -722.7781 29.452631 0.0 0.0 -1.3295597
   -0.17467098 0.0 0.0 -1.2475735 -0.3616412 0.0 0.0 -15.898961 7.7295513 0.0
   0.0 -0.9103461 -0.9442441 0.0 0.0 -1.2320782 -0.5204012 0.0 0.0 -1.2039909
   -0.5473203 0.0 0.0 -1.2317683 -0.34043798 0.0 0.0 -28.069454 7.0197334 0.0
   0.0 -27.07828 -5.167211 0.0 0.0 -1.2726022 -0.10059899 0.0 0.0 -1.2983949
   -0.21705535 0.0 0.0 -1.2491856 0.101841815 0.0 0.0 -1.2405033 -0.38370892 0.0
   0.0 -35.53723 5.0594954 0.0 0.0 -25.623371 15.375329 0.0 0.0 -1.1499196
   0.48238158 0.0 0.0 -1.3301994 0.13142735 0.0 0.0 -576.76373 -220.59294 0.0
   0.0 -1.2229702 0.04399423 0.0 0.0 -0.9519672 -0.94463676 0.0 0.0 -23.735298
   9.190299 0.0 0.0 -1.2039233 -0.34963843 0.0 0.0 -0.98572195 -0.7710519 0.0
   0.0 -15.9582615 5.3640203 0.0 0.0 -25.674526 15.424175 0.0 0.0 -0.86212426
   -1.0144936 0.0 0.0 -0.85717595 0.97542185 0.0 0.0 -1.3383676 0.009283382 0.0
   0.0 -1.3136907 -0.15202986 0.0 0.0 -27.628763 1.7039657 0.0 0.0 -27.91275
   -5.080638 0.0 0.0 -26.371326 -8.280779 0.0 0.0 -1.2976904 0.32286268 0.0 0.0
   -1.2802608 -0.39398134 0.0 0.0 -1.1171497 -0.6870372 0.0 0.0 -28.634317
   -3.4030805 0.0 0.0 -41.595825 -0.31040514 0.0 0.0 -1.313116 -0.06909342 0.0
   0.0 -1.306963 -0.15277466 0.0 0.0 -34.545418 -6.6987724 0.0 0.0 -1.2458203
   -0.22066738 0.0 0.0 -24.724396 6.5153427 0.0 0.0 -23.583363 5.0135593 0.0 0.0
   -27.584375 2.7502565 0.0 0.0 -1.2027187 -0.5813534 0.0 0.0 -29.956684
   2.4838922 0.0 0.0 -1.4912382 -0.054284524 0.0 0.0 -1.0054506 0.8740703 0.0
   0.0 -1.22297 0.4747222 0.0 0.0 -1.3066822 -0.16115202 0.0 0.0 -765.03674
   -207.72395 0.0 0.0 -1.3013283 0.051378965 0.0 0.0 -1.3115057 -0.13904838 0.0
   0.0 -1.2547232 -0.43413398 0.0 0.0 -26.813377 -6.670275 0.0 0.0 -28.858145
   3.687038 0.0 0.0 -1.2088437 0.42101288 0.0 0.0 -1.2879298 0.08998019 0.0 0.0
   -35.715458 -5.04519 0.0 0.0 -23.34742 16.42434 0.0 0.0 -1.4723191 -0.38231257
   0.0 0.0 -44.880898 -4.7691736 0.0 0.0 -27.77275 -0.36034688 0.0 0.0
   -30.107502 -0.5046868 0.0 0.0 -34.1914 2.4628904 0.0 0.0 -28.310972 -6.89976
   0.0 0.0 -29.12829 -7.6769924 0.0 0.0 -1.3155458 -0.26286426 0.0 0.0
   -1.1322143 -0.6621512 0.0 0.0 -29.947332 -3.344875 0.0 0.0 -25.651949
   -13.704894 0.0 0.0 -26.25074 9.018816 0.0 0.0 -28.854555 -4.0624466 0.0 0.0
   -1.3131124 -0.5059119 0.0 0.0 -1.2044705 -0.45649043 0.0 0.0 -677.1033
   -11.126946 0.0 0.0 -1.1491387 -0.6236293 0.0 0.0 -1.2226151 0.52101177 0.0
   0.0 -25.552658 -2.291597 0.0 0.0 -624.76984 262.62103 0.0 0.0 -1.2823263
   -0.28199115 0.0 0.0 -25.43545 -3.366069 0.0 0.0 -567.3604 262.344 0.0 0.0
   -1.2456416 -0.32800257 0.0 0.0 -25.543133 -2.4771388 0.0 0.0 -27.817179
   1.0672588 0.0 0.0 -28.591778 9.695218 0.0 0.0 -1.4482527 -0.3843349 0.0 0.0
   -25.674475 -0.312687 0.0 0.0 -1.2984695 0.23634878 0.0 0.0 -1.2324624
   0.074379005 0.0 0.0 -0.9736061 -0.5659586 0.0 0.0 -2.2366798 0.3469177 0.0
   0.0 -29.134598 -1.5907416 0.0 0.0 -28.947392 16.858631 0.0 0.0 -32.691372
   -2.0425837 0.0 0.0 -1.3226905 -0.18471931 0.0 0.0 -1.33369 -0.048854873 0.0
   0.0 -1.8359215 0.2954379 0.0 0.0 -1.3399297 0.02851838 0.0 0.0 -1.2713106
   0.38369843 0.0 0.0 -43.388374 12.324491 0.0 0.0 -24.83892 5.640385 0.0 0.0
   -23.983084 -14.0474 0.0 0.0 -26.875755 11.543183 0.0 0.0 -25.162334 -9.833137
   0.0 0.0 -29.198517 1.7891215 0.0 0.0 -1.0719011 0.3185488 0.0 0.0 -1.2117033
   0.3194879 0.0 0.0 -27.189798 -9.45494 0.0 0.0 -1.7868673 -0.3066396 0.0 0.0
   -721.63666 163.72394 0.0 0.0 -25.030691 5.6112595 0.0 0.0 -1.3094649
   0.19577664 0.0 0.0 -28.849 -4.9581156 0.0 0.0 -1.006357 -0.78590935 0.0 0.0
   -25.219856 5.1833606 0.0 0.0 -1.1390696 -0.6741318 0.0 0.0 -1.1344904
   0.49268273 0.0 0.0 -1.2200255 -0.041254222 0.0 0.0 -1.273466 0.07066645 0.0
   0.0 -1.0804706 0.6134014 0.0 0.0 -573.8777 -259.3449 0.0 0.0 -1.2090467
   -0.3429098 0.0 0.0 -28.87229 -4.862752 0.0 0.0 -30.223585 -2.4194994 0.0 0.0
   -1.3268061 -0.0819855 0.0 0.0 -1.2723488 0.1673036 0.0 0.0 -1.2519646
   -0.32387608 0.0 0.0 -1.3099254 -0.012045331 0.0 0.0 -28.929295 -4.6668158 0.0
   0.0 -1.116087 -0.79518557 0.0 0.0 -28.394497 4.4155536 0.0 0.0 -1.1221005
   0.09838136 0.0 0.0 -1.284166 -0.14412732 0.0 0.0 -712.1938 -213.68993 0.0 0.0
   -720.219 -185.44682 0.0 0.0 -1.1599282 0.6658778 0.0 0.0 -24.84591 -6.943712
   0.0 0.0 -1.1580476 -0.5031438 0.0 0.0 -889.60034 524.62415 0.0 0.0 -1.1121418
   -0.69068563 0.0 0.0 -25.79151 -0.90576375 0.0 0.0 -63.276596 0.4238867 0.0
   0.0 -25.784492 -5.0882096 0.0 0.0 -1.1016684 -0.118966624 0.0 0.0 -1.3223733
   0.20449336 0.0 0.0 -0.9852099 0.9611181 0.0 0.0 -1.1431472 0.69428104 0.0 0.0
   -25.703297 -1.7963744 0.0 0.0 -1.273852 -0.22730061 0.0 0.0 -1.3113664
   0.24242394 0.0 0.0 -1.3069293 -0.07796453 0.0 0.0 -1.3327484 -0.040329665 0.0
   0.0 -1.2643276 0.14241369 0.0 0.0 -688.1935 427.8594 0.0 0.0 -35.718174
   2.64747 0.0 0.0 -1.1341555 -0.66354775 0.0 0.0 -944.10876 146.53514 0.0 0.0
   -27.876446 0.1298075 0.0 0.0 -1.2216741 -0.4247837 0.0 0.0 -35.030365
   -23.308844 0.0 0.0 -24.634865 -7.7890964 0.0 0.0 -1.3395368 0.039164722 0.0
   0.0 -42.15464 2.1890967 0.0 0.0 -0.71752435 -0.4997683 0.0 0.0 -1.3285027
   0.0036886632 0.0 0.0 -1.8931237 -0.1819687 0.0 0.0 -21.558296 -3.7955937 0.0
   0.0 -33.857143 -19.277485 0.0 0.0 -1.3318697 -0.06341321 0.0 0.0 -1.274982
   0.12972507 0.0 0.0 -1.1362356 -0.85997516 0.0 0.0 -1.2505821 -0.4491384 0.0
   0.0 -1.3609453 0.040286146 0.0 0.0 -26.814245 8.288259 0.0 0.0 -1.329563
   0.033593785 0.0 0.0 -32.88548 3.0176647 0.0 0.0 -25.028194 4.586253 0.0 0.0
   -54.061348 1.9385259 0.0 0.0 -1.3268362 -0.19085202 0.0 0.0 -1.2349207
   0.015076503 0.0 0.0 -1.2146213 0.08502783 0.0 0.0 -1.2388157 -0.5087581 0.0
   0.0 -28.829165 -16.248526 0.0 0.0 -639.1521 264.64102 0.0 0.0 -26.694763
   12.385616 0.0 0.0 -40.939156 -10.64628 0.0 0.0 -1.2221795 -0.34420854 0.0 0.0
   -1.1152798 0.7166584 0.0 0.0 -28.054604 -0.20480055 0.0 0.0 -1.0943285
   -0.3983331 0.0 0.0 -1.2161738 0.4587701 0.0 0.0 -1.3323941 -0.10140547 0.0
   0.0 -41.589657 -8.177096 0.0 0.0 -1.1926793 0.47316188 0.0 0.0 -1.202567
   0.32105726 0.0 0.0 -1.235199 -0.07475181 0.0 0.0 -613.46484 177.75752 0.0 0.0
   -1.2020262 0.519528 0.0 0.0 -27.366907 -6.6397333 0.0 0.0 -1.3018851
   0.27693355 0.0 0.0 -24.494267 -8.538195 0.0 0.0 -26.846186 12.123601 0.0 0.0
   -44.931442 -9.977519 0.0 0.0 -22.896717 -17.635582 0.0 0.0 -24.358133
   13.923813 0.0 0.0 -27.802437 -9.936313 0.0 0.0 -747.69775 -101.27728 0.0 0.0
   -72.670074 -28.17153 0.0 0.0 -102.79937 -34.311905 0.0 0.0 -33.17709
   1.4460782 0.0 0.0 -21.792143 -19.140263 0.0 0.0 -1.2923548 -0.021482913 0.0
   0.0 -1.0868753 -0.73557496 0.0 0.0 -1.4551164 -0.27829492 0.0 0.0 -29.474443
   2.1914015 0.0 0.0 -26.88154 -4.9156017 0.0 0.0 -1.2541382 0.43018028 0.0 0.0
   -1.133033 -0.75160164 0.0 0.0 -28.173899 -1.4680549 0.0 0.0 -30.909391
   -7.316086 0.0 0.0 -28.651371 -6.9394407 0.0 0.0 -1.3274825 0.016929578 0.0
   0.0 -29.187582 4.4474025 0.0 0.0 -1.2635658 0.31573278 0.0 0.0 -1.2437401
   -0.40912342 0.0 0.0 -20.428844 15.829664 0.0 0.0 -1.2467227 -0.2844652 0.0
   0.0 -1.1185695 -0.15671147 0.0 0.0 -0.99606544 0.42659304 0.0 0.0 -26.016638
   0.49542361 0.0 0.0 -1.2896892 0.27670267 0.0 0.0 -1.2744434 0.1649227 0.0 0.0
   -0.9159007 -0.6886708 0.0 0.0 -27.846735 -4.8089094 0.0 0.0 -28.537062
   6.386825 0.0 0.0 -29.584309 -1.3146114 0.0 0.0 -1.2754515 0.24933432 0.0 0.0
   -44.516705 12.8012905 0.0 0.0 -1.2838595 -0.22960712 0.0 0.0 -26.001976
   1.4490355 0.0 0.0 -1.0260056 -0.8508239 0.0 0.0 -1.9087906 -0.44709387 0.0
   0.0 -1.0659512 0.72837186 0.0 0.0 -1509.4484 -530.0735 0.0 0.0 -26.46959
   15.56111 0.0 0.0 -1.189093 0.11316514 0.0 0.0 -30.579525 -2.9657342 0.0 0.0
   -26.014673 12.52252 0.0 0.0 -1.3212107 0.0021150184 0.0 0.0 -32.180706
   16.628592 0.0 0.0 -29.61358 -1.3695132 0.0 0.0 -1.2671986 0.32399538 0.0 0.0
   -1.3034959 -0.091940634 0.0 0.0 -1.259469 -0.30738398 0.0 0.0 -1.2829293
   -0.058018435 0.0 0.0 -1.157498 -0.51446617 0.0 0.0 -1.2386668 -0.43556118 0.0
   0.0 -670.1062 -208.09833 0.0 0.0 -27.249643 -7.72532 0.0 0.0 -1.3403646
   0.018897215 0.0 0.0 -26.491098 -4.212799 0.0 0.0 -1.2108159 -0.5450885 0.0
   0.0 -520.31903 -464.9203 0.0 0.0 -27.583927 -13.646056 0.0 0.0 -644.95715
   48.157215 0.0 0.0 -1.3297781 -0.084389046 0.0 0.0 -1.2706741 0.4171782 0.0
   0.0 -1.1953785 0.21921384 0.0 0.0 -1.2416564 0.117917426 0.0 0.0 -30.489367
   -0.24805021 0.0 0.0 -27.656404 8.693548 0.0 0.0 -27.638212 6.3784122 0.0 0.0
   -0.6448819 -0.5415947 0.0 0.0 -38.982414 6.163213 0.0 0.0 -1.239111
   -0.49316975 0.0 0.0 -28.550327 -8.0035305 0.0 0.0 -1.3343838 -0.12209816 0.0
   0.0 -1.2155384 -0.21384192 0.0 0.0 -1.328797 -0.10486243 0.0 0.0 -24.290846
   14.687829 0.0 0.0 -1.145478 -0.6138096 0.0 0.0 -1.3097026 0.28762898 0.0 0.0
   -29.21971 -8.93987 0.0 0.0 -648.9573 -8.412718 0.0 0.0 -1.2969187 0.3198539
   0.0 0.0 -1.2438452 0.36622652 0.0 0.0 -23.746098 17.0009 0.0 0.0 -1.3361871
   -5.793124e-4 0.0 0.0 -1.1328747 -0.6959333 0.0 0.0 -26.04953 1.8156443 0.0
   0.0 -23.557272 -17.89543 0.0 0.0 -1.0666357 0.8082666 0.0 0.0 -27.97577
   -12.673241 0.0 0.0 -1.2776704 0.10050362 0.0 0.0 -28.589079 8.136447 0.0 0.0
   -1.3036723 -0.2496378 0.0 0.0 -1.3019222 -0.017401546 0.0 0.0 -29.077103
   -18.425756 0.0 0.0 -1.1673261 0.63750684 0.0 0.0 -1.2608376 0.19609798 0.0
   0.0 -1.6560513 0.34000543 0.0 0.0 -1.2536676 0.6557758 0.0 0.0 -2.0101666
   0.093817 0.0 0.0 -27.108143 14.810921 0.0 0.0 -1.3398125 0.002006311 0.0 0.0
   -27.811167 -6.9322047 0.0 0.0 -24.316164 9.199813 0.0 0.0 -1.1838552
   -0.49367613 0.0 0.0 -700.85785 318.9006 0.0 0.0 -1.3167232 -0.19812068 0.0
   0.0 -1.110701 -0.39562592 0.0 0.0 -1.2709904 -0.42199978 0.0 0.0 -1.3110949
   0.26483917 0.0 0.0 -1.2822143 0.11159921 0.0 0.0 -30.578161 4.757564 0.0 0.0
   -1.2361686 0.51067513 0.0 0.0 -1.2061524 -0.4992695 0.0 0.0 -1.1463257
   -0.67345726 0.0 0.0 -28.16911 -8.085053 0.0 0.0 -18.466711 -13.987554 0.0 0.0
   -0.7241801 0.9640977 0.0 0.0 -1.1993208 -0.280952 0.0 0.0 -1.2105812
   -0.5780614 0.0 0.0 -1.2890855 0.116886474 0.0 0.0 -650.4484 -67.10093 0.0 0.0
   -1.2167914 -0.54536676 0.0 0.0 -1.2077568 -0.39868432 0.0 0.0 -1.1113446
   0.2865382 0.0 0.0 -24.992443 -15.993319 0.0 0.0 -25.474129 6.32627 0.0 0.0
   -29.74391 2.7679389 0.0 0.0 -1.1798978 0.040374726 0.0 0.0 -1.3250242
   0.20817009 0.0 0.0 -29.410885 0.06353219 0.0 0.0 -28.532646 8.822316 0.0 0.0
   -28.262028 -9.587713 0.0 0.0 -1.1475844 -0.4317061 0.0 0.0 -39.873558
   5.373639 0.0 0.0 -21.548363 18.730486 0.0 0.0 -1.4185671 0.14664973 0.0 0.0
   -1.3131957 0.13363953 0.0 0.0 -594.9354 -74.78236 0.0 0.0 -1.2437259 0.231103
   0.0 0.0 -23.023848 12.603269 0.0 0.0 -713.1232 -20.294586 0.0 0.0 -1.3119434
   -0.07595091 0.0 0.0 -1.0586036 -0.2563888 0.0 0.0 -33.656075 -1.0335442 0.0
   0.0 -33.184513 -6.132394 0.0 0.0 -1.3275405 -0.093819 0.0 0.0 -1.3136158
   -0.11406111 0.0 0.0 -1.2768265 0.2645306 0.0 0.0 -0.7861951 0.7611131 0.0 0.0
   -1.3313328 0.033673763 0.0 0.0 -1.3167983 0.093884245 0.0 0.0 -32.086384
   10.546695 0.0 0.0 -1.2653786 -0.16231975 0.0 0.0 -1.2450991 0.15641245 0.0
   0.0 -1.1265817 0.70916635 0.0 0.0 -1.3689978 -0.11066554 0.0 0.0 -1.2677847
   -0.40919822 0.0 0.0 -1.0610746 -0.8171308 0.0 0.0 -1.0182567 -0.8335587 0.0
   0.0 -28.343494 -3.888292 0.0 0.0 -40.9171 -23.350752 0.0 0.0 -1.2322505
   0.48540497 0.0 0.0 -28.737877 1.5685785 0.0 0.0 -1.3021438 0.2342799 0.0 0.0
   -1.2710826 0.2213746 0.0 0.0 -1.2860086 -0.37608114 0.0 0.0 -654.2938
   81.95658 0.0 0.0 -39.327053 -7.1217546 0.0 0.0 -56.054756 -19.628841 0.0 0.0
   -649.33655 116.85128 0.0 0.0 -1.4998006 -0.5286209 0.0 0.0 -24.465406
   9.812899 0.0 0.0 -1.2895933 0.22229339 0.0 0.0 -26.293554 11.353318 0.0 0.0
   -1.3016875 0.32277167 0.0 0.0 -539.5338 -380.9805 0.0 0.0 -29.940985
   -1.7032079 0.0 0.0 -0.71078867 -1.0629796 0.0 0.0 -25.791763 -0.26310414 0.0
   0.0 -39.875893 -3.4903088 0.0 0.0 -36.157898 9.480296 0.0 0.0 -650.3984
   119.06799 0.0 0.0 -26.339436 1.5327525 0.0 0.0 -1240.7206 363.75125 0.0 0.0
   -1.1687322 -0.60485744 0.0 0.0 -29.799664 3.5977538 0.0 0.0 -0.80808324
   0.38348615 0.0 0.0 -1.2433544 0.2954335 0.0 0.0 -0.9799161 -0.49770218 0.0
   0.0 -38.65129 9.968639 0.0 0.0 -28.192638 5.300295 0.0 0.0 -849.7779
   -59.34764 0.0 0.0 -20.994385 -22.98042 0.0 0.0 -1.1620746 -0.08519217 0.0 0.0
   -33.252922 -14.105453 0.0 0.0 -0.9710564 -0.71639174 0.0 0.0 -1.0980333
   0.7049099 0.0 0.0 -28.680086 -12.335541 0.0 0.0 -28.99559 -0.973395 0.0 0.0
   -652.4908 -119.655075 0.0 0.0 -1.224077 0.15916473 0.0 0.0 -29.43285
   -6.1345835 0.0 0.0 -33.818264 2.5471942 0.0 0.0 -1.1891123 -0.5067064 0.0 0.0
   -28.571167 3.2091808 0.0 0.0 -1.2784514 0.2950047 0.0 0.0 -1.3100785
   -0.14411038 0.0 0.0 -779.6909 -97.85401 0.0 0.0 -18.237783 19.048317 0.0 0.0
   -1.3239686 0.20259081 0.0 0.0 -39.125847 -5.764902 0.0 0.0 -1.3180615
   -0.13960327 0.0 0.0 -613.07526 -383.61948 0.0 0.0 -24.857523 -9.015774 0.0
   0.0 -1.245445 -0.3483797 0.0 0.0 -0.95780015 -0.9121115 0.0 0.0 -1.3008554
   -0.31529212 0.0 0.0 -0.94974923 -0.47450584 0.0 0.0 -1.3294032 -0.15379527
   0.0 0.0 -29.76257 4.4332147 0.0 0.0 -1.3018318 -0.21384317 0.0 0.0 -29.083668
   -6.865155 0.0 0.0 -1.4180908 0.5539127 0.0 0.0 -1.3016719 -0.22316867 0.0 0.0
   -24.929945 8.934881 0.0 0.0 -788.5854 2.2893605 0.0 0.0 -1.2688498
   -0.0025689306 0.0 0.0 -706.2627 -351.50104 0.0 0.0 -832.37885 -209.35048 0.0
   0.0 -0.9431704 -0.9455021 0.0 0.0 -52.48205 13.961743 0.0 0.0 -28.217382
   -5.880174 0.0 0.0 -1.3370625 -0.04526971 0.0 0.0 -28.637417 -12.696567 0.0
   0.0 -1.3335556 -0.1007272 0.0 0.0 -1.2895031 -0.24981253 0.0 0.0 -31.309383
   -1.7849253 0.0 0.0 -1.2317604 -0.51193035 0.0 0.0 -1.3155857 0.2107792 0.0
   0.0 -29.781849 -3.9140654 0.0 0.0 -1.2972386 0.33781844 0.0 0.0 -61.368637
   2.0911076 0.0 0.0 -1.2683843 0.43444544 0.0 0.0 -1.1866053 0.22430152 0.0 0.0
   -32.27024 2.7858324 0.0 0.0 -787.9948 -76.35772 0.0 0.0 -1.8357621 -1.150037
   0.0 0.0 -23.855135 20.3699 0.0 0.0 -672.97076 -652.8128 0.0 0.0 -26.531052
   -0.9462316 0.0 0.0 -861.519 -33.067394 0.0 0.0 -485.17822 380.1725 0.0 0.0
   -30.113401 -2.4682288 0.0 0.0 -674.45465 276.18802 0.0 0.0 -24.617826
   -9.925636 0.0 0.0 -647.9966 170.79152 0.0 0.0 -26.406685 -14.700345 0.0 0.0
   -683.07477 -403.8885 0.0 0.0 -1.2757039 -0.019344412 0.0 0.0 -1.2142615
   -0.43843552 0.0 0.0 -22.826197 13.358795 0.0 0.0 -51.01075 9.666352 0.0 0.0
   -15.831478 13.524237 0.0 0.0 -1.0066344 0.8751234 0.0 0.0 -1.2822115
   -0.20185046 0.0 0.0 -1.3154069 -0.5452359 0.0 0.0 -1.3392174 0.002563372 0.0
   0.0 -26.349766 -14.774778 0.0 0.0 -25.904211 -6.0404015 0.0 0.0 -25.267792
   7.9482694 0.0 0.0 -1.2968366 0.22552314 0.0 0.0 -74.11019 19.720558 0.0 0.0
   -24.626225 -19.53823 0.0 0.0 -1.3931086 0.5365768 0.0 0.0 -1.1877662
   -0.5745749 0.0 0.0 -1.2389588 0.29814267 0.0 0.0 -1.2709306 -0.31131077 0.0
   0.0 -24.094257 -11.147223 0.0 0.0 -28.747925 -3.4827266 0.0 0.0 -26.84449
   13.786755 0.0 0.0 -1.2561722 -0.45874912 0.0 0.0 -1.2671818 -0.18332894 0.0
   0.0 -1.2266735 0.25621945 0.0 0.0 -37.11379 3.6487727 0.0 0.0 -1.2201965
   -0.30100995 0.0 0.0 -1.1912895 -0.29569682 0.0 0.0 -1.5109261 0.26268685 0.0
   0.0 -1.5874486 -0.07716461 0.0 0.0 -1.2212096 0.156567 0.0 0.0 -674.1847
   8.953585 0.0 0.0 -1.319795 -0.036304273 0.0 0.0 -1.2340466 -0.39298403 0.0
   0.0 -946.2641 9.034681 0.0 0.0 -1.1788976 -0.6121027 0.0 0.0 -1.0401605
   0.33030394 0.0 0.0 -688.74884 -255.41583 0.0 0.0 -702.51514 185.40138 0.0 0.0
   -796.0952 76.581726 0.0 0.0 -647.8043 -190.86308 0.0 0.0 -1.2361612
   -0.50592715 0.0 0.0 -51.57573 9.058606 0.0 0.0 -1.223067 -0.5419387 0.0 0.0
   -39.470383 -9.794564 0.0 0.0 -2.1822772 0.05056886 0.0 0.0 -23.781967
   -12.101894 0.0 0.0 -1.2689061 -0.18185809 0.0 0.0 -31.04884 5.4485126 0.0 0.0
   -1.1768433 -0.47598603 0.0 0.0 -1.339017 0.048214894 0.0 0.0 -35.283245
   -11.918094 0.0 0.0 -40.350677 -5.320931 0.0 0.0 -1.2875391 -0.11566572 0.0
   0.0 -26.642523 -0.58332336 0.0 0.0 -1.0474671 0.8136172 0.0 0.0 -1.2946423
   0.34875277 0.0 0.0 -1.2499748 0.3895048 0.0 0.0 -39.69504 -9.173541 0.0 0.0
   -1.2518203 0.24002363 0.0 0.0 -1.1824373 -0.5132214 0.0 0.0 -1.331926
   0.024726838 0.0 0.0 -1.2830184 -0.21973774 0.0 0.0 -1.339482 -1.822915e-4 0.0
   0.0 -1.2546766 -0.4404935 0.0 0.0 -25.586126 -7.7387843 0.0 0.0 -27.25889
   -10.150348 0.0 0.0 -30.33224 9.049723 0.0 0.0 -30.190096 -2.595264 0.0 0.0
   -1.2703662 -0.3025408 0.0 0.0 -1.3984641 -0.0013915822 0.0 0.0 -1.3262713
   -0.1820131 0.0 0.0 -1.1652 0.5657887 0.0 0.0 -1.4575598 -0.4517572 0.0 0.0
   -29.911955 4.4400578 0.0 0.0 -30.359509 1.0238062 0.0 0.0 -28.515299
   5.2346926 0.0 0.0 -518.26416 -381.58517 0.0 0.0 -1.3108069 0.11257699 0.0 0.0
   -1.2720089 -0.41383645 0.0 0.0 -52.40205 5.3114495 0.0 0.0 -29.917961 1.49351
   0.0 0.0 -28.426907 -10.8892975 0.0 0.0 -1.091712 -0.66019005 0.0 0.0
   -24.329742 -2.5780764 0.0 0.0 -1.2204612 -0.49497053 0.0 0.0 -0.9853491
   -0.7766584 0.0 0.0 -1.4695174 0.4478095 0.0 0.0 -526.8872 295.5559 0.0 0.0
   -30.472553 -0.19512933 0.0 0.0 -1.2838042 0.37991244 0.0 0.0 -29.339725
   7.9307985 0.0 0.0 -1.1346253 0.71303463 0.0 0.0 -713.7635 203.89154 0.0 0.0
   -30.46738 0.6588839 0.0 0.0 -1.2368935 -0.47455207 0.0 0.0 -30.24751 -3.75689
   0.0 0.0 -1.1722096 0.6379841 0.0 0.0 -33.90161 -10.152085 0.0 0.0 -1.2777236
   -0.266097 0.0 0.0 -0.81736195 -1.2121652 0.0 0.0 -1.2305557 -0.14891015 0.0
   0.0 -1.3182304 0.18126866 0.0 0.0 -1.2967706 -0.17104828 0.0 0.0 -1.2116644
   -0.30229995 0.0 0.0 -2.530729 -0.90210813 0.0 0.0 -21.019558 -23.783373 0.0
   0.0 -1.1955953 0.48956236 0.0 0.0 -27.147493 2.3095574 0.0 0.0 -1.3167492
   0.1333711 0.0 0.0 -0.931481 -0.8434072 0.0 0.0 -909.58655 -312.29288 0.0 0.0
   -1139.0564 -495.21564 0.0 0.0 -34.634167 -21.979153 0.0 0.0 -502.76437
   -464.28705 0.0 0.0 -27.470312 9.977088 0.0 0.0 -1.3064018 -0.30277616 0.0 0.0
   -1.1871417 -0.553583 0.0 0.0 -860.2139 -205.46552 0.0 0.0 -1.6059173
   0.3405153 0.0 0.0 -1.302861 0.26626295 0.0 0.0 -1.3314098 0.04880589 0.0 0.0
   -1.2242864 0.715466 0.0 0.0 -1.1347157 0.64320225 0.0 0.0 -0.94437855
   0.93616444 0.0 0.0 -1.3202431 -0.17737973 0.0 0.0 -1.2216125 0.31041357 0.0
   0.0 -1.1459328 -0.66630715 0.0 0.0 -40.958214 -4.944045 0.0 0.0 -63.008736
   -25.799126 0.0 0.0 -2.5851238 -0.8670806 0.0 0.0 -1.0114053 -0.54985344 0.0
   0.0 -1.0370302 0.21761014 0.0 0.0 -25.868835 -7.3394833 0.0 0.0 -742.4981
   90.570076 0.0 0.0 -1.2656661 0.07589092 0.0 0.0 -808.4739 102.75025 0.0 0.0
   -23.271322 19.456905 0.0 0.0 -1.3345306 -0.11794459 0.0 0.0 -31.441078
   -5.247631 0.0 0.0 -26.398615 -15.502026 0.0 0.0 -26.81245 -2.058138 0.0 0.0
   -0.9133592 -0.9523673 0.0 0.0 -1.3379672 0.093595095 0.0 0.0 -29.997326
   -5.896771 0.0 0.0 -37.688538 -6.524844 0.0 0.0 -17.33248 -20.585173 0.0 0.0
   -1.2396668 -0.12041626 0.0 0.0 -1.2086707 -0.4726958 0.0 0.0 -0.97334427
   -0.8810638 0.0 0.0 -1.3058449 -0.049832664 0.0 0.0 -31.002563 -6.7716303 0.0
   0.0 -1.3044276 0.30759138 0.0 0.0 -665.4219 179.1804 0.0 0.0 -1.3347223
   -0.021393163 0.0 0.0 -26.875246 1.731302 0.0 0.0 -22.784153 14.373277 0.0 0.0
   -1.2565587 0.27516943 0.0 0.0 -958.0808 158.96472 0.0 0.0 -30.141891
   -2.9440062 0.0 0.0 -1.2074795 0.23861997 0.0 0.0 -42.167606 14.600166 0.0 0.0
   -1.3259025 -0.008280687 0.0 0.0 -1.178573 -0.27689838 0.0 0.0 -1.0279474
   -0.4023947 0.0 0.0 -1.2933927 0.328633 0.0 0.0 -1.189393 0.057471227 0.0 0.0
   -30.26026 -5.0386195 0.0 0.0 -26.799475 -3.0508986 0.0 0.0 -1.3238145
   -0.10316757 0.0 0.0 -11.841358 12.654375 0.0 0.0 -1.2967526 -0.3416706 0.0
   0.0 -1.306937 -0.2654526 0.0 0.0 -32.221916 21.195255 0.0 0.0 -26.720865
   -12.201205 0.0 0.0 -1.25497 -0.44363517 0.0 0.0 -54.434002 -20.572718 0.0 0.0
   -1.2537367 -0.03983905 0.0 0.0 -1.2629911 0.31469586 0.0 0.0 -1.2980866
   0.04604893 0.0 0.0 -1.3341829 -0.12568267 0.0 0.0 -1.0655781 0.10383156 0.0
   0.0 -26.7188 -12.223631 0.0 0.0 -691.2031 -47.126156 0.0 0.0 -28.132128
   20.572998 0.0 0.0 -41.909153 -16.238274 0.0 0.0 -25.389095 -9.244509 0.0 0.0
   -28.664694 5.992813 0.0 0.0 -1.2512542 0.014072087 0.0 0.0 -33.80653
   -8.495333 0.0 0.0 -1.3299918 0.16255425 0.0 0.0 -1.113697 -0.60191107 0.0 0.0
   -0.9639025 0.806063 0.0 0.0 -25.309935 9.170516 0.0 0.0 -38.476498 -2.7536693
   0.0 0.0 -1.2746152 -0.19235478 0.0 0.0 -32.0378 1.4364535 0.0 0.0 -1.3050966
   -0.1988818 0.0 0.0 -23.131071 -12.495364 0.0 0.0 -29.256624 -0.51643276 0.0
   0.0 -29.493593 6.020459 0.0 0.0 -1.2919567 -0.038523473 0.0 0.0 -0.88691884
   -1.0063541 0.0 0.0 -37.22054 8.004762 0.0 0.0 -1.3986211 0.21413685 0.0 0.0
   -29.362885 2.6170204 0.0 0.0 -1.0620534 -0.23327765 0.0 0.0 -1.1277146
   0.5390209 0.0 0.0 -25.09205 -9.935482 0.0 0.0 -1.3017707 0.32167763 0.0 0.0
   -1.3350885 -0.45856306 0.0 0.0 -1.5186162 -0.32230136 0.0 0.0 -1.2675834
   0.018085564 0.0 0.0 -1.3014714 0.10577908 0.0 0.0 -29.41416 9.056498 0.0 0.0
   -29.915298 7.406148 0.0 0.0 -1.2898413 -0.12194639 0.0 0.0 -1.3216482
   0.20304175 0.0 0.0 -1.1251262 0.6109321 0.0 0.0 -27.501535 3.8653104 0.0 0.0
   -1.1092298 -0.4601174 0.0 0.0 -1.078336 -0.77306557 0.0 0.0 -1.0289531
   -0.6658317 0.0 0.0 -29.133974 -9.676712 0.0 0.0 -30.809011 9.153498 0.0 0.0
   -25.84244 -14.204308 0.0 0.0 -1.3151098 0.043655727 0.0 0.0 -1.2248037
   -0.29977506 0.0 0.0 -29.314342 -9.614795 0.0 0.0 -1.1839964 0.5334437 0.0 0.0
   -30.108494 -3.22319 0.0 0.0 -775.0735 -297.00128 0.0 0.0 -1.336686
   -0.052628286 0.0 0.0 -38.68944 23.346218 0.0 0.0 -1.2483648 -0.2821568 0.0
   0.0 -29.589457 12.719657 0.0 0.0 -1.2918314 -0.33589634 0.0 0.0 -1.3192519
   0.049909085 0.0 0.0 -28.661203 3.854661 0.0 0.0 -1.2986995 0.33247048 0.0 0.0
   -28.286858 15.349725 0.0 0.0 -1.3343346 -0.13761556 0.0 0.0 -29.10807
   -4.4466376 0.0 0.0 -1.318133 0.24389929 0.0 0.0 -25.22786 10.056641 0.0 0.0
   -27.705534 -10.3987465 0.0 0.0 -26.49214 5.9927535 0.0 0.0 -27.267246
   12.912561 0.0 0.0 -1.2796959 0.23748183 0.0 0.0 -23.133596 -0.27847585 0.0
   0.0 -1.3190401 0.001236096 0.0 0.0 -27.137405 1.4195858 0.0 0.0 -35.87658
   2.113043 0.0 0.0 -1.3057076 -0.09027209 0.0 0.0 -1.3381724 -0.032239925 0.0
   0.0 -26.840952 -4.0999527 0.0 0.0 -763.6485 335.29828 0.0 0.0 -34.233685
   20.106857 0.0 0.0 -29.59741 1.222784 0.0 0.0 -25.677412 -8.901061 0.0 0.0
   -1.3327801 -0.068880886 0.0 0.0 -38.878456 0.1417051 0.0 0.0 -27.052227
   -2.598304 0.0 0.0 -1.3361808 -0.036833 0.0 0.0 -1.2977042 -0.0061660777 0.0
   0.0 -1.2604706 0.073408715 0.0 0.0 -1.3373446 -0.04813914 0.0 0.0 -30.735275
   3.7289767 0.0 0.0 -1.3211504 0.2316523 0.0 0.0 -27.847404 16.261372 0.0 0.0
   -1.3385398 0.0072302795 0.0 0.0 -1.3213292 -0.1714988 0.0 0.0 -1.290605
   0.24787928 0.0 0.0 -1.3386306 0.011612822 0.0 0.0 -1.3041127 0.2968774 0.0
   0.0 -701.70966 58.76847 0.0 0.0 -29.249056 4.9749017 0.0 0.0 -35.433548
   -14.871237 0.0 0.0 -34.807495 -16.291822 0.0 0.0 -1.3566864 -0.010204486 0.0
   0.0 -1.284776 0.14124224 0.0 0.0 -1.1241156 -0.7260459 0.0 0.0 -765.6362
   68.87278 0.0 0.0 -766.7153 -57.505848 0.0 0.0 -1.2163794 -0.11750172 0.0 0.0
   -24.511446 -11.868566 0.0 0.0 -1.3248613 0.096652195 0.0 0.0 -30.89304
   -7.778458 0.0 0.0 -479.04724 -631.9705 0.0 0.0 -1.280608 -0.18044427 0.0 0.0
   -34.668995 -16.52776 0.0 0.0 -24.983335 -10.814221 0.0 0.0 -1.1729839
   -0.6354069 0.0 0.0 -30.601734 3.944229 0.0 0.0 -30.433523 -1.0893688 0.0 0.0
   -1.3058954 0.29786453 0.0 0.0 -28.710325 7.661151 0.0 0.0 -25.02225 10.559797
   0.0 0.0 -29.904104 -8.1999445 0.0 0.0 -836.67755 -84.17024 0.0 0.0 -1.0701512
   0.38750696 0.0 0.0 -1.2315048 -0.6910136 0.0 0.0 -706.3052 41.39691 0.0 0.0
   -0.8288285 -1.0485194 0.0 0.0 -1.2867764 0.16526675 0.0 0.0 -1.2746631
   -0.081290804 0.0 0.0 -1.2234683 -0.022984771 0.0 0.0 -27.116322 -2.6892996
   0.0 0.0 -1.1202394 0.38300934 0.0 0.0 -28.325945 12.715655 0.0 0.0 -26.3289
   -16.510313 0.0 0.0 -26.273666 -7.4764776 0.0 0.0 -659.48737 -259.64905 0.0
   0.0 -696.3477 -132.7308 0.0 0.0 -1.7638898 -0.55925465 0.0 0.0 -27.071873
   -2.84292 0.0 0.0 -1.2725977 0.06523358 0.0 0.0 -1.0762951 -0.77629334 0.0 0.0
   -1.3207651 0.10256788 0.0 0.0 -52.93333 -8.435295 0.0 0.0 -1.2990845
   0.15959169 0.0 0.0 -1.2923672 0.19615471 0.0 0.0 -1.293968 0.3428304 0.0 0.0
   -1.3002375 0.30145976 0.0 0.0 -23.467684 14.148272 0.0 0.0 -29.524284
   -3.3821163 0.0 0.0 -0.824788 -0.89890754 0.0 0.0 -31.117514 0.39187083 0.0
   0.0 -1.28229 -0.012265905 0.0 0.0 -1.1536862 0.45054725 0.0 0.0 -0.9637686
   0.39934126 0.0 0.0 -1.2973711 0.16083074 0.0 0.0 -1.8862123 -0.065635964 0.0
   0.0 -54.540207 -4.0732327 0.0 0.0 -472.38162 -489.92093 0.0 0.0 -1.0344964
   -0.0125470385 0.0 0.0 -642.5018 -306.23038 0.0 0.0 -30.82214 -2.1627665 0.0
   0.0 -1.44146 -0.39243373 0.0 0.0 -1.3346317 0.042134997 0.0 0.0 -37.282192
   -9.750506 0.0 0.0 -1.1745453 -0.5921882 0.0 0.0 -1.1147528 -0.7412596 0.0 0.0
   -1.3334605 -0.12383654 0.0 0.0 -1.3311296 0.088135056 0.0 0.0 -638.67194
   -316.67392 0.0 0.0 -1.262352 -0.33246964 0.0 0.0 -1.3324376 -0.12609524 0.0
   0.0 -1.3248109 -0.1507299 0.0 0.0 -35.04931 -4.5615873 0.0 0.0 -1.3822478
   -0.34052864 0.0 0.0 -27.327242 2.1692164 0.0 0.0 -37.93736 -0.827308 0.0 0.0
   -28.717394 -11.646118 0.0 0.0 -1.2498097 0.21217579 0.0 0.0 -0.9205804
   -0.863576 0.0 0.0 -1003.9879 -125.009254 0.0 0.0 -32.58758 0.7057816 0.0 0.0
   -27.011091 -14.409827 0.0 0.0 -1.2786157 0.09761871 0.0 0.0 -21.293346
   8.510203 0.0 0.0 -24.472706 -9.731859 0.0 0.0 -1.2505395 -0.28567925 0.0 0.0
   -1.2625244 -0.38306597 0.0 0.0 -32.260143 4.941691 0.0 0.0 -25.027237
   10.959669 0.0 0.0 -29.422949 20.04249 0.0 0.0 -1.2568161 0.4385898 0.0 0.0
   -1.3144177 -0.13300437 0.0 0.0 -1.3293486 -0.13894433 0.0 0.0 -1.3261555
   -0.075458705 0.0 0.0 -1.552206 0.365465 0.0 0.0 -1.3159896 -0.0062917396 0.0
   0.0 -1.3165803 -0.08318987 0.0 0.0 -31.078438 3.1602576 0.0 0.0 -1.2967166
   -0.32301876 0.0 0.0 -1.3064469 -0.25467598 0.0 0.0 -0.891165 -0.9660902 0.0
   0.0 -1.3119742 -0.19249703 0.0 0.0 -1.182938 0.29527473 0.0 0.0 -25.979385
   -10.289205 0.0 0.0 -1.2816566 -0.026970943 0.0 0.0 -28.916042 7.833282 0.0
   0.0 -671.6102 -252.8144 0.0 0.0 -1.1391895 0.6382455 0.0 0.0 -0.8698807
   0.27467442 0.0 0.0 -30.181038 8.04261 0.0 0.0 -36.13174 -14.4818325 0.0 0.0
   -29.69812 4.219575 0.0 0.0 -27.379755 -6.2622147 0.0 0.0 -1.5357099
   -0.07894523 0.0 0.0 -30.979647 4.384845 0.0 0.0 -32.607895 14.545658 0.0 0.0
   -1.3249168 0.0051499084 0.0 0.0 -29.219625 14.757324 0.0 0.0 -38.45746
   8.893618 0.0 0.0 -17.63044 -25.691845 0.0 0.0 -34.377075 -24.979366 0.0 0.0
   -27.08459 -18.40371 0.0 0.0 -769.47925 -156.98024 0.0 0.0 -31.530312
   -8.857437 0.0 0.0 -1.2088768 0.40561736 0.0 0.0 -1.1437328 0.46891525 0.0 0.0
   -31.24976 0.22811304 0.0 0.0 -1.302312 0.02617289 0.0 0.0 -0.7996151
   0.7312272 0.0 0.0 -1.3093417 0.03444028 0.0 0.0 -700.5562 357.4312 0.0 0.0
   -22.530022 15.213607 0.0 0.0 -1.1340649 0.53400385 0.0 0.0 -1.314119
   0.15297115 0.0 0.0 -1.5122749 -0.529433 0.0 0.0 -1.1557617 0.3540116 0.0 0.0
   -1.2978019 0.017307457 0.0 0.0 -32.685074 -2.1871743 0.0 0.0 -1.324363
   -0.056730926 0.0 0.0 -1.299228 0.0027064271 0.0 0.0 -1.509354 -0.17422473 0.0
   0.0 -30.390068 -6.7382255 0.0 0.0 -693.44934 374.6523 0.0 0.0 -1.3305683
   0.06070254 0.0 0.0 -720.67126 -49.673275 0.0 0.0 -29.36762 -8.130072 0.0 0.0
   -1.2232481 -0.47562402 0.0 0.0 -741.7151 -268.74338 0.0 0.0 -1.1702685
   -0.5303266 0.0 0.0 -1.188036 0.011976459 0.0 0.0 -0.9694332 -0.44165868 0.0
   0.0 -1.3078358 -0.2973734 0.0 0.0 -1.2545197 -0.41185227 0.0 0.0 -26.998415
   5.7374597 0.0 0.0 -1.2355016 -0.25514287 0.0 0.0 -38.950092 -3.7744 0.0 0.0
   -1.8716097 0.37533087 0.0 0.0 -1.3035885 0.02041093 0.0 0.0 -920.63916
   -376.9111 0.0 0.0 -70.01557 -36.112812 0.0 0.0 -689.6862 -221.53061 0.0 0.0
   -1.2044021 0.21324214 0.0 0.0 -25.073645 11.485858 0.0 0.0 -1.3405564
   0.026370171 0.0 0.0 -635.0836 -349.4865 0.0 0.0 -1.1211629 0.7281152 0.0 0.0
   -0.75396866 -1.0110749 0.0 0.0 -30.698734 -11.714025 0.0 0.0 -31.177095
   -3.8448641 0.0 0.0 -1.0787416 -0.9858487 0.0 0.0 -26.061949 10.762382 0.0 0.0
   -851.62994 151.52927 0.0 0.0 -1.3177606 0.47088596 0.0 0.0 -1.2300795
   0.011297107 0.0 0.0 -31.361578 0.48982844 0.0 0.0 -1.1685845 0.65516675 0.0
   0.0 -1.6402678 0.21656887 0.0 0.0 -34.619827 -9.583656 0.0 0.0 -27.694063
   14.056809 0.0 0.0 -704.77124 -364.57758 0.0 0.0 -29.871105 4.3859572 0.0 0.0
   -29.598402 -6.5509186 0.0 0.0 -1.3013364 0.27228525 0.0 0.0 -1.2823187
   -0.12084492 0.0 0.0 -31.274971 3.0152528 0.0 0.0 -1.1315991 0.48266143 0.0
   0.0 -31.88919 8.204673 0.0 0.0 -1.052055 0.70341086 0.0 0.0 -1.2685778
   -0.38318378 0.0 0.0 -1.2400278 -0.15586102 0.0 0.0 -1.3365022 -0.044171512
   0.0 0.0 -1.2873591 -0.24096808 0.0 0.0 -1.2250766 -0.26187804 0.0 0.0
   -1.222423 -0.39571345 0.0 0.0 -1.2241046 -0.019295152 0.0 0.0 -1.0720601
   0.5193778 0.0 0.0 -1.3160126 -0.24295536 0.0 0.0 -25.105827 16.843716 0.0 0.0
   -1.2766691 -0.3043482 0.0 0.0 -31.19262 -4.200972 0.0 0.0 -1.3318175
   0.11526648 0.0 0.0 -31.126245 -3.748378 0.0 0.0 -1.2470049 0.40879595 0.0 0.0
   -1.229612 -0.35022143 0.0 0.0 -1.1086223 -0.57136965 0.0 0.0 -1.2700831
   -0.30228588 0.0 0.0 -1.3014162 0.12470855 0.0 0.0 -701.01404 -427.09796 0.0
   0.0 -0.9242871 -0.32685396 0.0 0.0 -729.012 47.614517 0.0 0.0 -38.187996
   -1.2880918 0.0 0.0 -1.2903647 -0.061274454 0.0 0.0 -1.3687958 -0.5163824 0.0
   0.0 -30.390224 -6.645364 0.0 0.0 -0.9860307 -0.72023785 0.0 0.0 -26.81589
   -4.56388 0.0 0.0 -1.3104122 -0.19994704 0.0 0.0 -1.262776 -0.37980607 0.0 0.0
   -1.1789249 -0.6363019 0.0 0.0 -1.2965798 0.14353701 0.0 0.0 -1.2906619
   -0.34112576 0.0 0.0 -30.495695 3.6156409 0.0 0.0 -1382.6809 -533.35095 0.0
   0.0 -868.7254 394.2426 0.0 0.0 -1.1923255 -0.48906583 0.0 0.0 -1.2284818
   -0.15938747 0.0 0.0 -1.3291559 0.031748317 0.0 0.0 -28.790014 9.48536 0.0 0.0
   -1.2891433 0.23050241 0.0 0.0 -716.0635 -358.2438 0.0 0.0 -1.1507461
   -0.5200591 0.0 0.0 -1.2416885 0.38603947 0.0 0.0 -1.0584984 -0.29966396 0.0
   0.0 -29.332458 -11.810769 0.0 0.0 -0.96609426 -0.7911186 0.0 0.0 -31.544651
   2.2972353 0.0 0.0 -26.45443 -8.427091 0.0 0.0 -1.0996135 -0.5843453 0.0 0.0
   -1.2522748 -0.17741278 0.0 0.0 -29.979494 -10.011673 0.0 0.0 -3.2307932
   -0.53192866 0.0 0.0 -1.2584482 -0.46261948 0.0 0.0 -26.430481 14.93519 0.0
   0.0 -25.696299 -12.748778 0.0 0.0 -35.25277 -8.271528 0.0 0.0 -38.736485
   7.161492 0.0 0.0 -1.3123295 0.23337586 0.0 0.0 -31.307808 10.965418 0.0 0.0
   -1.2703936 -0.21225812 0.0 0.0 0.17665555 -1.1904752 0.0 0.0 -0.97145593
   -0.15018049 0.0 0.0 -1.4029057 0.2996484 0.0 0.0 -1.336607 0.105452344 0.0
   0.0 -1.3297284 -0.032360554 0.0 0.0 -27.127449 -6.143997 0.0 0.0 -0.84719294
   0.848188 0.0 0.0 -1142.6692 -84.99286 0.0 0.0 -1.157544 -0.1496702 0.0 0.0
   -696.63495 239.83951 0.0 0.0 -28.864285 -12.893598 0.0 0.0 -26.74063 7.77975
   0.0 0.0 -1.2795573 0.22427349 0.0 0.0 -33.110817 -14.831044 0.0 0.0
   -1.3287959 -0.15704645 0.0 0.0 -1.2552048 0.0155971935 0.0 0.0 -1.2570584
   0.46420026 0.0 0.0 -1.2846073 0.36149985 0.0 0.0 -1.3360977 -0.076961964 0.0
   0.0 -1.2594132 0.42930996 0.0 0.0 -1.3207111 0.08336437 0.0 0.0 -35.688625
   -6.4568467 0.0 0.0 -31.059086 -6.4271574 0.0 0.0 -1.1803765 -0.5131667 0.0
   0.0 -1.2796522 0.34217513 0.0 0.0 -1.2696887 -0.30957636 0.0 0.0 -1.1212759
   0.53144985 0.0 0.0 -1.2748418 -0.38305417 0.0 0.0 -1.2447224 -0.46511704 0.0
   0.0 -1.2177407 0.4959278 0.0 0.0 -51.20065 0.39290795 0.0 0.0 -1.286339
   -0.37494543 0.0 0.0 -31.738163 -0.95131373 0.0 0.0 -1.3293163 -0.17399648 0.0
   0.0 -27.129307 6.49519 0.0 0.0 -1.2320176 0.3844522 0.0 0.0 -0.6543825
   0.7949951 0.0 0.0 -1.2317581 -0.48308536 0.0 0.0 -27.837698 -15.292414 0.0
   0.0 -1.3244936 0.015560649 0.0 0.0 -882.89954 51.034058 0.0 0.0 -27.744373
   -3.1277661 0.0 0.0 -1.2601501 -0.4010022 0.0 0.0 -29.134356 4.365486 0.0 0.0
   -1.2860987 -0.24888799 0.0 0.0 -858.58954 215.40979 0.0 0.0 -1.1899074
   0.5654763 0.0 0.0 -2.373804 0.10824096 0.0 0.0 -810.0197 -28.371548 0.0 0.0
   -33.09848 3.6112113 0.0 0.0 -1.229935 0.24903454 0.0 0.0 -1.2552935
   0.19374709 0.0 0.0 -31.755604 -1.3679122 0.0 0.0 -616.1719 -527.6801 0.0 0.0
   -31.766352 1.602331 0.0 0.0 -27.94048 -0.9800024 0.0 0.0 -38.837234
   -19.461092 0.0 0.0 -1.2452614 -0.34916294 0.0 0.0 -1.1845942 -1.0682976 0.0
   0.0 -20.90066 -23.643095 0.0 0.0 -1.0571313 -0.75514674 0.0 0.0 -29.087538
   -9.3290825 0.0 0.0 -26.855406 17.049599 0.0 0.0 -35.53576 8.127038 0.0 0.0
   -1.2814496 0.3751229 0.0 0.0 -689.27405 -279.7562 0.0 0.0 -840.91406
   -287.4102 0.0 0.0 -1.2771423 0.40582433 0.0 0.0 -30.09983 9.361478 0.0 0.0
   -33.749767 -13.900686 0.0 0.0 -1.3093475 0.17691535 0.0 0.0 -31.017418
   2.4514854 0.0 0.0 -0.979545 0.8558637 0.0 0.0 -1.2738203 -0.09446806 0.0 0.0
   -1.2609091 0.4366331 0.0 0.0 -30.335096 4.0099473 0.0 0.0 -1.2674214
   0.10171707 0.0 0.0 -1.133033 -0.6285722 0.0 0.0 -0.91831785 -0.8831763 0.0
   0.0 -29.69941 1.7946695 0.0 0.0 -25.457035 -11.701551 0.0 0.0 -15.331456
   -27.56244 0.0 0.0 -26.42945 -15.410952 0.0 0.0 -40.04957 -3.5133817 0.0 0.0
   -1.1900312 -0.6136597 0.0 0.0 -27.45278 13.421547 0.0 0.0 -1.2134082
   0.44220126 0.0 0.0 -1.2508137 -0.4168953 0.0 0.0 -1.2799416 0.3588248 0.0 0.0
   -1.3112223 0.049527403 0.0 0.0 -30.995466 2.3355448 0.0 0.0 -1.17184 0.437621
   0.0 0.0 -31.39258 -5.7522464 0.0 0.0 -39.365864 -18.942564 0.0 0.0 -1.2941458
   0.16090274 0.0 0.0 -1.1050371 0.7298125 0.0 0.0 -1.2053503 -0.14489765 0.0
   0.0 -29.808638 7.181683 0.0 0.0 -27.510336 -4.6246343 0.0 0.0 -43.61554
   -3.1726565 0.0 0.0 -1.3132447 0.26414728 0.0 0.0 -1.3350366 0.011193984 0.0
   0.0 -1.1406429 -0.6590894 0.0 0.0 -26.98065 -20.224789 0.0 0.0 -30.954882
   4.587423 0.0 0.0 -27.081968 -7.3700814 0.0 0.0 -86.64268 -61.521835 0.0 0.0
   -1.3231986 -0.19747958 0.0 0.0 -1.1126802 0.31250876 0.0 0.0 -1.2202998
   0.41316965 0.0 0.0 -743.2734 -306.16202 0.0 0.0 -1.3190943 0.11280095 0.0 0.0
   -1.2651987 -0.68287957 0.0 0.0 -1.3216443 0.058684185 0.0 0.0 -55.247715
   29.071548 0.0 0.0 -1.2876468 0.29760715 0.0 0.0 -31.392332 -3.8009307 0.0 0.0
   -1.3283008 0.17181017 0.0 0.0 -1.4750081 0.27793765 0.0 0.0 -32.627575
   -7.9319186 0.0 0.0 -28.11121 -0.4019752 0.0 0.0 -1.3069597 -0.20779695 0.0
   0.0 -27.295853 5.197584 0.0 0.0 -1.2743374 -0.06283621 0.0 0.0 -1.2445385
   -0.45363805 0.0 0.0 -27.037067 -7.7523966 0.0 0.0 -24.359474 -6.631247 0.0
   0.0 -35.459587 9.541132 0.0 0.0 -1.0442054 -0.6999589 0.0 0.0 -1.0161645
   -0.8479633 0.0 0.0 -29.301702 4.5112004 0.0 0.0 -47.84852 0.7722886 0.0 0.0
   -28.945438 -9.444423 0.0 0.0 -1.3228508 0.21858367 0.0 0.0 -1.8667593
   -0.27855211 0.0 0.0 -1.292996 -0.13091435 0.0 0.0 -681.731 319.66678 0.0 0.0
   -1.253737 -0.3723495 0.0 0.0 -1.3095375 0.28694895 0.0 0.0 -1.3044212
   -0.13917077 0.0 0.0 -0.4006348 -1.2751752 0.0 0.0 -31.0093 -13.072909 0.0 0.0
   -1.1866045 0.10759355 0.0 0.0 -1.1147531 0.54384196 0.0 0.0 -1.1965884
   0.4886957 0.0 0.0 -20.667288 8.455891 0.0 0.0 -1.1432996 -0.48731807 0.0 0.0
   -1.2658468 -0.42047644 0.0 0.0 -32.05225 -0.98327 0.0 0.0 -1.205458
   0.46358457 0.0 0.0 -885.7007 -174.10156 0.0 0.0 -40.704044 -0.7938015 0.0 0.0
   -39.301113 10.587685 0.0 0.0 -698.7013 286.44275 0.0 0.0 -1.2399395
   -0.28802344 0.0 0.0 -1.1981168 -0.5276123 0.0 0.0 -1.5243292 0.22953288 0.0
   0.0 -1.1751223 0.5952846 0.0 0.0 -59.39261 20.738602 0.0 0.0 -1.2952373
   -0.33725902 0.0 0.0 -904.3019 -6.0457096 0.0 0.0 -1.1758335 -0.25203654 0.0
   0.0 -3.0540357 0.37156183 0.0 0.0 -623.2374 -428.65967 0.0 0.0 -29.794577
   10.443535 0.0 0.0 -1.2154704 -0.52879757 0.0 0.0 -1.2381419 -0.37647712 0.0
   0.0 -756.8222 13.113582 0.0 0.0 -27.96333 3.8792934 0.0 0.0 -1.2541322
   0.20522968 0.0 0.0 -1.214075 -0.41924158 0.0 0.0 -23.94668 -14.786095 0.0 0.0
   -1.1638038 -0.4834549 0.0 0.0 -29.989399 7.32718 0.0 0.0 -0.9636455
   -0.9280165 0.0 0.0 -1.2066147 -0.51936615 0.0 0.0 -31.227736 -0.5906698 0.0
   0.0 -47.77446 4.060013 0.0 0.0 -780.10004 -281.998 0.0 0.0 -1.2004958
   -0.34431717 0.0 0.0 -53.743706 -18.007517 0.0 0.0 -1.1674391 0.60520697 0.0
   0.0 -1.327333 0.022018876 0.0 0.0 -1.1270118 -0.5382025 0.0 0.0 -26.562132
   17.89357 0.0 0.0 -26.58557 -9.411382 0.0 0.0 -37.02802 16.075819 0.0 0.0
   -26.96608 -8.232428 0.0 0.0 -1.3895323 0.23055081 0.0 0.0 -1146.8048
   318.32114 0.0 0.0 -1.2878798 -0.23447645 0.0 0.0 -28.28075 -0.4740035 0.0 0.0
   -29.744587 -8.438794 0.0 0.0 -45.349247 -16.512135 0.0 0.0 -1.2812613
   -0.31906 0.0 0.0 -1.2943171 -0.123586036 0.0 0.0 -1.3317593 -0.12161382 0.0
   0.0 -30.876825 -13.847481 0.0 0.0 -0.88405114 0.9438341 0.0 0.0 -1.2243352
   -0.42839122 0.0 0.0 -31.31048 -12.786778 0.0 0.0 -0.79844797 0.12258016 0.0
   0.0 -1.278689 -0.030122409 0.0 0.0 -1.2593577 -0.40958333 0.0 0.0 -28.30608
   0.78448313 0.0 0.0 -30.655912 9.929454 0.0 0.0 -894.63293 -177.32336 0.0 0.0
   -1.3170737 -0.120640546 0.0 0.0 -23.921267 21.112984 0.0 0.0 -0.9865875
   -0.4202723 0.0 0.0 -1.2500495 0.18862681 0.0 0.0 -1.3090888 0.26965472 0.0
   0.0 -66.42282 -8.792654 0.0 0.0 -1.2337025 -0.64024055 0.0 0.0 -1.2070733
   0.53655297 0.0 0.0 -44.023876 4.7000756 0.0 0.0 -1.2925242 -0.31771222 0.0
   0.0 -1.3050741 -0.23965542 0.0 0.0 -1.3100716 -0.17037137 0.0 0.0 -27.408155
   -7.0509434 0.0 0.0 -1.3326049 0.13959752 0.0 0.0 -991.32117 136.66971 0.0 0.0
   -1.0977759 -0.52211267 0.0 0.0 -1.2554296 0.1321636 0.0 0.0 -1.3318644
   0.1064665 0.0 0.0 -30.754763 8.519485 0.0 0.0 -1.1182438 -0.54246104 0.0 0.0
   -1.3249797 0.20905936 0.0 0.0 -1.0846086 -0.46505365 0.0 0.0 -1.0944482
   0.7712825 0.0 0.0 -56.81124 12.384348 0.0 0.0 -53.04579 -3.7890038 0.0 0.0
   -747.513 -164.0982 0.0 0.0 -30.215437 -11.284996 0.0 0.0 -30.012798 7.721579
   0.0 0.0 -91.089165 5.818374 0.0 0.0 -1.2265426 -0.00943239 0.0 0.0 -28.068916
   4.295384 0.0 0.0 -796.5974 261.27075 0.0 0.0 -1.0989763 0.32721958 0.0 0.0
   -28.683767 -7.50816 0.0 0.0 -1.5025463 0.32325053 0.0 0.0 -1.0164704
   -0.8260474 0.0 0.0 -78.54988 -28.36662 0.0 0.0 -1.607533 -0.38681367 0.0 0.0
   -1.2879312 0.25019726 0.0 0.0 -1.4756 0.7563906 0.0 0.0 -1.3074723 0.29072425
   0.0 0.0 -1.2822452 -0.22488095 0.0 0.0 -1.2080204 -0.40332383 0.0 0.0
   -1.6557928 1.088713 0.0 0.0 -1.1645781 0.1332257 0.0 0.0 -32.32567 1.2280667
   0.0 0.0 -31.793245 5.999581 0.0 0.0 -30.158411 7.345325 0.0 0.0 -29.776438
   8.581204 0.0 0.0 -0.82192594 -1.0236757 0.0 0.0 -30.756845 4.67237 0.0 0.0
   -839.307 57.998943 0.0 0.0 -1.3272288 -0.1597677 0.0 0.0 -1.2777554
   0.39655545 0.0 0.0 -29.412062 -12.537069 0.0 0.0 -1.2465051 -0.20796293 0.0
   0.0 -32.3716 -0.8076066 0.0 0.0 -1.3816329 -0.11289917 0.0 0.0 -1.2943723
   0.3286763 0.0 0.0 -1.229394 -0.412693 0.0 0.0 -1.2272675 0.04911158 0.0 0.0
   -1.2626246 0.30581367 0.0 0.0 -1.2807635 0.20236282 0.0 0.0 -1.2244437
   0.072365016 0.0 0.0 -37.66562 -24.151052 0.0 0.0 -1.2639133 -0.23061042 0.0
   0.0 -30.290665 -11.445376 0.0 0.0 -0.662047 -0.75815016 0.0 0.0 -1.3063571
   -0.27454466 0.0 0.0 -694.5584 -609.1688 0.0 0.0 -1.3497875 0.4555875 0.0 0.0
   -34.104847 -0.4137312 0.0 0.0 -1.0443155 -0.81370807 0.0 0.0 -42.268192
   14.492393 0.0 0.0 -35.25378 -12.291569 0.0 0.0 -30.900503 -4.1892977 0.0 0.0
   -28.424213 -1.4926324 0.0 0.0 -28.025187 5.2002177 0.0 0.0 -27.059341
   -15.195524 0.0 0.0 -1.3801805 -0.2349715 0.0 0.0 -949.7633 353.4714 0.0 0.0
   -24.953747 -18.70964 0.0 0.0 -924.0157 -61.394615 0.0 0.0 -1.331707
   0.15473369 0.0 0.0 -1.2789161 -0.36519077 0.0 0.0 -1.2297237 -0.4458332 0.0
   0.0 -841.01404 96.22674 0.0 0.0 -31.65086 -7.2223783 0.0 0.0 -40.860306
   0.11495831 0.0 0.0 -45.850792 -36.710667 0.0 0.0 -1.328457 -0.14936209 0.0
   0.0 -1.2929581 -0.35183844 0.0 0.0 -29.894915 -1.922773 0.0 0.0 -1.2996379
   -0.3185539 0.0 0.0 -29.359081 -13.273049 0.0 0.0 -1.145389 -0.24577875 0.0
   0.0 -1.2562684 0.21599358 0.0 0.0 -1.1827017 0.5911891 0.0 0.0 -1.3184147
   -0.07505193 0.0 0.0 -1.3002214 -0.29068622 0.0 0.0 -1.079812 -0.25749955 0.0
   0.0 -1.2687745 -0.27182803 0.0 0.0 -1.5381494 0.10254822 0.0 0.0 -779.04016
   -337.5607 0.0 0.0 -41.174015 -4.220812 0.0 0.0 -0.79069823 -1.0461636 0.0 0.0
   -1.3004373 0.2232031 0.0 0.0 -1.2791775 0.33815685 0.0 0.0 -1.3271236
   0.10966388 0.0 0.0 -714.192 -445.12964 0.0 0.0 -771.07135 90.269226 0.0 0.0
   -1.4781207 -0.030264288 0.0 0.0 -77.077156 -4.432928 0.0 0.0 -774.67993
   56.365173 0.0 0.0 -1.3233594 0.0031151252 0.0 0.0 -43.258698 10.8400545 0.0
   0.0 -1.0884879 0.76556665 0.0 0.0 -40.112476 8.630498 0.0 0.0 -0.9257125
   -0.36895072 0.0 0.0 -617.9029 585.747 0.0 0.0 -37.138172 -5.3401895 0.0 0.0
   -1.261198 0.41778475 0.0 0.0 -850.7746 42.987835 0.0 0.0 -1.0554327
   -0.57358885 0.0 0.0 -1.2728492 -0.18247184 0.0 0.0 -1.2932285 -0.14174485 0.0
   0.0 -1.4622451 0.4718521 0.0 0.0 -34.138004 0.9283562 0.0 0.0 -31.170702
   -3.1650875 0.0 0.0 -852.15125 -35.827763 0.0 0.0 -1.298025 0.3240676 0.0 0.0
   -31.616104 7.2800813 0.0 0.0 -0.93044245 -0.8480898 0.0 0.0 -29.484715
   -7.3293157 0.0 0.0 -1.0633214 -0.33557191 0.0 0.0 -31.260675 -1.3024594 0.0
   0.0 -1215.0989 -833.65045 0.0 0.0 -1.2499897 0.05045775 0.0 0.0 -1.2604804
   0.18978912 0.0 0.0 -789.2369 -327.26007 0.0 0.0 -32.120567 2.478442 0.0 0.0
   -1.06975 0.22696604 0.0 0.0 -27.905434 -6.5409226 0.0 0.0 -37.41416 3.8714426
   0.0 0.0 -1434.8179 346.983 0.0 0.0 -31.635937 1.8545284 0.0 0.0 -762.78516
   -167.8294 0.0 0.0 -1.2202445 0.30758083 0.0 0.0 -1.2669327 -0.08501273 0.0
   0.0 -2.6360328 0.34187523 0.0 0.0 -1.3176795 0.11905392 0.0 0.0 -1.3238593
   -0.19148052 0.0 0.0 -1.2576333 0.435415 0.0 0.0 -1.2652711 -0.22690961 0.0
   0.0 -34.170135 -15.76974 0.0 0.0 -28.622387 -1.2264427 0.0 0.0 -29.261309
   10.757355 0.0 0.0 -1.311534 -0.0064067724 0.0 0.0 -37.446186 5.5235577 0.0
   0.0 -1.2930343 -0.35327005 0.0 0.0 -851.66644 100.16238 0.0 0.0 -38.379307
   -15.151271 0.0 0.0 -815.0296 -267.59753 0.0 0.0 -32.132263 -5.8965516 0.0 0.0
   -1.32365 -0.02166293 0.0 0.0 -1.3271555 0.15026844 0.0 0.0 -1.3113824
   0.26937205 0.0 0.0 -822.69946 245.62628 0.0 0.0 -1.246163 0.36493304 0.0 0.0
   -1.2102054 0.56602234 0.0 0.0 -1.3076013 0.26419404 0.0 0.0 -49.001217
   7.3473682 0.0 0.0 -1236.3734 56.00396 0.0 0.0 -1.1407788 0.42865643 0.0 0.0
   -1.060614 -0.61858517 0.0 0.0 -1.3373424 0.10349908 0.0 0.0 -1.3088009
   0.11040804 0.0 0.0 -1.2622439 -0.3430517 0.0 0.0 -31.814396 7.1537986 0.0 0.0
   -32.650173 -10.299067 0.0 0.0 -32.46182 4.097321 0.0 0.0 -2.4311 -0.37715885
   0.0 0.0 -28.681425 1.8189092 0.0 0.0 -27.984428 -6.6341786 0.0 0.0 -850.8767
   132.50156 0.0 0.0 -34.016796 5.729524 0.0 0.0 -0.97069585 -0.9241796 0.0 0.0
   -1.239224 0.1490314 0.0 0.0 -30.347229 -12.267509 0.0 0.0 -1.1954051
   0.4607292 0.0 0.0 -1.4329765 0.13354146 0.0 0.0 -767.27545 -174.71445 0.0 0.0
   -1.3700205 -0.8889986 0.0 0.0 -1.33753 -0.061150867 0.0 0.0 -28.535091
   9.992638 0.0 0.0 -728.6805 -298.47397 0.0 0.0 -945.2114 23.559193 0.0 0.0
   -1.3355047 0.0950364 0.0 0.0 -1.2938291 0.16221625 0.0 0.0 -1.3242193
   -0.0913434 0.0 0.0 -37.28017 -4.8891397 0.0 0.0 -37.84329 0.29245737 0.0 0.0
   -1.3148324 -0.14398932 0.0 0.0 -1.3333259 0.02794813 0.0 0.0 -1.1209319
   -0.61169666 0.0 0.0 -1.2969172 -0.09161331 0.0 0.0 -1.260905 -0.2693023 0.0
   0.0 -1.334897 0.099963404 0.0 0.0 -31.215334 -9.254194 0.0 0.0 -32.001568
   7.1863394 0.0 0.0 -1.2996242 0.29912314 0.0 0.0 -40.959972 -6.664731 0.0 0.0
   -1.1996036 -0.28215742 0.0 0.0 -726.77795 -309.16074 0.0 0.0 -833.30994
   234.35641 0.0 0.0 -1.1051186 -0.723626 0.0 0.0 -658.4284 280.9843 0.0 0.0
   -0.7134993 -1.073227 0.0 0.0 -1.3068435 0.050241135 0.0 0.0 -1.3265314
   0.18850634 0.0 0.0 -1.3065422 0.029748337 0.0 0.0 -1.2929627 -0.31442857 0.0
   0.0 -1.3234409 -0.0021001063 0.0 0.0 -1.3582532 0.1584666 0.0 0.0 -1.3018135
   -0.14033608 0.0 0.0 -1.3045 -0.23471709 0.0 0.0 -31.322075 -22.56791 0.0 0.0
   -1.269607 0.07219354 0.0 0.0 -63.345097 16.667252 0.0 0.0 -2.2684386
   -1.1724373 0.0 0.0 -1196.5048 672.54865 0.0 0.0 -1.2067057 -0.5439152 0.0 0.0
   -48.002377 -13.019697 0.0 0.0 -1.2131821 -0.5415118 0.0 0.0 -1.1211925
   -0.5095916 0.0 0.0 -1.2385404 0.110351965 0.0 0.0 -1.3368495 -0.10181497 0.0
   0.0 -31.280659 4.054699 0.0 0.0 -29.583998 -14.349425 0.0 0.0 -1.3401945
   -0.03882049 0.0 0.0 -28.643799 15.828469 0.0 0.0 -1.3046745 0.15065104 0.0
   0.0 -35.50536 -13.542747 0.0 0.0 -1.0755594 0.7748509 0.0 0.0 -28.529783
   -13.578176 0.0 0.0 -1.3391603 0.030862466 0.0 0.0 -794.0729 -10.3106985 0.0
   0.0 -32.71506 2.9584055 0.0 0.0 -1.2498432 -0.24813278 0.0 0.0 -1.2509605
   0.28775403 0.0 0.0 -947.3286 -119.21466 0.0 0.0 -1366.6409 -181.70192 0.0 0.0
   -1.2246808 -0.0674777 0.0 0.0 -0.99743193 0.3550315 0.0 0.0 -54.36319
   7.512074 0.0 0.0 -27.921587 14.85086 0.0 0.0 -1.2473426 -0.46380207 0.0 0.0
   -1.3396195 -0.03304855 0.0 0.0 -30.508106 -11.969241 0.0 0.0 -1.3003186
   -0.073197745 0.0 0.0 -5.689472 0.75080097 0.0 0.0 -32.396965 -4.597715 0.0
   0.0 -29.693708 -7.987001 0.0 0.0 -1.2247057 -0.42804682 0.0 0.0 -1.2952676
   -0.2438746 0.0 0.0 -1.247709 -0.33801168 0.0 0.0 -1.2692971 0.20123783 0.0
   0.0 -30.394499 7.926434 0.0 0.0 -1.2985066 -0.12549406 0.0 0.0 -28.927174
   1.4867991 0.0 0.0 -34.667843 1.370076 0.0 0.0 -34.60005 3.1937082 0.0 0.0
   -1.207629 -0.58428085 0.0 0.0 -1.1792213 -0.342599 0.0 0.0 -1.2926205
   0.07016989 0.0 0.0 -1.2195082 0.3163175 0.0 0.0 -1.3152418 -0.2622879 0.0 0.0
   -32.831165 3.197857 0.0 0.0 -26.272911 -11.640859 0.0 0.0 -30.491838
   -12.59679 0.0 0.0 -1.3146741 0.1497935 0.0 0.0 -1.3291441 -0.10590061 0.0 0.0
   -790.793 113.42622 0.0 0.0 -1.157822 -0.102275565 0.0 0.0 -1.2437636
   0.45125362 0.0 0.0 -1.2961403 0.23894733 0.0 0.0 -28.360226 -6.0477824 0.0
   0.0 -1.1854626 0.05124259 0.0 0.0 -29.008465 0.3286483 0.0 0.0 -1.1779991
   0.0031996516 0.0 0.0 -28.369917 -6.0844254 0.0 0.0 -31.295633 -10.532494 0.0
   0.0 -25.840109 -18.516144 0.0 0.0 -22.3438 13.934862 0.0 0.0 -30.753572
   -8.134707 0.0 0.0 -1.239803 0.49891233 0.0 0.0 -34.821293 1.2750181 0.0 0.0
   -1.3255429 0.034994118 0.0 0.0 -1.1065518 -0.7581347 0.0 0.0 -32.064213
   7.5733285 0.0 0.0 -32.884407 0.48163018 0.0 0.0 -1.2811214 -0.30428734 0.0
   0.0 -28.831408 -3.4917583 0.0 0.0 -33.395008 12.444501 0.0 0.0 -33.186363
   -10.803361 0.0 0.0 -1724.9111 637.0103 0.0 0.0 -34.863415 -1.1627249 0.0 0.0
   -1.2476419 0.21550626 0.0 0.0 -1050.7218 -124.395874 0.0 0.0 -54.581406
   -7.7581177 0.0 0.0 -1.141592 -0.6086128 0.0 0.0 -36.04152 12.751097 0.0 0.0
   -1.3201776 -0.1857985 0.0 0.0 -45.075695 9.286934 0.0 0.0 -1.2992705
   -0.0870933 0.0 0.0 -1.0443285 -0.22976722 0.0 0.0 -1.8150189 0.542003 0.0 0.0
   -29.039543 1.4573097 0.0 0.0 -1.2185287 -0.53910047 0.0 0.0 -1.3082827
   -0.069582924 0.0 0.0 -30.104351 -10.374516 0.0 0.0 -30.238682 10.115934 0.0
   0.0 -1.0414503 -0.51067656 0.0 0.0 -28.41421 -6.124445 0.0 0.0 -31.95844
   -8.675735 0.0 0.0 -1.1842468 0.4355713 0.0 0.0 -30.869867 -7.8472276 0.0 0.0
   -1.3121762 0.06074631 0.0 0.0 -28.690544 -4.42911 0.0 0.0 -1.337328
   0.08036173 0.0 0.0 -1.3307083 -0.019885926 0.0 0.0 -814.88495 505.74423 0.0
   0.0 -1.3390677 -0.031238178 0.0 0.0 -1.2906473 -0.30253607 0.0 0.0
   -0.99058974 0.833214 0.0 0.0 -30.229933 -10.216849 0.0 0.0 -732.1383
   -337.1366 0.0 0.0 -31.710413 -3.741239 0.0 0.0 -1.260442 -0.4550839 0.0 0.0
   -30.613955 -8.568166 0.0 0.0 -28.92566 3.437465 0.0 0.0 -1.1601691
   -0.54438275 0.0 0.0 -850.5058 -800.53143 0.0 0.0 -32.3311 0.25632703 0.0 0.0
   -1.2025486 -0.5480798 0.0 0.0 -1.3402209 0.03720255 0.0 0.0 -1.309671
   0.033564243 0.0 0.0 -29.360243 -2.3892868 0.0 0.0 -29.090487 -1.8133619 0.0
   0.0 -95.00371 -18.033659 0.0 0.0 -22.818745 -26.50512 0.0 0.0 -1.3142914
   0.25931168 0.0 0.0 -1.3383313 -0.03880893 0.0 0.0 -1.3090173 -0.017678995 0.0
   0.0 -1.255823 0.22024806 0.0 0.0 -701.5353 -402.0046 0.0 0.0 -1.3395622
   -0.0434123 0.0 0.0 -1.2203659 0.19279785 0.0 0.0 -1.2806298 0.32829735 0.0
   0.0 -28.721025 -5.1545534 0.0 0.0 -28.943132 -3.1868556 0.0 0.0 -1.1759528
   -0.4093315 0.0 0.0 -1.047627 0.7560352 0.0 0.0 -42.885113 -17.435545 0.0 0.0
   -1.3350477 0.06390017 0.0 0.0 -1.2498069 -0.42755032 0.0 0.0 -930.2026
   291.96313 0.0 0.0 -1.3413633 -0.008790675 0.0 0.0 -861.59564 -218.89868 0.0
   0.0 -29.867224 6.57737 0.0 0.0 -0.6855231 -0.25117838 0.0 0.0 -836.90497
   301.11142 0.0 0.0 -26.280495 -9.669091 0.0 0.0 -1.3199847 0.043953642 0.0 0.0
   -34.389507 -21.055643 0.0 0.0 -1.2930428 0.06017779 0.0 0.0 -1.2276541
   -0.31722438 0.0 0.0 -1.2339268 -0.21617408 0.0 0.0 -1.2827559 -0.019294456
   0.0 0.0 -1154.5414 577.17194 0.0 0.0 -1.2376819 0.37333283 0.0 0.0 -28.700802
   5.5431924 0.0 0.0 -27.905094 8.628512 0.0 0.0 -887.1012 85.982605 0.0 0.0
   -1.3339466 0.12777811 0.0 0.0 -32.889065 4.7498593 0.0 0.0 -28.556337
   -6.145997 0.0 0.0 -1.8086252 -0.014073825 0.0 0.0 -32.05725 0.8823765 0.0 0.0
   -1.3228277 -0.06167459 0.0 0.0 -1.1815059 -0.5780419 0.0 0.0 -1.3287797
   0.1088106 0.0 0.0 -1.3094279 0.29155934 0.0 0.0 -1.30733 0.20768967 0.0 0.0
   -764.2018 -461.8842 0.0 0.0 -1.0913891 -0.371938 0.0 0.0 -1.2195342 0.2833593
   0.0 0.0 -1.2315043 -0.517542 0.0 0.0 -41.555637 -8.300626 0.0 0.0 -1.0071993
   -0.7944983 0.0 0.0 -1.2870914 0.3627523 0.0 0.0 -1.2948897 -0.0931928 0.0 0.0
   -807.81165 106.55749 0.0 0.0 -32.339718 3.9899604 0.0 0.0 -890.6111 -82.99735
   0.0 0.0 -1.1865138 0.14484638 0.0 0.0 -1.1769146 0.29764706 0.0 0.0
   -1.0847334 -0.55355877 0.0 0.0 -1.1444358 -0.5737946 0.0 0.0 -795.6854
   179.78076 0.0 0.0 -1.3224595 -0.21070153 0.0 0.0 -1.2487133 -0.4403125 0.0
   0.0 -1.2283446 0.24463165 0.0 0.0 -1.2058216 -0.58279604 0.0 0.0 -1.1797454
   -0.5304591 0.0 0.0 -1.3155383 0.1340712 0.0 0.0 -0.98772144 0.39600563 0.0
   0.0 -1.1628388 -0.45423678 0.0 0.0 -1.0723171 -0.7863919 0.0 0.0 -33.11632
   0.26633847 0.0 0.0 -1.3006672 0.21142058 0.0 0.0 -1.1083384 -0.14804833 0.0
   0.0 -1.237484 -0.31248796 0.0 0.0 -1091.4696 -465.26465 0.0 0.0 -41.53577
   -8.882092 0.0 0.0 -848.8262 -292.12708 0.0 0.0 -893.215 -91.03075 0.0 0.0
   -1.2395136 0.467836 0.0 0.0 -1.2905215 -0.11820662 0.0 0.0 -1.313467
   -0.25434577 0.0 0.0 -1.1617991 0.6117906 0.0 0.0 -748.5341 331.5644 0.0 0.0
   -47.177143 19.929235 0.0 0.0 -27.89164 -9.013178 0.0 0.0 -23.23434 17.845673
   0.0 0.0 -1.3286573 0.03155934 0.0 0.0 -1.2276175 -0.07491592 0.0 0.0
   -1.1132116 0.6949489 0.0 0.0 -1.2147491 -0.32377318 0.0 0.0 -24.26384
   -9.818946 0.0 0.0 -32.202827 0.44402742 0.0 0.0 -1.0961962 -0.17082843 0.0
   0.0 -1.096269 -0.69081783 0.0 0.0 -0.9612243 0.23734245 0.0 0.0 -1.3390043
   0.04445521 0.0 0.0 -1.2371217 -0.48489 0.0 0.0 -1.2727839 0.36506873 0.0 0.0
   -1.3379939 -0.04793453 0.0 0.0 -1.2262932 -0.5409883 0.0 0.0 -1.2032478
   -0.408672 0.0 0.0 -38.11699 -10.125795 0.0 0.0 -1.2587279 0.17967944 0.0 0.0
   -33.301693 3.0921617 0.0 0.0 -1.2273357 0.47995397 0.0 0.0 -0.6878337
   -0.98553413 0.0 0.0 -1557.0089 -266.3972 0.0 0.0 -1.2837969 0.17011937 0.0
   0.0 -31.893953 -10.153073 0.0 0.0 -1.3184836 -0.17084965 0.0 0.0 -29.39225
   1.0468369 0.0 0.0 -1.3295627 -0.059310425 0.0 0.0 -46.171894 -7.866086 0.0
   0.0 -31.159555 -11.225791 0.0 0.0 -32.51623 6.692967 0.0 0.0 -31.745905
   -5.81704 0.0 0.0 -1.2000996 0.26664856 0.0 0.0 -29.141607 -4.1405234 0.0 0.0
   -1.3049915 0.18292738 0.0 0.0 -1.4438155 -0.7967499 0.0 0.0 -1.0711917
   -0.44660497 0.0 0.0 -28.592506 -6.9034534 0.0 0.0 -1.0586549 -0.77155346 0.0
   0.0 -1.2772532 -0.35674614 0.0 0.0 -1.3572803 0.40814167 0.0 0.0 -1.2651708
   -0.27102107 0.0 0.0 -32.30239 0.124987066 0.0 0.0 -42.829918 3.0423973 0.0
   0.0 -33.045918 5.665213 0.0 0.0 -30.249868 -14.469933 0.0 0.0 -33.44521
   2.378376 0.0 0.0 -38.38171 6.6611676 0.0 0.0 -28.624725 6.452976 0.0 0.0
   -1.2197781 -0.29920167 0.0 0.0 -1.6669366 -0.88080066 0.0 0.0 -1.2892027
   -0.0712367 0.0 0.0 -1.8363464 -0.9185567 0.0 0.0 -882.8125 -208.37717 0.0 0.0
   -1.2896041 0.021249479 0.0 0.0 -30.031113 -6.578693 0.0 0.0 -1.0071226
   -0.85529417 0.0 0.0 -1.1452366 0.60146785 0.0 0.0 -42.721394 2.122597 0.0 0.0
   -1.3022994 -0.31722322 0.0 0.0 -26.16329 5.323037 0.0 0.0 -28.985476
   -5.490672 0.0 0.0 -30.873411 -15.178691 0.0 0.0 -902.5911 -104.45142 0.0 0.0
   -1.2628834 -0.40334004 0.0 0.0 -47.041508 0.36382285 0.0 0.0 -1445.3098
   -140.15184 0.0 0.0 -1.2171568 0.55586594 0.0 0.0 -1.3227979 -0.053857572 0.0
   0.0 -1.2433149 0.43714687 0.0 0.0 -59.091637 -34.413853 0.0 0.0 -1.2157301
   0.29806638 0.0 0.0 -1204.9115 34.96117 0.0 0.0 -28.969898 5.7240386 0.0 0.0
   -31.432106 10.044778 0.0 0.0 -28.89694 -5.8551087 0.0 0.0 -1.2854444
   0.30697373 0.0 0.0 -1.2798591 -0.34739247 0.0 0.0 -678.0513 -477.66647 0.0
   0.0 -28.830227 -13.759396 0.0 0.0 -0.79323 0.29461244 0.0 0.0 -1.2956964
   -0.028587947 0.0 0.0 -28.187521 8.148753 0.0 0.0 -1.2915031 0.21801552 0.0
   0.0 -1.3407685 -0.043667328 0.0 0.0 -42.698387 4.4868073 0.0 0.0 -1.2363338
   0.36120483 0.0 0.0 -33.817707 20.769289 0.0 0.0 -739.5273 -378.48734 0.0 0.0
   -589.58374 557.2456 0.0 0.0 -1327.6254 -51.15786 0.0 0.0 -32.33704 2.4409106
   0.0 0.0 -1.2143868 -0.4981384 0.0 0.0 -1.1619506 -0.5923236 0.0 0.0
   -1.3381118 -0.03811466 0.0 0.0 -1.1570864 0.07830958 0.0 0.0 -1.3404707
   -0.032203317 0.0 0.0 -32.33781 -9.39911 0.0 0.0 -1.0642762 -0.77697474 0.0
   0.0 -28.663988 17.540897 0.0 0.0 -1.3059843 0.0630481 0.0 0.0 -31.223175
   12.573883 0.0 0.0 -1.2844746 -0.10689456 0.0 0.0 -1.1831045 -0.58943146 0.0
   0.0 -1.318876 0.23045766 0.0 0.0 -33.57977 -2.389931 0.0 0.0 -911.2935
   -85.19607 0.0 0.0 -1.1967297 -0.4801568 0.0 0.0 -0.9704986 -0.8884846 0.0 0.0
   -1.1442512 0.032727454 0.0 0.0 -1.2040586 -0.5162548 0.0 0.0 -0.84140706
   -0.6234085 0.0 0.0 -30.809929 -11.428418 0.0 0.0 -31.211008 12.3081 0.0 0.0
   -1.2843698 -0.2838479 0.0 0.0 -0.4057939 -0.37370652 0.0 0.0 -35.42911
   4.6121306 0.0 0.0 -29.16827 -5.231473 0.0 0.0 -1.2766795 -0.31349903 0.0 0.0
   -33.657547 -2.0767632 0.0 0.0 -1.1239548 -0.6541004 0.0 0.0 -18.781317
   -22.873276 0.0 0.0 -1.3296056 -0.1764719 0.0 0.0 -1.2605516 -0.20633976 0.0
   0.0 -1.2987838 -0.120535895 0.0 0.0 -47.19671 1.5587541 0.0 0.0 -1.3402135
   -0.03323685 0.0 0.0 -1.200801 -0.44067594 0.0 0.0 -1.2176405 0.2988674 0.0
   0.0 -1.3282447 0.09103368 0.0 0.0 -23.800047 -31.136248 0.0 0.0 -1017.7066
   442.13824 0.0 0.0 -1.2895497 -0.2622664 0.0 0.0 -1.2500395 -0.47119075 0.0
   0.0 -47.97602 -30.093597 0.0 0.0 -28.011656 -9.755663 0.0 0.0 -38.158215
   -9.483912 0.0 0.0 -33.269547 -4.529247 0.0 0.0 -29.73077 15.502101 0.0 0.0
   -812.0588 205.41231 0.0 0.0 -1.7140269 -0.966667 0.0 0.0 -1.3365809
   -0.08383949 0.0 0.0 -1.2666417 0.017311312 0.0 0.0 -47.95984 20.377144 0.0
   0.0 -57.18877 3.609816 0.0 0.0 -1.0788046 -0.2226093 0.0 0.0 -1.2014804
   -0.39889118 0.0 0.0 -1.2250832 0.37219223 0.0 0.0 -1.283199 -0.29553467 0.0
   0.0 -57.25959 -3.159009 0.0 0.0 -1.2012788 0.52468395 0.0 0.0 -1.3190424
   -0.19586822 0.0 0.0 -1.2415898 -0.2579455 0.0 0.0 -1.312909 0.18097611 0.0
   0.0 -0.86089665 0.9594785 0.0 0.0 -31.384235 12.6426935 0.0 0.0 -766.2342
   -514.66486 0.0 0.0 -1.2455876 0.40030736 0.0 0.0 -30.710667 -1.5395883 0.0
   0.0 -0.9235315 0.9668022 0.0 0.0 -26.664696 1.4592649 0.0 0.0 -1.2644329
   -0.43340465 0.0 0.0 -1.553545 -0.0807333 0.0 0.0 -27.860441 -17.02976 0.0 0.0
   -1.2911718 -0.1550597 0.0 0.0 -31.777168 9.961804 0.0 0.0 -1.3220809
   0.21586913 0.0 0.0 -1.2486733 -0.33543745 0.0 0.0 -1.3054186 -0.6076252 0.0
   0.0 -51.10099 -23.794584 0.0 0.0 -27.523636 19.524744 0.0 0.0 -29.626917
   2.8438299 0.0 0.0 -1.2532861 0.24204564 0.0 0.0 -1.2830627 -0.0666956 0.0 0.0
   -35.265213 -17.734251 0.0 0.0 -53.56243 -20.880854 0.0 0.0 -28.349623
   9.042215 0.0 0.0 -1.2787077 0.28655985 0.0 0.0 -51.7964 0.11048432 0.0 0.0
   -1.1215383 0.7171237 0.0 0.0 -1434.6564 -782.34436 0.0 0.0 -33.56308
   -27.50518 0.0 0.0 -22.60347 -15.261263 0.0 0.0 -1.2522008 -0.3837927 0.0 0.0
   -1.2370381 0.42428222 0.0 0.0 -31.82746 7.6092777 0.0 0.0 -1.2408159 0.460906
   0.0 0.0 -0.65571135 -1.1685798 0.0 0.0 -29.367218 -3.3835032 0.0 0.0
   -838.0039 -103.80981 0.0 0.0 -1.2123643 -0.40170226 0.0 0.0 -1.1762285
   0.015373677 0.0 0.0 -1.3557239 0.36049482 0.0 0.0 -1.1899716 0.45318753 0.0
   0.0 -1.2709777 0.2615052 0.0 0.0 -1.2587357 -0.29286402 0.0 0.0 -1011.03107
   146.02571 0.0 0.0 -1.2852018 -0.29592425 0.0 0.0 -1.1123276 -0.6583531 0.0
   0.0 -1.2879908 -0.33506474 0.0 0.0 -1.3336823 0.12989809 0.0 0.0 -1.2794869
   0.087803364 0.0 0.0 -1.2913238 -0.13177532 0.0 0.0 -1.1725672 -0.6441278 0.0
   0.0 -0.7785827 -1.0897895 0.0 0.0 -1.2414173 0.42754015 0.0 0.0 -44.000645
   -18.672262 0.0 0.0 -33.6907 -12.611774 0.0 0.0 -39.668438 -5.9625287 0.0 0.0
   -1.1816155 0.5078121 0.0 0.0 -31.857681 8.435154 0.0 0.0 -1.2235385 0.4025503
   0.0 0.0 -0.7924789 -0.8754561 0.0 0.0 -36.362152 -16.388851 0.0 0.0
   -33.844257 -1.3466494 0.0 0.0 -33.925407 -1.9890162 0.0 0.0 -31.519695
   -12.7398405 0.0 0.0 -991.03314 -74.256424 0.0 0.0 -63.571823 1.0414652 0.0
   0.0 -1.2839175 0.3135059 0.0 0.0 -0.97889847 -0.8913582 0.0 0.0 -925.1388
   -122.30094 0.0 0.0 -1.3041825 0.24578927 0.0 0.0 -51.511467 -10.998889 0.0
   0.0 -30.582172 -14.553624 0.0 0.0 -1.3086001 -0.04972689 0.0 0.0 -31.339676
   13.16829 0.0 0.0 -112.4288 0.75202817 0.0 0.0 -1.2357934 -0.18117858 0.0 0.0
   -1.2269691 -0.43627292 0.0 0.0 -847.0744 -70.27087 0.0 0.0 -57.474705
   6.6005087 0.0 0.0 -1.1924324 -0.42592493 0.0 0.0 -1.1764144 0.15894718 0.0
   0.0 -1.2061725 0.18963784 0.0 0.0 -1.2269665 0.17729159 0.0 0.0 -1.5016617
   -0.4158595 0.0 0.0 -1.2656673 0.3637841 0.0 0.0 -56.70524 7.564241 0.0 0.0
   -1345.988 247.36598 0.0 0.0 -1.146252 0.32132477 0.0 0.0 -1.1235001
   -0.7155532 0.0 0.0 -1.2707269 -0.25659922 0.0 0.0 -1.2932235 0.35257015 0.0
   0.0 -1.2325861 0.24780375 0.0 0.0 -1.2678494 -0.13061331 0.0 0.0 -63.85977
   0.058371853 0.0 0.0 -41.159554 -14.946363 0.0 0.0 -1.1984756 0.50036734 0.0
   0.0 -1.3260282 -0.15615468 0.0 0.0 -33.223957 3.9038572 0.0 0.0 -1.2802109
   0.06938843 0.0 0.0 -33.35466 -2.3715641 0.0 0.0 -1.3126918 0.16743408 0.0 0.0
   -1.2090741 0.23523453 0.0 0.0 -29.314478 -6.2022862 0.0 0.0 -29.893927
   -16.290604 0.0 0.0 -1.3056172 -0.1745789 0.0 0.0 -1.253081 0.33356866 0.0 0.0
   -33.991863 1.3962442 0.0 0.0 -28.861519 -7.798409 0.0 0.0 -28.94133 15.758146
   0.0 0.0 -935.5484 -87.40393 0.0 0.0 -1.2060634 -0.4660137 0.0 0.0 -1.2034774
   -0.55410904 0.0 0.0 -775.3075 -249.70822 0.0 0.0 -27.319487 -12.363611 0.0
   0.0 -1.2080929 0.097457044 0.0 0.0 -918.99915 474.99 0.0 0.0 -1.4094406
   0.30636504 0.0 0.0 -1.2578676 0.26611367 0.0 0.0 -1.3347701 0.041900624 0.0
   0.0 -824.2462 -785.5525 0.0 0.0 -37.326256 11.44401 0.0 0.0 -1.3285899
   0.08138354 0.0 0.0 -1.1594849 0.5903571 0.0 0.0 -1.3201864 0.19937435 0.0 0.0
   -667.5663 -536.4436 0.0 0.0 -1.1726917 -0.0013812335 0.0 0.0 -34.080315
   -0.38886273 0.0 0.0 -1.1335678 0.29412878 0.0 0.0 -34.61384 -10.917265 0.0
   0.0 -19.807178 16.256212 0.0 0.0 -44.012833 0.7956404 0.0 0.0 -34.779747
   -10.153155 0.0 0.0 -1.4567055 -1.039718 0.0 0.0 -1.1001551 0.36205447 0.0 0.0
   -1.2178272 -0.49790785 0.0 0.0 -31.07314 -10.613071 0.0 0.0 -28.539494
   9.390597 0.0 0.0 -41.815723 13.009977 0.0 0.0 -34.970757 9.785309 0.0 0.0
   -1.122048 -0.73445773 0.0 0.0 -1.1753433 -0.24312422 0.0 0.0 -1.2338762
   0.478255 0.0 0.0 -32.23138 7.049501 0.0 0.0 -106.806496 -9.501309 0.0 0.0
   -60.645157 21.40207 0.0 0.0 -36.31036 -1.8185583 0.0 0.0 -1.3088654
   0.21537386 0.0 0.0 -34.13484 1.7578545 0.0 0.0 -1102.4583 307.93323 0.0 0.0
   -1.3262805 0.070626564 0.0 0.0 -844.0407 -164.67749 0.0 0.0 -1.2023664
   -0.32392806 0.0 0.0 -1382.9236 -643.5756 0.0 0.0 -1.327372 0.14438258 0.0 0.0
   -51.979004 -5.6694384 0.0 0.0 -1.5437932 -0.11047479 0.0 0.0 -1.2342834
   0.2516577 0.0 0.0 -1.1867744 -0.6136271 0.0 0.0 -0.9775208 -0.3908538 0.0 0.0
   -1.2353258 -0.4581962 0.0 0.0 -35.11004 7.5584526 0.0 0.0 -1386.5376 81.32892
   0.0 0.0 -24.807327 -17.043879 0.0 0.0 -30.56099 15.268048 0.0 0.0 -922.2799
   -22.001036 0.0 0.0 -1.1729623 0.61392254 0.0 0.0 -1.2769665 -0.07355574 0.0
   0.0 -1.1554127 0.5449737 0.0 0.0 -32.748386 -5.404917 0.0 0.0 -1.3277204
   0.045200933 0.0 0.0 -30.546318 -14.613797 0.0 0.0 -1037.9536 -118.05644 0.0
   0.0 -1.3126788 0.15259017 0.0 0.0 -31.924673 8.8884325 0.0 0.0 -41.496128
   15.367387 0.0 0.0 -1.3104243 -0.103953086 0.0 0.0 -1.2004806 -0.58339465 0.0
   0.0 -1.3113021 0.13368021 0.0 0.0 -0.8635425 0.10547896 0.0 0.0 -964.73364
   -404.49585 0.0 0.0 -1016.369 -540.8808 0.0 0.0 -36.308155 3.524217 0.0 0.0
   -1.3319197 0.098497234 0.0 0.0 -43.712826 -6.896303 0.0 0.0 -1.2325486
   0.14792667 0.0 0.0 -1.2938619 0.3518828 0.0 0.0 -1.2639582 -0.42358148 0.0
   0.0 -1.2482219 0.05433771 0.0 0.0 -1.2299666 -0.52649295 0.0 0.0 -30.166609
   -0.46431345 0.0 0.0 -35.7335 16.102804 0.0 0.0 -48.552086 2.4528198 0.0 0.0
   -1.2516675 -0.444646 0.0 0.0 -1.2256069 0.53852606 0.0 0.0 -33.159424
   -1.5995755 0.0 0.0 -60.38293 -23.45926 0.0 0.0 -27.156555 15.059378 0.0 0.0
   -52.136112 -11.849254 0.0 0.0 -863.6328 70.96522 0.0 0.0 -766.3803 -567.85114
   0.0 0.0 -32.3459 -11.523781 0.0 0.0 -40.695633 17.276505 0.0 0.0 -1.1708035
   -0.1586963 0.0 0.0 -33.37899 14.8947935 0.0 0.0 -1.3961041 0.3399141 0.0 0.0
   -1.3263638 -0.08782465 0.0 0.0 -1.1237596 0.60170907 0.0 0.0 -1.1045511
   -0.30744117 0.0 0.0 -1.3062156 -0.2846239 0.0 0.0 -32.926605 4.5389686 0.0
   0.0 -34.234657 3.381599 0.0 0.0 -26.003353 -15.399107 0.0 0.0 -2.712581
   0.20758207 0.0 0.0 -34.06139 -4.258374 0.0 0.0 -1.3005813 0.326261 0.0 0.0
   -1.3252894 -0.06578342 0.0 0.0 -1.2005099 -0.40237248 0.0 0.0 -1.1560746
   -0.3615537 0.0 0.0 -57.956116 11.335772 0.0 0.0 -1.1463429 0.41607344 0.0 0.0
   -1.2927874 0.30775687 0.0 0.0 -1.2271876 -0.46093708 0.0 0.0 -1.135737
   -0.6282371 0.0 0.0 -1.2945397 0.29840505 0.0 0.0 -57.742214 12.017334 0.0 0.0
   -36.620083 -0.7235401 0.0 0.0 -1402.2262 -112.81253 0.0 0.0 -1405.3792
   68.18249 0.0 0.0 -28.781437 -9.320861 0.0 0.0 -30.246578 -0.7959576 0.0 0.0
   -0.33508894 -0.38281372 0.0 0.0 -1.11067 -0.6819697 0.0 0.0 -1.2960104
   -0.33288485 0.0 0.0 -1.2347686 0.46611845 0.0 0.0 -1.8104696 0.0410315 0.0
   0.0 -33.078056 4.0024242 0.0 0.0 -1.5396434 0.2522297 0.0 0.0 -1.2862998
   0.10113158 0.0 0.0 -33.31663 -15.332938 0.0 0.0 -1.2908347 -0.36120674 0.0
   0.0 -1.4500542 0.28319246 0.0 0.0 -39.767963 6.8865066 0.0 0.0 -1.0770997
   -0.3220238 0.0 0.0 -1.3738152 -0.42710188 0.0 0.0 -1.2749623 -0.37530556 0.0
   0.0 -1.3272848 0.18140684 0.0 0.0 -50.391983 -18.577797 0.0 0.0 -1.292514
   0.1846108 0.0 0.0 -32.679752 -10.052361 0.0 0.0 -1.3328607 -0.078586176 0.0
   0.0 -1.1728578 0.46742043 0.0 0.0 -1.3107716 -0.15766238 0.0 0.0 -45.789654
   -17.330929 0.0 0.0 -43.890205 6.4008617 0.0 0.0 -29.000376 -15.666198 0.0 0.0
   -1.3352032 0.048954353 0.0 0.0 -1.3246129 -0.06021782 0.0 0.0 -1.2725095
   -0.17855291 0.0 0.0 -1.2732377 0.41430557 0.0 0.0 -784.573 -387.28107 0.0 0.0
   -1.2410735 -0.28157276 0.0 0.0 -1.3112409 0.1307602 0.0 0.0 -30.53107
   -13.502803 0.0 0.0 -1.3248099 0.20270802 0.0 0.0 -71.32936 9.794916 0.0 0.0
   -40.92134 0.28440756 0.0 0.0 -1.3204204 0.23317723 0.0 0.0 -1.4637125
   -0.5467105 0.0 0.0 -1.3032291 -0.06040901 0.0 0.0 -16.450428 25.33492 0.0 0.0
   -32.373417 -8.193616 0.0 0.0 -29.815468 -5.756217 0.0 0.0 -1.1977417
   -0.37190142 0.0 0.0 -1.1188667 -0.6434363 0.0 0.0 -1.0352994 -0.62289697 0.0
   0.0 -34.54356 -1.2789525 0.0 0.0 -1.3337913 0.09855003 0.0 0.0 -1.3084267
   -0.19971439 0.0 0.0 -1.1455824 0.2648365 0.0 0.0 -40.724514 -18.420214 0.0
   0.0 -1.3202671 -0.045684647 0.0 0.0 -32.834896 -1.3973248 0.0 0.0 -1.5013118
   0.19839422 0.0 0.0 -24.479044 -11.110647 0.0 0.0 -1.3044971 -0.16756299 0.0
   0.0 -30.050524 4.281418 0.0 0.0 -1.2677313 -0.2902913 0.0 0.0 -1.218345
   -0.05363722 0.0 0.0 -1.1849257 0.5050685 0.0 0.0 -1.2818927 -0.70887464 0.0
   0.0 -33.456997 -1.0506873 0.0 0.0 -1.3354295 -0.001472503 0.0 0.0 -1.2625712
   0.4295488 0.0 0.0 -1.4460167 0.049214236 0.0 0.0 -36.087414 -7.5481153 0.0
   0.0 -1.2557192 0.050948687 0.0 0.0 -1.0788498 -0.28803533 0.0 0.0 -2.3416247
   -0.05239025 0.0 0.0 -1.3325026 0.07359892 0.0 0.0 -1.2494282 0.46367928 0.0
   0.0 -1.2182419 -0.47421393 0.0 0.0 -1.2789147 -0.37698805 0.0 0.0 -1.2830389
   -0.28523245 0.0 0.0 -1.3094536 -0.12653589 0.0 0.0 -1.3145046 -0.16866933 0.0
   0.0 -1.3267332 -0.032449022 0.0 0.0 -810.5171 -501.68903 0.0 0.0 -0.6215755
   0.4484849 0.0 0.0 -1.1706816 -0.5275435 0.0 0.0 -1.3360859 -0.060404964 0.0
   0.0 -1.2178603 -0.35254815 0.0 0.0 -1.1275498 -0.6928796 0.0 0.0 -36.485798
   -5.6045246 0.0 0.0 -1.0934877 -0.7619114 0.0 0.0 -1.300188 -0.3160123 0.0 0.0
   -1.0907975 -0.0047331154 0.0 0.0 -1.2833873 -0.33369642 0.0 0.0 -1.2141136
   -0.50716203 0.0 0.0 -28.108877 -11.76737 0.0 0.0 -33.36664 -3.2871222 0.0 0.0
   -882.4143 -41.751682 0.0 0.0 -1.2508676 -0.36855105 0.0 0.0 -1.2098944
   0.50638276 0.0 0.0 -1016.1636 -602.672 0.0 0.0 -874.84216 427.61487 0.0 0.0
   -1430.1799 107.483406 0.0 0.0 -1.3360928 -0.06972124 0.0 0.0 -1.2634858
   0.35818624 0.0 0.0 -1.1938653 -0.16416757 0.0 0.0 -1.297799 0.06672256 0.0
   0.0 -1.326443 -0.19771354 0.0 0.0 -922.5275 -315.1724 0.0 0.0 -47.509464
   13.545783 0.0 0.0 -31.005468 2.830387 0.0 0.0 -1.2345939 -0.276134 0.0 0.0
   -33.535374 -2.1755247 0.0 0.0 -817.4369 340.77518 0.0 0.0 -1.2274629
   0.44051468 0.0 0.0 -1135.023 339.21005 0.0 0.0 -1.2679116 0.15687615 0.0 0.0
   -1.4102156 -0.07873403 0.0 0.0 -1.1811106 -0.5950811 0.0 0.0 -1.0633998
   -0.5475774 0.0 0.0 -1.1086192 -0.08911545 0.0 0.0 -1.2689716 -0.4129453 0.0
   0.0 -29.634417 -15.911452 0.0 0.0 -1.3252084 0.07661712 0.0 0.0 -63.819168
   28.671114 0.0 0.0 -0.9736567 -0.7961191 0.0 0.0 -1.327833 0.1815306 0.0 0.0
   -72.43893 -21.326822 0.0 0.0 -715.17065 -667.2275 0.0 0.0 -607.6236 426.85458
   0.0 0.0 -48.423756 10.445509 0.0 0.0 -1.3080658 -0.20939718 0.0 0.0 -33.01114
   6.60372 0.0 0.0 -1.324147 -0.14839713 0.0 0.0 -1.2223079 0.4787708 0.0 0.0
   -32.7393 -7.8341503 0.0 0.0 -101.77181 3.6087582 0.0 0.0 -33.940437 7.5619345
   0.0 0.0 -30.47322 -2.5362601 0.0 0.0 -36.924267 3.2392242 0.0 0.0 -1.3246543
   -0.02593703 0.0 0.0 -1.169225 -0.22575071 0.0 0.0 -1.0221491 -0.85054123 0.0
   0.0 -1.2971332 0.34052765 0.0 0.0 -1.339748 0.0052461945 0.0 0.0 -1.330728
   -0.0521414 0.0 0.0 -54.58447 2.827035 0.0 0.0 -1.1410838 0.18530531 0.0 0.0
   -1.279052 -0.07297311 0.0 0.0 -31.969437 -10.608556 0.0 0.0 -1.2649492
   -0.23886195 0.0 0.0 -1.2525641 0.4804403 0.0 0.0 -1.3256505 -0.15891409 0.0
   0.0 -24.350315 13.915195 0.0 0.0 -1.3143157 0.028070217 0.0 0.0 -1.3102356
   -0.28598374 0.0 0.0 -3.3669827 -1.9878864 0.0 0.0 -945.7188 267.25848 0.0 0.0
   -1.2687256 0.34126738 0.0 0.0 -44.569244 6.859611 0.0 0.0 -1.2039102
   -0.41151097 0.0 0.0 -3.243808 -0.73940605 0.0 0.0 -43.59027 -4.829937 0.0 0.0
   -1.2790806 0.32286206 0.0 0.0 -1.2841307 0.35172313 0.0 0.0 -1.3249867
   0.19110425 0.0 0.0 -30.34526 2.0606217 0.0 0.0 -30.450756 -3.495787 0.0 0.0
   -49.117786 -7.882018 0.0 0.0 -34.260574 -5.926784 0.0 0.0 -1.1692214
   -0.6326994 0.0 0.0 -32.898518 10.5941305 0.0 0.0 -43.730362 5.240847 0.0 0.0
   -33.481937 6.208557 0.0 0.0 -33.0502 10.49128 0.0 0.0 -0.95136917 -0.25196308
   0.0 0.0 -1.3175894 0.08446205 0.0 0.0 -29.923979 6.7425475 0.0 0.0 -1.0457441
   0.526026 0.0 0.0 -32.56692 12.280769 0.0 0.0 -1.1336209 0.45451054 0.0 0.0
   -40.86157 3.7805345 0.0 0.0 -34.384857 5.9500513 0.0 0.0 -1.3029449
   -0.08465981 0.0 0.0 -34.671627 -3.407176 0.0 0.0 -30.034622 -10.290416 0.0
   0.0 -1.2608645 0.39683747 0.0 0.0 -1.0899936 -0.69767684 0.0 0.0 -34.896305
   -1.5857356 0.0 0.0 -36.65419 -6.412177 0.0 0.0 -1.3246592 -0.009731532 0.0
   0.0 -986.98035 49.93235 0.0 0.0 -1.3070931 0.25071356 0.0 0.0 -1.2343099
   0.42167214 0.0 0.0 -1.329495 -0.17577417 0.0 0.0 -33.832367 0.8239032 0.0 0.0
   -44.595432 0.6827698 0.0 0.0 -29.63785 -3.6226263 0.0 0.0 -30.590105
   13.010119 0.0 0.0 -1.2729667 -0.1428473 0.0 0.0 -40.69948 -5.592364 0.0 0.0
   -767.76715 -465.57364 0.0 0.0 -1.3150777 -0.12134085 0.0 0.0 -1.3261725
   -0.12587054 0.0 0.0 -33.933125 -7.311047 0.0 0.0 -1.1721066 0.5942374 0.0 0.0
   -1076.6033 183.73479 0.0 0.0 -32.4553 9.59765 0.0 0.0 -1.1940061 0.30965066
   0.0 0.0 -0.41209725 -1.2237004 0.0 0.0 -71.08007 19.748508 0.0 0.0 -1.326435
   -0.13013355 0.0 0.0 -36.89142 5.843938 0.0 0.0 -1.2612625 -0.382462 0.0 0.0
   -1.0962987 0.58776915 0.0 0.0 -24.648245 -19.974348 0.0 0.0 -1.2119353
   -0.57215744 0.0 0.0 -1.2639172 -0.1911492 0.0 0.0 -108.8889 6.8497915 0.0 0.0
   -34.89286 1.4399372 0.0 0.0 -1.2750671 0.20297958 0.0 0.0 -30.53502
   -3.8200798 0.0 0.0 -35.81347 -10.69337 0.0 0.0 -1.3329988 0.0071840403 0.0
   0.0 -28.138828 -12.373797 0.0 0.0 -1.3081341 0.20429862 0.0 0.0 -34.37482
   -5.4007015 0.0 0.0 -31.90361 -11.840428 0.0 0.0 -0.906627 0.061652243 0.0 0.0
   -1.2804497 -0.3496549 0.0 0.0 -34.07374 -6.338271 0.0 0.0 -1.2116791
   -0.571246 0.0 0.0 -1.2063808 0.08481893 0.0 0.0 -1619.4673 -93.12519 0.0 0.0
   -37.27791 -3.166314 0.0 0.0 -32.942055 8.248196 0.0 0.0 -1.3033249 0.2865999
   0.0 0.0 -1.291013 -0.2668919 0.0 0.0 -0.8267665 -1.0412102 0.0 0.0 -1.3208224
   0.23424308 0.0 0.0 -1.2766658 -0.40627208 0.0 0.0 -75.01123 -18.873392 0.0
   0.0 -99.346695 -1.7790922 0.0 0.0 -800.1512 -420.22974 0.0 0.0 -814.3363
   -392.35858 0.0 0.0 -2.5318255 -1.1376858 0.0 0.0 -1.1004931 0.7072953 0.0 0.0
   -1.3086272 0.29479572 0.0 0.0 -1.7893481 0.42434677 0.0 0.0 -30.99236
   15.825222 0.0 0.0 -1.252992 0.33090848 0.0 0.0 -0.676298 0.58388746 0.0 0.0
   -1.2289244 -0.51673 0.0 0.0 -34.94541 -1.4288344 0.0 0.0 -60.15152 -10.633899
   0.0 0.0 -1.314619 0.11304057 0.0 0.0 -33.445568 8.826056 0.0 0.0 -1.2153741
   -0.4623136 0.0 0.0 -30.790688 0.7772229 0.0 0.0 -1.1835809 0.33132538 0.0 0.0
   -0.8896098 -1.0037189 0.0 0.0 -39.388187 12.615869 0.0 0.0 -1.1747913
   0.42152625 0.0 0.0 -1.3075932 0.2790395 0.0 0.0 -32.623123 -9.693614 0.0 0.0
   -1.3277115 -0.06543313 0.0 0.0 -1.1654134 -0.49875635 0.0 0.0 -1.2881023
   0.37173206 0.0 0.0 -30.741955 -16.715902 0.0 0.0 -1.2511884 0.3966214 0.0 0.0
   -1.0897651 -0.5835227 0.0 0.0 -32.48583 -13.108658 0.0 0.0 -30.898098
   -0.22556086 0.0 0.0 -41.081608 -7.845357 0.0 0.0 -33.20735 9.942227 0.0 0.0
   -1.4027122 -0.058221318 0.0 0.0 -1.0743153 0.06170298 0.0 0.0 -30.860691
   1.7688054 0.0 0.0 -35.09807 2.6196997 0.0 0.0 -1.3382306 0.0099589415 0.0 0.0
   -62.751625 24.790262 0.0 0.0 -33.243183 -40.67853 0.0 0.0 -1.2148958
   -0.47972423 0.0 0.0 -121.09369 12.262972 0.0 0.0 -1.3302728 -0.16881667 0.0
   0.0 -34.75937 -4.0562143 0.0 0.0 -43.746662 -13.066313 0.0 0.0 -1.3193436
   0.24117379 0.0 0.0 -1002.3401 57.443127 0.0 0.0 -34.89618 -4.608233 0.0 0.0
   -1.2863266 -0.02646179 0.0 0.0 -30.94506 -0.010665493 0.0 0.0 -1.2458199
   -0.28173763 0.0 0.0 -36.9587 7.052619 0.0 0.0 -34.30637 -7.483198 0.0 0.0
   -1.3029097 0.31164846 0.0 0.0 -1.3053559 -0.05865722 0.0 0.0 -1.3341265
   -0.096507885 0.0 0.0 -1.1757993 -0.5836742 0.0 0.0 -33.369755 7.220442 0.0
   0.0 -38.713947 5.7096257 0.0 0.0 -33.78206 -9.654537 0.0 0.0 -1.171371
   -0.5332126 0.0 0.0 -2.55326 -0.42591637 0.0 0.0 -1.3330672 0.13435833 0.0 0.0
   -41.515156 -0.42821434 0.0 0.0 -48.9376 12.65826 0.0 0.0 -0.6695328 0.4996156
   0.0 0.0 -30.480711 -15.4423685 0.0 0.0 -32.194427 19.513493 0.0 0.0
   -31.828892 12.435305 0.0 0.0 -972.14703 -539.598 0.0 0.0 -1.2833441 0.0845086
   0.0 0.0 -992.142 -178.45824 0.0 0.0 -0.9881236 -0.60633844 0.0 0.0 -1.3257364
   0.08861627 0.0 0.0 -35.143986 0.3967821 0.0 0.0 -1.224342 -0.5157729 0.0 0.0
   -1.3165402 0.23602203 0.0 0.0 -1.2724628 0.2050111 0.0 0.0 -37.039856
   -27.062866 0.0 0.0 -31.859716 13.927673 0.0 0.0 -30.706255 -4.3945823 0.0 0.0
   -1.1023502 -0.65616256 0.0 0.0 -1.2860422 0.056879986 0.0 0.0 -1.3370683
   0.10952007 0.0 0.0 -33.26342 -7.957216 0.0 0.0 -1.3201851 0.11125874 0.0 0.0
   -1.2509516 -0.36585757 0.0 0.0 -1393.2394 691.18994 0.0 0.0 -1.3287206
   -0.16757677 0.0 0.0 -91.01036 -8.52897 0.0 0.0 -33.21804 8.249553 0.0 0.0
   -1.3071661 0.001673434 0.0 0.0 -1.3252251 -0.0424752 0.0 0.0 -905.1001
   -451.9425 0.0 0.0 -1.3242615 0.14112407 0.0 0.0 -28.319654 -12.647492 0.0 0.0
   -1.2954131 -0.3352204 0.0 0.0 -1.2896106 -0.13128002 0.0 0.0 -1.2340797
   -0.1842559 0.0 0.0 -34.204357 1.5271704 0.0 0.0 -893.5834 -209.20511 0.0 0.0
   -34.79838 -5.9330473 0.0 0.0 -1.1065089 -0.023823164 0.0 0.0 -1.3037748
   -0.124448135 0.0 0.0 -1002.8579 146.22397 0.0 0.0 -1.3353103 0.10847368 0.0
   0.0 -0.78150874 -1.0208997 0.0 0.0 -1.0827266 0.73890114 0.0 0.0 -1.2821268
   -0.28660348 0.0 0.0 -34.77343 -0.061383333 0.0 0.0 -1116.8928 -77.90108 0.0
   0.0 -919.1036 -19.173943 0.0 0.0 -1.274399 0.29599816 0.0 0.0 -1.2014711
   -0.015374682 0.0 0.0 -37.797066 -2.029102 0.0 0.0 -1.3337032 0.11415167 0.0
   0.0 -32.831516 -11.955402 0.0 0.0 -1.3396108 0.06620383 0.0 0.0 -1.2578989
   -0.29301712 0.0 0.0 -1.198784 -0.4838939 0.0 0.0 -37.254757 6.584185 0.0 0.0
   -1366.279 25.926498 0.0 0.0 -1.1476266 0.27439392 0.0 0.0 -1.3393706
   -0.0032905415 0.0 0.0 -1016.73456 -3.7681847 0.0 0.0 -31.08994 1.4929899 0.0
   0.0 -0.49792695 -1.0606444 0.0 0.0 -1.3240286 0.09557111 0.0 0.0 -1.3149289
   -0.18997501 0.0 0.0 -0.97192854 -0.65355384 0.0 0.0 -1.2060487 0.5467222 0.0
   0.0 -70.26781 -18.01064 0.0 0.0 -1002.0452 -179.83679 0.0 0.0 -1.2862691
   0.10159475 0.0 0.0 -25.528221 17.578886 0.0 0.0 -1.200629 0.48992684 0.0 0.0
   -1.1740339 -0.5716811 0.0 0.0 -1.2241151 -0.48150286 0.0 0.0 -53.813484
   -16.413452 0.0 0.0 -34.36861 0.87182534 0.0 0.0 -34.098587 -4.394796 0.0 0.0
   -31.816795 -12.936605 0.0 0.0 -50.88486 0.22000924 0.0 0.0 -1105.8047
   418.30838 0.0 0.0 -31.114895 -1.7798623 0.0 0.0 -78.056366 -29.82485 0.0 0.0
   -62.08326 -2.9036322 0.0 0.0 -1.3101739 -0.28327274 0.0 0.0 -46.0446
   -3.0840583 0.0 0.0 -1.3306447 0.007889003 0.0 0.0 -1.2417481 0.0568786 0.0
   0.0 -1.2127587 -0.37324208 0.0 0.0 -28.391922 12.873175 0.0 0.0 -1.3127251
   0.07567194 0.0 0.0 -51.704624 22.42148 0.0 0.0 -1.1611735 0.12591624 0.0 0.0
   -1.3175222 0.04284454 0.0 0.0 -32.706806 -11.157692 0.0 0.0 -1.3265884
   -0.04088097 0.0 0.0 -1.1059138 -0.7509155 0.0 0.0 -1.3156118 -0.21185194 0.0
   0.0 -1.3395101 0.04758125 0.0 0.0 -35.126038 5.3932443 0.0 0.0 -0.79456025
   -1.0374595 0.0 0.0 -30.332203 7.1570306 0.0 0.0 -33.302845 12.431357 0.0 0.0
   -1.2595698 -0.34293565 0.0 0.0 -1.2624464 0.44596058 0.0 0.0 -0.79268724
   -0.8554637 0.0 0.0 -1.2926075 0.34342462 0.0 0.0))

(defun add-to-boid-system (origin count win
                           &key (maxcount *boids-maxcount*) (length (val (len *bp*)))
                             (trig *trig*))
  (let* ((bs (first (systems win)))
         (gl-coords (gl-coords bs))
         (vel (velocity-buffer bs))
         (life-buffer (life-buffer bs))
         (retrig-buffer (retrig-buffer bs))
         (boid-count (boid-count bs))
         (vertex-size 2) ;;; size of boid-coords
         (command-queue (first (command-queues win))))
    (setf count (min count (- maxcount (boid-count bs))))
;;;    (break "gl-coords: ~a" gl-coords)
    (unless (or (zerop gl-coords) (zerop count))
      (with-model-slots (num-boids lifemult speed maxlife) *bp*
        (let ((maxspeed (speed->maxspeed speed)))
          (with-bound-buffer (:array-buffer gl-coords)
                             (if *sharing*
                                 (gl:with-mapped-buffer (p1 :array-buffer :read-write)
;;; set to simple pointer!
                                   (ocl:with-mapped-svm-buffer (command-queue vel (* 4 (+ boid-count count)) :write t)
                                     (ocl:with-mapped-svm-buffer (command-queue life-buffer (+ boid-count count) :write t)
                                       (ocl:with-mapped-svm-buffer (command-queue retrig-buffer (+ boid-count count) :write t)
                                         (loop repeat count
                                               for i from (* 4 (* 2 vertex-size) boid-count) by (* 4 (* 2 vertex-size))
                                               for j from (* 4 boid-count) by 4
                                               for k from boid-count
                                               for a = (float (random +twopi+) 1.0)
                                               for v = (float (+ 0.1 (random 0.8)) 1.0) ;; 1.0
                                               do (let ()
                                                    (set-array-vals vel j (float (* v maxspeed (sin a))) (float (* v maxspeed (cos a))) 0.0 0.0)
                                                    (apply #'set-array-vals p1 (+ i 0) origin)
                                                    (apply #'set-array-vals p1 (+ i 8) (mapcar #'+ origin
                                                                                               (list (* -1 length (sin a))
                                                                                                     (* -1 length (cos a)) 0.0 1.0)))
                                                    (let ((color (if (zerop i) *first-boid-color* *fg-color*)))
                                                      (apply #'set-array-vals p1 (+ i 4) color)
                                                      (apply #'set-array-vals p1 (+ i 12) color))
                                                    (setf (cffi:mem-aref life-buffer :float k)
                                                          (float (if trig ;;; do we trigger on creation of a boid?
                                                                     (max 0.01 (* (random (max 0.01 (float lifemult))) (* count 0.12)))
                                                                     (max 0.01 (* (+ 0.7 (random 0.2)) maxlife))
                                                                     )
                                                                 1.0))
                                                    (setf (cffi:mem-aref retrig-buffer :int (* k 4)) 0) ;;; retrig
                                                    (setf (cffi:mem-aref retrig-buffer :int (+ (* k 4) 1)) -1) ;;; obstacle-idx for next trig
                                                    (setf (cffi:mem-aref retrig-buffer :int (+ (* k 4) 2))
                                                          (if trig 0 20)) ;;; frames since last trig
                                                    (setf (cffi:mem-aref retrig-buffer :int (+ (* k 4) 3)) 0) ;;; time since last obstacle-induced trigger
                                                    ))))))))
          (finish command-queue)
          (incf (boid-count bs) count)
          (setf num-boids (boid-count bs))
          (luftstrom-display::bp-set-value :num-boids num-boids))))
    bs))
