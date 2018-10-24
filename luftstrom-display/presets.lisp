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

;; (set-value :curr-kernel "boids")

(defparameter *emcs-conn* swank::*emacs-connection*)



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
    (:num-boids (set-value key *num-boids*))
    (:obstacles (set-obstacles val))
    (t (set-value key val))))


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
                  (setf (apply #'aref *nk2-fns* coords)
                        (eval def))
                  (funcall
                   (apply #'aref *nk2-fns* coords)
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
           do (setf (aref *nk2-fns* x idx) #'identity)))
  (setf-fixed-cc-fns))

;;; (clear-cc-fns)

(defun snapshot-curr-preset ()
  (let ((preset (capture-preset *curr-preset*)))
        (progn
          (digest-params preset)
          (loop for (param val) on (getf preset :boid-params) by #'cddr
             do (set-value param val))
          (gui-set-audio-args (preset-audio-args preset))
          (gui-set-midi-cc-fns (preset-midi-cc-fns preset))
          (clear-cc-fns)
          (loop for (coords def) in (getf preset :midi-cc-fns)
             do (progn
                  (setf (apply #'aref *nk2-fns* coords)
                        (eval def))
                  (funcall
                   (apply #'aref *nk2-fns* coords)
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
    (format out "(in-package :luftstrom-display)~%~%(setf *presets*~&~s)" *presets*))
  (format nil "presets written to ~a" file))

;;; (save-presets :file "presets/schwarm-18-10-03-02.lisp")

(defun load-presets (&key (file *presets-file*))
  (load file))

(load-presets)
;; (load-preset (aref *presets* 0))

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
                    (or (if ref (aref *notes* player ref))
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
;;                   (format t "~&~a" (aref *ewi-states* player ref))
                   (move-obstacle-rel
                    player
                    dir
                    window :delta (if ref (m-exp (aref *nk2* player ref) 10 max)
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

bewegt sich immer so schnell, wie möglich zum Zielwert

bei Funktionsaufruf der Bewegungsfunktion:


|#

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
                           (setf (obstacle-active obstacle) nil)))))))
    ;;; lambda-function entry point
        (if (> d2 0)
            (let ((obstacle obstacle))
              (format t "~&received: ~a" d2)
              (case dir
                (:left (setf (obstacle-target-dx obstacle)
                             (float (* -1 (if ref (m-exp (aref *nk2* player ref) 10 max) 10.0)))))
                (:right (setf (obstacle-target-dx obstacle)
                              (float (if ref (m-exp (aref *nk2* player ref) 10 max) 10.0))))
                (:down (setf (obstacle-target-dy obstacle)
                             (float (* -1 (if ref (m-exp (aref *nk2* player ref) 10 max) 10.0)))))
                (:up (setf (obstacle-target-dy obstacle)
                           (float (if ref (m-exp (aref *nk2* player ref) 10 max) 10.0)))))
              (unless (obstacle-active obstacle)
                (setf (obstacle-active obstacle) t)
                (inner (now)))))))))


(defun make-retrig-move-fn (player &key (dir :up) (max 100) (ref nil) (clip nil))
  "return a function moving the obstacle of a player in a direction
specified by :dir which can be bound to be called each time, a new
event (like a cc value) is received. If ref is specified it points to
a cc value stored in *nk2* which is used for exponential interpolation
of the boid's stepsize between 10 and :max pixels."
  (let ((window cl-boids-gpu::*win*)
        (clip clip)
        (obstacle (obstacle player))
        (retrig? nil))
    (lambda (d2)
      (labels ((inner (time)
                 "recursive function (with time delay between calls)
moving the obstacle framewise in the directions specified by dx and
dy. As different gestures could trigger an instance of the
function (assigning a new instance by calling 'make-retrig-move-fn)
only one of it is run at a time for each obstacle (assured by
asserting that the 'active slot in the mvobst struct hasn't been set
by sombody else before calling this function). The target-dx and
target-dy slots can get reassigned by any outside process while the
function is running. The function terminates if the dx and dy are both
0, (setting the 'active slot back to nil so that it can get
retriggered)."
;;                 (format t "inner!, ")
                 (with-slots (target-dx target-dy) obstacle
                   (let* ((x-dist (abs target-dx))
                          (y-dist (abs target-dy))
                          (max-dist (max x-dist y-dist))
                          (dx 0) (dy 0))
 ;;                    (format t "~&mdist: ~a" max-dist)
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
                           (let ((next (+ time (/ 10.0)))) (at next #'inner next)))
                         (setf (obstacle-moving obstacle) nil)))))
               (retrig (time)
                 "recursive function (with time delay between calls)
simulating a repetition of keystrokes after a key is depressed (once)
until it is released."
                 (if retrig?
                     (let ((next (+ time 0.2)))
;;                       (format t "~&retrig, act: ~a" (obstacle-active obstacle))
                       (with-slots (target-dx target-dy moving) obstacle
                         (case dir
                           (:left (setf target-dx 
                                        (float (* -1 (if ref (m-exp (aref *ewi-states* player ref) 10 max) 10.0)))))
                           (:right (setf target-dx
                                         (float (if ref (m-exp (aref *ewi-states* player ref) 10 max) 10.0))))
                           (:down (setf target-dy
                                        (float (* -1 (if ref (m-exp (aref *ewi-states* player ref) 10 max) 10.0)))))
                           (:up (setf target-dy 
                                      (float (if ref (m-exp (aref *ewi-states* player ref) 10 max) 10.0)))))
                         (unless moving
                           (setf moving t)
                           (inner (now)))
                         (at next #'retrig next))))))
;;; lambda-function entry point
;;        (format t "~&me-received: ~a" d2)
        (if (> d2 0)
            (progn
              (setf retrig? t)
              (retrig (now)))
            (setf retrig? nil))))))

;;; (move-obstacle-rel-xy player dx dy window :clip clip)
;;; (setf (obstacle-moving (obstacle 0)) nil)

;; (setf (obstacle-active (obstacle 0)) nil)

