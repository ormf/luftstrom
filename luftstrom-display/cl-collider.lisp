;;; 
;;; cl-coll.lisp
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

;;; 

(unless (find-package :sc-user)
  (progn
    (ql:quickload "cl-collider")
    (sleep 5)))

(in-package :sc-user)
(named-readtables:in-readtable :sc)

;; please check   *sc-synth-program*, *sc-plugin-paths*, *sc-synthdefs-path*
;; if you have different path then set to
;;
;; (setf *sc-synth-program* "/path/to/scsynth")
;; (setf *sc-plugin-paths* (list "/path/to/plugin_path" "/path/to/extension_plugin_path"))
;; (setf *sc-synthdefs-path* "/path/to/synthdefs_path")

(setf *sc-synth-program* "/usr/bin/scsynth")
(setf *sc-synthdefs-path* "~/.local/share/SuperCollider/synthdefs")
(setf *sc-plugin-paths* '())
(push "/usr/lib/SuperCollider/plugins/" *sc-plugin-paths*)
(push "/usr/share/SuperCollider/Extensions/SC3plugins/" *sc-plugin-paths*)
(setf *s* (make-external-server "localhost"
                                :port 57110
                                :just-connect-p
                                (handler-case
                                    (progn
                                      (uiop:run-program '("/usr/bin/pidof" "scsynth"))
                                      t)
                                  (uiop/run-program:subprocess-error () nil))))

#|
(read-from-string
 (with-output-to-string (out)
   (uiop:run-program '("/usr/bin/pidof" "scsynth") :output out)))
|#

(server-boot *s*)

;; in Linux, maybe you need call this function
(jack-connect)

;;; set metatdata of synth defined in supercollider:

(setf (gethash :lfo-click-2d-out sc::*synthdef-metadata*)
      (list :controls '((pitch 0.8) (amp 0.8) (dur 0.5) (suspan 0) (suswidth 0)
                        (decaystart 0.001) (decayend 0.0035) (lfofreq 10) (xpos 0.5) (ypos 0.5) (ioffs 0) (wet 1)
                        (filtfreq 20000))
            :name "lfo-click-2d-out"))

(defun randsign ()
  "return randomly 1 or -1 with equal distribution."
  (* 2 (- 0.5 (random 2))))

(defun sc-lfo-click-2d-out (&key (pitch 0.2) (amp 0.8) (dur 0.5) (suswidth 0) (suspan 0)
                              (decay-start 0.001) (decay-end 0.0035) (lfo-freq 10) (x-pos 0.5) (y-pos 0.6)
                              (ioffs 0) (wet 1) (filt-freq 20000)
                              (head :head))
  (declare (ignore head))
  (synth 'lfo-click-2d-out
         :pitch pitch
         :amp amp
         :dur dur
         :suswidth suswidth
         :suspan suspan
         :decaystart decay-start :decayend decay-end
         :lfofreq lfo-freq :xpos x-pos :ypos y-pos
         :ioffs ioffs
         :wet wet
         :filtfreq filt-freq))

(export 'SC-LFO-CLICK-2D-OUT 'sc-user)

(sc-lfo-click-2d-out :pitch 0.9 :dur 2 :decay-start 0.001 :decay-end 0.0035)

#|

(stop)
;; Quit SuperCollider server

(server-quit *s*)

(dotimes (x 350)
  (synth 'lfo-click-2d-out :amp (* (randsign) 0.01) 
         :suspan 0.5 :suswidth 0.95 :dur 30 :lfofreq (* 1000 (expt 1.1 (random 1.0)))
         :xpos (random 1.0)))

(stop)

(defun ls-lfo-click-2d-out (&key (pitch 0.8) (amp 0.8) (dur 0.5) (suswidth 0) (suspan 0)
                              (decaystart 0.001) (decayend 0.0035) (lfofreq 10) (xpos 0.5) (ypos 0.6))
  (luftstrom-audio::lfo-click-2d-out
   pitch amp dur (luftstrom-audio::gen-env suswidth suspan)
   decaystart decayend lfofreq xpos ypos :head 200))

(ls-lfo-click-2d-out)


(sc-lfo-click-2d-out :pitch 0.8 :lfofreq 0 :decaystart 10 :decayend 10 :dur 10)

(sc-lfo-click-2d-out :pitch 0.8 :lfofreq 0.01 :decaystart 1 :decayend 10 :suspan 0 :suswidth 1 :dur 10)

(let ((params '(:pitch 0.8 :lfofreq 0.01 :decaystart 10 :decayend 10 :suspan 0 :suswidth 1 :dur 10)))
  (apply #'ls-lfo-click-2d-out params))


(let ((params '(:pitch 0.8 :lfofreq 0.01 :decaystart 10 :decayend 10 :suspan 0 :suswidth 1 :dur 10)))
  (apply #'sc-lfo-click-2d-out params))

(ls-lfo-click-2d-out :pitch 0.9 :dur 2 :decaystart 0.01 :decayend 0.035)


(sc-lfo-click-2d-out :pitch 0.8 :decaystart 0.02 :decayend 0.0007 :dur 2)
(ls-lfo-click-2d-out :pitch 0.8 :decaystart 0.02 :decayend 0.0007 :dur 2)




(dotimes (n 150)
  (let ((x (random 1.0)) (y (+ 0.49 (random 0.02))))
    (ls-lfo-click-2d-out :pitch (+ 0.5 (* 0.3 y))
                      :amp 0.001
                      :dur 10
                      *env* 0.001 0.02 (* 500 (expt 3.01 y)) x y)))

(dotimes (n 150)
  (let ((x (random 1.0)) (y (+ 0.49 (random 0.02))))
    (luftstrom-audio::lfo-click-2d-out (+ 0.5 (* 0.3 y))
                      0.001
                      10
                      (luftstrom-audio::gen-env 0.9 0.5) 0.001 0.02 (* 500 (expt 3.01 y)) x y)))

(dotimes (n 150)
  (let ((x (random 1.0)) (y (+ 0.49 (random 0.02))))
    (ls-lfo-click-2d-out
     :pitch (+ 0.5 (* 0.3 y))
     :amp 0.001
     :dur 10
     :suswidth 0.9
     :suspan 0.5
     :decaystart 0.001
     :decayend 0.02
     :lfofreq (* 500 (expt 3.01 y))
     :xpos x
     :ypos y)))

(defparameter *env* (luftstrom-audio::gen-env 0.9 0.5))

(dotimes (n 100)
  (let ((x (random 1.0)) (y (+ 0.49 (random 0.02))))
    (luftstrom-audio::lfo-click-2d-out
     :pitch (+ 0.5 (* 0.3 y))
     :amp 0.001
     :dur 10
     :env *env*
     :decaystart 0.001
     :decayend 0.02
     :lfofreq (* 500 (expt 3.01 y))
     :xpos x
     :ypos y)))

(dotimes (n 500)
  (let ((x (random 1.0)) (y (+ 0.49 (random 0.02))))
    (sc-lfo-click-2d-out
     :pitch (+ 0.5 (* 0.3 y))
     :amp 0.002
     :dur 10
     :suswidth 0.9
     :suspan 0.5
     :decaystart 0.001
     :decayend 0.02
     :lfofreq (* 500 (expt 3.01 y))
     :xpos x
     :ypos y)))


(stop)

(let ((pitch 0.8) (amp 0.8) (dur 10) (suspan 0) (suswidth 0)
      (decaystart 10) (decayend 10) (lfofreq 0.01) (xpos 0.5) (ypos 0.6))
  (luftstrom-audio::lfo-click-2d-out
   pitch amp dur (luftstrom-audio::gen-env suswidth suspan)
   decaystart decayend lfofreq xpos ypos :head 200))


(luftstrom-audio::gen-env 0 1)

(defun gen-env (suswidth suspan)
  (make-envelope '(0 1 1 0)
                 (list (* suspan (- 1 suswidth))
                       suswidth
                       (* (- 1 suspan) (- 1 suswidth))) :curve :cubic))

;;; stop all synths (&optional (group 1)):
(stop)

;; Quit SuperCollider server

(server-quit *s*)

|#
