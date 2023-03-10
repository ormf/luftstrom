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

(in-package :luftstrom-display)

(setf *print-case* :downcase)

(defparameter *presets*
  (make-array 100 :initial-element nil))

(defparameter *curr-preset*
  (list :boid-params nil
        :audio-args nil
        :midi-cc-fns nil
        :midi-cc-state *cc-state*)) ;;; preset which as displayed in qt window

;;; The synths require key/value pairs for each arg of the synth. The
;;; written representation of an audio preset is a property list
;;; defining a function to be evaluated for each of the args. The
;;; naming scheme is straightforward: :ampfn is the function
;;; definition for the :amp arg, etc... The values in the audio preset
;;; form only contain the body of the functions. All these bodys get
;;; wrapped into a lambda form containing x, y, velo and p1..p4 as
;;; (optional) args.
;;;
;;; All audio presets exist in two forms:
;;;
;;; 1. The aforementioned printed representation containing the synth
;;;    idx, and key/value pairs for p1..p4 and all argument functions
;;;    submitted to the synth.
;;;
;;; 2. #'digest-audio-args transforms this property list into an array
;;;    containing the compiled functions to be called for each of the
;;;    synth arguments (in #'play-sound which is calling the
;;;    synth). In addition the audio-preset property list is stored as
;;;    a string at idx 1 of the array and the cc-state of the
;;;    controller (an array of 16 cc values) ist stored at idx 0.

(defparameter *default-audio-preset* (make-array 27))

;;; collect the argument keywords, their function specifier in the
;;; audio preset and the default value of all used synths into
;;; *synth-defs*. The idx of the synth is used in the :synth property
;;; of the audio-preset and has to match!

(defparameter *synth-defs*
  (loop
    for synth in '(:lfo-click-2d-bpf-4ch-out :lfo-click-2d-bpf-4ch-vow-out)
    for synth-id from 0
    collect (mapcar
             (lambda (x) (list (intern (string-upcase (format nil "~a" (first x))) 'keyword)
                          (intern (string-upcase (format nil "~afn" (first x))) 'keyword)
                          (second x)))
             (getf (gethash synth sc::*synthdef-metadata*) :controls))))

;;; *audio-fn-idx-lookup* is an array of hash tables relating the arg
;;; and argfn keywords to the idxs of the argument functions in the
;;; audio-preset array for each synth.

(defparameter *audio-fn-idx-lookup*
  (make-array (length *synth-defs*)
              :initial-contents
              (loop for synth in *synth-defs*
                    for hash = (make-hash-table)
                    do (loop for global-key in '(:preset-form :cc-state
                                                 :synth :p1 :p2 :p3 :p4)
                             for idx from 0
                             do (setf (gethash global-key hash) idx))
                       (loop for key-def in synth
                             for idx from 7
                             do (progn
                                  (setf (gethash (first key-def) hash) idx)
                                  (setf (gethash (second key-def) hash) idx)))
                    collect hash)))

;;; *synth-defaults* is an array of functions returning the default
;;; values for each argument in each synth at the same idxs as the
;;; corresponding arg-functions in the audio-preset.

(defparameter *synth-defaults*
  (loop for synth-def in *synth-defs*
        for synth-idx from 0
        collect (append
                 '((:preset-form nil)
                   (:cc-vals #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
                 (loop
                   repeat 5
                   collect (lambda (&optional x y v tidx p1 p2 p3 p4)
                             (declare (ignorable x y v tidx p1 p2 p3 p4))
                             0)) ;;; globals
                 (loop for param in synth-def
                       collect (lambda (&optional x y v tidx p1 p2 p3 p4)
                                 (declare (ignorable x y v tidx p1 p2 p3 p4))
                                 (third param)))))
    "collect a list with functions returning the default values for the
synth args. This list is used for initializing the array in
#'new-audio-preset. The first two elems are stubs for the storage of
the audio preset form nd the cc state in the audio-preset.")

(defun new-audio-preset (synth)
  (let ((default (elt *synth-defaults* synth)))
    (make-array (length default) :initial-contents default)))

;;; (new-audio-preset 0)

(defun get-max-size-audio-preset-idx ()
  "return the idx of the elem of *synth-elements* with maximum
length."
    (loop for idx from 0
          for preset in *synth-defaults*
          with max = 0
          with maxidx = 0
          do (let ((size (length preset)))
               (if (> size max) (progn
                                  (setf max size)
                                  (setf maxidx idx))))
          finally (return maxidx)))

;;; (get-max-size-audio-preset-idx)

;;; *audio-presets* contain the fn-defs of the args of the
;;; synths. Note that not all args have to be assigned. In case an arg
;;; is nil, the default value will be used.

;;; All audio-presets

(defparameter *audio-presets*
  (let ((size 128)
        (max-idx (get-max-size-audio-preset-idx)))
    (make-array size :initial-contents (loop for idx below size collect (new-audio-preset max-idx)))))

;;; *curr-audio-presets* are the current presets for each of the players/obstacles.

;;; The current audio preset of each player (max 20 players).

(defparameter *curr-audio-presets*
  (let ((size 20)
        (max-idx (get-max-size-audio-preset-idx)))
    (make-array size :initial-contents (loop for idx below size collect (new-audio-preset max-idx)))))

;; (setf *presets-file* "presets/schwarm-18-11-18.lisp")
;; (setf *audio-presets-file* "presets/schwarm-audio-presets-18-11-18.lisp")
;; (setf *audio-presets-file* "presets/up-to-three-19-07-31.lisp")
;;; (load-presets)
;;; (load-audio-presets)

(defparameter *curr-preset-no* 0)
(defparameter *curr-audio-preset-no* 0)

;;; tmp storage for all bound cc-fns in running preset. Used for
;;; suspending current pending actions when changing a preset before
;;; reassignment.

(defparameter *curr-cc-fns* nil)

(defun gui-set-preset (num)
  (if num
      (progn
        (setf *curr-preset-no* num)
        (qt:emit-signal (find-gui :pv1) "setPresetNum(int)" num)
;;;        (edit-preset-in-emacs num)
        )))

(defun gui-recall-preset (num)
  (if num
      (progn
        (setf *curr-preset-no* num)
        (qt:emit-signal (find-gui :pv1) "setPresetNum(int)" num)
;;;        (edit-preset-in-emacs num)
        (load-current-preset))))

(defun previous-preset ()
  (let ((next-no (max 0 (1- *curr-preset-no*))))
    (if (/= next-no *curr-preset-no*)
        (gui-set-preset next-no))
    *curr-preset-no*))

(defun edit-preset (no)
  (progn
    (setf *curr-preset-no* no)
    (edit-preset-in-emacs *curr-preset-no*))
  *curr-preset-no*)

(defun edit-audio-preset (no)
  (progn
;;;    (break "edit-audio-preset")
    (setf *curr-audio-preset-no* no)
    (edit-audio-preset-in-emacs *curr-audio-preset-no*))
  *curr-audio-preset-no*)

(defun next-preset ()
  (let ((next-no (min 99 (1+ *curr-preset-no*))))
    (if (/= next-no *curr-preset-no*)
        (gui-set-preset next-no))
    *curr-preset-no*))

(defun gui-set-audio-preset (num)
  (if num
      (progn
        (setf *curr-audio-preset-no* num)
        (qt:emit-signal (find-gui :pv1) "setAudioPresetNum(int)" num))))

(defun rot->inc (rot)
  (declare (type (unsigned-byte 128) rot))
  (let* ((bitwidth 7)
         (mask (ash -1 bitwidth)))
    (if (logbitp (1- bitwidth) rot)
        (logior rot mask)
        rot)))

;;; (rot->inc 64)

(defun encoder-set-audio-preset (dval)
  (declare (type (unsigned-byte 128) dval))
  (let* ((bitwidth 7)
         (mask (ash -1 bitwidth))
         (next-no
           (if (logbitp (1- bitwidth) dval) ;;; (< 63 dval 128)
               (max 0 (+ (logior dval mask) *curr-audio-preset-no*))
               (min 127 (+ dval *curr-audio-preset-no*)))))
    (if (/= next-no *curr-audio-preset-no*)
        (gui-set-audio-preset next-no))
    *curr-audio-preset-no*))

(defun previous-audio-preset ()
  (let ((next-no (max 0 (1- *curr-audio-preset-no*))))
    (if (/= next-no *curr-audio-preset-no*)
        (gui-set-audio-preset next-no))
    *curr-audio-preset-no*))

(defun next-audio-preset ()
  (let ((next-no (min 127 (1+ *curr-audio-preset-no*))))
    (if (/= next-no *curr-audio-preset-no*)
        (gui-set-audio-preset next-no))
    *curr-audio-preset-no*))

(defun get-player-cc-state (player-idx)
  "get the current cc-state of player at player-idx by returning the
player's subseq from *audio-preset-ctl-vector*."
  (let* ((start (ash player-idx 4)))
    (subseq *audio-preset-ctl-vector*
            start (+ start 16))))

;;; (param-boxes (gui (find-controller :ff1)))

(defun get-audio-ref (&optional ctl-id)
  "return the idx of the current player selected in the :ff1
controller."
  (let ((controller (or (find-controller ctl-id)
                        (find-controller :ff1))))
    (if controller
        (player-idx controller)
        0)))

#|(dotimes (i 16)
  (aref (param-boxes (gui (find-controller :ff1)))))
|#

(defun set-player-cc-state (player new-cc-state &key protected)
  "load the cc-state into the model-slots of player."
  (if new-cc-state
      (let* ((start (ash player 4)))
        (dotimes (idx 16)
          (unless (member idx protected)
            (set-cell (elt *audio-preset-ctl-model* (+ start idx))
                      (elt new-cc-state idx))))))
  new-cc-state)

;;; (set-player-cc-state 2 #(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2))

(defun audio-preset-form (audio-preset)
  (elt audio-preset 0))

(defun load-audio-preset (&key (no *curr-audio-preset-no*)
                            (player-ref (get-audio-ref)))
  "load audio-preset referenced by no to the audio-preset of the
player-ref. Update its cc-state in the current player's array range of
*audio-preset-ctl-model*. This is invoked by a set-cell-hook in the
apr-slots of *bp*."
  (let* ((curr-audio-preset (elt *audio-presets* no))
         (preset-form (audio-preset-form curr-audio-preset))
         (audio-preset-cc-state (getf preset-form :cc-state))
         (audio-args (getf *curr-preset* :audio-args))
         (audio-ref player-ref))
    (setf (elt *curr-audio-presets* audio-ref)
          curr-audio-preset)
    (when audio-preset-cc-state
      (set-player-cc-state player-ref audio-preset-cc-state))
    (setf (getf audio-args (player-name audio-ref))
          `(:apr ,no :cc-state ,audio-preset-cc-state))
    (setf audio-args (reorder-a-args audio-args))
    (setf (getf *curr-preset* :audio-args) audio-args)
    (gui-set-audio-args (pretty-print-prop-list audio-args))
    ;; (when (= player-ref (get-audio-ref))
    ;;     (setf *curr-audio-preset-no* no)
    ;;     (edit-audio-preset-in-emacs no)
    ;;     )
    ))

(defun set-current-audio-preset ()
  "set audio-preset model slot in :pv1 to no. This also triggers the
set-cell-hook loading the audio preset."
  (set-model-apr (get-audio-ref) *curr-audio-preset-no*))

;;; (load-audio-preset :no 14)

(defun apr-model (player-ref)
  (slot-value cl-boids-gpu::*bp*
              (aref #(cl-boids-gpu::auto-apr
                      cl-boids-gpu::pl1-apr
                      cl-boids-gpu::pl2-apr
                      cl-boids-gpu::pl3-apr
                      cl-boids-gpu::pl4-apr
                      cl-boids-gpu::default-apr)
                    (player-aref player-ref))))

(defun set-model-apr (player no)
  (set-cell (apr-model player) no))

(defun set-player-audio-preset (player preset-no &key cc-state protected)
  (let ((audio-preset (aref *audio-presets* preset-no))
        (player-idx (player-aref player)))
    (setf (aref *curr-audio-presets* player-idx) audio-preset)
    (set-model-apr player-idx preset-no)
;;    (format t "~&~a~%" (aref audio-preset 1))
    (set-player-cc-state player-idx (or cc-state (aref audio-preset 1))
                         :protected protected)
    (if cc-state
        `(:apr ,preset-no :cc-state ,cc-state)
        `(:apr ,preset-no))))

(defun load-player-audio-preset (player-idx &key cc-state)
  "load audio-preset referenced by *curr-audio-preset-no* to the
audio-preset of the current player. Update its cc-state in the
current player's array range of *audio-preset-ctl-model*."
  (let* ((curr-audio-preset (elt *audio-presets* *curr-audio-preset-no*))
         (preset-form (audio-preset-form curr-audio-preset))
         (audio-preset-cc-state (getf preset-form :cc-state))
         (audio-args (getf *curr-preset* :audio-args)))
    (setf (elt *curr-audio-presets* player-idx)
          curr-audio-preset)
    (if (< player-idx 5)
        (setf (val (slot-value *bp* (if (zerop player-idx) 'cl-boids-gpu::auto-apr
                                        (intern
                                         (format nil "PL~d-APR" player-idx)
                                         'cl-boids-gpu))))
              *curr-audio-preset-no*))
    (when audio-preset-cc-state
      (set-player-cc-state player-idx (or cc-state audio-preset-cc-state)))
    (setf (getf audio-args (player-name player-idx))
          `(:apr ,*curr-audio-preset-no* :cc-state ,audio-preset-cc-state))
    (setf audio-args (reorder-a-args audio-args))
    (setf (getf *curr-preset* :audio-args) audio-args)
    (gui-set-audio-args (pretty-print-prop-list audio-args))))

(defun reorder-a-args (audio-args)
  "sort audio-args in gui view."
  (loop
    for player in '(:default :auto :player1 :player2 :player3 :player4)
    for audio-arg = (getf audio-args player)
    if audio-arg append (list player audio-arg)))

#|
(defun audio-preset-num (player-ref)
  (val (apr-model player-ref)))
|#

(defun delete-player-audio-preset (player-idx)
  "delete audio-preset of the player at player-idx and replace
player's audio-preset by the :default audio-preset."
  (let* ((audio-args (getf *curr-preset* :audio-args))
         (player-name (player-name player-idx)))
    (unless (eql player-name :default)
      (remf audio-args player-name)
      (setf audio-args (reorder-a-args audio-args))
      (setf (getf *curr-preset* :audio-args) audio-args)
      (set-player-audio-preset player-name
                               (r-getf audio-args :default :apr)
                               :cc-state (get-player-cc-state (player-aref :default)))
      (gui-set-audio-args (pretty-print-prop-list audio-args))

      )))

(defun save-player-audio-preset (player-idx)
  "copy the audio-preset of the player at player-idx plus its cc-state
to the location displayed in the audio-tmp.lisp buffer and update the
:pv1 and audio-tmp.lisp guis accordingly."
  (let* ((from (audio-preset-num player-idx))
         (to *curr-audio-preset-no*)
         (cc-state (get-player-cc-state player-idx))
         (preset-form (copy-list (audio-preset-form (aref *audio-presets* from)))))
    (setf (getf preset-form :cc-state) cc-state)
    (digest-audio-preset-form
     preset-form :audio-preset (elt *audio-presets* to))
    (load-player-audio-preset player-idx)
    (edit-audio-preset-in-emacs to)))

;;; (save-current-audio-preset)
;;; (audio-preset-form 94)
;;; (save-current-audio-preset)
;;; (get-player-cc-state)

#|
(defun set-fixed-cc-fns (mc-ref)
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
  (setf (aref *cc-fns* (player-aref mc-ref) 16)
        (lambda (d2)
          (if (= d2 127)
              (previous-preset))))

  (setf (aref *cc-fns* (player-aref mc-ref) 17)
        (lambda (d2)
          (if (= d2 127)
              (next-preset))))

  (setf (aref *cc-fns* (player-aref mc-ref) 18)
        (lambda (d2)
          (if (= d2 127)
              (edit-preset-in-emacs *curr-preset-no*))))

  (setf (aref *cc-fns* (player-aref mc-ref) 19)
        (lambda (d2)
          (if (= d2 127)
              (load-current-audio-preset))))

  (setf (aref *cc-fns* (player-aref mc-ref) 20)
        (lambda (d2)
          (if (= d2 127)
              (previous-audio-preset))))
  
;;;  (edit-audio-preset-in-emacs *curr-audio-preset-no*)
  (setf (aref *cc-fns* (player-aref mc-ref) 21)
        (lambda (d2)
          (if (= d2 127)
              (next-audio-preset))))

  (setf (aref *cc-fns* (player-aref mc-ref) 22)
        (lambda (d2)
          (declare (ignore d2))
          (load-current-preset)))

  (setf (aref *cc-fns* (player-aref mc-ref) 23)
        (lambda (d2)
          (declare (ignore d2))
          (incudine:flush-pending)))

   (setf (aref *cc-fns* (player-aref mc-ref) 24)
        (lambda (d2)
          (declare (ignore d2))
          (cl-boids-gpu::reshuffle-life cl-boids-gpu::*win* :regular nil)))
  nil)
|#


(defun toggle-obstacle-state (player)
  (declare (ignore player)))

;;; (set-fixed-cc-fns (controler-chan :nk2)

;;; (previous-preset)
;;; (next-preset)
;;; (previous-audio-preset)
;;; (next-audio-preset)


(defun preset->string (preset)
  (format nil "(progn
  (setf *curr-preset*
          `(:boid-params
            (~s ~s~&~{~{~s ~s~}~^~%~})
            :audio-args
            (~s ~s~&~{~{~s ~s~}~^~%~})
            :midi-cc-fns
            (~{~{~s ~s~}~^~&~})
            :midi-note-fns
            (~{~{~s ~s~}~^~&~})
            :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))"
          (car (getf preset :boid-params))
          (cadr (getf preset :boid-params))
          (loop for (key val) on (cddr (getf preset :boid-params)) by #'cddr collect (list key val))
          (car (getf preset :audio-args))
          (cadr (getf preset :audio-args))
          (loop for (key val) on (cddr (getf preset :audio-args)) by #'cddr collect (list key val))
          (loop for (key val) on (getf preset :midi-cc-fns) by #'cddr collect (list key val))
          (loop for (key val) on (getf preset :midi-note-fns) by #'cddr collect (list key val))))

;;; (preset->string *curr-preset*)

(defun pretty-print-prop-list (prop-list)
  (format nil "~&~{~{~S ~s~}~^~%~}"
          (loop for (key val) on prop-list by #'cddr collect (list key val))))

(defun preset-audio-args (preset)
  (pretty-print-prop-list (getf preset :audio-args)))

;;; (preset-audio-args *curr-preset*)

(defun preset-midi-cc-fns (preset)
  (pretty-print-prop-list (getf preset :midi-cc-fns)))

;;; (preset-midi-cc-fns *curr-preset*)

(defun preset-midi-note-fns (preset)
  (pretty-print-prop-list (getf preset :midi-note-fns)))

;;; (preset-midi-note-fns *curr-preset*)

#|
(bp-set-value :boids-per-click 1)
(bp-set-value :length 20)
|#

(defun bp-set-value (param val)
  (let ((entry (gethash param *param-gui-pos*)))
    (if entry
        (progn
          (qt:emit-signal (getf entry :gui)
                          "setText(QString)" (format nil (getf entry :formatter) val))
          (set-param-from-key param val)
          (setf (getf (getf *curr-preset* :boid-params) param) val))
        (warn "param ~a doesn't exist in gui." param))))

;; (bp-set-value :speed 1.7)

;; (bp-set-value :curr-kernel "boids")

(defparameter *emcs-conn* swank::*emacs-connection*)

;;; (clear-obstacles (cl-boids-gpu::systems cl-boids-gpu::*win*))

(defun incudine.scratch::move-test (time num)
  (if (> num 0)
      (let ((next (+ time 10000.3)))
        (format t "~&next: ~a" num)
        (incudine:at next
          #'incudine.scratch::move-test next (decf num)))))

;;; (incudine.scratch::move-test (now) 4)


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
#|
(defun digest-boid-param (key val state)
  (case key
    (:num-boids (progn
                  (bp-set-value key *num-boids*)
                  (fudi-send-num-boids *num-boids*)))
    (:obstacles (reset-obstacles-from-preset val state))
    (t (bp-set-value key val))))
|#

(defun digest-boid-param-noreset (key val state)
  (case key
    (:num-boids (let ((num-boids (val (cl-boids-gpu::num-boids cl-boids-gpu::*bp*))))
                  (bp-set-value :num-boids num-boids)
                  (fudi-send-num-boids num-boids)))
    (:obstacles (reset-obstacles-from-preset val state))
    (t nil)))

;;; (reset-obstacles-from-preset '((4 25)) (get-system-state))

(defun get-system-state ()
  (list :num-boids (val (cl-boids-gpu::num-boids cl-boids-gpu::*bp*))
        :obstacles-state (cl-boids-gpu::get-obstacles-state cl-boids-gpu::*win*)
        :midi-cc-fns (copy-list (getf *curr-preset* :midi-cc-fns))))

;;; (getf (get-system-state) :obstacles-state)


; (getf (get-system-state) :obstacles)

(defun restore-controllers (names)
  (dolist (name names)
    (let ((controller (ensure-controller name)))
      (if controller
          (restore-controller-state
           controller
           (sub-array *cc-state* (controller-chan name))
           (sub-array *cc-fns* (controller-chan name)))))))

#|
(defun replace-audio-preset (num form)
  (digest-audio-preset-form form :audio-preset (aref *audio-presets* num)))
|#

(defun load-preset (ref &key (presets *presets*))
  (let ((preset (if (numberp ref) (aref presets ref) ref)))
    (if preset
        (let ((state (get-system-state))
              (pr-midi-cc-fns (getf preset :midi-cc-fns))
              (pr-midi-cc-state (getf preset :midi-cc-state))
              (pr-audio-args (getf preset :audio-args))
              (pr-midi-note-fns (getf preset :midi-note-fns)))
          (deactivate-cc-fns)
          (loop for (key val) on (getf preset :boid-params) by #'cddr
             do (digest-boid-param-noreset key val state))
;;          (gui-set-audio-args (preset-audio-args preset))
          (gui-set-midi-cc-fns (preset-midi-cc-fns preset))
          (gui-set-midi-note-fns (preset-midi-note-fns preset))
          (clear-cc-fns)
          (digest-midi-cc-fns pr-midi-cc-fns pr-midi-cc-state)
          (digest-midi-note-fns pr-midi-note-fns)
          (digest-preset-audio-args pr-audio-args t)
;;          (digest-audio-args pr-audio-args)
          (setf (getf *curr-preset* :midi-cc-fns) pr-midi-cc-fns)
          (setf *cc-state* pr-midi-cc-state)
          (restore-controllers '(:nk2 :ff1))
          (setf (getf *curr-preset* :audio-args) pr-audio-args)
          (setf *curr-preset* preset)
          (if (numberp ref)
              (progn
                (setf *curr-preset-no* ref)
                (fudi-send-pgm-no ref)))))))

#|
(defun gui-set-audio-preset (num)
  (setf *curr-audio-preset-no* num)
  (qt:emit-signal (find-gui :pv1) "setAudioPresetNum(int)" num))
(player-cc -1 7)
(untrace)
(setf *cc-state* (getf (aref *presets* 2) :midi-cc-state))

(aref *cc-state* 4 0)

(player-ref)                                      ;
|#

(defparameter *mc-ref* 4)

(defmacro nk2-ref (ref)
  `(aref *cc-state* (controller-chan :nk2) (1- ,ref)))

(defparameter tidx 0)
(defmacro mc-ref (ref &optional (tidx 0))
  `(aref *audio-preset-ctl-vector* (+ (* tidx 16) (1- ,ref))))

(defmacro mcn-ref (ref &optional (tidx 0))
  `(/ (aref *audio-preset-ctl-vector* (+ (* tidx 16) (1- ,ref)))
      127.0))

(defmacro ewi-luft ()
  `(/ (aref *audio-preset-ctl-vector* (+ (* tidx 16) 0)) 127.0))

(defmacro t-bright ()
  `(if (> tidx 0)
       (val (slot-value (aref *obstacles* (1- tidx)) 'brightness))
       1.0))



(aref *obstacles* 0)



(defmacro ewi-biss ()
  `(/ (aref *audio-preset-ctl-vector* (+ (* tidx 16) 1)) 127.0))

(defmacro ewi-gl-up ()
  `(/ (aref *audio-preset-ctl-vector* (+ (* tidx 16) 2)) 127.0))

(defmacro ewi-gl-down ()
  `(/ (aref *audio-preset-ctl-vector* (+ (* tidx 16) 3)) 127.0))

(defmacro ewi-glide ()
  `(/ (aref *audio-preset-ctl-vector* (+ (* tidx 16) 4)) 127.0))

(defmacro ewi-note ()
  `(/ (- (aref *audio-preset-ctl-vector* (+ (* tidx 16) 5)) 25) 87.0))

(defmacro ewi-key ()
  `(min 1.0 (max 0.0 (/ (mod (- (aref *audio-preset-ctl-vector* (+ (* tidx 16) 5)) 27) 12) 12.0))))

(defmacro ewi-oct ()
  `(min 1.0 (max 0.0 (/ (- (aref *audio-preset-ctl-vector* (+ (* tidx 16) 5)) 40) 72.0))))

(defmacro l6-vol ()
  `(/ (aref *audio-preset-ctl-vector* (+ (* tidx 16) 6)) 127.0))



(defun algn ()
  "current alignmult (normalized)"
  (/ (- (val (cl-boids-gpu::alignmult cl-boids-gpu::*bp*)) 1) 7.0))

(defun coh ()
  "current cohmult (normalized)"
  (/ (- (val (cl-boids-gpu::cohmult cl-boids-gpu::*bp*)) 1) 7.0))

(defun sep ()
  "current sepmult (normalized)"
  (/ (- (val (cl-boids-gpu::sepmult cl-boids-gpu::*bp*)) 1) 7.0))

(defun spd ()
  "current speed (normalized)"
  (log (* (val (cl-boids-gpu::bp-speed cl-boids-gpu::*bp*)) 10) 200))

(defun lfm ()
  "current lifemult (normalized)"
  (/ (val (cl-boids-gpu::lifemult cl-boids-gpu::*bp*)) 500.0))

(defun bpc ()
  "current boids per click"
  (float (val (cl-boids-gpu::boids-per-click cl-boids-gpu::*bp*))))

(defun lgth ()
  "current length (normalized)"
  (/ (- (val (cl-boids-gpu::len cl-boids-gpu::*bp*)) 5) 245))

(alexandria:define-constant +cos-lookup+
  (let ((tmp
          (coerce (loop for x below 257 collect
                                        (float (cos (* x 1/256 pi 1/2)) 1.0))
                  'vector)))
    (setf (aref tmp 256) 0.0)
    tmp) :test #'equalp)

(defmacro with-pan ((l r) x &rest body)
  `(let ((,l (aref +cos-lookup+ (round (* 256 ,x))))
         (,r (aref +cos-lookup+ (round (* 256 (- 1 ,x))))))
     ,@body))

#|
(with-pan (l r) 0.6
  (list l r))
|#
(defun v2c (fv)
  (* 12 (log fv 2)))

(defun c2v (ct)
  (expt 2 (/ ct 12)))

(defmacro mc-lin (ref min max)
  `(m-lin (aref *audio-preset-ctl-vector* (+ (* tidx 16) (1- ,ref))) ,min ,max))

(defmacro mc-exp (ref min max)
  `(m-exp (aref *audio-preset-ctl-vector* (+ (* tidx 16) (1- ,ref))) ,min ,max))

(defmacro mc-exp-zero (ref min max)
  `(m-exp-zero (aref *audio-preset-ctl-vector* (+ (* tidx 16) (1- ,ref))) ,min ,max))

(defmacro mc-exp-dev (ref max)
  "return a random deviation factor, the deviation being exponentially
interpolated between 1 for midi-ref-x=0 and [1/max..max] for midi-ref-x=127."
  `(n-exp-dev (mcn-ref ,ref) ,max))

(defmacro mc-lin-pm (ref max)
  "return a deviation, the deviation being linearly
interpolated between 0 for midi-ref-x=0 and [-max..max] for midi-ref-x=127."
  `(n-lin (mcn-ref ,ref) ,(* -1 max) ,max))

(defmacro mc-exp-pm (ref max)
  "return a deviation factor, the deviation being exponentially
interpolated between 1 for midi-ref-x=0 and [-max..max] for midi-ref-x=127."
  `(n-exp (mcn-ref ,ref) ,(/ max) ,max))

(defmacro n-lin-pm (x max)
  "return a deviation, the deviation being linearly
interpolated between 0 for x=0 and [-max..max] for x=1."
  `(n-lin ,x (* -1 ,max) ,max))

(defmacro n-exp-pm (x max)
  "return a deviation, the deviation being linearly
interpolated between 1 for x=0 and [1/max..max] for x=1."
  `(n-exp ,x (/ ,max) ,max))

(defmacro mc-lin-dev (ref max)
  "return a random deviation factor, the deviation being linearly
interpolated between 0 for midi-ref-x=0 and [-max..max] for midi-ref-x=127."
  `(n-lin-dev (mcn-ref ,ref) ,max))

(defun mtof (m)
  (* 440 (expt 2 (/ (- m 69) 12))))

(defun ftom (f)
  (+ 69 (* 12 (log (/ f 440) 2))))

(defun audio-preset-num (&optional player-ref)
  "parse the preset num of player referenced by player-ref from the
current preset's :audio-args property."
  (second
   (player-audio-arg-or-default
    (player-name (or player-ref (get-audio-ref)))
    (getf *curr-preset* :audio-args))))

(defun update-pv-audio-ref ()
  "update the preset num of current player in :audio-args of :pv1 view."
  (gui-set-audio-preset (audio-preset-num (get-audio-ref))))

(defun set-audio-ref (idx)
  "set the current audio ref in :ff1 to idx and propagate to
  \"Audio-Preset\" param-view-box in :pv1"
  (setf (player-idx (find-controller :ff1)) idx)
  (update-pv-audio-ref))

(defun edit-preset-in-emacs (ref &key (presets *presets*))
  (let ((swank::*emacs-connection* *emcs-conn*))
    (if (numberp ref)
        (swank::eval-in-emacs
         `(edit-flock-preset
           ,(progn
              (in-package :luftstrom-display)
              (defparameter swank::*send-counter* 0)
              (preset->string (aref presets ref))) ,(format nil "~a" ref)) t)
        (swank::eval-in-emacs
         `(edit-flock-preset ,(preset->string ref)
                             ,(format nil "~a" *curr-preset-no*)) t))))

(defun show-audio-preset (preset-def)
  (view-audio-preset-in-emacs (second (read-from-string preset-def)))
  "nil")

;;; (show-audio-preset '(apr 94))

(defun load-current-preset ()
  (load-preset *curr-preset-no*))

;;; (edit-audio-preset-in-emacs 2)

(defun edit-audio-preset-in-emacs (ref)
  (let ((swank::*emacs-connection* *emcs-conn*))
    (if (numberp ref)
        (swank::eval-in-emacs
         `(edit-flock-audio-preset
           ,(progn
              (in-package :luftstrom-display)
              (defparameter swank::*send-counter* 0)
              (get-audio-preset-load-form ref))
           ,(format nil "~a" ref))
                              t))))

(defun view-audio-preset-in-emacs (ref)
  (let ((swank::*emacs-connection* *emcs-conn*))
    (if (numberp ref)
        (swank::eval-in-emacs
         `(view-flock-audio-preset
           ,(progn
              (in-package :luftstrom-display)
              (get-audio-preset-load-form ref))
           ,(format nil "~a" ref))
         t))))

(defun init-emacs-display-fns ()
  (let ((swank::*emacs-connection* *emcs-conn*))
    (swank::eval-in-emacs
     `(load "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/elisp/edit-flock-presets.el") t)))

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
    (setf (getf state :boid-params)
          (loop for (key val) on (getf *curr-preset* :boid-params) by #'cddr
             append (capture-param key val)))
    (setf (getf state :midi-cc-state) (alexandria:copy-array *cc-state*))
    (setf (aref presets num) state))
  (values))

;;; (state-store-curr-preset 1)

;;; (load-preset 5)
;;; (load-preset (aref *presets* 1))


;;; (aref *presets* 1)



(defun save-presets (&key (file *presets-file*))
  (with-open-file (out file :direction :output :if-exists :supersede)
    (format out "(in-package :luftstrom-display)~%~%(setf *presets*~&~s)" *presets*))
  (format t "presets written to ~a" file)
  (format nil "presets written to ~a" file))

;;; (save-presets :file "presets/schwarm-18-10-03-02.lisp")

(defun load-presets (&key (file *presets-file*))
  (load file))

;;; (load-presets)
;; (load-preset (aref *presets* 0))

(defparameter *obst-move-time* 0.4)

#|
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
|#

(dotimes (player 4) (setf (aref *note-fns* player) #'identity))


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
                  :offset (* cl-boids-gpu::+float4-octets+ (obstacle-ref (aref *obstacles* player-ref)))
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
        (setf (aref luftstrom-display::*note-states* player-ref)
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
                    (or (if ref (aref luftstrom-display::*note-states* player ref))
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



;;; (setf (mvobst-xtarget (aref *move-obst* 0)) 3.1)

;;; (setf (mvobst-xtarget (aref *move-obst* 0)) (+ x dv))
;;; (unless (mvobst-active (aref *move-obst* 0))



#|
(defparameter *my-mv-fn*
    (make-move-fn 0 :up 100 nil))

(funcall *my-mv-fn* 0)

bewegt sich immer so schnell, wie m??glich zum Zielwert

bei Funktionsaufruf der Bewegungsfunktion:



(defun make-move-fn3 (player &key (dir :up) (max 100) (ref nil) (clip nil))
  "assign a function which can be bound to be called each time, a new
event (like a cc value) is received."
  (let ((window cl-boids-gpu::*win*)
        (clip clip)
        (obstacle (obstacle player)))
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
                 (let ((obstacle obstacle))
                   (with-slots (target-dx target-dy) obstacle
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
                           (setf (obstacle-moving obstacle) nil)))))))
    ;;; lambda-function entry point
        (if (> d2 0)
            (let ((obstacle obstacle))
              (format t "~&received: ~a" d2)
              (case dir
                (:left (setf (obstacle-target-dx obstacle)
                             (float (* -1 (if ref (m-exp (aref *cc-state* player ref) 10 max) 10.0)))))
                (:right (setf (obstacle-target-dx obstacle)
                              (float (if ref (m-exp (aref *cc-state* player ref) 10 max) 10.0))))
                (:down (setf (obstacle-target-dy obstacle)
                             (float (* -1 (if ref (m-exp (aref *cc-state* player ref) 10 max) 10.0)))))
                (:up (setf (obstacle-target-dy obstacle)
                           (float (if ref (m-exp (aref *cc-state* player ref) 10 max) 10.0)))))
              (unless (obstacle-moving obstacle)
                (setf (obstacle-moving obstacle) t)
                (inner (now)))))))))
|#


#|

(defun make-retrig-move-fn (player &key (dir :up) (num-steps 10) (max 100) (ref nil) (clip nil))
  "return a function moving the obstacle of a player in a direction
specified by :dir which can be bound to be called each time, a new
event (like a cc value) is received. If ref is specified it points to
a cc value stored in *cc-state* which is used for exponential interpolation
of the boid's stepsize between 10 and :max pixels."
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
                                   (float (* -1 (if ref (ou:m-exp-zero (aref *cc-state* player ref) 10 max) 10.0)))
                                   num-steps clip))
                           (:right (set-obstacle-dx
                                    obstacle-ref
                                    (float (if ref (ou:m-exp-zero (aref *cc-state* player ref) 10 max) 10.0))
                                    num-steps clip))
                           (:down (set-obstacle-dy
                                   obstacle-ref
                                   (float (* -1 (if ref (ou:m-exp-zero (aref *cc-state* player ref) 10 max) 10.0)))
                                   num-steps clip))
                           (:up (set-obstacle-dy
                                 obstacle-ref
                                 (float (if ref (ou:m-exp-zero (aref *cc-state* player ref) 10 max) 10.0))
                                 num-steps clip))))
                       ;;                       (format t "~&retrig, act: ~a" (obstacle-moving obstacle))
                       (at next #'retrig next)))))
;;; lambda-function entry point
        ;;        (format t "~&me-received: ~a" d2)
        (if (obstacle-active obstacle)
            (if (> d2 0)
                (unless retrig?
                  (setf retrig? t)
                  (retrig (now)))
                (setf retrig? nil)))))))
|#



(obstacle-active (obstacle 0))

;;; (defparameter *mv-test* (make-retrig-move-fn 0 :dir :up))

;;; (funcall *mv-test* 'stop)

;;; (funcall *mv-test* 10)
;;; (move-obstacle-rel-xy player dx dy window :clip clip)
;;; (setf (obstacle-moving (obstacle 0)) nil)

;; (setf (obstacle-moving (obstacle 0)) nil)

(defun std-obst-move (player max ref)
  `(((,player ,ref)
     (with-exp-midi-fn (1.0 100.0)
       (bp-set-value :predmult (float (funcall ipfn d2)))))
    ((,player 40) (make-retrig-move-fn ,player :dir :right :max ,max :ref ,ref :clip nil))
    ((,player 50) (make-retrig-move-fn ,player :dir :left :max ,max :ref ,ref :clip nil))
    ((,player 60) (make-retrig-move-fn ,player :dir :up :max ,max :ref ,ref :clip nil))
    ((,player 70) (make-retrig-move-fn ,player :dir :down :max ,max :ref ,ref :clip nil))))

(declaim (inline register-cc-fn))
(defun register-cc-fn (fn)
  (push fn *curr-cc-fns*))

(declaim (inline deactivate-cc-fns))
(defun deactivate-cc-fns ()
  (dolist (fn *curr-cc-fns*)
    (funcall fn 'stop))
  (setf *curr-cc-fns* nil))

(defun get-fn-idx (key synth)
  (let ((idx (gethash key (aref *audio-fn-idx-lookup* synth))))
    (if idx idx (warn "no index for key ~a in synth ~a" key synth))))

(defun cp-default-preset-args (preset synth)
  "copy default values for all preset args of synth into preset."
  (loop
    for idx from 0
    for default-val in (elt *synth-defaults* synth)
    do (progn
;;;         (break "idx: ~a, default: ~a" idx default-val)
         (setf (aref preset idx) default-val))))

;;; (elt (elt *curr-audio-presets* 0) 1)

(defun digest-audio-preset-form (preset-form &key audio-preset) ;; (player (get-audio-ref))
  "replace the elems (param-fns) of the given audio-preset array by
processing the defs in preset-form. If no audio preset is provided, create a
new array and return it."
;;  (break "digest-preset-form")
  (if preset-form
      (let* ((synth (getf preset-form :synth))
;;             (player-idx (if player (player-aref player)))
             (preset (or audio-preset (new-audio-preset synth))))
        (if synth
            (progn
              (cp-default-preset-args preset synth)
              (loop
                for (key val) on preset-form by #'cddr
                for idx = (or (get-fn-idx key synth) (error "arg not present in synth: ~S" key))
                do (case key
                     (:cc-state (setf (aref preset 1) val))
                     (otherwise
                      (setf (aref preset idx)
                            (eval `(lambda (&optional x y v tidx p1 p2 p3 p4)
                                     (declare (ignorable x y v tidx p1 p2 p3 p4))
                                     ,val))))))
              (setf (aref preset 0) preset-form)
;;;              (if player (setf (aref *curr-audio-presets* player-idx) preset))
              preset)
            (error "no synth specified: ~a" preset-form)))))
#|
(setf *default-audio-preset*
  (coerce
   (digest-audio-preset-form
    '(:p1 1
      :p2 (- p1 1)
      :p3 0
      :p4 0
      :synth 0
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
      :filt-freqfn 20000
      :bp-freq 500
      :bp-rq 10))
   'list))

|#

(defmacro apr (ref)
  `(elt ,*audio-presets* ,ref))

#|
(defun preset-fn (key preset)
  (aref preset (get-fn-idx key)))
|#

(defun get-audio-preset-string (audio-preset)
  (with-output-to-string (out)
    (loop for (key value) on (audio-preset-form audio-preset) by #'cddr
          for start = "'(" then #\NEWLINE
          do (format out "~a~s ~a" start key value))
    (format out ")")))

;;; (get-audio-preset-string (elt *audio-presets* 0))

(defun player-audio-arg-or-default (player audio-args)
  "return the player's audio arg or the default audio arg, if player
isn't referenced in audio-args."
  (getf audio-args player (getf audio-args :default)))

(defun player-audio-preset-num (player audio-args)
  "return the player's audio preset num or the default audio preset
num, if player isn't referenced in audio-args."
  (getf (getf audio-args player (getf audio-args :default)) :apr))

(defun player-audio-arg-cc-state (player audio-args)
  "return the player's audio preset num or the default audio preset
num, if player isn't referenced in audio-args."
  (getf (getf audio-args player (getf audio-args :default)) :cc-state #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))

(defun edit-player-audio-preset (idx-or-key)
  (edit-audio-preset-in-emacs
   (player-audio-preset-num
    (player-aref idx-or-key) (getf *curr-preset* :audio-args))))

#|
(setf (getf *curr-preset* :audio-args)
'(:default (:apr 99) :auto (:apr 99) :player1 (:apr 99) :player2 (:apr 37) :player3
 (:apr 37)))

(edit-player-audio-preset 0)

(loop for (key val) on (getf *curr-preset* :audio-args) by #'cddr
      do (format t "~&~S ~S" key val))
|#

(defun get-audio-preset-load-form (preset-no)
  (with-output-to-string (out)
    (format out "(digest-audio-preset-form~%")
    (format out (get-audio-preset-string
                 (aref *audio-presets* preset-no)))
    (format out "~&:audio-preset (aref *audio-presets* ~a))~%" preset-no)))

(defun cp-audio-preset (src target)
  "in-place digestion of preset-form of src to target."
  (digest-audio-preset-form
   (audio-preset-form (aref *audio-presets* src))
   :audio-preset (aref *audio-presets* target)))

(defun save-audio-presets (&key (file *audio-presets-file*))
  (with-open-file (out file :direction :output
                            :if-exists :supersede)
    (format out "(in-package :luftstrom-display)~%~%(progn~%")
    (loop for preset across *audio-presets*
          for idx from 0
          do (progn
;;               (format t "~&idx: ~a" idx)
               (format out (get-audio-preset-load-form idx))))
    (format out ")~%"))
  (format t "audio-presets written to ~a" file)
  (format nil "audio-presets written to ~a" file))

;;; (save-audio-presets)

(defun load-audio-presets (&key (file *audio-presets-file*))
  (load file))

;;; (load-audio-presets)

;;; (read-from-string (get-audio-preset-load-form 0))

(defun save-all-presets ()
  (save-presets)
  (save-audio-presets))

;;; (save-all-presets)
;;; (edit-audio-preset-in-emacs 2)
#|
(eval (second (funcall (gethash :boid-ctl1 *cc-presets*) 3)))
|#

(defun cc-preset (player key)
  (funcall (cond ((functionp key) key)
                   ((consp key) (eval key))
                   (t (gethash key *cc-presets*)))
           (gethash player *player-lookup*)))

;;; (gethash :obst-ctl1 *cc-presets*)

;; (cc-preset :player1 :boid-ctl1-noreset)

;; (cc-preset :player2 :life-ctl2)

;; (cc-preset :player2 #'life-ctl2)

;; (cc-preset 0 :obst-ctl1)

;;; (load-preset 0)

(defun expand-audio-def (def)
  (cond
    ((null def) ())
    ((numberp def) def)
    ((symbolp def) def)
    ((consp (first def))
     (cons (expand-audio-def (first def)) (expand-audio-def (rest def))))
    (t (if (and
            (eql (first def) 'aref)
            (eql (second def) '*cc-state*))
           (eval def)
           (cons (first def) (expand-audio-def (rest def)))))))

(defun extract-preset (ref)
  (loop for (key val) on (elt (elt *audio-presets* ref) 0) by #'cddr
        append (list key (expand-audio-def val))))

(defun ewi-lin (x min max)
  (+ min (* (- max min) (/ (- x 24) 84))))

(defun ewi-nlin (tidx min max)
  (+ min (* (- max min) (/ (- (player-note tidx) 24) 84))))
