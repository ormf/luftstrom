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

(defparameter *english-list*
  "~{~#[~;~a~;~a and ~a~:;~@{~a~#[~;, and ~:;, ~]~}~]~}")

(defparameter *bs-presets*
  (make-array 128
              :element-type
              'cl-boids-gpu::boid-system-state2
              :initial-contents
              (loop
                for x below 128
                collect (make-instance 'cl-boids-gpu::boid-system-state2))))

(defun bs-presets-change-notify ()
  "notify all controllers to update their state if bs-presets have
changed."
  (map nil #'bs-presets-change-handler
       (bs-preset-change-subscribers *bp*)))

#|
(defparameter *bs-presets-new* (make-array 128 :initial-contents (loop repeat 128 collect (make-instance 'cl-boids-gpu::boid-system-state2))))

(loop for i below 100 do
  (progn
    (format t "i: ~a~%" i))
  (cl-boids-gpu::cp-bstate (aref luftstrom-display::*bs-presets* i) (aref *bs-presets-new* i)))
|#

;;; (setf *bs-presets* *bs-presets-new*)


#|
(defun set-bs-preset-load-audio (state)
  (setf (val (cl-boids-gpu::load-audio *bp*))
        (or (> state 0)
            (not (val (cl-boids-gpu::load-boids *bp*))))))

(defun set-bs-preset-load-boids (state)
  (setf (val (cl-boids-gpu::load-boids *bp*))
        (or (> state 0)
            (not (val (cl-boids-gpu::load-audio *bp*))))))




|#

(defun replace-cc-state (proplist player-name)
  (setf (getf proplist :cc-state)
        (get-player-cc-state (player-aref player-name)))
  proplist)

(defun annotate-audio-preset-form (audio-args)
  "append the audio-preset form as :preset-form property to the
audio-arg declaration of each player. Skip preset-forms of already
used preset-nums."
  (let ((used-preset-nums '()))
    (loop for (player-name proplist) on audio-args by #'cddr
          for preset-num = (getf proplist :apr)
          append `(,player-name
                   ,(append
                     (replace-cc-state proplist player-name)
                     (unless (member preset-num used-preset-nums)
                       (push preset-num used-preset-nums)
                       `(:preset-form ,(elt (aref *audio-presets* preset-num) 0))))))))

#|
(annotate-audio-preset-form
 (get-audio-args-print-form (cl-boids-gpu::audio-args (aref *bs-presets* 21))))

|#
;;; (bs-state-save 99)

(defun shallow-copy-obstacle (src-o dest-o)
  "copy the values of model-slots of src into dest."
  (let ((dest-o (if (typep dest-o 'obstacle) dest-o (make-instance 'obstacle))))
    (loop for slot in '(active brightness dtime exists?
                        lookahead moving multiplier pos radius ref target-dpos type)
          do (setf (slot-value dest-o slot)
                   (val (slot-value src-o slot))))
    (setf (slot-value dest-o 'idx) (slot-value src-o 'idx))
    dest-o))

(defun shallow-copy-obstacles (src dest)
  "copy values of obstacles without their refs."
  (let ((dest-array (or (bs-obstacles dest) (make-array 16))))
    (dotimes (idx *max-obstacles*)
      (setf (aref dest-array idx) (shallow-copy-obstacle (aref src idx)  (aref dest-array idx))))
    (setf (bs-obstacles dest) dest-array)))

(defun protect-copy-boid-state (src dest)
  "copy the values of src (and not their refs) into new instance and
return the new instance."
  (loop for slot in '(bs-num-boids bs-positions bs-velocities bs-life bs-retrig bs-pixelsize
          bs-preset speed sepmult cohmult alignmult predmult  len maxlife lifemult
          ;;          bs-obstacles
          ;;          note-states midi-cc-state midi-cc-fns audio-args
          start-time last-update)
        do (setf (slot-value dest slot)
                 (if (typep (slot-value src slot) 'value-cell)
                     (val (slot-value src slot))
                     (slot-value src slot))))
  dest)

;;; (src *curr-boid-state*)

(defun copy-audio-args (src dest)
  (setf (slot-value dest 'cl-boids-gpu::audio-args)
        (annotate-audio-preset-form src)))

(defun bs-state-save (num &key (save-audio t) (save-obstacles t) (save-boids t))
  "save the current state of the boid system to the *bs-presets* array
at num."
  (let ((src *curr-boid-state*)
        (dest (aref *bs-presets* num))
        (saved nil))
    (when save-obstacles
      (shallow-copy-obstacles (bs-obstacles src) dest)
      (push 'obstacles saved))
    (when save-audio
      (copy-audio-args (getf *curr-preset* :audio-args) dest)
      (push 'audio saved))
    (when save-boids
      (protect-copy-boid-state src dest)
      (setf (slot-value dest 'cl-boids-gpu::bs-preset) *curr-preset*)
      (push 'boids saved))
    (format t "~&curr state of ~{~a~^, ~} saved to bs-preset ~a~%" saved num)
    (bs-presets-change-notify)))

(defun store-bs-presets (&optional (file *bs-presets-file*))
  "store the whole *bs-presets* array to disk."
  (cl-store:store *bs-presets* file)
  (if (string/= (namestring file) (namestring *bs-presets-file*))
      (setf *bs-presets-file* file))
  (format nil "~&bs-presets stored to ~a." (namestring file)))

(defun restore-bs-presets (&optional (file *bs-presets-file*))
  "restore the whole *bs-presets* array from disk."
  (setf *bs-presets* (cl-store:restore file))
  (format t "~&bs-presets restored from ~a." (namestring file))
  (if (string/= (namestring file) (namestring *bs-presets-file*))
      (setf *bs-presets-file* file))
  (bs-presets-change-notify)
  *bs-presets-file*)

;;; in bs-state-recall we recall the state of the boid system and
;;; selectively the cc, note and audio state of all players. If the
;;; keyword argument of any of the states is t (the default), the
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

(defun bs-replace-cc-state (num)
  (let ((preset (aref *bs-presets* num)))
    (setf (cl-boids-gpu::midi-cc-state preset) (ucopy *cc-state*))
    nil))

(defun get-keys (proplist)
  (loop for (k v) on proplist by #'cddr collect k))

(defun get-audio-args-print-form (proplist)
  (loop for (k v) on proplist by #'cddr
        append `(,k (:apr ,(getf v :apr)
                     :cc-state ,(getf v :cc-state)))))

(defun bs-preset-empty? (idx &key (load-obstacles t)
                               (load-audio t)
                               (load-boids t))
  (let ((bs-preset (aref *bs-presets* idx)))
;;    (break "preset-empty?: ~a" (load-boids *bp*))
    (not (or (if load-obstacles (bs-obstacles bs-preset))
             (if load-audio (audio-args bs-preset))
             (if load-boids (bs-positions bs-preset))))))

;;; (bs-preset-empty? 95)
#|
(let ((preset (aref *bs-presets* 95))
(if (val (load-obstacles *bp*)))                                      ; ; ;
))

(apr 99)

(let ((bs-preset (aref *bs-presets* 0)))
  (bs-audio-args-recall t (slot-value bs-preset 'cl-boids-gpu::audio-args)))

(let ((bs-preset (aref *bs-presets* 0)))
  (consp (getf (slot-value bs-preset 'cl-boids-gpu::audio-args) :default)))


(defun digest-audio-args (defs)
  "digest the audio args (like in a :audio-args property of a preset)"
  (set-default-audio-preset (getf defs :default))
  (loop for (key val) on defs by #'cddr
        do (if (consp (first val))
               (digest-audio-arg key (eval (first val)))
               (digest-audio-arg key (eval val))))
  (update-pv-audio-ref)) ;; update model (currently in :pv).

(defun restore-audio-preset (form num &key edit)
  (digest-audio-preset-form
   form (aref *audio-presets* num))
  (if edit
      (edit-audio-preset-in-emacs num)))

;;; (player-list)

(defun bs-audio-args-recall (players-to-recall audio-args)
  "restore audio-presets into *curr-audio-presets* and recall
them. players-to-recall is either t (all players) or a list of
players."
  (let*
      ((player-list (if (consp players-to-recall)
                        players-to-recall
                        (get-keys audio-args)))
       (preset-nums-done '()))
;;;    (break "player-list: ~a" player-list)
    (dolist (player player-list)
      (let ((player-audio-arg (getf audio-args player)))
        (if player-audio-arg
            (progn
              (unless (consp (first player-audio-arg)) ;;; audio-preset form attached to arg?
                (setf player-audio-arg `(,player-audio-arg nil)))                          
;;;              (format t "~&player-audio-arg: ~S~%" player-audio-arg)
              (destructuring-bind ((apr preset-num) form) player-audio-arg
                (declare (ignore apr))
                (unless (member preset-num preset-nums-done)
                  (if form
                      (progn
                        (replace-audio-preset preset-num form)
                        (push preset-num preset-nums-done))))
                (case player
                  (:default (progn
                              (set-default-audio-preset `(apr ,preset-num))))
                  (otherwise (digest-audio-arg player (elt *audio-presets* preset-num)))))))))
    (let ((print-form (get-audio-args-print-form audio-args)))
      (setf (getf *curr-preset* :audio-args) print-form) ;;; set print form in *curr-preset*
      (gui-set-audio-args (pretty-print-prop-list print-form))  ;;; set print form in :pv1
      (update-pv-audio-ref)
      (edit-audio-preset *curr-audio-preset-no*)
      )))
|#

(defun expand-players-to-recall (players-to-recall)
  (if (eql players-to-recall t)
      '(:auto :player1 :player2 :player3 :player4)
      players-to-recall))

#|

(defun canonize-audio-arg (audio-arg)
  "canonize the audio arg def to ((apr num) form)"
  (if (eql (first audio-arg) 'apr)
      (list audio-arg nil)
      audio-arg))
|#

(defun restore-audio-presets (audio-args)
  "restore all audio presets specified in the audio-args of
a (bs-)preset from their preset-forms to their respective places in
*audio-presets*. Note: This also recompiles the preset forms."
  (loop
    for (player player-args) on audio-args by #'cddr
    do (progn
;;         (break "player-args: ~a" player-args)
         (digest-audio-preset-form
          (getf player-args :preset-form)
          :audio-preset (aref *audio-presets* (getf player-args :apr))))))

(defun digest-preset-audio-args (audio-args players-to-recall)
  "we always process all audio-args. :default has to be provided!"
  (restore-audio-presets audio-args)
  (dolist (player (expand-players-to-recall players-to-recall))
    (set-player-audio-preset
     player
     (player-audio-preset-num player audio-args)
     :cc-state (player-audio-arg-cc-state player audio-args)))
  (let ((print-form (get-audio-args-print-form audio-args)))
    (setf (getf *curr-preset* :audio-args) print-form) ;;; set print form in *curr-preset*
    (gui-set-audio-args (pretty-print-prop-list print-form)) ;;; set print form in :pv1
    (update-pv-audio-ref)
    (edit-audio-preset *curr-audio-preset-no*)))

#|

      (destructuring-bind ((unused apr-num) form)
          (canonize-audio-arg (player-audio-arg-or-default player audio-args))
        (declare (ignore unused))
        (progn
            (let ((player (if (eql player :default) nil player)))
              (digest-audio-preset-form
               form
               :audio-preset (aref *audio-presets* apr-num))
               ;; if player is :default, set it to nil to just digest the audio
              (push apr-num already-processed))
            (unless (eql player :default)
)))
|#

(defparameter *audio-suspend* nil)

;;; (aref *bs-presets* 0)

(defun bs-state-recall (num &key
                              (players-to-recall t)
                              (note-states nil)
                              (load-obstacles)
                              (load-audio)
                              (load-boids)
                              (obstacles-protect nil)
;;                              (cc-fns t)
                              )
  "recall the state of the boid system in the *bs-presets* array at
num. This is a twofold process: 
1. The boid system has to be restored in the gl-context with #'restore-bs-from-preset.

2. The obstacles, gui, audio and cc-settings have to get reset."
  (let ((bs-preset (aref *bs-presets* num))
        (restored nil))
;;;    (format t "~&recall: ~a~%" num)
    (setf *audio-suspend* t)
    (when (and load-boids
               (cl-boids-gpu::bs-positions bs-preset))
        (gl-enqueue
         (lambda () (restore-bs-from-preset num))) ;;; signal the gl-engine to load the preset

;;; handle audio, cc-fns, cc-state and note-states
        (loop
          for (key slot) in '((:num-boids bs-num-boids)
                              ;;                            (:maxspeed maxspeed)
                              ;;                            (:maxforce maxforce)
                              (:speed speed)
                              (:length len)
                              (:sepmult sepmult)
                              (:cohmult cohmult)
                              (:alignmult alignmult)
                              (:predmult predmult)
                              (:maxlife maxlife)
                              (:lifemult lifemult))
          do (bp-set-value key (slot-value bs-preset slot)))
        (push 'boids restored))
    (when load-audio
      (let ((saved-note-states (slot-value bs-preset 'cl-boids-gpu::note-states)))
        (when (and note-states (consp note-states) saved-note-states)
            (loop
              for player in note-states
              do (let ((idx (player-aref player)))
                   (setf (aref *note-states* idx)
                         (aref saved-note-states idx))))
            (if saved-note-states (in-place-array-cp saved-note-states *note-states*))
            (push 'note-states restored)))
      (when (slot-value bs-preset 'cl-boids-gpu::audio-args)
            (digest-preset-audio-args (slot-value bs-preset 'cl-boids-gpu::audio-args)
                                      players-to-recall)
            ;; (let ((saved-cc-state (slot-value bs-preset 'cl-boids-gpu::midi-cc-state)))
            ;;   (if (and cc-state (consp cc-state) saved-cc-state)
            ;;       (loop
            ;;         for player in cc-state
            ;;         do (let ((player-idx (player-aref player)))
            ;;              (cp-player-cc player-idx saved-cc-state *cc-state*)
            ;;              ))
            ;;       (progn
            ;;         (in-place-array-cp saved-cc-state *cc-state*))))
            (push 'audio restored)))
    (when (and load-obstacles
               (bs-obstacles bs-preset))
      (reset-obstacles-from-bs-preset
       (bs-obstacles bs-preset)
       obstacles-protect)
      (push 'obstacles restored))
    (if restored (format t "~&~a loaded from bs-preset ~a~%" (format nil *english-list* restored) num))
      (setf *audio-suspend* nil)))

(defun bs-copy-obstacles (src dest)
  (let ((slot 'bs-obstacles))
    (setf (slot-value dest slot) (ucopy (slot-value src slot)))))

(defun bs-copy-audio (src dest)
  (dolist (slot '(midi-cc-state midi-cc-fns audio-args))
  (setf (slot-value dest slot) (ucopy (slot-value src slot)))))

(defun bs-copy-boids (src dest)
  (dolist (slot '(bs-num-boids bs-positions bs-velocities bs-life
                  bs-retrig bs-pixelsize bs-preset speed len
                  sepmult cohmult alignmult predmult maxlife
                  lifemult start-time last-update note-states))
    (setf (slot-value dest slot) (ucopy (slot-value src slot)))))

(defmacro mk-symbol (str name)
  `(intern (string-upcase (format nil ,str ,name))))

(defun bs-state-copy (src-idx dest-idx &key (cp-obstacles t)
                                         (cp-audio t)
                                         (cp-boids t))
  (let ((src (aref *bs-presets* src-idx))
        (dest (aref *bs-presets* dest-idx))
        (copied nil))
    (when cp-obstacles (bs-copy-obstacles src dest) (push 'obstacles copied))
    (when cp-audio (bs-copy-audio src dest) (push 'audio copied))
    (when cp-boids (bs-copy-boids src dest) (push 'boids copied))
    (if copied (format t "~&copied ~{~a~^, ~} from bs-preset ~d to ~d." copied src-idx dest-idx))
    (bs-presets-change-notify)))




#|
(defun bs-copy-boids (src dest)
  (dolist (slot '(cl-boids-gpu::bs-num-boids
                  cl-boids-gpu::bs-positions
                  cl-boids-gpu::bs-velocities
                  cl-boids-gpu::bs-life
                  cl-boids-gpu::bs-retrig
                  cl-boids-gpu::bs-pixelsize
                  cl-boids-gpu::bs-preset
                  speed len sepmult cohmult alignmult predmult
                  maxlife lifemult cl-boids-gpu::start-time
                  cl-boids-gpu::last-update
                  cl-boids-gpu::note-states))
    (setf (slot-value dest slot) (ucopy (slot-value src slot)))))
|#







(defun renew-bs-preset-audio-args (bs-preset)
  (let ((audio-args (cl-boids-gpu::audio-args bs-preset))
        (used-preset-nums nil))
    (setf (cl-boids-gpu::audio-args bs-preset)
          (loop for (key ((apr num) def)) on audio-args by #'cddr
                append `(,key ((apr ,num) ,(unless (member num used-preset-nums)
                                              (push num used-preset-nums)
                                              (elt (aref *audio-presets* num) 0))))))))

(defun cp-bs-preset-cc-state-chan (preset src dest)
  (dotimes (i 128)
    (setf (aref (cl-boids-gpu::midi-cc-state preset) dest i)
          (aref (cl-boids-gpu::midi-cc-state preset) src i))))


#|
(loop for x in '(0 0 0 0 0 0 0 0 74 19 118 102 86 27 0 127 0 0 0 22 127 0 127 127 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
      for idx from 0
      do (setf (aref (cl-boids-gpu::midi-cc-state (elt *bs-presets* 19))
                               5 idx) x))


(loop for x in '(22 22 3 127 0 0 43 46 63 39 0 46 127 1 0 0 0 0 89 0 0 107 63 127 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 127 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
      for idx from 0
      do (setf (aref (cl-boids-gpu::midi-cc-state (elt *bs-presets* 20))
                               5 idx) x))


(cp-bs-preset-cc-state-chan (elt *bs-presets* 20) 4 5)

(cl-boids-gpu::midi-cc-state (elt *bs-presets* 19))

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
    (0 0 0 0 0 0 0 0 74 19 118 102 86 27 0 127 0 0 0 22 127 0 127 127 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))

#2A((0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 33 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
    
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 75 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))



;;; (map nil #'renew-bs-preset-audio-args *bs-presets*)
;;; (bs-state-recall 85)

;;; (aref)

;;; (store-bs-presets)
|#



#|

(bs-state-recall 10)


(bs-state-save 40)
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
(bs-state-save 16)
(bs-state-save 17)
(bs-state-save 18)
(bs-state-save 19)
(bs-state-save 20)
(bs-state-save 21)
(bs-state-save 22)
(store-bs-presets)
(restore-bs-presets)

;;; recall preset (video only):
;;; (untrace)
(bs-state-recall 0 :cc-state nil)
(bs-state-recall 40)
(bs-state-recall 1 :cc-state nil)
(bs-state-recall 1)
(bs-state-recall 2)
(bs-state-recall 3)
(bs-state-recall 4)
(bs-state-recall 5)
(bs-state-recall 6)
(bs-state-recall 7)
(bs-state-recall 8)
(bs-state-recall 9 :global-flags t)
(bs-state-recall 10)
(bs-state-recall 11)
(bs-state-recall 12 :obstacles-protect '(:player1))
(bs-state-recall 13 :obstacles-protect '(:player2))
(bs-state-recall 13)
(bs-state-recall 14)
(bs-state-recall 15)
(bs-state-recall 16)
(bs-state-recall 17)
(bs-state-recall 18)
(bs-state-recall 19)
(bs-state-recall 20)
(bs-state-recall 21)
(bs-state-recall 22)
*curr-preset*

(bs-state-save 30)
(bs-state-save 31)

(bs-state-recall 30)
(bs-state-recall 55)
(bs-state-recall 56)

(cl-boids-gpu::midi-cc-state (elt *bs-presets* 20))

 ; ;


cl-boids-gpu::*obstacles*
*cc-state*
(aref *obstacles* 0)
(cl-boids-gpu::audio-args (aref *bs-presets* 20))

                                      ;


(setf *midi-debug* nil)                                      ;


(bp-set-value :lifemult 1500)
(setf *bs-presets* (cl-store:restore *bs-presets-file*))

(cl-store:store *bs-presets* "/tmp/test.lisp")

(setf *bs-presets* (cl-store:restore "/tmp/test.lisp"))

(cl-store:restore "/tmp/test.lisp")

(setf *bs-presets* nil)

(clear-cc-fns :nk2)                                      ;

(setf *cc-state* (cl-boids-gpu::midi-cc-state (aref *bs-presets* 20)))

(loop for idx below (length *bs-presets*)
      do   (progn
             (format t "~a, " idx)
             (let ((audio-args (cl-boids-gpu::audio-args (aref *bs-presets* idx))))
               (if audio-args
                   (loop
                     for (key val) on audio-args by #'cddr
                     do (unless (consp (first val))
                          (progn
;;;                            (break "~s" audio-args)
                            (setf (getf audio-args key)
                                  (cons val (list (elt (eval val) 0)))))))))))

(let ((idx 5))
)

(cl-boids-gpu::audio-args (aref *bs-presets* 5))

(cl-boids-gpu::audio-args (aref *bs-presets* 20))



(aref (apr 91) 0)

          (let* ((name :bs1)
                 (controller (find-controller name)))
            (if controller
                (progn
                  (setf (cc-state controller)
                        (sub-array *cc-state* (player-aref name)))
                  (setf (cc-fns controller)
                        (sub-array *cc-fns* (player-aref name)))
;;;                  (update-gui-encoder-callbacks controller)
                  (update-gui-fader controller))))

(setf 
 (cl-boids-gpu::midi-cc-fns (aref *bs-presets* 20))
 (append '(:bs1 #'mc-std) (cddr (cl-boids-gpu::midi-cc-fns (aref *bs-presets* 20)))))


(setf (slot-value (aref *bs-presets* 20) 'cl-boids-gpu::midi-cc-state)
      (alexandria:copy-array *cc-state*))

(recall-audio-preset 91)
(let ((bs-preset (aref *bs-presets* 22)))
  (slot-value bs-preset 'cl-boids-gpu::audio-args))

(restore-audio-preset
 '(:p1 1
   :p2 (- p1 1)
   :p3 0
   :p4 0
   :synth 0
   :pitchfn (n-exp y 0.4 1.2)
   :ampfn (* (sign) (m-exp-zero (nk2-ref 16) 0.01 1) (+ 0.1 (random 0.6)))
   :durfn (n-exp y 0.8 0.16)
   :suswidthfn 0
   :suspanfn 0.3
   :decaystartfn 0.001
   :decayendfn 0.02
   :lfofreqfn (* (expt (round (* 16 y)) (n-lin x 1 (m-lin (mc-ref 9) 1 1.5)))
               (hertz (m-lin (mc-ref 10) 31 55)))
   :xposfn x
   :yposfn y
   :wetfn (m-lin (mc-ref 8) 0 1)
   :filtfreqfn (n-exp y 200 10000))
 92 :edit t)

(apr 92)

(cl-boids-gpu::audio-args (aref *bs-presets* 21))

(loop for idx below 100
      do (if (cl-boids-gpu::audio-args (aref *bs-presets* idx))
             (setf (cl-boids-gpu::audio-args (aref *bs-presets* idx))
                   (fix-audio-preset-form (cl-boids-gpu::audio-args (aref *bs-presets* idx))))))

(fix-audio-preset-form
 (cl-boids-gpu::audio-args (aref *bs-presets* 20)))



(fix-audio-preset-form (cl-boids-gpu::audio-args (aref *bs-presets* 10)))



(defun fix-audio-preset-form (form)
  (let ((used-preset-nums nil))
    (loop for (player audio-arg) on form by #'cddr
          append (list player (if (consp (first audio-arg))
                                  (if (member (cadar audio-arg) used-preset-nums)
                                      (list (first audio-arg) nil)
                                      (progn
                                        (push (cadar audio-arg) used-preset-nums)
                                        audio-arg))
                                  (list audio-arg nil))))))

(loop for bs-preset across *bs-presets*
      for idx from 0
      do (loop for (player val) on (cl-boids-gpu::audio-args bs-preset) by #'cddr
               do (if (consp (first val))
                    (break "idx: ~a, val: ~a" idx val))))


(aref *bs-presets* 20)

(loop for bs-preset across *bs-presets*
      for idx from 0
      do (loop for (player val) on (cl-boids-gpu::midi-cc-fns bs-preset) by #'cddr
               do (if (member val '(:nk2-std :nk2-std2 :nk2-std-noreset :nk2-std-noreset-nolength #'nk2-st #'nk2-std-noreset #'nk2-std-noreset-nolength) :test #'equal)
                    (break "idx: ~a, val: ~s" idx val))))

(loop for bs-preset across *bs-presets*
      for idx from 0
      do (if (cl-boids-gpu::bs-positions bs-preset)
             (if (member (second (cl-boids-gpu::midi-cc-fns bs-preset))
                      '(:nk2-std :nk2-std-noreset :nk2-std2 :nk2-std-noreset-nolength #'nk2-st #'nk2-std-noreset #'nk2-std-noreset-nolength) :test #'equal)
                 (setf (second (cl-boids-gpu::midi-cc-fns bs-preset))
                       #'nk-std))))

|#

