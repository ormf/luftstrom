;;; 
;;; joystick-tablet.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2020 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
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

(defclass joystick-tablet (osc-controller)
  ((osc-in :initarg :osc-in :initform nil :accessor osc-in)
   (osc-out :initarg :osc-out :initform nil :accessor osc-out)
   (reverse-ip :initarg :reverse-ip :initform nil :accessor reverse-ip)
   (reverse-port :initarg :reverse-port :initform 3089 :accessor reverse-port)
   (player-idx :initarg :player-idx :initform 0 :accessor player-idx)
   (o-pos :initarg :o-pos :initform (make-instance 'value-cell :val '(0.5 0.5)) :accessor o-pos)
   (xy :initarg :xy :initform
       (make-array 2 :element-type 'value-cell :initial-contents
                   (loop for idx below 2 collect (make-instance 'value-cell)))
       :accessor xy)
   (o-type :initarg :o-type :initform (make-instance 'value-cell) :accessor o-type)
   (o-brightness :initarg :o-brightness :initform (make-instance 'value-cell) :accessor o-brightness)
   (o-active :initarg :o-active :initform (make-instance 'value-cell) :accessor o-active)
   (presets :initarg :presets
            :initform (make-array 16 :element-type 'single-float :initial-element 0.0)
            :accessor presets)
   (curr-audio-preset :initarg :curr-audio-preset :initform (make-instance 'value-cell) :accessor curr-audio-preset)
   (cp-audio :initarg :cp-audio :initform t :accessor cp-audio)
   (cp-boids :initarg :cp-boids :initform nil :accessor cp-boids)
   (rec-state :initarg :rec-state :initform nil :accessor rec-state)
   (copy-state :initarg :copy-state :initform 0 :accessor copy-state)
   (copy-src :initarg :copy-src :initform 0 :accessor copy-src)
   (bank :initarg :bank :initform 0 :accessor bank)
   (tracking :initarg :tracking :initform t :accessor tracking)))

;;; (remove-osc-controller :tab1)

(defmethod osc-save-in ((instance joystick-tablet))
  "react to Save button press on tablet."
  (with-slots (osc-in osc-out copy-state rec-state) instance
    (make-osc-responder
     osc-in (format nil "/saveState/~S" (id instance)) "f"
     (lambda (state)
       (with-debugging
         (format t "~&tablet save-button in: ~S ~a~%" (id instance) state))
       (with-slots (osc-in osc-out copy-state rec-state) instance
         (unless (zerop copy-state)
           (setf copy-state 0)
           (if osc-out ;;; turn off Copy button
               (incudine.osc:message
                osc-out
                "/copyState" "f" 0.0)))
         (setf rec-state (not (zerop state))))))))

(defmethod osc-copy-in ((instance joystick-tablet))
  "react to Copy button press on tablet."
  (with-slots (osc-in osc-out copy-state rec-state) instance
    (make-osc-responder
     osc-in (format nil "/copyState/~S" (id instance)) "f"
     (lambda (state)
       (with-debugging
         (format t "~&tablet copy-button in: ~S ~a~%" (id instance) state))
       (with-slots (osc-in osc-out copy-state rec-state) instance
         (if rec-state (progn
                         (setf rec-state nil)
                         (if osc-out ;;; turn off Save button
                             (incudine.osc:message
                              osc-out
                              "/saveState" "f" 0.0))))
         (setf copy-state state))))))


(defun xy-control-in (instance)
  "react to right xy slider on tablet."
  (with-slots (osc-in osc-out copy-state rec-state tracking xy) instance
    (make-osc-responder
     osc-in (format nil "/xyCtl/~S" (id instance)) "ff"
     (lambda (x y)
       (with-debugging
         (format t "~&tablet xyCtl in: ~S ~,2f ~,2f~%" (id instance) x y))
       (loop
         for val-slot across xy
         for val = x then y
         do (when (/= val (val val-slot))
              (setf (slot-value val-slot 'val) val)
              (when (cellctl::ref val-slot)
                (set-cell (cellctl::ref val-slot)
                          (funcall (map-fn val-slot) val)
                          :src val-slot))))))))

(defun xy-control-out (instance)
  "set right xy slider on tablet."
  (lambda (x)
    (declare (ignore x))
    (with-slots (osc-in osc-out copy-state rec-state tracking) instance
      (with-slots (xy) instance
        (if (osc-out instance)
            (incudine.osc:message
             (osc-out instance)
             "/xyCtl" "ff" (float (val (aref xy 0))) (float (val (aref xy 1)))))))))

(defun btn-2-in (instance)
  "react to toggle 2 on tablet."
  (with-slots (osc-in player-idx) instance
    (make-osc-responder
     osc-in (format nil "/aprTgl2/~S" (id instance)) "f"
     (lambda (val)
       (with-debugging
         (format t "~&tablet button 2 in: ~S ~,2f~%" (id instance) val))
       (set-ref (aref (slot-value instance 'xy) 0)
               (aref *audio-preset-ctl-model* (+ (ash (1+ player-idx) 4) (round val)))
               :map-fn #'ntom
               :rmap-fn #'mton)))))

(defun btn-2-out (instance val)
  "set apr toggle 2 on tablet."
  (if (osc-out instance)
      (incudine.osc:message
       (osc-out instance)
       "/aprTgl2" "f" (if val 1.0 0.0))))

(defun tracking-in (instance)
  "react to tracking toggle on tablet."
  (with-slots (osc-in osc-out copy-state rec-state tracking) instance
    (make-osc-responder
     osc-in (format nil "/aprTgl1/~S" (id instance)) "f"
     (lambda (val)
       (with-debugging
         (format t "~&tablet tracking in: ~S ~,2f~%" (id instance) val))
       (setf tracking (> val 0))))))

(defun tracking-out (instance val)
  "set apr toggle 1 on tablet."
  (if (osc-out instance)
      (incudine.osc:message
       (osc-out instance)
       "/aprTgl1" "f" (if val 1.0 0.0))))

(defmethod tilts-in ((instance joystick-tablet))
  "react to tilts on tablet."
  (with-slots (osc-in osc-out copy-state rec-state) instance
    (make-osc-responder
     osc-in (format nil "/tilts/~S" (id instance)) "f"
     (lambda (val)
       (with-debugging
         (format t "~&tablet tilts in: ~S ~,2f~%" (id instance) val))))))

(defmethod accel-in ((instance joystick-tablet))
  "react to accel on tablet."
  (with-slots (osc-in osc-out copy-state rec-state) instance
    (make-osc-responder
     osc-in (format nil "/accel/~S" (id instance)) "fff"
     (lambda (x y z)
       (with-debugging
         (format t "~&tablet accel in: ~S ~,2f ~,2f ~,2f~%" (id instance) x y z))))))

(defmethod gyro-in ((instance joystick-tablet))
  "react to gyro on tablet."
  (with-slots (osc-in osc-out copy-state rec-state) instance
    (make-osc-responder
     osc-in (format nil "/gyro/~S" (id instance)) "fff"
     (lambda (around-roll pitch yaw)
       (with-debugging
         (format t "~&tablet gyro in: ~S roll: ~,2f pitch: ~,2f yaw: ~,2f~%" (id instance) around-roll pitch yaw))))))

(defmethod motion-in ((instance joystick-tablet))
  "react to motion on tablet."
  (with-slots (osc-in osc-out copy-state rec-state player-idx tracking) instance
    (make-osc-responder
     osc-in (format nil "/motion/~S" (id instance)) "fff"
     (lambda (roll pitch yaw)
       (when tracking
         (with-debugging
           (format t "~&tablet motion in: ~S roll: ~,2f pitch: ~,2f yaw: ~,2f~%" (id instance) roll pitch (mod (+ 0.5 (/ (+ pi yaw) (* -2 pi))) 1.0)))
         (let ((cc-offset (ash (1+ player-idx) 4)))
           (set-cell (aref *audio-preset-ctl-model* (+ cc-offset 2)) (ntom (motion-n roll)))
           (set-cell (aref *audio-preset-ctl-model* (+ cc-offset 3)) (ntom (motion-n pitch)))
           (set-cell (aref *audio-preset-ctl-model* (+ cc-offset 4)) (ntom (mod (/ (+ yaw pi) (* -1 pi)) 1.0)))))))))

(declaim (inline motion-n))
(defun motion-n (val)
  (float (/ (+ 1 (clip val -1 1)) 2)))

(defun bank-button-in (instance)
  "react to incoming bank button press."
  (with-slots (osc-in id osc-out bank) instance
    (make-osc-responder
     osc-in
     (format nil "/bankBtn/~S" id) "f"
     (lambda (val)
       (when (> val 0)
         (with-debugging
           (format t "~&bank-button-in: ~S ~%" id))
         (setf bank (if (zerop bank) 1 0))
         (dotimes (col 8)
           (incudine.osc:message
            osc-out
            (format nil "/buttonLbl") "is" col (format nil "~d" (+ col (* 8 bank) 1))))
         (bs-presets-change-handler instance))))))

(defmethod osc-bs-preset-in ((instance joystick-tablet))
  "react to press of preset button press on tablet."
  (with-slots (osc-in bank) instance
    (make-osc-responder
     osc-in (format nil "/recallPresetGrid/~S" (id instance)) "fff"
     (lambda (col row val)
       (with-debugging
         (format t "~&tablet preset button in: ~S ~a ~a ~a~%" (id instance) row col val))
       (if (= val 1.0)
           (bs-preset-button-handler instance (round (+ (* 8 bank) col))))))))

#|
(defmethod set-sliders ((instance joystick-tablet))
  "set all sliders (used on (re)initialization)."
  (with-slots (osc-out sliders) instance
    (when osc-out
      (dotimes (idx 16)
        (let ((val (val (aref sliders idx))))
          (with-debugging
            (format t "~&slider-out: ~S ~a ~a~%" (id instance) (float idx) val))
          (incudine.osc:message
           osc-out
           "/slider" "ff" (float idx) (float val)))))))
|#

(defmethod osc-reinit-in ((instance joystick-tablet))
  "react to incoming reinit message."
  (make-osc-responder
   (osc-in instance) (format nil "/reInit/~S" (id instance)) ""
   (lambda ()
     (with-debugging
       (format t "~&reInit: ~S" (id instance)))
     (with-slots (id player-idx bank cp-audio cp-boids osc-out
                  curr-audio-preset o-pos o-active o-type o-brightness
                  tracking)
         instance
       (tablet-id-out instance)
       (incudine.osc:message
        osc-out
        "/playerIdx" "f" (float player-idx))
       (funcall (osc-o-pos-out instance) (val o-pos))
       (funcall (audio-preset-no-out instance) (val curr-audio-preset))
       (funcall (osc-o-active-out instance) (val o-active))
;;       (funcall (osc-o-brightness-out instance) (val o-brightness))
       (funcall (osc-o-type-out instance) (val o-type))
       (tracking-out instance tracking)
       (cp-audio-out instance cp-audio)
       (cp-boids-out instance cp-boids)
       (dotimes (col 8)
         (incudine.osc:message
          osc-out
          (format nil "/buttonLbl") "is" col (format nil "~d" (+ col (* 8 bank) 1))))
       (bs-presets-change-handler instance)
;;;       (set-sliders instance)
       ))))

(defmethod register-osc-responders ((instance joystick-tablet))
  (with-slots (osc-out responders) instance
    (format t "~&registering joystick tablet responders for player ~d at ~a~%"
            (1+ (player-idx instance)) osc-out)
    (dolist (fn (list #'osc-o-pos-in #'osc-o-active-in #'osc-o-brightness-in #'osc-o-type-in
                      #'bank-button-in #'osc-save-in #'osc-copy-in
                      #'cp-audio-in #'cp-boids-in
                      #'btn-2-in
                      #'osc-reinit-in
                      #'osc-bs-preset-in
                      #'prev-audio-preset-in #'next-audio-preset-in
                      #'player-idx-in
                      #'motion-in
                      #'tilts-in
                      #'tracking-in
                      #'xy-control-in
;;                      #'accel-in
;;                      #'gyro-in
                      ))
      (push (funcall fn instance) responders))))

(defmethod set-hooks ((instance joystick-tablet))
  (setf (ref-set-hook (slot-value instance 'o-pos))
        (osc-o-pos-out instance))
  (setf (ref-set-hook (slot-value instance 'o-active))
        (osc-o-active-out instance))
  (setf (ref-set-hook (aref (slot-value instance 'xy) 1))
        (xy-control-out instance))
  (setf (ref-set-hook (slot-value instance 'o-type))
        (osc-o-type-out instance))
  (setf (ref-set-hook (slot-value instance 'curr-audio-preset))
        (audio-preset-no-out instance)))

(defmethod set-refs ((instance joystick-tablet))
  (with-slots (player-idx) instance
    (let ((cc-offset (ash (1+ player-idx) 4)))
      (set-ref (slot-value instance 'o-pos)
               (slot-value (aref *obstacles* player-idx) 'pos))
      (set-ref (slot-value instance 'o-active)
               (slot-value (aref *obstacles* player-idx) 'active))
      (set-ref (slot-value instance 'o-brightness)
               (slot-value (aref *obstacles* player-idx) 'brightness))
      (set-ref (slot-value instance 'o-type)
               (slot-value (aref *obstacles* player-idx) 'type)
               :map-fn #'map-type
               :rmap-fn #'map-type)
      (set-ref (slot-value instance 'curr-audio-preset)
               (slot-value *bp* (string->symbol (format nil "pl~d-apr" (1+ player-idx))
                                                :cl-boids-gpu)))
      (set-ref (aref (slot-value instance 'xy) 0)
               (aref *audio-preset-ctl-model* (+ cc-offset 0))
               :map-fn #'ntom
               :rmap-fn #'mton)
      (set-ref (aref (slot-value instance 'xy) 1)
               (slot-value (aref *obstacles* player-idx) 'brightness))
      (switch-player player-idx instance)
      (register-bs-presets-change-handler instance *bp*))))

(defmethod clear-refs ((instance joystick-tablet))
  (set-ref (slot-value instance 'o-pos) nil)
  (set-ref (slot-value instance 'o-active) nil)
  (set-ref (slot-value instance 'o-brightness) nil)
  (set-ref (slot-value instance 'o-type) nil)
  (set-ref (slot-value instance 'curr-audio-preset) nil)
  (loop for slot across (slot-value instance 'xy) do (set-ref slot nil))
  (unregister-bs-presets-change-handler instance *bp*))

(defmethod init-controller ((instance joystick-tablet) &rest args)
  (declare (ignorable args))
  (with-slots (reverse-ip) instance
    (clear-refs instance)
    (if reverse-ip
        (save-config-on-tablet instance))
    (reconnect-tablet instance)
    (set-hooks instance)
    (set-refs instance)
;;    (set-sliders instance)
    ))

(defmethod initialize-instance :after ((instance joystick-tablet) &rest args)
  (declare (ignore args))
  (init-controller instance)
  (tablet-id-out instance))

(defmethod switch-player (player (instance joystick-tablet))
  "update the references of the Sliders to the current player's cc-state."
  (let ((cc-offs (ash (1+ player) 4)))
    (dotimes (idx 16)
      (with-debugging
        (format t "~&idx: ~a, ccidx: ~a" idx (+ cc-offs idx))))
    (bs-presets-change-handler instance)))

(defmethod blink ((instance joystick-tablet) idx)
  "start blinking of preset button at idx until copy-state of instance
is zero."
  (with-slots (osc-out copy-state) instance
    (let ((state t)) ;;; state is closed around labels
      (labels ((inner (time)
                 (if (zerop copy-state) ;;; stop blinking?
                     (bs-presets-change-handler instance) ;;; yes: update all preset buttons
                     (let ((next (+ time 0.5))) ;;; no: change state of src preset button and recurse.
                       (incudine.osc:message
                        osc-out
                        "/recallPresetState" "ff" (float idx)
                        (if (setf state (not state)) 1.0 0.0)) 
                       (at next #'inner next)))))
        (when osc-out (inner (now)))))))

(defmethod preset-displayed? (preset (instance joystick-tablet))
  (let ((min-preset (ash (player-idx instance) 4)))
    (<= min-preset preset (+ min-preset 15))))

(defmethod bs-presets-change-handler ((instance joystick-tablet) &optional changed-preset)
  (format t "preset-change-handler ~S~%" (id instance))
  (if (or (not changed-preset)
           (preset-displayed? changed-preset instance))
      (with-slots (osc-out player-idx cp-audio cp-boids bank) instance
        (dotimes (idx 8)
          (let ((cc-offset (+ (* bank 8) (ash (1+ player-idx) 4))))
            (when osc-out
              (with-debugging
                (format t "~&recallPresetState: ~S ~a~%" (id instance) idx)

                )
              (incudine.osc:message
               osc-out
               "/recallPresetState" "ff" (float idx)
               (if (bs-preset-empty?
                    (+ idx cc-offset)
                    :load-obstacles nil
                    :load-audio cp-audio
                    :load-boids cp-boids
                    :player-idx-or-key (1+ player-idx))
                   0.0 1.0))))))))


(defmethod bs-preset-button-handler ((instance joystick-tablet) idx)
  (with-slots (osc-out player-idx rec-state copy-state copy-src
               cp-obstacle cp-audio cp-boids)
      instance
    (let* ((bs-idx (+ idx (ash (1+ player-idx) 4))))
      (cond
        ((= copy-state 1) ;;; copying: setting copy-src
         (incf copy-state)
         (setf copy-src bs-idx)
         (blink instance idx))
        ((= copy-state 2) ;;; copying: cp-dest pressed
         (format t "cp-state=2~%")
         (setf copy-state 0) ;;; reset state, stop blink
         (bs-state-copy copy-src bs-idx
                        :cp-obstacles nil
                        :cp-audio cp-audio
                        :cp-boids cp-boids)
         (if osc-out
             (incudine.osc:message
              osc-out
              "/copyState" "f" 0.0))) ;;; turn off Copy button.
        (rec-state                    ;;; saving: save-dest pressed
         (bs-state-save
          bs-idx
          :save-obstacles nil
          :save-audio cp-audio
          :save-boids cp-boids)
         (setf rec-state nil)
         (if osc-out
             (incudine.osc:message
              osc-out
              "/saveState" "f" 0.0))) ;;; turn off Save button
        (t (bs-state-recall
            bs-idx
            :players-to-recall (reverse
                                (cons (player-name (1+ player-idx))
                                      (if cp-boids '(:auto))))
            :load-obstacles nil
            :load-audio  cp-audio
            :load-boids cp-boids))))))

