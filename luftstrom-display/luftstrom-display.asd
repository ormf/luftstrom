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
               #:simple-tk)
  :components ((:file "package")
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
               (:file "init")
               ))
