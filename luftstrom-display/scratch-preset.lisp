;;; 
;;; presets.lisp
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

(in-package :cuda-gui)
(named-readtables:in-readtable :qt)

(defparameter *testbutton* (make-instance 'pushbutton))

(emit-signal *testbutton* "myHighlight(int)" 1)

(aref (buttons (find-gui :bs1)) 7)

(highlight *testbutton* 0)

(emit-signal (slot-value (find-gui :ewi1) 'cuda-gui::l6-b) "myHighlight(int)" 0)

(emit-signal (slot-value (find-gui :ewi1) 'cuda-gui::l6-b) "pressed()")
(emit-signal (slot-value (find-gui :ewi1) 'cuda-gui::l6-a) "pressed()")

(emit-signal (slot-value (find-gui :ewi1) 'cuda-gui::ewi-hold) "pressed()")

(change-state (slot-value (find-gui :ewi-test2) 'cuda-gui::ewi-hold) 0)

(emit-signal instance "changeValue(int)" new-val)

(#_setStyleSheet (aref (buttons (find-gui :bs1)) 0)
                 "background-color: #dddddd")
(set-state )

(setf (val (cl-boids-gpu::len cl-boids-gpu::*bp*)) 5)

(defun square (x)
  (declare ((integer 0 30) x))
  (* x x))

(function square)
(let ((color "#ff7777"))
  (#_setStyleSheet (aref (buttons (find-gui :bs1)) 0)
                   (format nil
                           "background-color: ~a;
border-radius: 4px; 
border-style: outset;
border-color: #bbbbbb;
border-width: 1px;
min-width: 43px;
"
                           color)))

"background-color: #dddddd; 
 border-width: 4px;
border-radius: 4px; 
 border-style: sunken;
border-color: beige; 
min-width: 45px;"
(in-package :cl-boids-gpu)


(first (systems *win*))

(set-cell (boids-add-time *bp*) 10)






(cuda-gui:find-gui :pv1)

39-111

25-97
(- 111 39)
(- 97 25)

(- 39 27)

(let ((x 27)) (mod (- x 27) 12))

(ewi-oct)

(/ (- 112 40) 72.0)


(/ (- 40 40) 72.0)

()
(timer-add-boids 500 1 )

(timer-add-boids )

(set-obstacle-position *win* 1 0.2 0.2)

(luftstrom-display::obstacle-pos (elt *obstacles* 1))

(luftstrom-display::pos (elt *obstacles* 1))

(in-package :luftstrom-display)

(defparameter *default-apr*
  '(:apr 2 :cc-state #(127 0 127 0 127 127 0 53 0 16 127 0 0 0 0 42)
    :preset-form
    (:cc-state #(127 0 127 0 127 127 0 53 0 16 127 0 0 0 0 42)
     :p1 (if (<= (mc-lin 6 0 1) (random 1.0))
             (* (expt (min 2 (/ v)) (mcn-ref 13)) (mc-exp 14 0.1 1) (r-exp 0.2 0.6))
             0.6)
     :p2 (if (<= (mcn-ref 5) (random 1.0))
             0
             1)
     :p3 0
     :p4 0
     :synth 0
     :pitchfn (n-exp y 0.448 0.831)
     :ampfn (* (sign) (expt (mc-exp 8 0.1 1) p2) (db->amp (rand -10)))
     :durfn p1
     :suswidthfn (n-lin p2 0.3 0)
     :suspanfn (n-lin p2 0 0.3)
     :decaystartfn 5.0e-4
     :decayendfn 0.002
     :lfofreqfn (*
                 (expt (round (1+ (* (if (zerop p2) 1 31) y (mcn-ref 11))))
                  (n-lin x 1 (mc-lin 12 1 1.5)))
                 (mtof (mc-lin 9 (n-lin p2 3.5 31) 55)) (mc-exp-dev 10 1.2))
     :xposfn x
     :yposfn y
     :wetfn (mc-lin 16 0 1)
     :filtfreqfn (n-exp y (n-lin p2 1000 200) 10000)
     :bpfreq (n-exp y (n-lin p2 1000 100) 5000)
     :bprq (mc-exp 15 1 0.01))))

(defun clear-player-audio-presets (bs-preset)
  "delete the apr entries of all players and set :default to default
audio preset."
  (let ((audio-args (audio-args bs-preset)))
    (dolist (player '(:player1 :player2 :player3 :player4))
      (remf  audio-args player))
    (setf (getf audio-args :default)
          (copy-list *default-apr*))))

(loop for bs-preset across *bs-presets* do (clear-player-audio-presets bs-preset))

(clear-player-audio-presets (elt *bs-presets* 0))

(getf (audio-args (elt *bs-presets* 0)) :default)

(:cc-state #(127 30 127 0 39 127 0 27 59 0 3 123 9 56 0 127) :p1 0 :p2 0 :p3 0
  :p4 0 :synth 1 :pitchfn (n-exp y 0.45 1) :ampfn (* (sign) (n-exp y 1 0.5))
  :durfn
  (* (expt (min 2 (/ v)) (mcn-ref 13)) (m-exp (mc-ref 14) 0.1 1)
     (r-exp 0.2 0.6))
  :suswidthfn 0.3 :suspanfn 0 :decaystartfn 5.0e-4 :decayendfn 0.002 :lfofreqfn
  (* (n-exp x 1 1) (expt (1+ (round (* 16 y (mcn-ref 11)))) (mc-lin 12 1 1.5))
     (mc-exp 9 0.25 4) 45 (mc-exp-dev 10 1.2))
  :xposfn x :yposfn y :wetfn (mc-lin 16 0 1) :filtfreqfn (n-exp y 1000 10000)
  :vowel y :voicetype (random 5) :voicepan (mcn-ref 1) :bpfreq
  (n-exp y 1000 5000) :bprq (mc-exp 15 1 0.01) :bppan (mcn-ref 3))




(let ((liste  '(1 1 2 2 3 3 4 4)))
  (remf liste 2)
  liste)

(mapcar  (elt *bs-presets* 0))


(bs-life *curr-boid-state*)

(aref *bs-presets* 0)



(pos (elt *obstacles* 0))

(let ((nk2 (find-controller :nk2)))
  (with-slots (midi-output chan) nk2
    (funcall (ctl-out midi-output 43 0 chan))))

(make-instance )
(let* ((id :nk2b) (chan 1))
  (add-midi-controller
   'nanokontrol
   :id id :chan chan
   :cc-state (sub-array *cc-state* chan)
   :cc-fns (sub-array *cc-fns* chan)
   :x-pos 0
   :y-pos 490
   :height 60
   :width 750))

(dotimes (i 4)
  (setf (obstacle-type (aref (bs-obstacles (aref *bs-presets* 0)) i)) 3))

  (setf (pos (aref (bs-obstacles (aref *bs-presets* 0)) 0)) '(0.5 0.5))
  (setf (pos (aref (bs-obstacles (aref *bs-presets* 0)) 1)) '(0.1 0.1))
  (setf (pos (aref (bs-obstacles (aref *bs-presets* 0)) 2)) '(0.3 0.3))
(setf (pos (aref (bs-obstacles (aref *bs-presets* 0)) 3)) '(0.7 0.7))

(progn
  (setf (pos (aref (bs-obstacles (aref *bs-presets* 0)) 0)) '(0.7 0.7))
  (setf (pos (aref (bs-obstacles (aref *bs-presets* 0)) 1)) '(0.5 0.5))
  (setf (pos (aref (bs-obstacles (aref *bs-presets* 0)) 2)) '(0.3 0.3))
  (setf (pos (aref (bs-obstacles (aref *bs-presets* 0)) 3)) '(0.1 0.1))
  (setf (obstacle-active (aref (bs-obstacles (aref *bs-presets* 0)) 0)) t)
  (setf (obstacle-active (aref (bs-obstacles (aref *bs-presets* 0)) 1)) t)
  (setf (obstacle-active (aref (bs-obstacles (aref *bs-presets* 0)) 2)) t)
  (setf (obstacle-active (aref (bs-obstacles (aref *bs-presets* 0)) 3)) t)
  (set-cell (pos (aref *obstacles* 0)) '(0.2 0.2))
  (set-cell (pos (aref *obstacles* 1)) '(0.4 0.4))
  (set-cell (pos (aref *obstacles* 2)) '(0.6 0.6))
  (set-cell (pos (aref *obstacles* 3)) '(0.8 0.8)))

(set-cell (pos (aref *obstacles* 0)) '(0.7 0.7))

(set-cell (pos (aref *obstacles* 1)) '(0.3 0.3))

(setf (slot-value (pos (aref *obstacles* 1)) 'val) '(0.3 0.3))
cl-boids-gpu::update-get-active-obstacles

(reset-obstacles-from-bs-preset
 (bs-obstacles (aref *bs-presets* 0))
 nil)

(loop for i below 4
      collect (pos (aref *obstacles* i)))

(pos (aref *obstacles* 1))

(progn
  (setf (val (pos (aref *obstacles* 0))) '(0.5 0.5))
  (setf (val (pos (aref *obstacles* 1))) '(0.5 0.5))
  (setf (val (pos (aref *obstacles* 2))) '(0.5 0.5))
  (setf (val (pos (aref *obstacles* 3))) '(0.5 0.5)))

(rec-state (find-controller :nk2))

(bs-copy-state (find-controller :nk2))

(loop for i below 4
      collect (pos (aref (bs-obstacles (aref *bs-presets* 0)) i)))



(loop for i below 4
      collect (obstacle-type (aref (bs-obstacles (aref *bs-presets* 0)) i)))

((0.5 0.5) (0.8225 0.26333332) (1.0 0.88666666) (0.04875 0.50666666))



(predator-sort)

*obstacles*

(pos (aref (bs-obstacles (aref *bs-presets* 0)) 0))

*audio-presets*

(get-obstacle-pos 0 cl-boids-gpu::*win*)

(dotimes (i 4)
  (setf (set-cell-hook (pos (aref *obstacles* i))) #'identity)
  (setf (dependents (pos (aref *obstacles* i))) nil))

(set-cell (pos (aref *obstacles* 0)) '(0.5 0.5))
(set-cell (pos (aref *obstacles* 0)) '(0.2 0.2))
(set-cell (pos (aref *obstacles* 0)) '(0.7 0.7))

(reset-obstacles-from-bs-preset)

(aref *obstacles* 0)

(setf (val (slot-value *bp* 'cl-boids-gpu::length)) 5)

*bp*

(toggle-state (bs-cp-audio (find-controller :nk2)))

(funcall (ref-set-hook (slot-value (find-controller :nk2) 'bs-cp-audio)))

(set-pushbutton-cell-hooks (find-controller :nk2) *bp*)



(funcall (incudine::responder-function (first (responders (find-osc-controller :tab1)))) 1.0)



(progn
  (remove-osc-controller :tab1)
  (defparameter *tabletctl*
    (make-instance 'obstacle-ctl-tablet
                   :id :tab1
                   :osc-in *osc-obst-ctl*
                   :remote-ip *ip-galaxy*
                   :remote-port 3090)))

(progn
  (remove-osc-controller :tab-p1)
  (defparameter *one-player-tabletctl*
    (make-instance 'one-player-ctl-tablet
                   :id :tab-p1
                   :osc-in *osc-obst-ctl*
                   :remote-ip *ip-galaxy*
                   :remote-port 3090
                   :reverse-ip *ip-local*
                   :reverse-port 3089
                   :player-idx 0)))

*curr-audio-preset-no*
(set-model-apr :player1 19)

(let ((instance (find-osc-controller :tab-p1)))
  (setf (val (aref (sliders instance) 1)) 0.5))


(dotimes (i 16) (setf (val (aref (sliders (find-osc-controller :tab-p1)) i)) 0.5))

(dotimes (i 16) (setf (val (aref (sliders (find-osc-controller :tab-p1)) i)) 0.1))

(setf (val (aref (sliders (find-osc-controller :tab-p1)) 0)) 0.8)

(funcall (incudine::responder-function (elt (responders (find-osc-controller :tab-p1)) 0)) 1.0 0.4)

*audio-preset-ctl-model*

(sliders (find-osc-controller :tab-p1))

(let* ((idx 0)
       (value 0.4)
       (sliders (sliders (find-osc-controller :tab-p1)))
       (slider-slot (aref sliders (round idx))))
           (with-debugging
             (format t "~&slider-in: ~a ~a~%" idx value))
           (setf (slot-value slider-slot 'val) value)
           (set-cell (cellctl::ref slider-slot) (funcall (map-fn slider-slot) value)
                     :src slider-slot))


(funcall (slider-out (find-osc-controller :tab-p1)) 0 0.7)

(setf (val (aref (sliders (find-osc-controller :tab-p1)) 0)) 0.1)

(digest-preset-audio-args '(:default (:apr 99)) t)

(let ((audio-args '(:default (:apr 99))))
  (dolist (player (expand-players-to-recall t))
    (set-player-audio-preset
     player
     (player-audio-preset-num player audio-args)
     :cc-state (player-audio-arg-cc-state player audio-args))))

    (set-player-audio-preset
     :auto
     99)

(player-aref :auto)

(set-player-audio-preset)

(restore-audio-presets '(:default (:apr 99)))

(expand-players-to-recall t)

*curr-audio-preset-no*

(init-controller (find-osc-controller :tab-p1))

(let ((instance (find-osc-controller :tab-p1)))
  (funcall (reconnect-out instance) 1.0))
(let ((instance (find-osc-controller :tab-p1)))
  (with-slots (curr-audio-preset) instance
    (setf (val curr-audio-preset) (min 127 (1+ (val curr-audio-preset))))))

(let ((instance (find-osc-controller :tab-p1)))
  (incudine.osc:message
   (osc-out instance)
   "/saveConfig" "f" (float 1.0)))


(setf (val (slot-value *bp* 'cl-boids-gpu::pl1-apr)) 100)

(set-player-audio-preset :player1 64)
(set-player-audio-preset :player2 54)
(set-player-audio-preset :player1 34)

(let ((instance (find-osc-controller :tab-p1)))
  (incudine.osc:message
   (osc-out instance)
   "/reconnect" "f" (float 1.0)))

(reconnect-tablet (find-osc-controller :tab-p1))

(let ((instance (find-osc-controller :tab-p1)))
  (save-config-on-tablet instance))

(let ((instance (find-osc-controller :tab-p1)))
  (cp-boids instance))


(let ((instance (find-osc-controller :tab-p1))
      (ip "191.167.11.20"))
  (with-slots (osc-out) instance
    (loop
      for byte in (parse-ip ip)
      for id from 1
      do (incudine.osc:message
          osc-out
          (format nil "/ipSlider~2,'0d" id) "f" (float byte)))
    (incudine.osc:message
          osc-out
          (format nil "/ipSlider~2,'0d" 5) "f" (float 3090)))
    (incudine.osc:message
     (osc-out instance)
     "/reconnect" "f" (float 1.0)))

(let ((instance (find-osc-controller :tab-p1))
      (ip "191.167.11.20")
      (id 2))
    (incudine.osc:message
     (osc-out instance)
     (format nil "/ipSlider~2,'0d" id)
     "f" (float 110.0)))


(let ((instance (find-osc-controller :tab-p1)))
  (if (osc-out instance)
      (incudine.osc:message
       (osc-out instance)
       "/recallPresetState" "ff" (float 3) (float 1))))

(let ((instance (find-osc-controller :tab-p1)))
  (cp-boids instance))

 (float 0)

"/recallPresetGrid"

 "fff"

(let ((instance (find-osc-controller :tab-p1)))
  (with-slots (curr-audio-preset) instance
    (setf (val curr-audio-preset) 41)))

(let ((instance (find-osc-controller :tab-p1)))
  (if (osc-out instance)
      (incudine.osc:message
       (osc-out instance)
       "/presetNo" "f" (float 30))))

(slot-value (aref *obstacles* 0) 'pos)

(val (curr-audio-preset (find-osc-controller :tab-p1)))


(set-cell (cl-boids-gpu::boids-add-remove cl-boids-gpu:*bp*) 1.0)

(setf (val (add-toggle *tabletctl*)) )

(funcall (ref-set-hook (add-toggle *tabletctl*)) 0)

(incudine.osc:message
 (osc-out *tabletctl*)
 "/addtgl" "f" (float 0.0))

(set-bs-preset-buttons)

(unhighlight-radio-buttons (find-gui :bs1) 17)

(untrace)
(set-cell) *bp*
(cuda-gui::buttons (find-gui :bs1))

(cuda-gui::buttons (find-gui :nk2))

(find-gui :nk2)

(set-cell (cl-boids-gpu::load-boids cl-boids-gpu:*bp*) t)

(set-bs-preset-buttons (find-controller :nk2))

*bp*

(let ((player 1))
  (let ((ref (1- player))
        (type (map-type (obstacle-type (aref *obstacles* ref)))))))

(set-refs (find-osc-controller :ewi1))

(*obstacles*)

(cuda-gui::init-gui-callbacks (find-gui :ewi1))

*audio-preset-ctl-vector*

(find-gui :ewi1)

(setf (obstacle-type (aref *obstacles* 0)) 4)

(let ((gui (find-gui :ewi1)))
  (cuda-gui::emit-signal (cuda-gui::ewi-hold gui) "changeValue(int)" 0))

(with-slots (gui) (find-osc-controller :ewi1)
    (with-slots (cuda-gui::ewi-luft) gui 
      (let ((fn (make-retrig-move-fn
                 player
                 :dir :up :max 400
                 :ref (cuda-gui::ewi-luft (gui (find-osc-controller :ewi1)))
                 :clip nil))))))

(let* ((player 0)
       (let ((obstacle (aref *obstacles* player)))
         (with-slots (brightness radius)
             obstacle
           (let ((ipfn (ip-exp 2.5 10.0 128)))
             (set-lookahead player (float (funcall ipfn val))))
           (let ((ipfn (ip-exp 1 1.0 128)))
             (set-multiplier player (float (funcall ipfn val))))
           (let ((ipfn (ip-lin 0.2 1.0 128)))
             (setf brightness (funcall ipfn val)))))
       ))

(setf (obstacle-active (aref *obstacles* 0)) nil)

(with-slots (gui) (find-osc-controller :ewi1)
  (slot-value gui 'cuda-gui::ewi-luft))

(setf (val (pos (obstacle 0))) '(0.7 0.5))

  (let* ((bs (first (systems *win*)))
         (obstacle-target-posns (aref (obstacle-target-posns bs) 0)))
    obstacle-target-posns)

;;; (set-obstacle-dx 0 -40 10 nil)
;;; (set-obstacle-dy 0 -50 10 nil)


(setf (obstacle-pos (aref *obstacles* 0)) '(0.5 0.5))

(incudine.osc::set-value (osc-out *tabletctl*) 0 0.859375)
(incudine.osc::set-midi (osc-out *tabletctl*) 2 0.859375)


(setf (first (obstacle-pos (aref *obstacles* 0))) 0.2)
(setf (second (obstacle-pos (aref *obstacles* 0))) 0.5)

 Ihre Argumentation ist nachvollziehbar und naheliegend. Dennoch denke ich, dass das Präsidium seine Aufgabe auch dahingehend verstehen könnte, Hochschulmitarbeiter vor technisch defizitärer Software zu schützen, statt sie dieser auszusetzen.

Vor dem Hintergrund, dass die Dienstleistungen der Hochschule vermutlich nicht zum Supersparpreis angeboten werden, entzieht sich meinem Verständnis, dass Herr ... die Mängelbehebung seiner Software"konzepte" der Hochschule zusätzlich in Rechnung stellen will.

Ich würde begrüßen, wenn das Präsidium diese Auffassung teilt und dies der Firma ... gegenüber in aller dafür gebotenen Deutlichkeit artikuliert.

Herzliche Grüße,
Orm Finnendahl



(untrace)
(in-package :incudine.osc)

(defun set-midi (stream index value)
  (declare (type stream stream) (type non-negative-fixnum index)
           (type (unsigned-byte 32) value))
  (setf (cffi:mem-ref (arg-pointer stream index) :uint32) (round value))
  (values))

(defun set-midi (stream index value)
  (declare (type stream stream) (type non-negative-fixnum index)
           (type (unsigned-byte 32) value))
  (setf (cffi:mem-ref (arg-pointer stream index) :uint32) (round value))
  (values))

(incudine.osc::set-value (osc-out *tabletctl*) 0 0.883125)



(incudine.osc::typetag-code (osc-out *tabletctl*) 0)

(inc-obst-x (obstacle 0) 100)

(inc-obst-y (obstacle 0) 100)


(defun make-retrig-move-fn (player &key (dir :up) (num-steps 10) (max 100) (ref nil) (clip nil))
  "return a function moving the obstacle of a player in a direction
specified by :dir which can be bound to be called each time, a new
event (like a cc value) is received. If ref is specified it points to
a cc value stored in *cc-state* which is used for exponential interpolation
of the boid's stepsize between 0 and :max pixels."
  (let* ((clip clip)
         (obstacle (obstacle player))
         (obstacle-ref (obstacle-ref obstacle))
         (retrig? nil))
    (lambda (d2)
      (labels ((retrig (time)
                 "recursive function (with time delay between calls)
simulating a repetition of keystrokes after a key is depressed (once)
until it is released."
                 (if (and retrig? (obstacle-active obstacle))
                     (let ((next (+ time 0.1)))
                       (progn
                         (format t "~&running: ~a" d2)
                         (case dir
                           (:left (set-obstacle-dx
                                   obstacle-ref
                                   (float (* -1 (if ref (ou:m-exp-zero (aref *cc-state* player ref) 1 max) 10.0)))
                                   num-steps clip))
                           (:right (set-obstacle-dx
                                    obstacle-ref
                                    (float (if ref (ou:m-exp-zero (aref *cc-state* player ref) 1 max) 10.0))
                                    num-steps clip))
                           (:down (set-obstacle-dy
                                   obstacle-ref
                                   (float (* -1 (if ref (ou:m-exp-zero (aref *cc-state* player ref) 1 max) 10.0)))
                                   num-steps clip))
                           (:up (set-obstacle-dy
                                 obstacle-ref
                                 (float (if ref (ou:m-exp-zero (aref *cc-state* player ref) 1 max) 10.0))
                                 num-steps clip))))
                       ;;                       (format t "~&retrig, act: ~a" (obstacle-moving obstacle))
                       (at next #'retrig next)))))
;;; lambda-function entry point
        ;;        (format t "~&me-received: ~a" d2)
        (cond
          ((numberp d2)
           (if (obstacle-active obstacle)
               (if (> d2 0)
                   (unless retrig?
                     (setf retrig? t)
                     (retrig (now)))
                   (setf retrig? nil))))
          ((eq d2 'stop)
           (setf retrig? nil))
          (:else (warn "arg ~a not handled by make-retrig-move-fn." d2)))))))


(make-retrig-move-fn) (obstacle 0)
(toggle-obstacle 0)

(setf (obstacle-active (obstacle 0)) nil)

(defun make-retrig-move-fn (player &key (dir :up) (num-steps 10) (max 100) (ref nil) (clip nil))
  "return a function moving the obstacle of a player in a direction
specified by :dir which can be bound to be called each time, a new
event (like a cc value) is received. If ref is specified it points to
a value-cell which is used for exponential interpolation of the boid's
stepsize between 0 and :max pixels."
  (let* ((clip clip)
         (obstacle (obstacle player))
         (obstacle-ref (obstacle-ref obstacle))
         (retrig? nil))
    (lambda (d2)
      (labels ((retrig (time)
                 "recursive function (with time delay between calls)
simulating a repetition of keystrokes after a key is depressed (once)
until it is released."
                 (if retrig?
                     (let ((next (+ time 0.1)))
                       (progn
;;                         (format t "~&received: ~a" d2)
                         (case dir
                           (:left (set-obstacle-dx
                                   obstacle-ref
                                   (float (* -1 (if ref (ou:m-exp-zero (val ref) 1 max) 10.0)))
                                   num-steps clip))
                           (:right (set-obstacle-dx
                                    obstacle-ref
                                    (float (if ref (ou:m-exp-zero (val ref) 1 max) 10.0))
                                    num-steps clip))
                           (:down (set-obstacle-dy
                                   obstacle-ref
                                   (float (* -1 (if ref (ou:m-exp-zero (val ref) 1 max) 10.0)))
                                   num-steps clip))
                           (:up (set-obstacle-dy
                                 obstacle-ref
                                 (float (if ref (ou:m-exp-zero (val ref) 1 max) 10.0))
                                 num-steps clip))))
                       ;;                       (format t "~&retrig, act: ~a" (obstacle-moving obstacle))
                       (if (obstacle-active obstacle)
                           (at next #'retrig next)
                           (format t "~&movement stopped!~%"))))))
;;; lambda-function entry point
        ;;        (format t "~&me-received: ~a" d2)
        (cond
          ((numberp d2)
           (if (obstacle-active obstacle)
               (if (> d2 0)
                   (unless retrig?
                     (setf retrig? t)
                     (retrig (now)))
                   (setf retrig? nil))))
          ((eq d2 'stop)
           (setf retrig? nil))
          (:else (warn "arg ~a not handled by make-retrig-move-fn." d2)))))))





(defun make-retrig-move-fn (player &key (dir :up) (num-steps 10) (max 100) (ref nil) (clip nil))
  "return a function moving the obstacle of a player in a direction
specified by :dir which can be bound to be called each time, a new
event (like a cc value) is received. If ref is specified it points to
a value-cell which is used for exponential interpolation of the boid's
stepsize between 0 and :max pixels."
  (let* ((clip clip)
         (obstacle (obstacle player))
         (obstacle-ref (obstacle-ref obstacle))
         (retrig? nil))
    (lambda (d2)
      (labels ((retrig (time)
                 "recursive function (with time delay between calls)
simulating a repetition of keystrokes after a key is depressed (once)
until it is released."
                 (if retrig?
                     (let ((next (+ time 0.1)))
                       (progn
;;                         (format t "~&received: ~a" d2)
                         (case dir
                           (:left (set-obstacle-dx
                                   obstacle-ref
                                   (float (* -1 (if ref (ou:m-exp-zero (val ref) 1 max) 10.0)))
                                   num-steps clip))
                           (:right (set-obstacle-dx
                                    obstacle-ref
                                    (float (if ref (ou:m-exp-zero (val ref) 1 max) 10.0))
                                    num-steps clip))
                           (:down (set-obstacle-dy
                                   obstacle-ref
                                   (float (* -1 (if ref (ou:m-exp-zero (val ref) 1 max) 10.0)))
                                   num-steps clip))
                           (:up (set-obstacle-dy
                                 obstacle-ref
                                 (float (if ref (ou:m-exp-zero (val ref) 1 max) 10.0))
                                 num-steps clip))))
                       ;;                       (format t "~&retrig, act: ~a" (obstacle-moving obstacle))
                       (if (obstacle-active obstacle)
                           (at next #'retrig next)
                           (format t "~&movement stopped!~%"))))))
;;; lambda-function entry point
        ;;        (format t "~&me-received: ~a" d2)
        (cond
          ((numberp d2)
           (if (obstacle-active obstacle)
               (if (> d2 0)
                   (unless retrig?
                     (setf retrig? t)
                     (retrig (now)))
                   (setf retrig? nil))))
          ((eq d2 'stop)
           (setf retrig? nil))
          (:else (warn "arg ~a not handled by make-retrig-move-fn." d2)))))))


(defun obst-ctl1 (player)
  `((,player 7)
    ,(lambda (d2)
       (if (numberp d2)
           (let ((obstacle (aref *obstacles* player)))
             (with-slots (brightness radius)
                 obstacle
               (let ((ipfn (ip-exp 2.5 10.0 128)))
                 (set-lookahead player (float (funcall ipfn d2))))
               (let ((ipfn (ip-exp 1 1.0 128)))
                 (set-multiplier player (float (funcall ipfn d2))))
               (let ((ipfn (ip-lin 0.2 1.0 128)))
                 (setf brightness (funcall ipfn d2)))))))
    (,player 40)
    ,(make-retrig-move-fn player :dir :right :max 400 :ref 7 :clip nil)
    (,player 50)
    ,(make-retrig-move-fn player :dir :left :max 400 :ref 7 :clip nil)
    (,player 60)
    ,(make-retrig-move-fn player :dir :up :max 400 :ref 7 :clip nil)
    (,player 70)
    ,(make-retrig-move-fn player :dir :down :max 400 :ref 7 :clip nil)
    (,player 99)
    ,(lambda (d2)
       (if (and (numberp d2) (= d2 127))
           (toggle-obstacle player)))
    ))


(toggle-obstacle)

*audio-preset-ctl-vector*



(algn)

(obstacle-exists? (obstacle 0))

(obstacle 0)
*obstacles*

cuda-gui::label-pushbutton
(format t "~&obstacles: ~a, audio: ~a, boids: ~a"
        (val (cl-boids-gpu::load-obstacles *bp*))
        (val (cl-boids-gpu::load-audio *bp*))
        (val (cl-boids-gpu::load-boids *bp*)))

(setf (obstacle-active (aref *obstacles* 1)) nil)

(setf (obstacle-pos (elt *obstacles* 0)) '(0.1 0.8))

(setf (obstacle-brightness (elt *obstacles* 0)) 0.6)

(setf (ref-set-hook (slot-value instance 'o1-pos))
      (ensure-osc-echo-msg
        (format nil "/xy~d" (1+ player)) "ff" (float x) (float y))
      )

(setf (add-time *tabletctl*) (make-instance 'value-cell))

(incudine::fast-nrt-enqueue-function)


(let ((instance *tabletctl*))
  (setf (ref-set-hook (slot-value instance 'o1-pos))
        (lambda (pos)
          (if (osc-out instance)
              (destructuring-bind (x y) pos
                (incudine.osc:message
                 (osc-out instance)
                 (format nil "/xy~d" 1) "ff" (float x) (float y)))))))


        (lambda (active)
          (if (osc-out instance)
              (destructuring-bind (x y) pos
                (at (now) (apply #'incudine.osc:message
                           (osc-out instance)
                           (format nil "/obstactive~d" 1) "f" (float (if active 1 0)))))))

(obstacle-active (aref *obstacles* 0))
(ensure-osc-echo-msg
)

(make-instance
      'ewi-controller
      :id :ewi-test
      :player 1
      :osc-in *osc-obst-ctl*
      :remote-ip *ip-galaxy*
      :remote-port 3091
      :x-pos 800
      :y-pos (+ 0 )
      :height 60)

(make-instance
      'ewi-controller
      :id :ewi-test
      :player 1
      :osc-in *osc-obst-ctl*
      :remote-ip *ip-local*
      :remote-port 3091
      :x-pos 800
      :y-pos (+ 0 )
      :height 60)

(gethash *osc-obst-ctl* incudine::*responders*)
(setf (osc-in (find-osc-controller :ewi1)) *osc-obst-ctl*)


(clear-refs *tabletctl*)
(find)

(find-osc-controller :ewi-test)


*tabletctl*

(find-gui :ewi-test)
'cuda-gui::label-spinbox
  (new-pvb-value instance
                 (+ (#_value (text-box instance)) inc))

(let ((gui (find-gui :ewi-test)))

  (setf (slot-value (slot-value gui 'cuda-gui::l6-a) 'cuda-gui::callback)
        (lambda ()
          (if (> (#_value (text-box (slot-value gui 'cuda-gui::ewi-apr))) 0)
              (cuda-gui::dec-pvb-value (slot-value gui 'cuda-gui::ewi-apr))))))


    (setf (slot-value (slot-value gui 'cuda-gui::l6-b) 'cuda-gui::callback-fn)
          (lambda ()
            (if (< (val (slot-value gui 'cuda-gui::ewi-apr)) 127)
                (setf (val (slot-value gui 'cuda-gui::ewi-apr))
                      (+ (slot-value (slot-value gui 'cuda-gui::ewi-apr) 'val) 1)))))
    (setf (slot-value (slot-value gui 'cuda-gui::l6-c) 'cuda-gui::callback-fn)
          (lambda ()
            (if (> (val (slot-value gui 'cuda-gui::ewi-type)) 0)
                (setf (val (slot-value gui 'cuda-gui::ewi-type))
                      (- (slot-value (slot-value gui 'cuda-gui::ewi-type) 'val) 1)))))
    (setf (slot-value (slot-value gui 'cuda-gui::l6-d) 'cuda-gui::callback-fn)
          (lambda ()
            (if (< (val (slot-value gui 'cuda-gui::ewi-type)) 4)
                (setf (val (slot-value gui 'cuda-gui::ewi-type))
                      (+ (slot-value (slot-value gui 'cuda-gui::ewi-type) 'val) 1)))))

(make-instance
      'ewi-controller
      :id :ewi-test2
      :player 1
      :osc-in *osc-obst-ctl*
      :remote-ip "192.168.67.119"
      :remote-port 3091
      :x-pos 800
      :y-pos (+ 0 15 )
      :height 60)



(emit-signal (slot-value (find-gui :ewi-test2) 'cuda-gui::l6-a) "pressed()")

(setf (val (slot-value (find-gui :ewi-test2) 'cuda-gui::ewi-luft)) 10)

(bs-state-recall 0)
(find-gui :ewi1)

(load-audio-preset :no 10 :player-ref 1)


(make-instance
      'ewi-controller
      :id :ewi-test3
      :player 1
      :osc-in *osc-obst-ctl*
      :remote-ip "192.168.67.11"
      :remote-port 3090
      :x-pos 800
      :y-pos (+ 0 200)
      :height 60)

(let ((gui (find-gui :ewi-test)))
  (funcall (slot-value (slot-value gui 'cuda-gui::ewi-apr) 'ref-set-hook) 5))

(let ((gui (find-gui :ewi-test)))
  (setf (val (slot-value gui 'cuda-gui::ewi-apr)) 3))

(find-gui :ewi-test)

(incudine.osc:message
        *osc-obst-ctl-echo*
        ,@body)



(find-osc-controller :ewi-test2)

(let ((instance (find-osc-controller :ewi-test2))
      (num 2))
  (incudine.osc:message
   (osc-out instance)
   "/presetno2" "f" (float num)))

(find-osc-controller :ewi-test2)
(let ((instance (find-osc-controller :ewi-test2)))
  (incudine.osc:message
   (osc-out instance)
   (format nil "/numtoadd") "f" 10.0))

(let ((instance (find-osc-controller :ewi-test2)))
  (incudine.osc:message
   *osc-obst-ctl-echo*
   (format nil "/numtoadd") "f" 100.0))

(let ((instance (find-osc-controller :ewi-test2)))
  (incudine.osc:message
   *osc-obst-ctl-echo*
   (format nil "/type") "f" 1.0))

(let ((instance (find-osc-controller :ewi-test)) (player 1))
  (let ((#:s731 (osc-out instance)))
    (incudine.osc:start-message #:s731 (format nil "/xy-~d" player) "i")
    (incudine.osc::set-value #:s731 0 3)
    (incudine.osc:send #:s731)))

(defparameter *my-responder*
  (make-osc-responder *osc-obst-ctl* "/pl1-luft" "f"
                      (lambda (val)
                        (format t "~&received pl1-luft: ~a" val))))



;;; (remove-responder *my-responder*)

(defun replace-obstacles (pr)
  (if (cl-boids-gpu::bs-obstacles pr)
      (loop
        for old across (cl-boids-gpu::bs-obstacles pr)
        for idx from 0
        do (setf (aref (cl-boids-gpu::bs-obstacles pr) idx) (oldobst->new-obst idx old)))))


(loop for pr across *bs-presets* do (if pr (replace-obstacles pr)))

(obst2->obst (aref (cl-boids-gpu::bs-obstacles (aref *bs-presets* 0)) 0))

(reset-obstacles)


(aref *obstacles* 0)

(defun replace-obstacles (pr)
  (if (cl-boids-gpu::bs-obstacles pr)
      (loop
        for old across (cl-boids-gpu::bs-obstacles pr)
        for idx from 0
        do (setf (aref (cl-boids-gpu::bs-obstacles pr) idx) (obst2->obst old)))))

(defun replace-obstacles (pr)
  (if (cl-boids-gpu::bs-obstacles pr)
      (loop
        for old across (cl-boids-gpu::bs-obstacles pr)
        for idx from 0
        do (setf (aref (cl-boids-gpu::bs-obstacles pr) idx) (oldobst->new-obst idx old)))))

(defun obst2->obst (old)
  (let ((new (make-instance 'obstacle)))
    (loop for slot in '(exists? type radius ref brightness lookahead multiplier moving dtime active pos target-dpos)
          do (setf (val (slot-value new slot)) (val (slot-value old slot))))
    (setf (slot-value new 'idx) (slot-value old 'idx))
    new))

(defun oldobst->new-obst (idx old)
  (let ((new (make-instance 'obstacle2)))
    (loop for slot in '(exists? type radius ref brightness lookahead multiplier moving dtime active)
          do (setf (val (slot-value new slot)) (val (slot-value old slot))))
    (setf (val (slot-value new 'pos)) (list (val (slot-value old 'x)) (val (slot-value old 'y))))
    (setf (val (slot-value new 'target-dpos)) (list (val (slot-value old 'target-dx)) (val (slot-value old 'target-dy))))
    (setf (slot-value new 'idx) idx)
    new))

(oldobst->new-obst 4 (aref (cl-boids-gpu::bs-obstacles (aref *bs-presets* 1)) 1))

(defun class-get-model-slot-names (class-name)
  (let ((tmp (make-instance class-name))
         (class (find-class class-name)))
     (c2mop:ensure-finalized class)
     (loop for slot-def in (c2mop:class-direct-slots class)
           for slot-name = (c2mop:slot-definition-name slot-def)
           if (typep (slot-value tmp slot-name) 'model-slot)
             collect (c2mop:slot-definition-name slot-def))))

(untrace)
(class-get-model-slot-names 'obstacle)

(loop for idx across
              (cl-boids-gpu::bs-obstacles (aref *bs-presets* 0)))

obstacle

  (ensure-osc-echo-msg
    (format nil "/xy~d" 1) "ff" 0.5 0.5)

(osc-out *tabletctl*)

(set-ref (slot-value *tabletctl* 'o1-pos) (slot-value (aref *obstacles* 0) 'pos))

(obstacle-active (aref *obstacles* 0))

(set-ref (slot-value *tabletctl* 'o1-active) (slot-value (aref *obstacles* 0) 'active))

(setf (slot-value (slot-value (aref *obstacles* 0) 'active) 'dependents) nil)

(obstacle-pos (aref *obstacles* 0))

(cl-boids-gpu::*bp*)

(cl-boids-gpu::obstacle-type *obstacles*)
(obstacle-type (elt *obstacles* 0))

(slot-value (elt *obstacles* 0) 'type)

(reset-obstacles)

(set-ref (slot-value *tabletctl* 'o1-active) nil)

(slot-value *tabletctl* 'o1-active)
(val (o1-active *tabletctl*))

(setf cl-boids-gpu::*check-state* t)


(defun bs-state-recall (num &key (audio t)
                              (note-states t)
                              (cc-state t)
                              (cc-fns t)
                              (obstacles-protect nil)
                              (global-flags nil))
  "recall the state of the boid system in the *bs-presets* array at
num. This is a twofold process: 
1. The boid system has to be resored in the gl-context with #'restore-bs-from-preset.

2. The obstacles, gui, audio and cc-settings have to get reset."
  (let ((bs-preset (aref *bs-presets* num)))
    (setf *audio-suspend* t)
    (if (and global-flags (cl-boids-gpu::load-boids *bp*))
        (when (cl-boids-gpu::bs-positions bs-preset)
          (setf cl-boids-gpu::*switch-to-preset* num) ;;; tell the gl-engine to load the boid-system in the next frame.

;;; handle audio, cc-fns, cc-state and note-states
          (loop
            for (key slot) in '((:num-boids cl-boids-gpu::bs-num-boids)
                                ;;                            (:maxspeed cl-boids-gpu::maxspeed)
                                ;;                            (:maxforce cl-boids-gpu::maxforce)
                                (:speed cl-boids-gpu::speed)
                                (:length cl-boids-gpu::len)
                                (:sepmult cl-boids-gpu::sepmult)
                                (:cohmult cl-boids-gpu::cohmult)
                                (:alignmult cl-boids-gpu::alignmult)
                                (:predmult cl-boids-gpu::predmult)
                                (:maxlife cl-boids-gpu::maxlife)
                                (:lifemult cl-boids-gpu::lifemult))
            do (bp-set-value key (slot-value bs-preset slot)))))


    (format t "~&bs-preset-loaded~%")
    (setf *audio-suspend* nil))
)

(aref *bs-presets* 85)

(bs-state-recall 85 :global-flags t)

(bs-state-save 99)

(aref *obstacles* 0)

(setf (o2-pos *tabletctl*) (make-instance 'value-cell :val '(0.5 0.5)))

(elt (elt *curr-audio-presets* 0) 0)

(replace-audio-preset 99
                      '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
   :ampfn (* (sign) (n-exp y 1 0.5))
   :durfn (* (/ v) (m-exp (mc-ref 14) 0.1 1) (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (expt 2 y) (m-exp (mc-ref 12) 0.25 1) (r-exp 200 200))
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 16) 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :bpfreq (n-exp y 1000 5000)
   :vowel y
   :voicetype (random 5)
   :bprq (m-lin (mc-ref 15) 1 0.01)))

(find-gui :bs1)

(get-all-pla)


(defun set-default-audio-preset (val)
  (if val
      (let ((audio-preset (eval val)))
        (dolist (player '(:default :player1 :player2 :player3 :player4))
          (digest-player-audio-preset-args player audio-preset))
        (gui-set-audio-preset (second val)))
      (warn "no default audio preset!")))

(setf (slot-value (aref *obstacles* 0) 'type) )


(aref *bs-presets* 124)

(getf (getf *curr-preset* :audio-args) :player5)

(digest-audio-args (getf *curr-preset* :audio-args))



(getf (slot-value (elt *bs-presets* 71) 'cl-boids-gpu::audio-args) :player3)

(update-audio-ref)

(defun class-get-model-slot-readers (class-name)
  (let (;;(tmp (make-instance class-name))
         (class (find-class class-name)))
     (c2mop:ensure-finalized class)
     (loop for slot-def in (c2mop:class-direct-slots class)
           for slot-name = (c2mop:slot-definition-name slot-def)
           ;; if (typep (slot-value tmp slot-name) 'model-slot)
             collect (first (c2mop:slot-definition-readers slot-def)))))

(let ((class (find-class 'boid-system-state2)))
  (c2mop:ensure-finalized class)
  (loop for slot-def in (c2mop:class-direct-slots class)
        collect (c2mop:slot-definition-name slot-def)))

  cl-boids-gpu::bs-obstacles

  cl-boids-gpu::midi-cc-state
  cl-boids-gpu::midi-cc-fns cl-boids-gpu::audio-args


(defparameter *test* (make-array 16 :initial-contents (loop for x below 16 collect (make-instance 'obstacle2))))

(copy-obstacles (bs-obstacles *curr-boid-state*) *test*)

(dolist (slot '(alignmult)))

(setf (alignmult *curr-boid-state*) (make-instance 'value-cell :ref (alignmult *bp*)))
(setf (alignmult *curr-boid-state*) (make-instance 'value-cell :ref (alignmult *bp*)))
(setf (alignmult *curr-boid-state*) (make-instance 'value-cell :ref (alignmult *bp*)))
(setf (alignmult *curr-boid-state*) (make-instance 'value-cell :ref (alignmult *bp*)))

'(alignmult
  boids-add-time boids-add-x boids-add-y
  boids-per-click clockinterv cohmult length lifemult
  load-audio load-boids load-obstacles
  maxidx maxlife num-boids
  obstacles-lookahead predmult sepmult speed)

*curr-boid-state*


        (setf (slot-value curr-bs-state 'cl-boids-gpu::bs-preset) *curr-preset*)

(setf (slot-value curr-bs-state 'cl-boids-gpu::speed) (val (cl-boids-gpu::bp-speed *bp*)))
(setf (slot-value curr-bs-state 'cl-boids-gpu::sepmult) (val (cl-boids-gpu::sepmult *bp*)))
(setf (slot-value curr-bs-state 'cl-boids-gpu::cohmult) (val (cl-boids-gpu::cohmult *bp*)))
(setf (slot-value curr-bs-state 'cl-boids-gpu::alignmult) (val (cl-boids-gpu::alignmult *bp*)))
(setf (slot-value curr-bs-state 'cl-boids-gpu::predmult) (val (cl-boids-gpu::predmult *bp*)))
(setf (slot-value curr-bs-state 'cl-boids-gpu::len) (val (cl-boids-gpu::len *bp*)))
(setf (slot-value curr-bs-state 'cl-boids-gpu::maxlife) (val (cl-boids-gpu::maxlife *bp*)))
(setf (slot-value curr-bs-state 'cl-boids-gpu::lifemult) (val (cl-boids-gpu::lifemult *bp*)))

(let ((test (make-instance 'cl-boids-gpu::boid-system-state2)))
  (protect-copy-boid-state *curr-boid-state* test))

*curr-boid-state*
(setf *bs-presets* nil)

(defparameter *bs-presets2* (ucopy *bs-presets*))

(progn
  (cl-store:store *bs-presets2* "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/presets/salzburg-2020-01-23-04b-bs.lisp")
  (format t "done."))

(restore-bs-presets)
*bs-presets-file*


(aref (bs-obstacles (aref *bs-presets* 52)) 0)
(make-instance 'obstacle)

(aref *obstacles* 0)
(setf *bs-presets* nil)
*gl-width*

(defun )


(loop for prest in *bs-presets*)

*bp*

(defun shallow-copy-obstacle2 (src-o dest-o)
  "copy the values of model-slots of src into dest."
  (loop for slot in '(active brightness dtime exists?
                      lookahead moving multiplier pos radius ref target-dpos type)
        do (if (eql slot 'pos)
               (setf (slot-value dest-o slot)
                     (cl-boids-gpu::global->local-pos (if (typep (slot-value src-o slot) 'model-slot) bos(val (slot-value src-o slot))(slot-value src-o slot))))
               (setf (slot-value dest-o slot)
                     (slot-value src-o slot))))
  (setf (slot-value dest-o 'idx) (slot-value src-o 'idx)))

(defun shallow-copy-obstacle3 (src-o dest-o)
  "copy the values of model-slots of src into dest."
  (loop for slot in '(active brightness dtime exists?
                      lookahead moving multiplier pos radius ref target-dpos type)
        do (setf (slot-value dest-o slot)
                 (if (typep (slot-value src-o slot) 'model-slot)
                     (val (slot-value src-o slot))
                     (slot-value src-o slot))))
  (setf (slot-value dest-o 'idx) (slot-value src-o 'idx)))

(defun shallow-copy-obstacles3 (src dest)
  "copy values of obstacles without their refs."
  (map nil (lambda (src-o dest-o) (setf dest-o (shallow-copy-obstacle3 src-o dest-o)))
       src dest))


(aref *bs-presets* 95)

(let ((o nil) (a nil) (b t))
   (or (if o (not obstacles))
      (if a (not audio))
      (if b (not boids))))

(slot-value (aref (bs-obstacles (aref *bs-presets* 40)) 0) 'active)

(slot-value (aref (bs-obstacles (aref *bs-presets* 0)) 0) 'active)

(setf *bs-presets2* (ucopy *bs-presets*))
(setf *bs-presets* nil)

(make-instance 'obstacle)

(audio-args (aref *bs-presets* 86))




(audio-args (aref *bs-presets* 84))

(dotimes (num 128)
  (let ((res (loop for (player props) on (audio-args (aref *bs-presets* num)) by #'cddr
                   for preset-form = (getf props :preset-form)
                   if (= (length preset-form) 2) collect (list num player preset-form))))
    (if res   (format t "~a: ~a~%" num res))))

(audio-args (aref *bs-presets* 73))

(defun bs-repair-audio-args (bs-preset)
  (loop for (player props) on (audio-args bs-preset) by #'cddr
        for preset-form = (getf props :preset-form)
        if (= (length preset-form) 2)
          do (remf props :preset-form)
        append `(,player ,props)))



(bs-repair-audio-args (ucopy (aref *bs-presets* 66)))


(dotimes (idx 128)
  (bs-repair-audio-args (aref *bs-presets* idx)))


(aref *bs-presets* 66)
(aref *bs-presets* num)

(let ((proplist '(:apr 3 :preset-form (1 2 3 4))))
  (remf
   :preset-form))

'(:default
  ((apr 103)
   (:cc-state #(0 109 0 127 0 0 0 58 0 0 0 9 52 0 40 127) :p1 1 :p2 (- p1 1) :p3
    0 :p4 0 :synth 1 :pitchfn (n-exp y 0.1 1) :ampfn
    (* (sign) (n-exp y 2 1) (r-exp 0.3 4)) :durfn
    (* (/ *maxspeed*) (mc-exp 13 0.02 2) (mc-exp-dev 14 4)) :suswidthfn 0.2
    :suspanfn 0 :decaystartfn 0 :decayendfn 0.01 :lfofreqfn
    (* (mc-exp-dev 11 2) (mc-exp 12 1 80)) :xposfn x :yposfn y :wetfn
    (mc-lin 16 0 1) :filtfreqfn (mc-exp 8 1000 10000) :bpfreq (n-exp y 200 5000)
    :vwlinterp (mcn-ref 3) :voicepan (mcn-ref 1) :vowel y :voicetype (random 5)
    :bprq (mc-exp 15 1 0.02))))

(defun rewrite-audio-preset (preset)
  (loop
    with saved-forms = '()
    for (player ((apr num) form)) on preset by #'cddr
    do (if form (push (list num form) saved-forms))
    append (if form
                      `(,player (:apr ,num
                                 :cc-state ,(getf form :cc-state)
                                 :preset-form ,form))
                      `(,player (:apr ,num
                                 :cc-state ,(getf (cadr (assoc num saved-forms)) :cc-state))))))

(dotimes (num 128)
  (setf (audio-args (aref *bs-presets* num))
        (rewrite-audio-preset (audio-args (aref *bs-presets* num)))))

(audio-) (audio-args (aref *bs-presets* 86))


(annotate-audio-preset-form (getf *curr-preset* :audio-args))


(player-audio-preset-num :auto)

(dotimes (num 128)
  (setf (audio-args (aref *bs-presets* num))
        (first (audio-args (aref *bs-presets* num)))))


  (getf
                                       (or form (cadr (assoc num saved forms)))
                                       :cc-state)

(get-audio-args-print-form (audio-args (aref *bs-presets* 86)))
(:default
 (:apr 99 :cc-state #(127 30 127 0 39 127 0 28 0 0 3 123 9 123 96 127)) :auto
 (:apr 99 :cc-state #(127 30 127 0 39 127 0 28 0 0 3 123 9 123 96 127))
 :player1
 (:apr 99 :cc-state #(127 30 127 0 39 127 0 28 0 0 3 123 9 123 96 127))
 :player2 (:apr 37 :cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)) :player3
 (:apr 37 :cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))


(set-cell)

*be

(untrace)

(dotimes (i 128)
  (let ((tmp (make-array 16 :initial-contents (loop for x below 16 collect (make-instance 'obstacle))))
        (bs-obstacles (bs-obstacles (aref *bs-presets* i))))
    (shallow-copy-obstacles3 bs-obstacles tmp)
    (setf (bs-obstacles (aref *bs-presets* i)) tmp)))


(dotimes (i 128)
  (let ((tmp (make-array 16 :initial-contents (loop for x below 16 collect (make-instance 'obstacle))))
        (bs-obstacles (bs-obstacles (aref *bs-presets* i))))
    (shallow-copy-obstacles2 bs-obstacles tmp)
    (setf (bs-obstacles (aref *bs-presets* i)) tmp)))

(let ((test (aref *bs-presets* 0)))
  (with-slots (alignmult) test

    (setf alignmult 3.02))

  )


(let ((audio-args (slot-value (elt *bs-presets* 71) 'cl-boids-gpu::audio-args)))
  (let ((already-processed '()))
    (dolist (player '(:default :player1 :player2 :player3 :player4))
      (player-audio-arg-or-default )

      (push (first ))
      )))


(defun digest-audio-args (defs)
  "digest the audio args (like in a :audio-args property of a preset)"
  (set-default-audio-preset (getf defs :default))
  (loop for (key val) on defs by #'cddr
        do (if (consp (first val))
               (digest-audio-arg key (eval (first val)))
               (digest-audio-arg key (eval val))))
  (update-pv-audio-ref))


(slot-value (elt *bs-presets* 71) 'cl-boids-gpu::audio-args)

'(:default
  ((apr 36)
   (:cc-state #(127 6 9 0 121 127 0 55 18 95 36 54 9 0 122 60) :p1 10 :p2
    (- p1 1) :p3 0 :p4 0 :synth 0 :pitchfn (n-exp y 0.4 1.2) :ampfn
    (* (sign) (+ 0.1 (random 0.6))) :durfn (n-exp y 0.8 0.16) :suswidthfn 0.1
    :suspanfn 0.3 :decaystartfn 0.001 :decayendfn 0.02 :lfofreqfn
    (* (n-exp x 1 1.2)
     (expt (round (* 16 y)) (n-lin x 1 (m-lin (mc-ref 6) 1 1.2)))
     (hertz (m-lin (mc-ref 10) 31 55)))
    :xposfn x :yposfn y :wetfn 0.5 :filtfreqfn (n-exp y 200 10000)))
  :player1
  ((apr 103)
   (:cc-state #(0 109 0 127 0 0 0 58 0 0 0 9 52 0 40 127) :p1 1 :p2 (- p1 1) :p3
    0 :p4 0 :synth 1 :pitchfn (n-exp y 0.1 1) :ampfn (* (sign) (r-exp 1 10))
    :durfn (* (mc-exp 13 0.02 2) (mc-exp-dev 14 4)) :suswidthfn 0.2 :suspanfn 0
    :decaystartfn 0 :decayendfn 0.01 :lfofreqfn (mc-exp 12 1 80) :xposfn x
    :yposfn y :wetfn (mc-lin 16 0 1) :filtfreqfn (mc-exp 8 1000 10000) :bpfreq
    (n-exp y 1000 5000) :vwlinterp (mcn-ref 3) :voicepan (mcn-ref 1) :vowel y
    :voicetype (random 5) :bprq (mc-exp 15 1 0.02)))
  :player2
  ((apr 37)
   (:cc-state #(0 116 54 126 44 0 102 0 0 0 0 0 0 0 0 0) :p1 1 :p2 (- p1 1) :p3
    0 :p4 0 :synth 0 :pitchfn (n-exp y 0.4 1.2) :ampfn
    (* (sign) 0.125 (+ 0.1 (random 0.6))) :durfn (n-exp y 0.8 0.16) :suswidthfn
    0.1 :suspanfn 0.3 :decaystartfn 0.001 :decayendfn 0.02 :lfofreqfn
    (* (n-exp x 1 1.2)
     (expt (round (* 16 y)) (n-lin x 1 (m-lin (mc-ref 6) 1 1.2)))
     (hertz (ewi-nlin tidx 31 55)))
    :xposfn x :yposfn y :wetfn 0.5 :filtfreqfn (n-exp y 200 10000)))
  :player3 ((apr 37) nil))


(untrace)
(digest-audio-preset-form)



(slot-value (elt *bs-presets* 73) 'cl-boids-gpu::audio-args)


(aref *bs-presets* 72)


(dotimes (i 128)
  (let* ((bs-preset (aref *bs-presets* i))
         (audio-args (copy-list (slot-value bs-preset 'cl-boids-gpu::audio-args))))
    (setf (slot-value bs-preset 'cl-boids-gpu::audio-args)
          (loop for (player ((apr num) def)) on audio-args by #'cddr
                for midi-cc-state = (subseq (sub-array (slot-value bs-preset 'cl-boids-gpu::midi-cc-state) (old-player-aref player)) 0 16)
                append (progn
                          (unless (getf def :cc-state) (setf (getf def :cc-state) midi-cc-state))
                          `(,player ((,apr ,num) ,def)))))))

(let ((def '(test 3)))
  (setf )
  )



(let ((bs-preset (aref *bs-presets* 72)))
  (loop for (player def) on (slot-value bs-preset 'cl-boids-gpu::audio-args) by #'cddr
        collect player))

(let ((player 4))
  (subseq (sub-array (slot-value (aref *bs-presets* 72) 'cl-boids-gpu::midi-cc-state) player) 0 16))

(aref  0)

(defun old-player-aref (player)
  (if (eql player :default)
      4 (player-aref player)))


(aref (aref *audio-presets* 0) 1)

(player-aref :player3)

(set-player-cc-state)

(get-players
 )




(digest-preset-audio-args (slot-value (elt *bs-presets* 36) 'cl-boids-gpu::audio-args))



(set-audio-ref)
(digest-audio-preset-form)
(save-current-audio-preset)

(player-audio-arg-or-default :player3  (slot-value (elt *bs-presets* 71) 'cl-boids-gpu::audio-args))

(getf '(:p1 34 :default 72) :p2 (getf '(:p1 34 :default 72) :default))

(if (member :player1 players-to-recall))


(bs-audio-args-recall
 t
 (slot-value (elt *bs-presets* 71) 'cl-boids-gpu::audio-args))

(setf (slot-value (elt *bs-presets* 71) 'cl-boids-gpu::audio-args)
                  (annotate-audio-preset-form (getf *curr-preset* :audio-args)))

(untrace)
(find-controller :nk2)
(setf *tabletctl* nil)
(clear-refs *tabletctl*)
(set-refs *tabletctl*)

(list (val (cl-boids-gpu::boids-add-x cl-boids-gpu:*bp*))
      (val (cl-boids-gpu::boids-add-y cl-boids-gpu:*bp*)))

(0.0010080645 0.71326166)
(0.5221774 0.97849464)

(set-ref)

(funcall (ref-set-hook (o1-pos *tabletctl*)) '(0.2 0.2))

(set-cell (slot-value (elt *obstacles* 0) 'pos) '(0.5 0.5))

(osc-out *tabletctl*)

(setf (obstacle-pos (elt *obstacles* 0)) '(0.5 0.1))
(setf (val (o1-pos *tabletctl*)) '(0.7 0.4))

(setf (obstacle-brightness (elt *obstacles* 0)) 0.8)


(setf (obstacle-type (elt *obstacles* 1)) 2.0)
(setf (obstacle-type (elt *obstacles* 0)) 2.0)



(funcall (ref-set-hook (o1-pos *tabletctl*)) '(0.2 0.2))

  (when (eql key #\q)
    (gl-set-obstacle-type luftstrom-display::*mouse-ref* +nointeract+))
  (when (eql key #\w)
    (gl-set-obstacle-type luftstrom-display::*mouse-ref* +trigger+))
  (when (eql key #\e)
    (gl-set-obstacle-type luftstrom-display::*mouse-ref* +obstacle+))
  (when (eql key #\r)
    (gl-set-obstacle-type luftstrom-display::*mouse-ref* +attractor+))
  (when (eql key #\t)
    (gl-set-obstacle-type luftstrom-display::*mouse-ref* +predator+))


(let ((obstacle (elt *obstacles* 0)))
  (setf (set-cell-hook (slot-value obstacle 'pos))
        (lambda (pos)
          (destructuring-bind (x y) pos
            (cl-boids-gpu::gl-enqueue
             (lambda () 
               (cl-boids-gpu::set-obstacle-position
                cl-boids-gpu::*win* (idx obstacle)
                (* cl-boids-gpu::*real-width* x) (* cl-boids-gpu::*height* (- 1 y)))))))))

(setf (set-cell-hook (slot-value (elt *obstacles* 0) 'pos)) #'identity)

(aref (buttons (find-gui :bs1)) 6)
(untrace)

(digest-audio-args-preset
 '(:cc-state #(127 0 21 127 27 121 124 127 127 1 0 0 0 0 0 17)
   :p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
   :ampfn (* (sign) (n-exp y 1 0.5))
   :durfn (* (/ v) (m-exp (mc-ref 6) 0.1 1) (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (m-exp (mc-ref 4) 0.25 1) (r-exp 45 45))
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 8) 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :voicepan (mcn-ref 1)
   :voicetype (random 5)
   :vowel (random 1.0)
   :bpfreq (n-exp y 100 5000)
   :bprq (m-lin (mc-ref 7) 1 0.01)
   :bppan (mcn-ref 9))
 (aref *audio-presets* 0))

(funcall (m-exp-rd-rev-fn 1 500) 64)
(funcall (m-exp-rd-rev-fn 1 500) 64)

*tabletctl*

'beatstep-gui

(let ((cc-fns (cl-boids-gpu::midi-cc-fns (aref *bs-presets* 0))))
  (loop
    for player in cc-fns
    for value = (getf saved-cc-fns player)
    do (loop
         for (key cc-def) on (funcall #'cc-preset player value) by #'cddr
         do (with-cc-def-bound (fn reset) cc-def
              (declare (ignore reset))
              (digest-cc-def key fn saved-cc-state :reset nil)))))

(bs-state-recall 2 :cc-fns nil)

(loop
  for i below (* 6 128)
  do (setf (row-major-aref *cc-fns* i) #'identity))

(aref *bs-presets* 23)

*cc-state*

(defparameter *m1* (make-instance 'model-slot))

(defparameter *t1* (make-instance 'value-cell :ref *m1*))

(setf (val *t1*) 31.2)

(setf (val *m1*) 30.2)

(defparameter *cc-array* #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))


(set-nk2-std)

(let ((id :nk2-2) (chan 1))
  (make-instance 'nanokontrol :id id :chan chan))

(aref (cuda-gui::param-boxes (find-gui :nk2-2)) 7)

(let ((gui (find-gui :nk2-2)))
  (set-ref (aref (cuda-gui::param-boxes gui) 7)
           (cl-boids-gpu::len *bp*)
           :map-fn (m-lin-rd-fn 5 250)
           :rmap-fn (m-lin-rd-rev-fn 5 250)))

*audio-preset-ctl-model*

(set-cell)
(defmethod set-ref ((instance label-spinbox) new-ref &key map-fn rmap-fn)
  (with-slots (ref) instance
    (when ref (setf (dependents ref) (delete instance (dependents ref))))
    (setf ref new-ref)
    (if new-ref
        (progn
          (pushnew instance (dependents new-ref))
          (if map-fn (setf (map-fn instance) map-fn))
          (if rmap-fn (setf (rmap-fn instance) rmap-fn))
          (ref-set-cell instance (slot-value new-ref 'val)))))
  new-ref)







(defclass array-cell (value-cell)
  ((a-ref :initform nil :initarg :a-ref :accessor a-ref)))

(defmethod ref-set-cell ((instance array-cell) new-val)
  (with-slots (val a-ref) instance
    (setf (slot-value instance 'val) new-val)
    (setf (aref *cc-array* a-ref) new-val)))

(defparameter *a1* (make-instance 'array-cell :a-ref 1 :ref *m1*))

*cc-array*
()

*cc-model*

(defmethod aref ((instance array-cell) idx))

(setf *midi-debug* nil)

(player-aref :bs1)

(find-controller :nk2)
(player-aref :player1)
(player-aref :default)

(set-ref (aref (cuda-gui::param-boxes (find-gui :nk2)) 8)
         (cl-boids-gpu::bp-speed *bp*)
         :map-fn (m-exp-fn 0.1 20)
         :rmap-fn (m-exp-rev-fn 0.1 20))

(in-package :luftstrom-display)

(set-ref (aref (cuda-gui::param-boxes (find-gui :nk2)) 13)
         (cl-boids-gpu::lifemult *bp*)
         :map-fn (m-lin-fn 0 500)
         :rmap-fn (m-lin-rev-fn 0 500))

(let ((instance (find-gui :ewi1)))
  (cuda-gui::emit-signal (cuda-gui::ewi-type instance) "incValue(int)" -1))

(let ((instance (find-gui :ewi1)))
  (cuda-gui::emit-signal (cuda-gui::ewi-type instance) "incValue(int)" -1))

(cuda-gui::init-gui-callbacks (find-gui :ewi1))

(cuda-gui::inc-obst-type (find-gui :ewi1))
(cuda-gui::dec-obst-type (find-gui :ewi1))

(let ((instance (slot-value (find-gui :ewi1) 'cuda-gui::ewi-type))
      (value 0))
  (set-cell (cuda-gui::ref instance) (funcall (cuda-gui::map-fn instance) value) :src instance))

(set-cell (slot-value (aref *obstacles* 0) 'type) 4)

(setf (set-cell-hook (slot-value (aref *obstacles* 0) 'type)) #'identity)

(dotimes (i 4)
  (setf (set-cell-hook (slot-value (aref *obstacles* i) 'type))
          (lambda (type)
            (declare (ignore type))
            (reset-obstacles))))

(loop for i below 4
      collect (list (obstacle-ref (aref *obstacles* i))
                    (map-type (obstacle-type (aref *obstacles* i)))
                    (obstacle-active (aref *obstacles* i))
                    (obstacle-idx (aref *obstacles* i))))

((1 4 t 0) (0 3 nil 1) (2 0 nil 2) (3 0 nil 3))

(set-cell (slot-value (aref luftstrom-display::*obstacles* 0) 'luftstrom-display::pos)
                  (list 0.3 0.1))

(remove-osc-controller :tab1)
(defparameter *tabletctl*
  (make-instance 'obstacle-ctl-tablet
                 :id :tab1
                 :osc-in *osc-obst-ctl*
                 :remote-ip *ip-galaxy*
                 :remote-port 3090))



((0 3 nil 0) (1 3 nil 1) (2 4 nil 2) (3 0 nil 3))
((1 4 nil 0) (0 3 nil 1) (2 4 nil 2) (3 0 nil 3))



((0 4 t 0) (1 3 nil 1) (2 4 nil 2) (3 0 nil 3))
((1 4 t 0) (2 4 nil 1) (0 4 nil 2) (3 0 nil 3))

(setf (val (o1-pos *tabletctl*)) (list 0.5 0.2))

(o1-pos *tabletctl*)

(setf )

(o2-pos *tabletctl*)


(set-ref (o1-pos *tabletctl*) nil)

(setf (ref-set-hook (o1-pos *tabletctl*)) #'identity)

(setf (slot-value (slot-value *tabletctl* 'o1-pos) 'cellctl::ref) nil)

(set-ref (slot-value *tabletctl* 'o1-pos) (slot-value (aref *obstacles* 1) 'pos))


(setf (dependents (slot-value (aref *obstacles* 1) 'pos)) nil)

(set-cell (slot-value (aref *obstacles* 1) 'pos) '(0.5 0.5))

(setf (set-cell-hook (slot-value (aref *obstacles* 0) 'pos)) #'identity)



((2 4 t 0) (0 3 nil 1) (1 3 nil 2) (3 0 nil 3))
((1 4 t 0) (0 3 nil 1) (2 3 nil 2) (3 0 nil 3))

(setf (slot-value (slot-value (aref *obstacles* 0) 'type) 'val) 2)

(obstacle 0)
(reset-obstacles)


(let ((instance (find-osc-controller :tab1))
      (x 0.5) (y 0.1))
  (setf (val (funcall (string->function (format nil "o~d-pos" 1)) instance))
        (list x y)))

(aref *obstacles* 0)

(setf (val (o1-pos (find-osc-controller :tab1))) '(0.1 0.5))


(set-cell-hook)
(ref-set-cell)
(setf (val (o1-type (find-osc-controller :tab1))) 3)

(setf (val (o1-type (find-osc-controller :tab1))) 4)

(cuda-gui::ref-set-cell)

(remove-osc-controller :tab1)

(setf (audio-args (aref *bs-presets* 0)) nil)

(setf (getf (getf (audio-args (aref *bs-presets* 0)) :default) :cc-state)
      (getf (getf (audio-args (aref *bs-presets* 0)) :auto) :cc-state))

(reset-obstacles)

(copy-seq *obstacles*)

((2 4 t 0) (0 3 nil 1) (1 3 nil 2) (3 0 nil 3))
((0 4 t 0) (1 3 nil 1) (2 3 nil 2) (3 0 nil 3))
(reset-obstacles)

(untrace)



(find-controller :tab1)

(cuda-gui::set-pvb-value)
(set-cell (slot-value (aref *obstacles* 0) 'type) 2)

(cuda-gui::remove-model-refs (find-gui :ewi1))

(set-refs (find-osc-controller :ewi1))

(ref-set-cell (slot-value (find-gui :ewi1) 'cuda-gui::ewi-type) 3)

(funcall (ref-set-hook (slot-value (find-gui :ewi1) 'cuda-gui::ewi-type)) 1)

(let ((instance (slot-value (find-gui :ewi1) 'cuda-gui::ewi-type)))
  (cuda-gui::emit-signal instance "setValue(int)"
               (funcall (rmap-fn instance) 1)))

(find-osc-controller :tab1)

(set-cell)


(setf (obstacle-brightness (elt *obstacles* 0)) 0.8)
(setf (obstacle-pos (elt *obstacles* 0)) '(0.5 0.1))



*osc-out*

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   (format nil "/recallPresetState") "ff" (float 3.0) (float 1.0)))

(let ((osc-out (osc-out (find-osc-controller :tab-p1))))
  (incudine.osc:message
   osc-out
   (format nil "/slider") "ff" (float 3.0) (float 1.0)))

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   (format nil "/presetNo") "f" (float 1)))

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   (format nil "/obstActive") "f" (float 0)))

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   (format nil "/obstType") "f" (float 3)))

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   (format nil "/obstVolume") "f" (float 0.8)))

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   (format nil "/obstPos") "ff" (float 0.5) (float 0.5)))

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   (format nil "/cpObstacles") "f" (float 1.0)))

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   (format nil "/cpAudio") "f" (float 1.0)))

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   (format nil "/cpBoids") "f" (float 0)))

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   (format nil "/saveState") "f" (float 0)))

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   (format nil "/cpState") "f" (float 1)))

(let ((osc-out (osc-out (find-osc-controller :tab1))))
  (incudine.osc:message
   osc-out
   "/playerIdx" "f" (float 0)))



(defparameter *test* (make-array 16 :element-type 'single-float :initial-element 0.0))


(defmethod init-gui-callbacks ((instance ewi-gui) &key (echo nil))
  (declare (ignore echo))
  (format t "~&init-gui-callbacks: ~a" instance)
  (setf (callback (l6-a instance))
        (lambda () (cuda-gui::emit-signal (ewi-type instance) "incValue(int)" -1)))
  (setf (cuda-gui::callback (l6-b instance))
        (lambda () (cuda-gui::emit-signal (ewi-type instance) "incValue(int)" 1)))
  (setf (callback (l6-c instance))
        (lambda () (cuda-gui::emit-signal (ewi-apr instance) "incValue(int)" -1)))
  (setf (callback (l6-d instance))
        (lambda () (cuda-gui::emit-signal (ewi-apr instance) "incValue(int)" 1))))




(toggle-obstacle 0)
(set-nk2-std (find-gui :nk2))

(set-cell (cl-boids-gpu::bp-speed *bp*) 10.6)

(funcall (m-exp-rev-fn 0.1 20) 5.49)

(cl-boids-gpu::bp-speed cl-boids-gpu::*bp*)

(set-cell (cl-boids-gpu::bp-speed cl-boids-gpu::*bp*) 0.5)

(set-cell (cl-boids-gpu::bp-speed cl-boids-gpu::*bp*) 0.5)

(bp-set-value)

(make-instance 'boid-params)
'cl-boids-gpu::boid-params

*bp*


(defparameter *test* (make-instance 'value-cell :ref (num-boids *bp*)))

(setf (cdr (cellctl::dependents (num-boids *bp*))) nil)

(cellctl::set-ref *test* (alignmult *bp*))
(cellctl::set-ref *test* (num-boids *bp*))

(cellctl::set-ref *test* nil)


(untrace)
(set-cell (cl-boids-gpu::bp-speed *bp*) 1.9)

(set-cell (cl-boids-gpu::alignmult *bp*) 1.2)

(set-cell (cl-boids-gpu::lifemult *bp*) 200.4)

(set-ref (getf (gethash :speed *param-gui-pos*) :gui)
         (cl-boids-gpu::bp-speed *bp*))

(slot-value *bp* (intern (symbol-name :alignmult) 'cl-boids-gpu))

(getf (gethash :alignmult *param-gui-pos*) :gui)



*curr-preset*


(:boid-params
 (:num-boids 10 :boids-per-click 50 :clockinterv 0 :speed 2.0
  :obstacles-lookahead 2.5 :obstacles ((1 25) (1 25) (1 25) (1 25))
  :curr-kernel "boids" :bg-amp 1.0 :maxspeed 4.302512 :maxforce 0.3687868
  :maxidx 317 :length 5 :sepmult 2.488189 :alignmult 5.850394 :cohmult
  2.8740158 :predmult 1 :maxlife 60000.0 :lifemult 0.0 :max-events-per-tick 10)
 :audio-args
 (:default (apr 0) :player1 (apr 1) :player2 (apr 2) :player3 (apr 3) :player4
  (apr 4))
 :midi-cc-fns
 (:nk2 :nk2-std2 :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
  :player4 :life-ctl1 (:nk2 6)
  (with-lin-midi-fn (0 50)
    (setf *clockinterv* (round (funcall ipfn d2)))))
 :midi-cc-state
 #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     (89 27 34 88 45 0 0 90 0 0 0 0 0 0 0 0 75 0 0 0 127 127 127 127 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))




(cl-boids-gpu::timer-add-boids 1000 10 :origin '(0.5 0.5))

(recalc-coords '(0.5 0.5))



*width*

*gl-scale*
*width*

(cl-boids-gpu::timer-remove-boids 20000 20000 :fadetime 0)

(with-cc-def-bound (fn reset) cc-def
  (digest-cc-def key fn old-cc-state :reset reset))

(cd "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/")

(defparameter *presets*
  (make-array 100 :initial-element nil))
(defparameter *curr-preset* nil)
(defparameter *presets-file* "presets/schwarm01.lisp")

;;; (setf *presets-file* "presets/schwarm-18-10-06.lisp")
;;; (load-presets)

(defparameter *curr-preset-no* 0)

(defun previous-preset ()
  (let ((next-no (max 0 (1- *curr-preset-no*))))
    (if (/= next-no *curr-preset-no*)
        (progn
          (setf *curr-preset-no* next-no)
          (qt:emit-signal (find-gui :pv1) "setPreset(int)" *curr-preset-no*)
          (edit-preset-in-emacs *curr-preset-no*)))
    *curr-preset-no*))

#|
(qt:emit-signal (find-gui :pv1) "setPreset(int)" 3)
(previous-preset)
|#

(defun next-preset ()
  (let ((next-no (min 127 (1+ *curr-preset-no*))))
    (if (/= next-no *curr-preset-no*)
        (progn
          (setf *curr-preset-no* next-no)
          (qt:emit-signal (find-gui :pv1) "setPreset(int)" *curr-preset-no*)
          (edit-preset-in-emacs *curr-preset-no*)))
    *curr-preset-no*))

(defun setf-fixed-cc-fns ()
  (setf (aref *cc-fns* 0 58)
        (lambda (d2)
          (if (= d2 127)
              (previous-preset))))

  (setf (aref *cc-fns* 0 46)
        (lambda (d2)
          (if (= d2 127)
              (edit-preset-in-emacs *curr-preset-no*))))

  (setf (aref *cc-fns* 0 59)
        (lambda (d2)
          (if (= d2 127)
              (next-preset)))))

(defun preset->string (preset)
  (format nil "(progn
  (setf *curr-preset*
        (copy-list
         (append
          '(:boid-params
            (~s ~s~&~{~{~s ~s~}~^~%~})
            :audio-args
            (~s ~s~&~{~{~s ~s~}~^~%~})
            :midi-cc-fns
            (~{~{(~s~&~s)~}~^~&~}))
            `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))"
          (car (getf preset :boid-params))
          (cadr (getf preset :boid-params))
          (loop for (key val) on (cddr (getf preset :boid-params)) by #'cddr collect (list key val))
          (car (getf preset :audio-args))
          (cadr (getf preset :audio-args))
          (loop for (key val) on (cddr (getf preset :audio-args)) by #'cddr collect (list key val))
          (loop for (key val) in (getf preset :midi-cc-fns) collect (list key val))))


;;;(preset->string *curr-preset*)

(defun preset-audio-args (preset)
  (format nil "~&~{~{:~a ~a~}~^~%~}"
          (loop for (key val) on (getf preset :audio-args) by #'cddr collect (list key val))))

;;; (preset-audio-args *curr-preset*)

(defun preset-midi-cc-fns (preset)
  (format nil "~&~{~{~a ~a~}~^~%~}"
          (loop for (key val) on (getf preset :midi-cc-fns) by #'cddr append (list key val))))

;;; (preset-midi-cc-fns *curr-preset*)

(defun set-value (param val)
  (gui-set-param-value param val)
  (set-param-from-key param val))

;; (bp-set-value :alignmult 3)

;; (bp-set-value :curr-kernel "boids")

(defparameter *emcs-conn* swank::*emacs-connection*)

(defun keynum->coords (keynum)
  (let ((kn (- (max 24 (min 107 keynum)) 24)))
    (multiple-value-bind (y x) (floor kn 12)
      (values (round (* (/ (+ 0.5 x) 12) *gl-width*))
              (round (* (- 1 (/ (+ 0.5 y) 7)) *gl-height*))))))

;;; (keynum->coords 107)

;;; (coords->keynum 1467 0)

;;; (floor 61 12)
#|

tiefster Ton: 22
höchster Ton: 110

mapping: 24 107

(/ (- 108 24) 12)

(- (floor 107 12) 2)
|#

(defun coords->keynum (x y)
  (+ 24
     (round (* (/ x *gl-width*) 12))
     (* 12 (round (* (- 1 (/ y *gl-height*)) 7)))))

(defun predator-sort (seq)
  (sort seq #'> :key #'fourth))

(defun set-obstacle-ref (obstacles)
  (dotimes (i 4)
    (setf (aref *obstacle-ref* i) nil))
  (loop
     for o across obstacles
     for idx from 0
     do (setf (obstacle-ref o) idx)))

(defun set-obstacles (val)
  (setf *obstacles* val)
  (let ((win cl-boids-gpu::*win*)
        (new-obstacles
         (predator-sort
          (loop
             for o in *obstacles*
             for idx from 0
             append (if o (multiple-value-bind (x y) (keynum->coords (aref *notes* idx))
                            (list (append (list idx x y) o))))))))
    (if win
        (progn
          (clear-obstacles win)
          (gl-set-obstacles win new-obstacles)
          (set-obstacle-ref new-obstacles)))))

;;; (clear-obstacles (cl-boids-gpu::systems cl-boids-gpu::*win*))

(defun incudine.scratch::move-test (time num)
  (if (> num 0)
      (let ((next (+ time 10000.3)))
        (format t "~&next: ~a" num)
        (incudine:at next
          #'incudine.scratch::move-test next (decf num)))))

;;; (incudine.scratch::move-test (now) 4)


#|

|#
;;; (move-test (now) 4)



;;; *obstacle-ref*

#|
(%update-system)
(loop
   for v in val
   for ch below 4
   with idx = -1
   do (if v
          (destructuring-bind (type radius) v
            (multiple-value-bind (x y) (keynum->coords (aref *notes* ch))
              (case type
                (0 (new-predator win x y radius))
                (otherwise (new-predator win x y radius))))
            (setf (aref *obstacle-ref* ch) (incf idx)))))

(new-obstacle *win* 100 300 20)
(new-obstacle *win* 300 100 20)
(new-obstacle *win* 500 1000 20)
(new-obstacle *win* 200 430 20)
(new-obstacle *win* 500 150 40)

(new-predator *win* 300 240 20)

(delete-obstacle *win* 1)

|#

(defun digest-boid-param (key val)
  (case key
    (:num-boids (bp-set-value key *num-boids*))
    (:obstacles (set-obstacles val))
    (t (bp-set-value key val))))


(defun load-preset (ref &key (presets *presets*))
  (let ((preset (if (numberp ref) (aref presets ref) ref)))
    (if preset
        (progn
          (loop for (key val) on (getf preset :boid-params) by #'cddr
             do (digest-boid-param key val))
          (gui-set-audio-args (preset-audio-args preset))
          (gui-set-midi-cc-fns (preset-midi-cc-fns preset))
          (clear-cc-fns)
          (loop for (coords def) in (getf preset :midi-cc-fns)
             do (progn
                  (setf (apply #'aref *cc-fns* coords)
                        (eval def))
                  (funcall
                   (apply #'aref *cc-fns* coords)
                   (apply #'aref (getf preset :midi-cc-state) coords))))
          (digest-arg-fns (getf preset :audio-args))
          (setf *curr-preset* preset)
          ))))

(defun edit-preset-in-emacs (ref &key (presets *presets*))
  (let ((swank::*emacs-connection* *emcs-conn*))
    (if (numberp ref)
        (swank::eval-in-emacs `(edit-preset
                                ,(progn
                                   (in-package :luftstrom-display)
                                   (preset->string (aref presets ref))) ,(format nil "~a" ref)) t)
        (swank::eval-in-emacs `(edit-preset ,(preset->string ref) ,(format nil "~a" *curr-preset-no*)) t))))

;;; (preset->string (aref *presets* 0))

;;; (load-presets 3)
;;; (load-preset *curr-preset*)

;;; (snapshot-curr-preset)
;;; *num-boids*

(defun capture-preset (preset)
  (setf (getf preset :boid-params)
        (loop for (key val) on (getf preset :boid-params) by #'cddr
           append (capture-param key val)))
  preset)

(defun clear-cc-fns ()
  (loop for x below 6
     do (loop for idx below 128
           do (setf (aref *cc-fns* x idx) #'identity)))
  (setf-fixed-cc-fns))

;;; (clear-cc-fns)

(defun snapshot-curr-preset ()
  (let ((preset (capture-preset *curr-preset*)))
        (progn
          (digest-params preset)
          (loop for (param val) on (getf preset :boid-params) by #'cddr
             do (bp-set-value param val))
          (gui-set-audio-args (preset-audio-args preset))
          (gui-set-midi-cc-fns (preset-midi-cc-fns preset))
          (clear-cc-fns)
          (loop for (coords def) in (getf preset :midi-cc-fns)
             do (progn
                  (setf (apply #'aref *cc-fns* coords)
                        (eval def))
                  (funcall
                   (apply #'aref *cc-fns* coords)
                   (apply #'aref (getf preset :midi-cc-state) coords))))
          (loop for (chan def) in (getf preset :note-fns)
             do (progn
                  (setf (aref *note-fns* chan)
                        (eval def))
                  (funcall
                   (aref *note-fns* chan)
                   (aref (getf preset :midi-note-state) chan))))
          (setf *curr-preset* preset)
          (edit-preset-in-emacs *curr-preset*))))

#|
(progn
  (setf *curr-preset*
        (copy-list
         (append
          '(:boid-params
            (:num-boids nil
             :clockinterv 50
             :speed 2.0
             :obstacles-lookahead 2.5
             :maxspeed 0.85690904
             :maxforce 0.07344935
             :maxidx 317
             :length 5
             :sepmult 168/127
             :alignmult 343/127
             :cohmult 245/127
             :predmult 1
             :maxlife 60000.0
             :lifemult 100.0
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (+ 0.1 (* 0.6 y))
             :ampfn (* (sign) (+ (* 0.03 (expt 16 (- 1 y))) (random 0.01)))
             :durfn (* (expt 1/3 y) 1.8)
             :suswidthfn 0.1
             :suspanfn 0.1
             :decay-startfn 0.001
             :decay-endfn 0.002
             :lfo-freqfn (* 50 (expt 5 (/ (aref *cc-state* 0 7) 127))
                          (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
             :x-posfn x
             :y-posfn y
             :wetfn 1
             :filt-freqfn 20000)
            :midi-cc-fns
            (((0 0)
              (with-exp-midi (0.1 2)
                (let ((speedf (funcall ipfn d2)))
                  (bp-set-value :maxspeed (* speedf 1.05))
                  (bp-set-value :maxforce (* speedf 0.09)))))
             ((0 1)
              (with-lin-midi (1 8)
                (bp-set-value :sepmult (funcall ipfn d2))))
             ((0 2)
              (with-lin-midi (1 8)
                (bp-set-value :cohmult (funcall ipfn d2))))
             ((0 3)
              (with-lin-midi (1 8)
                (bp-set-value :alignmult (funcall ipfn d2))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (digest-params *curr-preset*)
  (load-preset *curr-preset*))
|#

#|
(progn
  (digest-params *curr-preset*)
  (load-preset *curr-preset*))
|#

(defun store-curr-preset (num &key (presets *presets*))
  "store current preset as specified."
  (let ((state (copy-list *curr-preset*)))
    (setf (getf state :midi-cc-state) (alexandria:copy-array *cc-state*))
    (setf (aref presets num) state))
  (values))

;;; (store-curr-preset 1)


(defun state-store-curr-preset (num &key (presets *presets*))
  "store current preset but use the current state of the boid-params."
  (let ((state (copy-list *curr-preset*)))
    (setf (getf *curr-preset* :boid-params)
          (loop for (key val) on (getf *curr-preset* :boid-params) by #'cddr
             append (capture-param key val)))
    (setf (getf state :midi-cc-state) (alexandria:copy-array *cc-state*))
    (setf (aref presets num) state))
  (values))

;;; (state-store-curr-preset 1)

;;; (load-preset 5)
;;; (load-preset (aref *presets* 1))


(defun save-presets (&key (file *presets-file*))
  (with-open-file (out file :direction :output :if-exists :supersede)
    (format out "(in-package :luftstrom-display)~%~%(setf *presets*~&~s)" *presets*))
  (format nil "presets written to ~a" file))

;;; (save-presets :file "presets/schwarm-18-10-03-02.lisp")

(defun load-presets (&key (file *presets-file*))
  (load file))

(load-presets)
(load-preset (aref *presets* 0))

(defparameter *obst-move-time* 0.4)

(setf (aref *note-fns* 0)
      (lambda (d1) (multiple-value-bind (x y) (keynum->coords d1)
                (time-move-obstacle-abs x y 0 *obst-move-time*))))
(setf (aref *note-fns* 1)
      (lambda (d1) (multiple-value-bind (x y) (keynum->coords d1)
                (time-move-obstacle-abs x y 0 *obst-move-time*))))
(setf (aref *note-fns* 2)
      (lambda (d1) (multiple-value-bind (x y) (keynum->coords d1)
                (time-move-obstacle-abs x y 0 *obst-move-time*))))
(setf (aref *note-fns* 3)
      (lambda (d1) (multiple-value-bind (x y) (keynum->coords d1)
                (time-move-obstacle-abs x y 0 *obst-move-time*))))

;;; (setf *length* 105)

(defun move-test (time num)
  (if (> num 0)
      (let ((next (+ time 0.3)))
        (format t "step, ")
        (at next
          #'move-test next (decf num)))))

;;; (move-test (now) 4)

(defun time-move-obstacle-abs (x y player-ref &optional (time 0))
  "linearly move obstacle of player-ref to new x and y positions in
duration given by time (in seconds)."
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (cl-boids-gpu::systems window)))
         old-x old-y)
    (if bs
        (progn
          (ocl:with-mapped-buffer
              (p1 (car (cl-boids-gpu::command-queues window))
                  (cl-boids-gpu::obstacles-pos bs) 4
                  :offset (* cl-boids-gpu::+float4-octets+ (aref cl-boids-gpu::*obstacle-ref* player-ref))
                  :write t)
            (setf old-x (cffi:mem-aref p1 :float 0))
            (setf old-y (- (glut:height window) (cffi:mem-aref p1 :float 1))))
          (let* ((maxpixels (max (abs (- x old-x))
                                 (abs (- y old-y))))
                 (frames (* time 60))
                 (num-steps (max 1 (min frames maxpixels)))
                 (dtime (/ time num-steps))
                 (now (now))
                 (dx (/ (- x old-x) num-steps))
                 (dy (/ (- y old-y) num-steps)))
;;            (format t "~&~a ~a ~a ~a" old-x old-y x y)
            (loop for count below num-steps
               for curr-x = (incf old-x dx) then (incf curr-x dx)
               for curr-y = (incf old-y dy) then (incf curr-y dy)
               do (at (+ now (float (* count dtime)))
                    #'cl-boids-gpu::move-obstacle-abs (round curr-x) (round curr-y) player-ref))))
        (setf (aref luftstrom-display::*notes* player-ref)
              (luftstrom-display::coords->keynum x (- (glut:height window) y))))))

#|

(time-move-obstacle-abs 200 200 0 0.2)
(time-move-obstacle-abs 600 500 0 0.2)
(time-move-obstacle-abs 602 503 0 0.2)


(time-move-obstacle-abs 200 200 0)
(time-move-obstacle-abs 900 800 0)

|#


(defun make-move-fn (player &key (dir :up) (max 100) (ref nil) (clip nil))
  (let ((moving nil)
        (dv 0)
        (window cl-boids-gpu::*win*)
        (clip clip))
    (lambda (d2)
      (labels
          ((inner (time)
             (if moving
                 (let ((next (+ time 0.1)))
                   (move-obstacle-rel
                    player
                    (or (if ref (aref *cc-state** player ref))
                        dir)
                    window :delta (m-exp dv 1 max)
                    :clip clip)
                   (at next #'inner next)))))
        (if (zerop d2) (setf moving nil)
            (progn
              (setf dv d2)
              (if (not moving)
                  (progn
                    (setf moving t)
                    (inner (now))))))))))

(defun make-move-fn2 (player &key (dir :up) (max 100) (ref nil) (clip nil))
  (let ((moving nil)
        (dv 0)
        (window cl-boids-gpu::*win*)
        (clip clip))
    (lambda (d2)
      (labels
          ((inner (time)
             (if moving
                 (let ((next (+ time 0.1)))
;;                   (format t "~&~a" (aref *cc-state** player ref))
                   (move-obstacle-rel
                    player
                    dir
                    window :delta (if ref (m-exp (aref *cc-state* player ref) 10 max)
                                      10)
                    :clip clip)
                   (at next #'inner next)))))
        (if (zerop d2) (setf moving nil)
            (progn
              (setf dv 1)
              (if (not moving)
                  (progn
                    (setf moving t)
                    (inner (now))))))))))

(defstruct mvobst
  (target-dx 0.0 :type float)
  (target-dy 0.0 :type float)
  (dtime 0.0 :type float)
  (active nil :type boolean))

(defparameter *move-obst* (make-array '(4) :element-type 'mvobst :initial-contents (loop for idx below 4 collect (make-mvobst))))

;;; (setf (mvobst-xtarget (aref *move-obst* 0)) 3.1)

;;; (setf (mvobst-xtarget (aref *move-obst* 0)) (+ x dv))
;;; (unless (mvobst-active (aref *move-obst* 0))



#|
(defparameter *my-mv-fn*
    (make-move-fn 0 :up 100 nil))

(funcall *my-mv-fn* 0)

bewegt sich immer so schnell, wie möglich zum Zielwert

bei Funktionsaufruf der Bewegungsfunktion:


|#

(defun make-move-fn3 (player &key (dir :up) (max 100) (ref nil) (clip nil))
  "assign a function which can be bound to be called each time, a new
event (like a cc value) is received."
  (let ((window cl-boids-gpu::*win*)
        (clip clip)
        (mv-obst (aref *move-obst* player)))
    (lambda (d2)
      (labels ((inner (time)
                 "recursive function (with time delay between calls)
moving the obstacle framewise. As different gestures could trigger an
instance of the function (assigning a new instance by calling
'make-move-fn3) only one of it is run at a time for each
obstacle (assured by testing the 'active slot in the mvobst
struct). The target-dx and target-dy slots can get reassigned by all
assigned gestures while the function is running. The function
terminates if the dx and dy are both 0, (setting the 'active slot back
to nil so that it can get retriggered)."
                 (with-slots (target-dx target-dy) mv-obst
                   (let* ((x-dist (abs target-dx))
                          (y-dist (abs target-dy))
                          (max-dist (max x-dist y-dist))
                          (dx 0) (dy 0))
                     (if (> max-dist 0)
                         (progn
                           (unless (zerop x-dist)
                             (if (< x-dist 10)
                                 (setf dx (signum target-dx))
                                 (setf dx (round (/ target-dx 10))))
                             (decf target-dx dx))
                           (unless (zerop y-dist)
                             (if (< y-dist 10)
                                 (setf dy (signum target-dy))
                                 (setf dy (round (/ target-dy 10))))
                             (decf target-dy dy))
                           (move-obstacle-rel-xy player dx dy window :clip clip)
                           (let ((next (+ time (/ 60.0)))) (at next #'inner next)))
                         (setf (mvobst-active (aref *move-obst* player)) nil))))))
    ;;; lambda-function entry point
        (if (> d2 0)
            (progn
              (format t "~&received: ~a" d2)
              (case dir
                (:left (setf (mvobst-target-dx (aref *move-obst* player))
                             (float (* -1 (if ref (m-exp (aref *cc-state* player ref) 10 max) 10.0)))))
                (:right (setf (mvobst-target-dx (aref *move-obst* player))
                              (float (if ref (m-exp (aref *cc-state* player ref) 10 max) 10.0))))
                (:down (setf (mvobst-target-dy (aref *move-obst* player))
                             (float (* -1 (if ref (m-exp (aref *cc-state* player ref) 10 max) 10.0)))))
                (:up (setf (mvobst-target-dy (aref *move-obst* player))
                           (float (if ref (m-exp (aref *cc-state* player ref) 10 max) 10.0)))))
              (unless (mvobst-active (aref *move-obst* player))
                (setf (mvobst-active (aref *move-obst* player)) t)
                (inner (now)))))))))

(setf (mvobst-active (aref *move-obst* 0) ) nil)
;;; (move-obstacle-rel-xy player dx dy window :clip clip)


(in-package :luftstrom-display)

;;; preset: 0

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 0
             :boids-per-click 5
             :clockinterv 2
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles ((4 25))
             :curr-kernel "boids"
             :bg-amp (m-exp (aref *cc-state* 4 21) 0 1)
             :maxspeed 0.85690904
             :maxforce 0.07344935
             :maxidx 317
             :length 5
             :sepmult 1.32
             :alignmult 2.7
             :cohmult 1.93
             :predmult 10
             :maxlife 60000.0
             :lifemult 1000.0
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (n-exp y 0.4 1.08)
             :ampfn (* (sign) 3)
             :durfn (n-exp y 0.001 5.0e-4)
             :suswidthfn 0.1
             :suspanfn 0
             :decay-startfn 0.001
             :decay-endfn 0.2
             :lfo-freqfn 1
             :x-posfn x
             :y-posfn y
             :wetfn 1
             :filt-freqfn 20000)
            :midi-cc-fns
            (((4 0)
              (with-exp-midi (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (bp-set-value :maxspeed (* speedf 1.05))
                  (bp-set-value :maxforce (* speedf 0.09)))))
             ((4 1)
              (with-lin-midi (1 8)
                (bp-set-value :sepmult (float (funcall ipfn d2)))))
             ((4 2)
              (with-lin-midi (1 8)
                (bp-set-value :cohmult (float (funcall ipfn d2)))))
             ((4 3)
              (with-lin-midi (1 8)
                (bp-set-value :alignmult (float (funcall ipfn d2)))))
             ((4 4)
              (with-lin-midi (1 10000)
                (bp-set-value :lifemult (float (funcall ipfn d2)))))
             ((4 21)
              (with-exp-midi (0.001 1.0)
                (bp-set-value :bg-amp (float (funcall ipfn d2)))))
             ,@(std-obst-move 0 400 100)))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))




(state-store-curr-preset 0)

(bp-set-value :predmult 2.0)


(in-package :luftstrom-display)

;;; preset: 0

(progn
  (setf *curr-preset*
        (copy-list
         (append
          '(:boid-params
            (:num-boids 0
             :boids-per-click 50
             :clockinterv 2
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles ((4 25))
             :curr-kernel "boids"
             :bg-amp (m-exp (aref *cc-state* 4 21) 0 1)
             :maxspeed 0.85690904
             :maxforce 0.07344935
             :maxidx 317
             :length 5
             :sepmult 1.32
             :alignmult 2.7
             :cohmult 1.93
             :predmult 10
             :maxlife 60000.0
             :lifemult 1000.0
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (n-exp y 0.4 1.08)
             :ampfn (* (sign) 3)
             :durfn (n-exp y 0.001 5.0e-4)
             :suswidthfn 0.1
             :suspanfn 0
             :decay-startfn 0.001
             :decay-endfn 0.2
             :lfo-freqfn 1
             :x-posfn x
             :y-posfn y
             :wetfn 1
             :filt-freqfn 20000)
            :midi-cc-fns
            (((4 0)
              (with-exp-midi (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (bp-set-value :maxspeed (* speedf 1.05))
                  (bp-set-value :maxforce (* speedf 0.09)))))
             ((4 1)
              (with-lin-midi (1 8)
                (bp-set-value :sepmult (float (funcall ipfn d2)))))
             ((4 2)
              (with-lin-midi (1 8)
                (bp-set-value :cohmult (float (funcall ipfn d2)))))
             ((4 3)
              (with-lin-midi (1 8)
                (bp-set-value :alignmult (float (funcall ipfn d2)))))
             ((4 4)
              (with-lin-midi (1 10000)
                (bp-set-value :lifemult (float (funcall ipfn d2)))))
             ((4 21)
              (with-exp-midi (0.001 1.0)
                (bp-set-value :bg-amp (float (funcall ipfn d2)))))
             ((0 100)
              (progn
                (with-exp-midi (1.0 300.0)
                  (bp-set-value :predmult (float (funcall ipfn d2)))
                  )
                (with-exp-midi (2.5 10.0)
                  (bp-set-value :obstacles-lookahead (float (funcall ipfn d2))))))
             ((0 40) (make-retrig-move-fn 0 :dir :right :max 200 :ref 100 :clip nil))
             ((0 50) (make-retrig-move-fn 0 :dir :left :max 200 :ref 100 :clip nil))
             ((0 60) (make-retrig-move-fn 0 :dir :up :max 200 :ref 100 :clip nil))
             ((0 70) (make-retrig-move-fn 0 :dir :down :max 200 :ref 100 :clip nil))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(save-presets)
(state-store-curr-preset 0)

(bp-set-value :predmult 2.0)


(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 0
             :boids-per-click 5
             :clockinterv 2
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles ((4 25))
             :curr-kernel "boids"
             :bg-amp (m-exp (aref *cc-state* 0 21) 0 1)
             :maxspeed 0.85690904
             :maxforce 0.07344935
             :maxidx 317
             :length 5
             :sepmult 1.32
             :alignmult 2.7
             :cohmult 1.93
             :predmult 1
             :maxlife 60000.0
             :lifemult 1000.0
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (n-exp y 0.4 1.08)
             :ampfn (* (sign) 3)
             :durfn (n-exp y 0.001 5.0e-4)
             :suswidthfn 0.1
             :suspanfn 0
             :decay-startfn 0.001
             :decay-endfn 0.2
             :lfo-freqfn 1
             :x-posfn x
             :y-posfn y
             :wetfn 1
             :filt-freqfn 20000)
            :midi-cc-fns
            (((4 0)
              (with-exp-midi (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (bp-set-value :maxspeed (* speedf 1.05))
                  (bp-set-value :maxforce (* speedf 0.09)))))
             ((4 1)
              (with-lin-midi (1 8)
                (bp-set-value :sepmult (float (funcall ipfn d2)))))
             ((4 2)
              (with-lin-midi (1 8)
                (bp-set-value :cohmult (float (funcall ipfn d2)))))
             ((4 3)
              (with-lin-midi (1 8)
                (bp-set-value :alignmult (float (funcall ipfn d2)))))
             ((4 4)
              (with-lin-midi (1 10000)
                (bp-set-value :lifemult (float (funcall ipfn d2)))))
             ((4 21)
              (with-exp-midi (0.001 1.0)
                (bp-set-value :bg-amp (float (funcall ipfn d2)))))
             ,@(std-obst-move 0 400 7)))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

;;; todo:
;;;
;;; 1. sound presets für Spieler:
;;;
;;; - Zuordnung selektiv wählbar (als array)
;;;
;;; - play-sound macht dispatch basierend auf tidx
;;;
;;; 2. Verschiedene obstacle type icons
;;;
;;;
;;; 3. Umschaltung Obstacle Typ
;;;
;;; aufwändug: Alle obstacles müssen bei Umschaltung neu sortiert
;;; werden und der state aller Obstacles erhalten bleiben (erst für
;;; nächste Version!)







#|
(let*
    ((preset (aref *audio-presets* 0))
     (p1 (funcall (preset-fn :p1 preset) 0 0 0))
     (p2 (funcall (preset-fn :p2 preset) 0 0 0 p1))
     (p3 (funcall (preset-fn :p3 preset) 0 0 0 p1 p2))
     (p4 (funcall (preset-fn :p4 preset) 0 0 0 p1 p2 p3)))
  (funcall
   (preset-fn :pitchfn preset)
   0 0 0.1 p1 p2 p3 p4))

(digest-audio-args
 '(:p1 1
   :p2 (+ p1 1)
   :p3 0
   :p4 0
   :pitchfn (+ p2 (n-exp y 0.4 1.08))
   :ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
   :durfn 0.5
   :suswidthfn 0
   :suspanfn (random 1.0)
   :decay-startfn 5.0e-4
   :decay-endfn 0.002
   :lfo-freqfn (r-exp 50 80)
   :x-posfn x
   :y-posfn y
   :wetfn 1
   :filt-freqfn 20000)
 (aref *audio-presets* 0))
|#



(setf (aref (aref *audio-presets* 1) 0) "Hallo")

(digest-audio-args
 '(:p1 1
   :p2 (+ p1 1)
   :p3 0
   :p4 0
   :pitchfn (+ p2 (n-exp y 0.4 1.08))
   :ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
   :durfn 0.5
   :suswidthfn 0
   :suspanfn (random 1.0)
   :decay-startfn 5.0e-4
   :decay-endfn 0.002
   :lfo-freqfn (r-exp 50 80)
   :x-posfn x
   :y-posfn y
   :wetfn 1
   :filt-freqfn 20000)
 (aref *audio-presets* 0))

 (aref *audio-presets* 0)



(defun digest-audio-args (args)
  (let ((p1)))

  )
(:p1 1
 :p2 (- p1 1)
 :p3 0
 :p4 0
 :pitchfn (+ p2 (n-exp y 0.4 1.08))
 :ampfn (progn (* (/ v 20) (sign) (n-exp y 3 1.5)))
 :durfn 0.5
 :suswidthfn 0
 :suspanfn (random 1.0)
 :decay-startfn 5.0e-4
 :decay-endfn 0.002
 :lfo-freqfn (r-exp 50 80)
 :x-posfn x
 :y-posfn y
 :wetfn 1
 :filt-freqfn 20000)



(setf (aref *curr-audio-presets* 0)
      (aref *audio-presets* 0))



(elt *obstacles* 0)

(aref *audio-presets* 0)

:audio-args
'(;;; test
  :default 0
  :player1 0
  :player2 1)


(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 90
             :boids-per-click 10
             :clockinterv 4
             :speed 2.0
             :obstacles-lookahead 3.0
             :obstacles nil
             :curr-kernel "boids"
             :bg-amp 1
             :maxspeed 1.55
             :maxforce 0.0465
             :maxidx 317
             :length 5
             :sepmult 2
             :alignmult 1
             :cohmult 1
             :predmult 10
             :maxlife 60000.0
             :lifemult 100
             :max-events-per-tick 10)
            :audio-args
            (:default (apr 0))
            :midi-cc-fns
            (:nk2 (cc-set 0)
             :player1 (cc-set :obstacle)
             :player2 (cc-set :boid-ctl)))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))


(in-package :luftstrom-display)

;;; preset: 1

(progn
  (setf *curr-preset*
        (copy-list
         (append
          `(:boid-params
            (:num-boids 90
             :boids-per-click 5
             :clockinterv 2
             :speed 2.0
             :obstacles-lookahead 2.5
             :obstacles ((4 25))
             :curr-kernel "boids"
             :bg-amp 0.001
             :maxspeed 0.105
             :maxforce 0.009000001
             :maxidx 317
             :length 5
             :sepmult 1.0
             :alignmult 1.0
             :cohmult 1.0
             :predmult 1.0
             :maxlife 60000.0
             :lifemult 1.0
             :max-events-per-tick 10)
            :audio-args
            (:default (apr 0)
             :player1 (apr 1))
            :midi-cc-fns
            (((4 0)
              (with-exp-midi-fn (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (bp-set-value :maxspeed (* speedf 1.05))
                  (bp-set-value :maxforce (* speedf 0.09)))))
             ((4 1)
              (with-lin-midi-fn (1 8)
                (bp-set-value :sepmult (float (funcall ipfn d2)))))
             ((4 2)
              (with-lin-midi-fn (1 8)
                (bp-set-value :cohmult (float (funcall ipfn d2)))))
             ((4 3)
              (with-lin-midi-fn (1 8)
                (bp-set-value :alignmult (float (funcall ipfn d2)))))
             ((4 4)
              (with-lin-midi-fn (0 100)
                (bp-set-value :lifemult (float (funcall ipfn d2)))))
             ((4 21)
              (with-exp-midi-fn (0.001 1.0)
                (bp-set-value :bg-amp (float (funcall ipfn d2)))))
             ((0 7)
              (lambda (d2)
                (if (numberp d2)
                    (let ((obstacle (aref *obstacles* 0)))
                      (with-slots (brightness radius)
                          obstacle
                        (let ((ipfn (ip-exp 1 40.0 128)))
                          (set-lookahead 0 (float (funcall ipfn d2))))
                        (let ((ipfn (ip-exp -1 -100.0 128)))
                          (set-multiplier 0
                                          (* (signum (- (aref *cc-state* 0 100) 63))
                                             (float (funcall ipfn d2)))))
                        (let ((ipfn (ip-lin 0.2 1.0 128)))
                          (setf brightness (funcall ipfn d2))))))))
             ((0 40)
              (make-retrig-move-fn 0 :dir :right :max 400 :ref 7 :clip nil))
             ((0 50)
              (make-retrig-move-fn 0 :dir :left :max 400 :ref 7 :clip nil))
             ((0 60)
              (make-retrig-move-fn 0 :dir :up :max 400 :ref 7 :clip nil))
             ((0 70)
              (make-retrig-move-fn 0 :dir :down :max 400 :ref 7 :clip nil))
             ((0 99)
              (lambda (d2)
                (if (and (numberp d2) (= d2 127))
                    (toggle-obstacle 0))))))
          `(:midi-cc-state ,(alexandria:copy-array *cc-state*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 1)

(apr 1)

(*curr-audio-presets*

)
;;; Fragen:
;;;
;;;
;;;
;;; - wie boids erzeugen/wegnehmen
;;;
;;; - Steuerung boids/obstacles prüfen
;;;
;;; - Tonhöhen?
;;;
;;; - cc-Verläufe an Tonhöhen/Audio Parameter koppeln
;;;
;;; - presets umschalten?
;;;
;;; 


(loop for preset across *presets*
      do (if preset
             (setf (getf preset :midi-cc-fns)
                   `(,@(cc-preset :nk2 :nk2-std)
                     ,@(cc-preset :player1 :obst-ctl1)
                     ))))


(((4 0)
              (with-exp-midi-fn (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (bp-set-value :maxspeed (* speedf 1.05))
                  (bp-set-value :maxforce (* speedf 0.09)))))
             ((4 1)
              (with-lin-midi-fn (1 8)
                (bp-set-value :sepmult (float (funcall ipfn d2)))))
             ((4 2)
              (with-lin-midi-fn (1 8)
                (bp-set-value :cohmult (float (funcall ipfn d2)))))
             ((4 3)
              (with-lin-midi-fn (1 8)
                (bp-set-value :alignmult (float (funcall ipfn d2)))))
             ((4 4)
              (with-lin-midi-fn (0 500)
                (bp-set-value :lifemult (float (funcall ipfn d2)))))
             ((4 21)
              (with-exp-midi-fn (0.001 1.0)
                (bp-set-value :bg-amp (float (funcall ipfn d2)))))
             ((2 7)
              (lambda (d2)
                (if (numberp d2)
                    (let ((obstacle (aref *obstacles* 2)))
                      (with-slots (brightness radius)
                          obstacle
                        (let ((ipfn (ip-exp 2.5 10.0 128)))
                          (set-lookahead 2 (float (funcall ipfn d2))))
                        (let ((ipfn (ip-exp 1 100.0 128)))
                          (set-multiplier 2 (float (funcall ipfn d2))))
                        (let ((ipfn (ip-lin 0.2 1.0 128)))
                          (setf brightness (funcall ipfn d2))))))))
             ((2 40)
              (make-retrig-move-fn 2 :dir :right :max 400 :ref 7 :clip nil))
             ((2 50)
              (make-retrig-move-fn 2 :dir :left :max 400 :ref 7 :clip nil))
             ((2 60)
              (make-retrig-move-fn 2 :dir :up :max 400 :ref 7 :clip nil))
             ((2 70)
              (make-retrig-move-fn 2 :dir :down :max 400 :ref 7 :clip nil))
             ((2 99)
              (lambda (d2)
                (if (and (numberp d2) (= d2 127))
                    (toggle-obstacle 2)))))


  0: (cffi-sys:%mem-set 5/2 #.(sb-sys:int-sap #X7FC4E5AE3F80) :unsigned-int 0)
  1: (cl-opencl:%set-kernel-arg-number #.(sb-sys:int-sap #X7FC4E6CAA440) 6 5/2 :uint)

(toggle-obstacle 1)

*obstacles*

(make-obstacle-mask)
(dotimes (i 4) (setf (aref *cc-state* i 7) 127))


(loop for preset across *presets*
  do (setf (getf preset :midi-cc-fns)
        '(:nk2 :nk2-std
          :player1 :obst-ctl1
          :player2 :obst-ctl1
          :player3 :obst-ctl1
          :player4 :obst-ctl1
          (:nk2 20) (with-exp-midi-fn (5 250)
                      (setf *length* (round (funcall ipfn d2)))))))


(make-obstacle-mask)

*obstacles*

(car (cl-boids-gpu::systems cl-boids-gpu::*win*))

(set-obstacles)

(setf (aref *cc-state* 3 7) 20)

(funcall (aref *cc-fns* 0 7) 20)

(setf *curr-audio-preset-no* 94)
(setf *curr-audio-preset-no* 37)
(setf *curr-audio-preset-no* 17)
(setf *curr-audio-preset-no* 0)

(edit-audio-preset-in-emacs 51)

(cp-audio-preset 93 92)
;;;; Ablauf:

leer, wenig
Obstacles ohne Klangreaktion
Obstacles mit Klangreaktion
-> Drone
-> Obertonklang

- Xenakis
- Bienenschwarm
- Langsame Streifen (eso)
- Schlagzegdonnern
- Im Sturm stehen
- Solo Beat
- Solo Orm


'(10 22 29 42 47 62 71 80)
'(10 19 32 29 53 63 75 79)
'(12 22 27 45 50 41 71 80)
'(9 23 32 37 47 55 70 79)



(defparameter *testfn* (seq-ip-pick '(10 22 29 42 47 62 71 80)
                                    '(10 19 32 29 53 63 75 79)))

(funcall *testfn* 0.5)
(:p1 1 :p2 (- p1 1) :p3 0 :p4 0 :pitchfn (+ p2 (n-exp y 0.4 1.08)) :ampfn
 (progn (* (sign) 1 (m-exp-zero (player-cc tidx 7) 0.01 1) (n-exp y 1.5 2.5)))
 :durfn (* (m-exp 111 0.01 1) (r-exp 0.9 (/ 0.9)) 0.5) :suswidthfn 0.1
 :suspanfn (random 0.01) :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn
 (* (n-exp y 1 (m-lin 0 1 20)) (n-exp-dev (m-lin 0 0 1) 2)
    (hertz (m-lin 39 10 108)))
 :x-posfn x :y-posfn y :wetfn (m-lin 98 0 1) :filt-freqfn 20000 :bp-freq
 (hertz (n-lin y 10 100)) :bp-rq (m-lin 0 5 0.01))

(:p1 1 :p2 (- p1 1) :p3 0 :p4 0 :pitchfn (+ p2 (n-exp y 0.4 1.08)) :ampfn
 (progn (* (sign) 1 (m-exp-zero (player-cc tidx 7) 0.01 1) (n-exp y 1.5 2.5)))
 :durfn (* (m-exp 50 0.01 1) (r-exp 0.9 (/ 0.9)) 0.5) :suswidthfn 0.1 :suspanfn
 (random 0.01) :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn
 (* (n-exp y 1 (m-lin 0 1 20)) (n-exp-dev (m-lin 0 0 1) 2)
    (hertz (m-lin 39 10 108)))
 :x-posfn x :y-posfn y :wetfn (m-lin 98 0 1) :filt-freqfn 20000 :bp-freq
     (hertz (n-lin y 10 100)) :bp-rq (m-lin 0 5 0.01))

(:p1 1 :p2 (- p1 1) :p3 0 :p4 0 :pitchfn (+ p2 (n-exp y 0.4 1.08)) :ampfn
 (progn (* (sign) 1 (m-exp-zero (player-cc tidx 7) 0.01 1) (n-exp y 1.5 2.5)))
 :durfn (* (m-exp 88 0.01 1) (r-exp 0.9 (/ 0.9)) 0.5) :suswidthfn 0.5 :suspanfn
 1 :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn
 (* (n-exp y 1 (m-lin 30 1 20)) (n-exp-dev (m-lin 21 0 1) 2)
    (hertz (m-lin 80 10 108)))
 :x-posfn x :y-posfn y :wetfn (m-lin 127 0 1) :filt-freqfn 20000 :bp-freq
     (hertz (n-lin y 10 100)) :bp-rq (m-lin 0 5 0.01))

(:p1 1 :p2 (- p1 1) :p3 0 :p4 0 :pitchfn (+ p2 (n-exp y 0.4 1.08)) :ampfn
 (progn (* (sign) 1 (m-exp-zero (player-cc tidx 7) 0.01 1) (n-exp y 1.5 2.5)))
 :durfn (* (m-exp 25 0.01 1) (r-exp 0.9 (/ 0.9)) 0.5) :suswidthfn 0.1 :suspanfn
 0 :decay-startfn 5.0e-4 :decay-endfn 0.002 :lfo-freqfn
 (* (n-exp y 1 (m-lin 94 1 20)) (n-exp-dev (m-lin 83 0 1) 2)
    (hertz (m-lin 49 10 108)))
 :x-posfn x :y-posfn y :wetfn (m-lin 0 0 1) :filt-freqfn 20000 :bp-freq
 (hertz (n-lin y 10 100)) :bp-rq (m-lin 0 5 0.01))


presets: 98

(extract-preset 16)

;;; ätherisch (p16):
(:p1 1 :p2 (- p1 1) :p3 0 :p4 0 :pitchfn (n-exp y 0.4 1.2) :ampfn
 (* (sign) (m-exp-zero (player-cc tidx 7) 0.01 1) (+ 0.1 (random 0.6))) :durfn
 (n-exp y 0.8 0.16) :suswidthfn 0.1 :suspanfn 0.3 :decay-startfn 0.001
 :decay-endfn 0.02 :lfo-freqfn
 (* (expt (round (* 16 y)) (n-lin x 1 (n-lin (/ 55 127) 1 1.2)))
    (m-exp 127 50 200))
 :x-posfn x :y-posfn y :wetfn 0.5 :filt-freqfn (n-exp y 200 10000))

(previous-preset)
(next-preset)
(setf *curr-audio-preset-no* 94)
(setf *curr-audio-preset-no* 13)
(setf (aref *cc-state* 0 7) 64)
(cp-audio-preset 93 37)

(sort
 (remove-duplicates
  (loop
    for audio-args in (loop
                        for preset from 0 to 7
                        collect (getf (aref *presets* preset) :audio-args))
    append (loop for x in (cdr audio-args) by #'cddr collect (second x))) :from-end t)
 #'<)

(1 2 3 4 11 12 13 14 17 18 19 22 28 37 46 89 91 92 94)

(94 1 2 3 4 11 12 13 14 91 89 92 37 17 18 46 28 22 19)
(slime-)

(edit-preset-in-emacs)

(keynum 200 :hz)


(:nk2 20) (with-exp-midi-fn (5 250)
            (setf *length* (round (funcall ipfn d2))))

(cl-boids-gpu::timer-add-boids 3000 500)
(cl-boids-gpu::timer-add-boids 12000 500)


(cl-boids-gpu::timer-remove-boids 20000 2000 :fadetime 0)
(cl-boids-gpu::timer-add-boids 2000 20)
(cl-boids-gpu::timer-add-boids 3000 2000)

(setf cl-boids-gpu::*trig* t)
(setf cl-boids-gpu::*trig* nil)

(cl-boids-gpu::timer-add-boids 1000 20)

;;; ADD:

(cl-boids-gpu::timer-add-boids 15000 2000)

(progn
  (cl-boids-gpu::timer-remove-boids 1000 1 :fadetime 10))

;;; REMOVE!!

(progn
  (cl-boids-gpu::timer-remove-boids 20000 20000 :fadetime 0))

(progn
  (cl-boids-gpu::timer-remove-boids 20000 20000 :fadetime 0)
  (cl-boids-gpu::timer-add-boids 10 5));;; (cl-boids-gpu:boids :width 1920 :height 1080)




(progn
  (cl-boids-gpu::timer-remove-boids 20000 20000 :fadetime 0)
  (cl-boids-gpu::timer-add-boids 4500 5000))
(setf *lifemult* 0)

(next-preset)
(previous-preset)
Checken, ob bei 03 auch Lautstärke von den Spielern gesteuert wird!!!!


(let ((p2 1))
  (*
   (expt
    (round
     (*
      (if (zerop p2)
          1
          16)
      y))
    (n-lin x 1 (m-lin (nk2-ref 16) 1 1.5)))
   (hertz (m-lin (nk2-ref 17) 31 55))
   (n-exp-dev (m-lin (nk2-ref 18) 0 1) 1.5)))

(digest-audio-args-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (n-exp y 0.4 1.2)
   :ampfn (* (sign) (m-exp-zero (player-cc tidx 7) 0.01 1) (+ 0.1 (random 0.6)))
   :durfn (n-exp y 0.8 0.16)
   :suswidthfn 0
   :suspanfn 0.3
   :decay-startfn 0.001
   :decay-endfn 0.02
   :lfo-freqfn (* (expt (round (* 16 y)) (n-lin x 1 (m-lin (nk2-ref 16) 1 1.5)))
                (hertz (m-lin (nk2-ref 17) 31 55)))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 23) 0 1)
   :filt-freqfn (n-exp y 200 10000))
 (aref *audio-presets* 92))

(digest-audio-args-preset
 '(:p1 0
   :p2 (m-lin (nk2-ref 6) 0 1)
   :p3 0
   :p4 0
   :pitchfn (n-exp y 0.4 (m-lin (nk2-ref 19) 0.8 1.2))
   :ampfn (* (m-exp-zero (player-cc tidx 7) 0.01 1) (sign) (+ 0.1 (random 0.6)))
   :durfn (+ (* (- 1 p2) (n-exp y 0.8 0.16)) (* p2 (m-exp (nk2-ref 16) 0.1 0.5)))
   :suswidthfn (* p2 0.5)
   :suspanfn 0.3
   :decay-startfn (n-lin p2 0.001 0.03)
   :decay-endfn (n-lin p2 0.02 0.03)
   :lfo-freqfn (n-lin p2
                (* (expt (round (* 16 y)) (n-lin x 1 (m-lin (nk2-ref 16) 1 1.5)))
                 (hertz (m-lin (nk2-ref 17) 31 55)))
                (* (n-exp y 0.8 1.2) (m-exp (nk2-ref 18) 50 400)
                 (n-exp-dev (m-lin (nk2-ref 17) 0 1) 0.5)))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 22) 0 1)
   :filt-freqfn (* (n-exp y 1 2) (m-exp (nk2-ref 23) 100 10000)))
 (aref *audio-presets* 17))



x=0 -> 1- (/ 1.3)
x=1 -> 1-1.3

(let ((x 1))
  (n-lin x (mc-lin 5 1 (/ 1.3)) (mc-lin 5 1 1.3)))

(with-pan (l r) (mcn-ref 5)
                (*
                 (expt (round (* 16 y))
                  (n-lin x (mc-lin 11 1 (/ 1.3)) (mc-lin 11 1 1.3)))
                 (hertz (m-lin (mc-ref 10) 31 55))))

(with-pan (l r) (mcn-ref 5)
                (+
                 (* l
                  (expt (round (* 16 1))
                   (n-lin 0.2 (mc-lin 11 1 (/ 1.3)) (mc-lin 11 1 1.3)))
                  (hertz (m-lin (mc-ref 10) 31 55)))
                 (* r (m-lin (mc-ref 10) 0.1 1))))

(+
 (* p1
    (expt (round (* 16 y))
          (n-lin x (mc-lin 11 1 (/ 1.3)) (mc-lin 11 1 1.3)))
    (hertz (m-lin (mc-ref 10) 31 55)))
 (* (- 1 p1) (m-lin (mc-ref 10) 0.1 1)))

;;; bassdrum:

(digest-audio-preset-form
 '(:cc-state #(0 0 0 0 0 0 0 127 0 0 0 0 0 1 0 0)
   :p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.5 0.6)
   :ampfn (progn (* (sign) 1 (n-exp y 2 1)))
   :durfn (mc-exp 6 0.1 0.5)
   :suswidthfn 0.1
   :suspanfn 0.02
   :decaystartfn 0.1
   :decayendfn 0.5
   :lfofreqfn (* (mc-exp 7 1 10) 0.1)
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 8 0 1)
   :filtfreqfn 20000)
 :audio-preset (aref *audio-presets* 1))

(load-audio-preset)

(find-gui :ewi1)


QPushButton {
         border: 1px solid #838383;
         background-color: #ffffff;
         selection-color: red;
         border-radius: 0px;
         selection-background-color: white;
         min-width: 80px;
     }

(make-instance 'ewi-controller
               :id :ewi1
               :player :player1
               :x-pos 0
               :y-pos 580
               :height 60)

(let ((pvb (cuda-gui::ewi-apr (find-gui :ewi1))))
  (funcall pvb (val (cuda-gui::ref))))

(val (cuda-gui::ewi-apr (find-gui :ewi1)))

cuda-gui::label-spinbox

(val (cuda-gui::ewi-apr (find-gui :ewi1)))
(find-controller :ewi1)

(ewi-gui :id :ewi4 :x-pos 100 :y-pos 100 :width 800 :height 200)

(setf (cl-boids-gpu::num-boids cl-boids-gpu::*bp*) 100)

(find-controller :bs1)

(digest-audio-args-preset
 '(:p1 0
   :p2 (m-lin (nk2-ref 6) 0 1)
   :p3 0
   :p4 0
   :pitchfn (n-exp y 0.4 (m-lin (nk2-ref 19) 0.8 1.2))
   :ampfn (* (m-exp-zero (player-cc tidx 7) 0.01 1) (sign) (n-exp y 1 0.5))
   :durfn (m-exp (nk2-ref 16) 0.1 0.5)
   :suswidthfn 0.5
   :suspanfn 0.3
   :decay-startfn 0.03
   :decay-endfn 0.03
   :lfo-freqfn (+
                (* (n-exp y 0.8 1.2) (m-exp (nk2-ref 18) 50 400)
                 (n-exp-dev (m-lin (nk2-ref 17) 0 1) 0.5)))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 22) 0 1)
   :filt-freqfn (* (n-exp y 1 2) (m-exp (nk2-ref 23) 100 10000)))
 (aref *audio-presets* 17))
rremove-


(defun quick (list)
  (if (null list) nil
      (let ((pivot (car list)) (rest (cdr list)) (less nil) (greater nil))
        (dolist (i rest)
          (if (< i pivot) (push i less) (push i greater)))
        (append (quick less) (list pivot) (quick greater)))))

(setf (aref *))

(dotimes (player 4) (setf (aref *cc-state* player 7) 127))

(osc-stop)
(osc-start)

(funcall (n-lin-fn 0.2 0.8) 0)

(set-cell (slot-value (elt *obstacles* 0) 'type) 4)

(reset-obstacles)

(slot-value *tabletctl* 'o1-type)

(obstacle-type (elt *obstacles* 0))


(digest-audio-preset-form
 '(:cc-state #(0 30 0 0 39 127 0 28 96 0 0 127 7 42 12 127)
   :p1 0
   :p2 0
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (n-exp y 0.45 1)
   :ampfn (* (sign) (n-exp y 1 0.5))
   :durfn (mc-exp 14 0.01 2)
   :suswidthfn 0
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.02
   :lfofreqfn (* (n-exp-dev 1 (n-lin x (mc-lin 12 1 0.8) (mc-lin 12 1 1.2)))
               (expt (+ 1 (round (* y (mc-lin 10 0 16)))) (mc-lin 11 1 1.5))
               (mc-exp 9 1 100))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :vowel y
   :voicetype (random 5)
   :voicepan (mcn-ref 1)
   :bpfreq (n-exp y 1000 5000)
   :bprq (mc-exp 15 1 0.01)
   :bppan (mcn-ref 3))
 :audio-preset (aref *audio-presets* 100))

(loop
  for i below 4
  collect (obstacle-exists? (aref *obstacles* i)))

(set-cell (cl-boids-gpu::boids-add-time *bp*) 10)

;;;;;;;

(defparameter *presets-2018* nil)

(setf *presets-2018*
      '((:boid-params
                       (:num-boids 0 :boids-per-click 100 :trig t :clockinterv 4 :speed 2.0
                        :obstacles-lookahead 3.0 :obstacles ((2 25) (2 25) (2 25) (0 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 0.105 :maxforce 0.009000001
                        :maxidx 317 :length 5 :sepmult 1.0 :alignmult 1.0 :cohmult 1.0 :predmult 10
                        :maxlife 60000.0 :lifemult 0.0 :max-events-per-tick 10)
                       :audio-args (:default (apr 0)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :life-ctl3)
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 45 :boids-per-click 5 :trig nil :clockinterv 2 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxidx 317 :length 5 :predmult 1
                        :maxlife 60000.0 :lifemult 0.0 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 94) :player1 (apr 1) :player2 (apr 2) :player3 (apr 3)
                        :player4 (apr 4))
                       :midi-cc-fns
                       (:nk2 :nk2-std-noreset :player1 :obst-ctl1 :player2 :obst-ctl1 :player3
                             :obst-ctl1 :player4 :life-ctl1)
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 64 50 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (111 65 66 66 0 0 0 0 0 0 0 0 0 0 0 0 85 0 0 34 32 56 0 74 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 100 :boids-per-click 50 :trig nil :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((1 25) (1 25) (1 25) (1 25))
                        :curr-kernel "boids" :bg-amp 1.0 :maxidx 317 :length 5 :predmult 1 :maxlife
                        60000.0 :lifemult 0.0 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 94) :player1 (apr 11) :player2 (apr 12) :player3 (apr 13)
                        :player4 (apr 14))
                       :midi-cc-fns
                       (:nk2 :nk2-std2-noreset :player1 :obst-ctl1 :player2 :obst-ctl1 :player3
                             :obst-ctl1 :player4 :life-ctl1 (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (setf *clockinterv* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 64 50 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (111 65 66 66 0 0 0 0 0 0 0 0 0 0 0 0 85 0 0 34 32 56 0 74 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 100 :boids-per-click 50 :trig nil :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((1 25) (1 25) (1 25) (1 25))
                        :curr-kernel "boids" :bg-amp 0.0067107594 :maxspeed 0.105 :maxforce
                        0.009000001 :maxidx 317 :length 5 :sepmult 8.0 :alignmult 1.0 :cohmult 1.0
                        :predmult 1 :maxlife 60000.0 :lifemult 0.0 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 91) :player1 (apr 89) :player2 (apr 89) :player3 (apr 89)
                        :player4 (apr 89))
                       :midi-cc-fns
                       (:nk2 :nk2-std2-noreset :player1 :obst-ctl1 :player2 :obst-ctl1 :player3
                             :obst-ctl1 (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (setf *clockinterv* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 64 50 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (111 65 66 66 0 0 0 0 0 0 0 0 0 0 0 0 85 0 0 34 32 56 0 74 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 100 :boids-per-click 50 :trig nil :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((1 25) (1 25) (1 25) (1 25))
                        :curr-kernel "boids" :bg-amp 0.0067107594 :maxidx 317 :length 5 :predmult 1
                        :maxlife 60000.0 :lifemult 177.16536 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 92) :player1 (apr 37) :player2 (apr 37) :player3 (apr 37))
                       :midi-cc-fns
                       (:nk2 :nk2-std2-noreset :player1 :obst-ctl1 :player2 :obst-ctl1 :player3
                             :obst-ctl1 :player4 :boid-ctl1-noreset (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (setf *clockinterv* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 64 50 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (111 65 66 66 0 0 0 0 0 0 0 0 0 0 0 0 85 0 0 34 32 56 0 74 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 100 :boids-per-click 100 :trig nil :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxidx 317 :length 5 :predmult 1
                        :maxlife 60000.0 :lifemult 381.88977 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 17) :player1 (apr 37) :player2 (apr 37) :player3 (apr 37))
                       :midi-cc-fns
                       (:nk2 :nk2-std2-noreset :player1 :obst-ctl1 :player2 :obst-ctl1 :player3
                             :obst-ctl1 :player4 :boid-ctl1-noreset)
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 64 50 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (111 65 66 66 0 0 0 0 0 0 0 0 0 0 0 0 85 0 0 34 32 56 0 74 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 100 :boids-per-click 100 :trig nil :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxidx 317 :length 13 :sepmult 1.0
                        :alignmult 1.0 :cohmult 1.0 :predmult 1 :maxlife 60000.0 :lifemult
                        86.614174 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 18) :player1 (apr 46) :player2 (apr 28) :player3 (apr 22))
                       :midi-cc-fns
                       (:nk2 :nk2-std2-noreset :player1 :obst-ctl1 :player2 :obst-ctl1 :player3
                             :obst-ctl1 :player4 :boid-ctl1-noreset (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 64 50 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (111 65 66 66 0 0 0 0 0 0 0 0 0 0 0 0 85 0 0 34 32 56 0 74 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 100 :boids-per-click 100 :trig nil :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 0.105 :maxforce 0.009000001
                        :maxidx 317 :length 13 :sepmult 1.0 :alignmult 1.0 :cohmult 1.0 :predmult 1
                        :maxlife 60000.0 :lifemult 0.0 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 19) :player1 (apr 19) :player2 (apr 19) :player3 (apr 19))
                       :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :boid-ctl1 (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (bp-set-value :clockinterv (round (funcall ipfn d2))))
                        (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 64 50 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (111 65 66 66 0 0 0 0 0 0 0 0 0 0 0 0 85 0 0 34 32 56 0 74 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 1955 :boids-per-click 50 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((1 25) (1 25) (1 25) (1 25))
                        :curr-kernel "boids" :bg-amp 0.0067107594 :maxspeed 1.8679068 :maxforce
                        0.16010632 :maxidx 317 :length 5 :sepmult 3.2047243 :alignmult 6.1811023
                        :cohmult 7.007874 :predmult 1 :maxlife 60000.0 :lifemult 263.77954
                        :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 91) :player1 (apr 91) :player2 (apr 91) :player3 (apr 91)
                        :player4 (apr 91))
                       :midi-cc-fns
                       (:nk2 :nk2-std2 :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :life-ctl1 (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (setf *clockinterv* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 64 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (69 40 109 94 67 127 0 109 0 0 0 0 0 0 0 0 0 0 95 127 44 127 123 127 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 1955 :boids-per-click 50 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((1 25) (1 25) (1 25) (1 25))
                        :curr-kernel "boids" :bg-amp 0.0067107594 :maxspeed 0.3520638 :maxforce
                        0.030176898 :maxidx 317 :length 5 :sepmult 8.0 :alignmult 1.0 :cohmult 1.0
                        :predmult 1 :maxlife 60000.0 :lifemult 192.91339 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 92) :player1 (apr 37) :player2 (apr 37) :player3 (apr 37))
                       :midi-cc-fns
                       (:nk2 :nk2-std2 :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (setf *clockinterv* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (29 127 0 0 49 0 0 65 0 0 0 0 0 0 0 0 28 22 127 62 0 127 127 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 10 :boids-per-click 1 :clockinterv 4 :speed 2.0
                        :obstacles-lookahead 3.0 :obstacles ((2 25) (2 25) (2 25) (0 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 0.9582121 :maxforce 0.08213247
                        :maxidx 317 :length 5 :sepmult 2.488189 :alignmult 5.850394 :cohmult
                        2.8740158 :predmult 10 :maxlife 60000.0 :lifemult 0.0 :max-events-per-tick
                        10)
                       :audio-args (:default (apr 0)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :life-ctl1)
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (53 83 13 40 0 108 127 0 0 0 0 0 0 0 0 0 58 24 96 127 127 127 53 48 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 10 :boids-per-click 5 :clockinterv 2 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 1.0859671 :maxforce
                        0.093082905 :maxidx 317 :length 5 :sepmult 2.488189 :alignmult 5.850394
                        :cohmult 2.8740158 :predmult 1 :maxlife 60000.0 :lifemult 0.0
                        :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 0) :player1 (apr 1) :player2 (apr 2) :player3 (apr 3)
                        :player4 (apr 4))
                       :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :life-ctl1)
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (56 83 13 40 0 108 127 0 0 0 0 0 0 0 0 0 58 24 96 127 127 127 53 48 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 10 :boids-per-click 50 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((1 25) (1 25) (1 25) (1 25))
                        :curr-kernel "boids" :bg-amp 1.0 :maxspeed 4.302512 :maxforce 0.3687868
                        :maxidx 317 :length 5 :sepmult 2.488189 :alignmult 5.850394 :cohmult
                        2.8740158 :predmult 1 :maxlife 60000.0 :lifemult 0.0 :max-events-per-tick
                        10)
                       :audio-args
                       (:default (apr 0) :player1 (apr 1) :player2 (apr 2) :player3 (apr 3)
                        :player4 (apr 4))
                       :midi-cc-fns
                       (:nk2 :nk2-std2 :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :life-ctl1 (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (setf *clockinterv* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (89 27 34 88 45 0 0 90 0 0 0 0 0 0 0 0 75 0 0 0 127 127 127 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 13 :boids-per-click 50 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((1 25) (1 25) (1 25) (1 25))
                        :curr-kernel "boids" :bg-amp 0.0067107594 :maxspeed 9.910351 :maxforce
                        0.8494587 :maxidx 317 :length 5 :sepmult 6.4566927 :alignmult 2.2125983
                        :cohmult 1.8267716 :predmult 1 :maxlife 60000.0 :lifemult 267.71652
                        :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 91) :player1 (apr 91) :player2 (apr 91) :player3 (apr 91)
                        :player4 (apr 91))
                       :midi-cc-fns
                       (:nk2 :nk2-std2 :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (setf *clockinterv* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (109 99 15 22 68 127 0 127 0 0 0 0 0 0 0 0 75 0 127 3 127 82 127 127 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 3013 :boids-per-click 50 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((1 25) (1 25) (1 25) (1 25))
                        :curr-kernel "boids" :bg-amp 0.0067107594 :maxspeed 0.105 :maxforce
                        0.009000001 :maxidx 317 :length 5 :sepmult 8.0 :alignmult 1.0 :cohmult 1.0
                        :predmult 1 :maxlife 60000.0 :lifemult 177.16536 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 92) :player1 (apr 37) :player2 (apr 37) :player3 (apr 37))
                       :midi-cc-fns
                       (:nk2 :nk2-std2 :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :boid-ctl1 (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (setf *clockinterv* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (15 127 0 0 39 127 0 55 0 0 0 0 0 0 0 0 38 31 0 127 127 0 62 99 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 3013 :boids-per-click 100 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 21.0 :maxforce 1.8000001
                        :maxidx 317 :length 5 :sepmult 1.0 :alignmult 1.0 :cohmult 1.0 :predmult 1
                        :maxlife 60000.0 :lifemult 177.16536 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 17) :player1 (apr 37) :player2 (apr 37) :player3 (apr 37))
                       :midi-cc-fns
                       (:nk2 :nk2-std2 :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :boid-ctl1)
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (127 127 0 0 53 127 127 64 0 0 0 0 0 0 0 0 127 24 19 127 0 0 53 48 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 3013 :boids-per-click 100 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 21.0 :maxforce 1.8000001
                        :maxidx 317 :length 5 :sepmult 1.0 :alignmult 1.0 :cohmult 1.0 :predmult 1
                        :maxlife 60000.0 :lifemult 177.16536 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 18) :player1 (apr 46) :player2 (apr 28) :player3 (apr 22))
                       :midi-cc-fns
                       (:nk2 :nk2-std2 :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :boid-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (127 127 0 0 53 127 127 64 0 0 0 0 0 0 0 0 127 24 19 127 0 0 53 48 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 10 :boids-per-click 100 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 0.105 :maxforce 0.009000001
                        :maxidx 317 :length 250 :sepmult 1.0 :alignmult 1.0 :cohmult 1.0 :predmult
                        1 :maxlife 60000.0 :lifemult 177.16536 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 19) :player1 (apr 19) :player2 (apr 19) :player3 (apr 19))
                       :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :boid-ctl1 (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (bp-set-value :clockinterv (round (funcall ipfn d2))))
                        (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (89 27 34 88 45 0 0 90 0 0 0 0 0 0 0 0 75 0 0 0 127 127 127 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 3610 :boids-per-click 100 :clockinterv 50 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 9.117008 :maxforce 0.7814579
                        :maxidx 317 :length 250 :sepmult 5.7401576 :alignmult 8.0 :cohmult
                        2.3228347 :predmult 1 :maxlife 60000.0 :lifemult 905.51184
                        :max-events-per-tick 10)
                       :audio-args (:default (apr 18) :player1 (apr 18)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2))))
                        (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (bp-set-value :clockinterv (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 64 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (107 86 24 127 23 0 127 127 0 0 0 0 0 0 0 0 125 127 17 40 127 127 0 127
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 3610 :boids-per-click 100 :clockinterv 4 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 0.18060417 :maxforce
                        0.015480359 :maxidx 317 :length 250 :sepmult 5.7401576 :alignmult 8.0
                        :cohmult 2.3228347 :predmult 1 :maxlife 60000.0 :lifemult 905.51184
                        :max-events-per-tick 10)
                       :audio-args (:default (apr 19) :player1 (apr 19)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (bp-set-value :clockinterv (round (funcall ipfn d2))))
                        (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 64 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (13 86 24 127 23 0 9 127 0 0 0 0 0 0 0 0 125 127 17 40 127 127 0 127 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      nil
                      (:boid-params
                       (:num-boids 50 :boids-per-click 100 :clockinterv 2 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 15.0408535 :maxforce 1.2892162
                        :maxidx 317 :length 5 :sepmult 5.6299214 :alignmult 6.5669293 :cohmult
                        2.7086613 :predmult 1 :maxlife 60000.0 :lifemult 440.9449
                        :max-events-per-tick 10)
                       :audio-args (:default (apr 21) :player1 (apr 21)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (119 84 31 101 112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 3550 :boids-per-click 100 :clockinterv 2 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 0.5570872 :maxforce
                        0.047750335 :maxidx 317 :length 5 :sepmult 6.125984 :alignmult 1.0 :cohmult
                        1.0 :predmult 1 :maxlife 60000.0 :lifemult 31.496063 :max-events-per-tick
                        10)
                       :audio-args (:default (apr 61) :player1 (apr 22)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :boid-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 64 40 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            93 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (83 105 89 0 86 0 0 6 0 0 0 0 0 0 0 0 0 50 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 2200 :boids-per-click 100 :clockinterv 2 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 0.105 :maxforce 0.009000001
                        :maxidx 317 :length 5 :sepmult 1.0 :alignmult 1.496063 :cohmult 1.0
                        :predmult 1 :maxlife 60000.0 :lifemult 0.0 :max-events-per-tick 10)
                       :audio-args (:default (apr 23) :player1 (apr 23) :player4 (apr 23))
                       :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :boid-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 64 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 9 127 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (8 44 19 81 68 0 0 0 0 0 0 0 0 0 0 0 0 50 0 0 0 0 0 127 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      nil
                      (:boid-params
                       (:num-boids 1200 :boids-per-click 5 :clockinterv 2 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 1.6481631 :maxforce 0.14127113
                        :maxidx 317 :length 5 :sepmult 2.7086613 :alignmult 8.0 :cohmult 8.0
                        :predmult 1 :maxlife 60000.0 :lifemult 3.937008 :max-events-per-tick 10)
                       :audio-args (:default (apr 23) :player1 (apr 25)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :boid-ctl1 (:player4 40)
                        (lambda (d2)
                          (if (and (numberp d2) (> d2 0))
                              (cl-boids-gpu::timer-remove-boids 300 50)))
                        (:player4 50)
                        (lambda (d2)
                          (if (and (numberp d2) (> d2 0))
                              (cl-boids-gpu::timer-add-boids 300 50)))
                        (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 64 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 64 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 41 0 0 0 64 41 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (66 31 127 127 1 0 0 54 0 0 0 0 0 0 0 0 127 96 0 97 0 0 33 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 50 :boids-per-click 5 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 8.044468 :maxforce 0.6895259
                        :maxidx 317 :length 5 :sepmult 8.0 :alignmult 1.0 :cohmult 7.8346457
                        :predmult 1 :maxlife 60000.0 :lifemult 322.83466 :max-events-per-tick 10)
                       :audio-args (:default (apr 26) :player1 (apr 26)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (104 127 124 0 82 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      nil nil nil nil nil nil nil nil
                      (:boid-params
                       (:num-boids 3610 :boids-per-click 50 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((1 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 1.0 :maxspeed 21.0 :maxforce 1.8000001 :maxidx
                        317 :length 5 :sepmult 5.7401576 :alignmult 8.0 :cohmult 7.5039372
                        :predmult 1 :maxlife 60000.0 :lifemult 81.88976 :max-events-per-tick 10)
                       :audio-args (:default (apr 93) :player1 (apr 37)) :midi-cc-fns
                       (:nk2 :nk2-mass :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2))))
                        (:nk2 6)
                        (with-lin-midi-fn (0 50)
                          (setf *clockinterv* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 64 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (127 86 118 127 104 78 0 76 0 0 0 0 0 0 0 0 125 127 17 40 0 127 0 127 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      nil nil nil nil
                      (:boid-params
                       (:num-boids 50 :boids-per-click 50 :clockinterv 2 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp (m-exp (aref *cc-state* 4 21) 0 1) :maxspeed
                        8.044468 :maxforce 0.6895259 :maxidx 317 :length 5 :sepmult 8.0 :alignmult
                        1.0 :cohmult 7.8346457 :predmult 1 :maxlife 60000.0 :lifemult 322.83466
                        :max-events-per-tick 10)
                       :audio-args (:default (apr 40) :player1 (apr 40)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (104 127 124 0 82 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 3550 :boids-per-click 100 :clockinterv 2 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 0.105 :maxforce 0.009000001
                        :maxidx 317 :length 5 :sepmult 1.0 :alignmult 1.0551181 :cohmult 1.0
                        :predmult 1 :maxlife 60000.0 :lifemult 0.0 :max-events-per-tick 10)
                       :audio-args (:default (apr 41) :player1 (apr 41)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :boid-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (96 116 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 50 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      nil nil nil
                      (:boid-params
                       (:num-boids 50 :boids-per-click 50 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp (m-exp-zero (aref *cc-state* 4 21) 0.001 1)
                        :maxspeed 8.044468 :maxforce 0.6895259 :maxidx 317 :length 5 :sepmult 8.0
                        :alignmult 1.0 :cohmult 7.8346457 :predmult 1 :maxlife 60000.0 :lifemult
                        322.83466 :max-events-per-tick 10)
                       :audio-args (:default (apr 45) :player1 (apr 45)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (104 127 124 0 82 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 10 :boids-per-click 50 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp (m-exp-zero (aref *cc-state* 4 21) 0.001 1)
                        :maxspeed 0.105 :maxforce 0.009000001 :maxidx 317 :length 5 :sepmult 1.0
                        :alignmult 1.0 :cohmult 1.0 :predmult 1.0 :maxlife 60000.0 :lifemult 0.0
                        :max-events-per-tick 10)
                       :audio-args (:default (apr 46) :player1 (apr 46)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 10 :boids-per-click 50 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp (m-exp-zero (aref *cc-state* 4 21) 0.001 1)
                        :maxspeed 0.105 :maxforce 0.009000001 :maxidx 317 :length 5 :sepmult 1.0
                        :alignmult 1.0 :cohmult 1.0 :predmult 1.0 :maxlife 60000.0 :lifemult 0.0
                        :max-events-per-tick 10)
                       :audio-args (:default (apr 47) :player1 (apr 47)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 10 :boids-per-click 50 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp (m-exp-zero (aref *cc-state* 4 21) 0.001 1)
                        :maxspeed 0.105 :maxforce 0.009000001 :maxidx 317 :length 5 :sepmult 1.0
                        :alignmult 1.0 :cohmult 1.0 :predmult 1.0 :maxlife 60000.0 :lifemult 0.0
                        :max-events-per-tick 10)
                       :audio-args (:default (apr 48) :player1 (apr 48)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      nil nil nil nil nil nil nil nil nil nil nil
                      (:boid-params
                       (:num-boids 2155 :boids-per-click 100 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 1.0859671 :maxforce
                        0.093082905 :maxidx 317 :length 44 :sepmult 6.897638 :alignmult 1.0
                        :cohmult 5.4094486 :predmult 1 :maxlife 60000.0 :lifemult 401.5748
                        :max-events-per-tick 10)
                       :audio-args (:default (apr 61) :player1 (apr 2)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 1000)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (56 107 80 0 102 17 0 32 0 0 0 0 0 0 0 0 16 56 0 0 52 0 0 127 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      (:boid-params
                       (:num-boids 2155 :boids-per-click 100 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 1.0859671 :maxforce
                        0.093082905 :maxidx 317 :length 44 :sepmult 6.897638 :alignmult 1.0
                        :cohmult 5.4094486 :predmult 1 :maxlife 60000.0 :lifemult 401.5748
                        :max-events-per-tick 10)
                       :audio-args (:default (apr 61) :player1 (apr 2)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 1000)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (56 107 80 0 102 17 0 32 0 0 0 0 0 0 0 0 16 56 0 0 52 0 0 127 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      nil nil nil nil
                      (:boid-params
                       (:num-boids 3013 :boids-per-click 100 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.001 :maxspeed 21.0 :maxforce 1.8000001
                        :maxidx 317 :length 5 :sepmult 1.0 :alignmult 1.0 :cohmult 1.0 :predmult 1
                        :maxlife 60000.0 :lifemult 177.16536 :max-events-per-tick 10)
                       :audio-args
                       (:default (apr 18) :player1 (apr 46) :player2 (apr 28) :player3 (apr 22))
                       :midi-cc-fns
                       (:nk2 :nk2-std2 :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :boid-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (127 127 0 0 53 127 127 64 0 0 0 0 0 0 0 0 127 24 19 127 0 0 53 48 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      nil nil nil nil nil nil nil nil nil nil nil nil nil
                      (:boid-params
                       (:num-boids 115 :boids-per-click 5 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.02344654 :maxspeed 1.7183772 :maxforce
                        0.14728948 :maxidx 317 :length 11 :sepmult 4.5826774 :alignmult 4.913386
                        :cohmult 3.3149607 :predmult 1 :maxlife 60000.0 :lifemult 433.07086
                        :max-events-per-tick 10)
                       :audio-args (:default (apr 61) :player1 (apr 61)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (67 49 42 71 94 103 0 107 0 0 0 0 0 0 0 0 0 37 34 0 49 0 77 127 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                      nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
                      (:boid-params
                       (:num-boids 37 :boids-per-click 5 :clockinterv 0 :speed 2.0
                        :obstacles-lookahead 2.5 :obstacles ((4 25) (4 25) (4 25) (4 25))
                        :curr-kernel "boids" :bg-amp 0.02344654 :maxspeed 0.114136875 :maxforce
                        0.009783161 :maxidx 317 :length 250 :sepmult 8.0 :alignmult 4.3622046
                        :cohmult 6.7874017 :predmult 1 :maxlife 60000.0 :lifemult 275.59055
                        :max-events-per-tick 10)
                       :audio-args (:default (apr 61) :player1 (apr 2)) :midi-cc-fns
                       (:nk2 :nk2-std :player1 :obst-ctl1 :player2 :obst-ctl1 :player3 :obst-ctl1
                        :player4 :obst-ctl1 (:nk2 20)
                        (with-exp-midi-fn (5 250)
                          (setf *length* (round (funcall ipfn d2)))))
                       :midi-cc-state
                       #2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 110 0 0 0 0 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 109 0 0 0 0 109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 106 0 0 0 0 106 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            19 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (2 127 105 61 7 0 0 105 0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 127 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                           (0 0 102 0 0 0 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))))


(defun r-getf (seq &rest props)
  (reduce #'getf-or-elt props :initial-value seq))

(defun getf-or-elt (seq id)
  (cond
    ((numberp id) (elt seq id))
    (t (getf seq id))))

(index-seq (map 'list (lambda (preset) (r-getf preset :audio-args)) *presets-2018*))

(index-seq (map 'list (lambda (preset) (list (second (r-getf preset :audio-args :default)))) *presets-2018*))

((0 0) (1 94) (2 94) (3 91) (4 92) (5 17) (6 18) (7 19) (8 91) (9 92) (10 0)
 (11 0) (12 0) (13 91) (14 92) (15 17) (16 18) (17 19) (18 18) (19 19) (20 nil)
 (21 21) (22 61) (23 23) (24 nil) (25 23) (26 26) (27 nil) (28 nil) (29 nil)
 (30 nil) (31 nil) (32 nil) (33 nil) (34 nil) (35 93) (36 nil) (37 nil)
 (38 nil) (39 nil) (40 40) (41 41) (42 nil) (43 nil) (44 nil) (45 45) (46 46)
 (47 47) (48 48) (49 nil) (50 nil) (51 nil) (52 nil) (53 nil) (54 nil) (55 nil)
 (56 nil) (57 nil) (58 nil) (59 nil) (60 61) (61 61) (62 nil) (63 nil) (64 nil)
 (65 nil) (66 18) (67 nil) (68 nil) (69 nil) (70 nil) (71 nil) (72 nil)
 (73 nil) (74 nil) (75 nil) (76 nil) (77 nil) (78 nil) (79 nil) (80 61)
 (81 nil) (82 nil) (83 nil) (84 nil) (85 nil) (86 nil) (87 nil) (88 nil)
 (89 nil) (90 nil) (91 nil) (92 nil) (93 nil) (94 nil) (95 nil) (96 nil)
 (97 nil) (98 nil) (99 61))

'((0 :default (apr 0))
  (1 :default (apr 94) :player1 (apr 1) :player2 (apr 2) :player3 (apr 3) :player4 (apr 4))
  (2 :default (apr 94) :player1 (apr 11) :player2 (apr 12) :player3 (apr 13) :player4 (apr 14))
  (3 :default (apr 91) :player1 (apr 89) :player2 (apr 89) :player3 (apr 89) :player4 (apr 89))
  (4 :default (apr 92) :player1 (apr 37) :player2 (apr 37) :player3 (apr 37))
  (5 :default (apr 17) :player1 (apr 37) :player2 (apr 37) :player3 (apr 37))
  (6 :default (apr 18) :player1 (apr 46) :player2 (apr 28) :player3 (apr 22))
  (7 :default (apr 19) :player1 (apr 19) :player2 (apr 19) :player3 (apr 19))
  (8 :default (apr 91) :player1 (apr 91) :player2 (apr 91) :player3 (apr 91) :player4 (apr 91))
  (9 :default (apr 92) :player1 (apr 37) :player2 (apr 37) :player3 (apr 37)) (10 :default (apr 0))
  (11 :default (apr 0) :player1 (apr 1) :player2 (apr 2) :player3 (apr 3) :player4 (apr 4))
  (12 :default (apr 0) :player1 (apr 1) :player2 (apr 2) :player3 (apr 3) :player4 (apr 4))
  (13 :default (apr 91) :player1 (apr 91) :player2 (apr 91) :player3 (apr 91) :player4 (apr 91))
  (14 :default (apr 92) :player1 (apr 37) :player2 (apr 37) :player3 (apr 37))
  (15 :default (apr 17) :player1 (apr 37) :player2 (apr 37) :player3 (apr 37))
  (16 :default (apr 18) :player1 (apr 46) :player2 (apr 28) :player3 (apr 22))
  (17 :default (apr 19) :player1 (apr 19) :player2 (apr 19) :player3 (apr 19))
  (18 :default (apr 18) :player1 (apr 18))
  (19 :default (apr 19) :player1 (apr 19))
  (20)
  (21 :default (apr 21) :player1 (apr 21))
  (22 :default (apr 61) :player1 (apr 22))
  (23 :default (apr 23) :player1 (apr 23) :player4 (apr 23)) (24)
  (25 :default (apr 23) :player1 (apr 25))
  (26 :default (apr 26) :player1 (apr 26))
  (27) (28) (29) (30) (31) (32) (33) (34)
  (35 :default (apr 93) :player1 (apr 37))
  (36) (37) (38) (39)
  (40 :default (apr 40) :player1 (apr 40))
  (41 :default (apr 41) :player1 (apr 41))
  (42) (43) (44)
  (45 :default (apr 45) :player1 (apr 45))
  (46 :default (apr 46) :player1 (apr 46))
  (47 :default (apr 47) :player1 (apr 47))
  (48 :default (apr 48) :player1 (apr 48))
  (49) (50) (51) (52) (53) (54) (55) (56) (57) (58) (59)
  (60 :default (apr 61) :player1 (apr 2))
  (61 :default (apr 61) :player1 (apr 2))
  (62) (63) (64) (65)
  (66 :default (apr 18) :player1 (apr 46) :player2 (apr 28) :player3 (apr 22))
  (67) (68) (69) (70) (71) (72) (73) (74) (75) (76) (77) (78) (79)
  (80 :default (apr 61) :player1 (apr 61))
  (81) (82) (83) (84) (85) (86) (87) (88) (89) (90) (91) (92) (93) (94) (95) (96) (97) (98)
  (99 :default (apr 61) :player1 (apr 2)))

(reduce #'elt idxs :initial-value seq)

(digest-audio-preset-form
   '(:p1 (if (<= (random 1.0) (m-lin (nk2-ref 21) 0 1))
             0.6
             (m-exp (nk2-ref 19) 0.01 0.6))
     :p2 (if (<= (random 1.0) (m-lin (nk2-ref 20) 0 1))
             1
             0)
     :p3 0
     :p4 0
     :pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
     :ampfn (* (sign) (expt (m-exp (nk2-ref 5) 0.1 1) p2)
             (m-exp-zero (player-cc tidx 7) 0.01 1) (+ 0.4 (random 0.6)))
     :durfn p1
     :suswidthfn 0
     :suspanfn 0.3
     :decay-startfn 0.001
     :decay-endfn 0.002
     :lfo-freqfn (* 1
                  (expt
                   (round
                    (*
                     (if (zerop p2)
                         1
                         16)
                     y))
                   (n-lin x 1 (m-lin (nk2-ref 16) 1 1.5)))
                  (hertz (m-lin (nk2-ref 17) 31 55))
                  (n-exp-dev (m-lin (nk2-ref 18) 0 1) 1.5))
     :x-posfn x
     :y-posfn y
     :wetfn (m-lin (nk2-ref 23) 0 1)
     :filt-freqfn (n-exp y 200 10000)
     :bp-freq (n-exp y 100 5000)
     :bp-rq (m-lin (nk2-ref 22) 1 0.01))
   (aref *audio-presets* 91))

(digest-audio-preset-form
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (n-exp y 0.4 1.2)
   :ampfn (* (sign) (m-exp-zero (player-cc tidx 7) 0.01 1) (+ 0.1 (random 0.6)))
   :durfn (n-exp y 0.8 0.16)
   :suswidthfn 0
   :suspanfn 0.3
   :decay-startfn 0.001
   :decay-endfn 0.02
   :lfo-freqfn (* (expt (round (* 16 y)) (n-lin x 1 (m-lin (nk2-ref 16) 1 1.5)))
                (hertz (m-lin (nk2-ref 17) 31 55)))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 23) 0 1)
   :filt-freqfn (n-exp y 200 10000))
 (aref *audio-presets* 92))

(digest-audio-preset-form
 '(:p1 (if (<= (random 1.0) (m-lin (nk2-ref 21) 0 1))
           0.8
           (m-exp (nk2-ref 19) 0.01 0.8))
   :p2 (if (<= (random 1.0) (m-lin (nk2-ref 20) 0 1))
           1
           0)
   :p3 0
   :p4 0
   :pitchfn (* (n-exp y 0.4 1.2) 0.63951963)
   :ampfn (* (sign) (expt (m-exp (nk2-ref 5) 0.1 1) p2)
           (m-exp-zero (player-cc tidx 7) 0.01 1) (+ 0.1 (random 0.6)))
   :durfn p1
   :suswidthfn 0.1
   :suspanfn 0.3
   :decay-startfn 0.001
   :decay-endfn 0.02
   :lfo-freqfn (*
                (expt
                 (round
                  (*
                   (if (zerop p2)
                       1
                       (round (m-lin (nk2-ref 18) 1 16)))
                   y))
                 (n-lin x 1 (m-lin (nk2-ref 16) 1 1.5)))
                (hertz (m-lin (nk2-ref 17) 31 55)))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 23) 0 1)
   :filt-freqfn (n-exp y 200 10000)
   :bp-freq (n-exp y 100 5000)
   :bp-rq (m-lin (nk2-ref 22) 1 0.01))
 (aref *audio-presets* 93))
(digest-audio-preset-form
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
   :ampfn (* (sign) (n-exp y 1 0.5) (m-exp-zero (player-cc 4 100) 0.01 2))
   :durfn (* (m-exp (nk2-ref 21) 0.1 1) (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decay-startfn 5.0e-4
   :decay-endfn 0.002
   :lfo-freqfn (* (m-exp (nk2-ref 19) 0.25 1) (r-exp 45 45))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 23) 0 1)
   :filt-freqfn (n-exp y 1000 10000)
   :bp-freq (n-exp y 100 5000)
   :bp-rq (m-lin (nk2-ref 22) 1 0.01))
 (aref *audio-presets* 94))

(digest-audio-preset-form
 '(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   :p1 0
   :p2 0
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.4 1.2)
   :ampfn (* (sign) (mc-exp-zero 8 0.01 1) (+ 0.1 (random 0.6)))
   :durfn (n-exp y 0.8 0.16)
   :suswidthfn 0
   :suspanfn 0.3
   :decaystartfn 0.001
   :decayendfn 0.02
   :lfofreqfn (* (expt (1+ (round (* 16 y))) (n-lin x 1 (mc-lin 12 1 1.5)))
               (hertz (mc-lin 9 31 55))
               (n-exp-dev (mc-lin 10 0 1) 1.5))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (n-exp y 200 10000))
 :audio-preset (aref *audio-presets* 32))

(digest-audio-preset-form
 '(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   :p1 (if (<= (random 1.0) (mc-lin 6 0 1))
           0.8
           (mc-exp 4 0.01 0.8))
   :p2 (if (<= (random 1.0) (mc-lin 5 0 1))
           1
           0)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.256 0.77)
   :ampfn (* (sign) (expt (mc-exp 8 0.1 1) p2) (mc-exp-zero 7 0.01 1)
           (+ 0.1 (random 0.6)))
   :durfn p1
   :suswidthfn 0.1
   :suspanfn 0.3
   :decaystartfn 0.001
   :decayendfn 0.02
   :lfofreqfn (*
               (expt
                (round
                 (*
                  (if (zerop p2)
                      1
                      (1+ (round (mc-lin 11 1 16))))
                  y))
                (n-lin x 1 (mc-lin 12 1 1.5)))
               (hertz (mc-lin 9 31 55)))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (n-exp y 200 10000)
   :bpfreq (n-exp y 100 5000)
   :bprq (mc-lin 15 1 0.01))
 :audio-preset (aref *audio-presets* 33))

(digest-audio-preset-form
 '(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   :p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.448 0.831)
   :ampfn (* (sign) (n-exp y 1 0.5) (mc-exp-zero 8 0.01 2))
   :durfn (* (mc-exp 14 0.1 1) (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (mc-exp 9 0.25 1) (r-exp 45 45))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :bpfreq (n-exp y 100 5000)
   :bprq (mc-lin 15 1 0.01))
 :audio-preset (aref *audio-presets* 34))

(digest-audio-preset-form
 '(:p1 0
   :p2 (m-lin (nk2-ref 6) 0 1)
   :p3 0
   :p4 0
   :pitchfn (n-exp y 0.4 (m-lin (nk2-ref 19) 0.8 1.2))
   :ampfn (* (m-exp-zero (player-cc tidx 7) 0.01 1) (sign) (+ 0.1 (random 0.6)))
   :durfn (+ (* (- 1 p2) (n-exp y 0.8 0.16)) (* p2 (m-exp (nk2-ref 16) 0.1 0.5)))
   :suswidthfn (* p2 0.5)
   :suspanfn 0.3
   :decay-startfn (n-lin p2 0.001 0.03)
   :decay-endfn (n-lin p2 0.02 0.03)
   :lfo-freqfn (n-lin p2
                (*
                 (expt (round (* 16 y))
                  (n-lin x 1 (m-lin (nk2-ref 16) 1 1.5)))
                 (hertz (m-lin (nk2-ref 17) 31 55)))
                (* (n-exp y 0.8 1.2) (m-exp (nk2-ref 18) 50 400)
                 (n-exp-dev (m-lin (nk2-ref 17) 0 1) 0.5)))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 22) 0 1)
   :filt-freqfn (* (n-exp y 1 2) (m-exp (nk2-ref 23) 100 10000)))
 (aref *audio-presets* 17))

(digest-audio-preset-form
 '(:p1 (m-lin (nk2-ref 21) 0 1)
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :pitchfn (n-exp y 0.4 (m-lin (nk2-ref 19) 0.8 1.2))
   :ampfn (* (m-exp-zero (player-cc tidx 7) 0.01 1) (sign) (n-exp y 0.7 0.35))
   :durfn (m-exp (nk2-ref 16) 0.1 0.5)
   :suswidthfn 0.5
   :suspanfn 0.3
   :decay-startfn 0.03
   :decay-endfn 0.03
   :lfo-freqfn (+
                (* (- 1 p1) (n-exp y 0.8 1.2) (m-exp (nk2-ref 18) 50 400)
                 (n-exp-dev (m-lin (nk2-ref 17) 0 1) 0.5))
                (* p1 12.5 (expt 2 (+ 2 (random 4)))))
   :x-posfn x
   :y-posfn y
   :wetfn (m-lin (nk2-ref 22) 0 1)
   :filt-freqfn (* (n-exp y 1 2) (m-exp (nk2-ref 23) 100 10000)))
 (aref *audio-presets* 18))

(digest-audio-preset-form
   '(:p1 1
     :p2 (- p1 1)
     :p3 0
     :p4 0
     :pitchfn (n-exp y 0.4 0.8)
     :ampfn (* (sign) (m-exp-zero (aref *cc-state* *nk2-chan* 7) 0.01 1)
             (+ 0.1 (random 0.8)))
     :durfn (n-exp (random 1.0) 0.01 0.8)
     :suswidthfn 0.5
     :suspanfn 0.3
     :decay-startfn 0.03
     :decay-endfn 0.03
     :lfo-freqfn (* 12.5 (expt 2 (+ 2 (random 4))))
     :x-posfn x
     :y-posfn y
     :wetfn 1
     :filt-freqfn (m-exp (aref *cc-state* *nk2-chan* 23) 100 10000))
   (aref *audio-presets* 19))


(digest-audio-preset-form
 '(:cc-state #(0 0 1 0 127 83 0 0 0 0 0 0 0 0 0 127)
   :p1 (if (<= (random 1.0) (m-lin (mc-ref 6) 0 1))
           0.6
           (m-exp (mc-ref 5) 0.01 0.6))
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (* (n-exp y 0.7 1.3) 0.63951963)
   :ampfn (* (sign) 1 (n-exp y 1 0.5))
   :durfn 1
   :suswidthfn (+ 0.1 (random 0.3))
   :suspanfn (random p1)
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn 45
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 16) 0 1)
   :filtfreqfn (* (n-exp (random 1.0) 1 10) 1000))
 :audio-preset (aref *audio-presets* 3))

(digest-audio-preset-form
 '(:cc-state #(127 30 127 0 39 127 0 27 0 1 0 105 9 56 0 127)
   :p1 0
   :p2 0
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (n-exp y 0.45 1)
   :ampfn (* (sign) (n-exp y 1 0.5))
   :durfn (* (expt (min 2 (/ v)) (mcn-ref 13)) (mc-exp 14 0.1 1) (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (n-exp x 1 1)
               (expt (1+ (round (* 16 y (mcn-ref 11)))) (mc-lin 12 1 1.5))
               (mc-exp 9 10 200) (mc-exp-dev 10 1.2))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :vowel y
   :voicetype (random 5)
   :voicepan (mcn-ref 1)
0   :bpfreq (n-exp y 1000 5000)
   :bprq (mc-exp 15 1 0.01)
   :bppan (mcn-ref 3))
 :audio-preset (aref *audio-presets* 1))

(cl-boids-gpu::audio-args (aref *bs-presets* 45))

(bs-state-recall
 45
 :load-obstacles nil
 :load-audio t
 :load-boids nil)


(digest-audio-preset-form
 '(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   :p1 0
   :p2 0
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.4 1.2)
   :ampfn (* (sign) (mc-exp-zero 8 0.01 1) (+ 0.1 (random 0.6)))
   :durfn (n-exp y 0.8 0.16)
   :suswidthfn 0
   :suspanfn 0.3
   :decaystartfn 0.001
   :decayendfn 0.02
   :lfofreqfn (* (expt (1+ (round (* 16 y))) (n-lin x 1 (mc-lin 12 1 1.5)))
               (hertz (mc-lin 9 31 55)) (n-exp-dev (mc-lin 10 0 1) 1.5))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (n-exp y 200 10000))
 :audio-preset (aref *audio-presets* 32))

(digest-audio-preset-form
 '(:cc-state #(127 113 0 127 0 0 127 127 0 0 0 0 0 0 0 0)
   :p1 (mc-lin 6 0 1)
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :synth 0
   :pitchfn (n-exp y 0.4 (mc-lin 4 0.8 1.2))
   :ampfn (* (sign) (n-exp y 0.7 0.35))
   :durfn (m-exp (mc-ref 1) 0.1 0.5)
   :suswidthfn 0.5
   :suspanfn 0.3
   :decaystartfn 0.03
   :decayendfn 0.03
   :lfofreqfn (+
               (* (- 1 p1) (n-exp y 0.8 1.2) (m-exp (mc-ref 3) 50 400)
                (n-exp-dev (mc-lin 2 0 1) 0.5))
               (* p1 12.5 (expt 2 (+ 2 (random 4)))))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 7 0 1)
   :filtfreqfn (* (n-exp y 1 2) (m-exp (mc-ref 8) 100 10000)))
 :audio-preset (aref *audio-presets* 18))


(digest-audio-preset-form
 '(:cc-state #(127 113 0 0 0 0 127 127 0 0 0 0 0 0 0 117)
   :p1 (mc-lin 6 0 1)
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :synth 0
   :pitchfn (n-exp y 0.4 (mc-lin 11 0.8 1.2))
   :ampfn (* (sign) (n-exp y 0.7 0.35))
   :durfn (m-exp (mc-ref 14) 0.1 0.5)
   :suswidthfn 0.5
   :suspanfn 0.3
   :decaystartfn 0.03
   :decayendfn 0.03
   :lfofreqfn (+
               (* (- 1 p1) (n-exp y 0.8 1.2) (mc-exp 9 50 400)
                (n-exp-dev (mc-lin 10 0 1) 0.5))
               (* p1 12.5 (expt 2 (+ 2 (random 4)))))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (* (n-exp y 1 2) (m-exp (mc-ref 15) 100 10000)))
 :audio-preset (aref *audio-presets* 3))

(digest-audio-preset-form
 '(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   :p1 0
   :p2 (mc-lin 5 0 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.4 0.8)
   :ampfn (* (sign) (+ 0.1 (random 0.6)))
   :durfn (n-exp y 0.8 0.16)
   :suswidthfn 0
   :suspanfn 0.3
   :decaystartfn 0.001
   :decayendfn 0.02
   :lfofreqfn (* (expt (1+ (round (* 16 y))) (n-lin x 1 (mc-lin 1 1 1.5)))
                (hertz (mc-lin 2 31 55)))
   :xposfn x
   :yposfn y
   :wetfn 0
   :filtfreqfn (* (n-exp y 1 2) 100))
 :audio-preset (aref *audio-presets* 17))

(digest-audio-preset-form
 '(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   :p1 0
   :p2 (mc-lin 5 0 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.4 (mc-lin 4 0.8 1.2))
   :ampfn (* (sign) (+ 0.1 (random 0.6)))
   :durfn (+ (* (- 1 p2) (n-exp y 0.8 0.16)) (* p2 (mc-exp 1 0.1 0.5)))
   :suswidthfn (* p2 0.5)
   :suspanfn 0.3
   :decaystartfn (n-lin p2 0.001 0.03)
   :decayendfn (n-lin p2 0.02 0.03)
   :lfofreqfn (n-lin p2
               (* (expt (1+ (round (* 16 y))) (n-lin x 1 (mc-lin 1 1 1.5)))
                (hertz (mc-lin 2 31 55)))
               (* (n-exp y 0.8 1.2) (mc-exp 3 50 400)
                (n-exp-dev (mc-lin 2 0 1) 0.5)))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 7 0 1)
   :filtfreqfn (* (n-exp y 1 2) (mc-exp 8 100 10000)))
 :audio-preset (aref *audio-presets* 17))




(digest-audio-preset-form
 '(:cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   :p1 0
   :p2 (mc-lin 5 0 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.4 (mc-lin 4 0.8 1.2))
   :ampfn (* (sign) (+ 0.1 (random 0.6)))
   :durfn (+ (* (- 1 p2) (n-exp y 0.8 0.16)) (* p2 (mc-exp 1 0.1 0.5)))
   :suswidthfn (* p2 0.5)
   :suspanfn 0.3
   :decaystartfn (n-lin p2 0.001 0.03)
   :decayendfn (n-lin p2 0.02 0.03)
   :lfofreqfn (n-lin p2
               (* (expt (1+ (round (* 16 y))) (n-lin x 1 (mc-lin 1 1 1.5)))
                (hertz (mc-lin 2 31 55)))
               (* (n-exp y 0.8 1.2) (mc-exp 3 50 400)
                (n-exp-dev (mc-lin 2 0 1) 0.5)))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 7 0 1)
   :filtfreqfn (* (n-exp y 1 2) (mc-exp 8 100 10000)))
 :audio-preset (aref *audio-presets* 17))


(0 0)
(1 94) -> 34 -> 0/1
(2 94)
(3 91) -> 31 -> 2
(4 92) -> 32
(5 17) ->
(6 18) ->
(7 19) ->
(8 91)
(9 92)

AUdio Preset 3 retten!


(ftom 200)

(n-lin p2 3.5 31) 55
(mc-exp 9 10 200)


(digest-audio-preset-form
 '(:cc-state #(0 0 0 0 0 0 0 0 0 113 0 0 0 127 127 127)
   :p1 (mc-lin 6 0 1)
   :p2 0
   :p3 0
   :p4 0
   :synth 0
   :synth 0
   :pitchfn (n-exp y 0.4 (mc-lin 11 0.8 1.2))
   :ampfn (* (sign) (n-exp y 0.7 0.35))
   :durfn (m-exp (mc-ref 14) 0.1 0.5)
   :suswidthfn 0.5
   :suspanfn 0.3
   :decaystartfn 0.03
   :decayendfn 0.03
   :lfofreqfn (+
               (* (- 1 p1) (n-exp y 0.8 1.2) (mc-exp 9 50 400)
                (n-exp-dev (mc-lin 10 0 1) 0.5))
               (* p1 12.5 (expt 2 (+ 2 (random 4)))))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (* (n-exp y 1 2) (m-exp (mc-ref 15) 100 10000)))
 :audio-preset (aref *audio-presets* 3))


(digest-audio-preset-form
 '(:cc-state #(127 30 127 0 39 127 0 27 59 0 3 123 9 56 127 127)
   :p1 0
   :p2 0
   :p3 0
   :p4 0
   :synth 1
   :pitchfn (n-exp y 0.45 0.831)
   :ampfn (* (sign) (n-exp y 1 0.5))
   :durfn (* (expt (min 2 (/ v)) (mcn-ref 13)) (m-exp (mc-ref 14) 0.1 1)
           (r-exp 0.2 0.6))
   :suswidthfn 0.3
   :suspanfn 0
   :decaystartfn 5.0e-4
   :decayendfn 0.002
   :lfofreqfn (* (n-exp x 1 1)
               (expt (1+ (round (* 15 y (mcn-ref 11)))) (mc-lin 12 1 1.5))
               (mc-exp 9 0.25 4) 45 (mc-exp-dev 10 1.2))
   :xposfn x
   :yposfn y
   :wetfn (mc-lin 16 0 1)
   :filtfreqfn (n-exp y 1000 10000)
   :vowel y
   :voicetype (random 5)
   :voicepan (mcn-ref 1)
   :bpfreq (n-exp y 1000 5000)
   :bprq (mc-exp 15 1 0.01)
   :bppan (mcn-ref 3))
 :audio-preset (aref *audio-presets* 99))
*obstacles*
(ct->fv 100)


(c2v (n-lin-pm (* 0 (mcn-ref 10)) 2))

(n-lin-pm (* 1 (mcn-ref 10)) 12)

(c2v (n-lin-pm 0 (* (mcn-ref 10) 12)))

(n-lin-pm 1 (* (mcn-ref 10) 12))
