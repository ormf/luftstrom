;;;; luftstrom-display.asd
;;;;
;;;; Copyright (c) 2018-22 Orm Finnendahl
;;;; <orm.finnendahl@selma.hfmdk-frankfurt.de>

(unless (find-package :cl-opencl) (ql:quickload "cl-opencl"))

(use-package :cl-opencl)

(defun get-platform-ids ()
     "returns a list of available OpenCL Platform IDs (opaque, don't need to be
manually released)"
     ;; fixme: figure out if returning same pointer twice is correct,
     ;; possibly remove-duplicates on it if so?
     (cl-opencl::without-fp-traps
       (cl-opencl::get-counted-list %cl:get-platform-ids () '%cl:platform-id)))

(defun ensure-platform ()
  "ensure that platform with gl sharing exists and return it."
  (or (loop for platform in (get-platform-ids)
            if (loop for device in (get-device-ids platform :all)
                     if (or (member :gpu (get-device-info device :type))
                            (device-extension-present-p device "cl_APPLE_gl_sharing")
                            (device-extension-present-p device "cl_khr_gl_sharing"))
                       return t)
              return platform)
      (error "no openCL platform with cl_khr_gl_sharing found")))

(let* ((platform (ensure-platform))
       (vendor  (get-platform-info platform :vendor))
       (version  (get-platform-info platform :version)))
  (cond
    ((string= vendor "Advanced Micro Devices, Inc.")
     (push :opencl-amd-rocm *features*))
    ((string= (subseq version 0 22) "OpenCL 2.0 beignet 1.4")
     (push :opencl-intel-beignet *features*))
    (t (error "No supported opencl platform detected!"))))

(asdf:defsystem #:luftstrom-display
  :description "Display part of luftstrom project"
  :author "Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de"
  :license  "GPL 2.0 or later"
  :version "0.0.2"
  :serial t
  :depends-on (#:cffi #:cl-opencl #:cl-opengl #:safe-queue #:cl-glut #:cl-glu #:cellctl #:orm-utils
               #:alexandria
;;;               #:cl-boids-gpu
               #:incudine
               #:orm-utils
               #:incudine-gui
               #:cl-collider
               #:cm-utils
               #:simple-tk
               #:cl-store)
  :components ((:module "cl-boids-gpu"
                :description "gl and cl specific core code for the boids"
                :depends-on ()
                :serial t
                :components ((:file "package")
;;;                             (:file "constants" :depends-on ("package"))
                             (:file "constants")
                             (:file "classes-amd-rocm" :if-feature :opencl-amd-rocm)
                             (:file "classes-intel-beignet" :if-feature :opencl-intel-beignet)
                             (:file "classes")
                             (:file "params")
                             (:file "util")
                             (:file "board")
                             (:file "obstacles")
                             (:file "opencl-kernel-handling")
                             (:file "cl-boids-gpu")
                             (:file "cl-boids-gpu-amd-rocm" :if-feature :opencl-amd-rocm)
                             (:file "cl-boids-gpu-intel-beignet" :if-feature :opencl-intel-beignet)))
               (:module "src"
                :description "luftstrom-display code for the boids"
                :depends-on (#:cl-boids-gpu)
                :serial t
                :components ((:file "package")
                             (:file "utils")
                             (:file "midictl")
                             (:file "osc-ctl")
                             (:file "luftstrom-display-amd-rocm" :if-feature :opencl-amd-rocm)
                             (:file "luftstrom-display-intel-beignet" :if-feature :opencl-intel-beignet)
;;; (:file "netconnect")
                             (:file "luftstrom-display")
                             (:file "vowel-definitions")
                             (:file "cl-collider")
                             (:file "params")
                             (:file "send-to-sc")
                             (:file "nano-ctl")
                             (:file "keyboard")
                             (:file "ewi-ctl")
                             (:file "fudi-recv")
                             (:file "config-window-gui")
                             (:file "param-view-gui")
                             (:file "param-view-ctl")
                             (:file "gui-init")
                             (:file "obstacles")
                             (:file "cc-presets")
                             (:file "presets")
                             (:file "bs-presets")
                             (:file "beatstep-ctl")
                             (:file "obstacle-ctl-tablet")
                             (:file "one-player-ctl-tablet")
                             (:file "joystick-tablet")
                             (:file "rocm" :if-feature :opencl-amd-rocm)
                             (:file "beignet" :if-feature :opencl-intel-beignet)
                             (:file "init") ;;; has to be last as the call to #'boids doesn't return!!!
                             ))))

