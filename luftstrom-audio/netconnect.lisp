;;;; netconnect.lisp
;;;;
;;;; Copyright (c) 2018 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>

(in-package :luftstrom-audio)

(defvar *bufin* (make-array 40000 :element-type 'single-float))
(defvar *net-in* (net:open :buffer-size (+ (* 40000 4) 100)))

(defvar *receiving* nil)

(setf *receiving* t)
(setf *receiving* nil)

(loop
   while *receiving*
   do (progn
        (cffi:with-pointer-to-vector-data (ptr *bufin*)
          (net:foreign-read *net-in* ptr (* 40000 4)))
        (format t "received!~%")))

#|
Here is an example with incudine on the same pc:
(defvar *bufin* (make-array 40000 :element-type 'single-float))
(defvar *bufout* (make-array 40000 :element-type 'single-float))

;; test
(dotimes (i 40000)
  (setf (aref *bufout* i) (random 1.0)))

(defvar *net-in* (net:open :buffer-size (+ (* 40000 4) 100)))

(defvar *net-out* (net:open :direction :output))

(cffi:with-pointer-to-vector-data (ptr *bufout*)
  (net:foreign-write *net-out* ptr (* 40000 4)))
;; => 160000

(cffi:with-pointer-to-vector-data (ptr *bufin*)
  (net:foreign-read *net-in* ptr (* 40000 4)))
;; => 160000

(every #'= *bufin* *bufout*)
;; => T

;;; Alternative: output buffer with octets.

(setf *bufout* (make-array (* 40000 4) :element-type '(unsigned-byte 8)))

;; test
(cffi:with-pointer-to-vector-data (ptr *bufout*)
  (dotimes (i 40000)
    (setf (cffi:mem-aref ptr :float i) (random 1.0))))

(net:write *net-out* *bufout*)
;; => 160000

(cffi:with-pointer-to-vector-data (ptr *bufin*)
  (net:foreign-read *net-in* ptr (* 40000 4)))
;; => 160000

(cffi:with-pointer-to-vector-data (ptr *bufout*)
  (dotimes (i 40000)
    (assert (= (aref *bufin* i) (cffi:mem-aref ptr :float i)))))

(net:close *net-out*)
(net:close *net-in*)


|#
