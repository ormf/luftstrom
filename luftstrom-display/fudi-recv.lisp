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

;; (fudi-open-default :host "192.168.99.15" :direction :input)

(fudi-open-default :host "localhost" :port 3002 :direction :input)

(set-receiver!
 (lambda (message)
   (case (first message)

     (:cc (destructuring-bind (ch d1 d2) (rest message)
;;            (format t "~&cc: ~a ~a ~a~%" ch d1 d2)
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

(defparameter *ewi-fudi-connections* nil)

(defun disconnect-ew-4 ()
  (dolist (conn *ewi-fudi-connections*)
    (if (and conn (slot-value conn 'fudi::socket))
          (progn
            (fudi:close conn))))
  (setf *ewi-fudi-connections* nil))

(defun connect-to-ew-4 (ips)
  (disconnect-ew-4)
  (dolist (ip ips)
    (push (fudi-open :host ip :port 3003 :protocol :tcp :direction :output)
          *ewi-fudi-connections*)))

(defun fudi-send-pgm-no (num)
  (let ((msg (format nil "pgm ~d" num)))
    (dolist (stream *ewi-fudi-connections*)
      (output (new fudi :message msg :stream stream)))))

;;; (fudi-send-pgm-no 0)

(defun fudi-send-num-boids (num)
  (let ((msg (format nil "num-boids ~d" num)))
    (dolist (stream *ewi-fudi-connections*)
      (output (new fudi :message msg :stream stream)))))

;;; (fudi-send-num-boids (random 500))

;;; (connect-to-ew-4 '("192.168.99.11" "192.168.99.12" "192.168.99.13" "192.168.99.14" "192.168.99.15"))

;;; (connect-to-ew-4 '("127.0.0.1"))

;;; (output (new fudi :message "Hallo" :stream (first *ewi-fudi-connections*)))

;;; (connect-to-ew-4 '("192.168.99.12" "192.168.99.13" "192.168.99.14" "192.168.99.15"))
