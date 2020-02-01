;;; 
;;; param-view-ctl.lisp
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

(in-package :cl-boids-gpu)

(defclass bp-ctl ()
  ((params :initarg :params :type 'boid-params :initform nil :accessor params)
   (gui :initarg :gui :type 'param-view-grid :initform nil :accessor gui)))


#|(bp-slot
 (model-slot)
 ((pvbox :initarg :pvbox :initform nil :accessor pvbox)))
|#


(in-package :luftstrom-display)

(defparameter *bp-ctl* (make-instance 'cl-boids-gpu::bp-ctl
                                      :params cl-boids-gpu::*bp*
                                      :gui (find-gui :pv1)))

#|
(loop for)
|#

;;;; (find-gui :pv1)

(defun set-param-from-key (key val)
  (let ((sym (intern (string-upcase (symbol-name key))
                     'cl-boids-gpu)))
    (set-cell (slot-value *bp* sym) val)))

;;; (setf (val (cl-boids-gpu::len *bp*)) 3)

;;; (set-param-from-key :length 5)

(defun boolean? (val)
  (or (not val) (eq (type-of val) 'boolean)))

(defun capture-param (key val)
  (if (numberp val)
      (case key
        (:num-boids (list key *num-boids*))
        (otherwise
         (let ((sym (intern (format nil "*~a*" (string-upcase (symbol-name key)))
                            'luftstrom-display)))
           (list key (symbol-value sym)))))
      (list key val)))

(defun digest-arg-fn (key val)
  (setf (symbol-value
         (intern (format nil "*~a*" (string-upcase (symbol-name key)))
                 'luftstrom-display))
        (eval `(lambda (&optional x y v p1 p2 p3 p4) (declare (ignorable x y v p1 p2 p3 p4))
                  ,val))))

(defun digest-arg-fns (fns)
  (loop for (key val) on fns by #'cddr
     do (digest-arg-fn key val)))

#|
(defun digest-audio-args (defs)
  (set-default-audio-preset (getf defs :default))
  (loop for (key val) on defs by #'cddr
        do (digest-audio-arg key (eval val))))

(defun digest-audio-arg (key val)
;;  (format t "~&digest: ~S ~S" key (elt val 0))
  (case key
    (:default (setf (elt *curr-audio-presets* 0) val))
    (:player1 (setf (elt *curr-audio-presets* 1)
                    (or val (elt *curr-audio-presets* 1))))
    (:player2 (setf (elt *curr-audio-presets* 2)
                    (or val (elt *curr-audio-presets* 2))))
    (:player3 (setf (elt *curr-audio-presets* 3)
                    (or val (elt *curr-audio-presets* 3))))
    (:player4 (setf (elt *curr-audio-presets* 4)
                    (or val (elt *curr-audio-presets* 4))))
    (:otherwise (warn "digest-audio-arg: Wrong key ~a in audio-arg" key)))
  nil)
|#

(defun digest-cc-def (cc-ref fn old-state &key (reset t))
  "store a midi cc callback function into *cc-fns* at cc-ref. If reset
is true, call the function with the value at cc-ref."
  (let ((ref (player-aref (first cc-ref))))
    (setf (apply #'aref *cc-fns* ref (rest cc-ref)) fn)
    (if reset
        (funcall fn (apply #'aref old-state ref (rest cc-ref))))
;;;    (register-cc-fn fn) ;;; this was intended to be able to reset hanging obst movement fns.
    ))

(defun digest-midi-note-fns (defs)
  (loop for (key-or-coords value) on defs by #'cddr
        do (progn
             ;;             (format t "~&~a ~a" key-or-coords value)
             (loop
               for (player cc-note-def)
                 on (funcall #'cc-preset key-or-coords value) by #'cddr
               do (if (functionp cc-note-def)
                      (funcall cc-note-def player))))))

(defun digest-midi-cc-fns (defs old-cc-state)
  "function to install (register) midi-cc callback functions into
*cc-fns*. A def is similar to a property list, alternating between
keys and values. The keys are the index pair into *cc-defs*. The value
is either a callback function for the received midi cc event, or a
list with a callback function as first element and a flag, indicating,
whether the callback function should get executed with the value
stored in old-cc-state at the respective index pair."
  (loop for (key-or-coords value) on defs by #'cddr
        do (progn
             ;;             (format t "~&~a ~a" key-or-coords value)
             (cond
               ((consp key-or-coords)
                (digest-cc-def key-or-coords (eval value) old-cc-state))
               (t
                (loop
                  for (key cc-def)
                    on (funcall #'cc-preset key-or-coords value) by #'cddr
                  do (if (functionp cc-def)
                         (let ((fn cc-def) (reset nil))
                           (digest-cc-def key fn old-cc-state :reset reset))
                         (let ((fn (first cc-def)) (reset (second cc-def)))
                           (digest-cc-def key fn old-cc-state :reset reset)))))))))

;; (with-cc-def-bound (fn reset) cc-def (digest-cc-def key fn old-cc-state :reset reset))

(defun set-in-gui? (key)
  "return t if key should be set in gui from preset."
  (not (member key '(:num-boids :obstacles))))

(defun digest-params (preset)
  (clear-cc-fns)
  (loop for (ctl templ) in (getf preset :midi-cc-fns)
     do (setf (apply #'aref *cc-fns* ctl) (eval templ)))
  (loop for (key val) on (getf preset :boid-params) by #'cddr
     do (if (set-in-gui? key)
          (set-param-from-key key val)))
  (digest-arg-fns (getf preset :audio-args))
  (values))

#|
(defun format-boid-params ()
  (loop for param in
       '(*speed* *obstacles-lookahead*
         *speed* *maxidx* *length*
         *sepmult* *alignmult* *cohmult* *predmult* *maxlife*
         *lifemult* *max-events-per-tick*)
     do (format t "~&:~a ~a~%"
                (string-trim "*" (string-downcase (symbol-name param)))
                (symbol-value param))))
|#
;;; position and gui lookup for params

(defparameter *param-gui-pos* (make-hash-table))

;;; abbreviated param names for gui

(defparameter *param-labels*
  '((:boids-per-click . :b-p-c)
    (:clockinterv . :clck-iv)
    (:obstacles-lookahead . :ob-lkahd)
    (:obstacle-tracked . :ob-trckd)
    (:max-events-per-tick . :mx-t-evts)
    (:curr-kernel . :kernel)))

;;; non-standard format specs for gui display (standard is "~a"):

(defparameter *param-formatters*
  '((:sepmult . "~,2f")
    (:cohmult . "~,2f")
    (:alignmult . "~,2f")
    (:lifemult . "~,2f")
    (:predmult . "~,2f")
    (:speed . "~,2f")
    (:maxspeed . "~,2f")
    (:maxforce . "~,2f")
    (:master-amp . "~,2f")
    (:auto-amp . "~,2f")
    (:pl1-amp . "~,2f")
    (:pl2-amp . "~,2f")
    (:pl3-amp . "~,2f")
    (:pl4-amp . "~,2f")))

#|

;;; the following is now directly handled in bp-set-value

(defun gui-set-param-value (param val)
  "set field of param in gui with val."
  (let ((entry (gethash param *param-gui-pos*)))
    (qt:emit-signal (getf entry :gui)
                    "setText(QString)" (format nil (getf entry :formatter) val))))

;;; (gui-set-param-value :alignmult 5)

|#

(defun cl-boids-gpu::set-num-boids (num)
;;  (setf *num-boids* num)
  (bp-set-value :num-boids num)
  (fudi-send-num-boids num))

(defun gui-set-formatter (param format-string)
  "set format string of param in gui."
  (let ((entry (gethash param *param-gui-pos*)))
    (setf (getf entry :formatter) format-string)))

;;; (gui-set-formatter :length "~4,2f")

(defun gui-set-audio-args (str)
  "set field of param in gui with val."
  (let ((gui (gethash :param-gui *param-gui-pos*)))
    (qt:emit-signal gui "setAudioArgs(QString)" str)))

(defun gui-set-midi-cc-fns (str)
  "set field of param in gui with val."
  (let ((gui (gethash :param-gui *param-gui-pos*)))
    (qt:emit-signal gui "setMidiCCFns(QString)" str)))

(defun gui-set-midi-note-fns (str)
  "set field of param in gui with val."
  (let ((gui (gethash :param-gui *param-gui-pos*)))
    (qt:emit-signal gui "setMidiNoteFns(QString)" str)))

;;; set labels and register gui components in hash-table

(defun init-param-gui (id)
  (let ((gui (cuda-gui::find-gui id)))
    (setf (gethash :gui-params *param-gui-pos*)
          '(:num-boids :boids-per-click :clockinterv :obstacles-lookahead :speed
;;;  :maxspeed :maxforce
            :maxidx
            :length :sepmult :cohmult :alignmult :predmult :maxlife :lifemult
            :23 :master-amp
            :auto-apr :pl1-apr :pl2-apr :pl3-apr :pl4-apr
            :auto-amp :pl1-amp :pl2-amp :pl3-amp :pl4-amp
            ;;           :max-events-per-tick :obstacle-tracked :curr-kernel :bg-amp :trig
            ))
    (loop for param in (gethash :gui-params *param-gui-pos*)
       for idx from 0
       do (multiple-value-bind  (row column) (floor idx 5)
            (setf (gethash idx *param-gui-pos*) param)
            (setf (gethash param *param-gui-pos*)
                  (list :pos (list row column)
                        :gui (aref (cuda-gui::param-boxes gui)
                                   (+ (* row 5) column))
                        :formatter (or (cdr (assoc param *param-formatters*)) "~a")))
            (qt:emit-signal
             (aref (cuda-gui::param-boxes (cuda-gui::find-gui id)) idx
;;;                    (+ (* row 5) column)
                   )
             "setLabel(QString)" (format nil "~a:" (or (cdr (assoc param *param-labels*)) param)))))
    (setf (gethash :param-gui *param-gui-pos*) gui)))

;;; (init-param-gui :pv1)

(defun set-boid-gui-refs (boid-params)
  "set the refs of the gui to the global *bp* model."
  (loop
    for param in (gethash :gui-params *param-gui-pos*)
    for spec = (gethash param *param-gui-pos*)
    for param-view-box = (getf spec :gui)
    for ref = (unless (member param '(:23 :24))
                (slot-value boid-params (intern (symbol-name param) 'cl-boids-gpu)))
    do (if ref (progn
                 (set-ref param-view-box ref)
                 (setf (cuda-gui::pformatter param-view-box) (getf spec :formatter))))))

;;; TODO: incorporate *curr-boid-state* altogether into *bp*

(defun set-bp-refs (src dest)
  "set the references of *curr-boid-state* cells to the *bp* model-cells."
  (dolist (slots '((speed speed)
                   (sepmult sepmult)
                   (cohmult cohmult)
                   (alignmult alignmult)
                   (predmult predmult)
                   (length len)
                   (maxlife maxlife)
                   (lifemult lifemult)))
    (destructuring-bind (src-slot dest-slot) slots
      (setf (slot-value dest dest-slot) (make-instance 'value-cell :ref (slot-value src src-slot))))))

;;; (set-bp-refs *bp* *curr-boid-state*)

(defun set-bp-apr-cell-hooks (src)
  "set the cell-hooks of apr *bp* model-cells to load the audio preset
and update emacs and *curr-audio-preset-no* in case the player is the
current player."
  (loop
    for slot in '(auto-apr pl1-apr pl2-apr pl3-apr pl4-apr)
    for player-ref from 0    
    do (setf (slot-value (slot-value src (intern (symbol-name slot) 'cl-boids-gpu)) 'set-cell-hook)
             (let ((player-ref player-ref))
               (lambda (num) (load-audio-preset :no num :player-ref player-ref))))))
