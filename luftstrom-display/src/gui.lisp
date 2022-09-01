;;; 
;;; gui.lisp
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

(in-package :luftstrom-display)

(let ((row 0) (column 3))
  (qt:emit-signal (aref (cuda-gui::param-boxes (cuda-gui::find-gui "pv1")) (+ (* row 5) column))
               "setLabel(QString)" "*sepmult*"))

(set-receiver!
 (lambda (st d1 d2)
   (case (status->opcode st)
     (:cc (let ((ch (status->channel st)))
            (if (< ch 2)
                (let ((row d1) (column 0))
                  (qt:emit-signal
                   (aref (cuda-gui::param-boxes (cuda-gui::find-gui "pv1"))
                         (+ (* row 5) column))
                   "setText(QString)" (format nil "~d" d2))))))))
 *midi-in1*
 :format :raw)


(defun main ()
  (with-tk-root (root)
    (setf (window-title root) "Example 1")
    (setf (window-geometry root) "300x100+100+200")

    (let ((f (frame :parent root)))

      (pack f :expand t :fill "both")
      
      (pack (button :parent f
                    :text "Quit"
                    :command (lambda ()
                               (window-destroy root)))
            :expand t))))

(defun main ()
  (with-tk-root (root)
    (setf (window-title root) "Variables")
    (setf (window-geometry root) "300x200+200+200")
    (let ((f (frame :parent root))
          (cb-var (string-var))
          (l-var (string-var)))
      (pack f :expand t :fill "both")

      (pack (checkbutton :parent f
                         :text "Checkbox"
                         :variable cb-var
                         :onvalue "enabled"
                         :offvalue "disabled"
                         :command (lambda ()
                                    (setf (var-value l-var)
                                          (format nil "Checkbox is ~a." (var-value cb-var)))))
            :padx 2 :pady 2)

      (pack (label :parent f
                   :textvariable l-var)
            :padx 2 :pady 2)

      (setf (var-value cb-var) "enabled")
      (setf (var-value l-var) "Checkbox is enabled."))))



(main)

(defun main (&key (port 3100))
  (let ((fudi-rcv (fudi:open :port port :direction :input)))
    (unwind-protect
         (with-tk-root (root)
           (setf (window-title root) "Variables")
           (setf (window-geometry root) "300x200+200+200")
           (let ((f (frame :parent root))
                 (cb-var (string-var))
                 (l-var (string-var)))
             (pack f :expand t :fill "both")
             (set-receiver!
              (lambda (args)
                (format t "~&received: ~d~%" (first args))
                (format t "~&l-var: ~a~%" (var-value l-var)))
              fudi-rcv)
             (pack (checkbutton :parent f
                                :text "Checkbox"
                                :variable cb-var
                                :onvalue "enabled"
                                :offvalue "disabled"
                                :command (lambda ()
                                           (progn
                                             (setf (var-value l-var)
                                                   (format nil "Checkbox is ~a." (var-value cb-var)))
                                             (format t "Hallo~%"))))
                   :padx 2 :pady 2)
             (pack (label :parent f
                          :textvariable l-var)
                   :padx 2 :pady 2)
             (setf (var-value cb-var) "enabled")
             (setf (var-value l-var) "Checkbox is enabled.")))
      (fudi:close fudi-rcv))))

(main :port 3005)

(defparameter *to-gui* (fudi-open :port 3005 :direction :output))
(fudi:send *to-gui* '(1))

(defparameter *gui-rcv* (fudi:open :port 3326 :direction :input))
(set-receiver!
 (lambda (args)
   (format t "~a~%" (apply #'+ 2 args)))
 *gui-rcv*)

(fudi:close *gui-rcv*)

(usocket::socket (fudi::input-stream-server-socket *gui-rcv*))

(fudi::input-stream-id *gui-rcv*)

host: "127.0.0.1"
port: 3310



(main)

(new fudi)

(fudi-open-default :port 3203 :direction :input)

(fudi-close-default :direction :input)

(set-receiver!
 (lambda (args)
   (format t "~a~%" (apply #'+ 2 args)))
 cm::*fudi-in*)


(fudi:close *private-send*)

(fudi:open *private-send*)

(output (new fudi :message "123;"))




()
(setf (sv cm::*midi-in1* cm::rt-stream-receive-type))

(sv cm::*midi-in1* cm::rt-stream-receive-type)


(defsetf (cm::rt-stream-receive-type cm::*fudi-in*) :periodic)

(recv-start cm::*fudi-in*)
(recv-stop cm::*fudi-in*)

(cm::rt-stream-receive-type cm::*fudi-in*)

(defvar *fudi-responder*
  (incudine::make-fudi-responder
   cm::*fudi-in*
   (lambda (msg)
     (format *debug-io* "~a~%" msg))))


(set-re)

()

cm::*fudi-in*

()


(defparameter *f* nil)

(defparameter *t1* (string-var))

(with-tk-root (root)
  (setf (window-title root) "Grid")

  (let ((onevar (boolean-var))
        (twovar (boolean-var))
        (threevar (boolean-var))
        (f (frame :parent root :padding '(5 5 5 5))))
    (setf *f* f)
      
    (setf (var-value onevar) t
          (var-value twovar) nil
          (var-value threevar) t)
      
    (pack f :expand t :fill "both")
      
    (grid (frame :parent f :relief "sunken" :width 300 :height 200)
          :column 0 :row 0 :sticky "nsew"
          :columnspan 3 :rowspan 2)
    (grid (label :parent f :text "Name")
          :column 3 :row 0 :columnspan 2 :sticky "w")
    (grid (entry :parent f)
          :column 3 :row 1 :sticky "new"
          :columnspan 2)
    (grid (checkbutton :text "One" :parent f :variable onevar)
          :column 0 :row 3)
    (grid (checkbutton :text "Two" :parent f :variable twovar)
          :column 1 :row 3)
    (grid (checkbutton :text "Three" :parent f :variable threevar)
          :column 2 :row 3)
    (grid (button :text "OK" :parent f)
          :column 3 :row 3)
    (grid (button :text "Cancel" :parent f)
          :column 4 :row 3)

    (grid-rowconfigure f 1 :weight 1)
    (grid-columnconfigure f 0 :weight 3)
    (grid-columnconfigure f 1 :weight 3)
    (grid-columnconfigure f 2 :weight 3)
    (grid-columnconfigure f 3 :weight 1)
    (grid-columnconfigure f 4 :weight 1)

    (dolist (s (grid-slaves f))
      (grid-configure s :padx 2 :pady 2))))

(grid-slaves *f*)


(defun main ()
  (with-tk-root (root)
    (setf (window-title root) "Grid")

    (let ((onevar (boolean-var))
          (twovar (boolean-var))
          (threevar (boolean-var))
          (f (frame :parent root :padding '(5 5 5 5))))
      
      (setf (var-value onevar) t
            (var-value twovar) nil
            (var-value threevar) t)
      
      (pack f :expand t :fill "both")
      
      (grid (frame :parent f :relief "sunken" :width 300 :height 200)
            :column 0 :row 0 :sticky "nsew"
            :columnspan 3 :rowspan 2)
      (grid (label :parent f :text "Name")
            :column 3 :row 0 :columnspan 2 :sticky "w")
      (grid (entry :parent f)
            :column 3 :row 1 :sticky "new"
            :columnspan 2)
      (grid (checkbutton :text "One" :parent f :variable onevar)
            :column 0 :row 3)
      (grid (checkbutton :text "Two" :parent f :variable twovar)
            :column 1 :row 3)
      (grid (checkbutton :text "Three" :parent f :variable threevar)
            :column 2 :row 3)
      (grid (button :text "OK" :parent f)
            :column 3 :row 3)
      (grid (button :text "Cancel" :parent f)
            :column 4 :row 3)

      (grid-rowconfigure f 1 :weight 1)
      (grid-columnconfigure f 0 :weight 3)
      (grid-columnconfigure f 1 :weight 3)
      (grid-columnconfigure f 2 :weight 3)
      (grid-columnconfigure f 3 :weight 1)
      (grid-columnconfigure f 4 :weight 1)

      (dolist (s (grid-slaves f))
        (grid-configure s :padx 2 :pady 2)))))

(main)
