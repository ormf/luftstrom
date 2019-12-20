;;;; luftstrom-display.asd
;;;;
;;;; Copyright (c) 2018 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>

(asdf:defsystem #:luftstrom-display
  :description "Display part of luftstrom project"
  :author "Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-boids-gpu
               #:incudine
               #:orm-utils
               #:incudine-gui
               #:cl-collider
               #:cm-utils
               #:simple-tk
               #:cl-store)
  :components ((:file "package")
               (:file "utils")
               (:file "midictl")
               (:file "luftstrom-display")
               ;;; (:file "netconnect")
               (:file "vowel-definitions")
               (:file "cl-collider")
               (:file "params")
               (:file "params2")
               (:file "send-to-sc")
               (:file "nano-ctl")
               (:file "fudi-recv")
               (:file "config-window-gui")
               (:file "param-view-gui")
               (:file "gui-init")
               (:file "obstacles")
               (:file "cc-presets")
               (:file "presets")
               (:file "bs-presets")
               (:file "beatstep-ctl")
               (:file "osc-ctl")
               (:file "init") ;;; has to be last as the call to #'boids doesn't return!!!
               ))
