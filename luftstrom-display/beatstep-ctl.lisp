;;; 
;;; beatstep-ctl.lisp
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

(defclass beatstep (midi-controller) ())

(defmethod initialize-instance :before ((instance beatstep) &rest args)
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

(defmethod initialize-instance :after ((instance beatstep) &rest args)
  (declare (ignore args))
  (with-slots (cc-map gui id chan midi-output) instance
    (setf cc-map
          (get-inverse-lookup-array
           '(32 33 34 35 36 37 38 39
             40 41 42 43 44 45 46 47)))
    (setf gui (beatstep-gui :id id))
    (setf (cuda-gui::cleanup-fn (cuda-gui::find-gui id))
          (let ((id id))
            (lambda () (remove-midi-controller id))))
    (sleep 1)
    (init-beatstep-gui-callbacks instance)))

(defmethod handle-midi-in ((instance beatstep) opcode d1 d2)
  (case opcode
    (:cc (unless (= d1 48) ;;; big encoder wheel of beatstep
                 (inc-fader
                           (gui instance)
                           (aref (cc-map instance) d1) ;;; idx of numbox in gui
                           (rotary->inc d2))))
    (:note-on
     (let ((velo (if (zerop d2) 127 d2)))
       (cond
         ((<= 44 d1 51) ;;; emulate click into radio-buttons upper row (1-8)
          (cuda-gui::emit-signal
           (aref (cuda-gui::buttons (gui instance)) (- d1 44)) "setState(int)" velo))
         ((<= 36 d1 43) ;;; emulate click into radio-buttons lower row (9-16)
          (cuda-gui::emit-signal
           (aref (cuda-gui::buttons (gui instance)) (- d1 28)) "setState(int)" velo)))))
    (:note-off (funcall (note-fn instance) d1 0))))


(defun init-beatstep-gui-callbacks (instance &key (midi-echo t))
  (loop for idx below 16
        with note-ids = #(44 45 46 47 48 49 50 51
                          36 37 38 39 40 41 42 43) ;;; midi-notnums of Beatstep
        do (with-slots (gui note-fn cc-fns cc-state cc-offset chan midi-output) instance
             (set-encoder-callback
              gui
              idx
              (let ((idx idx))
                (lambda (val)
                  (setf (aref cc-state (+ idx cc-offset)) val)
                  (funcall (aref cc-fns (+ idx cc-offset)) val))))
             (set-pushbutton-callback
              gui
              idx
              (let ((idx idx))
                (lambda (pb-instance)
                  (with-slots (state) pb-instance
                    (funcall note-fn (aref note-ids idx) state)
                    (if (> state 0)
                        (progn
                          (disable-radio-buttons gui idx)
                          (if (< idx 8)
                              (progn
                                (setf cc-offset (* 16 idx))
                                (loop
                                  for idx below 16 do
                                    (cuda-gui::set-fader
                                     gui idx (aref cc-state (+ cc-offset idx))))))))
                    (loop for idx below 16)
                    (if midi-echo
                        (progn
                          (funcall (note-on midi-output (aref note-ids idx)
                                            state (1- chan))))))))))))



(defun disable-radio-buttons (instance idx)
  (let ((id-offs (if (< idx 8) 0 8)))
    (dotimes (i 8)
      (if (/= (+ i id-offs) idx)
          (progn
            (cuda-gui::set-state
             (aref (cuda-gui::buttons instance) (+ i id-offs)) 0))))))

(defgeneric update-gui-fader (obj))

(defmethod update-gui-fader ((instance beatstep))
  (loop for idx below 16
        for cc-val across (cc-state instance)
        do (cuda-gui::set-fader (gui instance) idx cc-val)))

(defgeneric update-gui-encoder-callbacks (obj))

(defmethod update-gui-encoder-callbacks ((instance beatstep))
  (with-slots (cc-fns cc-state cc-offset gui) instance
    (dotimes (idx 16)
      (set-encoder-callback
       gui
       idx
       (let ((idx idx))
         (lambda (val)
           (setf (aref cc-state (+ idx cc-offset)) val)
           (funcall (aref cc-fns (+ idx cc-offset)) val)))))))

(defgeneric restore-controller-state (obj cc-state cc-fns))

(defmethod restore-controller-state ((controller beatstep) cc-state cc-fns)
  (if cc-fns (setf (cc-fns controller) cc-fns))
  (if cc-state
      (progn
        (setf (cc-state controller) cc-state)
        (update-gui-fader controller))))

#|



(cc-state (find-controller :bs1))
(with-slots (cc-fns) (find-controller :bs1)
  (loop
    for idx below 128
    do (setf (aref cc-fns idx)
             (let ((idx idx))
               (lambda (val) (format t "~&idx: ~a, val: ~a~%" idx val))))))
(midi-output *bs2*)
(untrace)
(setf *bs1* (make-instance 'beatstep))
(setf *bs2* (make-instance 'beatstep :id :bs2 :chan 4))



(cuda-gui::find-gui :bs1)

(make-instance 'beatstep :id :bs2)

(member *bs2* (gethash *midi-in1* *midi-controllers*))

(remhash nil *midi-controllers*)

(setf *midi-controllers* (make-hash-table :test #'equal))

(defun start-midi-receive ()
  (set-receiver!
     (lambda (st d1 d2)
       (if *midi-debug*
           (format t "~&~S ~a ~a ~a~%" (status->opcode st) d1 d2  (status->channel st)))
       (case (status->opcode st)
         (:cc (let ((ch (status->channel st)))
                (progn    
                  (if (= ch *bs1-chan*)
                    (progn
                      (inc-fader (find-gui :bs1)
                                 (- d1 *beatstep-cc-offs*) (rotary->inc d2)))
                    (progn
                      (handle-ewi-hold-cc ch d1)
                      (funcall (aref *cc-fns* ch d1) d2))))))
         (:note-on
          (let ((ch (status->channel st)))
;;;            (if *midi-debug* (format t "~&note: ~a ~a ~a~%" ch d1 d2))
            (if (and (= ch (player-aref :bs1)) (> d2 0))
                (cond
                   ((<= 44 d1 51) ;;; emulate radio-buttons upper row (1-8)
                    (cuda-gui::emit-signal
                     (aref (cuda-gui::buttons (find-gui :bs1)) (- d1 44)) "setState(int)" d2))
                   ((<= 36 d1 43) ;;; emulate radio-buttons lower row (9-16)
                    (cuda-gui::emit-signal
                     (aref (cuda-gui::buttons (find-gui :bs1)) (- d1 28)) "setState(int)" d2)))
                (funcall (aref *note-fns* ch) d1 d2)) ;;; call registered handler function
;;            (setf (aref *note-states* ch) d1) ;;; memorize last keynum of device
            ))
         (:note-off
          (let ((ch (status->channel st)))
;;;            (if *midi-debug* (format t "~&note: ~a ~a ~a~%" ch d1 d2))
            (if (and (= ch (player-aref :bs1)) (> d2 0))
                (cond
                   ((<= 44 d1 51) ;;; emulate radio-buttons upper row (1-8)
                    (progn
                      (cuda-gui::gui-funcall
                       (cuda-gui::set-state
                        (aref (cuda-gui::buttons (find-gui :bs1)) (- d1 44)) 0))
                      (sleep 0.01)))
                   ((<= 36 d1 43) ;;; emulate radio-buttons lower row (9-16)
                    (progn
                      (cuda-gui::gui-funcall
                       (cuda-gui::set-state
                        (aref (cuda-gui::buttons (find-gui :bs1)) (- d1 28)) 0))
                      (sleep 0.01))))
                (funcall (aref *note-fns* ch) d1 d2)) ;;; call registered handler function
;;            (setf (aref *note-states* ch) d1) ;;; memorize last keynum of device
            ))))
     *midi-in1*
     :format :raw))

|#



;;; (funcall (note-on *midi-out1* 36 0 5))

(defclass nanokontrol2 (midi-controller) ())

(defmethod initialize-instance :after ((instance nanokontrol2) &rest args)
  (unless (getf args :cc-map)
    (setf (cc-map instance)
          (get-inverse-lookup-array
           '(16 17 18 19 20 21 22 23
              0  1  2  3  4  5  6  7)))))

;;; (make-instance 'nanokontrol2)



;;; (init-beatstep-gui-callbacks :bs1)



;;; (gui (find-controller :bs1))

