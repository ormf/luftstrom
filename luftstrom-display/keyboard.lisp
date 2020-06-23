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

(defclass keyboard (midi-controller)
  ((cc-offset :initform 0
              :initarg :cc-offset :accessor cc-offset)
   (player-idx :initform 0 :initarg :player-idx :accessor player-idx)))

(defmethod initialize-instance :before ((instance keyboard)
                                        &key (id :kbd1) (chan (controller-chan :kbd1))
                                        &allow-other-keys)
  (setf (id instance) id)
  (setf (chan instance) chan))

(defmethod initialize-instance :after ((instance keyboard) &key  &allow-other-keys)
  (setf (note-fn instance) (flock-keyboard-in instance)))

(defun flock-keyboard-in (instance)
  (lambda (key val)
    (with-debugging
      (format t "~&key-in ~S: ~a ~a~%" (id instance) key val))))

;;; (add-midi-controller 'keyboard :id :kbd1 :chan 6)
