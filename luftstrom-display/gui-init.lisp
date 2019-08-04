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

(defun boid-open-gui ()
  (if (find-gui :pv1)
      (gui-stop))
   (gui-funcall (create-tl-widget 'param-view-grid :pv1)))

;;; (gui-funcall (create-tl-widget 'param-view-grid :pv3))

(export 'boid-open-gui 'incudine-gui)

(defun param-view-grid-open (&key (id "pv-gui"))
  (gui-funcall (create-tl-widget 'param-view-grid id)))

(in-package #:luftstrom-display)

(defun boid-init-gui ()
  (incudine-gui::boid-open-gui)
  (sleep 1)
  (init-param-gui :pv1)
  (gui-set-param-value :length 5))

;;; (boid-init-gui)

;;; (boid-open-gui)

