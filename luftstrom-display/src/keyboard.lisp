;;; 
;;; keyboard.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2019 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
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

(defun digest-keypgm (idx form)
  (let ((keypgm (aref *keyboard-pgms* idx)))
    (loop for (key val) on form by #'cddr
          do (setf (slot-value keypgm (intern (symbol-name key))) val))
    keypgm))

(defun pitch-cc-vec (pitch)
  (vector 0 0 0 0 0 0 0 0 pitch 0 0 0 0 0 0 0))

;;; (pitch-cc-vec 39) -> #(0 0 0 0 0 0 0 0 39 0 0 0 0 0 0 0)


(defun cc-all-except (&rest seq)
  (loop for idx below 16 unless (member idx seq) collect idx))

;;; (cc-all-except 8) -> (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15)

;;; (aref *keyboard-pgms* 1)

(defstruct keypgm
  (bs-audio-preset nil)
  (bs-boids-preset nil)
  (obstacles nil)
  (pitch-offset 0)
  (cc-state nil)
  (protected nil)
  (save-state nil)
  (update t)
  )

(defclass keyboard (midi-controller)
  ((cc-offset :initform 0
              :initarg :cc-offset :accessor cc-offset)
   (player-idx :initform 0 :initarg :player-idx :accessor player-idx)
   (last-audio :initform nil :initarg :last-audio :accessor last-audio)
   (switch-boids :initform t :initarg :switch-boids :accessor switch-boids)
   (last-bs-preset :initform nil :initarg :last-bs-preset :accessor last-bs-preset)
   (last-bend  :initform 64 :initarg :last-bend :accessor last-bend)
   (last-mod  :initform 0 :initarg :last-bend :accessor last-mod)
   (offset-scale  :initform 1 :initarg :offset-scale :accessor offset-scale)))

(defmethod initialize-instance :before ((instance keyboard)
                                        &key (id :kbd1) (chan (controller-chan :kbd1))
                                        &allow-other-keys)
  (setf (id instance) id)
  (setf (chan instance) chan))

(defmethod initialize-instance :after ((instance keyboard) &key  &allow-other-keys)
  (setf (note-fn instance) (flock-keyboard-in instance)))



(defmethod handle-midi-in ((instance keyboard) opcode d1 d2)
  (with-slots (last-bend last-mod offset-scale player-idx) instance
    (case opcode
      (:pitch-bend
       (let ((start (ash player-idx 4)))
         (format t "~&bend: ~a, ~a, ~a~%" d2 (elt *audio-preset-ctl-model* (+ start 8))
                 (m-lin (- d2 last-bend) 0 1.0))

         (set-cell (elt *audio-preset-ctl-model* (+ start 8))
                   (max 0 (+ (val (elt *audio-preset-ctl-model* (+ start 8)))
                             (m-lin (- d2 last-bend) 0 10.0))))
         (setf last-bend d2)))
      (:cc
       (progn
         (format t "~&cc: ~a, ~a~%" d1 d2)
         (case d1
           (1 (let ((start (ash player-idx 4)))
                (format t "~&cc: ~a, ~a~%" d1 d2)
                (format t "~&bend: ~a, ~a, ~a~%" d2 (elt *audio-preset-ctl-model* (+ start 9))
                        (m-lin (- d2 last-bend) 0 10.0))

                (set-cell (elt *audio-preset-ctl-model* (+ start 11))
                          (max 0
                               (+ (val (elt *audio-preset-ctl-model* (+ start 11)))
                                  (m-lin (- d2 last-mod) 0 30.0))))
                (setf last-mod d2)))
           (11 (set-cell (cl-boids-gpu::auto-amp *bp*)
                         (funcall (m-exp-zero-fn 0.01 1)
                                  (round (max 0 (min 127 d2))))))
           (25
            (unless (zerop d2)
              (cl-boids-gpu::toggle-update)))
           (74
            (format t "~&cc: ~a, ~a~%" d1 d2)
            (setf offset-scale (m-exp d2 1 200))))))))
  (call-next-method)
  )

(defun flock-keyboard-in (instance)
  (lambda (key velo)
    (when (> velo 0)
      (format t "~&key-in ~S: ~a ~a~%" (id instance) key velo)
      (load-keyboard-pgm instance (- key 36)))))
(defparameter *last-key* 0)

(defun change-pitch (cc-state offset)
  (let ((new-state (copy-seq cc-state)))
    (incf (aref new-state 8) offset)
    new-state))

(defun load-keyboard-pgm (instance key)
  (format t "loading keyboard-pgm ~a~%" key)
  (setf *last-key* key)
  (with-slots (last-audio player-idx switch-boids last-bs-preset offset-scale) instance
    (with-slots (cc-state bs-audio-preset bs-boids-preset pitch-offset
                 obstacles protected save-state update)
        (elt *keyboard-pgms* key)
      (if last-bs-preset
          (bs-state-save last-bs-preset :save-boids t))
      (setf cl-boids-gpu::*update* t)
      (when bs-audio-preset
        (bs-state-recall
         bs-audio-preset
         :players-to-recall (list (player-name player-idx))
         :load-obstacles nil
         :load-audio (if (not (eql last-audio bs-audio-preset))
                         (setf last-audio bs-audio-preset))
         :load-boids nil
         :cc-state cc-state
         :protected protected)
        (let ((start (ash player-idx 4)))
          (set-cell (elt *audio-preset-ctl-model* (+ start 8))
                    (+ (val (elt *audio-preset-ctl-model* (+ start 8)))
                       (* pitch-offset offset-scale)))))
      (if (and bs-boids-preset switch-boids)
          (bs-state-recall
           bs-boids-preset
           :players-to-recall (list player-idx)
           :load-obstacles obstacles
           :load-audio nil
           :load-boids t))
      (setf last-bs-preset (and save-state bs-boids-preset))
      
      (unless update (at (+ (now) 0.06) (lambda () (setf cl-boids-gpu::*update* update))))
      (unless (or bs-audio-preset bs-boids-preset)
        (setf last-audio 1)))))

(setf cl-boids-gpu::*update* t )


;;; (setf (switch-boids (find-controller :kbd1)) nil)

;;; (remove-midi-controller :kbd1)
(progn
  (remove-midi-controller :kbd1)
  (add-midi-controller 'keyboard :id :kbd1 :chan 6))
;;;

;;(m-lin 63.5 -1 1)



;;; (find-controller :kbd1)

;;; (load-keyboard-pgm (find-controller :kbd1) 0)

(defparameter *keyboard-pgms*
  (make-array 1024
              :element-type 'keypgm
              :initial-contents (loop
                                  for pgm below 1024
                                  collect (make-keypgm :bs-audio-preset (mod pgm 128)))))

(defparameter *white-keys*
  (loop for oct below 4 append (mapcar (lambda (x) (+ x (* oct 12)))
                                       '(0 2 4 5 7 9 11))))

(defparameter *black-keys*
  (loop for oct below 4 append (mapcar (lambda (x) (+ x (* oct 12)))
                                       '(1 3 6 8 10))))


(loop for key in *white-keys*
      for pitch from 26 by 1.7
      do (digest-keypgm key `(:bs-audio-preset 53
                              :cc-state ,(pitch-cc-vec pitch)
                              :protected ,(cc-all-except 8))))

(loop for key in *black-keys*
      for cc-state in (list
                       (vector 0 0 0 0 0 0 127 127 38 0 70 11 0 127 91 0)
                       (vector 0 0 0 0 0 0 127 127 38 1 95 11 0 127 91 0)
                       (vector 0 0 0 0 0 0 127 127 38 0 12 22 0 127 14 110)
                       (vector 0 0 0 0 0 0 127 127 38 1 10 11 0 127 127 20)
                       (vector 0 0 0 40 0 0 127 127 38 3 127 7 0 127 91 105)
                       (vector 0 0 0 0 0 0 127 127 38 0 127 11 0 127 91 105)
                       (vector 0 0 0 0 0 0 127 127 38 5 127 11 0 127 91 105)
                       (vector 0 0 0 0 0 0 127 127 38 5 127 19 0 127 50 105)
                       (vector 0 0 0 0 0 0 127 127 38 0 70 11 0 127 91 105)
                       (vector 0 0 0 0 0 0 127 127 38 0 70 30 0 127 91 105)
                       (vector 0 0 0 10 0 0 127 127 38 0 70 30 0 127 91 105)
                       (vector 0 0 0 0 0 0 127 127 38 9 70 30 0 127 91 105)
                       (vector 0 0 0 0 0 0 127 127 38 9 70 30 0 127 91 10)
                       (vector 0 0 0 0 0 0 127 127 38 9 127 30 0 127 91 127)
                       (vector 0 0 0 0 0 0 127 127 38 0 127 30 0 127 127 127)
                       (vector 0 0 0 0 0 0 127 127 38 9 127 30 0 127 16 127)
                       (vector 0 0 0 0 0 0 127 127 38 9 127 30 0 127 16 21)
                       (vector 0 0 0 0 0 0 127 127 38 121 127 30 0 127 16 21)
                       (vector 0 0 0 0 0 0 127 127 38 1 10 11 0 127 0 127)
                       (vector 0 0 0 0 0 0 127 127 38 9 70 30 0 127 91 105)

                       (vector 0 0 0 0 0 0 127 127 38 9 70 98 0 127 91 105)
                       (vector 0 0 0 0 0 0 127 127 38 9 70 98 0 127 127 05)
                       (vector 0 0 0 0 0 0 127 127 38 90 70 98 0 127 127 05)
                       (vector 0 0 0 0 0 0 127 127 38 30 70 98 0 127 127 25)
                       (vector 0 0 0 0 0 0 127 127 38 30 127 38 0 127 127 05)
                       (vector 0 0 0 0 0 0 127 127 38 0 127 38 0 40 107 35)
                       (vector 0 0 0 0 0 0 127 127 38 0 127 38 0 127 127 35)
                       (vector 0 0 0 0 0 0 127 127 38 0 127 38 0 127 127 35)
                       (vector 0 0 0 0 0 0 127 127 38 3 90 11 0 127 91 105)
                       (vector 93 0 125 0 0 127 127 127 42 0 12 22 86 0 14 110)
                       (vector 0 0 0 16 0 0 127 127 38 0 70 30 0 127 91 105)
                       )
      for boid-preset from 10
      do (digest-keypgm key `(:bs-audio-preset 53
                              :bs-boids-preset ,boid-preset
                              :cc-state ,cc-state
                              :protected (8))))


(defun digest-keypgms (seq &optional (target *keyboard-pgms*))
  (loop for idx from 0
        for form in seq
        do (setf (aref target idx) (apply #'make-keypgm form))))


(digest-keypgms
 '((:bs-audio-preset 53 :bs-boids-preset 44 :obstacles nil :pitch-offset 0.0 :cc-state
    #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) :protected (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15) :save-state nil
    :update nil)
   (:bs-audio-preset 53 :bs-boids-preset 48 :obstacles nil :pitch-offset 0.155 :cc-state
    #(86 0 0 0 0 0 127 127 53 0 70 11 0 127 91 0) :protected (8) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 28.1 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil :update nil )
   (:bs-audio-preset 53 :bs-boids-preset 49 :obstacles nil :pitch-offset -0.07 :cc-state
    #(86 0 0 0 0 0 127 127 53 1 95 11 0 127 91 0) :protected (8) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 30.2 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 32.3 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 50 :obstacles nil :pitch-offset 0.157 :cc-state
    #(64 0 0 0 0 0 127 127 38 0 12 22 0 127 14 110) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 34.399998 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 51 :obstacles nil :pitch-offset -0.117 :cc-state
    #(86 0 0 0 0 0 127 127 62 1 10 11 0 127 127 20) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 36.499996 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 52 :obstacles nil :pitch-offset 0.28 :cc-state
    #(64 0 0 40 0 0 127 127 38 3 127 7 0 127 91 105) :protected (8) :save-state t)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 38.599995 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(86 0 0 0 0 0 127 127 41 0 12 22 0 127 14 110) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 53 :obstacles nil :pitch-offset 0.14 :cc-state
    #(64 0 0 0 0 0 127 127 51 0 127 11 0 127 91 105) :protected (8) :save-state t)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 42.79999 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 54 :obstacles nil :pitch-offset -0.38 :cc-state
    #(64 0 0 0 0 0 127 127 38 5 127 11 0 127 91 105) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 44.89999 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 46.99999 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 55 :obstacles nil :pitch-offset 0.35 :cc-state
    #(86 0 0 0 0 0 127 127 62 5 127 19 0 127 50 105) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 49.099987 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 56 :obstacles nil :pitch-offset -0.225 :cc-state
    #(64 0 0 0 0 0 127 127 38 0 70 11 0 127 91 105) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 51.199986 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 57 :obstacles nil :pitch-offset -0.1 :cc-state
    #(64 0 0 0 0 0 127 127 38 0 70 30 0 127 91 105) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 53.299984 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 55.399982 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 58 :obstacles nil :pitch-offset 0.45 :cc-state
    #(64 0 0 10 0 0 127 127 64 0 70 30 0 127 127 105) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.415 :cc-state
    #(64 0 0 0 0 0 0 0 57.49998 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 59 :obstacles nil :pitch-offset -0.742 :cc-state
    #(64 0 0 0 0 0 127 127 38 9 70 30 0 127 91 105) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 59.59998 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 61.699978 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 60 :obstacles nil :pitch-offset 0.375 :cc-state
    #(86 0 0 0 0 0 127 127 45 9 70 30 0 127 91 10) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 63.799976 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 61 :obstacles nil :pitch-offset -0.115 :cc-state
    #(64 0 0 0 0 0 127 127 38 9 127 30 0 127 91 127) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 65.89998 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 62 :obstacles nil :pitch-offset -0.152 :cc-state
    #(64 0 0 0 0 0 127 127 64 2 127 30 0 127 86 127) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 67.99998 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 70.099976 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 63 :obstacles nil :pitch-offset 0.2515 :cc-state
    #(86 0 0 0 0 0 127 127 45 9 127 30 0 127 84 0) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 72.199974 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 64 :obstacles nil :pitch-offset 0.1471 :cc-state
    #(86 0 0 0 0 0 127 127 60 9 127 30 0 127 16 21) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 74.29997 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 76.39997 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 65 :obstacles nil :pitch-offset -0.213 :cc-state
    #(64 0 0 0 0 0 127 127 51 121 127 30 0 127 101 21) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 78.49997 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 66 :obstacles nil :pitch-offset 0.32 :cc-state
    #(127 0 0 0 0 0 127 127 45 1 10 11 0 127 0 127) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 80.59997 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset nil :bs-boids-preset nil :obstacles nil :pitch-offset 0 :cc-state
    #(86 0 0 0 0 0 127 127 49 9 70 30 0 127 91 105) :protected nil :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(86 0 0 0 0 0 0 0 82.69997 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)

;;; 84

   (:bs-audio-preset 101 :bs-boids-preset 96 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 97 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 98 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 99 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 100 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 101 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 102 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 103 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 104 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 105 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 106 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 107 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 93 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 109 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 110 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 111 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 115 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 116 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 119 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 120 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 121 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 122 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 123 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 124 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 125 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 126 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 127 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 80 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 81 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 82 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 83 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 84 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 85 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 86 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 87 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 88 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 89 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 90 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 91 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 92 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 93 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 94 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)
   (:bs-audio-preset 101 :bs-boids-preset 95 :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil :update nil)

   (:bs-audio-preset nil :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)

   (:bs-audio-preset 92 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 93 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 94 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 95 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 96 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 97 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 98 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 99 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 100 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 101 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 102 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 103 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 104 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 105 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 106 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 107 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 108 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 109 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 110 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 111 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 112 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 113 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 114 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 115 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 116 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 117 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 118 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 119 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 120 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 121 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 122 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 123 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 124 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 125 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 126 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 127 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)

   ))

#|
(set-player-cc-state 0 (vector 93 0 125 0 0 127 127 127 42 0 12 22 86 0 14 110) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 0 127 30 0 127 127 127) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 40 0 0 127 127 38 3 127 7 0 127 91 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 0 127 11 0 127 91 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 3 90 11 0 127 91 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 5 127 11 0 127 91 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 0 12 22 0 127 14 110) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 5 127 19 0 127 50 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 0 70 11 0 127 91 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 0 70 30 0 127 91 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 10 0 0 127 127 38 0 70 30 0 127 91 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 16 0 0 127 127 38 0 70 30 0 127 91 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 9 70 30 0 127 91 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 9 70 30 0 127 91 10) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 9 127 30 0 127 91 127) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 9 127 30 0 127 16 127) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 9 127 30 0 127 16 21) :protected '(8))

(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 121 127 30 0 127 16 21) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 0 70 11 0 127 91 0) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 1 95 11 0 127 91 0) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 1 10 11 0 127 0 127) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 1 10 11 0 127 127 20) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 9 70 30 0 127 91 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 9 70 98 0 127 91 105) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 9 70 98 0 127 127 05) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 90 70 98 0 127 127 05) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 30 70 98 0 127 127 25) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 30 127 38 0 127 127 05) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 0 127 38 0 40 107 35) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 0 127 38 0 127 127 35) :protected '(8))
(set-player-cc-state 0 (vector 0 0 0 0 0 0 127 127 38 0 127 38 0 127 127 35) :protected '(8))




(vector 0 0 0 0 0 0 127 127 38 0 127 30 0 127 127 127)


(load-keyboard-pgm (find-controller :kbd1) 0)
  (load-keyboard-pgm (find-controller :kbd1) 1)
(load-keyboard-pgm (find-controller :kbd1) 2)
  (load-keyboard-pgm (find-controller :kbd1) 3)
(load-keyboard-pgm (find-controller :kbd1) 4)
(load-keyboard-pgm (find-controller :kbd1) 5)
  (load-keyboard-pgm (find-controller :kbd1) 6)
(load-keyboard-pgm (find-controller :kbd1) 7)
  (load-keyboard-pgm (find-controller :kbd1) 8)
(load-keyboard-pgm (find-controller :kbd1) 9)
  (load-keyboard-pgm (find-controller :kbd1) 10)
(load-keyboard-pgm (find-controller :kbd1) 11)

(load-keyboard-pgm (find-controller :kbd1) 12)
  (load-keyboard-pgm (find-controller :kbd1) 13)
(load-keyboard-pgm (find-controller :kbd1) 14)
  (load-keyboard-pgm (find-controller :kbd1) 15)
(load-keyboard-pgm (find-controller :kbd1) 16)
(load-keyboard-pgm (find-controller :kbd1) 17)
  (load-keyboard-pgm (find-controller :kbd1) 18)
(load-keyboard-pgm (find-controller :kbd1) 19)
  (load-keyboard-pgm (find-controller :kbd1) 20)
(load-keyboard-pgm (find-controller :kbd1) 21)
  (load-keyboard-pgm (find-controller :kbd1) 22)
(load-keyboard-pgm (find-controller :kbd1) 23)

(load-keyboard-pgm (find-controller :kbd1) 24)
  (load-keyboard-pgm (find-controller :kbd1) 25)
(load-keyboard-pgm (find-controller :kbd1) 26)
  (load-keyboard-pgm (find-controller :kbd1) 27)
(load-keyboard-pgm (find-controller :kbd1) 28)
(load-keyboard-pgm (find-controller :kbd1) 29)
  (load-keyboard-pgm (find-controller :kbd1) 30)
(load-keyboard-pgm (find-controller :kbd1) 31)
  (load-keyboard-pgm (find-controller :kbd1) 32)
(load-keyboard-pgm (find-controller :kbd1) 33)
  (load-keyboard-pgm (find-controller :kbd1) 34)
(load-keyboard-pgm (find-controller :kbd1) 35)

(load-keyboard-pgm (find-controller :kbd1) 36)
  (load-keyboard-pgm (find-controller :kbd1) 37)
(load-keyboard-pgm (find-controller :kbd1) 38)
  (load-keyboard-pgm (find-controller :kbd1) 39)
(load-keyboard-pgm (find-controller :kbd1) 40)
(load-keyboard-pgm (find-controller :kbd1) 41)
  (load-keyboard-pgm (find-controller :kbd1) 42)
(load-keyboard-pgm (find-controller :kbd1) 43)
  (load-keyboard-pgm (find-controller :kbd1) 44)
(load-keyboard-pgm (find-controller :kbd1) 45)
  (load-keyboard-pgm (find-controller :kbd1) 46)
(load-keyboard-pgm (find-controller :kbd1) 47)

(load-keyboard-pgm (find-controller :kbd1) 48)
(load-keyboard-pgm (find-controller :kbd1) 49)


(setf (keypgm-save-state (aref *keyboard-pgms* 15)) nil)
(setf (keypgm-save-state (aref *keyboard-pgms* 13)) t)
(setf (keypgm-save-state (aref *keyboard-pgms* 10)) t)

(bs-state-recall 53 :load-audio t)


(bs-state-save 53 :save-audio t :save-boids nil :save-obstacles nil)

|#


(defparameter *solo-seq*
  '((:time 0 :dtime 0.01 :keynum 56 :duration 1.0)
    (:time 0.01 :dtime 1 :keynum 55 :duration 1.0)
    (:time 1 :dtime 2 :keynum 68 :duration 2)
    (:time 3 :dtime 1 :keynum 58 :duration 1.0)
    (:time 4 :dtime 2 :keynum 63 :duration 2)
    (:time 6 :dtime 1 :keynum 58 :duration 1.0)
    (:time 7 :dtime 2 :keynum 68 :duration 2)
    (:time 9 :dtime 1 :keynum 56 :duration 1.0)
    (:time 10 :dtime 1 :keynum 63 :duration 1.0)
    (:time 11 :dtime 1 :keynum 68 :duration 1.0)
    (:time 12 :dtime 1 :keynum 61 :duration 1.0)
    (:time 13 :dtime 2 :keynum 68 :duration 2)
    (:time 15 :dtime 1 :keynum 58 :duration 1.0)
    (:time 16 :dtime 1 :keynum 61 :duration 1.0)
    (:time 17 :dtime 1 :keynum 68 :duration 1.0)
    (:time 18 :dtime 1 :keynum 56 :duration 1.0)
    (:time 19 :dtime 2 :keynum 68 :duration 2)
    (:time 21 :dtime 1 :keynum 61 :duration 1.0)
    (:time 22 :dtime 2 :keynum 68 :duration 2)
    (:time 24 :dtime 1 :keynum 58 :duration 1.0)
    (:time 25 :dtime 1 :keynum 63 :duration 1.0)
    (:time 26 :dtime 1 :keynum 68 :duration 1.0)
    (:time 27 :dtime 1 :keynum 61 :duration 1.0)
    (:time 28 :dtime 1 :keynum 58 :duration 1.0)
    (:time 29 :dtime 1 :keynum 68 :duration 1.0)
    (:time 30 :dtime 1 :keynum 61 :duration 1.0)
    (:time 31 :dtime 1 :keynum 58 :duration 1.0)
    (:time 32 :dtime 1 :keynum 63 :duration 1.0)
    (:time 33 :dtime 1 :keynum 58 :duration 1.0)
    (:time 34 :dtime 0.99 :keynum 61 :duration 1.0)
    (:time 34.99 :dtime 0.01 :keynum 55 :duration 1.0)
    (:time 35 :dtime 1 :keynum 56 :duration 1.0)
    (:time 36 :dtime 1 :keynum 68 :duration 1.0)
    (:time 37 :dtime 1 :keynum 61 :duration 1.0)
    (:time 38 :dtime 1 :keynum 63 :duration 1.0)
    (:time 39 :dtime 1 :keynum 68 :duration 1.0)
    (:time 40 :dtime 1 :keynum 61 :duration 1.0)
    (:time 41 :dtime 1 :keynum 68 :duration 1.0)
    (:time 42 :dtime 1 :keynum 61 :duration 1.0)
    (:time 43 :dtime 1 :keynum 56 :duration 1.0)
    (:time 44 :dtime 1 :keynum 63 :duration 1.0)
    (:time 45 :dtime 1 :keynum 58 :duration 1.0)
    (:time 46 :dtime 1 :keynum 68 :duration 1.0)
    (:time 47 :dtime 1 :keynum 61 :duration 1.0)
    (:time 48 :dtime 1 :keynum 58 :duration 1.0)
    (:time 49 :dtime 1 :keynum 61 :duration 1.0)
    (:time 50 :dtime 1 :keynum 68 :duration 1.0)
    (:time 51 :dtime 1 :keynum 58 :duration 1.0)
    (:time 52 :dtime 1 :keynum 61 :duration 1.0)
    (:time 53 :dtime 1 :keynum 63 :duration 1.0)
    (:time 54 :dtime 1 :keynum 61 :duration 1.0)
    (:time 55 :dtime 1 :keynum 58 :duration 1.0)
    (:time 56 :dtime 1 :keynum 68 :duration 1.0)
    (:time 57 :dtime 1 :keynum 61 :duration 1.0)
    (:time 58 :dtime 1 :keynum 56 :duration 1.0)
    (:time 59 :dtime 1 :keynum 68 :duration 1.0)
    (:time 60 :dtime 0.99 :keynum 61 :duration 1.0)
    (:time 60.99 :dtime 0.01 :keynum 50 :duration 1.0)
    (:time 61 :dtime 1 :keynum 56 :duration 1.0)
    (:time 62 :dtime 1 :keynum 61 :duration 1.0)
    (:time 63 :dtime 1 :keynum 63 :duration 1.0)
    (:time 64 :dtime 1 :keynum 61 :duration 1.0)
    (:time 65 :dtime 1 :keynum 54 :duration 1.0)
    (:time 66 :dtime 1 :keynum 68 :duration 1.0)
    (:time 67 :dtime 1 :keynum 61 :duration 1.0)
    (:time 68 :dtime 1 :keynum 56 :duration 1.0)
    (:time 69 :dtime 1 :keynum 68 :duration 1.0)
    (:time 70 :dtime 1 :keynum 61 :duration 1.0)
    (:time 71 :dtime 1 :keynum 58 :duration 1.0)
    (:time 72 :dtime 1 :keynum 61 :duration 1.0)
    (:time 73 :dtime 1 :keynum 63 :duration 1.0)
    (:time 74 :dtime 1 :keynum 61 :duration 1.0)
    (:time 75 :dtime 1 :keynum 54 :duration 1.0)
    (:time 76 :dtime 1 :keynum 61 :duration 1.0)
    (:time 77 :dtime 1 :keynum 51 :duration 1.0)
    (:time 78 :dtime 1 :keynum 68 :duration 1.0)
    (:time 79 :dtime 1 :keynum 61 :duration 1.0)
    (:time 80 :dtime 1 :keynum 56 :duration 1.0)
    (:time 81 :dtime 1 :keynum 58 :duration 1.0)
    (:time 82 :dtime 1 :keynum 68 :duration 1.0)
    (:time 83 :dtime 1 :keynum 61 :duration 1.0)
    (:time 84 :dtime 1 :keynum 63 :duration 1.0)
    (:time 85 :dtime 1 :keynum 68 :duration 1.0)
    (:time 86 :dtime 1 :keynum 61 :duration 1.0)
    (:time 87 :dtime 1 :keynum 68 :duration 1.0)
    (:time 88 :dtime 0.99 :keynum 61 :duration 1.0)
    (:time 88.99 :dtime 0.01 :keynum 60 :duration 1.0)
    (:time 89 :dtime 1 :keynum 56 :duration 1.0)
    (:time 90 :dtime 1 :keynum 61 :duration 1.0)
    (:time 91 :dtime 1 :keynum 63 :duration 1.0)
    (:time 92 :dtime 1 :keynum 68 :duration 1.0)
    (:time 93 :dtime 1 :keynum 61 :duration 1.0)
    (:time 94 :dtime 1 :keynum 58 :duration 1.0)
    (:time 95 :dtime 1 :keynum 61 :duration 1.0)
    (:time 96 :dtime 1 :keynum 68 :duration 1.0)
    (:time 97 :dtime 1 :keynum 58 :duration 1.0)
    (:time 98 :dtime 1 :keynum 61 :duration 1.0)
    (:time 99 :dtime 1 :keynum 63 :duration 1.0)
    (:time 100 :dtime 1 :keynum 61 :duration 1.0)
    (:time 101 :dtime 1 :keynum 58 :duration 1.0)
    (:time 102 :dtime 1 :keynum 68 :duration 1.0)
    (:time 103 :dtime 1 :keynum 61 :duration 1.0)
    (:time 104 :dtime 1 :keynum 51 :duration 1.0)
    (:time 105 :dtime 1 :keynum 68 :duration 1.0)
    (:time 106 :dtime 1 :keynum 61 :duration 1.0)
    (:time 107 :dtime 1 :keynum 56 :duration 1.0)
    (:time 108 :dtime 1 :keynum 61 :duration 1.0)
    (:time 109 :dtime 1 :keynum 63 :duration 1.0)
    (:time 110 :dtime 1 :keynum 61 :duration 1.0)
    (:time 111 :dtime 1 :keynum 54 :duration 1.0)
    (:time 112 :dtime 1 :keynum 68 :duration 1.0)
    (:time 113 :dtime 1 :keynum 61 :duration 1.0)
    (:time 114 :dtime 1 :keynum 56 :duration 1.0)
    (:time 115 :dtime 1 :keynum 68 :duration 1.0)
    (:time 116 :dtime 1 :keynum 61 :duration 1.0)
    (:time 117 :dtime 1 :keynum 56 :duration 1.0)
    (:time 118 :dtime 1 :keynum 61 :duration 1.0)
    (:time 119 :dtime 1 :keynum 63 :duration 1.0)
    (:time 120 :dtime 1 :keynum 61 :duration 1.0)
    (:time 121 :dtime 1 :keynum 54 :duration 1.0)
    (:time 122 :dtime 1 :keynum 61 :duration 1.0)
    (:time 123 :dtime 0 :keynum 56 :duration 1.0)
    (:time 123 :dtime 1 :keynum 64 :duration 1.0)
    (:time 124 :dtime 1 :keynum 68 :duration 1.0)
    (:time 125 :dtime 1 :keynum 63 :duration 1.0)
    (:time 126 :dtime 1 :keynum 61 :duration 1.0)
    (:time 127 :dtime 1 :keynum 54 :duration 1.0)
    (:time 128 :dtime 1 :keynum 58 :duration 1.0)
    (:time 129 :dtime 0 :keynum 56 :duration 1.0)
    (:time 129 :dtime 1 :keynum 57 :duration 1.0)
    (:time 130 :dtime 1 :keynum 68 :duration 1.0)
    (:time 131 :dtime 1 :keynum 63 :duration 1.0)
    (:time 132 :dtime 0 :keynum 56 :duration 1.0)
    (:time 132 :dtime 1 :keynum 53 :duration 1.0)
    (:time 133 :dtime 0 :keynum 61 :duration 1.0)
    (:time 133 :dtime 1 :keynum 62 :duration 1.0)
    (:time 134 :dtime 1 :keynum 68 :duration 1.0)
    (:time 135 :dtime 1 :keynum 54 :duration 1.0)
    (:time 136 :dtime 1 :keynum 63 :duration 1.0)
    (:time 137 :dtime 0 :keynum 58 :duration 1.0)
    (:time 137 :dtime 1 :keynum 59 :duration 1.0)
    (:time 138 :dtime 0 :keynum 56 :duration 1.0)
    (:time 138 :dtime 1 :keynum 52 :duration 1.0)
    (:time 139 :dtime 0 :keynum 61 :duration 1.0)
    (:time 139 :dtime 1 :keynum 55 :duration 1.0)
    (:time 140 :dtime 1 :keynum 68 :duration 1.0)
    (:time 141 :dtime 0 :keynum 56 :duration 1.0)
    (:time 141 :dtime 1 :keynum 48 :duration 1.0)
    (:time 142 :dtime 0 :keynum 61 :duration 1.0)
    (:time 142 :dtime 1 :keynum 62 :duration 1.0)
    (:time 143 :dtime 1 :keynum 54 :duration 1.0)
    (:time 144 :dtime 1 :keynum 63 :duration 1.0)
    (:time 145 :dtime 1 :keynum 68 :duration 1.0)
    (:time 146 :dtime 0 :keynum 58 :duration 1.0)
    (:time 146 :dtime 1 :keynum 55 :duration 1.0)
    (:time 147 :dtime 0 :keynum 61 :duration 1.0)
    (:time 147 :dtime 1 :keynum 53 :duration 1.0)
    (:time 148 :dtime 1 :keynum 54 :duration 1.0)
    (:time 149 :dtime 1 :keynum 68 :duration 1.0)
    (:time 150 :dtime 0 :keynum 56 :duration 1.0)
    (:time 150 :dtime 1 :keynum 60 :duration 1.0)
    (:time 151 :dtime 1 :keynum 63 :duration 1.0)
    (:time 152 :dtime 1 :keynum 54 :duration 1.0)
    (:time 153 :dtime 1 :keynum 68 :duration 1.0)
    (:time 154 :dtime 0 :keynum 61 :duration 1.0)
    (:time 154 :dtime 1 :keynum 48 :duration 1.0)
    (:time 155 :dtime 0 :keynum 58 :duration 1.0)
    (:time 155 :dtime 1 :keynum 60 :duration 1.0)
    (:time 156 :dtime 0 :keynum 56 :duration 1.0)
    (:time 156 :dtime 1 :keynum 57 :duration 1.0)
    (:time 157 :dtime 1 :keynum 63 :duration 1.0)
    (:time 158 :dtime 1 :keynum 54 :duration 1.0)
    (:time 159 :dtime 0 :keynum 56 :duration 1.0)
    (:time 159 :dtime 1 :keynum 62 :duration 1.0)
    (:time 160 :dtime 1 :keynum 68 :duration 1.0)
    (:time 161 :dtime 1 :keynum 63 :duration 1.0)
    (:time 162 :dtime 0 :keynum 61 :duration 1.0)
    (:time 162 :dtime 1 :keynum 53 :duration 1.0)
    (:time 163 :dtime 1 :keynum 54 :duration 1.0)
    (:time 164 :dtime 0 :keynum 58 :duration 1.0)
    (:time 164 :dtime 1 :keynum 48 :duration 1.0)
    (:time 165 :dtime 0 :keynum 56 :duration 1.0)
    (:time 165 :dtime 1 :keynum 59 :duration 1.0)
    (:time 166 :dtime 1 :keynum 68 :duration 1.0)
    (:time 167 :dtime 1 :keynum 63 :duration 1.0)
    (:time 168 :dtime 0 :keynum 56 :duration 1.0)
    (:time 168 :dtime 1 :keynum 65 :duration 1.0)
    (:time 169 :dtime 0 :keynum 61 :duration 1.0)
    (:time 169 :dtime 1 :keynum 59 :duration 1.0)
    (:time 170 :dtime 1 :keynum 68 :duration 1.0)
    (:time 171 :dtime 1 :keynum 54 :duration 1.0)
    (:time 172 :dtime 1 :keynum 63 :duration 1.0)
    (:time 173 :dtime 0 :keynum 58 :duration 1.0)
    (:time 173 :dtime 1 :keynum 53 :duration 1.0)
    (:time 174 :dtime 0 :keynum 56 :duration 1.0)
    (:time 174 :dtime 1 :keynum 57 :duration 1.0)
    (:time 175 :dtime 0 :keynum 61 :duration 1.0)
    (:time 175 :dtime 1 :keynum 64 :duration 1.0)
    (:time 176 :dtime 1 :keynum 68 :duration 1.0)
    (:time 177 :dtime 0 :keynum 56 :duration 1.0)
    (:time 177 :dtime 1 :keynum 55 :duration 1.0)
    (:time 178 :dtime 1 :keynum 54 :duration 1.0)
    (:time 179 :dtime 1 :keynum 61 :duration 1.0)
    (:time 180 :dtime 1 :keynum 63 :duration 1.0)
    (:time 181 :dtime 1 :keynum 68 :duration 1.0)
    (:time 182 :dtime 1 :keynum 58 :duration 1.0)
    (:time 183 :dtime 1 :keynum 56 :duration 1.0)
    (:time 184 :dtime 1 :keynum 54 :duration 1.0)
    (:time 185 :dtime 1 :keynum 61 :duration 1.0)
    (:time 186 :dtime 1 :keynum 56 :duration 1.0)
    (:time 187 :dtime 1 :keynum 63 :duration 1.0)
    (:time 188 :dtime 1 :keynum 54 :duration 1.0)
    (:time 189 :dtime 1 :keynum 68 :duration 1.0)
    (:time 190 :dtime 1 :keynum 61 :duration 1.0)
    (:time 191 :dtime 1 :keynum 58 :duration 1.0)
    (:time 192 :dtime 1 :keynum 56 :duration 1.0)
    (:time 193 :dtime 1 :keynum 63 :duration 1.0)
    (:time 194 :dtime 1 :keynum 54 :duration 1.0)
    (:time 195 :dtime 1 :keynum 56 :duration 1.0)
    (:time 196 :dtime 1 :keynum 68 :duration 1.0)
    (:time 197 :dtime 1 :keynum 63 :duration 1.0)
    (:time 198 :dtime 1 :keynum 61 :duration 1.0)
    (:time 199 :dtime 1 :keynum 54 :duration 1.0)
    (:time 200 :dtime 1 :keynum 58 :duration 1.0)
    (:time 201 :dtime 1 :keynum 56 :duration 1.0)
    (:time 202 :dtime 1 :keynum 68 :duration 1.0)
    (:time 203 :dtime 1 :keynum 63 :duration 1.0)
    (:time 204 :dtime 1 :keynum 56 :duration 1.0)
    (:time 205 :dtime 1 :keynum 61 :duration 1.0)
    (:time 206 :dtime 1 :keynum 68 :duration 1.0)
    (:time 207 :dtime 1 :keynum 54 :duration 1.0)
    (:time 208 :dtime 1 :keynum 63 :duration 1.0)
    (:time 209 :dtime 1 :keynum 58 :duration 1.0)
    (:time 210 :dtime 1 :keynum 56 :duration 1.0)
    (:time 211 :dtime 1 :keynum 61 :duration 1.0)
    (:time 212 :dtime 1 :keynum 68 :duration 1.0)
    (:time 213 :dtime 1 :keynum 56 :duration 1.0)
    (:time 214 :dtime 1 :keynum 54 :duration 1.0)
    (:time 215 :dtime 1 :keynum 61 :duration 1.0)
    (:time 216 :dtime 1 :keynum 63 :duration 1.0)
    (:time 217 :dtime 1 :keynum 68 :duration 1.0)
    (:time 218 :dtime 1 :keynum 58 :duration 1.0)
    (:time 219 :dtime 1 :keynum 56 :duration 1.0)
    (:time 220 :dtime 1 :keynum 54 :duration 1.0)
    (:time 221 :dtime 1 :keynum 61 :duration 1.0)
    (:time 222 :dtime 1 :keynum 56 :duration 1.0)
    (:time 223 :dtime 1 :keynum 63 :duration 1.0)
    (:time 224 :dtime 1 :keynum 54 :duration 1.0)
    (:time 225 :dtime 1 :keynum 68 :duration 1.0)
    (:time 226 :dtime 1 :keynum 61 :duration 1.0)
    (:time 227 :dtime 1 :keynum 58 :duration 1.0)
    (:time 228 :dtime 1 :keynum 56 :duration 1.0)
    (:time 229 :dtime 1 :keynum 63 :duration 1.0)
    (:time 230 :dtime 1 :keynum 54 :duration 1.0)
    (:time 231 :dtime 1 :keynum 56 :duration 1.0)
    (:time 232 :dtime 1 :keynum 68 :duration 1.0)
    (:time 233 :dtime 1 :keynum 63 :duration 1.0)
    (:time 234 :dtime 1 :keynum 61 :duration 1.0)
    (:time 235 :dtime 1 :keynum 54 :duration 1.0)
    (:time 236 :dtime 1 :keynum 58 :duration 1.0)
    (:time 237 :dtime 1 :keynum 56 :duration 1.0)
    (:time 238 :dtime 1 :keynum 68 :duration 1.0)
    (:time 239 :dtime 1 :keynum 63 :duration 1.0)
    (:time 240 :dtime 1 :keynum 56 :duration 1.0)
    (:time 241 :dtime 1 :keynum 61 :duration 1.0)
    (:time 242 :dtime 1 :keynum 68 :duration 1.0)
    (:time 243 :dtime 1 :keynum 54 :duration 1.0)
    (:time 244 :dtime 1 :keynum 63 :duration 1.0)
    (:time 245 :dtime 1 :keynum 58 :duration 1.0)
    (:time 246 :dtime 1 :keynum 56 :duration 1.0)
    (:time 247 :dtime 1 :keynum 61 :duration 1.0)
    (:time 248 :dtime 1 :keynum 68 :duration 1.0)
    (:time 249 :dtime 1 :keynum 56 :duration 1.0)
    (:time 250 :dtime 1 :keynum 54 :duration 1.0)
    (:time 251 :dtime 1 :keynum 61 :duration 1.0)
    (:time 252 :dtime 1 :keynum 63 :duration 1.0)
    (:time 253 :dtime 1 :keynum 68 :duration 1.0)
    (:time 254 :dtime 1 :keynum 58 :duration 1.0)
    (:time 255 :dtime 1 :keynum 56 :duration 1.0)
    (:time 256 :dtime 1 :keynum 54 :duration 1.0)
    (:time 257 :dtime 1 :keynum 61 :duration 1.0)
    (:time 258 :dtime 1 :keynum 56 :duration 1.0)
    (:time 259 :dtime 1 :keynum 63 :duration 1.0)
    (:time 260 :dtime 1 :keynum 54 :duration 1.0)
    (:time 261 :dtime 1 :keynum 68 :duration 1.0)
    (:time 262 :dtime 1 :keynum 61 :duration 1.0)
    (:time 263 :dtime 1 :keynum 58 :duration 1.0)
    (:time 264 :dtime 1 :keynum 56 :duration 1.0)
    (:time 265 :dtime 1 :keynum 63 :duration 1.0)))

(defparameter *solo-play* t)
(defparameter *kbd-note-fn* nil)
(defparameter *curr-kbd-seq* nil)

(defun play-solo-seq (seq time &optional (tempo 40))
  (when *solo-play*
    (setf *curr-kbd-seq* (rest seq))
    (funcall *kbd-note-fn* (getf (first seq) :keynum) 1)
    (format t "~a~%" (first seq))
    (when seq
      (let ((next (+ time (* incudine::*sample-rate* (/ 60 tempo) (getf (first seq) :dtime)))))
        (incudine:at next #'play-solo-seq (cdr seq) next)))))

(setf *kbd-note-fn* (flock-keyboard-in (find-controller :kbd1)))

#|



(setf *curr-kbd-seq* *solo-seq*)


(bs-state-recall 53 :players-to-recall '(:auto) :load-audio t)



(progn
  (bs-state-recall 53 :players-to-recall '(0) :load-audio t)
  (setf *solo-play* t)
  (play-solo-seq *curr-kbd-seq* (incudine::now)))

(setf *solo-play* nil)
|#
