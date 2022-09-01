;;;; opencl-kernel-handling.lisp
;;;;
;;;; Copyright (c) 2017-18 Orm Finnendahl
;;;; <orm.finnendahl@selma.hfmdk-frankfurt.de>
 
(in-package #:cl-boids-gpu)

(defun get-program-idx (name)
  (position name *program-sources* :test #'string=))

(defun find-kernel (name) (elt *kernels* (get-program-idx name)))

;;; (reload-programs (make-instance 'opencl-boids-window))

(defmethod reload-programs ((w opencl-boids-window) &key &allow-other-keys)
  (loop while *programs*
        do (release-program (pop *programs*)))
  (setf *kernels* nil)
  (loop
     for pgm-name in (reverse *program-sources*)
     do (let ((program (create-program-with-source
                        *context*
                        (read-c-code (format nil "~a.cpp" pgm-name)))))
          (push program *programs*)
          (build-program program)
          (let* ((kernel (create-kernel program pgm-name)))
            (format t "~&built program ~s, ~s: ~a status: ~s, log = ~s~%"
                    (get-kernel-info kernel :function-name)
                    pgm-name
                    kernel
                    (get-program-build-info program (device w) :status)
                    (get-program-build-info program (device w) :log))
            (push kernel *kernels*))))
  (format t "~&*kernels*: ~a" *kernels*)
  (setf (kernel w) (find-kernel "boids"))
  (setf (clear-board-kernel w) (find-kernel "clear_board"))
  (setf (calc-weight-kernel w) (find-kernel "calc_weight")))

;; (get-program-idx "calc-weights")

(defun test-build-programs ()
  (let* ((width 600)
         (height 480)
         (platform (ensure-platform))
         (device (car (get-device-ids platform :all)))
         (win (make-instance 'opencl-boids-window :device device :width width :height height))
         (*context* (create-shared-context platform device)))
    (unwind-protect
         (progn
           (reload-programs win))
      (clear-systems win))))

(defmethod set-kernel ((w opencl-boids-window) &key &allow-other-keys)
  (setf (kernel w) (find-kernel *curr-kernel*)))
