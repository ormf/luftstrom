;;; 
;;; gui-init.lisp
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

(in-package :incudine-gui)
(named-readtables:in-readtable :qt)

(declaim #+sbcl(sb-ext:muffle-conditions style-warning))
(incudine-gui::start)
(declaim #+sbcl(sb-ext:unmuffle-conditions style-warning))

;;; (gui-stop)

(defun param-view-grid-open (&rest args &key (id "pv-gui")
                                          (x-pos 0) (y-pos 0) (width 700) (height 600)
                             &allow-other-keys)
  (declare (ignorable x-pos y-pos width height))
  (gui-funcall (apply #'create-tl-widget 'param-view-grid id args)))

#|
(defun boid-open-gui ()
  (let ((gui (find-gui :pv1)))
    (if gui
        (gui-funcall (#_close gui))))
  (param-view-grid-open :id :pv1))
|#

(defun boid-open-gui (&rest args)
  (unless (find-gui :pv1)
    (apply #'param-view-grid-open :id :pv1 args)))

;;; (gui-funcall (create-tl-widget 'param-view-grid :pv3))

(export 'boid-open-gui 'incudine-gui)

(in-package #:luftstrom-display)

(defun boid-init-gui (&rest args)
  (apply #'cuda-gui::boid-open-gui args)
  (at (+ (now) 1)
    (lambda () 
      (init-param-gui :pv1)))
;;;  (gui-set-param-value :length 5)
  )

;;; (boid-init-gui)

;;; (boid-open-gui)

