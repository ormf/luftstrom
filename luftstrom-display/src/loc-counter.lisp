;;; 
;;; loc-counter.lisp
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

(sb-posix:chdir "/home/orm/work/kompositionen/luftstrom/lisp/luftstrom/luftstrom-display/")

(apply #'+
       (loop for (key name) in
             '((:file "package")
               (:file "luftstrom-display")
;;; (:file "netconnect")
               (:file "cl-collider")
               (:file "send-to-sc")
               (:file "midictl")
               (:file "params")
               (:file "params2")
               (:file "param-view-gui")
               (:file "gui-init")
               (:file "obstacles")
               (:file "presets")
               (:file "init"))
             collect (count-loc (format nil "~a.lisp" name))))

;;; 1418 !!!!

(sb-posix:chdir "/home/orm/work/programmieren/lisp/cl-boids-gpu/")

(apply #'+
       (loop for (key name) in
             '((:file "package")
               (:file "constants")
               (:file "params")
               (:file "classes")
               (:file "util")
               (:file "board")
               (:file "obstacles")
               (:file "opencl-kernel-handling")
               (:file "cl-boids-gpu"))
             collect (count-loc (format nil "/home/orm/work/programmieren/lisp/cl-boids-gpu/~a.lisp" name))))

;;; 1201 !!!


(defun block-comment-start (line)
  (let ((stripped-line (string-left-trim '(#\Space #\Tab #\Newline) line)))
    (and (> (length stripped-line) 1)
         (string= (subseq stripped-line 0 2) "#|"))))

(defun block-comment-end (line)
  (let ((stripped-line (string-left-trim '(#\Space #\Tab #\Newline) line)))
    (and (> (length stripped-line) 1)
         (string= (subseq stripped-line 0 2) "|#"))))

;;;(block-comment-start "   #|")

(defun skip-to-end-of-block-comment (in)
  (loop
    for line = (read-line in nil nil)
    while line
    until (block-comment-end line)))

(defun loc-value (line)
  (let ((stripped-line (string-left-trim '(#\Space #\Tab #\Newline) line)))
    (cond
      ((string= stripped-line "") 0)
      ((eq (aref stripped-line 0) #\;) 0)
      (:else 1))))

(defun count-loc (file)
  (with-open-file (in file)
    (loop
      with line-count = 0
      for line = (read-line in nil nil)
      while line
      do (if (block-comment-start line)
             (skip-to-end-of-block-comment in)
             (incf line-count (loc-value line)))
      finally (return line-count))))

;;; (count-loc "cl-collider.lisp")

