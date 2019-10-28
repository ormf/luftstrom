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

(defclass nanokontrol (midi-controller) ())

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
           '(16 17 18 19 20 21 22 23
             0 1 2 3 4 5 6 7
             58 59             ;;; 16 17
             46    60 61 62    ;;; 18    19 20 21
             43 44 42 41 45))) ;;; 22 23 24 25 26
    (setf gui (nanokontrol-gui :id id))
    (setf (cuda-gui::cleanup-fn (cuda-gui::find-gui id))
          (let ((id id))
            (lambda () (remove-midi-controller id))))
    (sleep 1)
    (init-nanokontrol-gui-callbacks instance)))

(defmethod handle-midi-in ((instance nanokontrol) opcode d1 d2)
  (case opcode
    (:cc (if (or (<= 0 d1 7) (<= 16 d1 23))
             (set-fader
              (gui instance)
              (aref (cc-map instance) d1) ;;; idx of numbox in gui
              d2)
             (funcall (aref (cc-fns instance) (aref (cc-map instance) d1)) d2)))
    (:note-on nil)
    (:note-off nil)))

(defun init-nanokontrol-gui-callbacks (instance &key (midi-echo t))
  (declare (ignore midi-echo))
  (loop for idx below 16
        ;; with note-ids = #(44 45 46 47 48 49 50 51
        ;;                   36 37 38 39 40 41 42 43) ;;; midi-notnums of Nanokontrol
        do (with-slots (gui note-fn cc-fns cc-state cc-offset chan midi-output) instance
             (set-encoder-callback
              gui
              idx
              (let ((idx idx))
                (lambda (val)
                  (setf (aref cc-state (+ idx cc-offset)) val)
                  (funcall (aref cc-fns (+ idx cc-offset)) val))))
             ;; (set-pushbutton-callback
             ;;  gui
             ;;  idx
             ;;  (let ((idx idx))
             ;;    (lambda (pb-instance)
             ;;      (with-slots (state) pb-instance
             ;;        (funcall note-fn (aref note-ids idx) state)
             ;;        (if (> state 0)
             ;;            (progn
             ;;              (disable-radio-buttons gui idx)
             ;;              (if (< idx 8)
             ;;                  (progn
             ;;                    (setf cc-offset (* 16 idx))
             ;;                    (loop
             ;;                      for idx below 16 do
             ;;                        (cuda-gui::set-fader
             ;;                         gui idx (aref cc-state (+ cc-offset idx))))))))
             ;;        (loop for idx below 16)
             ;;        (if midi-echo
             ;;            (progn
             ;;              (funcall (note-on midi-output (aref note-ids idx)
             ;;                                state (1- chan)))))))))
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

