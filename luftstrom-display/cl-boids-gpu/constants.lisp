;;;; constants.lisp
;;;;
;;;; Copyright (c) 2017 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
;;;; boid system using OpenCL and OpenGL

(in-package :cl-boids-gpu)

(eval-when (:compile-toplevel)
  (defconstant +red+ '(1.0 0.0 0.0 1.0))
  (defconstant +float3-octets+ (* 3 4))
  (defconstant +float4-octets+ (* 4 4))
  (defconstant +twopi+ (* 2 pi)))

(unless (boundp '+red+)
  (defconstant +red+ '(1.0 0.0 0.0 1.0)))

(unless (boundp '+red+)
  (defconstant +float3-octets+ (* 3 4)))

(unless (boundp '+float4-octets+)
  (defconstant +float4-octets+ (* 4 4)))

(unless (boundp '+float-octets+)
  (defconstant +float-octets+ 4))

(unless (boundp '+twopi+)
  (defconstant +twopi+ (* 2 pi)))
