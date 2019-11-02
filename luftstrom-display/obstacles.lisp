;;; 
;;; obstacles.lisp
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

(in-package :cl-boids-gpu)

;;; *obstacles*

;;; (elt (systems *win*) 0)

(defun get-obstacles-state (win)
  "collect (list x y brightness radius active lookahead multiplier) of
all existing (not active!) obstacles from boid-system in the order of
*obstacles* (player-order)."
  (if win
      (let ((*command-queues* (command-queues win))
            (bs (first (systems win))))
        (if bs
            (with-slots (num-obstacles
                         maxobstacles
                         obstacles-pos
                         obstacles-radius
                         obstacles-type
                         obstacles-boardoffs-maxidx)
                bs
              (loop
                 for o across *obstacles*
                 collect (if (luftstrom-display::obstacle-exists? o)
                             (let* ((i (luftstrom-display::obstacle-ref o)))
                               (ocl:with-mapped-buffer (p1 (car *command-queues*) obstacles-pos (* 4 maxobstacles) :read t)
                                 (with-slots (luftstrom-display::x
                                              luftstrom-display::y
                                              luftstrom-display::brightness
                                              luftstrom-display::radius
                                              luftstrom-display::lookahead
                                              luftstrom-display::multiplier
                                              luftstrom-display::active)
                                     o
                                   (setf luftstrom-display::x (cffi:mem-aref p1 :float (+ (* i 4) 0)))
                                   (setf luftstrom-display::y (cffi:mem-aref p1 :float (+ (* i 4) 1)))
                                   (list
                                    luftstrom-display::x
                                    luftstrom-display::y
                                    luftstrom-display::brightness
                                    luftstrom-display::radius
                                    luftstrom-display::active
                                    luftstrom-display::lookahead
                                    luftstrom-display::multiplier)))))))))))


(defun update-get-active-obstacles (win &key (obstacles *obstacles*))
  "get the momentary (type x y radius brightness) of all active
obstacles."
  (let ((*command-queues* (command-queues win))
        (bs (first (systems win)))
        (width (glut:width win))
        (height (glut:height win))
        (result '()))
    (if bs
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-boardoffs-maxidx)
            bs
          (loop
            for o across obstacles
            for player from 0
            if (luftstrom-display::obstacle-active o)
              do (let* ((i (luftstrom-display::obstacle-ref o))
                       (radius (luftstrom-display::obstacle-radius o))
                       (brightness (luftstrom-display::obstacle-brightness o)))
                  (ocl:with-mapped-buffer (p1 (car *command-queues*) obstacles-pos (* 4 maxobstacles) :write t)
                    (ocl:with-mapped-buffer (p2 (car *command-queues*) obstacles-radius maxobstacles :write t)
                      (ocl:with-mapped-buffer (p4 (car *command-queues*) obstacles-type maxobstacles :read t)
                        (with-slots (dx dy x-steps y-steps x-clip y-clip) (aref (obstacle-target-posns bs) i)
                          (push
                           (list
                            (cffi:mem-aref p4 :int i)               ;;; type
                            player
                            (setf (luftstrom-display::obstacle-x o) (recalc-pos (cffi:mem-aref p1 :float (+ (* i 4) 0)) dx x-steps x-clip width)) ;;; x
                            (setf (luftstrom-display::obstacle-y o) (recalc-pos (cffi:mem-aref p1 :float (+ (* i 4) 1)) dy y-steps y-clip height)) ;;; y
                            (setf (cffi:mem-aref p2 :int i) (round radius))
                            brightness
                            )
                           result)))))))))
    (values (reverse result))))

;; (update-get-active-obstacles *win*)

#|
(let* ((window *win*)
       (bs (first (systems window)))
       (command-queue (first (command-queues window))))
  (with-slots (obstacles-lookahead maxobstacles) bs
    (ocl:with-mapped-buffer (p1 command-queue obstacles-lookahead maxobstacles :read t)
      (loop for i below maxobstacles
           collect (cffi:mem-aref p1 :float i)))))

|#
(defun gl-set-obstacles (win obstacles &key bs)
  "set obstacles in gl-buffer in the order specified by
obstacles (they should be sorted by type)."
  (let ((command-queue (first (command-queues win)))
        (bs (or bs (first (systems win))))
        (len (length obstacles)))
    (if bs
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-lookahead
                     obstacles-multiplier
                     obstacles-boardoffs-maxidx)
            bs
          (setf num-obstacles (min len maxobstacles))
          (ocl:with-mapped-buffer (p1 command-queue obstacles-pos (* 4 maxobstacles) :write t)
            (ocl:with-mapped-buffer (p2 command-queue obstacles-radius maxobstacles :write t)
              (ocl:with-mapped-buffer (p3 command-queue obstacles-boardoffs-maxidx maxobstacles :write t)
                (ocl:with-mapped-buffer (p4 command-queue obstacles-type maxobstacles :write t)
                  (ocl:with-mapped-buffer (p5 command-queue obstacles-lookahead maxobstacles :write t)
                    (ocl:with-mapped-buffer (p6 command-queue obstacles-multiplier maxobstacles :write t)
                      (loop for obst in obstacles
                         for i below num-obstacles
                         do (with-slots (luftstrom-display::x luftstrom-display::y luftstrom-display::radius luftstrom-display::type
                                                              luftstrom-display::lookahead
                                                              luftstrom-display::multiplier)
                                obst
                              (set-array-vals p1 (* i 4) (float luftstrom-display::x 1.0) (float luftstrom-display::y 1.0) 0.0 0.0)
                              (setf (cffi:mem-aref p2 :int i) (round luftstrom-display::radius))
                              (setf (cffi:mem-aref p3 :int i) (get-board-offs-maxidx (* luftstrom-display::radius *obstacles-lookahead*)))
                              (setf (cffi:mem-aref p4 :int i) luftstrom-display::type)
                              (setf (cffi:mem-aref p5 :float i) luftstrom-display::lookahead)
                              (setf (cffi:mem-aref p6 :float i) luftstrom-display::multiplier)))))))))
          num-obstacles))))

(defun move-obstacle-rel (player direction window &key (delta 1) (clip nil))
  (let ((bs (first (systems window))))
    (if bs
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-boardoffs-maxidx)
            bs
          (progn
            (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                        :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
              (let ((x (cffi:mem-aref p1 :float 0))
                    (y (cffi:mem-aref p1 :float 1)))
                (case direction
                  (:left (setf x (if clip
                                     (max 0 (- x delta))
                                     (mod (- x delta) (glut:width window)))))
                  (:right (setf x
                                (if clip
                                    (min (+ x delta) (glut:width window))
                                    (mod (+ x delta) (glut:width window)))))
                  (:up (setf y
                             (if clip
                                 (min (+ y delta) (glut:height window))
                                 (mod (+ y delta) (glut:height window)))))
                  (:down (setf y
                             (if clip
                                 (max 0 (- y delta))
                                 (mod (- y delta) (glut:height window))))))
                (setf (cffi:mem-aref p1 :float 0) (float x 1.0))
                (setf (cffi:mem-aref p1 :float 1) (float y 1.0)))))))))

(defun move-obstacle-rel-xy (player dx dy window &key (clip nil))
  (let ((bs (first (systems window))))
    (if bs
        (with-slots (num-obstacles
                     maxobstacles
                     obstacles-pos
                     obstacles-radius
                     obstacles-type
                     obstacles-boardoffs-maxidx)
            bs
          (progn
            (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                        :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
              (let ((x (cffi:mem-aref p1 :float 0))
                    (y (cffi:mem-aref p1 :float 1)))
                (setf x (if clip
                            (min (max 0 (+ x dx)) (glut:width window))
                            (mod (+ x dx) (glut:width window))))
                (setf y (if clip
                            (min (max 0 (+ y dy)) (glut:height window))
                            (mod (+ y dy) (glut:height window))))
                (setf (cffi:mem-aref p1 :float 0) (float x 1.0))
                (setf (cffi:mem-aref p1 :float 1) (float y 1.0)))))))))

(defun get-obstacle-pos (player window)
  (let ((bs (first (systems window))))
    (ocl:with-mapped-buffer
        (p1 (car (cl-boids-gpu::command-queues window))
            (cl-boids-gpu::obstacles-pos bs) 4
            :offset (* cl-boids-gpu::+float4-octets+
                       (get-obstacle-ref player)) :write t)
      (values (cffi:mem-aref p1 :float 0)
              (cffi:mem-aref p1 :float 1)))))

(defun make-obstacle-mask ()
  (loop
     for o across *obstacles*
     for active = (luftstrom-display::obstacle-active o)
;;     for player below 4
     with res = 0
     if (and active (luftstrom-display::obstacle-exists? o))
       do (setf res (logior res (ash 1 (luftstrom-display::obstacle-ref o))))
     finally (return res)))

;;; (make-obstacle-mask)

;;; (setf (luftstrom-display::obstacle-active (aref *obstacles* 0)) t)

;;; (setf (luftstrom-display::obstacle-exists? (aref *obstacles* 0)) t)

;;; *obstacles*
;;; (make-obstacle-mask)



(in-package :luftstrom-display)

(defstruct obstacle
  (exists? nil :type boolean)
  (type 0 :type integer)
  (radius 15 :type integer)
  (ref 0 :type integer) ;;; reference of OpenCL array
  (brightness 0.5 :type float)
  (lookahead 2.5 :type float)
  (multiplier 2.5 :type float)
  (moving nil :type boolean)
  (target-dx 0.0 :type float)
  (target-dy 0.0 :type float)
  (x 0.0 :type float)
  (y 0.0 :type float)
  (dtime 0.0 :type float)
  (active nil :type boolean))

;;; obstacles ist immer sortiert nach playern, d.h. (aref *obstacles*
;;; 0) ist immer das Obstacle von Player 1!

(defparameter *obstacles* (make-array '(16) :element-type 'obstacle :initial-contents
                                      (loop for idx below 16 collect (make-obstacle))))

(defparameter *player-idx* (make-array '(17) :element-type 'integer :initial-contents '(0 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil)))

(defparameter *mouse-ref* nil) ;;; reference of mouse-pointer into *obstacles*

(defun keynum->coords (keynum)
  (let ((kn (- (max 24 (min 107 keynum)) 24)))
    (multiple-value-bind (y x) (floor kn 12)
      (values (round (* (/ (+ 0.5 x) 12) *gl-width*))
              (round (* (- 1 (/ (+ 0.5 y) 7)) *gl-height*))))))

(defun tidx->player (tidx)
  (elt *player-idx* tidx))

;;; (setf (player-idx 2) 1)

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
  (sort seq #'> :key #'(lambda (elem) (obstacle-type elem))))

(defun obstacle (player)
  (elt *obstacles* player))

(defun maxobstacles ()
  (length *obstacles*))

(defun clear-obstacle-ref (player)
  (setf (obstacle-ref (obstacle player)) 0))

(defun clear-player-idx (idx)
  (setf (elt *player-idx* idx) nil))

(defun obstacle-idx (obstacle)
  (loop
     for o across *obstacles*
     for idx from 0
     if (eq o obstacle) return idx))

(defun set-obstacle-ref (obstacles)
  (dotimes (idx (maxobstacles))
    (clear-obstacle-ref idx)
    (clear-player-idx (1+ idx)))
  (loop
     for o in obstacles ;;; caution: 'obstacles are in (predator)
                        ;;; sorted order of gl-buffer, but reference
                        ;;; the elems of *obstacles*, which are in
                        ;;; player-order!
     for idx from 1
     do (progn
          (setf (obstacle-ref o) (1- idx))
          (setf (elt *player-idx* idx) (1+ (obstacle-idx o))))))

(defun clear-obstacle (o)
  (setf (obstacle-exists? o) nil)
  (setf (obstacle-active o) nil))

(defun clear-all-obstacles ()
  (dotimes (idx (length *obstacles*))
    (clear-obstacle (obstacle idx))))

(defun match-align (new old)
  (loop
     for x in new
     for idx in old)
  new)

(defun reset-obstacles-from-preset (val state)
  "reset *obstacles* according to preset values (a list of (type
radius) pairs while preserving the state of previous obstacles by
reinserting their state infos and pushing them onto window after
sorting in predator order. If state is nil use default values."
  (declare (ignorable state))
  (clear-all-obstacles)
  (loop for (type radius) in val
     for idx from 0
     for old-state = (elt (getf state :obstacles-state) idx)
     for o = (obstacle idx)
     do (if type
            (progn
;;;              (break "o: ~a, state: ~a" o state)
              (destructuring-bind (old-x old-y old-brightness old-radius old-active old-lookahead old-multiplier)
                  (or old-state '(nil nil nil nil nil nil nil))
                (declare (ignore old-radius))
                (setf (obstacle-type o) type)
                (setf (obstacle-lookahead o) (or old-lookahead 2.5))
                (setf (obstacle-multiplier o) (or old-multiplier 2.5))
                (setf (obstacle-radius o) radius)
                (setf (obstacle-exists? o) t)
                (setf (obstacle-x o) (or old-x 50.0))
                (setf (obstacle-y o) (or old-y 50.0))
                (setf (obstacle-brightness o) (or old-brightness 0.2))
                (setf (obstacle-active o) (if old-state old-active nil))))
            (clear-obstacle o)))
  (let ((win cl-boids-gpu::*win*)
        (new-obstacles
         (predator-sort
          (loop
             for o across *obstacles*
             if (obstacle-exists? o)
             collect o))))
    (if win
        (progn
          (clear-obstacles win)
          (gl-set-obstacles win new-obstacles)
          (set-obstacle-ref new-obstacles)))))

;;; (reset-obstacles-from-preset '((4 25)) (get-system-state))

(defun reset-obstacles-from-bs-preset (saved-obstacles obstacle-protect)
  "reset *obstacles* according to bs-preset value (*obstacles* at the
time of bs-preset capture). obstacle-protect can have the following values:

   nil - all saved-obstacles are restored.

   t   - the current state of obstacles is not altered.

   a list of player keywords or their idx - the obstacles of all
                                            listed players are not restored.
"
  (if (listp obstacle-protect) ;;; this is also t if obstacle-protect is nil!
      (let ((protected-chans (mapcar #'player-aref obstacle-protect)))
        (dotimes (i (length saved-obstacles))
          (unless (member (obstacle-ref (aref saved-obstacles i)) protected-chans)
            (setf (aref *obstacles* i)
                  (ucopy (aref saved-obstacles i)))))))
  (reset-obstacles))

(defun reset-obstacles ()
  "reset the *obstacles* in the gl window after sorting in predator
oder."
  (let ((win cl-boids-gpu::*win*)
        (new-obstacles
         (predator-sort
          (loop
             for o across *obstacles*
             if (obstacle-exists? o)
             collect o))))
    (if win
        (progn
          (clear-obstacles win)
          (gl-set-obstacles win new-obstacles)
          (set-obstacle-ref new-obstacles)))))

;;; (reset-obstacles-from-bs-preset (slot-value (aref *bs-presets* 0) 'cl-boids-gpu::bs-obstacles) '(:player2 :player3))

(defun activate-obstacle (player)
  (setf (obstacle-active (obstacle player)) t))

(defun deactivate-obstacle (player)
  (setf (obstacle-active (obstacle player)) nil))

(defun toggle-obstacle (player)
  (if (and player (obstacle-exists? (obstacle player)))
      (if (obstacle-active (obstacle player))
          (deactivate-obstacle player)
          (activate-obstacle player))))

(defun set-lookahead (player value)
  (let ((o (obstacle player)))
    (setf (obstacle-lookahead o) (float value))
    (cl-boids-gpu::set-obstacle-lookahead (obstacle-ref o) (float value))))

;;; (set-lookahead 0 2.5)

(defun set-multiplier (player value)
  (let ((o (obstacle player)))
    (setf (obstacle-multiplier o) (float value))
    (cl-boids-gpu::set-obstacle-multiplier (obstacle-ref o) (float value))))

(defun player-cc (tidx cc)
  (if (= tidx -1)
       (aref *cc-state* (player-aref :nk2) cc)
       (aref *cc-state* (player-aref (idx->player (1- tidx))) cc)))

(defun player-note (tidx)
  (if (= tidx -1)
      60
      (aref *note-states* (player-aref (idx->player (1- tidx))))))

(defun o-x (tidx)
  (if (= tidx -1)
      0.5
      (/ (obstacle-x (aref *obstacles* (idx->player (1- tidx)))) *gl-width*)))

(defun o-y (tidx)
  (if (= tidx -1)
      0.5
      (/ (obstacle-y (aref *obstacles* (idx->player (1- tidx)))) *gl-height*)))

;;; (player-cc 1 7)



#|(elt *obstacles* 0)

(setf (obstacle-exists? (elt *obstacles* 0)) t)
(setf (obstacle-active (elt *obstacles* 0)) t)
(setf (obstacle-ref (elt *obstacles* 0)) 0)
|#
;;; (set-multiplier 0 10)


;;; (obstacle 0)
;; (load-preset 0)



;;; (setf (obstacle-brightness (obstacle 0)) 0.2)

;;; (idx->player 0)

;;; (in-package :luftstrom-display)


;;; (get-obstacles)

