;;; 
;;; joystick.lisp
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

(in-package :incudine)

(progn
  (recv-stop *fudi-in*)
  (fudi:close *fudi-in*))

(progn
  (defparameter *fudi-in*
    (fudi:open :host "localhost" :port 3103 :direction :input :protocol :tcp))
  (recv-start *fudi-in*)
  (defparameter *fudi-responder*
    (incudine::make-fudi-responder *fudi-in*
                                   (lambda (msg) (format t "~a~%" msg)))))

(progn
  (defparameter *fudi-in*
    (fudi:open :host "localhost" :port 3105 :direction :input :protocol :udp :element-type 'unsigned-byte))
  (recv-start *fudi-in*)
  (defparameter *fudi-responder*
    (incudine::make-fudi-responder *fudi-in*
                                   (lambda (msg) (format t "~a~%" msg)))))

(progn
  (defparameter *fudi-in*
    (fudi:open :host "localhost" :port 3107 :direction :input :protocol :udp :element-type 'character))
  (recv-start *fudi-in*)
  (defparameter *fudi-responder*
    (incudine::make-fudi-responder *fudi-in*
                                   (lambda (msg) (format t "~a~%" msg)))))

(progn
  (defparameter *fudi-in*
    (fudi:open :host "localhost" :port 3106 :direction :input :protocol :tcp :element-type 'unsigned-byte))
  (recv-start *fudi-in*)
  (defparameter *fudi-responder*
    (incudine::make-fudi-responder *fudi-in*
                                   (lambda (msg) (format t "~a~%" msg)))))
