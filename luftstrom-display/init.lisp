;;; 
;;; init.lisp
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

(in-package :cl-user)

(defun ld ()
  (setf *package* (find-package :luftstrom-display)))

(in-package :luftstrom-display)

#|
(setf *presets-file* "presets/schwarm-video.lisp")
(setf *audio-presets-file* "presets/schwarm-audio-presets-video.lisp")
(setf *presets-file* "presets/schwarm-18-12-06.lisp")
(setf *audio-presets-file* "presets/schwarm-audio-presets-18-12-0
6.lisp")

;;; (load-presets)
;;; (load-audio-presets)
|#

(defparameter *ip-galaxy* "192.168.67.21")
;;(defparameter *ip-local* "127.0.0.1")
(defparameter *ip-local* "192.168.67.12")

(defparameter *ip-tablets* '("192.168.67.19" "192.168.67.42 "))
(defparameter *ip-jst* '("192.168.67.19"))

(defun mosaik ()
  (setf *ip-galaxy* "192.168.11.20")
;;;  (setf *ip-local* "192.168.11.9")
  (setf *ip-local* "192.168.11.11")
;;  (setf *ip-local* "127.0.0.1")
  (setf *ip-tablets* '("192.168.11.20"))
  (setf *ip-jst* '("192.168.11.40"
                   "192.168.11.45"
                   "192.168.11.47"
                   "192.168.11.48")))

(defun bahn ()
  (setf *ip-galaxy* "192.168.11.20")
;;;  (setf *ip-local* "192.168.11.9")
;;;  (setf *ip-local* "192.168.11.11")
  (setf *ip-local* "127.0.0.1")
  (setf *ip-tablets* '("192.168.11.20"))
  (setf *ip-jst* '("192.168.11.40"
                   "192.168.11.45"
                   "192.168.11.47"
                   "192.168.11.48")))

;;; (mosaik)
(bahn)

(defparameter *curr-boids-state* nil)
(setf *curr-boids-state* (make-instance 'cl-boids-gpu::boid-system-state))

(defun init-flock ()
  (setf *basedir*  (pathname "/home/orm/work/kompositionen/uptoten/lisp/luftstrom/luftstrom-display/"))
  (cd *basedir*)
  (setf *presets-file* (bs-full-path "presets/salzburg-2020-01-23-presets.lisp"))
;;  (setf *audio-presets-file* (bs-full-path "presets/flock-2020-06-11-audio.lisp"))

  (setf *audio-presets-file* (bs-full-path "presets/flock-2020-07-04-mosaik-audio.lisp"))
;;;  (setf *bs-presets-file* (bs-full-path "presets/flock-solo-01-bs.lisp"))
  (setf *bs-presets-file* (bs-full-path "presets/flock-2020-08-27-mosaik-bs.lisp"))
  (init-cc-presets)
;;;  (set-fixed-cc-fns (find-controller :nk2))
  (load-audio-presets)
;;  (init-emacs-display-fns)
  (load-presets)
  (restore-bs-presets)
  (setf *trig* t)
  ;;  (gui-recall-preset 0)
)

(boid-init-gui :width 750 :x-pos 0 :y-pos 0)
(sleep 2)
(set-boid-gui-refs *bp*)
(set-bp-refs *bp* *curr-boid-state*)
(set-bp-apr-cell-hooks *bp*)
(init-flock)

;;;
;;; (init-beatstep *midi-out1*)
;; (setf (aref *cc-fns* *art-chan* 0)
;;       (lambda (val) (format t "~&cb-val: ~a~%" val)))
;; 
;; (setf (aref *cc-fns* *art-chan* 1)
;;       (lambda (val) (format t "~&hallo Tobi: ~a~%" val)))

(start-midi-receive *midi-in1*)
;;; (sleep 2)
#|
(make-instance
 'beatstep
 :id :bs1 :chan (controller-chan :bs1)
 :cc-state (sub-array *cc-state* (controller-chan :bs1))
 :cc-fns (sub-array *cc-fns* (controller-chan :bs1)))
;;; (make-instance 'beatstep :id :bs2)


|#


(osc-start)
(sleep 1)
(init-beatstep *midi-out1*)
(sleep 1)
(add-midi-controller
 'beatstep
 :id :bs1
 :chan (controller-chan :bs1)
 :cc-state (sub-array *cc-state* (controller-chan :bs1))
 :cc-fns (sub-array *cc-fns* (controller-chan :bs1))
 :x-pos 0
 :y-pos 330
 :width 750
 :height 140)

(let* ((id :nk2) (chan (controller-chan id)))
  (add-midi-controller
   'nanokontrol
   :id :nk2 :chan chan
   :cc-state (sub-array *cc-state* chan)
   :cc-fns (sub-array *cc-fns* chan)
   :x-pos 0
   :y-pos 490
   :height 60
   :width 750))

(let* ((id :nk2-02) (chan (controller-chan id)))
  (add-midi-controller
   'nanokontrol
   :id :nk2-02 :chan chan
   :cc-state (sub-array *cc-state* chan)
   :cc-fns (sub-array *cc-fns* chan)
   :x-pos 0
   :y-pos 690
   :height 60
   :width 750))


#|
(defparameter *tabletctl*
  (make-instance 'obstacle-ctl-tablet
                 :id :tab1
                 :osc-in *osc-obst-ctl*
                 :remote-ip *ip-galaxy*
                 :remote-port 3090))

|#
#|
(dotimes (player 1)
  (let ((id (make-keyword (format nil "tab-p~d" (1+ player)))))
    (remove-osc-controller id)
    (defparameter *one-player-tabletctl*
      (make-instance 'one-player-ctl-tablet
                     :id id
                     :osc-in *osc-obst-ctl*
                     :remote-ip *ip-galaxy*
                     :remote-port 3090
                     :reverse-ip *ip-local*
                     
                     :reverse-port 3089
                     :player-idx player))))
|#

(defparameter *one-player-tablets* #(nil nil nil nil))


(loop for player from 0
      for remote-ip in *ip-tablets*
      do (let ((id (make-keyword (format nil "tab-p~d" (1+ player))))
               (audio-preset-ref-slotname
                 (string->symbol (format nil "pl~d-apr" (1+ player)) :cl-boids-gpu)))
           (remove-osc-controller id)
           (set-cell (slot-value *bp* audio-preset-ref-slotname) 43)
           (setf (aref *one-player-tablets* player)
                 (make-instance 'one-player-ctl-tablet
                                :id id
                                :osc-in *osc-obst-ctl*
                                :remote-ip remote-ip
                                :remote-port 3090
                                :reverse-ip *ip-local*
                                :reverse-port 3089
                                :player-idx player))))

;;; (remove-osc-controller :tab-p1)

(loop
  for player from 0
  for remote-ip in *ip-jst*
  do (let ((id (make-keyword (format nil "jst-p~d" (1+ player))))
           (audio-preset-ref-slotname
             (string->symbol (format nil "pl~d-apr" (1+ player)) :cl-boids-gpu)))
       (remove-osc-controller id)
       (set-cell (slot-value *bp* audio-preset-ref-slotname) 43)
       (add-osc-controller 'joystick-tablet
                           :id id
                           :osc-in *osc-obst-ctl*
                           :remote-ip remote-ip
                           :remote-port 3090
                           :reverse-ip *ip-local*
                           :reverse-port 3089
                           :player-idx player)))

;;; (remove-osc-controller :tab-p1)
;;; (remove-osc-controller :jst-p1)

(loop
  for num from 1 to 1
  for ip in (list  "192.168.11.31" "192.168.11.32" "192.168.11.33" "192.168.11.34")
  for id = (ou::make-keyword (format nil "ewi~d" num))
  do (progn
       (remove-osc-controller id)
       (add-osc-controller
        'ewi-controller
        :id id
        :player num
        :minspeed 1
        :maxspeed 400
        :osc-in *osc-obst-ctl*
        :remote-ip ip
        :remote-port 3091
        :x-pos 0
        :y-pos (+ 490 (* num 100))
        :height 60)))

(defun n-exp-zero (x min max)
  "linear interpolation for normalized x."
  (if (zerop x) 0
      (* min (expt (/ max min) x))))

#|

(make-instance 'ewi-controller
               :id (make-symbol (string-upcase (format nil "ewi~d" num)))
               :player (make-symbol (string-upcase (format nil "player~d" num))) 
               :x-pos 0
               :y-pos 580
               :height 60)
(load-audio-preset :no 4 :player-ref (player-aref :player1))
|#


#|
(loop
  for num from 1 to 4
  do (ewi-gui :id (ou::make-keyword (format nil "ewi~d" num))
              :x-pos 0
              :y-pos (+ 500 (* num 80))
              :height 60))
|#
(load-preset 0)
(init-player-obstacles)
#|


(let ((id :nk2-2) (chan 1))
  (make-instance 'nanokontrol :id id :chan chan))
|#


;; (set-nk2-std (find-gui :nk2))

;; (setf (val (alignmult *bp*)) 3.1)
;;; (osc-start)

;;; (setf cl-boids-gpu::*gl-y-aspect* 10)
;;; (setf *gl-height* 1000)

;;; (numerator (/ 1600 1000))

#|
(cl-boids-gpu:boids :width 1728
                    :height 1080
                    :gl-width 1600
                    :gl-height 1000
                    :pos-y -15 :pos-x (+ 1600 (- 1920 1728)))

(* 1280 9/16)                                      ;
(let* ((width 1280)
       (height 720)
       (monitoraspect (/ width height)))
  (setf cl-boids-gpu::*gl-x-aspect* (numerator monitoraspect))
  (setf cl-boids-gpu::*gl-y-aspect* (denominator monitoraspect))
  (cl-boids-gpu:boids :width width :height height :pos-y -15 :pos-x 1600))
|#
(let* ((width 1920)
       (height 1080)
       (monitoraspect (/ width height)))
  (setf cl-boids-gpu::*gl-x-aspect* (numerator monitoraspect))
  (setf cl-boids-gpu::*gl-y-aspect* (denominator monitoraspect))
  (cl-boids-gpu:boids :width width :height height :pos-y -15 :pos-x 1600))


;;; (slime-autodoc)

;;; (cl-boids-gpu:boids :width 1728 :height 1080 :pos-y -15 :pos-x (- 1728 1600))
;;;(cl-boids-gpu:boids :width 1600 :height 1000 :pos-y -15 :pos-x 1920)

;;;(cl-boids-gpu:boids :width 1920 :height 1080 :pos-y -15 :pos-x 1600)
;;; (cl-boids-gpu:boids :width 800 :height 450)
;;; (set-fader (find-gui :nk2) 0 28)

;;; (defparameter test (make-instance 'beatstep :id :bs3))

;;; (cuda-gui::remove-gui :bs2)
;;; (cuda-gui::remove-gui :nk1)

