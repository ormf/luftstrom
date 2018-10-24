;;; 
;;; midictl.lisp
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

(defparameter *nk2* (make-array '(6 128) :element-type 'integer :initial-element 0))
(defparameter *nk2-fns* (make-array '(6 128) :element-type 'function :initial-element #'identity))

(defparameter *notes* (make-array '(16) :element-type 'integer :initial-element 0))
(defparameter *note-fns* (make-array '(16) :element-type 'function :initial-element #'identity))

(defparameter *ewi-states*
  (make-array '(4 128) :element-type 'integer :initial-element 0))

(declaim (inline last-keynum))
(defun last-keynum (player)
  (aref *notes* player))

(defun clear-nk2-fns ()
  (dotimes (m 2)
    (dotimes (n 128)
      (unless (and (= m 0) (member n '(46 58 59))) ;;; protect some
                                                   ;;; nk2 switches
                                                   ;;; used to control
                                                   ;;; the gui
        (setf (aref *nk2-fns* m n) #'identity)))))

(defun clear-note-fns ()
  (dotimes (n 16)
    (setf (aref *note-fns* n) #'identity)))

;;; (clear-nk2-fns)

(defparameter *midi-debug* nil)

(set-receiver!
 (lambda (st d1 d2)
   (case (status->opcode st)
     (:cc (let ((ch (status->channel st)))
            (if (< ch 5)
                (progn
                  (if *midi-debug* (format t "~&cc: ~a ~a ~a~%" ch d1 d2))
                  (setf (aref *nk21* ch d1) d2)
                  (funcall (aref *nk2-fns* ch d1) d2)))))
     (:note-on
      (let ((ch (status->channel st)))
        (format t "~&note: ~a ~a ~a~%" ch d1 d2)
        (funcall (aref *note-fns* ch) d1)
        (setf (aref *ewi-states* ch) d1)
        ))))
 *midi-in1*
 :format :raw)

(setf (aref *note-fns* 0) #'identity)

;;; (cm::stream-receive-stop *midi-in1*)

#|
(set-receiver!
   (lambda (st d1 d2)
     (case (status->opcode st)
       (:cc (case d1
              ;; (0 (setf *freq* (mtof (interpl d2 '(0 -36 127 108)))))
              ;; (1 (setf *arrayidx* (interpl d2 '(0 0 127 99))))
              ;; (2 (setf *lfofreq* (mtof (interpl d2 '(0 -36 127 72)))))
              ;; (6 (setf *dur* (max 0.1 (interpl d2 '(0 0.1 127 5) :base 50))))
              ;; (7 (setf *amp* (let ((amp (interpl d2 '(0 0.001 127 1) :base 1000)))
              ;;                         (if (= amp 0.001) 0 amp))))
              ;; (16 (setf *inner-dur* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))
              ;; (17 (setf *inner-suswidth* (min 0.99 (interpl d2 '(0 0 127 1)))))
              ;; (18 (setf *suswidth* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))
              ;; (19 (setf *suspan* (max 0.01 (interpl d2 '(0 0.01 127 1) :base 100))))

              (t (format t "~&:cc ~a ~a ~a" d1 d2 (status->channel st)))
              ))))              
   *midi-in1*
   :format :raw)

(loop for nk below 2
   do (loop for cc below 16
         do (format t "~&(defparameter *cc-~a-~a* 0)~%" nk cc)))
|#

