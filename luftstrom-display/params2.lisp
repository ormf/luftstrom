;;; 
;;; params2.lisp
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

(in-package #:luftstrom-display)

#|
(defmacro set-exp-midi-cc ((cc min max) &body body)
  `(setf (aref *nk2-01-fns* ,cc)
         (let ((ipfn (ou:ip-exp ,min ,max 128)))
           (lambda (d2)
             ,@body))))

(defmacro set-lin-midi-cc ((cc min max) &body body)
  `(setf (aref *nk2-01-fns* ,cc)
         (let ((ipfn (ou:ip-lin ,min ,max 128)))
           (lambda (d2)
             ,@body))))
|#

(defmacro with-lin-midi-fn ((min max) &body body)
  "return closure with ipfn bound to a linear interpolation of the
input range 0..127 between min and max."
  `(let ((ipfn (ou:ip-lin ,min ,max 128)))
     (lambda (d2)
       (cond ((numberp d2)
              ,@body)))))

(defmacro with-exp-midi-fn ((min max) &body body)
  "return closure with ipfn bound to an exponential interpolation of
the input range 0..127 between min and max."
  `(let ((ipfn (ou:ip-exp ,min ,max 128)))
     (lambda (d2)
       (cond ((numberp d2)
              ,@body)))))

(defun set-param-from-key (key val)
  (let ((sym (intern (format nil "*~a*" (string-upcase (symbol-name key)))
                     'luftstrom-display)))
    (setf (symbol-value sym) val)))

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

(defun digest-audio-arg (key val)
  (case key
    (:default (setf (elt *curr-audio-presets* 0) (or val (elt *curr-audio-presets* 0))))
    (:player1 (setf (elt *curr-audio-presets* (+ 2 (obstacle-ref (obstacle 0))))
                    (or val (elt *curr-audio-presets* 0))))
    (:player2 (setf (elt *curr-audio-presets* (+ 2 (obstacle-ref (obstacle 1))))
                    (or val (elt *curr-audio-presets* 0))))
    (:player3 (setf (elt *curr-audio-presets* (+ 2 (obstacle-ref (obstacle 2))))
                    (or val (elt *curr-audio-presets* 0))))
    (:player4 (setf (elt *curr-audio-presets* (+ 2 (obstacle-ref (obstacle 3))))
                    (or val (elt *curr-audio-presets* 0))))
    (:otherwise (warn "digest-audio-arg: Wrong key ~a in audio-arg" key))))

(defun set-default-audio-preset (val)
  (dolist (key '(:player1 :player2 :player3 :player4))
    (digest-audio-arg key (eval val))))

(defun digest-audio-args (defs)
  (set-default-audio-preset (getf defs :default))
  (loop for (key val) on defs by #'cddr
        do (digest-audio-arg key (eval val))))

(defun digest-cc-def (cc-ref fn old-state &key (reset t))
  (let ((chan (player-chan (first cc-ref))))
    (setf (apply #'aref *cc-fns* chan (rest cc-ref)) fn)
    (if reset
        (funcall fn (apply #'aref old-state chan (rest cc-ref))))
;;;    (register-cc-fn fn) ;;; this was intended to be able to reset hanging obst movement fns.
    ))


;;; (deactivate-cc-fns)
                                        ;:; (player-chan 4)

;;; (funcall (aref *cc-fns* 4 4) (aref (getf (aref *presets* 2) :midi-cc-state) 4 4))

#|
(loop for (coords def) in val
      do (digest-cc-def coords (eval def) ))

(funcall #'cc-preset 0 :nk2-std)

           (let ((fn (eval def)))
             (setf (apply #'aref *cc-fns* coords) fn)
             (funcall fn (apply #'aref (getf preset :midi-cc-state) coords))
             (register-cc-fn fn))
|#

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
  "A def is similar to a property list, alternating between keyword and
values. The keyword is a player-ref (either idx or name), the value is
a function of the player-ref which sets the definitions."
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
  (dotimes (chan 5) (clear-cc-fns chan))
  (loop for (ctl templ) in (getf preset :midi-cc-fns)
     do (setf (apply #'aref *cc-fns* ctl) (eval templ)))
  (loop for (key val) on (getf preset :boid-params) by #'cddr
     do (if (set-in-gui? key)
          (set-param-from-key key val)))
  (digest-arg-fns (getf preset :audio-args))
  (values))

(defun format-boid-params ()
  (loop for param in
       '(*speed* *obstacles-lookahead*
         *maxspeed* *maxforce* *maxidx* *length*
         *sepmult* *alignmult* *cohmult* *predmult* *maxlife*
         *lifemult* *max-events-per-tick*)
     do (format t "~&:~a ~a~%"
                (string-trim "*" (string-downcase (symbol-name param)))
                (symbol-value param))))

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
    (:maxspeed . "~,2f")
    (:maxforce . "~,2f")
    (:bg-amp . "~,2f")))

(defun gui-set-param-value (param val)
  "set field of param in gui with val."
  (let ((entry (gethash param *param-gui-pos*)))
    (qt:emit-signal (getf entry :gui)
                    "setText(QString)" (format nil (getf entry :formatter) val))))

;;; (gui-set-param-value :alignmult 5)
(defun cl-boids-gpu::set-num-boids (num)
  (setf *num-boids* num)
  (gui-set-param-value :num-boids num)
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

;;; set labels and register gui components in hash-table

(defun init-param-gui (id)
  (let ((gui (cuda-gui::find-gui id)))
    (loop for param in
         '(:num-boids :boids-per-click :clockinterv :obstacles-lookahead :speed :maxspeed :maxforce :maxidx
           :length :sepmult :cohmult :alignmult :predmult :maxlife :lifemult :max-events-per-tick :obstacle-tracked :curr-kernel :bg-amp :trig)
       for idx from 0
       do (multiple-value-bind  (row column) (floor idx 5)
            (setf (gethash idx *param-gui-pos*) param)
            (setf (gethash param *param-gui-pos*)
                  (list :pos (list row column)
                        :gui (aref (cuda-gui::param-boxes gui)
                                   (+ (* row 5) column))
                        :formatter (or (cdr (assoc param *param-formatters*)) "~a")))
            (qt:emit-signal
             (aref (cuda-gui::param-boxes (cuda-gui::find-gui id))
                   (+ (* row 5) column))
             "setLabel(QString)" (format nil "~a:" (or (cdr (assoc param *param-labels*)) param)))))
    (setf (gethash :param-gui *param-gui-pos*) gui)))

;;; (init-param-gui :pv1)
