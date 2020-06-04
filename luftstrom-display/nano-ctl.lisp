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
  ((rec-state :initform nil :initarg :rec-state :accessor rec-state)
   (cc-offset :initform 0
              :initarg :cc-offset :accessor cc-offset)
   (bs-copy-state :initform 0 :initarg :bs-copy-state :accessor bs-copy-state)
   (bs-copy-src :initform nil :initarg :bs-copy-src :accessor bs-copy-src)
   (bs-cp-obstacles :initform (make-instance 'value-cell :val nil)
                    :initarg :bs-cp-obstacles :accessor bs-cp-obstacles)
   (bs-cp-audio :initform (make-instance 'value-cell :val nil)
                :initarg :bs-cp-audio :accessor bs-cp-audio)
   (bs-cp-boids :initform (make-instance 'value-cell :val nil)
                :initarg :bs-cp-boids :accessor bs-cp-boids)))

(defmethod (setf bs-cp-obstacles) (new-val (instance nanokontrol))
  (with-slots (bs-cp-obstacles) instance
    (setf (val bs-cp-obstacles) new-val))
  new-val)

(defmethod (setf bs-cp-audio) (new-val (instance nanokontrol))
  (with-slots (bs-cp-audio) instance
    (setf (val bs-cp-audio) new-val))
  new-val)

(defmethod (setf bs-cp-boids) (new-val (instance nanokontrol))
  (with-slots (bs-cp-boids) instance
    (setf (val bs-cp-boids) new-val))
  new-val)

(defmethod bs-cp-obstacles ((instance nanokontrol))
  (with-slots (bs-cp-obstacles) instance
    (val bs-cp-obstacles)))

(defmethod bs-cp-audio ((instance nanokontrol))
  (with-slots (bs-cp-audio) instance
    (val bs-cp-audio)))

(defmethod bs-cp-boids ((instance nanokontrol))
  (with-slots (bs-cp-boids) instance
    (val bs-cp-boids)))

(defmacro toggle-state (slot)
  `(setf ,slot (not ,slot)))

(defgeneric blink (instance cc-ref)
  (:documentation "implementation of a blinking pushbutton for bs-copy-state.")
  (:method ((instance nanokontrol) cc-ref)
    (with-slots (midi-output chan bs-copy-src bs-copy-state) instance
      (let ((state t))
        (labels ((inner (time)
                   (if (zerop bs-copy-state)
                     (funcall (ctl-out midi-output cc-ref 0 chan)) ;;; ensure blink light is off
                     (let ((next (+ time 0.5)))
                       (setf state (not state))
                       (funcall (ctl-out midi-output cc-ref (if state 127 0) chan)) 
                       (at next #'inner next)))))
          (inner (now)))))))

(defgeneric preset-displayed? (preset instance)
  (:documentation "predicate testing if preset is currently displayed on instance.")
  (:method (preset (instance nanokontrol))
    (with-slots (cc-offset) instance
      (<= cc-offset preset (+ cc-offset 15)))))

(defgeneric bs-presets-change-handler (instance &optional changed-preset)
  (:documentation "handle gui updates of preset changes (set/unset).")
  (:method ((instance nanokontrol) &optional changed-preset)
    (if (or (not changed-preset)
            (preset-displayed? changed-preset instance))
        (set-bs-preset-buttons instance))))

(defmethod initialize-instance :before ((instance nanokontrol)
                                        &key (id :nk2) (chan (controller-chan :nk2))
                                        &allow-other-keys)
  (setf (id instance) id)
  (setf (chan instance) chan))

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

(defgeneric remove-model-refs (gui)
  (:documentation "cleanup: removes the refs in the model of the gui's labelboxes")
  (:method ((gui cuda-gui::nanokontrol-grid))
    (dotimes (idx 16)
      (set-ref (aref (param-boxes gui) idx) nil))))

(defmethod initialize-instance :after ((instance nanokontrol) &key (x-pos 0) (y-pos 0) (width 500)
                                       (height 60)
                                       &allow-other-keys)
  (with-slots (cc-fns cc-map gui id chan midi-output) instance
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
    (setf gui (nanokontrol-gui :id id
                               :x-pos x-pos
                               :y-pos y-pos
                               :width width
                               :height height))
    (setf (cuda-gui::cleanup-fn gui)
          (let ((id id) (gui gui))
            (lambda ()
              (remove-midi-controller id)
              (remove-model-refs gui)
              (unregister-bs-presets-handler instance *bp*))))
;;    (setf cc-fns (sub-array *cc-fns* (player-aref :nk2)))
    (map nil (lambda (fn) (setf fn #'identity)) cc-fns)
;;;    (set-fixed-cc-fns instance)
    (at (+ (now) 1) (lambda ()
                      (init-nanokontrol-gui-callbacks instance)
                      (setup-bs-presets-handler instance *bp*)
                      (init-nk2-pushbuttons instance)
                      ))))

(defun init-nk2-pushbuttons (instance)
  "simulate pressing the midi pushbuttons for cp-bs-obstacles,
cp-bs-audio and cp-bs-boids and finally the leftmost R button."
  (setf (bs-cp-obstacles instance) nil)
  (setf (bs-cp-audio instance) nil)
  (setf (bs-cp-boids instance) nil)
  (handle-midi-in instance :cc 43 127)
  (handle-midi-in instance :cc 44 127)
  (handle-midi-in instance :cc 42 127)
  (handle-midi-in instance :cc 64 127))

;;; (init-nk2-pushbuttons (find-controller :nk2))

(defgeneric setup-bs-presets-handler (instance ref)
  (:documentation "update the bs-buttons on state change of bs-cp-boids, bs-cp-audio or bs-cp-obstacles in instance")
  (:method ((instance nanokontrol) ref)
    (with-slots (bs-cp-obstacles bs-cp-audio bs-cp-boids midi-output chan) instance
      (register-bs-presets-change-handler instance ref)
      (setf (ref-set-hook bs-cp-obstacles)
            (lambda (val) (funcall (ctl-out midi-output 43 (if val 127 0) chan))))
      (setf (ref-set-hook bs-cp-audio)
            (lambda (val) (funcall (ctl-out midi-output 44 (if val 127 0) chan))))
      (setf (ref-set-hook bs-cp-boids)
            (lambda (val) (funcall (ctl-out midi-output 42 (if val 127 0) chan)))))))

;;; (set-pushbutton-cell-hooks (find-controller :nk2) *bp*)
#|
(player-aref :nk2)
(restore-controllers)

(ensure-controller :nk2)
(find-controller :nk2)
             58 59                    ;;; 16 17
             46    60 61 62           ;;; 18    19 20 21
             43 44 42 41 45           ;;; 22 23 24 25 26
                                      ;;; S/M/R pushbuttons:
             32 33 34 35 36 37 38 39  ;;; 27 28 29 30 31 32 33 34
             48 49 50 51 52 53 54 55  ;;; 35 36 37 38 39 40 41 42
             64 65 66 67 68 69 70 71  ;;; 43 44 45 46 47 48 49 50

(defun set-fixed-cc-fns (controller)
  "fixed cc-fns are the functions for retrieving presets using the
nanokontrol2 transport keys on the left. mc-ref should be the index of
the nanokontrol to use."
  ;;;
  ;;;      the index of the nanocontrol object cc-fns for the
  ;;;      buttons. The mapping to the actual cc nums is done in the
  ;;;      intitialization method of the object.
  ;;;
  ;;;      16 17
  ;;;      18    19 20 21
  ;;;      22 23 24 25 26
  ;;;
  (with-slots (cc-fns) controller
    (setf (aref cc-fns 16) (lambda (d2) (if (= d2 127) (previous-preset))))
    (setf (aref cc-fns 17) (lambda (d2) (if (= d2 127) (next-preset))))
    (setf (aref cc-fns 18) (lambda (d2) (if (= d2 127) (edit-preset-in-emacs *curr-preset-no*))))
    (setf (aref cc-fns 19) (lambda (d2) (if (= d2 127) (load-current-audio-preset))))
    (setf (aref cc-fns 20) (lambda (d2) (if (= d2 127) (previous-audio-preset))))
    (setf (aref cc-fns 21) (lambda (d2) (if (= d2 127) (next-audio-preset))))
    (setf (aref cc-fns 22) (lambda (d2) (declare (ignore d2)) (load-current-preset)))
    (setf (aref cc-fns 23) (lambda (d2) (declare (ignore d2)) (incudine:flush-pending)))
    (setf (aref cc-fns 24)
          (lambda (d2) (declare (ignore d2))
            (cl-boids-gpu::reshuffle-life cl-boids-gpu::*win* :regular nil))))
  nil)
 |#

(defmethod handle-midi-in ((instance nanokontrol) opcode d1 d2)
  (with-slots (gui chan cc-map cc-fns cc-offset midi-output rec-state bs-copy-state) instance
    (case opcode
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
              (if rec-state
                  (progn
                    (setf rec-state nil)
                    (funcall (ctl-out midi-output 45 0 chan))))
              (funcall (ctl-out midi-output d1 (if (zerop bs-copy-state) 0 127) chan)))
             ((= d1 45) ;;; Rec Transport-ctl Button
              (setf rec-state (not rec-state))
              (if rec-state (unless (zerop bs-copy-state)
                              (setf bs-copy-state 0)
                              (funcall (ctl-out midi-output 41 0 chan))))
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
      (:note-on nil)
      (:note-off nil))))

;;; (handle-midi-in (find-controller :nk2) :cc 17 64)

;;; (cuda-gui::set-fader (gui (find-controller :nk2)) 1 33)

(defgeneric set-bs-preset-buttons (instance)
  (:documentation "light the S/M buttons containing a bs-preset")
  (:method ((instance nanokontrol))
    (let ((pb-cc-nums #(32 33 34 35 36 37 38 39 48 49 50 51 52 53 54 55)))
      (with-slots (midi-output chan cc-offset bs-cp-obstacles bs-cp-audio bs-cp-boids) instance
        (dotimes (idx 16)
          (funcall (ctl-out midi-output (aref pb-cc-nums idx)
                            (if (bs-preset-empty?
                                 (+ idx cc-offset)
                                 :load-obstacles (val bs-cp-obstacles)
                                 :load-audio (val bs-cp-audio)
                                 :load-boids (val bs-cp-boids))
                                0 127)
                            chan) ))))))

;;; (set-bs-preset-buttons (find-controller :nk2))

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
           (bs-presets-change-notify)) ;;; update button lights of all registered controllers.
          (rec-state
           (bs-state-save
            bs-idx
            :save-obstacles (val bs-cp-obstacles)
            :save-audio (val bs-cp-audio)
            :save-boids (val bs-cp-boids))
           (setf rec-state nil)
           (funcall (ctl-out midi-output 45 0 chan))
           (bs-presets-change-notify))
          (t (bs-state-recall
              bs-idx
              :players-to-recall '(:auto)
              :load-obstacles (val bs-cp-obstacles)
              :load-audio  (val bs-cp-audio)
              :load-boids (val bs-cp-boids))))))))

(defgeneric init-nanokontrol-gui-callbacks (instance &key echo)
  (:documentation "init the gui callback functions specific for the controller type."))


;;; (set-nk2-std (find-gui :nk2))

(defun set-nk2-std (gui)
  ;;  (break "set-nk2-std: ~a" gui)
  (set-ref (aref (cuda-gui::param-boxes gui) 0)
           (cl-boids-gpu::auto-amp *bp*)
           :map-fn (m-exp-zero-fn 0.01 2)
           :rmap-fn (m-exp-zero-rev-fn 0.01 2))
  (set-ref (aref (cuda-gui::param-boxes gui) 1)
           (cl-boids-gpu::pl1-amp *bp*)
           :map-fn (m-exp-zero-fn 0.01 2)
           :rmap-fn (m-exp-zero-rev-fn 0.01 2))
  (set-ref (aref (cuda-gui::param-boxes gui) 2)
           (cl-boids-gpu::pl2-amp *bp*)
           :map-fn (m-exp-zero-fn 0.01 2)
           :rmap-fn (m-exp-zero-rev-fn 0.01 2))
  (set-ref (aref (cuda-gui::param-boxes gui) 3)
           (cl-boids-gpu::pl3-amp *bp*)
           :map-fn (m-exp-zero-fn 0.01 2)
           :rmap-fn (m-exp-zero-rev-fn 0.01 2))
  (set-ref (aref (cuda-gui::param-boxes gui) 4)
           (cl-boids-gpu::pl4-amp *bp*)
           :map-fn (m-exp-zero-fn 0.125 2)
           :rmap-fn (m-exp-zero-rev-fn 0.125 2))
  (set-ref (aref (cuda-gui::param-boxes gui) 5)
           (cl-boids-gpu::boids-per-click *bp*)
           :map-fn (m-exp-rd-fn 1 500)
           :rmap-fn (m-exp-rd-rev-fn 1 500))
  (set-ref (aref (cuda-gui::param-boxes gui) 6)
           (cl-boids-gpu::boids-add-time *bp*)
           :map-fn (m-exp-zero-fn 0.01 100)
           :rmap-fn (m-exp-zero-rev-fn 0.01 100))
  (set-ref (aref (cuda-gui::param-boxes gui) 7)
           (cl-boids-gpu::len *bp*)
           :map-fn (m-lin-rd-fn 5 250)
           :rmap-fn (m-lin-rd-rev-fn 5 250))
  (set-ref (aref (cuda-gui::param-boxes gui) 8)
           (cl-boids-gpu::bp-speed *bp*)
           :map-fn (m-exp-fn 0.1 20)
           :rmap-fn (m-exp-rev-fn 0.1 20))
  (set-ref (aref (cuda-gui::param-boxes gui) 9)
           (cl-boids-gpu::sepmult *bp*)
           :map-fn (m-lin-fn 1 8)
           :rmap-fn (m-lin-rev-fn 1 8))
  (set-ref (aref (cuda-gui::param-boxes gui) 10)
           (cl-boids-gpu::cohmult *bp*)
           :map-fn (m-lin-fn 1 8)
           :rmap-fn (m-lin-rev-fn 1 8))
  (set-ref (aref (cuda-gui::param-boxes gui) 11)
           (cl-boids-gpu::alignmult *bp*)
           :map-fn (m-lin-fn 1 8)
           :rmap-fn (m-lin-rev-fn 1 8))
  (set-ref (aref (cuda-gui::param-boxes gui) 13)
           (cl-boids-gpu::lifemult *bp*)
           :map-fn (m-exp-zero-fn 1 500)
           :rmap-fn (m-exp-zero-rev-fn 1 500))
  (set-ref (aref (cuda-gui::param-boxes gui) 14)
           (cl-boids-gpu::clockinterv *bp*)
           :map-fn (m-lin-rd-fn 0 50)
           :rmap-fn (m-lin-rd-rev-fn 0 50))

  (set-ref (aref (cuda-gui::param-boxes gui) 15)
           (cl-boids-gpu::master-amp *bp*)
           :map-fn (m-exp-zero-fn 0.125 8)
           :rmap-fn (m-exp-zero-rev-fn 0.125 8)))


;;; (set-nk2-std (find-gui :nk2))
#|

(let ((gui (find-gui :nk2)))
  (set-ref (aref (cuda-gui::param-boxes gui) 14)
           (cl-boids-gpu::clockinterv *bp*)
           :map-fn (m-lin-rd-fn 0 50)
           :rmap-fn (m-lin-rd-rev-fn 0 50))
  (set-ref (aref (cuda-gui::param-boxes gui) 13)
           (cl-boids-gpu::lifemult *bp*)
           :map-fn (m-lin-fn 0 500)
           :rmap-fn (m-lin-rev-fn 0 500)))
|#

(defmethod init-nanokontrol-gui-callbacks ((instance nanokontrol) &key (echo t))
  (declare (ignore echo))
  ;;; dials and faders, absolute (no influence of cc-offset!!!)
  (with-slots (gui note-fn cc-fns cc-state cc-offset chan midi-output) instance
    (loop for idx below 16
          do (set-encoder-callback
              gui
              idx
              (let ((idx idx))
                (lambda (val)
                  (setf (aref cc-state idx) val)
                  (funcall (aref cc-fns idx) val)))))
    (set-nk2-std gui)))

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

