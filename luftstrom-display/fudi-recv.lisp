;;; 
;;; fudi-recv.lisp
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

(fudi-open-default :direction :input)

(set-receiver!
 (lambda (message)
;;;   (format t "~&~a ~a~%" (symbol-name (first message)) (eq (first message) 'CC))

   (case (first message)
     (:cc (destructuring-bind (ch d1 d2) (rest message)
           (if (and *midi-debug* (midi-filter ch d1))
               (format t "~&cc: ~a ~a ~a~%" ch d1 d2))
           (setf (aref *cc-state* ch d1) d2)
           (handle-ewi-hold-cc ch d1)
           (funcall (aref *cc-fns* ch d1) d2)))
     (:note-on (destructuring-bind (ch keynum velo) (rest message)
               (if *midi-debug* (format t "~&note: ~a ~a ~a~%" ch keynum velo))
               (funcall (aref *note-fns* ch) keynum)
               (setf (aref *note-states* ch) keynum)
               ))))
 *fudi-in*
 :format :raw)

;; (setf *midi-debug* t)
