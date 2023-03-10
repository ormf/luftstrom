;;; 
;;; send-to-sc.lisp
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

(rts)
(make-mt-stream *mt-out1* *midi-out1* '(4 0))
(output (new midi-program-change :program 73 :channel 0) :to *mt-out1*)
(cm::initialize-io *mt-out1*)
(setf *rts-out* *mt-out1*)

(defun incudine.scratch::node-free-unprotected ()
  (dotimes (chan 4)
    (cm:output (cm:new cm::midi-control-change :controller cm::+all-notes-off+ :value 0 :channel chan)))
  (incudine:free (incudine:node 0))
  (sc::stop))

(defvar *bufout* (make-array 40000 :element-type 'single-float))

(defun vlength (x y)
  (sqrt (+ (* x x) (* y y))))

(defun trigger (time)
  (if *play*
      (let ((next (+ time 1/60)))
        (dotimes (i (* 1 cl-boids-gpu::*max-events-per-tick*))
          (at (+ time (* 1/60 (/ i cl-boids-gpu::*max-events-per-tick*)))
            (lambda ()
              (apply #'play-sound (list (random 1.0) (random 1.0) 0 1)))))
        (at next  #'trigger next))))

(defun trigger (time)
  (if *play*
      (let ((next (+ time 1)))
        (dotimes (i (* 1 cl-boids-gpu::*max-events-per-tick*))
          (at time
            (lambda ()
              (apply #'play-sound (list (random 1.0) (random 1.0) 0 1)))))
        (at next  #'trigger next))))

(defparameter *play* t)
(setf *play* nil)
(setf *play* t)

;;; (progn (setf *play* t) (trigger (now)))

;;; (untrace)
#|
(setf cl-boids-gpu::*max-events-per-tick* 10)
(setf cl-boids-gpu::*max-events-per-tick* 40)

(apply #'play-sound (list (random 1.0) (random 1.0) 0 1))
|#

(defun send-to-audio (retrig pos velo)
  (declare (ignorable velo))
;;;(break "test:")
  (loop
    repeat 4000
    with count = 0
    for posidx from 0 by 16
    for idx below (length retrig) by 4
    for trig = (aref retrig idx)
    while (< count cl-boids-gpu::*max-events-per-tick*)
    if (/= trig -1) do (let ((x (/ (aref pos (+ 0 posidx)) *gl-width*))
                             (y (/ (aref pos (+ 1 posidx)) *gl-height*))
                             (tidx trig)
                             (v (vlength (aref velo (+ 0 idx)) (aref velo (+ 1 idx)))))
                         (incf count)
                         (at (+ (now) (* 1/10 (random 1.0)))
                           (lambda ()
                             (apply #'play-sound (list x y tidx v)))))))

(setf cl-boids-gpu::*max-events-per-tick* 10)

;;; (setf *lifemult* 10000)
;;; (setf cl-boids-gpu::*max-events-per-tick* 3)

(defparameter *print* nil)
;; (setf *print* nil)

(defun sign ()
  (* 2 (- 0.5 (random 2))))

#|
(defun play-sound (x y)
  (if *print*
      (format t "x: ~4,2f, y: ~4,2f~%" x y)))
|#

(defun fn-defs (tidx)
  (aref *curr-audio-presets* tidx))

;;; (setf *boids-per-click* 100)

;;; (fn-defs 0)

(defun ensure-funcall (array synth-id-hash key &rest args)
  (let* ((idx (gethash key synth-id-hash))
         (fn (and idx (aref array idx))))
;;    (format t "~&key: ~a, idx: ~a, fn: ~a" key idx fn)
    (if fn (apply fn args)
        (warn "no fn for ~S in ~S" key synth-id-hash))))

(defun collect-args (synth fndefs)
  (loop for x in (elt *synth-defs* synth)
        append (list (first x) `(ensure-funcall ,fndefs ,(second x) x y velo tidx p1 p2 p3 p4))))

;;; (defparameter *synth-defaults* #(#(0 0 0 0 2 3) #(0 0 0 0)))

(defun player-amp (array-ref)
  (* (val (cl-boids-gpu::master-amp *bp*))
     (val (slot-value
           *bp*
           (aref
            #(cl-boids-gpu::auto-amp
              cl-boids-gpu::pl1-amp
              cl-boids-gpu::pl2-amp
              cl-boids-gpu::pl3-amp
              cl-boids-gpu::pl4-amp)
            array-ref)))))


;;; (aref (fn-defs 1) 0)
;;; (aref *cc-state* (player-aref :nk2) 0)
;;; (player-amp 0) 
;;; (tidx->player 3)

;;;
;;;; (setf *clock* 0)

(defun play-sound (x y tidx velo)
  ;;  (if (/= tidx -1) (format t "~a ~%" tidx))
  ;;  (format t "~&~a ~a~%" tidx (tidx->player tidx))
  (unless  *audio-suspend*
    (let* ((pl-ref (tidx->player tidx))
           (fndefs (fn-defs pl-ref))
           (synth (getf (aref fndefs 0) :synth))
           (synth-id-hash (aref *audio-fn-idx-lookup* synth))
           (p1 (ensure-funcall fndefs synth-id-hash :p1 x y velo pl-ref))
           (p2 (ensure-funcall fndefs synth-id-hash :p2 x y velo pl-ref p1))
           (p3 (ensure-funcall fndefs synth-id-hash :p3 x y velo pl-ref p1 p2))
           (p4 (ensure-funcall fndefs synth-id-hash :p4 x y velo pl-ref p1 p2 p3)))
;;      (format t "~&x: ~,2f y: ~,2f tidx: ~a velo: ~a~%" x y tidx velo)
      ;;    (format t "~a ~%" synth-id-hash)
      ;; (format t "~&~a~%" synth)
      (case synth
        (0
         (sc-user:sc-lfo-click-2d-bpf-4ch-out
          :pitch (ensure-funcall fndefs synth-id-hash :pitchfn x y velo pl-ref p1 p2 p3 p4)
          :amp (float (* (player-amp pl-ref)
                         (ensure-funcall fndefs synth-id-hash :ampfn  x y velo pl-ref p1 p2 p3 p4)))
          :dur (ensure-funcall fndefs synth-id-hash :durfn x y velo pl-ref p1 p2 p3 p4)
          :suswidth (ensure-funcall fndefs synth-id-hash :suswidthfn x y velo pl-ref p1 p2 p3 p4)
          :suspan (ensure-funcall fndefs synth-id-hash :suspanfn x y velo pl-ref p1 p2 p3 p4)
          :decaystart (ensure-funcall fndefs synth-id-hash :decaystartfn x y velo pl-ref p1 p2 p3 p4)
          :decayend (ensure-funcall fndefs synth-id-hash :decayendfn x y velo pl-ref p1 p2 p3 p4)
          :lfofreq (ensure-funcall fndefs synth-id-hash :lfofreqfn x y velo pl-ref p1 p2 p3 p4)
          :xpos (ensure-funcall fndefs synth-id-hash :xposfn x y velo pl-ref p1 p2 p3 p4)
          :ypos (ensure-funcall fndefs synth-id-hash :yposfn x y velo pl-ref p1 p2 p3 p4)
          :wet (ensure-funcall fndefs synth-id-hash :wetfn x y velo pl-ref p1 p2 p3 p4)
          :filtfreq (ensure-funcall fndefs synth-id-hash :filtfreqfn x y velo pl-ref p1 p2 p3 p4)
          :bpfreq (ensure-funcall fndefs synth-id-hash :bpfreqfn x y velo pl-ref p1 p2 p3 p4)
          :bprq (ensure-funcall fndefs synth-id-hash :bprqfn x y velo pl-ref p1 p2 p3 p4)
          :head 200))
;;; (format t "~&args: ~%~S" args)
        (1
         (multiple-value-bind (vowel vwlinterp)
             (floor (* (ensure-funcall fndefs synth-id-hash :vowelfn x y velo pl-ref p1 p2 p3 p4) 3.9999))
           ;; (format t "~&vwl: ~a, vwlinterp: ~,2f voice: ~a, voicepan: ~a, bppan: ~a" vowel vwlinterp (round (ensure-funcall fndefs synth-id-hash :voicetypefn x y velo pl-ref p1 p2 p3 p4))
           ;;         (float (ensure-funcall fndefs synth-id-hash :voicepanfn x y velo pl-ref p1 p2 p3 p4))
           ;;         (float (ensure-funcall fndefs synth-id-hash :bppanfn x y velo pl-ref p1 p2 p3 p4))
           ;;         )
           (sc-user:sc-lfo-click-2d-bpf-4ch-vow-out
            :pitch (float (ensure-funcall fndefs synth-id-hash :pitchfn x y velo pl-ref p1 p2 p3 p4))
            :amp (float
                  (* (player-amp pl-ref)
                     (ensure-funcall fndefs synth-id-hash :ampfn x y velo pl-ref p1 p2 p3 p4)))
            :dur (float (ensure-funcall fndefs synth-id-hash :durfn x y velo pl-ref p1 p2 p3 p4))
            :suswidth (float (ensure-funcall fndefs synth-id-hash :suswidthfn x y velo pl-ref p1 p2 p3 p4))
            :suspan (float (ensure-funcall fndefs synth-id-hash :suspanfn x y velo pl-ref p1 p2 p3 p4))
            :decaystart (float (ensure-funcall fndefs synth-id-hash :decaystartfn x y velo pl-ref p1 p2 p3 p4))
            :decayend (float (ensure-funcall fndefs synth-id-hash :decayendfn x y velo pl-ref p1 p2 p3 p4))
            :lfofreq (float (ensure-funcall fndefs synth-id-hash :lfofreqfn x y velo pl-ref p1 p2 p3 p4))
            :xpos (float (ensure-funcall fndefs synth-id-hash :xposfn x y velo pl-ref p1 p2 p3 p4))
            :ypos (float (ensure-funcall fndefs synth-id-hash :yposfn x y velo pl-ref p1 p2 p3 p4))
            :wet (float (ensure-funcall fndefs synth-id-hash :wetfn x y velo pl-ref p1 p2 p3 p4))
            :filtfreq (float (ensure-funcall fndefs synth-id-hash :filtfreqfn x y velo pl-ref p1 p2 p3 p4))
            :bpfreq (float (ensure-funcall fndefs synth-id-hash :bpfreqfn x y velo pl-ref p1 p2 p3 p4))
            :bprq (float (ensure-funcall fndefs synth-id-hash :bprqfn x y velo pl-ref p1 p2 p3 p4))
            :bppan (float (ensure-funcall fndefs synth-id-hash :bppanfn x y velo pl-ref p1 p2 p3 p4))
            :vowel vowel
            :vwlinterp (float vwlinterp)
            :voicetype (round (ensure-funcall fndefs synth-id-hash :voicetypefn x y velo pl-ref p1 p2 p3 p4))
            :voicepan (float (ensure-funcall fndefs synth-id-hash :voicepanfn x y velo pl-ref p1 p2 p3 p4))
            :head 200)))
        (otherwise (warn "no synth specified: ~a" synth)))
      )))

;;;(apply #'play-sound (list 0.5 0.2 0 1))

#|
(defun auto-play (time)
  (let ((x 0) (y (random 0.5)) (tidx -1) (v 0.5))
    (apply #'play-sound (list x y tidx v))
    (if *autoplay*
        (at time (lambda () (funcall #'auto-play (+ time 0.02)))))))

(play-sound 0.5 0.5 -1 1)

(defparameter *autoplay* t)
(defparameter *autoplay* nil)

(auto-play (now))


(aref (fn-defs -1) 2)

(defun play-sound (x y trigidx velo)
  ;;  (format t "~a ~a~%" x y)
  (setf *clock* *clockinterv*)
  (let* ((p1 (funcall *p1* x y velo trigidx))
         (p2 (funcall *p2* x y velo trigidx p1))
         (p3 (funcall *p3* x y velo trigidx p2))
         (p4 (funcall *p4* x y velo trigidx p3)))
    (sc-user::sc-lfo-click-2d-out
     :pitch (funcall *pitchfn* x y velo trigidx p1 p2 p3 p4)
     :amp (float (* (get-amp trigidx) (funcall *ampfn* x y velo trigidx p1 p2 p3 p4)))
     :dur (funcall *durfn* x y  trigidx p1 p2 p3 p4)
     :suswidth (funcall *suswidthfn* x y velo trigidx p1 p2 p3 p4)
     :suspan (funcall *suspanfn* x y velo trigidx p1 p2 p3 p4)
     :decay-start (funcall *decay-startfn* x y velo trigidx p1 p2 p3 p4)
     :decay-end (funcall *decay-endfn* x y velo trigidx p1 p2 p3 p4)
     :lfo-freq (funcall *lfo-freqfn* x y velo trigidx p1 p2 p3 p4)
     :x-pos (funcall *x-posfn* x y velo trigidx p1 p2 p3 p4)
     :y-pos (funcall *y-posfn* x y velo trigidx p1 p2 p3 p4)
     :wet (funcall *wetfn* x y velo trigidx p1 p2 p3 p4)
     :filt-freq (funcall *filt-freqfn* x y velo trigidx p1 p2 p3 p4)
     :head 200)))

(in-package :cl-boids-gpu)

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
  (setf cl-boids-gpu::*maxspeed* 1.05)
  (setf cl-boids-gpu::*maxforce* 0.0915)
  (setf cl-boids-gpu::*maxidx* 317)
  (setf cl-boids-gpu::*length* 5)
  (setf cl-boids-gpu::*sepmult* 2)
  (setf cl-boids-gpu::*cohmult* 1)
  (setf cl-boids-gpu::*predmult* 1)
  (setf cl-boids-gpu::*maxlife* 60000.0)
  (setf cl-boids-gpu::*lifemult* 100.0)
  (defun luftstrom-display::play-sound (x y)
    ;;  (format t "~a ~a~%" x y)
    (setf cl-boids-gpu::*clock* 3 )
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

(in-package :luftstrom-display)

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



(loop for param in
     '(*speed* *obstacles-lookahead*
       *maxspeed* *maxforce* *maxidx* *length*
       *sepmult* *cohmult* *predmult* *maxlife*
       *lifemult*)
   do (format t "~&(setf cl-boids-gpu::~a ~a)~%" param (symbol-value param)))

((bus-idx bus-number)
pitch amp dur (env envelope) decay-start decay-end lfo-freq x-pos y-pos)
|#

#|

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
(setf cl-boids-gpu::*speed* 2.0)
(setf cl-boids-gpu::*obstacles-lookahead* 4.0)
(setf cl-boids-gpu::*maxspeed* 1.5500001)
(setf cl-boids-gpu::*maxforce* 0.0465)
(setf cl-boids-gpu::*maxidx* 317)
(setf cl-boids-gpu::*length* 5)
(setf cl-boids-gpu::*sepmult* 1)
(setf cl-boids-gpu::*cohmult* 3)
(setf cl-boids-gpu::*predmult* 1)
(setf cl-boids-gpu::*maxlife* 60000.0)
(setf cl-boids-gpu::*lifemult* 1000.0)
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
(setf cl-boids-gpu::*speed* 2.0)
(setf cl-boids-gpu::*obstacles-lookahead* 4.0)
(setf cl-boids-gpu::*maxspeed* 1.5500001)
(setf cl-boids-gpu::*maxforce* 0.0465)
(setf cl-boids-gpu::*maxidx* 317)
(setf cl-boids-gpu::*length* 5)
(setf cl-boids-gpu::*sepmult* 2)
(setf cl-boids-gpu::*cohmult* 1)
(setf cl-boids-gpu::*predmult* 2)
(setf cl-boids-gpu::*maxlife* 60000.0)
(setf cl-boids-gpu::*lifemult* 1000.0)
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
   :head 200))

(defun play-sound (x y)
;;  (format t "~a ~a~%" x y)
  (sc-user::sc-lfo-click-2d-out
   :pitch (+ 0.1 (* 0.2 y))
   :amp (* (luftstrom-display::sign) (random 0.02))
   :dur 0.6
   :suswidth 1
   :suspan 0.1
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 50 (expt (+ 1 (* (round (* 17 y)))) 1.01))
   :x-pos x
   :y-pos y
   :head 200))

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
   :pitch (+ 0.1 (* 0.2 y))
   :amp (* (luftstrom-display::sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
   :dur 1.6
   :suswidth 0.4
   :suspan 0.2
   :decay-start 0.001
   :decay-end 0.002
   :lfo-freq (* 50 (expt (+ 1 (* (round (* 16 y)))) 0.9))
   :x-pos x
   :y-pos y
   :head 200))




;;; irre (1200 boids)!

(progn
;;; 540 boids
  (let ((fac 3))
    (defparameter cl-boids-gpu::*maxspeed* (* fac 0.1))
    (defparameter cl-boids-gpu::*maxforce* (* fac 0.0003)))
  (defparameter cl-boids-gpu::*maxidx* 317)
  (defparameter cl-boids-gpu::*length* 5)

  (defparameter cl-boids-gpu::*sepmult* 1)
  (defparameter cl-boids-gpu::*alignmult* 1)
  (defparameter cl-boids-gpu::*cohmult* 3)
  (defparameter cl-boids-gpu::*predmult* 2)
  (defparameter cl-boids-gpu::*platform* nil)
  (defparameter cl-boids-gpu::*maxlife* 60000.0)
  (defparameter cl-boids-gpu::*lifemult* 1000.0)
;;  (defparameter cl-boids-gpu::*width* 640)
;;  (defparameter cl-boids-gpu::*height* 480)
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
:head 200))):

(progn
;;; 540 boids
  (let ((fac 3))
    (defparameter *maxspeed* (* fac 0.1))
    (defparameter *maxforce* (* fac 0.0003)))
  (defparameter *maxidx* 317)
  (defparameter *length* 5)

  (defparameter *sepmult* 1)
  (defparameter *alignmult* 1)
  (defparameter *cohmult* 3)
  (defparameter *predmult* 2)
  (defparameter *platform* nil)
  (defparameter *maxlife* 60000.0)
  (defparameter *lifemult* 1000.0)
;;  (defparameter *width* 640)
;;  (defparameter *height* 480)
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
    (defparameter *maxspeed* (* fac 0.1))
    (defparameter *maxforce* (* fac 0.0003)))
  (defparameter *maxidx* 317)
  (defparameter *length* 5)

  (defparameter *sepmult* 1)
  (defparameter *alignmult* 1)
  (defparameter *cohmult* 3)
  (defparameter *predmult* 2)
  (defparameter *platform* nil)
  (defparameter *maxlife* 60000.0)
  (defparameter *lifemult* 1000.0)
;;  (defparameter *width* 640)
;;  (defparameter *height* 480)
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


(defparameter *test* t)


(progn
;;; 5400 boids in 1200x800!!! 
  
(let ((fac 1.5))
  (defparameter *maxspeed* (* fac 0.1))
  (defparameter *maxforce* (* fac 0.003)))
(defparameter *maxidx* 317)
(defparameter *length* 5)

(defparameter *sepmult* 2)
(defparameter *alignmult* 5)
(defparameter *cohmult* 5)
(defparameter *predmult* 1)
(defparameter *platform* nil)
(defparameter *maxlife* 60000.0)
(defparameter *lifemult* 200.0)
;; (defparameter *width* 1200)
;; (defparameter *height* 800)
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
  (defparameter cl-boids-gpu::*maxspeed* (* fac 0.1))
  (defparameter cl-boids-gpu::*maxforce* (* fac 0.001)))
(defparameter cl-boids-gpu::*maxidx* 317)
(defparameter cl-boids-gpu::*length* 5)

(defparameter cl-boids-gpu::*sepmult* 2)
(defparameter cl-boids-gpu::*alignmult* 1)
(defparameter cl-boids-gpu::*cohmult* 1)
(defparameter cl-boids-gpu::*predmult* 1)
(defparameter cl-boids-gpu::*platform* nil)
(defparameter cl-boids-gpu::*maxlife* 60000.0)
(defparameter cl-boids-gpu::*lifemult* 20.0)
;; (defparameter *width* 1200)
;; (defparameter *height* 800)
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
|#
