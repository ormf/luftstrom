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
  (cc-state nil)
  (protected nil)
  (save-state nil)
  )

(defclass keyboard (midi-controller)
  ((cc-offset :initform 0
              :initarg :cc-offset :accessor cc-offset)
   (player-idx :initform 0 :initarg :player-idx :accessor player-idx)
   (last-audio :initform nil :initarg :last-audio :accessor last-audio)))

(defmethod initialize-instance :before ((instance keyboard)
                                        &key (id :kbd1) (chan (controller-chan :kbd1))
                                        &allow-other-keys)
  (setf (id instance) id)
  (setf (chan instance) chan))

(defmethod initialize-instance :after ((instance keyboard) &key  &allow-other-keys)
  (setf (note-fn instance) (flock-keyboard-in instance)))

(defun flock-keyboard-in (instance)
  (lambda (key velo)
    (when (> velo 0)
      (format t "~&key-in ~S: ~a ~a~%" (id instance) key velo)
      (load-keyboard-pgm instance (- key 36)))))

(defun load-keyboard-pgm (instance key)
  (with-slots (last-audio player-idx) instance
    (with-slots (cc-state bs-audio-preset bs-boids-preset obstacles protected) (elt *keyboard-pgms* key)
      (if bs-audio-preset
          (bs-state-recall
           bs-audio-preset
           :players-to-recall (list player-idx)
           :load-obstacles nil
           :load-audio (if (not (eql last-audio bs-audio-preset))
                           (setf last-audio bs-audio-preset))
           :load-boids nil
           :cc-state cc-state
           :protected protected))
      (if bs-boids-preset
          (bs-state-recall
           bs-boids-preset
           :players-to-recall (list player-idx)
           :load-obstacles obstacles
           :load-audio nil
           :load-boids t))
      )))




;;; (remove-midi-controller :kbd1)

;;; (add-midi-controller 'keyboard :id :kbd1 :chan 6)

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
      for pitch from 26 by 2.1
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
|#

