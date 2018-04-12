;;;; luftstrom-audio.asd
;;;;
;;;; Copyright (c) 2018 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>

(asdf:defsystem #:luftstrom-audio
  :description "Describe luftstrom here"
  :author "Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>"
  :license "licensed under the GPL v2 or later"
  :serial t
  :depends-on (#:cm-incudine
               #:cm-utils
               #:incudine-gui)
  :components ((:file "package")
               (:file "luftstrom-audio")
;;               (:file "qt-gui")
;;               (:file "nanokontrol")
               ))

