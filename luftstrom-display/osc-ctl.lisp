;;; 
;;; osc-ctl.lisp
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

(defparameter *osc-obst-ctl* nil)
(defparameter *osc-obst-ctl-echo* nil)

;;; local-comenius: "192.168.67.19"
;;; galaxy-comenius: "192.168.67.20"

;;; (defparameter *ip-galaxy* "192.168.1.15")
;;; (defparameter *ip-local* "192.168.1.14")

;;; (defparameter *ip-galaxy* "192.168.2.20")
;;; (defparameter *ip-local* "192.168.2.35")

;;; (defparameter *ip-galaxy* "192.168.67.20")
;;; (defparameter *ip-galaxy* "192.168.67.21")
;;; (defparameter *ip-local* "192.168.67.19")

(defun map-type (type)
  (aref #(0 2 1 4 3) (round type)))

(defun osc-start ()
  (setf *osc-obst-ctl*
        (incudine.osc:open :direction :input
                           :host *ip-local* :port 3089))
  (setf *osc-obst-ctl-echo*
        (incudine.osc:open :direction :output
                           :host *ip-galaxy*  :port 3090))
  (recv-start *osc-obst-ctl*)
  (make-osc-responder *osc-obst-ctl* "/xy1" "ff"
                      (lambda (x y)
                        (let ((x x) (y y))
                          (cl-boids-gpu::gl-enqueue
                           (lambda () 
                             (cl-boids-gpu::set-obstacle-position
                              cl-boids-gpu::*win* 0
                              (* cl-boids-gpu::*real-width* x) (* *height* (- 1 y))))))))
  (make-osc-responder *osc-obst-ctl* "/xy2" "ff"
                      (lambda (x y)
                        (let ((x x) (y y))
                          (cl-boids-gpu::gl-enqueue
                           (lambda () 
                             (cl-boids-gpu::set-obstacle-position
                              cl-boids-gpu::*win* 1
                              (* cl-boids-gpu::*real-width* x) (* *height* (- 1 y))))))))
  (make-osc-responder *osc-obst-ctl* "/xy3" "ff"
                      (lambda (x y)
                        (let ((x x) (y y))
                          (cl-boids-gpu::gl-enqueue
                           (lambda () 
                             (cl-boids-gpu::set-obstacle-position
                              cl-boids-gpu::*win* 2
                              (* cl-boids-gpu::*real-width* x) (* *height* (- 1 y))))))))
  (make-osc-responder *osc-obst-ctl* "/xy4" "ff"
                      (lambda (x y)
                        (let ((x x) (y y))
                          (cl-boids-gpu::gl-enqueue
                           (lambda () 
                             (cl-boids-gpu::set-obstacle-position
                              cl-boids-gpu::*win* 3
                              (* cl-boids-gpu::*real-width* x) (* *height* (- 1 y))))))))
  (make-osc-responder *osc-obst-ctl* "/obsttype1" "f"
                      (lambda (type)
                        (cl-boids-gpu::gl-set-obstacle-type 0 (map-type type))))
  (make-osc-responder *osc-obst-ctl* "/obstactive1" "f"
                      (lambda (obstactive)
                        (case obstactive
                          (0.0 (deactivate-obstacle 0))
                          (otherwise (activate-obstacle 0)))))
  (make-osc-responder *osc-obst-ctl* "/obstvolume1" "f"
                      (lambda (amp)
                        (let* ((player 0)
                               (obstacle (aref *obstacles* player)))
                          (with-slots (brightness radius)
                              obstacle
                            (set-lookahead player (float (n-exp amp 2.5 10.0)))
                            (set-multiplier player (float (n-exp amp 1 1.0)))
                            (setf brightness (n-lin amp 0.2 1.0))))))

  (make-osc-responder *osc-obst-ctl* "/obsttype2" "f"
                      (lambda (type)
                        (cl-boids-gpu::gl-set-obstacle-type 1 (map-type type))))
  (make-osc-responder *osc-obst-ctl* "/obstactive2" "f"
                      (lambda (obstactive)
                        (case obstactive
                          (0.0 (deactivate-obstacle 1))
                          (otherwise (activate-obstacle 1)))))
  (make-osc-responder *osc-obst-ctl* "/obstvolume2" "f"
                      (lambda (amp)
                        (let* ((player 1)
                               (obstacle (aref *obstacles* player)))
                          (with-slots (brightness radius)
                              obstacle
                            (set-lookahead player (float (n-exp amp 2.5 10.0)))
                            (set-multiplier player (float (n-exp amp 1 1.0)))
                            (setf brightness (n-lin amp 0.2 1.0))))))
  
  (make-osc-responder *osc-obst-ctl* "/obsttype3" "f"
                      (lambda (type)
                        (cl-boids-gpu::gl-set-obstacle-type 2 (map-type type))))
  (make-osc-responder *osc-obst-ctl* "/obstactive3" "f"
                      (lambda (obstactive)
                        (case obstactive
                          (0.0 (deactivate-obstacle 2))
                          (otherwise (activate-obstacle 2)))))
  (make-osc-responder *osc-obst-ctl* "/obstvolume3" "f"
                      (lambda (amp)
                        (let* ((player 2)
                               (obstacle (aref *obstacles* player)))
                          (with-slots (brightness radius)
                              obstacle
                            (set-lookahead player (float (n-exp amp 2.5 10.0)))
                            (set-multiplier player (float (n-exp amp 1 1.0)))
                            (setf brightness (n-lin amp 0.2 1.0))))))

  (make-osc-responder *osc-obst-ctl* "/obsttype4" "f"
                      (lambda (type)
                        (cl-boids-gpu::gl-set-obstacle-type 3 (map-type type))))
  (make-osc-responder *osc-obst-ctl* "/obstactive4" "f"
                      (lambda (obstactive)
                        (case obstactive
                          (0.0 (deactivate-obstacle 3))
                          (otherwise (activate-obstacle 3)))))
  (make-osc-responder *osc-obst-ctl* "/obstvolume4" "f"
                      (lambda (amp)
                        (let* ((player 3)
                               (obstacle (aref *obstacles* player)))
                          (with-slots (brightness radius)
                              obstacle
                            (set-lookahead player (float (n-exp amp 2.5 10.0)))
                            (set-multiplier player (float (n-exp amp 1 1.0)))
                            (setf brightness (n-lin amp 0.2 1.0)))))))

(defun osc-stop ()
  (recv-stop *osc-obst-ctl*)
  (remove-all-responders *osc-obst-ctl*)
  (incudine.osc:close *osc-obst-ctl*)
  (incudine.osc:close *osc-obst-ctl-echo*))


(defun obst-active (player active)
  (incudine.osc:message
   *osc-obst-ctl-echo*
   (format nil "/obstactive~d" (1+ player)) "f" (float active)))

(defun obst-amp (player amp)
  (incudine.osc:message
   *osc-obst-ctl-echo*
   (format nil "/obstvolume~d" (1+ player)) "f" (float amp)))


(defun obst-xy (player x y)
  (setf luftstrom-display::*last-xy* (list x y))
  (incudine.osc:message
   *osc-obst-ctl-echo*
   (format nil "/xy~d" (1+ player)) "ff" (float x) (float y)))

(defun obst-type (player type)
  (incudine.osc:message
   *osc-obst-ctl-echo*
   (format nil "/obsttype~d" (1+ player)) "f" (float type)))


#|
(obst-active 0 0)
(obst-xy 0 0.1 0.8)
(obst-amp 0 0.6)
(obst-type 0 2)

(progn
  (recv-stop *osc-obst1-ctl*)
  (remove-all-responders *osc-obst1-ctl*)
  (incudine.osc:close *osc-obst1-ctl*))

(incudine.osc:close *osc-obst-ctl-echo*)

(defun obst-xy (player x y)
  "stub when no osc connection"
  (declare (ignore player x y)))



(incudine.osc:message *osc-obst-ctl-echo* "/xy1" "ff" 0.5 0.5)




|#
