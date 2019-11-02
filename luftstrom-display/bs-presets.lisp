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

(defun annotate-audio-preset-form (audio-args)
  "append the audio-arg form to all audio-arg-presets. Skip already
appended preset-nums."
  (let ((used-preset-nums '()))
    (loop for (player (_ preset-num)) on audio-args by #'cddr
          append (prog1
                      (if (member preset-num used-preset-nums)
                          `(,player ((apr ,preset-num) nil))
                          (progn
                            (push preset-num used-preset-nums)
                            `(,player ((apr ,preset-num)
                                           ,(elt (aref *audio-presets* preset-num) 0)))))))))


#|
(annotate-audio-preset-form
q (get-audio-args-print-form (cl-boids-gpu::audio-args (aref *bs-presets* 10))))


|#

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
          (annotate-audio-preset-form (getf *curr-preset* :audio-args)))
    (setf (aref *bs-presets* num) curr-bs-state)))



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
  *bs-presets-file*)

(defun digest-audio-args (defs)
  (set-default-audio-preset (getf defs :default))
  (loop for (key val) on defs by #'cddr
        do (if (consp (first val))
               (digest-audio-arg key (eval (first val)))
               (digest-audio-arg key (eval val)))))

(defun restore-audio-preset (form num &key edit)
  (digest-audio-args-preset
   form (aref *audio-presets* num))
  (if edit
      (edit-audio-preset-in-emacs num)))

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
  (loop for (k (v form)) on proplist by #'cddr
        append `(,k ,v)))

;;; (get-audio-args-print-form (slot-value (aref *bs-presets* 20) 'cl-boids-gpu::audio-args))

(defun bs-preset-empty? (idx)
  (not (cl-boids-gpu::bs-positions (aref *bs-presets* idx))))

;;; (bs-preset-empty? 0)
#|
(aref *bs-presets* 0)

(apr 99)

(let ((bs-preset (aref *bs-presets* 0)))
  (bs-audio-args-recall t (slot-value bs-preset 'cl-boids-gpu::audio-args)))

(let ((bs-preset (aref *bs-presets* 0)))
  (consp (getf (slot-value bs-preset 'cl-boids-gpu::audio-args) :default)))

|#

(defun bs-audio-args-recall (audio audio-args)
  (let*
      ((player-list (if (consp audio) audio (get-keys audio-args)))
       (preset-nums-done '()))
    (dolist (player player-list)
      (let ((player-audio-arg (getf audio-args player)))
        (if player-audio-arg
            (progn
              (unless (consp (first player-audio-arg)) ;;; audio-preset form attached to arg?
                (setf player-audio-arg `(,player-audio-arg nil)))                          
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
      (setf (getf *curr-preset* :audio-args) print-form)
      (gui-set-audio-args (pretty-print-prop-list print-form)))))

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
      (reset-obstacles-from-bs-preset (cl-boids-gpu::bs-obstacles bs-preset) obstacles-protect)
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
      (bs-audio-args-recall audio (slot-value bs-preset 'cl-boids-gpu::audio-args) )
      (if note-states
          (let ((saved-note-states (slot-value bs-preset 'cl-boids-gpu::note-states)))
            (if (consp note-states)
                (loop
                  for player in note-states
                  do (let ((idx (player-aref player)))
                       (setf (aref *note-states* idx)
                             (aref saved-note-states idx))))
                (in-place-array-cp saved-note-states *note-states*))))
      (if cc-state
          (let ((saved-cc-state (slot-value bs-preset 'cl-boids-gpu::midi-cc-state)))
            (if (consp cc-state)
                (loop
                  for player in cc-state
                  do (let ((player-idx (player-aref player)))
                       (cp-player-cc player-idx saved-cc-state *cc-state*)))
                (progn
                  (in-place-array-cp saved-cc-state *cc-state*)
                  (restore-controllers '(:bs1 :nk2))))))
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
                  (clear-cc-fns (player-aref :nk2))
                  (setf (getf *curr-preset* :midi-cc-fns) saved-cc-fns)
                  (digest-midi-cc-fns saved-cc-fns saved-cc-state)
                  (gui-set-midi-cc-fns (pretty-print-prop-list saved-cc-fns)))))))))

(defun bs-state-copy (src dest)
  (setf (aref *bs-presets* dest)
        (ucopy (aref *bs-presets* src))))

(defun renew-bs-preset-audio-args (bs-preset)
  (let ((audio-args (cl-boids-gpu::audio-args bs-preset))
        (used-preset-nums '()))
    (setf (cl-boids-gpu::audio-args bs-preset)
          (loop for (key ((apr num) def)) on audio-args by #'cddr
                append `(,key ((apr ,num) ,(unless (member num used-preset-nums)
                                              (push num used-preset-nums)
                                              (elt (aref *audio-presets* num) 0))))))))

;;; (map nil #'renew-bs-preset-audio-args *bs-presets*)
;;; (bs-state-recall 0)

;;; (aref)

;;; (store-bs-presets)

#|


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
;;; (untrace)                                      ;
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
(bs-state-recall 9)
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
(bs-state-recall 31)


cl-boids-gpu::*obstacles*
*cc-state*
(aref *obstacles* 0)
(cl-boids-gpu::audio-args (aref *bs-presets* 20))

                                      ;


(setf *midi-debug* nil)                                      ;


(set-value :lifemult 1500)
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

