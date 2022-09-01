(defpackage #:opencl-example-utils
  (:use #:cl)
  (:export
   #:with-fps-vars
   #:update-fps
   #:create-shared-context))

(in-package #:cl-boids-gpu)
(defparameter *frame-count* 0)
(defparameter *last-fps-message-time* 0)
(defparameter *last-fps-message-frame-count* 0)
(defparameter *fps-message-interval* 2.000) ;; in second

(defmacro continuable (&body body)
  "Helper macro that we can use to allow us to continue from an
   error. Remember to hit C in slime or pick the restart so
   errors don't kill the app."
  `(restart-case
       (progn ,@body)
     (continue () :report "Swank.Live: Continue")))

(defun update-swank ()
  "Called from within the main loop, this keep the lisp repl
   working while cepl runs"
  (continuable
    (let ((connection (or swank::*emacs-connection*
                          (swank::default-connection))))
      (when connection
        (swank::handle-requests connection t)))))

(defmacro with-bound-buffer ((type buffer) &rest body)
  `(progn
     (gl:bind-buffer ,type ,buffer)
     (unwind-protect
          (progn ,@body)
       (gl:bind-buffer ,type 0))))

(defmacro with-bound-mapped-buffer ((p target access) buffer &rest body)
  `(with-bound-buffer
       (,target ,buffer)
       (gl:with-mapped-buffer (,p ,target ,access)
         (progn ,@body))))

(defun update-fps (&key (print t))
     ;; update the frame count
     (incf *frame-count*)
     ;; handle tick count wrapping to 0
     (let ((now (/ (get-internal-real-time) internal-time-units-per-second)))
       (when (< now *last-fps-message-time*)
         (setf *last-fps-message-time* now))
       ;; see if it is time for next message
       (when (and print
                  (>= now (+ *last-fps-message-time* *fps-message-interval*)))
         (let ((frames (- *frame-count* *last-fps-message-frame-count*))
               (seconds (- now *last-fps-message-time*)))
           (format t "~s seconds: ~s fps, ~s ms per frame~%"
                   (float seconds)
                   (if (zerop seconds) "<infinite>" (float (/ frames seconds)))
                   (if (zerop frames) "<infinite>" (float (/ seconds frames)))))
         (setf *last-fps-message-time* now)
         (setf *last-fps-message-frame-count* *frame-count*))))

(defmacro with-fps-vars ((&key (interval 2.0)) &body body)
  `(let ((*frame-count* 0)
         (*last-fps-message-time* 0)
         (*last-fps-message-frame-count* 0)
         (*fps-message-interval* ,interval))
     ,@body))

(defun set-array-vals (p offs &rest vals)
  "set values of consecutive locations of array pointed to by p
starting at offs."
    (let ((i -1))
      (mapc (lambda (x) (setf (cffi:mem-aref p :float (+ offs (incf i))) x))
            vals)))

(defmacro set-kernel-args (kernel args)
  "Set args of kernel. If element of args is a list use
%set-kernel-svm-buffer in case the second arg is :svm, else
%set-kernel-number, else use %set-kernel-buffer."
  `(progn ,@(loop
               for i from 0
               for arg in args
               collect (if (consp arg)
                           (if (eql (second arg) :svm)
                               `(%set-kernel-arg-svm-buffer ,kernel ,i ,(first arg))    
                               `,(append `(%set-kernel-arg-number ,kernel ,i) arg))
                           `(%set-kernel-arg-buffer ,kernel ,i ,arg)))))
#+unix
(cffi:defcfun ("glXGetCurrentContext" *-get-current-context) :pointer)
#+unix
(cffi:defcfun ("glXGetCurrentDisplay" *-get-current-display-or-hdc) :pointer)
#+win32
(cffi:defcfun ("wglGetCurrentContext" *-get-current-context) :pointer)
#+win32
(cffi:defcfun ("wglGetCurrentDC" *-get-current-display-or-hdc) :pointer)
#+darwin
(cffi:defcfun ("CLGGetCurrentContext" cgl-get-current-context) :pointer)
#+darwin
(cffi:defcfun ("CGLGetShareGroup" cgl-get-share-group) :pointer
  (context :pointer))


(defun create-shared-context (platform device)
  (cond
    ((ocl:device-extension-present-p device "cl_khr_gl_sharing")
     (ocl:create-context (list device)
                     :platform platform
                     ;; unix, win32, egl use roughly same api:
                     #+ (or unix win32) :gl-context-khr
                     #+ (or unix win32) (*-get-current-context)
                     #+ unix :glx-display-khr
                     #+ win32 :wgl-hdc-khr
                     #+ (or unix win32) (*-get-current-display-or-hdc)
                     ;; but apple is different:
                     #+ darwin :cgl-sharegroup-khr
                     #+ darwin (cgl-get-share-group
                                (cgl-get-current-context))))
    ((ocl:device-extension-present-p device "cl_APPLE_gl_sharing")
     (error "context sharing not implemented yet for cl_APPLE_gl_sharing"))
     (t (error "no context sharing extension found in device?"))))

#|
(defun get-x (n &key width cl-boids-gpu::*cl-width*)
  (if *positions*
      (/ (aref *positions* (* n 16)) width)))
|#
(defun get-y (n &key height cl-boids-gpu::*height*)
  (if *positions*
      (/ (aref *positions* (1+ (* n 16))) height)
      0))

(defun get-speed (n)
  (if *velocities*
      (let* ((idx (* n 4))
             (x (aref *velocities* idx))
             (y (aref *velocities* (1+ idx))))
        (sqrt (* (* x x) (* y y))))
      0))

(defun now ()
  (float (/ (get-internal-real-time) internal-time-units-per-second)
         1d0))

(defun read-c-code (filename)
  "return content of \"$CL-BOIDS-GPU/c/<filename>\" as string."
  (ou:file-string
   (merge-pathnames
    filename
    (merge-pathnames
     "c/"
     (asdf:system-source-directory :cl-boids-gpu)))))
