;;; 
;;; midictl.lisp
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

;;; midictl handles the midi infrastructure: It uses the hash table
;;; *midi-controllers* to (un)register controllers by their id and
;;; additionally pushes/removes all controllers to/from (gethash
;;; *midi-controllers* 'input). It also starts the midi-responder
;;; which accepts midi-events and dispatches them (by midi-channel) to
;;; all appropriate controllers. One main purpose of the
;;; infrastructure is to guarantee that there are no problems
;;; detaching/reattaching hardware devices after instantiating the gui
;;; objects (in the future we might even implement reacting to udev
;;; events by instantiating/removing gui-instances on the fly).
;;;
;;; Further below is the definition of functions for player-access,
;;; default chans for the used midi-controllers/players, etc.

(in-package :luftstrom-display)

(defparameter *midi-controllers* (make-hash-table :test #'equal)
  "hash-table which stores all currently active midi controllers by id
  and an entry for all used midi-ins of the active controllers by
  pushing the controller instance to the 'midi-in entry of this
  hash-table. Maintenance of *midi-controllers* is done within the
  midi-controller methods.")

(defclass midi-controller ()
  ((id :initform nil :initarg :id :accessor id)
   (chan :initform 0 :initarg :chan :accessor chan)
   (cc-map :initform (make-array 128 :initial-contents (loop for i below 128 collect i))
           :initarg :cc-map :accessor cc-map)
   (gui :initform nil :initarg :gui :accessor gui)
   (midi-in :initform *midi-in1* :initarg :midi-in :accessor midi-input)
   (midi-output :initform *midi-out1* :initarg :midi-out :accessor midi-output)
   (last-note-on :initform 0 :initarg :last-note-on :accessor last-note-on)
   (cc-state :initform (make-array 128 :initial-element 0) :initarg :cc-state :accessor cc-state)
   (cc-fns :initform (make-array 128 :initial-element #'identity) :initarg :cc-fns :accessor cc-fns)
   (note-fn :initform (lambda (keynum velo) (declare (ignore velo keynum)))
            :initarg :note-fn :accessor note-fn))
    (:documentation "generic class for midi-controllers. An instance
  should get initialized with #'add-midi-controller and get removed
  with #'remove-midi-controller, using its id as argument in order to
  close the gui and remove its handler functions from
  *midi-controllers*."))

(defgeneric (setf midi-input) (new-midi-in instance)
  (:method (new-midi-in (instance midi-controller))
    (if (member instance (gethash (midi-input instance) *midi-controllers*))
        (setf (gethash (midi-input instance) *midi-controllers*)
              (delete instance (gethash (midi-input instance) *midi-controllers*)))
        (warn "couldn't remove midi-controller ~a" instance))
    (setf (slot-value instance 'midi-in) new-midi-in)
    (push instance (gethash new-midi-in *midi-controllers*))))

(defgeneric handle-midi-in (instance opcode d1 d2)
  (:documentation
   "define midi-handlers by simulating the appropriate mouse/keyboard interaction."))

(defmethod handle-midi-in ((instance midi-controller) opcode d1 d2)
  (case opcode
    (:cc (funcall (aref (cc-fns instance) d1) d2))
    (:note-on (funcall (note-fn instance) d1 d2))
    (:note-off (funcall (note-fn instance) d1 0))))

;;; (make-instance 'midi-controller)

(defgeneric init-gui-callbacks (instance &key echo)
  (:documentation "initialize the gui callback functions."))

(defgeneric init-gui-callbacks (instance &key echo)
  (:documentation "initialize the gui callback functions of a
  controller. Called in initialize-instance :after."))

(defmethod init-gui-callbacks ((instance midi-controller) &key (echo t))
  (declare (ignore instance echo)))

(defmethod initialize-instance :after ((instance midi-controller) &rest args)
  (declare (ignorable args))
  (with-slots (id) instance))

;;; central registry for midi controllers:

(defun add-midi-controller (class &rest args)
  "register midi-controller by id and additionally by pushing it onto
the hash-table entry of its midi-input."
  (let ((instance (apply #'make-instance class args)))
    (with-slots (id) instance
      (when (gethash id *midi-controllers*)
          (warn "id ~S already used, redefining" id)
          (remove-midi-controller id))
      (format t "~&adding: ~S~%" id)
      (push instance (gethash (midi-input instance) *midi-controllers*))
      (setf (gethash id *midi-controllers*) instance))))

(defun remove-midi-controller (id)
  (let ((instance (gethash id *midi-controllers*)))
    (format t "~&removing: ~S~%" id)
    (if instance
        (if (member instance (gethash (midi-input instance) *midi-controllers*))
            (progn
              (setf (gethash (midi-input instance) *midi-controllers*)
                    (delete instance (gethash (midi-input instance) *midi-controllers*)))
              (remhash id *midi-controllers*))
            (warn "couldn't remove midi-controller ~a" instance)))))

(defun find-controller (id)
  (gethash id *midi-controllers*))

(defun ensure-controller (id)
  (let ((controller (gethash id *midi-controllers*)))
    (if controller
        controller
        (error "controller ~S not found!" id))))

;;; (ensure-controller :nk2)
;;; (setf *midi-debug* nil)

(defun start-midi-receive (input)
  "general receiver/dispatcher for all midi input of input arg. On any
midi input it scans all elems of *midi-controllers* and calls their
handle-midi-in method in case the event's midi channel matches the
controller's channel."
  (set-receiver!
     (lambda (st d1 d2)
       (if *midi-debug*
           (format t "~&~S ~a ~a ~a~%" (status->opcode st) d1 d2 (status->channel st)))
       (let ((chan (status->channel st)))
         (dolist (controller (gethash input *midi-controllers*))
           (if (= chan (chan controller))
               (handle-midi-in controller (status->opcode st) d1 d2)))))
     input
     :format :raw))
;;;
;;;
;;;; Code für Luftstrom Controllers:
;;;
;;;

;;; *all-players* bezieht sich auf die Audio-Argumente (16 pro Player)

(defparameter *all-players* #(:auto :player1 :player2 :player3 :player4 :default))

(defparameter *controller-chans* '(:player1 0
                                   :player2 1
                                   :player3 2
                                   :player4 3
                                   :bs1 4
                                   :nk2 5
                                   :kbd1 6
                                   :kbd2 7
                                   :kbd3 8
                                   :kbd4 9))

(defparameter *player-lookup* nil)

(defun init-player-lookup ()
  (let ((hash (make-hash-table)))
    (loop for name across *all-players*
          for idx from 0
          do (if (consp name)
                 (mapcar (lambda (name) (setf (gethash name hash) idx)) name)
                 (setf (gethash name hash) idx))
             (setf (gethash idx hash) idx)
          finally (setf *player-lookup* hash))))

(init-player-lookup)

(declaim (inline player-aref))
(defun player-aref (idx-or-key)
  (or (gethash idx-or-key *player-lookup*)
      (error "no player named ~S" idx-or-key)))

;;; (player-aref :player1)
;;; (player-aref :default)

(declaim (inline controller-chan))
(defun controller-chan (idx-or-key)
  (or (getf *controller-chans* idx-or-key)
      (error "no controller named ~S" idx-or-key)))

;;; (controller-chan :default)

(defun player-name (idx)
  (aref *all-players* (player-aref idx)))

;;; (player-name :auto)

;;; Audio Argument Handling:
;;;
;;; *audio-preset-ctl-model* ist ein 5x16 Array von model-slots, das
;;; den State aller Audio Argumente der 5 player enthält.
;;;
;;; Aus Effizienzgründen wird beim Errechnen der Synth Parameter
;;; direkt aus dem Vektor *audio-preset-ctl-vector* gelesen, in dem
;;; die Werte des models in einem einfachen Vektor dupliziert
;;; sind. Das Setzen von Werten sollte *nicht* im Vektor, sondern im
;;; *audio-preset-ctl-model* vorgenommen werden, um die Synchronizität
;;; sämtlicher Werte in allen darauf referenzierenden Controllern zu
;;; gewährleisten.

(defparameter *audio-preset-ctl-vector*
  (let ((num-players 6) (num-args 16))
    (make-array (* num-players num-args)
                :element-type '(integer 0 127)
                :initial-element 0)))


(defparameter *audio-preset-ctl-model*
  (let* ((num-players 6) (num-args 16)
         (array-size (* num-players num-args)))
    (make-array array-size
                :element-type 'model-array
                :initial-contents
                (loop
                  for idx below array-size
                  collect (make-instance 'model-array
                                         :arr *audio-preset-ctl-vector*
                                         :a-ref (list idx))))))

;;; (setf (val (aref *audio-preset-ctl-model* (+ 2 (* 16 (player-aref :default))))) 31)

(defparameter *cc-state*
  (make-array '(6 128)
              :element-type 'integer
              :initial-element 0))

(defparameter *cc-fns*
  (make-array '(6 128)
              :element-type 'function
              :initial-element #'identity))

(defun sub-array (main idx &key (size 128))
  (make-array size :displaced-to main :displaced-index-offset (* idx size)))

(defmacro set-cc ((player idx) &body body)
  `(setf (aref *cc-fns* (player-aref ,player) ,idx)
         (lambda (val) ,@body)))

(defun identity-notefn (keynum velo)
  (list keynum velo))

(defparameter *note-states* ;;; stores last note-on keynum for each player.
  (make-array '(16) :element-type 'integer :initial-element 0))
(defparameter *note-fns*
  (make-array '(16) :element-type 'function :initial-element #'identity-notefn))



(declaim (inline last-keynum))
(defun last-keynum (player)
  (aref *note-states* player))

(defun clear-cc-fns ()
  "set all cc-fns to #'identity."
  (do-array (idx *cc-fns*)
    (setf (row-major-aref *cc-fns* idx) #'identity)))

(defun clear-note-fns ()
  (dotimes (n 16)
    (setf (aref *note-fns* n) #'identity)))

;;; (clear-note-fns)

;;; (clear-cc-fns)

(defparameter *midi-debug* nil)

;;; (setf *midi-debug* t)

(defun handle-ewi-hold-cc (ch d1)
"we simulate a (virtual) cc 99 toggle: In case cc40 and cc50 are
pressed simutaneously (d2=127), cc 99 value is 127, 0 otherwise."
  (if (member d1 '(40 50))
      (let ((d2 (if (and (= (aref *cc-state* ch 40) 127)
                         (= (aref *cc-state* ch 50) 127))
                    127 0)))
        (setf (aref *cc-state* ch 99) d2)
        (funcall (aref *cc-fns* ch 99) d2))))

(defun midi-filter (ch d1)
  (and (= ch 2) (= d1 100)))

;;; (untrace)

#|
(defun midi-filter (ch d1)
  (declare (ignorable ch d1))
  t)
|#
(defun n-ewi-note (ref)
  (/ (- ref 24) 86.0))

(defun seq-ip-pick (x l1 l2 &key (len 8))
  "interpolate between randomly chosen elems of 8-element lists l1 and
l2 according to x (0..1). For x = 0 take random elm of list l1, for
x=1 take random elem of l2, for x=0.5 take the mean between the elems
l1 and l2 at the same (random) idx."
  (let* ((idx (random len))
         (left (elt l1 idx))
         (delta (- (elt l2 idx) left)))
    (+ left (* x delta))))


;;; (setf *midi-debug* t)

(declaim (inline rotary->inc))
(defun rotary->inc (num)
  (if (> num 63)
      (- num 128)
      num))

(declaim (inline clip))
(defun clip (val min max)
  (min (max val min) max))

(defmacro rotary->cc (array ch d1 d2)
  `(setf (aref ,array ,ch ,d1)
         (clip (+ (aref ,array ,ch ,d1)
                  (rotary->inc ,d2))
               0 127)))

;; (set-fader (find-gui :bs1) 0 29)
;;; (setf *midi-debug* nil)
;;; (start-midi-receive)
