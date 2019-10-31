;;; 
;;; nano-ctl.lisp
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

(defclass nanokontrol (midi-controller)
  ((rec-state :initform nil :initarg :rec-state :accessor rec-state))
  )

(defmethod initialize-instance :before ((instance nanokontrol) &rest args)
  (setf (id instance) (getf args :id :bs1))
  (setf (chan instance) (getf args :chan 6)))

(defun get-inverse-lookup-array (seq)
  (let ((array (make-array 128 :initial-contents (loop for i below 128 collect i))))
    (loop
      with remain = ()
      for x in seq
      for idx from 0
      do (progn
           (push (aref array x) remain)
           (setf (aref array x) idx)))
    array))

(defmethod initialize-instance :after ((instance nanokontrol) &rest args)
  (declare (ignore args))
  (with-slots (cc-map gui id chan midi-output) instance
    (setf cc-map
          (get-inverse-lookup-array
           '(16 17 18 19 20 21 22 23  ;;; dials
             0 1 2 3 4 5 6 7          ;;; fader
                                      ;;; transport-ctl:
             58 59                    ;;; 16 17
             46    60 61 62           ;;; 18    19 20 21
             43 44 42 41 45           ;;; 22 23 24 25 26
                                      ;;; S/M/R pushbuttons:
             32 33 34 35 36 37 38 39  ;;; 27 28 29 30 31 32 33 34
             48 49 50 51 52 53 54 55  ;;; 35 36 37 38 39 40 41 42
             64 65 66 67 68 69 70 71  ;;; 43 44 45 46 47 48 49 50
             )))
    (setf gui (nanokontrol-gui :id id))
    (setf (cuda-gui::cleanup-fn (cuda-gui::find-gui id))
          (let ((id id))
            (lambda () (remove-midi-controller id))))
    (sleep 1)
    (init-nanokontrol-gui-callbacks instance)))

(defmethod handle-midi-in ((instance nanokontrol) opcode d1 d2)
  (with-slots (gui chan cc-map cc-fns cc-offset midi-output rec-state) instance
    (case opcode
      (:cc (cond
             ((or (<= 0 d1 7) (<= 16 d1 23))
              (cuda-gui::handle-cc-in
               gui
               (aref cc-map d1) ;;; idx of numbox in gui
               d2))
             ((= d1 45) ;;; Rec Transport-ctl Button
              (if (= d2 127) ;;; momentary mode
                  (progn
                    (setf rec-state (not rec-state))
                    (funcall (ctl-out midi-output d1 (if rec-state 127 0) (1- chan))))))
             ((or (<= 41 d1 46) (<= 58 d1 62)) ;;; transport-controls (rec-transport already in previous cond form!)
              (funcall (aref cc-fns (aref cc-map d1)) d2))
               ;;; S/M Pushbuttons
             ((or (<= 32 d1 39)
                  (<= 48 d1 55))
              (pushbutton-callback instance d1 d2)
              (if rec-state
                  (funcall (ctl-out midi-output 45 0 (1- chan))))
              (funcall (ctl-out midi-output d1 127 (1- chan)))
              (at (+ (now) 0.15) (ctl-out midi-output d1 0 (1- chan))))
               ;;; R Pushbuttons
             ((<= 64 d1 71)
              (setf cc-offset (* 16 (- d1 64)))
              (format t "~&cc-offset: ~a" cc-offset)
              (loop for cc from 64 to 71
                    do (funcall (ctl-out midi-output cc (if (= cc d1) 127 0) (1- chan)))))
))
      (:note-on nil)
      (:note-off nil))))

(defgeneric pushbutton-callback (obj cc-num val))

(defmethod pushbutton-callback ((instance nanokontrol) cc-num val)
  (declare (ignore val))
  (with-slots (cc-map cc-offset chan midi-output rec-state) instance
    (let ((idx (- (aref cc-map cc-num) 27)))
;;      (format t "~&idx: ~a, rec-state: ~a" idx rec-state)
      (if rec-state
          (progn
            (bs-state-save (+ idx cc-offset))
            (setf rec-state nil)
            (funcall (ctl-out midi-output 45 0 (1- chan))))
          (bs-state-recall (+ idx cc-offset))))))

(defun init-nanokontrol-gui-callbacks (instance &key (midi-echo t))
  (declare (ignore midi-echo))
  ;;; dials and faders
  (loop for idx below 16
        do (with-slots (gui note-fn cc-fns cc-state cc-offset chan midi-output) instance
             (set-encoder-callback
              gui
              idx
              (let ((idx idx))
                (lambda (val)
                  (setf (aref cc-state (+ idx cc-offset)) val)
                  (funcall (aref cc-fns (+ idx cc-offset)) val))))
             )))



(defmethod update-gui-fader ((instance nanokontrol))
  (loop for idx below 16
        for cc-val across (cc-state instance)
        do (cuda-gui::set-fader (gui instance) idx cc-val)))

(defmethod restore-controller-state ((controller nanokontrol) cc-state cc-fns)
  (if cc-fns (setf (cc-fns controller) cc-fns))
  (if cc-state
      (progn
        (setf (cc-state controller) cc-state)
        (update-gui-fader controller))))

;;; (funcall (note-on *midi-out1* 36 0 5))

(defclass nanokontrol2 (nanokontrol) ())

(defmethod initialize-instance :after ((instance nanokontrol2) &rest args)
  (unless (getf args :cc-map)
    (setf (cc-map instance)
          (get-inverse-lookup-array
           '(16 17 18 19 20 21 22 23
              0  1  2  3  4  5  6  7)))))

;;; (make-instance 'nanokontrol2)



;;; (init-nanokontrol-gui-callbacks :bs1)



;;; (gui (find-controller :bs1))

