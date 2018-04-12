;;;; package.lisp
;;;;
;;;; Copyright (c) 2018 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>

(defpackage #:luftstrom-audio
  (:shadowing-import-from #:cm
                          :at :now :tuning :*tempo* :play :rescale-envelope :quantize :stop :group :range
                          :midi-note-on :midi-note-off :midi-pitch-bend
                          :midi-note
                          :line)
  (:use #:cl #:incudine #:incudine.vug #:incudine.util #:cm #:cm-utils))

