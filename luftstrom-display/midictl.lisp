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

(defparameter *nk2-chan* 4)
(defparameter *art-chan* 5)
(defparameter *all-players* #(:player1 :player2 :player3 :player4 :nk2 :arturia))
(defparameter *player-chans* (vector 0 1 2 3 *nk2-chan* *art-chan*))

(defparameter *player-lookup* (make-hash-table))


(defun init-player-lookup ()
  (loop for chan across *player-chans*
        for name across *all-players*
        for idx from 0
        do (progn
             (setf (gethash idx *player-lookup*) chan)
             (setf (gethash name *player-lookup*) chan))))

(init-player-lookup)

(declaim (inline player-chan))
(defun player-chan (idx-or-key) (gethash idx-or-key *player-lookup*))
(defun player-name (idx) (aref *all-players* idx))

(defparameter *cc-state* (make-array '(6 128) :element-type 'integer :initial-element 0))
(defparameter *cc-fns* (make-array '(6 128) :element-type 'function :initial-element #'identity))

(defparameter *note-states* ;;; stores last note-on keynum for each player.
  (make-array '(16) :element-type 'integer :initial-element 0))
(defparameter *note-fns* (make-array '(16) :element-type 'function :initial-element #'identity))



(declaim (inline last-keynum))
(defun last-keynum (player)
  (aref *note-states* player))

(defun clear-cc-fns (nk2-chan)
  (do-array (idx *cc-fns*)
    (setf (row-major-aref *cc-fns* idx) #'identity))
  (set-fixed-cc-fns nk2-chan))

(defun set-pad-note-fn (player)
  (setf (aref *note-fns* (player-chan player))
        (lambda (d1 d2)
          (cond
            ((<= 44 d1 51) (bs-state-recall (- d1 44)))
            ((<= 36 d1 43) (bs-state-save (- d1 36)))
            (:else (warn "~&pad num ~a not assigned!" d1))))))

(set-pad-note-fn :arturia)


(defun clear-note-fns ()
  (dotimes (n 16)
    (setf (aref *note-fns* n) #'identity)))

;;; (clear-cc-fns)

(defparameter *midi-debug* nil)

;;; (setf *midi-debug* t)

(defun handle-ewi-hold-cc (ch d1)
"we simulate a (virtual) cc 99 toggle: In case cc40 and cc50 are
pressed simutaneously (d2=127), cc 99 value is 127, 0 otherwise."
  (if (member d1 '(40 50))
      (let ((d2 (if (and (= (aref *cc-state* ch 40) 127)
                         (= (aref *cc-state* ch 50) 127))
                    127 0)))
        (setf (aref *cc-state* ch 99) d2)
        (funcall (aref *cc-fns* ch 99) d2))))

(defun midi-filter (ch d1)
  (and (= ch 2) (= d1 100)))

;;; (untrace)

#|
(defun midi-filter (ch d1)
  (declare (ignorable ch d1))
  t)
|#
(defun n-ewi-note (ref)
  (/ (- ref 24) 86.0))

(defun seq-ip-pick (x l1 l2 &key (len 8))
  "interpolate between randomly chosen elems of 8-element lists l1 and
l2 according to x (0..1). For x = 0 take random elm of list l1, for
x=1 take random elem of l2, for x=0.5 take the mean between the elems
l1 and l2 at the same (random) idx."
  (let* ((idx (random len))
         (left (elt l1 idx))
         (delta (- (elt l2 idx) left)))
    (+ left (* x delta))))


;;; (setf *midi-debug* nil)

(declaim (inline rotary->inc))
(defun rotary->inc (num)
  (if (> num 63)
      (- num 128)
      num))

(declaim (inline clip))
(defun clip (val min max)
  (min (max val min) max))

(defmacro rotary->cc (array ch d1 d2)
  `(setf (aref ,array ,ch ,d1)
         (clip (+ (aref ,array ,ch ,d1)
                  (rotary->inc ,d2))
               0 127)))

(set-receiver!
 (lambda (st d1 d2)
;;;   (format t "~&cc: ~a ~a ~a~%" (status->channel st) d1 d2)
   (case (status->opcode st)
     (:cc (let ((ch (status->channel st)))
            (progn
              (if (and *midi-debug* (midi-filter ch d1))
                  (format t "~&cc: ~a ~a ~a~%" ch d1 d2))    
              (if (= ch *art-chan*)
                  (rotary->cc *cc-state* ch d1 d2)
                  (setf (aref *cc-state* ch d1) d2))
              (handle-ewi-hold-cc ch d1)
              (funcall (aref *cc-fns* ch d1) d2))))
     (:note-on
      (let ((ch (status->channel st)))
        (if *midi-debug* (format t "~&note: ~a ~a ~a~%" ch d1 d2))
        (if (= ch (player-chan :arturia))
            (funcall (note-off *midi-out1* d1 0 ch)))
        (funcall (aref *note-fns* ch) d1 d2)
        (setf (aref *note-states* ch) d1)
        ))))
 *midi-in1*
 :format :raw)

;;; (aref *cc-state* 0 99)
;;; (setf (aref *note-fns* 0) #'identity)

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

