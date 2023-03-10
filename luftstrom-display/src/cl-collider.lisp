;;; 
;;; cl-collider.lisp
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

(unless (find-package :sc)
  (progn
    (ql:quickload "cl-collider")
    (sleep 5)))

(in-package :sc)
(named-readtables:in-readtable :sc)

;; please check   *sc-synth-program*, *sc-plugin-paths*, *sc-synthdefs-path*
;; if you have different path then set to
;;
;; (setf *sc-synth-program* "/path/to/scsynth")
;; (setf *sc-plugin-paths* (list "/path/to/plugin_path" "/path/to/extension_plugin_path"))
;; (setf *sc-synthdefs-path* "/path/to/synthdefs_path")

(defun buffer-set-list (buffer data)
  (multiple-value-bind (repeat rest-message-len)
      (floor (length data) 1024)
    (let ((server (sc::server buffer)))
      (dotimes (i repeat)
	(let ((msg (subseq data (* i 1024) (+ (* i 1024) 1024))))
	  (apply #'send-message server (append (list "/b_setn" (bufnum buffer) (* i 1024) 1024) msg))))
      (unless (zerop rest-message-len)
	(let ((msg (subseq data (* repeat 1024) (+ (* repeat 1024) rest-message-len))))
	  (apply #'send-message server (append (list "/b_setn" (bufnum buffer) (* repeat 1024) rest-message-len) msg)))))
    (sync (sc::server buffer))
    buffer))

(in-package :sc-user)

(setf *sc-synth-program* "/usr/bin/scsynth")
(setf *sc-synthdefs-path* "~/.local/share/SuperCollider/synthdefs")
(setf *sc-plugin-paths* '())
(push "/usr/lib/SuperCollider/plugins/" *sc-plugin-paths*)
(push "/usr/share/SuperCollider/Extensions/SC3plugins/" *sc-plugin-paths*)
(defparameter *num-sc-instances* 4)
(defparameter *servers* nil)

(uiop:run-program '("/usr/bin/killall" "-9" "scsynth") :ignore-error-status t)
(sleep 1)
(setf *servers*
      (loop repeat *num-sc-instances*
            for port = 57110 then (+ port 10)
            collect (make-external-server "localhost"
                                          :port port
                                          :server-options (make-server-options
                                                           :num-control-bus (expt 2 16))
                                          :just-connect-p
                                          (if (= port 57110)
                                              (handler-case
                                                  (progn
                                                    (uiop:run-program '("/usr/bin/pidof" "scsynth"))
                                                    t)
                                                (uiop/run-program:subprocess-error () nil))))))
(map nil (lambda (s) (server-boot s)) *servers*)

;;; closure returning next server by cdring through server list

(let (server)
  (defun next-server ()
    (setf server (if (rest server) (rest server) *servers*))
    (first server)))

;;; (next-server)

(in-package :sc)

(defun stop (&optional (group 1) &rest groups)
  (dolist (*s* sc-user::*servers*)
    (sched-clear (scheduler *s*))
    (tempo-clock-clear (tempo-clock *s*))
    (dolist (group (cons group groups))
      (send-message *s* "/g_freeAll" group)
      (send-message *s* "/clearSched"))
    (dolist (hook *stop-hook*)
      (funcall hook))))
#|
(defmacro with-node ((node id server) &body body)
  `(let ((,id (etypecase ,node
		(number ,node)
		(node (id ,node))
		(keyword (alexandria:when-let ((node (gethash ,node (node-proxy-table *s*))))
			   (id node)))))
	 (,server (if (typep ,node 'node) (server ,node) *s*)))
     (when ,id
       ,@body)))
|#

(defun synth (name &rest args)
  "Start a synth by name."
  (let* ((*s* (sc-user::next-server))
         (name-string (cond ((stringp name) name) (t (string-downcase (symbol-name name)))))
         (next-id (or (getf args :id) (get-next-id *s*)))
         (to (or (getf args :to) 1))
         (pos (or (getf args :pos) :head))
         (new-synth (make-instance 'node :server *s* :id next-id :name name-string :pos pos :to to))
         (parameter-names (mapcar (lambda (param) (string-downcase (car param))) (getf (get-synthdef-metadata name) :controls)))
         (args (loop :for (arg val) :on args :by #'cddr
		  :for pos = (position (string-downcase arg) parameter-names :test #'string-equal)
		  :unless (null pos)
                    :append (list (string-downcase (nth pos parameter-names)) val))))
    (message-distribute new-synth
                        (apply #'make-synth-msg *s* name-string next-id to pos args)
                        *s*)))

#|
(read-from-string
 (with-output-to-string (out)
   (uiop:run-program '("/usr/bin/pidof" "scsynth") :output out)))
|#


(in-package :sc-user)

;;; (server-quit *s*)

;; in Linux, maybe you need call this function
;;; (jack-connect)

;;; set metatdata of synth defined in supercollider:

(defparameter *filter-buffers* (loop for s in *servers* collect (buffer-alloc 1024 :server s)))
(defparameter *sc-filter-bufnum* (slot-value (first *filter-buffers*) 'bufnum))
 
#|
(defparameter *ctl-bus-x* (bus-control :chanls 20000 :busnum 1000))
(defparameter *ctl-bus-y* (bus-control :chanls 20000 :busnum 21000))
|#

(setf (gethash :lfo-click-2d-out sc::*synthdef-metadata*)
      (list :controls '((pitch 0.8) (amp 0.8) (dur 0.5) (suspan 0) (suswidth 0)
                        (decay-start 0.001) (decay-end 0.0035) (lfo-freq 10)
                        (x-pos 0.5) (y-pos 0.5) (i-offs 0) (wet 1)
                        (filtfreq 20000))
            :name "lfo-click-2d-out"))

(setf (gethash :lfo-click-2d-bpf-out sc::*synthdef-metadata*)
      (list :controls '((pitch 0.8) (amp 0.8) (dur 0.5) (suspan 0) (suswidth 0)
                        (decaystart 0.001) (decayend 0.0035) (lfofreq 10)
                        (xpos 0.5) (ypos 0.5) (ioffs 0) (wet 1)
                        (filtfreq 20000) (bpfreq 500) (bprq 100))
            :name "lfo-click-2d-bpf-out"))

(setf (gethash :lfo-click-2d-bpf-4ch-out sc::*synthdef-metadata*)
      (list :controls '((pitch 0.8) (amp 0.8) (dur 0.5) (suspan 0) (suswidth 0)
                        (decaystart 0.001) (decayend 0.0035) (lfofreq 10)
                        (xpos 0.5) (ypos 0.5) (ioffs 0) (wet 1)
                        (filtfreq 20000) (bpfreq 500) (bprq 100))
            :name "lfo-click-2d-bpf-4ch-out"))

(setf (gethash :lfo-click-2d-bpf-vow-out sc::*synthdef-metadata*)
      (list :controls `((pitch 0.8) (amp 0.8) (dur 0.5) (suspan 0) (suswidth 0)
                        (decaystart 0.001) (decayend 0.0035) (lfofreq 10)
                        (xpos 0.5) (ypos 0.5) (ioffs 0) (wet 1)
                        (filtfreq 20000) (bpfreq 10000) (bprq 100)
                        (voicepan 0) (voicetype 0) (vowel 0)
                        (vowelbuf ,*sc-filter-bufnum*))
            :name "lfo-click-2d-bpf-vow-out"))

(setf (gethash :lfo-click-2d-bpf-4ch-vow-out sc::*synthdef-metadata*)
      (list :controls `((pitch 0.8) (amp 0.8) (dur 0.5) (suspan 0) (suswidth 0)
                                    (decaystart 0.001) (decayend 0.0035) (lfofreq 10)
                                    (xpos 0.5) (ypos 0.5) (ioffs 0) (wet 1)
                                    (filtfreq 20000) (bpfreq 10000) (bprq 100) (bppan 0)
                                    (voicepan 0) (vowel 0) (vwlinterp 0) (voicetype 0)
                                    (vowelbuf ,*sc-filter-bufnum*))
            :name "lfo-click-2d-bpf-4ch-vow-out"))

(defun randsign ()
  "return randomly 1 or -1 with equal distribution."
  (* 2 (- 0.5 (random 2))))

(defun sc-lfo-click-2d-out (&key (pitch 0.2) (amp 0.8) (dur 0.5) (suswidth 0) (suspan 0)
                              (decay-start 0.001) (decay-end 0.0035) (lfo-freq 10)
                              (x-pos 0.5) (y-pos 0.6)
                              (i-offs 0) (wet 1) (filt-freq 20000)
                              (head :head))
  (declare (ignore head))
  (synth 'lfo-click-2d-out
         :pitch pitch
         :amp amp
         :dur dur
         :suswidth suswidth
         :suspan suspan
         :decay-start decay-start :decay-end decay-end
         :lfo-freq lfo-freq :x-pos x-pos :y-pos y-pos
         :i-offs i-offs
         :wet wet
         :filt-freq filt-freq))

(defun sc-lfo-click-2d-bpf-out (&key (pitch 0.2) (amp 0.8) (dur 0.5) (suswidth 0) (suspan 0)
                                  (decaystart 0.001) (decayend 0.0035) (lfofreq 10)
                                  (xpos 0.5) (ypos 0.6)
                                  (ioffs 0) (wet 1) (filtfreq 20000)
                                  (bpfreq 500) (bprq 100)
                                  (head :head))
  (declare (ignore head))
  (synth 'lfo-click-2d-bpf-out
         :pitch pitch
         :amp amp
         :dur dur
         :suswidth suswidth
         :suspan suspan
         :decaystart decaystart
         :decayend decayend
         :lfofreq lfofreq :xpos xpos :ypos ypos
         :ioffs ioffs
         :wet wet
         :filtfreq filtfreq
         :bpfreq bpfreq
         :bprq bprq))

(defun sc-lfo-click-2d-bpf-4ch-out (&key (pitch 0.2) (amp 0.8) (dur 0.5) (suswidth 0) (suspan 0)
                                  (decaystart 0.001) (decayend 0.0035) (lfofreq 10)
                                  (xpos 0.5) (ypos 0.6)
                                  (ioffs 0) (wet 1) (filtfreq 20000)
                                  (bpfreq 500) (bprq 100)
                                      (head :head))
  (declare (ignore head))
  (synth 'lfo-click-2d-bpf-4ch-out
         :pitch pitch
         :amp amp
         :dur dur
         :suswidth suswidth
         :suspan suspan
         :decaystart decaystart :decayend decayend
         :lfofreq lfofreq :xpos xpos :ypos ypos
         :ioffs ioffs
         :wet wet
         :filtfreq filtfreq
         :bpfreq bpfreq
         :bprq bprq))

(defun sc-lfo-click-2d-bpf-vow-out (&key (pitch 0.2) (amp 0.8) (dur 0.5) (suswidth 0) (suspan 0)
                                      (decaystart 0.001) (decayend 0.0035) (lfofreq 10)
                                      (xpos 0.5) (ypos 0.6)
                                      (ioffs 0) (wet 1) (filtfreq 20000)
                                      (bpfreq 500) (bprq 100) (voicetype 0) (vcinterp 0) (voicepan 0) (vowel 0)
                                      (vowelbuf *sc-filter-bufnum*)
                                      (head :head))
  (declare (ignore head))
  (synth 'lfo-click-2d-bpf-vow-out
         :pitch pitch
         :amp amp
         :dur dur
         :suswidth suswidth
         :suspan suspan
         :decaystart decaystart
         :decayend decayend
         :lfofreq lfofreq :xpos xpos :ypos ypos
         :ioffs ioffs
         :wet wet
         :filtfreq filtfreq
         :bpfreq bpfreq
         :bprq bprq
         :voicetype voicetype
         :vcinterp vcinterp
         :voicepan voicepan
         :vowel vowel
         :vowelbuf vowelbuf))

(defun sc-lfo-click-2d-bpf-4ch-vow-out
    (&key (pitch 0.2) (amp 0.8) (dur 0.5) (suswidth 0) (suspan 0)
       (decaystart 0.001) (decayend 0.0035) (lfofreq 10)
       (xpos 0.5) (ypos 0.6)
       (ioffs 0) (wet 1) (filtfreq 20000)
       (bpfreq 500) (bprq 100) (bppan 1)
       (voicepan 0) (vowel 0) (vwlinterp 0) (voicetype 0)
       (vowelbuf *sc-filter-bufnum*)
       (head :head))
  (declare (ignore head))
  (synth 'lfo-click-2d-bpf-4ch-vow-out
         :pitch pitch
         :amp amp
         :dur dur
         :suswidth suswidth
         :suspan suspan
         :decaystart decaystart
         :decayend decayend
         :lfofreq lfofreq :xpos xpos :ypos ypos
         :ioffs ioffs
         :wet wet
         :filtfreq filtfreq
         :bpfreq bpfreq
         :bprq bprq
         :bppan bppan
         :vowel vowel
         :vwlinterp vwlinterp
         :voicetype voicetype
         :voicepan voicepan
         :vowelbuf vowelbuf))

(defun db->amp (db)
  (expt 10 (/ db 20)))

#|
(buffer-set-list
 *filter-buffer*
 (loop for (voice defs) on *vowel-definitions* by #'cddr
       append (loop for (vowel vdefs) on defs by #'cddr
                    append (loop for set on vdefs
                            append (mapcar (lambda (def) (getf def :freq)) vdefs)
                            (mapcar (lambda (def) (getf def :rq)) vdefs)
                            (mapcar (lambda (def) (getf def :ampdb)) vdefs)))))
|#

;;; load the vowel definitions in the following form:
;;;
;;; bass: freqfmt1(u), freqfmt1(o), freqfmt1(a), freqfmt1(e), freqfmt1(i),
;;;       rqfmt1(u), rqfmt1(o), rqfmt1(a), rqfmt1(e), rqfmt1(i),
;;;       ampfmt1(u), ampfmt1(o), ampfmt1(a), ampfmt1(e), ampfmt1(i),
;;;       freqfmt2(u), freqfmt2(o), freqfmt2(a), freqfmt2(e), freqfmt2(i),
;;;       rqfmt2(u), rqfmt2(o), rqfmt2(a), rqfmt2(e), rqfmt2(i),
;;;       ampfmt2(u), ampfmt2(o), ampfmt2(a), ampfmt2(e), ampfmt2(i),
;;;
;;;       ...
;;;
;;;       freqfmt5(u), freqfmt5(o), freqfmt5(a), freqfmt5(e), freqfmt5(i),
;;;       rqfmt5(u), rqfmt5(o), rqfmt5(a), rqfmt5(e), rqfmt5(i),
;;;       ampfmt5(u), ampfmt5(o), ampfmt5(a), ampfmt5(e), ampfmt5(i),
;;;
;;; tenor: freqfmt1(u), freqfmt1(o), freqfmt1(a), freqfmt1(e), freqfmt1(i),
;;;       rqfmt1(u), rqfmt1(o), rqfmt1(a), rqfmt1(e), rqfmt1(i),
;;;       ampfmt1(u), ampfmt1(o), ampfmt1(a), ampfmt1(e), ampfmt1(i),
;;;       freqfmt2(u), freqfmt2(o), freqfmt2(a), freqfmt2(e), freqfmt2(i),
;;;       rqfmt2(u), rqfmt2(o), rqfmt2(a), rqfmt2(e), rqfmt2(i),
;;;       ampfmt2(u), ampfmt2(o), ampfmt2(a), ampfmt2(e), ampfmt2(i),
;;;
;;;       ...
;;;
;;;       freqfmt5(u), freqfmt5(o), freqfmt5(a), freqfmt5(e), freqfmt5(i),
;;;       rqfmt5(u), rqfmt5(o), rqfmt5(a), rqfmt5(e), rqfmt5(i),
;;;       ampfmt5(u), ampfmt5(o), ampfmt5(a), ampfmt5(e), ampfmt5(i),
;;;
;;;       (etc. bis soprano fmt5)

;;; This form already allows for direct linear interpolation between
;;; the vowels (a..u) for any param/format of a voice type.

(loop for filter-buffer in *filter-buffers*
      do (buffer-set-list
          filter-buffer
          (loop
            for voice in '(:bass :tenor :countertenor :alto :soprano)
            append
            (loop
              for idx below 5
              append (loop
                       for prop in '(:freq :rq :ampdb)
                       append (loop for vowel in '(:u :o :a :e :i)
                                    collect (let ((val (getf
                                                        (elt
                                                         (getf
                                                          (getf *vowel-definitions* voice)
                                                          vowel)
                                                         idx)
                                                        prop)))
                                              (if (eq prop :ampdb) (float (db->amp val)) val))))))))

;;; (buffer-get (elt *filter-buffers* 0) 5)
#|

bass-u-freq1 bass-o-freq1 ... bass-i-freq1 
bass-u-rq1 bass-o-rq1 ... bass-i-rq1 
bass-u-ampdb1 bass-u-rq1 ... bass-u-rq1 

bass-u-freq2 bass-o-freq2 ... bass-i-freq2 
bass-u-rq2 bass-o-rq2 ... bass-i-rq2 
bass-u-ampdb2 bass-u-rq2 ... bass-u-rq2 

...

bass-u-freq5 bass-o-freq5 ... bass-i-freq5 
bass-u-rq5 bass-o-rq5 ... bass-i-rq5 
bass-u-ampdb5 bass-u-rq5 ... bass-u-rq5 



tenor-u-freq1 tenor-o-freq1 ... tenor-i-freq1 
tenor-u-rq1 tenor-o-rq1 ... tenor-i-rq1 
tenor-u-ampdb1 tenor-u-rq1 ... tenor-u-rq1 

tenor-u-freq2 tenor-o-freq2 ... tenor-i-freq2 
tenor-u-rq2 tenor-o-rq2 ... tenor-i-rq2 
tenor-u-ampdb2 tenor-u-rq2 ... tenor-u-rq2 

...

tenor-u-freq5 tenor-o-freq5 ... tenor-i-freq5 
tenor-u-rq5 tenor-o-rq5 ... tenor-i-rq5 
tenor-u-ampdb5 tenor-u-rq5 ... tenor-u-rq5 





|#




(export 'SC-LFO-CLICK-2D-OUT 'sc-user)
(export 'SC-LFO-CLICK-2D-BPF-OUT 'sc-user)
(export 'SC-LFO-CLICK-2D-BPF-4CH-OUT 'sc-user)
(export 'SC-LFO-CLICK-2D-BPF-VOW-OUT 'sc-user)
(export 'SC-LFO-CLICK-2D-BPF-4CH-VOW-OUT 'sc-user)

;;; (sc-lfo-click-2d-out :pitch 0.9 :dur 2 :decay-start 0.001 :decay-end 0.0035)
;;; (sc-lfo-click-2d-bpf-out :pitch 0.9 :dur 2 :decay-start 0.001 :decay-end 0.0035)
;;; (sc-lfo-click-2d-bpf-4ch-out :pitch 0.9 :dur 0.1 :lfo-freq 0.1 :decay-start 0.001 :decay-end 0.0035 :x-pos 1 :y-pos 0)

;;; (apply #'sc-user::sc-lfo-click-2d-bpf-4ch-out :server (first *servers*) '(:pitch 0.9 :dur 2 :lfofreq 10 :decaystart 0.001 :amp 4 :decayend 0.0035 :xpos 0))

(apply #'sc-user::sc-lfo-click-2d-bpf-4ch-vow-out '(:pitch 0.9 :xpos 0.5 :dur 3))
;;; (apply #'sc-user::sc-lfo-click-2d-bpf-vow-out :server (first *servers*) '(:pitch 0.9 :dur 3))

(sc-user::sc-lfo-click-2d-bpf-4ch-vow-out
        :amp 1
        :dur 13
        :lfofreq 1
        :wet 1
        :voicetype 0.4
        :vowel -0.2
        :head 200)




#|
(apply #'sc-user::sc-lfo-click-2d-bpf-out '(:pitch 0.7152962 :amp 0.0 :dur 0.01 :suswidth 0 :suspan 0 :decay-start 5.0e-4
                                            :decay-end 0.002 :lfo-freq 79.56419 :x-pos 0.039156392 :y-pos 0.5851811 :wet 1
                                            :filt-freq 20000 :bp-freq 500 :bp-rq 1 :head 200))

;;; (setf *start* 0)

(let ((vowel (setf *start* (mod (+ 0.2 *start*) 1)))
      (voice-type (random 5)))
  (sc-lfo-click-2d-bpf-vow-out
   :pitch 0.5 :dur 2 :lfo-freq 10
   :decay-start 0.001 :decay-end 0.0035
   :wet 1
   :amp 8
   :voice-type 4
   :vowel (clip vowel 0 4) :amp 2))

(defparameter *start* -0.05)

(let ((vowel (setf *start* (mod (+ 0.05 *start*) 1)))
      (voicetype (random 5)))
  (sc-lfo-click-2d-bpf-vow-out
   :pitch 0.5 :dur 1 :lfo-freq 5
   :decay-start 0.001 :decay-end 0.0035
   :wet 1
   :voicetype voicetype
   :vowel (clip vowel 0 4) :amp 2))

(loop for time from 0 by 0.5
      for vowel in '(0 1 2 3 4)
      do (at (+ (now) time)
           #'sc-lfo-click-2d-bpf-vow-out
           :pitch 0.9 :dur 2 :lfo-freq 30
           :decay-start 0.001 :decay-end 0.0035
           :vowel vowel :amp 2))



(let ((voicepan 0)
      (vowel 0)
      (voicetype 1))
  (loop for idx in (list (+ (* 75 voicetype) vowel)
                         (+ (* 75 voicetype) vowel 5)
                         (+ (* 75 voicetype) vowel 10))
        collect (buffer-get *filter-buffer* idx))

  )
	sig1 = ((1-voicepan) * BPF.ar(sig, IndexL.kr(vowelbuf,75*voicetype+vowel),
	 	IndexL.kr(vowelbuf,75*voicetype+5+vowel),
	 	IndexL.kr(vowelbuf,75*voicetype+10+vowel)) +
		(voicepan *  BPF.ar(sig, IndexL.kr(vowelbuf,(75*(1+voicetype)+vowel)),
			IndexL.kr(vowelbuf,(75*(1+voicetype))+5+vowel),
			IndexL.kr(vowelbuf,(75*(1+voicetype))+10+vowel))));	
	sig2 = ((1-voicepan) * BPF.ar(sig, IndexL.kr(vowelbuf,75*voicetype+15+vowel),
		IndexL.kr(vowelbuf,75*voicetype+20+vowel),
		IndexL.kr(vowelbuf,75*voicetype+25+vowel))) +
	(voicepan *  BPF.ar(sig, IndexL.kr(vowelbuf,(75*(1+voicetype))+15+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+20+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+25+vowel)));

	sig3 = ((1-voicepan) * BPF.ar(sig, IndexL.kr(vowelbuf,75*voicetype+30+vowel),
		IndexL.kr(vowelbuf,75*voicetype+35+vowel),
		IndexL.kr(vowelbuf,75*voicetype+40+vowel))) +
	(voicepan *  BPF.ar(sig, IndexL.kr(vowelbuf,(75*(1+voicetype))+30+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+35+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+40+vowel)));

	sig4 = ((1-voicepan) * BPF.ar(sig, IndexL.kr(vowelbuf,75*voicetype+45+vowel),
		IndexL.kr(vowelbuf,75*voicetype+50+vowel),
		IndexL.kr(vowelbuf,75*voicetype+55+vowel))) +
	(voicepan *  BPF.ar(sig, IndexL.kr(vowelbuf,(75*(1+voicetype))+45+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+50+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+55+vowel)));

	sig5 = ((1-voicepan) * BPF.ar(sig, IndexL.kr(vowelbuf,75*voicetype+60+vowel),
		IndexL.kr(vowelbuf,75*voicetype+65+vowel),
		IndexL.kr(vowelbuf,75*voicetype+70+vowel))) +
	(voicepan *  BPF.ar(sig, IndexL.kr(vowelbuf,(75*(1+voicetype))+60+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+65+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+70+vowel)));

(db->amp -22)
 (loop for (voice defs) on *vowel-definitions* by #'cddr
       append (loop for (vowel vdefs) on defs by #'cddr
                    append (append
                            (mapcar (lambda (def) (getf def :freq)) vdefs)
                            (mapcar (lambda (def) (getf def :rq)) vdefs)
                            (mapcar (lambda (def) (getf def :ampdb)) vdefs))))

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
