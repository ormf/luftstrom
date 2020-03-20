;;; 
;;; one-player-ctl-tablet.lisp
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

(defun parse-ip (ip)
  (mapcar #'read-from-string (uiop:split-string ip :separator ".")))


(defparameter *one-player-ctl-tablet* nil)

(defclass one-player-ctl-tablet (osc-controller)
  ((osc-in :initarg :osc-in :initform nil :accessor osc-in)
   (osc-out :initarg :osc-out :initform nil :accessor osc-out)
   (reverse-ip :initarg :reverse-ip :initform nil :accessor reverse-ip)
   (reverse-port :initarg :reverse-port :initform 3089 :accessor reverse-port)
   (player-idx :initarg :player-idx :initform 0 :accessor player-idx)
   (o-pos :initarg :o-pos :initform (make-instance 'value-cell :val '(0.5 0.5)) :accessor o-pos)
   (o-type :initarg :o-type :initform (make-instance 'value-cell) :accessor o-type)
   (o-brightness :initarg :o-brightness :initform (make-instance 'value-cell) :accessor o-brightness)
   (o-active :initarg :o-active :initform (make-instance 'value-cell) :accessor o-active)
   (sliders :initarg :sliders
            :initform (make-array 16 :element-type 'value-cell :initial-contents
                                  (loop for idx below 16 collect (make-instance 'value-cell)))
            :accessor sliders)
   (presets :initarg :presets
            :initform (make-array 16 :element-type 'single-float :initial-element 0.0)
            :accessor presets)
   (cp-obstacles :initarg :cp-obstacles :initform nil :accessor cp-obstacles)
   (cp-audio :initarg :cp-audio :initform nil :accessor cp-audio)
   (cp-boids :initarg :cp-boids :initform nil :accessor cp-boids)
   (rec-state :initarg :rec-state :initform 0 :accessor rec-state)
   (cp-src :initarg :cp-src :initform 0 :accessor cp-src)
   (curr-audio-preset :initarg :curr-audio-preset :initform (make-instance 'value-cell) :accessor curr-audio-preset)
   ))

;;; (remove-osc-controller :tab1)

(defun osc-o-pos-out (instance)
  "set obstacle position on tablet."
  (lambda (pos)
    (with-debugging
      (format t "~&pos-out:~a" pos))
    (if (osc-out instance)
        (destructuring-bind (x y) pos
          (at (now)
            (lambda ()
              (incudine.osc:message
               (osc-out instance)
               (format nil "/obstPos") "ff" (float x) (float y))))))))

(defun osc-o-pos-in (instance)
  "react to incoming pos of player."
  (let ((pos-slot
          (slot-value instance 'o-pos)))
    (make-osc-responder (osc-in instance) "/obstPos" "ff"
                        (lambda (x y)
                          (let ((pos `(,x ,y)))
                            (with-debugging
                              (format t "~&pos-in: ~a" (list x y)))
                            (setf (slot-value pos-slot 'val) pos)
                            (set-cell (cellctl::ref pos-slot)
                                      (funcall (map-fn pos-slot) pos) :src pos-slot))))))

(defun osc-o-active-out (instance)
  "control obstacle active toggle on tablet."
  (lambda (active)
    (if (osc-out instance)
        (incudine.osc:message
         (osc-out instance)
         "/obstActive" "f" (float (if active 1 0))))))

(defun osc-o-active-in (instance)
  "react to incoming activation info of player."
  (let ((active-slot
          (slot-value instance 'o-active)))
    (make-osc-responder (osc-in instance) "/obstActive" "f"
                        (lambda (active)
                          (let ((state (not (zerop active))))
                            (with-debugging
                              (format t "active: ~a (not (zerop active)): ~a" active (not (zerop active))))
                            (setf (slot-value active-slot 'val) state)
                            (set-cell (cellctl::ref active-slot) (funcall (map-fn active-slot) state)
                                      :src active-slot))))))

(defun osc-o-brightness-out (instance)
  "control obstacle brightness on tablet."
  (lambda (brightness)
    (if (osc-out instance)
        (incudine.osc:message
         (osc-out instance)
         "/obstVolume" "f" (float (funcall (n-lin-rev-fn 0.2 1) brightness))))))

(defun osc-o-brightness-in (instance)
  "react to incoming brightness of player obstacle."
  (let ((brightness-slot
          (slot-value instance 'o-brightness)))
    (make-osc-responder
     (osc-in instance) "/obstVolume" "f"
     (lambda (brightness)
       (with-debugging
         (format t "~&brightness: ~a, ~a" brightness (funcall (n-lin-rev-fn 0.2 1) brightness)))
       (setf (slot-value brightness-slot 'val) brightness)
       (set-cell (cellctl::ref brightness-slot) (funcall (map-fn brightness-slot) brightness)
                 :src brightness-slot)))))

(defun osc-o-type-out (instance)
  "control obstacle type on tablet."
  (lambda (type)
    (if (osc-out instance)
        (incudine.osc:message
         (osc-out instance)
         "/obstType" "f" (float type)))))

(defun audio-preset-no-out (instance)
  "control audio preset num on tablet."
  (lambda (val)
    (if (osc-out instance)
        (incudine.osc:message
         (osc-out instance)
         "/presetNo" "f" (float val)))))

(defun cp-obstacle-out (instance)
  "control audio preset num on tablet."
  (lambda (val)
    (if (osc-out instance)
        (incudine.osc:message
         (osc-out instance)
         "/cpObstacle" "f" (float val)))))

(defun cp-audio-out (instance)
  "control audio preset num on tablet."
  (lambda (val)
    (if (osc-out instance)
        (incudine.osc:message
         (osc-out instance)
         "/cpAudio" "f" (float val)))))

(defun cp-boids-out (instance)
  "control audio preset num on tablet."
  (lambda (val)
    (if (osc-out instance)
        (incudine.osc:message
         (osc-out instance)
         "/cpBoids" "f" (float val)))))

(defun slider-in (instance idx)
  "control audio preset num on tablet."
  (with-slots (osc-in sliders) instance
    (with-debugging
      (format t "~&registering osc-slider-responder: /slider~2,'0d~%" idx))
    (make-osc-responder
     osc-in
     (format nil "/slider~2,'0d" idx) "f"
     (lambda (value)
       (let ((slider-slot (aref sliders idx)))
         (with-debugging
           (format t "~&slider-in: ~a ~a~%" idx value))
         (setf (slot-value slider-slot 'val) value)
         (set-cell (cellctl::ref slider-slot) (funcall (map-fn slider-slot) value)
                   :src slider-slot))))))

(defun slider-out (instance idx)
  "control audio preset num on tablet."
  (lambda (val)
    (if (osc-out instance)
        (incudine.osc:message
         (osc-out instance)
         "/slider" "ff" (float idx) (float val)))))

(defun reconnect-tablet (instance)
  "control audio preset num on tablet."
  (if (osc-out instance)
      (incudine.osc:message
       (osc-out instance)
       "/reconnect" "f" 1.0)))

(defun osc-o-type-in (instance)
  "react to incoming type obstacle."
  (let  ((type-slot
           (slot-value instance 'o-type)))
    (make-osc-responder
     (osc-in instance)
     "/obstType" "f"
     (lambda (type)
       (with-debugging
         (format t "~&type-in: ~a~%" type))
       (setf (slot-value type-slot 'val) type)
       (set-cell (cellctl::ref type-slot) (funcall (map-fn type-slot) type)
                 :src type-slot)))))

(defun cp-obstacles-in (instance)
  "react to incoming cp-obstacles flag."
  (make-osc-responder
   (osc-in instance)
   "/cpObstacles" "f"
   (lambda (val)
     (with-debugging
       (format t "~&cp-obstacles-in: ~a~%" val))
     (setf (cp-obstacles instance) (not (zerop val)))
     (bs-presets-change-handler instance))))

(defun cp-audio-in (instance)
  "react to incoming cp-audio flag."
  (make-osc-responder
   (osc-in instance)
   "/cpAudio" "f"
   (lambda (val)
     (with-debugging
       (format t "~&cp-audio-in: ~a~%" val))
     (setf (cp-audio instance) (not (zerop val)))
     (bs-presets-change-handler instance))))

(defun cp-boids-in (instance)
  "react to incoming cp-boids flag."
  (make-osc-responder
   (osc-in instance)
   "/cpBoids" "f"
   (lambda (val)
     (with-debugging
       (format t "~&cp-boids-in: ~a~%" val))
     (setf (cp-boids instance) (not (zerop val)))
     (bs-presets-change-handler instance))))

(defun player-idx-in (instance)
  (with-slots (player-idx) instance
    (make-osc-responder
     (osc-in instance)
     "/playerIdx" "f"
     (lambda (val)
       (with-debugging
         (format t "~&player-idx-in: ~a~%" val))
       (setf player-idx (round val))
       (set-refs instance)))))


(defun prev-audio-preset-in (instance)
  "react to incoming type obstacle."
  (with-slots (osc-in curr-audio-preset player-idx) instance
    (make-osc-responder
     osc-in
     "/prevPreset" "f"
     (lambda (val)
       (when (> val 0)
         (with-debugging
           (format t "~&prev-preset-in~%"))
         (setf (val curr-audio-preset) (max 0 (1- (val curr-audio-preset))))
         ;; (load-audio-preset
         ;;  :no (val curr-audio-preset) :player-ref player-idx)
         )))))

(defun next-audio-preset-in (instance)
  "react to incoming type obstacle."
  (with-slots (osc-in curr-audio-preset player-idx) instance
    (make-osc-responder
     osc-in
     "/nextPreset" "f"
     (lambda (val)
       (when (> val 0)
         (with-debugging
           (format t "~&next-preset-in~%"))
         (setf (val curr-audio-preset) (min 127 (1+ (val curr-audio-preset))))
         ;; (load-audio-preset
         ;;  :no (val curr-audio-preset) :player-ref player-idx)
         )))))


(defmethod register-osc-responders ((instance one-player-ctl-tablet))
  (with-slots (osc-out responders) instance
    (format t "~&registering one-player tablet responders for player ~d at ~a~%"
            (1+ (player-idx instance)) osc-out)
    (dolist (fn (list #'osc-o-pos-in #'osc-o-active-in #'osc-o-brightness-in #'osc-o-type-in
                      #'cp-obstacles-in #'cp-audio-in #'cp-boids-in
                      #'prev-audio-preset-in #'next-audio-preset-in
                      #'player-idx-in))
      (push (funcall fn instance) responders)
      (dotimes (idx 16)
        (push (slider-in instance idx) responders)))))

(defun set-hooks (instance)
  (setf (ref-set-hook (slot-value instance 'o-pos))
        (osc-o-pos-out instance))
  (setf (ref-set-hook (slot-value instance 'o-active))
        (osc-o-active-out instance))
  (setf (ref-set-hook (slot-value instance 'o-brightness))
        (osc-o-brightness-out instance))
  (setf (ref-set-hook (slot-value instance 'o-type))
        (osc-o-type-out instance))
  (setf (ref-set-hook (slot-value instance 'curr-audio-preset))
        (audio-preset-no-out instance))
  (dotimes (idx 16)
    (setf (ref-set-hook (aref (slot-value instance 'sliders) idx))
          (slider-out instance idx))
    )
  )

(defmethod set-refs ((instance one-player-ctl-tablet))
  (with-slots (player-idx) instance
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
    (switch-player player-idx instance)
    (register-bs-presets-change-handler instance *bp*)))

(defmethod clear-refs ((instance one-player-ctl-tablet))
  (set-ref (slot-value instance 'o-pos) nil)
  (set-ref (slot-value instance 'o-active) nil)
  (set-ref (slot-value instance 'o-brightness) nil)
  (set-ref (slot-value instance 'o-type) nil)
  (set-ref (slot-value instance 'curr-audio-preset) nil)
  (dotimes (idx 16)
    (set-ref (aref (sliders instance) idx) nil))
  (unregister-bs-presets-change-handler instance *bp*))

(defgeneric init-controller (instance &rest args)
  (:documentation "(re)init an instance of a controller")
  (:method ((instance one-player-ctl-tablet) &rest args)
    (declare (ignorable args))
    (if (reverse-ip instance)
        (save-config-on-tablet instance))
    (reconnect-tablet instance)))


(defmethod initialize-instance :after ((instance one-player-ctl-tablet) &rest args)
  (declare (ignore args))
  (set-hooks instance)
  (set-refs instance)
  (init-controller instance))


(defun save-config-on-tablet (instance)
  (with-slots (osc-out reverse-ip reverse-port player-idx) instance
    (loop
      for byte in (parse-ip reverse-ip)
      for id from 1
      do (incudine.osc:message
          osc-out
          (format nil "/ipSlider~2,'0d" id) "f" (float byte)))
    (incudine.osc:message
     osc-out
     (format nil "/ipSlider~2,'0d" 5) "f" (float reverse-port))
    (incudine.osc:message
     (osc-out instance)
     "/playerIdx" "f" (float player-idx))
    (incudine.osc:message
     (osc-out instance)
     "/saveConfig" "f" (float 1.0))))

(defmethod switch-player (player (instance one-player-ctl-tablet))
  "update the references of the Sliders to the current player's cc-state."
  (let ((cc-offs (ash (1+ player) 4)))
    (dotimes (idx 16)
      (with-debugging
        (format t "~&idx: ~a, ccidx: ~a" idx (+ cc-offs idx)))
      (set-ref (aref (sliders instance) idx)
               (aref *audio-preset-ctl-model* (+ cc-offs idx))
               :map-fn #'ntom
               :rmap-fn #'mton))
    (bs-presets-change-handler instance)))

(defmethod preset-displayed? (preset (instance one-player-ctl-tablet))
  (let ((min-preset (ash (player-idx instance) 4)))
    (<= min-preset preset (+ min-preset 15))))

(defmethod bs-presets-change-handler ((instance one-player-ctl-tablet) &optional changed-presets)
  (if (or (not changed-presets)
          (some (lambda (preset) (preset-displayed? preset instance)) changed-presets))
      (with-slots (osc-out player-idx cp-obstacles cp-audio cp-boids) instance
        (dotimes (idx 16)
          (let ((cc-offset (ash player-idx 4)))
            (if osc-out
                (incudine.osc:message
                 osc-out
                 "/recallPresetState" "ff" (float idx)
                 (if (bs-preset-empty?
                      (+ idx cc-offset)
                      :load-obstacles cp-obstacles
                      :load-audio cp-audio
                      :load-boids cp-boids)
                     0.0 1.0))))))))


;;; (set-bs-preset-buttons (find-osc-controller :tab-p1))

#|
(defgeneric bs-preset-button-handler (obj cc-num)
  (:documentation "handler to recall bs-presets.")
  (:method ((instance nanokontrol) cc-num)
    (with-slots (cc-map cc-offset chan midi-output rec-state bs-copy-state bs-copy-src
                 bs-cp-obstacles bs-cp-audio bs-cp-boids)
        instance
      (let* ((idx (- (aref cc-map cc-num) 27))
             (bs-idx (+ idx cc-offset)))
                                        ;      (break "bs-preset-button-handler")
        (cond
          ((= bs-copy-state 1) ;;; copying: setting cp-src
           (incf bs-copy-state)
           (setf bs-copy-src bs-idx)
           (blink instance cc-num))
          ((= bs-copy-state 2)
           ;;; copying: cp-dest pressed
           (setf bs-copy-state 0) ;;; reset state, stop blink
           (bs-state-copy bs-copy-src bs-idx
                          :cp-obstacles (val bs-cp-obstacles)
                          :cp-audio (val bs-cp-audio)
                          :cp-boids (val bs-cp-boids))
           (funcall (ctl-out midi-output 41 0 chan)) ;;; turn off play button.
           (set-bs-preset-buttons instance) ;;; update button lights.
           )
          (rec-state
           (bs-state-save
            bs-idx
            :save-obstacles (val bs-cp-obstacles)
            :save-audio (val bs-cp-audio)
            :save-boids (val bs-cp-boids))
           (setf rec-state nil)
           (funcall (ctl-out midi-output 45 0 chan))
           (set-bs-preset-buttons instance))
          (t (bs-state-recall
              bs-idx
              :players-to-recall '(:auto)
              :load-obstacles (val bs-cp-obstacles)
              :load-audio  (val bs-cp-audio)
              :load-boids (val bs-cp-boids))))))))

      (:cc (cond
             ((or (<= 0 d1 7) (<= 16 d1 23))
              (cuda-gui::handle-cc-in
               gui
               (aref cc-map d1) ;;; idx of numbox in gui
               d2))
             ;;; transport-controls
             ((= d1 58) (if (= d2 127) (cl-boids-gpu::add-remove-boids t))) ;;; upper <-
             ((= d1 59) (if (= d2 127) (cl-boids-gpu::add-remove-boids nil)))     ;;; upper ->
             ((= d1 46) (if (= d2 127) (cl-boids-gpu::reshuffle-life cl-boids-gpu::*win* :regular nil))) ;;;; cycle button
             ((= d1 60) (if (= d2 127) (progn
                                         (scratch::node-free-unprotected)
                                         (incudine:flush-pending)))) ;;; set button
             ((= d1 61) (if (= d2 127) (previous-audio-preset))) ;;; lower <-
             ((= d1 62) (if (= d2 127) (next-audio-preset)))     ;;; lower ->
             ((= d1 43) (toggle-state (bs-cp-obstacles instance))
              (set-bs-preset-buttons instance))       ;;; rewind button
;;             ((= d1 44) (incudine:flush-pending))    ;;; fastfwd button
             ((= d1 44) (toggle-state (bs-cp-audio instance))
              (set-bs-preset-buttons instance))
             ((= d1 42) (toggle-state (bs-cp-boids instance)) ;;; stop button
              (set-bs-preset-buttons instance))
             ((= d1 41) ;;; Play Transport-ctl Button
              (setf bs-copy-state (if (zerop bs-copy-state) 1 0))
              (funcall (ctl-out midi-output d1 (if (zerop bs-copy-state) 0 127) chan)))
             ((= d1 45) ;;; Rec Transport-ctl Button
              (setf rec-state (not rec-state))
              (funcall (ctl-out midi-output d1 (if rec-state 127 0) chan)))
               ;;; S/M Pushbuttons
             ((or (<= 32 d1 39)
                  (<= 48 d1 55))
;;;              (funcall (ctl-out midi-output d1 127 chan))
              (bs-preset-button-handler instance d1))
               ;;; R Pushbuttons
             ((<= 64 d1 71)
              (setf cc-offset (* 16 (- d1 64)))
              (loop for cc from 64 to 71
                    do (funcall (ctl-out midi-output cc (if (= cc d1) 127 0) chan)))
              (set-bs-preset-buttons instance))))
|#
