;;; 
;;; utils.lisp
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

(defun in-place-array-cp (src target)
  "copy src to target in place."
  (let ((total-size (array-total-size src)))
    (unless (= total-size
               (array-total-size target))
      (error "~a and ~a not of equal size" src target))
    (dotimes (i total-size)
      (setf (row-major-aref target i)
            (row-major-aref src i)))))

(defmacro with-array-mapped ((i array) &rest body)
  `(let ((total-size (array-total-size ,array)))
    (dotimes (,i total-size)
      ,@body)))

(defmacro do-array ((i array) &rest body)
  `(let ((total-size (array-total-size ,array)))
    (dotimes (,i total-size)
      ,@body)))

#|

(let ((arr (make-array '(3 10) :initial-element nil)))
  (with-array-mapped (i arr)
    (setf (row-major-aref arr i) 3))
  arr)

|#
