;;; 
;;; bs-presets.lisp
;;;
;;; Utils to store the complete state of the boid system with all
;;; positions, velocities, etc. in presets. The presets are stored in
;;; an array of 100 elems. Each array element contains an instance of
;;; a 'boid-system-state class. The parameter *curr-boid-state* is set
;;; on each frame in the gl loop. Storing the state is done with the
;;; save-boid-system-state function. It simply means copying the
;;; *curr-boid-state* into the array at the given preset idx.
;;;
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

(defparameter *bs-presets* (make-array 100
                                       :element-type
                                       'cl-boids-gpu::boid-system-state
                                       :initial-contents
                                       (loop
                                         for x below 100
                                         collect (make-instance 'cl-boids-gpu::boid-system-state))))

(defun bs-state-save (num)
  "save the current state of the boid system in the *bs-presets* array
at num."
  (let ((curr-bs-state (ou:ucopy *curr-boid-state*)))
    (setf (slot-value curr-bs-state 'cl-boids-gpu::bs-preset) *curr-preset*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::maxforce) *maxforce*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::maxspeed) *maxspeed*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::sepmult) *sepmult*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::cohmult) *cohmult*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::alignmult) *alignmult*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::predmult) *predmult*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::len) *length*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::maxlife) *maxlife*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::lifemult) *lifemult*)
    (setf (slot-value curr-bs-state 'cl-boids-gpu::bs-obstacles) (ou:ucopy *obstacles*))
    (setf (slot-value curr-bs-state 'cl-boids-gpu::note-states)
          (alexandria:copy-array *note-states*))
    (setf (slot-value curr-bs-state 'cl-boids-gpu::midi-cc-state)
          (alexandria:copy-array *cc-state*))
    (setf (slot-value curr-bs-state 'cl-boids-gpu::midi-cc-fns)
          (getf *curr-preset* :midi-cc-fns))
    (setf (slot-value curr-bs-state 'cl-boids-gpu::audio-args)
          (getf *curr-preset* :audio-args))
    (setf (aref *bs-presets* num) curr-bs-state)))

(defun store-bs-presets (&optional (file *bs-presets-file*))
  "store the whole *bs-presets* array to disk."
  (cl-store:store *bs-presets* file)
  (format t "~&bs-presets stored to ~a." (namestring file))
  (if (string/= (namestring file) (namestring *bs-presets-file*))
      (setf *bs-presets-file* file)))

(defun restore-bs-presets (&optional (file *bs-presets-file*))
  "restore the whole *bs-presets* array from disk."
  (setf *bs-presets* (cl-store:restore file))
  (format t "~&bs-presets restored from ~a." (namestring file))
  (if (string/= (namestring file) (namestring *bs-presets-file*))
      (setf *bs-presets-file* file)))

(defun digest-audio-args (defs)
  (set-default-audio-preset (getf defs :default))
  (loop for (key val) on defs by #'cddr
        do (digest-audio-arg key (eval val))))

;;; in bs-state-recall we recall the state of the boid system and
;;; selectively the cc, note and audio state of all players. If the
;;; keyword argument of any of the states is t (the default), than the
;;; complete state of the keyword's saved state will get recalled. If
;;; it is a list, the list should contain the keynames of the players
;;; to be restored.  Example: (bs-state-recall :audio '(:player1
;;; :player3)) will recall the audio preset of player1 and player3
;;; only. Be aware that the midi-cc-fns can also contain direct
;;; definitions of (player cc) pairs. ATM these only get restored, if
;;; :midi-cc-fns is t. (These absolute definitions in :midi-cc-fns of
;;; presets are a little hackish anyway and probably should get
;;; removed altogether as they can be expressed more elegantly in the
;;; context of a respective player rather than hardcoded).

(defun cp-player-cc (player-idx src target)
  (dotimes (idx 128)
    (setf (aref target player-idx idx)
          (aref src player-idx idx))))



(defun bs-state-recall (num &key (audio t)
                              (note-states t) (cc-state t) (cc-fns t)
                              (obstacles-protect nil))
  "recall the state of the boid system in the *bs-presets* array at
num. This is a twofold process: 
1. The boid system has to be resored in the gl-context with #'restore-bs-from-preset.

2. The obstacles, gui, audio and cc-settings have to get reset."
  (let ((bs-preset (aref *bs-presets* num)))
    (when (cl-boids-gpu::bs-positions bs-preset)
        (setf cl-boids-gpu::*switch-to-preset* num) ;;; tell the gl-engine to load the boid-system in the next frame.
        (reset-obstacles-from-bs-preset (slot-value bs-preset 'cl-boids-gpu::bs-obstacles) obstacles-protect)
        ;;; handle audio, cc-fns, cc-state and note-states
        (loop
          for (key slot) in '((:num-boids cl-boids-gpu::bs-num-boids)
                              (:maxspeed cl-boids-gpu::maxspeed)
                              (:maxforce cl-boids-gpu::maxforce)
                              (:length cl-boids-gpu::len)
                              (:sepmult cl-boids-gpu::sepmult)
                              (:cohmult cl-boids-gpu::cohmult)
                              (:alignmult cl-boids-gpu::alignmult)
                              (:predmult cl-boids-gpu::predmult)
                              (:maxlife cl-boids-gpu::maxlife)
                              (:lifemult cl-boids-gpu::lifemult))
          do (set-value key (slot-value bs-preset slot)))
        (if audio
            (let ((audio-args (slot-value bs-preset 'cl-boids-gpu::audio-args)))
              (if (consp audio)
                  (loop
                    for player in audio
                    do (let ((audio-arg (getf audio-args player)))
                         (if audio-arg
                             (case player
                               (:default (set-default-audio-preset audio-arg))
                               (otherwise (digest-audio-arg player (eval audio-arg)))))))
                  (progn
                    (setf (getf *curr-preset* :audio-args) audio-args)
                    (gui-set-audio-args (pretty-print-prop-list audio-args))
                    (digest-audio-args audio-args)))))
        (if note-states
            (let ((saved-note-states (slot-value bs-preset 'cl-boids-gpu::note-states)))
              (if (consp note-states)
                  (loop
                    for player in note-states
                    do (let ((idx (player-chan player)))
                         (setf (aref *note-states* idx)
                               (aref saved-note-states idx))))
                  (in-place-array-cp saved-note-states *note-states*))))
        (if cc-state
            (let ((saved-cc-state (slot-value bs-preset 'cl-boids-gpu::midi-cc-state)))
              (if (consp cc-state)
                  (loop
                    for player in cc-state
                    do (let ((player-idx (player-chan player)))
                         (cp-player-cc player-idx saved-cc-state *cc-state*)))
                  (in-place-array-cp saved-cc-state *cc-state*))))
        (if cc-fns
            (let ((saved-cc-fns (slot-value bs-preset 'cl-boids-gpu::midi-cc-fns))
                  (saved-cc-state (slot-value bs-preset 'cl-boids-gpu::midi-cc-state)))
              (if (consp cc-fns)
                  (loop
                    for player in cc-fns
                    for value = (getf saved-cc-fns player)
                    do (loop
                         for (key cc-def) on (funcall #'cc-preset player value) by #'cddr
                         do (with-cc-def-bound (fn reset) cc-def
                              (declare (ignore reset))
                              (digest-cc-def key fn saved-cc-state :reset nil))))
                  (progn
                    (clear-cc-fns *nk2-chan*)
                    (setf (getf *curr-preset* :midi-cc-fns) saved-cc-fns)
                    (digest-midi-cc-fns saved-cc-fns saved-cc-state)
                    (gui-set-midi-cc-fns (pretty-print-prop-list saved-cc-fns)))))))))

;;; (restore-bs-presets)

#|

(bs-state-save 0)
(bs-state-save 1)
(bs-state-save 2)
(bs-state-save 3)
(bs-state-save 4)
(bs-state-save 5)
(bs-state-save 6)
(bs-state-save 7)
(bs-state-save 8)
(bs-state-save 9)
(bs-state-save 10)
(bs-state-save 11)
(bs-state-save 12)
(bs-state-save 13)
(bs-state-save 14)
(bs-state-save 15)
(store-bs-presets)
(restore-bs-presets)

;;; recall preset (video only):
;;; (untrace)                                      ;
(bs-state-recall 0 :cc-state nil)
(bs-state-recall 0)
(bs-state-recall 1 :cc-state nil)
(bs-state-recall 1)
(bs-state-recall 2)
(bs-state-recall 3)
(bs-state-recall 4)
(bs-state-recall 5)
(bs-state-recall 6)
(bs-state-recall 7)
(bs-state-recall 8)
(bs-state-recall 9)
(bs-state-recall 10)
(bs-state-recall 11)
(bs-state-recall 12 :obstacles-protect '(:player1))
(bs-state-recall 13 :obstacles-protect '(:player2))
(bs-state-recall 13)
(bs-state-recall 14)
(bs-state-recall 15)
*curr-preset*

cl-boids-gpu::*obstacles*

(aref *obstacles* 0)
(aref *bs-presets* 12)



(set-value :lifemult 1500)
(setf *bs-presets* (cl-store:restore *bs-presets-file*))

(cl-store:store *bs-presets* "/tmp/test.lisp")

(setf *bs-presets* (cl-store:restore "/tmp/test.lisp"))

(cl-store:restore "/tmp/test.lisp")

(setf *bs-presets* nil)




|#

