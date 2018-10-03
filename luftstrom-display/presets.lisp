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

(cd "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/")

(defparameter *presets*
  (make-array 100 :initial-element nil))
(defparameter *curr-preset* nil)
(defparameter *presets-file* "presets/schwarm01.lisp")

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

(setf (aref *nk2-fns* 0 58)
      (lambda (d2)
        (if (= d2 127)
            (previous-preset))))

(setf (aref *nk2-fns* 0 46)
      (lambda (d2)
        (if (= d2 127)
            (edit-preset-in-emacs *curr-preset-no*))))

(setf (aref *nk2-fns* 0 59)
      (lambda (d2)
        (if (= d2 127)
            (next-preset))))

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
            `(:midi-cc-state ,(alexandria:copy-array *nk2*)))))
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

;; (set-value :alignmult 3)

(defparameter *emcs-conn* swank::*emacs-connection*)

(defun load-preset (ref &key (presets *presets*))
  (let ((preset (if (numberp ref) (aref presets ref) ref)))
    (if preset
        (progn
          (digest-params preset)
          (loop for (param val) on (getf preset :boid-params) by #'cddr
             do (set-value param val))
          (gui-set-audio-args (preset-audio-args preset))
          (gui-set-midi-cc-fns (preset-midi-cc-fns preset))
          (loop for (coords def) in (getf preset :midi-cc-fns)
             do (progn
                  (setf (apply #'aref *nk2-fns* coords)
                        (eval def))
                  (funcall
                   (apply #'aref *nk2-fns* coords)
                   (apply #'aref (getf preset :midi-cc-state) coords))))
          (setf *curr-preset* preset)
          ))))

(defun edit-preset-in-emacs (ref &key (presets *presets*))
  (let ((swank::*emacs-connection* *emcs-conn*))
    (if (numberp ref)
        (swank::eval-in-emacs `(edit-preset ,(preset->string (aref presets ref)) ,(format nil "~a" ref)) t)
        (swank::eval-in-emacs `(edit-preset ,(preset->string ref) ,(format nil "~a" *curr-preset-no*)) t))))

;;; (load-preset 3)
;;; (load-preset *curr-preset*)

;;; (snapshot-curr-preset)
;;; *num-boids*

(defun capture-preset (preset)
  (setf (getf preset :boid-params)
        (loop for (key val) on (getf preset :boid-params) by #'cddr
           append (capture-param key val)))
  preset)

(defun snapshot-curr-preset ()
  (let ((preset (capture-preset *curr-preset*)))
        (progn
          (digest-params preset)
          (loop for (param val) on (getf preset :boid-params) by #'cddr
             do (set-value param val))
          (gui-set-audio-args (preset-audio-args preset))
          (gui-set-midi-cc-fns (preset-midi-cc-fns preset))
          (loop for (coords def) in (getf preset :midi-cc-fns)
             do (progn
                  (setf (apply #'aref *nk2-fns* coords)
                        (eval def))
                  (funcall
                   (apply #'aref *nk2-fns* coords)
                   (apply #'aref (getf preset :midi-cc-state) coords))))
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
             :lfo-freqfn (* 50 (expt 5 (/ (aref *nk2* 0 7) 127))
                          (expt (+ 1 (* 1.1 (round (* 16 y)))) (expt 1.3 x)))
             :x-posfn x
             :y-posfn y
             :wetfn 1
             :filt-freqfn 20000)
            :midi-cc-fns
            (((0 0)
              (with-exp-midi (0.1 2)
                (let ((speedf (funcall ipfn d2)))
                  (set-value :maxspeed (* speedf 1.05))
                  (set-value :maxforce (* speedf 0.09)))))
             ((0 1)
              (with-lin-midi (1 8)
                (set-value :sepmult (funcall ipfn d2))))
             ((0 2)
              (with-lin-midi (1 8)
                (set-value :cohmult (funcall ipfn d2))))
             ((0 3)
              (with-lin-midi (1 8)
                (set-value :alignmult (funcall ipfn d2))))))
          `(:midi-cc-state ,(alexandria:copy-array *nk2*)))))
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
    (setf (getf state :midi-cc-state) (alexandria:copy-array *nk2*))
    (setf (aref presets num) state))
  (values))

;;; (store-curr-preset 1)


(defun state-store-curr-preset (num &key (presets *presets*))
  "store current preset but use the current state of the boid-params."
  (let ((state (copy-list *curr-preset*)))
    (setf (getf *curr-preset* :boid-params)
          (loop for (key val) on (getf *curr-preset* :boid-params) by #'cddr
             append (capture-param key val)))
    (setf (getf state :midi-cc-state) (alexandria:copy-array *nk2*))
    (setf (aref presets num) state))
  (values))

;;; (state-store-curr-preset 1)

;;; (load-preset 5)
;;; (load-preset (aref *presets* 1))


(defun save-presets (&key (file *presets-file*))
  (with-open-file (out file :direction :output :if-exists :supersede)
    (format out "(setf *presets*~&~s)" *presets*))
  (format nil "presets written to ~a" file))

;;; (save-presets :file "presets/schwarm-18-10-03-02.lisp")

(defun load-presets (&key (file *presets-file*))
  (load file))

(load-presets)
(load-preset (aref *presets* 0))

