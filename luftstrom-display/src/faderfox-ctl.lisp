;;; 
;;; faderfox-ctl.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2022 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
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

;;; Documentation: the faderfox controller consists of two classes/instances
;;;
;;; 1. faderfox-gui
;;;
;;; This is the place, where the gui elements and the infrastructure
;;; of gui callback and access functions for reading and changing the
;;; state of the gui elements are defined. The callback functions are
;;; invoked on user interaction (keyboard and mouse).
;;;
;;; Upon instantiation, an instance will be registered with the
;;; cuda-gui::*guis* hash table. Closing the gui window will call the
;;; cleanup-fn (customizable, initially not doing anything) and remove
;;; the instance from cuda-gui::*guis*.
;;;
;;; 2. faderfox-ctl
;;;
;;; This is the place, where the connection/link to an actual hardware
;;; controller is defined/established. The superclass 'midi-controller
;;; contains the input/output midi ports, midi channel, the cc-map of
;;; the controller's buttons/dials/faders, state of cc and last notes,
;;; an array of cc-fns to be invoked on cc-events and a note-fn
;;; invoked on note events. It also contains a 'gui slot establishing
;;; a link to the cuda-gui instance.
;;;
;;; Upon instantiation of faderfox-ctl, it gets registered with the
;;; luftstrom-display::*midi-controllers* hash table and the instance
;;; is added to the list stored under the 'input key of
;;; *midi-controllers* (see midictl.lisp). It also establishes a link
;;; to the midi in/outputs, instantiates the gui and (re)defines the
;;; callback handler functions in the gui to
;;;
;;; 1. reflect gui changes in the controller hardware (by sending the
;;; appropriate messages to the instance's midi-out).
;;;
;;; 2. Do whatever is the desired response to gui changes.
;;;
;;; Here is the place to define
;;;
;;; - The midi cc-map
;;; - The callback handlers for the gui elements
;;; - The receiver functions for incoming midi-events.
;;;
;;; The main functions to define are:
;;;
;;; - initialize-instance :after
;;;
;;;   defines cc-map, initializes the gui, sets the gui's #'cleanup-fn
;;;   to handle removal of the faderfox controller instance from
;;;   *midi-controllers* and (gethash *midi-controllers* 'input) upon
;;;   closing the window and finally calls
;;;
;;; - init-gui-callbacks
;;;
;;;   to define the behaviour of gui-elements (like radio-buttons,
;;;   etc.) on user keyboard/mouse interaction.
;;; 
;;; - handle-midi-in
;;; 
;;;   defines the handlers for midi-input, These handlers most of the
;;;   time simulate the mouse/keyboard interaction corresponding to
;;;   the midi-event.
;;;

;;; The chain of command: midi-in -> (via handle-midi-in)
;;;                      emit-signal (to gui buttons/pvbs)
;;;                      do-action (via init-gui-callbacks)

(in-package :luftstrom-display)

(defclass faderfox (midi-controller)
    ((cc-copy-state :initform 0 :initarg :cc-copy-state :accessor cc-copy-state)
     (cc-copy-src :initform nil :initarg :cc-copy-src :accessor cc-copy-src)
     (player-idx :initform 0 :type (integer 0 16) :initarg :player-idx :accessor player-idx)
     (rec-state :initform 0 :type (integer 0 2) :initarg :rec-state :accessor rec-state)
     (player-cp-src :initform 0 :type (integer 0 5) :initarg :player-cp-src :accessor player-cp-src)))

#|
(defmethod blink ((instance faderfox) cc-ref)
  (with-slots (midi-output chan cc-copy-src cc-copy-state) instance
    (let ((state t))
      (labels ((inner (time)
                 (unless (zerop cc-copy-state)
                     (let ((next (+ time 0.5)))
                       (setf state (not state))
                       (funcall (ctl-out midi-output cc-ref (if state 127 0) chan)) 
                       (at next #'inner next)))))
        (inner (now))))))
|#

(defmethod initialize-instance :before ((instance faderfox) &key (id :ff1)
                                        (chan (controller-chan :ff1)) &allow-other-keys)
  (setf (id instance) id)
  (setf (chan instance) chan))

(defun get-inverse-lookup-array (seq)
  "put the index of the elems of seq into the array at the index of
their value and return the array."
  (let ((array (make-array 128 :initial-contents (loop for i below 128 collect i))))
    (loop
      with remain = ()
      for x in seq
      for idx from 0
      do (progn
           (push (aref array x) remain)
           (setf (aref array x) idx)))
    array))

(defmethod initialize-instance :after ((instance faderfox) &rest args &key (x-pos 0) (y-pos 0)
                                                             (width 600) (height 140)
                                       &allow-other-keys)
  (declare (ignorable x-pos y-pos width height))
  (with-slots (cc-map gui id chan midi-output) instance
    (setf cc-map
          (get-inverse-lookup-array
           '(32 33 34 35 36 37 38 39
             40 41 42 43 44 45 46 47)))
    (setf gui (apply #'faderfox-gui :id id args
                            ;; :x-pos x-pos
                            ;; :y-pos y-pos
                            ;; :width width
                            ;; :height height
                            ))
    (setf (cuda-gui::cleanup-fn (cuda-gui::find-gui id))
          (let ((id id))
            (lambda ()
              (remove-midi-controller id)
              (cuda-gui::remove-model-refs gui)
              )))
    (at (+ (now) 1)
      (lambda ()
        (init-gui-callbacks instance)
;;;        (set-bs-preset-refs instance)
        (cuda-gui::emit-signal ;;; set Player to :auto, this also sets the dial-refs by calling handle-player-switch!
         (aref (cuda-gui::buttons (gui instance)) 0) "changeValue(int)" 127)))))

;; (set-bs-preset-refs (find-controller :ff1))

;; (cuda-gui::ref (aref (cuda-gui::buttons (gui (find-controller :ff1))) 7))

;;; here we react to midi-events, generating gui user interaction. The
;;; actual handlers are called as gui-callbacks. The handlers should
;;; also make sure to reflect state change to midi-out.

(defun inc-auto-player-vol (inc)
  (let ((map-fn (m-exp-zero-fn 0.01 2))
        (rmap-fn (m-exp-zero-rev-fn 0.01 2)))
    (set-cell (cl-boids-gpu::auto-amp *bp*)
              (funcall map-fn
                       (round (max 0 (min 127 (+ inc (funcall rmap-fn (val (cl-boids-gpu::auto-amp *bp*)))))))))))

(defmethod handle-midi-in ((instance faderfox) opcode d1 d2)
  (case opcode
    (:cc (case d1
           ;; (48 (inc-auto-player-vol
           ;;      (rotary->inc d2)))
 ;;; (encoder-set-audio-preset d2) big encoder wheel of faderfox
           (otherwise
            (inc-fader
             (gui instance)
             (aref (cc-map instance) d1) ;;; idx of numbox in gui
             (rotary->inc d2)))))
    (:note-on
     (let ((velo d2))
       (cond
         ((<= 32 d1 37) ;;; emulate click into radio-buttons upper row (1-6)
          (cuda-gui::emit-signal
           (aref (cuda-gui::buttons (gui instance)) (- d1 32)) "changeValue(int)"
           (if (zerop velo) 127 velo)))
         ((<= 38 d1 39) ;;; emulate click into radio-buttons upper row (6-8)
          (cuda-gui::emit-signal
           (aref (cuda-gui::buttons (gui instance)) (- d1 32)) "changeValue(int)"
           (if (zerop velo) 127 velo)))
         ((<= 40 d1 47) ;;; emulate click into radio-buttons lower row (9-16)
          (cuda-gui::emit-signal
           (aref (cuda-gui::buttons (gui instance)) (- d1 32)) "changeValue(int)"
           velo)))))
    (:note-off
     (cond
       ((<= 32 d1 37) ;;; emulate click into radio-buttons upper row (1-6)
        (cuda-gui::emit-signal
         (aref (cuda-gui::buttons (gui instance)) (- d1 32)) "changeValue(int)" 127))
       ((<= 38 d1 39) ;;; emulate click into radio-buttons upper row (7-8)
        (cuda-gui::emit-signal
         (aref (cuda-gui::buttons (gui instance)) (- d1 32)) "changeValue(int)" 0))

       ((<= 40 d1 47) ;;; emulate click into radio-buttons lower row (9-16)
        (cuda-gui::emit-signal
         (aref (cuda-gui::buttons (gui instance)) (- d1 32)) "changeValue(int)" 127))))))

;;; here we invoke the actual handlers and also handle the reflection
;;; of state-change to the midi-outlets.

(defmethod init-gui-callbacks ((instance faderfox) &key (echo t))
  (declare (ignore echo))
  (let ((note-ids #(32 33 34 35 ;;; midi-notenums of Faderfox Pads
                    36 37 38 39
                    40 41 42 43
                    44 45 46 47)))
    (dotimes (idx 16)
      (with-slots (gui note-fn cc-fns cc-state player-idx chan midi-output) instance
           (set-encoder-callback
            gui
            idx
            (let ((idx idx))
              (lambda (val)
                (setf (aref cc-state (+ idx player-idx)) val)
                (funcall (aref cc-fns (+ idx player-idx)) val)
                (funcall (ctl-out midi-output (aref note-ids idx) val chan)))))
           (set-pushbutton-callback
            gui
            idx
            (let ((idx idx))
              (lambda (pb-instance)
                (with-slots (state) pb-instance
;;; Currently we just use a generic operation of setting player-idxs
;;; and restoring the rotary encoders of the faderfox.  In case we
;;; want to set a special handler function for pushbuttons in the
;;; future:  (funcall note-fn (aref note-ids idx) state)
;;;                  (break "pushbutton-callback in init-gui-callbacks, state: ~a, idx: ~a" state idx)

                  (cond
                    ((and (> state 0) (< idx 6))   ;;; idx: auto + 4 Players +  default
                     (handle-player-switch instance idx)
;;;                     (update-bs-faders gui cc-state player-idx)
                     )
                    ((and (> state 0) (= idx 7))
                     (toggle-cp-player-apr instance))
                    ((and (> state 0) (member idx '(6 8 9 10 11 12 13 14 15)))   ;;; lower row
                     (case idx
                          (8 (load-player-audio-preset (player-idx instance)))
                          (9 (previous-audio-preset))
                          (10 (next-audio-preset))
                          (14 (delete-player-audio-preset (player-idx instance)))
                          (15 (save-player-audio-preset (player-idx instance))))
                     (unhighlight-radio-buttons gui 17 6 1) ;;; set state to 0 to simulate momentary
                     (unhighlight-radio-buttons gui 17 8 8)))
;;                   (if echo ;;; echo state change to the midi-out of
;;                            ;;; the pushbutton. Setting the state
;;                            ;;; appropriately before this is called
;;                            ;;; defines whether the button is momentary
;;                            ;;; or toggle.
;; ;;;                   optical feedback of pushbuttons in beatstep:
;;                       (progn
;;                         (funcall (note-on midi-output (aref note-ids idx)
;;                                           state chan)))
;;                       )
                  ))))))))

(defun handle-player-switch (instance idx)
  (with-slots (gui player-idx) instance
    (unhighlight-radio-buttons gui idx)
    (setf player-idx idx)
    (set-audio-ref idx)
    (switch-player idx gui)))

(defun toggle-cp-player-apr (instance)
  (with-slots (rec-state) instance
    (if (zerop rec-state)
        (setf rec-state 1)
        (setf rec-state 0))

    (format t "~&rec-state: ~a" rec-state)))

#|
(let ((instance (gui (find-controller :ff1))))
  (cuda-gui::change-state (aref (cuda-gui::buttons instance) 7) 0))
|#
;;; (init-gui-callbacks (find-controller :ff1)) 


#|
(untrace)
(cuda-gui::set-state (elt (cuda-gui::buttons (gui (find-controller :ff1))) 0) 0)

(val (state (elt (cuda-gui::buttons (gui (find-controller :ff1))) 0)))
(defun handle-bs-presets-load-state (gui idx state)
  (let* ((load-audio-button (aref (cuda-gui::buttons gui) 6))
         (load-boids-button (aref (cuda-gui::buttons gui) 7))
         (last-audio-state (cuda-gui::state load-audio-button))
         (last-boids-state (cuda-gui::state load-boids-button)))
;;    (format t "~&state ~a, idx ~a, audio ~a, boids ~a" state idx last-audio-state last-boids-state)
    (if (= state 0)
        (case idx
          (6 (if (zerop last-boids-state)
                 (set-bs-preset-load-boids 127)
                 (set-bs-preset-load-audio 0)))
          (7 (if (zerop last-audio-state)
                 (set-bs-preset-load-audio 127)
                 (set-bs-preset-load-boids 0))) )
        (case idx
          (6 (if (> last-boids-state 0)
                 (progn
                   (set-bs-preset-load-audio 127)
                   (cuda-gui::set-state
                    (aref (cuda-gui::buttons gui) 7) 0))
                 (set-bs-preset-load-boids 0)))
          (7 (if (> last-audio-state 0)
                 (progn
                   (set-bs-preset-load-boids 127)
                   (cuda-gui::set-state
                    (aref (cuda-gui::buttons gui) 6) 0))
                 (set-bs-preset-load-audio 0)
                 ))))))
|#

(defgeneric switch-player (player instance)
  (:method  (player (bs-gui cuda-gui::faderfox-grid))
    "update the references of the rotaries to the current player's cc-state."
    (let ((cc-offs (ash player 4)))
      (dotimes (idx 16)
        (set-ref (aref (param-boxes bs-gui) idx)
                 (aref *audio-preset-ctl-model* (+ cc-offs idx))
                 :rmap-fn #'round :map-fn #'identity)))))


           #|

(cuda-gui::set-state
 (aref (cuda-gui::buttons (gui (find-controller :ff1))) (- 49 44)) 0) 


(cuda-gui::emit-signal
           (aref (cuda-gui::buttons (gui instance)) (- d1 44)) "setState(int)" velo)
|#



(defun update-bs-faders (gui cc-state player-idx)
  (loop
    for idx below 16 do
      (cuda-gui::set-fader
       gui idx (aref cc-state (+ player-idx idx)))))

(defun unhighlight-radio-buttons (instance idx &optional (idx-offs 0) (num 6))
  "turn off all pushbuttons from idx-offs for num except for the button at idx."
  (dotimes (i num)
    (if (/= (+ i idx-offs) idx)
        (cuda-gui::change-state
         (aref (cuda-gui::buttons instance) (+ i idx-offs)) 0))))

(defgeneric update-gui-fader (obj)
  (:documentation "reflect all fader states in gui after a state
  change."))

(defmethod update-gui-fader ((instance faderfox))
  (loop for idx below 16
        for cc-val across (cc-state instance)
        do (cuda-gui::set-fader (gui instance) idx cc-val)))

(defgeneric update-gui-encoder-callbacks (obj))

(defmethod update-gui-encoder-callbacks ((instance faderfox))
  (with-slots (cc-fns cc-state player-idx gui) instance
    (dotimes (idx 16)
      (set-encoder-callback
       gui
       idx
       (let ((idx idx)) ;;; create closure
         (lambda (val)
           (setf (aref cc-state (+ idx player-idx)) val)
           (funcall (aref cc-fns (+ idx player-idx)) val)))))))

(defgeneric restore-controller-state (obj cc-state cc-fns))

(defmethod restore-controller-state ((controller faderfox) cc-state cc-fns)
  (if cc-fns (setf (cc-fns controller) cc-fns))
  (if cc-state
      (progn
        (setf (cc-state controller) cc-state)
        (update-gui-fader controller))))


(defun init-faderfox (midi-output)
  "We have to send a notout to chan 0 before the pushbutton lights
will respond on other chans as well (presumable a firmware bug of the
faderfox)."
  (dotimes (i 1)
    (at (+ (now) (* i 0.05)) (note-on midi-output (+ 36 i) 127 0))
    (at (+ (now) (* i 0.05) 0.05) (note-on midi-output (+ 36 i) 0 0))))

(defun reinit-faderfox (instance &optional chan1)
  (with-slots (midi-output chan) instance
    (dotimes (i 16)
      (at (+ (now) (* i 0.05)) (note-on midi-output (+ 36 i) 127 (or chan1 chan)))
      (at (+ (now) (* i 0.05) 0.05) (note-on midi-output (+ 36 i) 0 (or chan1 chan))))))

;;; (reinit-faderfox (find-controller :ff1))

;;; (funcall (aref (note-fn (find-controller :ff1))))

;;; (find-controller :ff1)

