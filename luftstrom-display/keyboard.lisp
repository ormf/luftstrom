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

         (set-cell (elt *audio-preset-ctl-model* (+ start 9))
                   (max 0 (+ (val (elt *audio-preset-ctl-model* (+ start 9)))
                             (m-lin (- d2 last-bend) 0 10.0))))
         (setf last-bend d2)))
      (:cc
       (progn
;;;         (format t "~&cc: ~a, ~a~%" d1 d2)
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
    (with-slots (cc-state bs-audio-preset bs-boids-preset pitch-offset obstacles protected save-state) (elt *keyboard-pgms* key)
      (if last-bs-preset
          (bs-state-save last-bs-preset :save-boids t))
      (when bs-audio-preset
        (bs-state-recall
         bs-audio-preset
         :players-to-recall (list player-idx)
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
      (setf last-bs-preset (and save-state bs-boids-preset)))))

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
 '((:bs-audio-preset 53 :bs-boids-preset 124 :obstacles nil :pitch-offset 0.0 :cc-state
    #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) :protected (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset 48 :obstacles nil :pitch-offset 0.155 :cc-state
    #(86 0 0 0 0 0 127 127 53 0 70 11 0 127 91 0) :protected (8) :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(64 0 0 0 0 0 0 0 28.1 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
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
   (:bs-audio-preset 53 :bs-boids-preset 67 :obstacles nil :pitch-offset -0.252 :cc-state
    #(86 0 0 0 0 0 127 127 60 9 70 30 0 127 91 105) :protected (8) :save-state
    nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state
    #(86 0 0 0 0 0 0 0 82.69997 0 0 0 0 0 0 0) :protected
    (0 1 2 3 4 5 6 7 9 10 11 12 13 14 15) :save-state nil)
   (:bs-audio-preset 48 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 49 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 50 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 51 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 52 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 54 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 55 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 56 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 57 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 58 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 59 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 60 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 61 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 62 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 63 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 64 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 65 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 66 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 67 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 68 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 69 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 70 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 71 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 72 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 73 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 74 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 75 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 76 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 77 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 78 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 79 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 80 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 81 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 82 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 83 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 84 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 85 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 86 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 87 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 88 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 89 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 90 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 91 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
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
   (:bs-audio-preset 0 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 1 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 2 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 3 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 4 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 5 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 6 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 7 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 8 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 9 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 10 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 11 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 12 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 13 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 14 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 15 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 16 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 17 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 18 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 19 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 20 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 21 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 22 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 23 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 24 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 25 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 26 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 27 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 28 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 29 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 30 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 31 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 32 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 33 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 34 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 35 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 36 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 37 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 38 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 39 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 40 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 41 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 42 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 43 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 44 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 45 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 46 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 47 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 48 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 49 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 50 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 51 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 52 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 54 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 55 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 56 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 57 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 58 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 59 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 60 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 61 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 62 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 63 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 64 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 65 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 66 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 67 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 68 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 69 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 70 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 71 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 72 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 73 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 74 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 75 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 76 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 77 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 78 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 79 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 80 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 81 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 82 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 83 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 84 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 85 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 86 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 87 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 88 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 89 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 90 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 91 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
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
   (:bs-audio-preset 0 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 1 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 2 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 3 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 4 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 5 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 6 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 7 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 8 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 9 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 10 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 11 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 12 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 13 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 14 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 15 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 16 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 17 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 18 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 19 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 20 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 21 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 22 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 23 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 24 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 25 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 26 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 27 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 28 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 29 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 30 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 31 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 32 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 33 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 34 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 35 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 36 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 37 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 38 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 39 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 40 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 41 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 42 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 43 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 44 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 45 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 46 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 47 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 48 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 49 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 50 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 51 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 52 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 54 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 55 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 56 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 57 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 58 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 59 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 60 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 61 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 62 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 63 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 64 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 65 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 66 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 67 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 68 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 69 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 70 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 71 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 72 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 73 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 74 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 75 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 76 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 77 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 78 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 79 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 80 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 81 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 82 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 83 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 84 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 85 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 86 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 87 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 88 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 89 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 90 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 91 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
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
   (:bs-audio-preset 0 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 1 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 2 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 3 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 4 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 5 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 6 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 7 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 8 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 9 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 10 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 11 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 12 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 13 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 14 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 15 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 16 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 17 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 18 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 19 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 20 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 21 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 22 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 23 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 24 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 25 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 26 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 27 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 28 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 29 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 30 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 31 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 32 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 33 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 34 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 35 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 36 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 37 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 38 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 39 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 40 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 41 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 42 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 43 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 44 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 45 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 46 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 47 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 48 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 49 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 50 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 51 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 52 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 54 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 55 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 56 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 57 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 58 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 59 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 60 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 61 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 62 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 63 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 64 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 65 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 66 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 67 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 68 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 69 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 70 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 71 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 72 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 73 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 74 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 75 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 76 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 77 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 78 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 79 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 80 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 81 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 82 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 83 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 84 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 85 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 86 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 87 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 88 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 89 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 90 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 91 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
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
   (:bs-audio-preset 0 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 1 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 2 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 3 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 4 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 5 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 6 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 7 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 8 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 9 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 10 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 11 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 12 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 13 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 14 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 15 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 16 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 17 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 18 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 19 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 20 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 21 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 22 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 23 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 24 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 25 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 26 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 27 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 28 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 29 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 30 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 31 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 32 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 33 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 34 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 35 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 36 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 37 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 38 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 39 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 40 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 41 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 42 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 43 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 44 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 45 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 46 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 47 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 48 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 49 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 50 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 51 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 52 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 54 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 55 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 56 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 57 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 58 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 59 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 60 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 61 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 62 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 63 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 64 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 65 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 66 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 67 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 68 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 69 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 70 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 71 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 72 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 73 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 74 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 75 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 76 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 77 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 78 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 79 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 80 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 81 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 82 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 83 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 84 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 85 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 86 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 87 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 88 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 89 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 90 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 91 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
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
   (:bs-audio-preset 0 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 1 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 2 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 3 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 4 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 5 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 6 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 7 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 8 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 9 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 10 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 11 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 12 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 13 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 14 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 15 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 16 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 17 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 18 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 19 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 20 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 21 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 22 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 23 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 24 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 25 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 26 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 27 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 28 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 29 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 30 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 31 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 32 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 33 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 34 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 35 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 36 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 37 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 38 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 39 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 40 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 41 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 42 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 43 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 44 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 45 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 46 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 47 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 48 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 49 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 50 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 51 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 52 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 54 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 55 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 56 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 57 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 58 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 59 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 60 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 61 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 62 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 63 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 64 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 65 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 66 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 67 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 68 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 69 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 70 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 71 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 72 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 73 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 74 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 75 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 76 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 77 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 78 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 79 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 80 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 81 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 82 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 83 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 84 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 85 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 86 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 87 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 88 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 89 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 90 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 91 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
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
   (:bs-audio-preset 0 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 1 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 2 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 3 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 4 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 5 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 6 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 7 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 8 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 9 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 10 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 11 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 12 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 13 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 14 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 15 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 16 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 17 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 18 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 19 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 20 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 21 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 22 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 23 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 24 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 25 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 26 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 27 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 28 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 29 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 30 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 31 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 32 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 33 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 34 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 35 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 36 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 37 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 38 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 39 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 40 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 41 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 42 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 43 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 44 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 45 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 46 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 47 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 48 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 49 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 50 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 51 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 52 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 54 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 55 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 56 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 57 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 58 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 59 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 60 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 61 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 62 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 63 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 64 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 65 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 66 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 67 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 68 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 69 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 70 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 71 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 72 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 73 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 74 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 75 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 76 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 77 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 78 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 79 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 80 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 81 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 82 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 83 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 84 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 85 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 86 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 87 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 88 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 89 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 90 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 91 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
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
   (:bs-audio-preset 0 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 1 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 2 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 3 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 4 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 5 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 6 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 7 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 8 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 9 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 10 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 11 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 12 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 13 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 14 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 15 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 16 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 17 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 18 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 19 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 20 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 21 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 22 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 23 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 24 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 25 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 26 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 27 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 28 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 29 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 30 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 31 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 32 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 33 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 34 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 35 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 36 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 37 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 38 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 39 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 40 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 41 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 42 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 43 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 44 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 45 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 46 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 47 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 48 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 49 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 50 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 51 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 52 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 53 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 54 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 55 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 56 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 57 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 58 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 59 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 60 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 61 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 62 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 63 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 64 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 65 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 66 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 67 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 68 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 69 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 70 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 71 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 72 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 73 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 74 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 75 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 76 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 77 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 78 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 79 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 80 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 81 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 82 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 83 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 84 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 85 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 86 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 87 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 88 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 89 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 90 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
    :protected nil :save-state nil)
   (:bs-audio-preset 91 :bs-boids-preset nil :obstacles nil :pitch-offset 0.0 :cc-state nil
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
    :protected nil :save-state nil)))

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
.
