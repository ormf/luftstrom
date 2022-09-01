;;;; cl-boids-gpu.asd
;;;;
;;;; Copyright (c) 2017 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>

(asdf:defsystem #:cl-boids-gpu
  :description "Describe cl-boids-gpu here"
  :author "Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>"
  :license "licensed under the GPL v2 or later"
  :depends-on (#:cffi #:cl-opencl #:cl-opengl #:safe-queue #:cl-glut #:cl-glu #:cellctl #:orm-utils)
  :serial t
  :components ((:file "package")
               (:file "constants")
               (:file "classes")
               (:file "params")
               (:file "util")
               (:file "board")
               (:file "obstacles")
               (:file "opencl-kernel-handling")
               (:file "cl-boids-gpu")))
