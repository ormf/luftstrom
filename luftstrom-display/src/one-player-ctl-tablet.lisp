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
   (cp-obstacle :initarg :cp-obstacle :initform nil :accessor cp-obstacle)
   (cp-audio :initarg :cp-audio :initform nil :accessor cp-audio)
   (cp-boids :initarg :cp-boids :initform nil :accessor cp-boids)
   (rec-state :initarg :rec-state :initform nil :accessor rec-state)
   (copy-state :initarg :copy-state :initform 0 :accessor copy-state)
   (copy-src :initarg :copy-src :initform 0 :accessor copy-src)
   (curr-audio-preset :initarg :curr-audio-preset :initform (make-instance 'value-cell) :accessor curr-audio-preset)))

;;; (remove-osc-controller :tab1)

(defun osc-o-pos-out (instance)
  "set obstacle position on tablet."
  (lambda (pos)
    (when (osc-out instance)
      (with-debugging
        (format t "~&pos-out: ~S ~a" (id instance) pos))
      (destructuring-bind (x y) pos
        (at (now)
          (lambda ()
            (incudine.osc:message
             (osc-out instance)
             (format nil "/obstPos") "ff" (float x) (float y))))))))

(defun osc-o-pos-in (instance)
  "react to incoming pos of player."
  (make-osc-responder (osc-in instance) (format nil "/obstPos/~S" (id instance)) "ff"
                      (lambda (x y)
                        (let* ((pos-slot (slot-value instance 'o-pos))
                               (pos `(,x ,y)))
                          ;;                          (break "pos in")
                          (with-debugging
                            (format t "~&pos-in: ~S ~a" (id instance) (list x y)))
                          (setf (slot-value pos-slot 'val) pos)
                          (set-cell (cellctl::ref pos-slot)
                                    (funcall (map-fn pos-slot) pos) :src pos-slot)))))

(defun osc-o-active-out (instance)
  "control obstacle active toggle on tablet."
  (lambda (active)
    (when (osc-out instance)
      (with-debugging
        (format t "~&active-out: ~S ~a" (id instance) active))
      (incudine.osc:message
       (osc-out instance)
       "/obstActive" "f" (float (if active 1 0))))))

(defun osc-o-active-in (instance)
  "react to incoming activation info of player."
  (make-osc-responder (osc-in instance) (format nil "/obstActive/~S" (id instance)) "f"
                      (lambda (active)
                        (let* ((active-slot (slot-value instance 'o-active))
                               (state (not (zerop active))))
                          (with-debugging
                            (format t "active: ~S ~a (not (zerop active)): ~a" (id instance) active (not (zerop active))))
                          (setf (slot-value active-slot 'val) state)
                          (set-cell (cellctl::ref active-slot) (funcall (map-fn active-slot) state)
                                    :src active-slot)))))

(defun osc-o-brightness-in (instance)
  "react to incoming brightness of player obstacle."
  (make-osc-responder
   (osc-in instance) (format nil "/obstVolume/~S" (id instance)) "f"
   (lambda (brightness)
     (with-debugging
       (format t "~&brightness: ~S ~a" (id instance) brightness))
     (let ((brightness-slot (slot-value instance 'o-brightness))
;;           (sl-0-slot (aref (sliders instance) 0))
           )
       (setf (slot-value brightness-slot 'val) brightness)
       (set-cell (cellctl::ref brightness-slot) (funcall (map-fn brightness-slot) brightness)
                 :src brightness-slot)
       ;; (set-cell (cellctl::ref sl-0-slot) (funcall (map-fn sl-0-slot) brightness))
       ))))

(defun osc-o-brightness-out (instance)
  "control obstacle brightness on tablet."
  (lambda (brightness)
    (when (osc-out instance)
        (with-debugging
          (format t "~&brightness-out: ~S ~a" (id instance) brightness))
        (incudine.osc:message
         (osc-out instance)
         "/obstVolume" "f" (float brightness)))))

;;; (funcall (n-lin-rev-fn 0.2 1) brightness)

(defun osc-o-type-out (instance)
  "control obstacle type on tablet."
  (lambda (type)
    (when (osc-out instance)
      (with-debugging
        (format t "~&type-out: ~S ~a" (id instance) type))
        (incudine.osc:message
         (osc-out instance)
         "/obstType" "f" (float type)))))

(defun audio-preset-no-out (instance)
  "control audio preset num on tablet."
  (lambda (val)
    (when (osc-out instance)
      (with-debugging
        (format t "~&preset-no-out: ~S ~a" (id instance) val))
      (incudine.osc:message
       (osc-out instance)
       "/presetNo" "f" (float val)))))

(defun cp-obstacle-out (instance val)
  "set cp obstacle toggle on tablet."
  (when (osc-out instance)
    (with-debugging
      (format t "~&cp-obst-out: ~S ~a" (id instance) (if val 1.0 0.0)))
    (incudine.osc:message
     (osc-out instance)
     "/cpObstacles" "f" (if val 1.0 0.0))))

(defun cp-audio-out (instance val)
  "set cp audio toggle on tablet."
  (when (osc-out instance)
    (with-debugging
      (format t "~&cp-audio-out: ~S ~a" (id instance) (if val 1.0 0.0)))
    (incudine.osc:message
     (osc-out instance)
     "/cpAudio" "f" (if val 1.0 0.0))))

(defun cp-boids-out (instance val)
  "set cp boids toggle on tablet."
  (when (osc-out instance)
    (with-debugging
      (format t "~&cp-boids-out: ~S ~a" (id instance) (if val 1.0 0.0)))
    (incudine.osc:message
     (osc-out instance)
     "/cpBoids" "f" (if val 1.0 0.0))))

(defun tablet-id-out (instance)
  "set id of tablet."
  (when (osc-out instance)
    (with-debugging
      (format t "~&tablet-id-out: ~S" (id instance)))
    (incudine.osc:message
     (osc-out instance)
     "/tabletId" "s" (format nil "~S" (id instance)))))

(defun slider-in (instance idx)
  "control audio preset num on tablet."
  (with-slots (osc-in) instance
    (with-debugging
      (format t "~&registering osc-slider-responder: /slider~2,'0d~%" idx))
    (make-osc-responder
     osc-in
     (format nil "/slider~2,'0d/~S" idx (id instance)) "f"
     (lambda (value)
       (let ((slider-slot (aref (sliders instance) idx)))
         (with-debugging
           (format t "~&slider-in: ~S ~a ~a~%" (id instance) idx value))
         (setf (slot-value slider-slot 'val) value)
         (set-cell (cellctl::ref slider-slot) (funcall (map-fn slider-slot) value)
                   :src slider-slot))))))

(defun slider-out (instance idx)
  "control param slider on tablet."
  (with-slots (osc-out) instance
    (lambda (val)
      (when osc-out
          (with-debugging
            (format t "~&slider-out: ~S ~a ~a~%" (id instance) (float idx) val))
          (incudine.osc:message
           osc-out
           "/slider" "ff" (float idx) (float val))))))

(defun reconnect-tablet (instance)
  (if (osc-out instance)
      (incudine.osc:message
       (osc-out instance)
       "/reconnect" "f" 1.0)))

(defun osc-o-type-in (instance)
  "react to incoming type obstacle."
    (make-osc-responder
     (osc-in instance)
     (format nil "/obstType/~S" (id instance)) "f"
     (lambda (type)
       (with-debugging
         (format t "~&type-in: ~S ~a~%" (id instance) type))
       (let  ((type-slot (slot-value instance 'o-type)))
         (setf (slot-value type-slot 'val) type)
         (set-cell (cellctl::ref type-slot) (funcall (map-fn type-slot) type)
                   :src type-slot)))))

(defun cp-obstacle-in (instance)
  "react to incoming cp-obstacle flag."
  (make-osc-responder
   (osc-in instance)
   (format nil "/cpObstacles/~S" (id instance)) "f"
   (lambda (val)
     (with-debugging
       (format t "~&cp-obstacle-in: ~S ~a~%" (id instance) val))
     (setf (cp-obstacle instance) (not (zerop val)))
     (bs-presets-change-handler instance))))

(defun cp-audio-in (instance)
  "react to incoming cp-audio flag."
  (make-osc-responder
   (osc-in instance)
   (format nil "/cpAudio/~S" (id instance)) "f"
   (lambda (val)
     (with-debugging
       (format t "~&cp-audio-in: ~S ~a~%" (id instance) val))
     (setf (cp-audio instance) (not (zerop val)))
     (bs-presets-change-handler instance))))

(defun cp-boids-in (instance)
  "react to incoming cp-boids flag."
  (make-osc-responder
   (osc-in instance)
   (format nil "/cpBoids/~S" (id instance)) "f"
   (lambda (val)
     (with-debugging
       (format t "~&cp-boids-in: ~S ~a~%" (id instance) val))
     (setf (cp-boids instance) (not (zerop val)))
     (bs-presets-change-handler instance))))

(defun player-idx-in (instance)
    (make-osc-responder
     (osc-in instance)
     (format nil "/playerIdx/~S" (id instance)) "f"
     (lambda (val)
       (with-debugging
         (format t "~&player-idx-in: ~S ~a~%" (id instance) val))
       (setf (player-idx instance) (round val))
       (set-refs instance))))

(defun prev-audio-preset-in (instance)
  "react to prev-preset button."
  (with-slots (osc-in curr-audio-preset player-idx) instance
    (make-osc-responder
     osc-in
     (format nil "/prevPreset/~S" (id instance)) "f"
     (lambda (val)
       (when (> val 0)
         (with-debugging
           (format t "~&prev-preset-in: ~S~%" (id instance)))
         (with-slots (curr-audio-preset o-brightness sliders) instance
           (setf (val curr-audio-preset) (max 0 (1- (val curr-audio-preset))))
           ;; (let ((sl-0-slot (aref sliders 0)))
           ;;   (set-cell (cellctl::ref sl-0-slot) (funcall (map-fn sl-0-slot) (val o-brightness))))
           ))))))

(defun next-audio-preset-in (instance)
  "react to next-preset button."
  (with-slots (osc-in curr-audio-preset) instance
    (make-osc-responder
     osc-in
     (format nil "/nextPreset/~S" (id instance)) "f"
     (lambda (val)
       (when (> val 0)
         (with-debugging
           (format t "~&next-preset-in ~S~%" (id instance)))
         (with-slots (curr-audio-preset o-brightness sliders) instance
           (setf (val curr-audio-preset) (min 127 (1+ (val curr-audio-preset))))
           ;; (let ((sl-0-slot (aref sliders 0)))
           ;;   (set-cell (cellctl::ref sl-0-slot) (funcall (map-fn sl-0-slot) (val o-brightness))))
           ))))))


(defgeneric shake-in (instance))
(defgeneric accel-in (instance))
(defgeneric gyro-in (instance))
(defgeneric motion-in (instance))

(defgeneric osc-save-in (instance))

(defmethod osc-save-in ((instance one-player-ctl-tablet))
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

(defgeneric osc-copy-in (instance))

(defmethod osc-copy-in ((instance one-player-ctl-tablet))
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


(defgeneric osc-bs-preset-in (instance))

(defmethod osc-bs-preset-in ((instance one-player-ctl-tablet))
  "react to press of preset button press on tablet."
  (with-slots (osc-in) instance
    (make-osc-responder
     osc-in (format nil "/recallPresetGrid/~S" (id instance)) "fff"
     (lambda (col row val)
       (with-debugging
         (format t "~&tablet preset-button in: ~S ~a ~a ~a~%" (id instance) row col val))
       (if (= val 1.0)
           (bs-preset-button-handler instance (round col)))))))

(defgeneric osc-reinit-in (instance))

(defmethod osc-reinit-in ((instance one-player-ctl-tablet))
  "react to incoming reinit message."
  (make-osc-responder
   (osc-in instance) (format nil "/reInit/~S" (id instance)) ""
   (lambda ()
     (with-debugging
       (format t "~&reInit: ~S" (id instance)))
     (with-slots (id player-idx cp-audio cp-boids cp-obstacle
                  curr-audio-preset o-pos o-active o-type o-brightness rec-state)
         instance
       (tablet-id-out instance)
       (incudine.osc:message
        (osc-out instance)
        "/playerIdx" "f" (float player-idx))
       (funcall (osc-o-pos-out instance) (val o-pos))
       (funcall (audio-preset-no-out instance) (val curr-audio-preset))
       (funcall (osc-o-active-out instance) (val o-active))
       (funcall (osc-o-brightness-out instance) (val o-brightness))
       (funcall (osc-o-type-out instance) (val o-type))
       (cp-obstacle-out instance cp-obstacle)
       (cp-audio-out instance cp-audio)
       (cp-boids-out instance cp-boids)
       (bs-presets-change-handler instance)
       (setf rec-state 0)
       (set-sliders instance)))))


(defmethod register-osc-responders ((instance one-player-ctl-tablet))
  (with-slots (osc-out responders) instance
    (format t "~&registering one-player tablet responders for player ~d at ~a~%"
            (1+ (player-idx instance)) osc-out)
    (dolist (fn (list #'osc-o-pos-in #'osc-o-active-in #'osc-o-brightness-in #'osc-o-type-in
                      #'cp-obstacle-in #'cp-audio-in #'cp-boids-in #'osc-reinit-in
                      #'osc-save-in #'osc-copy-in
                      #'osc-bs-preset-in
                      #'prev-audio-preset-in #'next-audio-preset-in
                      #'player-idx-in))
      (push (funcall fn instance) responders))
    (dotimes (idx 16)
      (push (slider-in instance idx) responders))))

(defgeneric set-hooks (instance))

(defmethod set-hooks ((instance one-player-ctl-tablet))
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
          (slider-out instance idx))))

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

(defmethod set-sliders ((instance one-player-ctl-tablet))
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
    (with-slots (reverse-ip cp-obstacle cp-audio cp-boids) instance
      (clear-refs instance)
      (if reverse-ip
          (save-config-on-tablet instance))
      (reconnect-tablet instance)
      (cp-obstacle-out instance cp-obstacle)
      (cp-audio-out instance cp-audio)
      (cp-boids-out instance cp-boids)
      (set-hooks instance)
      (set-refs instance)
      (set-sliders instance))))

(defmethod initialize-instance :after ((instance one-player-ctl-tablet) &rest args)
  (declare (ignore args))
  (init-controller instance)
  (tablet-id-out instance))

(defun save-config-on-tablet (instance)
  (with-slots (osc-out reverse-ip reverse-port player-idx) instance
    (loop
      for byte in (parse-ip reverse-ip)
      for id from 1
      do (progn
           (with-debugging
             (format t "/ipSlider~2,'0d ~S ~a~%" id (id instance) (float byte)))
           (incudine.osc:message
               osc-out
               (format nil "/ipSlider~2,'0d" id) "f" (float byte))))
    (with-debugging
      (format t "/ipSlider~2,'0d ~S ~a~%" 5 (id instance) (float reverse-port)))
    (incudine.osc:message
     osc-out
     (format nil "/ipSlider~2,'0d" 5) "f" (float reverse-port))
    (with-debugging
      (format t "playerIdx: ~S ~a~%" (id instance) (float player-idx)))
    (incudine.osc:message
     (osc-out instance)
     "/playerIdx" "f" (float player-idx))
    (with-debugging
      (format t "tabletId: ~S ~S~%" (id instance) (id instance)))
    (incudine.osc:message
     (osc-out instance)
     "/tabletId" "s" (format nil "~S" (id instance)))
    (with-debugging
      (format t "saveConfig: ~S~%" (id instance)))
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

(defmethod blink ((instance one-player-ctl-tablet) idx)
  "start blinking of preset button at idx until copy-state of instance
is zero."
  (with-slots (osc-out copy-state) instance
    (let ((state t)) ;;; state is closed around labels
      (labels ((inner (time)
                 (if (zerop copy-state) ;;; stop blinking?
                     (bs-presets-change-handler instance);;; yes: update all preset buttons
                     (let ((next (+ time 0.5))) ;;; no: change state of src preset button and recurse.
                       (incudine.osc:message
                        osc-out
                        "/recallPresetState" "ff" (float idx)
                        (if (setf state (not state)) 1.0 0.0)) 
                       (at next #'inner next)))))
        (when osc-out (inner (now)))))))

(defmethod preset-displayed? (preset (instance one-player-ctl-tablet))
  (let ((min-preset (ash (player-idx instance) 4)))
    (<= min-preset preset (+ min-preset 15))))

(defmethod set-param-sliders ((instance one-player-ctl-tablet))
  "set param sliders to current cc state."
  (with-slots (osc-out player-idx) instance
    (dotimes (idx 16)
      (let ((cc-offset (ash (1+ player-idx) 4)))))))

(defmethod bs-presets-change-handler ((instance one-player-ctl-tablet) &optional changed-preset)
  "highlight preset buttons if non-empty."
  (if (or (not changed-preset)
           (preset-displayed? changed-preset instance))
      (with-slots (osc-out player-idx cp-obstacle cp-audio cp-boids) instance
        (dotimes (idx 16)
          (let ((cc-offset (ash (1+ player-idx) 4)))
            (if osc-out
                (incudine.osc:message
                 osc-out
                 "/recallPresetState" "ff" (float idx)
                 (if (bs-preset-empty?
                      (+ idx cc-offset)
                      :load-obstacles cp-obstacle
                      :load-audio cp-audio
                      :load-boids cp-boids
                      :player-idx-or-key (1+ player-idx))
                     0.0 1.0))))))))

(defmethod bs-preset-button-handler ((instance one-player-ctl-tablet) idx)
  "handle button press on preset buttons."
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
         (setf copy-state 0) ;;; reset state, stop blink
         (bs-state-copy copy-src bs-idx
                        :cp-obstacles cp-obstacle
                        :cp-audio cp-audio
                        :cp-boids cp-boids)
         (if osc-out
             (incudine.osc:message
              osc-out
              "/copyState" "f" 0.0)) ;;; turn off Copy button.
         (bs-presets-change-notify)) ;;; update button lights of all registered controllers.
        (rec-state ;;; saving: save-dest pressed
         (bs-state-save
          bs-idx
          :save-obstacles cp-obstacle
          :save-audio cp-audio
          :save-boids cp-boids)
         (setf rec-state nil)
         (if osc-out
             (incudine.osc:message
              osc-out
              "/saveState" "f" 0.0)))
  ;;; turn off Save button
        (t (bs-state-recall
            bs-idx
            :players-to-recall (reverse
                                (cons (player-name (1+ player-idx))
                                      (if cp-boids '(:auto))))
            :load-obstacles cp-obstacle
            :load-audio  cp-audio
            :load-boids cp-boids))))))

;;; (set-bs-preset-buttons (find-osc-controller :tab-p1))
