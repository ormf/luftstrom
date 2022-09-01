;;; cl-boids-gpu.lisp
;;;;
;;;; Copyright (c) 2017-18 Orm Finnendahl
;;;; <orm.finnendahl@selma.hfmdk-frankfurt.de>
;;; boid system using OpenCL and OpenGL

;;; run cl-boids-gpu:boids, click to add boid systems, space to clear
;;; running systems, esc to quit. Might need to adjust
;;; *boids-per-click* depending on hardware ;;; performance
;;;
;;; todo:
;;; (ql:quickload "orm-utils")
 
(in-package #:cl-boids-gpu)
;;; (setf  *update* t)
(defparameter *test* nil)

(defun %lock-system-buffers (command-queue bs)
  (let ((pos (boid-coords-buffer bs)))
    (enqueue-acquire-gl-objects command-queue (list pos))))

(defun %unlock-system-buffers (command-queue bs)
  (let ((pos (boid-coords-buffer bs)))
    (enqueue-release-gl-objects command-queue (list pos))))

(defparameter *vel-dummy* nil)

(defmacro with-gl-cl-buffer ((vbo cl-buf context elt-size count) &body body)
  `(with-bound-buffer (:array-buffer ,vbo)
                      (%gl:buffer-data :array-buffer (* ,elt-size ,count) (cffi:null-pointer)
                                      :dynamic-draw)
                      (setf ,cl-buf
                            (create-from-gl-buffer ,context :read-write ,vbo))
                      ,@body
;;;                (format t "created shared GL buffer: ~a~%" (boid-coords-buffer bs));
                     ))



(defun make-boid-system (origin count win &key (maxcount *boids-maxcount*)
                                            (maxobstacles *max-obstacles*)
                                            (pixelsize *pixelsize*)
                                            (trig *trig*))
  (declare (ignore win))
  (format t "~&making, origin: ~a~%" origin)
  (destructuring-bind (gl-coords gl-vel gl-life gl-retrig) (gl:gen-buffers 4)
    
    (let* ((max-offs-size (length *board-offsets*))
           (vertex-size 2)                ;;; size of one boid-coord (pos color)
           ;; 4 single-floats per boid for velocity, 
           (force-buffer (create-buffer *context* (* +float4-octets+ maxcount) :read-write))
           (bidx-buffer (create-buffer *context* (* 4 maxcount) :read-write))

;;; obstacles
           (obstacles-pos-buffer (create-buffer *context* (* +float4-octets+ maxobstacles) :read-write))
           (obstacle-target-posns (make-array
                                   maxobstacles
                                   :element-type 'obstacle-targets
                                   :initial-contents (loop for i below maxobstacles collect (make-obstacle-targets))))
           (obstacles-radius-buffer (create-buffer *context* (* 4 maxobstacles) :read-write))
           (obstacles-lookahead-buffer (create-buffer *context* (* 4 maxobstacles) :read-write))
           (obstacles-multiplier-buffer (create-buffer *context* (* 4 maxobstacles) :read-write))
           (obstacles-type-buffer (create-buffer *context* (* 4 maxobstacles) :read-write))
           (obstacles-boardoffs-maxidx-buffer (create-buffer *context* (* 4 maxobstacles) :read-write)) 


           
           (color-buffer (create-buffer *context* (* +float4-octets+ maxcount) :read-write))
           (weight-board (create-buffer *context* (round (+ 0.5
                                                            (* 4 (/ *gl-width* pixelsize)
                                                               (/ *gl-height* pixelsize)))) :read-write))
           (align-board (create-buffer
                         *context*
                         (round (+ 0.5
                                   (* +float4-octets+ (/ *gl-width* pixelsize)
                                      (/ *gl-height* pixelsize)))) :read-write))
           (obstacle-board-buffer (create-buffer *context*
                                                 (round (* 4 (/ *gl-width* pixelsize)
                                                           (/ *gl-height* pixelsize))) :read-write))

           (board-dx (create-buffer *context* (* 4 max-offs-size) :read-only))
           (board-dy (create-buffer *context* (* 4 max-offs-size) :read-only))
           (board-dist (create-buffer *context* (* 4 max-offs-size) :read-only))
           (board-sep (create-buffer *context* (* +float4-octets+ max-offs-size) :read-only))
           (board-coh (create-buffer *context* (* +float4-octets+ max-offs-size) :read-only))
           
           (bs (make-instance
                'boid-system
                :count count
                :gl-coords gl-coords
                :gl-vel gl-vel
                :gl-life gl-life
                :gl-retrig gl-retrig
;;;                :velocity-buffer vel
;;;                :life-buffer life-buffer
;;;                :retrig-buffer retrig-buffer
                :force-buffer force-buffer
                :obstacle-target-posns obstacle-target-posns
                :obstacle-board obstacle-board-buffer
                :obstacles-pos obstacles-pos-buffer
                :obstacles-radius obstacles-radius-buffer
                :obstacles-lookahead obstacles-lookahead-buffer
                :obstacles-multiplier obstacles-multiplier-buffer
                :obstacles-boardoffs-maxidx obstacles-boardoffs-maxidx-buffer
                :obstacles-type obstacles-type-buffer
                :maxobstacles maxobstacles
                :bidx-buffer bidx-buffer :color-buffer color-buffer
                :weight-board weight-board :align-board align-board
                :board-dx board-dx :board-dy board-dy :board-dist board-dist :board-sep board-sep
                :board-coh board-coh :pixelsize pixelsize
                :x (first origin) :y (second origin) :z (third origin))))
      (unless (zerop gl-coords)
        (with-slots (boid-coords-buffer velocity-buffer life-buffer retrig-buffer) bs
          (with-model-slots (speed lifemult maxlife) *bp*
            (let ((maxspeed (* 1.05 speed)))
;;; specify buffer size in bytes; as we store the coords of start and end
;;; points for each boid, we multiply the vertex size (pos+color)
;;; by 2 and by the number of bytes for 4 floats (x,y,z,w) = 64 bytes for each boid.
              (with-gl-cl-buffer (gl-coords (boid-coords-buffer bs) *context* (* 2 vertex-size +float4-octets+) maxcount)
                (gl:with-mapped-buffer (p :array-buffer :write-only)
                  (unless (zerop count)
                    (progn
                      (loop repeat count
                            for i from 0 by (* 2 vertex-size 4) ;;; as i indexes floats, we increase the float-count and *not* the byte-count!
                            do (let ((color (if (zerop i) *first-boid-color* *fg-color*)))
                                 (apply #'set-array-vals p (+ i 0) origin)
                                 (apply #'set-array-vals p (+ i 4) color)
                                 (apply #'set-array-vals p (+ i 8) origin)
                                 (apply #'set-array-vals p (+ i 12) color)))))))
              (unless (zerop count)
                (with-gl-cl-buffer (gl-vel velocity-buffer *context* +float4-octets+ maxcount)
                  (gl:with-mapped-buffer (p :array-buffer :write-only)
                    (unless (zerop count)
                      (progn
                        (loop repeat count
                              for i from 0 by 4
                              for a = (float (random +twopi+) 1.0)
                              for v = (float (+ 0.1 (random 0.1)) 1.0)
                              do (set-array-vals p i (* v maxspeed (sin a))(* v maxspeed (cos a)) 0.0 0.0))))))
                (with-gl-cl-buffer (gl-life life-buffer *context* +float-octets+ maxcount)
                  (gl:with-mapped-buffer (p :array-buffer :write-only)
                    (unless (zerop count)
                      (dotimes (i count)
                        (setf (cffi:mem-aref p :float i)
                              (float (if trig
                                         (max 0.01 (* (random (float (max 0.01 lifemult))) 8))
                                         (max 0.01 (* (+ 0.7 (random 0.2)) maxlife)))
                                     1.0))))))
                ;;         (ocl:with-mapped-svm-buffer ((car *command-queues*) life-buffer count :write t)
                ;; (dotimes (i count) (setf (cffi:mem-aref life-buffer :float i) (float (if trig
                ;;                                                                          (max 0.01 (* (random (float (max 0.01 lifemult))) 8))
                ;;                                                                          (max 0.01 (* (+ 0.7 (random 0.2)) maxlife)))
                ;;                                                                      1.0))))
                (with-gl-cl-buffer (gl-retrig retrig-buffer *context* (* 4 2 +float-octets+) maxcount)
                  (gl:with-mapped-buffer (p :array-buffer :write-only)
                    (unless (zerop count)
                      (loop
                        repeat count
                        for i from 0 by 4
                        do (progn
                             (setf (cffi:mem-aref p :long i) 0)
                             (setf (cffi:mem-aref p :long (+ i 1)) -2) ;;; set next trigger-type to no obstacle
                             (setf (cffi:mem-aref p :long (+ i 2)) 0)
                             (setf (cffi:mem-aref p :long (+ i 3)) 0))))))
	;;; board-offset initialization: write dx,dy,distance,sep and coh vectors
                
                (ocl:with-mapped-buffer (dx (car *command-queues*) board-dx max-offs-size :write t)
                  (ocl:with-mapped-buffer (dy (car *command-queues*) board-dy max-offs-size :write t)
                    (ocl:with-mapped-buffer (d (car *command-queues*) board-dist max-offs-size :write t)
                      (ocl:with-mapped-buffer (sep (car *command-queues*) board-sep (* 4 max-offs-size) :write t)
                        (ocl:with-mapped-buffer (coh (car *command-queues*) board-coh (* 4  max-offs-size) :write t)
                          (ocl:with-mapped-buffer (obst (car *command-queues*) obstacle-board-buffer max-offs-size :write t)
                            (loop
                              for i from 0 for j from 0 by 4 for elem in *board-offsets*
                              for vcoh = (getf elem :coh-vec) for dist = (getf elem :dist) for vsep = (getf elem :sep-vec)
                              do (progn
                                   ;;                            (format t "~&~a ~a ~a ~a~%" vcoh vsep (getf elem :dx) (getf elem :dy))
                                   (setf (cffi:mem-aref dx :int i) (getf elem :dx)
                                         (cffi:mem-aref dy :int i) (getf elem :dy)
                                         (cffi:mem-aref d :float i) (getf elem :dist)
                                         (cffi:mem-aref obst :int i) 0)
                                   (apply #'set-array-vals sep j vsep)
                                   (apply #'set-array-vals coh j vcoh))))))))))))))
      bs)))

(defun add-to-boid-system (origin count win &key (maxcount *boids-maxcount*) (length 5))
  (format t "~&adding, origin: ~a" origin)
  (let* ((bs (first (systems win)))
         (coords (gl-coords bs))
         (vel (velocity-buffer bs))
         (life-buffer (life-buffer bs))
         (retrig-buffer (retrig-buffer bs))
         (boid-count (boid-count bs))
         (vertex-size 2)  ;;; size of boid-coords
         (command-queue (first (command-queues win))))
    (setf count (min count (- maxcount (boid-count bs))))
;;;    (break "coords: ~a" coords)
    (unless (or (zerop gl-coords) (zerop count))
      (with-model-slots (num-boids maxspeed lifemult) *bp*
        (with-bound-buffer (:array-buffer gl-coords)
           (gl:with-mapped-buffer (p1 :array-buffer :read-write)
             (ocl:with-mapped-svm-buffer (command-queue vel (* 4 (+ boid-count count)) :write t)
               (ocl:with-mapped-svm-buffer (command-queue life-buffer (+ boid-count count) :write t)
                 (ocl:with-mapped-svm-buffer (command-queue retrig-buffer (+ boid-count count) :write t)
                   (loop repeat count
                         for i from (* 4 (* 2 vertex-size) boid-count) by (* 4 (* 2 vertex-size))
                         for j from (* 4 boid-count) by 4
                         for k from boid-count
                         for a = (float (random +twopi+) 1.0)
                         for v = (float (+ 0.1 (random 0.8)) 1.0) ;; 1.0
                         do (let ()
                              (set-array-vals vel j (* v maxspeed (sin a)) (* v maxspeed (cos a)) 0.0 0.0)
                              (apply #'set-array-vals p1 (+ i 0) origin)
                              (apply #'set-array-vals p1 (+ i 8) (mapcar #'+ origin
                                                                         (list (* -1 length (sin a))
                                                                               (* -1 length (cos a)) 0.0 1.0)))
                              (let ((color (if (zerop i) *first-boid-color* *fg-color*)))
                                (apply #'set-array-vals p1 (+ i 4) color)
                                (apply #'set-array-vals p1 (+ i 12) color))
                              (setf (cffi:mem-aref life-buffer :float k) (float (* 6 lifemult) 1.0))
                              (setf (cffi:mem-aref retrig-buffer :int (* k 4)) 0) ;;; retrig
                              (setf (cffi:mem-aref retrig-buffer :int (+ (* k 4) 1)) 0) ;;; frames since last trig
                              (setf (cffi:mem-aref retrig-buffer :int (+ (* k 4) 2)) -2) ;;; obstacle-idx for next trig
                              (setf (cffi:mem-aref retrig-buffer :int (+ (* k 4) 3)) 0) ;;; unused
                              )))))))
        (incf (boid-count bs) count)
        (setf num-boids (boid-count bs))))
    bs))


#|




(cl-glut::with-window *win*
(gl:enable-client-state :vertex-array)
(gl:enable-client-state :color-array)
  (gl:bind-buffer :array-buffer 2)
  (gl:map-buffer :array-buffer :read-write))

*win*

(add-to-boid-system '(0.5 0.5 0.0 0.0) 50 *win*)

(first (systems *win*))
|#

;;; (show-positions *positions*)

;;; (toggle-update)

(defun unmake-boid-system (bs context)
  (gl:delete-buffers (list (gl-coords bs)))
  (setf (gl-coords bs) nil)
  (when (force-buffer bs)
    (release-mem-object (force-buffer bs))
    (setf *buffers*
          (delete (force-buffer bs) *buffers* :test 'cffi:pointer-eq))
    (setf (force-buffer bs) nil))
  (when (bidx-buffer bs)
    (release-mem-object (bidx-buffer bs))
    (setf *buffers*
          (delete (bidx-buffer bs) *buffers* :test 'cffi:pointer-eq))
    (setf (force-buffer bs) nil))
  (when (velocity-buffer bs)
    (svm-free context (velocity-buffer bs))
    (setf *buffers*
          (delete (velocity-buffer bs) *buffers* :test 'cffi:pointer-eq))
    (setf (velocity-buffer bs) nil))
  (when (life-buffer bs)
    (svm-free context (life-buffer bs))
    (setf *buffers*
          (delete (life-buffer bs) *buffers* :test 'cffi:pointer-eq))
    (setf (life-buffer bs) nil))
  (when (retrig-buffer bs)
    (svm-free context (retrig-buffer bs))
    (setf *buffers*
          (delete (retrig-buffer bs) *buffers* :test 'cffi:pointer-eq))
    (setf (retrig-buffer bs) nil))
  (when (color-buffer bs)
    (release-mem-object (color-buffer bs))
    (setf *buffers*
          (delete (color-buffer bs) *buffers* :test 'cffi:pointer-eq))
    (setf (color-buffer bs) nil))
  (when (weight-board bs)
    (release-mem-object (weight-board bs))
    (setf *buffers*
          (delete (weight-board bs) *buffers* :test 'cffi:pointer-eq))
    (setf (weight-board bs) nil))
  (when (align-board bs)
    (release-mem-object (align-board bs))
    (setf *buffers*
          (delete (align-board bs) *buffers* :test 'cffi:pointer-eq))
    (setf (align-board bs) nil))
  (when (board-dx bs)
    (release-mem-object (board-dx bs))
    (setf *buffers*
          (delete (board-dx bs) *buffers* :test 'cffi:pointer-eq))
    (setf (board-dx bs) nil))
  (when (board-dy bs)
    (release-mem-object (board-dy bs))
    (setf *buffers*
          (delete (board-dy bs) *buffers* :test 'cffi:pointer-eq))
    (setf (board-dy bs) nil))
  (when (board-dist bs)
    (release-mem-object (board-dist bs))
    (setf *buffers*
          (delete (board-dist bs) *buffers* :test 'cffi:pointer-eq))
    (setf (board-dist bs) nil))
  (when (board-sep bs)
    (release-mem-object (board-sep bs))
    (setf *buffers*
          (delete (board-sep bs) *buffers* :test 'cffi:pointer-eq))
    (setf (board-sep bs) nil))
  (when (board-coh bs)
    (release-mem-object (board-coh bs))
    (setf *buffers*
          (delete (board-coh bs) *buffers* :test 'cffi:pointer-eq))
    (setf (board-coh bs) nil))
  (when (boid-coords-buffer bs)
    (release-mem-object (boid-coords-buffer bs))
    (setf *buffers*
          (delete (boid-coords-buffer bs) *buffers* :test 'cffi:pointer-eq))
    (setf (boid-count bs) nil)
    (setf *positions* nil)))

(defun clear-systems (window)
  (format t "clearing ~d~:* boid system~p from window~%" (length (systems window)))
  ;; (format t "clearing ~[no~:;~:*~s~] boid system~:*~[~;~:;s~] from window~%"
  ;;         (length (systems window)))
  (loop while (systems window)
        do (unmake-boid-system (pop (systems window)) *context*)))

;;(format t "clearing ~[no~:;~:*~d~] boid system~:*~[~;~:;s~] from window~%" 1)

;;(format t "clearing ~d~:* boid system~p from window~%" 0)

(defun draw-system (bs)
  (when (gl-coords bs)
;    (format t "~a~%"(gl-coords bs))
    (gl:color 0.6 0.6 0.3 0.8)
    (gl:bind-buffer :array-buffer (gl-coords bs))
    
;;    (gl:buffer-data :array-buffer :dynamic-draw (gl-array bs))
    (%gl:vertex-pointer 4 :float (* +float4-octets+ 2) (* +float4-octets+ 0))
    (%gl:color-pointer 4 :float (* +float4-octets+ 2) (* +float4-octets+ 1))
    (gl:draw-arrays :lines 0 (* 2 (boid-count bs)))
    (gl:bind-buffer :array-buffer 0)))

(defun draw-systems (window)
  (gl:enable-client-state :vertex-array)
  (gl:enable-client-state :color-array)
  (mapc #'draw-system (systems window))
  (gl:disable-client-state :color-array)
  (gl:disable-client-state :vertex-array))


;;; WARNING: The following function gets redefined in luftstrom-display!!!

(defun %update-system (window bs)
  (let ((command-queue (car *command-queues*))
        (pixelsize (pixelsize bs))
        (width *gl-width*)
        (height *gl-height*)
        (pos (boid-coords-buffer bs))
        (vel (velocity-buffer bs))
        (forces (force-buffer bs))
        (bidx (bidx-buffer bs))
        (life (life-buffer bs))
        (retrig (retrig-buffer bs))
        (color (color-buffer bs))
        (weight-board (weight-board bs))
        (align-board (align-board bs))
        (board-dx (board-dx bs))
        (board-dy (board-dy bs))
        (coh (board-coh bs))
        (sep (board-sep bs))
        (obstacle-board (obstacle-board bs))
        (obstacles-pos (obstacles-pos bs))
        (obstacles-radius (obstacles-radius bs))
        (obstacles-type (obstacles-type bs))
        (obstacles-lookahead (obstacles-lookahead bs))
        (obstacles-multiplier (obstacles-multiplier bs))
        (obstacles-boardoffs-maxidx (obstacles-boardoffs-maxidx bs))
        (num-obstacles (num-obstacles bs))
        (dist (board-dist bs))
        (cb-kernel (clear-board-kernel window))
        (cw-kernel (calc-weight-kernel window))
        (kernel (find-kernel *curr-kernel*))
        (count (boid-count bs)))
    (with-model-slots (num-boids maxidx length speed maxspeed maxforce alignmult sepmult cohmult maxlife lifemult) *bp*
      (set-kernel-args cb-kernel (weight-board align-board obstacle-board obstacles-pos obstacles-radius obstacles-lookahead
                                               ((make-obstacle-mask) :uint)
                                               (num-obstacles :int)
                                               (pixelsize :int) ((round (/ width pixelsize)) :int)
                                               ((round (/ height pixelsize)) :int)))
      (enqueue-nd-range-kernel command-queue cb-kernel (round (* (/ width pixelsize) (/ height pixelsize))))
      (finish command-queue)
      (set-kernel-args
       cw-kernel
       (pos weight-board vel align-board (pixelsize :int) (width :int) (height :int)))
      (enqueue-nd-range-kernel command-queue cw-kernel (boid-count bs))
      (finish command-queue)
      (if *test*
          (progn
            (format t "~a"
                    (list pos vel forces bidx life color weight-board align-board
                          board-dx board-dy dist coh sep obstacle-board obstacles-pos
                          obstacles-radius obstacles-boardoffs-maxidx num-obstacles

                          (round maxidx) (float length 1.0) (float speed 1.0)
                          (x bs) (y bs) (z bs) (float maxspeed 1.0) (float maxforce 1.0)
                          (float alignmult 1.0) (float sepmult 1.0)
                          (float cohmult 1.0) (float maxlife 1.0) (float lifemult 1.0)
                          (round count) (round pixelsize) (round width)(round height)))
            (setf *test* nil)))
      (decf *clock*)
      (set-kernel-args kernel
                       (pos vel forces bidx life retrig color weight-board align-board
                            board-dx board-dy dist coh sep obstacle-board obstacles-pos obstacles-radius obstacles-type
                            obstacles-boardoffs-maxidx
                            obstacles-lookahead obstacles-multiplier
                            ((round num-obstacles) :int)
                            ((if (<= *clock* 0) 1 0) :int)
                            ((round maxidx) :int) ((float length 1.0) :float) ((float speed 1.0) :float)
                            ((x bs) :float) ((y bs) :float) ((z bs) :float)
                            ((float maxspeed 1.0) :float)
                            ((float maxforce 1.0) :float)
                            ((float alignmult 1.0) :float)
                            ((float sepmult 1.0) :float)
                            ((float cohmult 1.0) :float)
                            ((float maxlife 1.0) :float)
                            ((float lifemult 1.0) :float)
                            ((round count) :int)
                            ((round pixelsize) :int)
                            ((round width) :int)
                            ((round height) :int)))
      (enqueue-nd-range-kernel command-queue kernel count)
      (finish command-queue)

      (Setf num-boids (boid-count bs))
      ;;    (setf *positions* (boid-coords-buffer bs))
      (setf *positions* (enqueue-read-buffer command-queue pos
                                             (* 16 (boid-count bs))))
      (setf *velocities* (enqueue-read-buffer command-queue vel
                                              (* 4 (boid-count bs))))
      (setf *obstacle-board* (enqueue-read-buffer command-queue obstacle-board
                                                  (round (* (/ width pixelsize) (/ height pixelsize)))
                                                  :element-type '(unsigned-byte 32)))
      (setf *forces* (enqueue-read-buffer command-queue forces
                                          (* 4 (boid-count bs))))
      (setf *life* (enqueue-read-buffer command-queue life
                                        (boid-count bs)))
      (setf *retrig* (enqueue-read-buffer command-queue retrig
                                          (* 4 (boid-count bs))
                                          :element-type '(signed-byte 32)))
      (setf *bidx* (enqueue-read-buffer command-queue bidx
                                        (boid-count bs)
                                        :element-type '(signed-byte 32)))
      (setf *colors* (enqueue-read-buffer command-queue color
                                          (* 4 (boid-count bs))))
      (setf *obstacles-pos* (enqueue-read-buffer command-queue obstacles-pos
                                                 (* 4 num-obstacles)))
      (setf *obstacles-radius* (enqueue-read-buffer command-queue obstacles-radius
                                                    num-obstacles
                                                    :element-type '(signed-byte 32)))
      ;; (setf *board-dx* (enqueue-read-buffer command-queue board-dx
      ;;                                      *maxidx*
      ;;                                      :element-type '(signed-byte 32)))
      ;; (setf *board-dy* (enqueue-read-buffer command-queue board-dy
      ;;                                      *maxidx*
      ;;                                      :element-type '(signed-byte 32)))
      ;; (setf *board-dist* (enqueue-read-buffer command-queue dist
      ;;                                         *maxidx*))
      ;; (setf *board-sep* (enqueue-read-buffer command-queue sep
      ;;                                        (* 4 *maxidx*)))
      ;; (setf *board-coh* (enqueue-read-buffer command-queue coh
      ;;                                        (* 4 *maxidx*)))
      (finish command-queue)))
)


(defun update-cracklers ())

(defun update-systems (window)
  ;; fixme: switch back to something like this once we can implement
  ;;        UPDATE-SYSTEM with event waits instead of FINISH
  #++(mapcar (lambda (a) (update-system window a)) (systems window))
  (let ((command-queue (car (command-queues window))))
    ;; since we can't wait on events, break the update into pieces
    ;; so we only need 3 FINISH stalls per frame
    ;; (dolist (bs (systems window)) (%lock-system-buffers command-queue bs))
    ;; (finish command-queue)
    (if *update*
        (dolist (bs (systems window)) (%update-system window bs)))
    (finish command-queue)
    ;; (dolist (bs (systems window)) (%unlock-system-buffers command-queue bs))
    ;; (finish command-queue)
    ))

;;; (test-build-programs)

#|
(defun set-zoom (val)
  (setf *zoom* (float (min (max val 0.25) 4) 1.0))
  (format t "~&zoom: ~a" *zoom*)
  (setf *gl-width* (round (/ *gl-width* *zoom*)))
  (setf *gl-height* (round (/ *gl-height* *zoom*)))
  ;; (setf *gl-scale* (float (* *zoom* (/ *width* *gl-width*)) 1.0))
  )
|#
#|
(setf *gl-scale* 1)
(setf *gl-width* 1600)
(setf *gl-height* 900)
|#

(defun get-circle-vertex-coords (rad num)
  (let* ((theta (/ +twopi+ num))
         (tang-factor (tan theta))
         (rad-factor (cos theta)))
;;    (format t "~a ~a" rad-factor tang-factor)
    (loop
       for x = 0 then (* (+ x1 (* -1 y1 tang-factor)) rad-factor)
       for y = rad then (* (+ y1 (* x1 tang-factor)) rad-factor)
       for x1 = x
       for y1 = y
       for i below num
       collect (vector x y))))

(defun get-predator-vertex-coords (rad num fac &optional (modulo 1) (offset 0))
  (let* ((theta (/ +twopi+ num))
         (tang-factor (tan theta))
         (rad-factor (cos theta)))
;;    (format t "~a ~a" rad-factor tang-factor)
    (loop
       for x = 0 then (* (+ x1 (* -1 y1 tang-factor)) rad-factor)
       for y = rad then (* (+ y1 (* x1 tang-factor)) rad-factor)
       for x1 = x
       for y1 = y
       for i to num
       collect (let ((factor (if (zerop (mod (+ i offset) modulo)) fac 1)))
                   (vector (* factor x) (* factor y))))))

(defparameter *unit-circle-vertex-coords* (get-circle-vertex-coords 1 16))
(defparameter *pentagon-vertex-coords* (get-circle-vertex-coords 1 5))
(defparameter *unit-predator-vertex-coords* (get-predator-vertex-coords 1 16 1 1 0))

(defparameter *unit-attractor-vertex-coords* (get-predator-vertex-coords 1 16 1 1 0))

(defun set-circle-vertex-coords (rad num)
  (declare (ignore num))
  (loop
     for v in *unit-circle-vertex-coords*
     do (gl:vertex (* rad (elt v 0)) (* rad (elt v 1))  0.0)))

(defun set-pentagon-vertex-coords (rad num)
  (declare (ignore num))
  (loop
    for v in *pentagon-vertex-coords*
     do (gl:vertex (* rad (elt v 0)) (* rad (elt v 1))  0.0)))

(defun set-predator-vertex-coords (rad num)
  (declare (ignore num))
  (loop
     for v in *unit-predator-vertex-coords*
     do (gl:vertex (* rad (elt v 0)) (* rad (elt v 1))  0.0)))

(defun set-attractor-vertex-coords (rad num)
  (declare (ignore num))
  (loop
     for v in *unit-attractor-vertex-coords*
     do (gl:vertex (* rad (elt v 0)) (* rad (elt v 1))  0.0)))

(defmethod glut:display-window :before ((w opencl-boids-window))
  (setf *context*
        (if *sharing*
            (create-shared-context *platform* (device w))
            (create-context (device w))
            ))
  (format t "context: ~a" *context*)
  (if *context*
      (progn
        (push (create-command-queue *context* (device w)) *command-queues*)
        (setf (command-queues w) *command-queues*)
        (reload-programs w)
        (format t "~&setting cursor in window ~a...~%" (glut:get-window))
        (glut:set-cursor :cursor-none)
        (gl:clear-depth 1)
        (gl:shade-model :smooth)
        (gl:clear-color 0 0 0 0)
        (gl:enable :depth-test :multisample)
        (gl:depth-func :lequal)
        (let ((p (glut:get-proc-address "glxSwapIntervalEXT")))
          (unless (cffi:null-pointer-p p)
            (cffi:foreign-funcall-pointer p () :int 4 :int)))
        (gl:hint :perspective-correction-hint :nicest))
      (error "no context created!")))


#|

(systems *win*)

(setf *context*
(create-shared-context *platform* (device *win*)))

(create-shared-context *platform* (device *win*)) ;


(command-queues *win*)
|#
#|

(defmethod glut:display-window :before ((w stroke-window))
  (let ((a '(#\A (0 0 pt) (0 9 pt) (1 10 pt) (4 10 pt) (5 9 pt) (5 0 stroke)
                 (0 5 pt) (5 5 end)))
        (e '(#\E (5 0 pt) (0 0 pt) (0 10 pt) (5 10 stroke) (0 5 pt) (4 5 end)))
        (p '(#\P (0 0 pt) (0 10 pt) (4 10 pt) (5 9 pt) (5 6 pt) (4 5 pt)
                 (0 5 end)))
        (r '(#\R (0 0 pt) (0 10 pt) (4 10 pt) (5 9 pt) (5 6 pt) (4 5 pt)
                 (0 5 stroke) (3 5 pt) (5 0 end)))
        (s '(#\S (0 1 pt) (1 0 pt) (4 0 pt) (5 1 pt) (5 4 pt) (4 5 pt) (1 5 pt)
                 (0 6 pt) (0 9 pt) (1 10 pt) (4 10 pt) (5 9 end))))
    ;; draw-letter interprets the instructions above
    (flet ((draw-letter (instructions)
             (gl:begin :line-strip)
             (loop for (x y what) in instructions do
                   (case what
                     (pt (gl:vertex x y))
                     (stroke (gl:vertex x y)
                             (gl:end)
                             (gl:begin :line-strip))
                     (end (gl:vertex x y)
                          (gl:end)
                          (gl:translate 8 0 0))))))
      ;; create a display list for each of 6 characters
      (gl:shade-model :flat)
      (let ((base (gl:gen-lists 128)))
        (gl:list-base base)
        (loop for char in (list a e p r s) do
              (gl:with-new-list ((+ base (char-code (car char))) :compile)
                (draw-letter (cdr char))))
        ;; space
        (gl:with-new-list ((+ base (char-code #\Space)) :compile)
          (gl:translate 8 0 0))))))

(defun draw-number (num x y)
  (declare (ignore num x y))
  (let ((a '(#\A (0 0 pt) (0 9 pt) (1 10 pt) (4 10 pt) (5 9 pt) (5 0 stroke)
                 (0 5 pt) (5 5 end)))
        (e '(#\E (5 0 pt) (0 0 pt) (0 10 pt) (5 10 stroke) (0 5 pt) (4 5 end)))
        (p '(#\P (0 0 pt) (0 10 pt) (4 10 pt) (5 9 pt) (5 6 pt) (4 5 pt)
                 (0 5 end)))
        (r '(#\R (0 0 pt) (0 10 pt) (4 10 pt) (5 9 pt) (5 6 pt) (4 5 pt)
                 (0 5 stroke) (3 5 pt) (5 0 end)))
        (s '(#\S (0 1 pt) (1 0 pt) (4 0 pt) (5 1 pt) (5 4 pt) (4 5 pt) (1 5 pt)
                 (0 6 pt) (0 9 pt) (1 10 pt) (4 10 pt) (5 9 end))))
    ;; draw-letter interprets the instructions above
    (flet ((draw-letter (instructions)
             (gl:begin :line-strip)
             (loop for (x y what) in instructions do
                   (case what
                     (pt (gl:vertex x y))
                     (stroke (gl:vertex x y)
                             (gl:end)
                             (gl:begin :line-strip))
                     (end (gl:vertex x y)
                          (gl:end)
                          (gl:translate 8 0 0))))))
      ;; create a display list for each of 6 characters
      (gl:shade-model :flat)
      (let ((base (gl:gen-lists 128)))
        (gl:list-base base)
        (loop for char in (list a e p r s) do
              (gl:with-new-list ((+ base (char-code (car char))) :compile)
                (draw-letter (cdr char))))
        ;; space
        (gl:with-new-list ((+ base (char-code #\Space)) :compile)
          (gl:translate 8 0 0))))))
|#

(defun draw-icon (player radius)
  (case player
    (0 (let ((stretch (* radius 0.25))
             (stretchneg (* radius -0.25)))
         (gl:color 0.2 0.2 0.2 1)
         (gl:translate 0 (* radius 1/25) 0.0)
         (gl:with-primitives :polygon   ; start drawing a polygon
           (gl:vertex stretchneg stretchneg 0.0)
           (gl:vertex 0 stretch 0.0)
           (gl:vertex stretch stretchneg 0.0))
         (gl:translate 0 (* radius -1/25) 0.0)))
    (1 (let ((stretch (* radius 0.2))
             (stretchneg (* radius -0.2)))
         (gl:color 0.2 0.2 0.2 1)
         (gl:with-primitives :polygon   ; start drawing a polygon
           (gl:vertex stretchneg stretchneg 0.0)
           (gl:vertex stretchneg stretch 0.0)
           (gl:vertex stretch stretch 0.0)
           (gl:vertex stretch stretchneg 0.0))))
    (2 (gl:color 0.2 0.2 0.2 1)
     (gl:translate 0 0 0.0)
     (gl:with-primitives :polygon       ; start drawing a polygon
       (set-pentagon-vertex-coords (* 0.3 radius) 5))
     (gl:translate 0 0 0.0))
    (3 (gl:color 0.2 0.2 0.2 1)
     (gl:with-primitives :polygon       ; start drawing a polygon
       (set-circle-vertex-coords (* 0.25 radius) 16)))))

(defun predator-circle (player x y radius brightness)
  (gl:load-identity)
  (gl:translate x y 0.0)       ; translate left and into the screen
       ; translate left and into the screen
  (draw-icon player radius)
  (gl:line-width 4)
  (gl:color 0.6 0.6 0.6 brightness)
  (gl:with-primitives :polygon  ; start drawing a polygon
    (set-predator-vertex-coords (* 0.7 radius) 16)))

(defun attractor-circle (player x y radius brightness)
  (gl:load-identity)
  (gl:translate x y 0.0)       ; translate left and into the screen
  (draw-icon player radius)
  (gl:line-width 4)
  (gl:color 0.5 0.5 0.5 brightness)
  (gl:with-primitives :polygon  ; start drawing a polygon
    (set-attractor-vertex-coords (* 0.7 radius) 16)))

(defun plucker-circle (player x y radius brightness)
  (gl:load-identity)
  (gl:translate x y 0.0)       ; translate left and into the screen
  (gl:line-width 4)
  (draw-icon player radius)
  (gl:color 0.5 0.5 0.5 brightness)
  (gl:with-primitives :polygon  ; start drawing a polygon
    (set-circle-vertex-coords (* 0.7 radius) 16)))

(defun obstacle-circle (player x y radius brightness)
  (gl:load-identity)
  (gl:translate x y 0.0)       ; translate left and into the screen
  (gl:line-width 4)
  (draw-icon player radius)
  (gl:color 0.5 0.5 0.5 brightness)
  (gl:with-primitives :polygon  ; start drawing a polygon
    (set-circle-vertex-coords (* 0.7 radius) 16)))

(defun no-interact-circle (player x y radius brightness)
  (gl:load-identity)
  (gl:translate x y 0.0)       ; translate left and into the screen
  (gl:line-width 4)
  (draw-icon player radius)
  (gl:color 0.5 0.5 0.5 brightness)
  (gl:with-primitives :polygon  ; start drawing a polygon
    (set-circle-vertex-coords (* 0.7 radius) 16)))

#|

(defun draw-icon (player radius)
  (case player
    (0   (let ((stretch (* radius 0.3))
               (stretchneg (* radius -0.3)))
           (gl:with-primitives :polygon ; start drawing a polygon
             (gl:vertex stretchneg stretchneg 0.0)
             (gl:vertex -5 5 0.0)
             (gl:vertex 5 5 0.0)
             (gl:vertex 5 -5 0.0))))

    ))
*show-fps*
|#

(defmethod glut:display ((window opencl-boids-window))
  (with-slots (width height gl-width gl-height gl-scale show-fps) window
    (update-fps :print show-fps)
    (gl:load-identity)
    (gl:enable :blend)
    (gl:blend-func :src-alpha :one)
    (gl:point-size (* 2 gl-scale))
    (gl:line-width (* 2 gl-scale))
    (gl:disable :depth-test)
    (gl:depth-func :lequal)
    (gl:matrix-mode :projection)
    (gl:load-identity)
    ;; (glu:perspective 50 (/ (glut:width window) (glut:height window)) -1 1)
    (gl:ortho 0 gl-width 0 gl-height -1 1)
    (gl:scale gl-scale gl-scale gl-scale)
;;;    (gl:translate (* (- 1 gl-scale) gl-width) (* (- 1 gl-scale) gl-height) 0.0)
    (gl:matrix-mode :modelview)
    (update-swank)
    (gl:clear :color-buffer-bit :depth-buffer-bit)
;;    (format t "context: ~a" *context*)
    (continuable
      (draw-systems window)
      ;; (draw-obstacles window)
      (if (show-frame window) (draw-frame window))
      )
    (glut:swap-buffers)
    (gl:finish)
    (continuable
      (if *update*
          (update-systems window)))
    ))

#|
(glut:reshape *win* 640 480)
(glut:reshape *win* 860 720)
(glut:reshape *win* 1280 960)
(glut:reshape *win* 800 450)


|#
;;; (attractor-circle (mouse-x window) (- height (mouse-y window)))
#|

(defmethod glut:idle ((window opencl-boids-window))
  (glut:post-redisplay))

|#

(defparameter *fps-limit* 60)
(defparameter *frame-delay* (float (/ 1000 *fps-limit*) 1.0))

(defparameter *last-render-time* 0)
#|
(defmethod glut:idle ((window opencl-boids-window))
  (let ((current-time (* 0.001 (get-internal-real-time))))
    (glut:schedule-timer (round (+ current-time *frame-delay*)) #'glut:post-redisplay)))

(defmethod glut:idle ((window opencl-boids-window))
  (let ((current-time (* 0.001 (get-internal-real-time))))
    (if (> current-time (+ *last-render-time* *frame-delay*))
        (progn
          #'glut:post-redisplay
          (setf *last-render-time* current-time)))))

(defmethod glut:idle ((window opencl-boids-window))
  (glut:post-redisplay))
|#

#|



(defun recalc-aspect (width height)
  "recalc and set *gl-x-aspect* and *gl-y-aspect*"
  (setf *gl-x-aspect* (numerator (/ width height)))
  (setf *gl-y-aspect* (denominator (/ width height)))
  (list :x-aspect *gl-x-aspect* :y-aspect *gl-y-aspect*))
|#

;;; (recalc-aspect 1600 900)

(defmethod set-viewport ((window opencl-boids-window))
  (with-slots (gl-halign gl-width gl-height
               gl-valign gl-aspect gl-scale glut:width glut:height viewport)
      window
    (let* ((w-aspect (/ glut:width glut:height))
           (vwidth (* gl-scale (if (> w-aspect gl-aspect) (* glut:height gl-aspect) glut:width)))
           (vheight (* gl-scale (if (< w-aspect gl-aspect) (/ glut:width gl-aspect) glut:height)))
           (hoffs (case gl-halign
                    (:center (/ (- glut:width (* gl-scale vwidth)) 2))
                    (:right (- glut:width (* gl-scale vwidth)))
                    (otherwise 0)))
           (voffs (case gl-valign
                    (:center (/ (- glut:height (* gl-scale vheight)) 2))
                    (:top (- glut:height (* gl-scale vheight)))
                    (otherwise 0))))
      (apply #'gl:viewport (setf viewport (list hoffs voffs vwidth vheight))))))

(defmethod glut:reshape ((window opencl-boids-window) width height)  
    (setf (glut:width window) width
          (glut:height window) height
          *width* width
          *height* height)
  (glut:reshape-window width height)
  (set-viewport window))

(defun zoom (scale window &key halign valign)
  (with-slots (gl-valign gl-halign gl-scale) window
    (when halign (setf gl-halign halign))
    (when valign (setf gl-valign valign))
    (setf gl-scale scale)
    (set-viewport window))) 

;;; (zoom 1.0 *win*)
;;; (reshape 1.0 *win*)

;;; (setf (gl-scale *win*) 0.5)
;;; (setf (gl-valign *win*) :center)
;;; (setf (gl-halign *win*) :center)



(defmethod glut:keyboard ((window opencl-boids-window) key x y)
  (declare (ignore x y))
  (when (eql key #\Esc)
    (glut:destroy-current-window))
  (when (eql key #\r)
    (continuable
      (format t "r pressed!~%")
      (reload-programs window)))
  (when (eql key #\f)
    (setf *show-fps* (not *show-fps*)))
  (when (eql key #\k)
    (continuable
      (set-kernel window)))
  (when (eql key #\space)
    (continuable
      (toggle-update)))
  (when (eql key #\c)
    (continuable
      (dolist (bs (systems window))
        (setf (boid-count bs) 0)))))



#|
(defmethod glut:passive-motion ((window opencl-boids-window) x y)
  (let ((bs (first (systems window))))
    (setf (mouse-x window) x)
    (setf (mouse-y window) y)
;;       (format t "~a ~a~%" x y)
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4 :write t)
          (ocl:with-mapped-buffer (p2 (car (command-queues window)) (obstacles-type bs) 1 :read t)
            (if (= (cffi:mem-aref p2 :int 0) 1)
                (progn
                  (setf (cffi:mem-aref p1 :float 0) (float x 1.0))
                  (setf (cffi:mem-aref p1 :float 1) (float (- (glut:height window) y) 1.0)))))))))

(defun get-mouse-player-ref ()
  (let ((id (aref *obstacle-ref* 4)))
    (if id
        (loop for idx below 4
           for ref across *obstacle-ref*
           until (and ref (= ref id))
           finally (return idx)))))

;;; (get-mouse-player-ref)
|#

;;(new-obstacle *win* 300 800 50)
;;(new-predator *win* 600 200 20)
;; (num-obstacles (first (systems *win*)))

;;(delete-obstacle *win* 0)

(defun set-num-boids (num)
  (setf (val (num-boids *bp*)) num))

;; todo: Korrigieren für Zoom und alignment!

(defun mouse->gl (window mouse-x mouse-y)
  "transform screen coords to gl coords with 0,0 on top left corner."
  (with-slots (gl-scale gl-width gl-height viewport) window
    (destructuring-bind (x-offs y-offs vwidth vheight) viewport
      ;; (format t "mouse->gl: ~a ~a ~a ~a ~a ~a ~a ~a ~a~%~a~%"
      ;;         mouse-x mouse-y gl-scale gl-width gl-height x-offs y-offs vwidth vheight
      ;;         (list
      ;;  (float (* (/ gl-width vwidth) (/ gl-scale) (- mouse-x x-offs)))
      ;;  (float (* -1 (/ gl-height vheight) (/ gl-scale) (- mouse-y y-offs)))))
      (list
       (float (* (/ gl-width vwidth) (/ gl-scale) (- mouse-x x-offs)))
       (float (* -1 (/ gl-height vheight) (/ gl-scale) (- mouse-y y-offs)))))))

(defun mouse->gl-fn (window)
  "transform screen coords to gl coords."
  (let (gl-x gl-y)
    (with-slots (glut:width glut:height gl-scale gl-width gl-height gl-aspect
                 gl-halign gl-valign)
        window
      (lambda (x y)
        (if (> (/ glut:width glut:height) gl-aspect)
            (let ((vwidth (* glut:height gl-aspect))) ;;; pixelbreite
              (setf gl-x
                    (case gl-halign
                      (:center (max 0 (min gl-width (* (- x (/ (- glut:width vwidth) 2))
                                                       (/ gl-width vwidth)))))
                      (:right (max 0 (* (- x (- glut:width vwidth))
                                        (/ gl-width vwidth))))
                      (otherwise (min gl-width (* x (/ gl-width vwidth))))))
              (setf gl-y (* y (/ gl-height glut:height))))
            (let ((vheight (* glut:width (/ gl-aspect)))) ;;; pixelhöhe
              (setf gl-x (* x (/ gl-width glut:width)))
              (setf gl-y
                    (case gl-valign
                      (:center (max 0 (min gl-height
                                           (* (- y (/ (- glut:height vheight) 2))
                                              (/ gl-height vheight)))))
                      (:top (min gl-height (* (- y (- 1 gl-scale)) (/ gl-height vheight))))
                      (otherwise (+ (- glut:height gl-height)
                                    (* y (/ gl-height vheight))))))))
        (list (float gl-x) (float (* -1 gl-y)) 0.0 0.0)))))

#|
0 0 ist oben links
(setf (gl-valign *win*) :center)
width: Bildschirmbreite in pixeln
vw: pixel breite des gl windows
gl-width: gl breite
gl-scale: Skalierung der gl-koordinaten

(setf (gl-scale *win*) 0.8)

|#

(defmethod glut:mouse ((window opencl-boids-window) button state x y)
  (continuable
    ;; (when (eql button :wheel-down)
    ;;   (set-zoom (* *zoom* 0.99)))
    ;; (when (eql button :wheel-up)
    ;;   (set-zoom (* *zoom* 1.0101)))
;;;    (format t "~a ~a ~S~%" button state (equal (list :active-ctrl) (glut:get-modifiers)))
    (format t ".")
    (case button
      (:left-button
       (when (eql state :down)
         (with-slots (gl-scale) window
           (format t "systems: ~d~%" (length (systems window)))
           (if (zerop (length (systems window)))
               (progn
                 (push (make-boid-system
                        `(,(float (/ x gl-scale) 1.0) ,(float (* -1 (/ y gl-scale)) 1.0) 0.0 0.0)
                        (val (boids-per-click *bp*))
                        window)
                       (systems window))
                 (format t "added new boid system, ~s total~%" (length (systems window))))
               (destructuring-bind (gl-x gl-y) (mouse->gl window x y)
                 (when (and (<= 0 gl-x (gl-width window))
                            (<= (* -1 (gl-height window)) gl-y 0 ))
                   (add-to-boid-system
                    `(,gl-x ,gl-y 0.0 0.0)
;;;               `(,(float (/ x gl-scale) 1.0) ,(float (* -1 (/ y gl-scale)) 1.0) 0.0 0.0)
                    (val (boids-per-click *bp*))
                    window)
                   (format t "~&added new boids at: ~a ~a ~a~%" x y (mouse->gl window x y))))))
         (set-num-boids (reduce #'+ (systems window) :key 'boid-count))
         (format t "total = ~:d boids~%" (val (num-boids *bp*)))))
      (:wheel-down (when (and (equal (list :active-ctrl) (glut:get-modifiers))
                              (eql state :down))
                     (zoom (* (gl-scale window) 95/100) window)))
      (:wheel-up (when (and (equal (list :active-ctrl) (glut:get-modifiers))
                            (eql state :down))
                   (zoom (* (gl-scale window) 100/95) window)))
      (:right-button (when (and (equal (list :active-ctrl) (glut:get-modifiers))
                              (eql state :down))
                     (zoom 1.0 window))))
      ;; (when (and (eql button :right-button) (eql state :down))
    ;;   (push (make-boid-system
    ;;          `(,(float x 1.0) ,(float (* -1 y) 1.0) 0.0 0.0)
    ;;          *boids-per-click*
    ;;          window)
    ;;         (systems window))
    ;;   (format t "added boid system, ~s total~%" (length (systems window)))
    ;;   (format t " = ~:d boids~%" (reduce #'+ (systems window) :key 'boid-count)))
    ))

(defmethod glut:close ((window opencl-boids-window))
  (format t "window closed, cleaning up...~%")
;;  (clear-systems window)
  ;; (loop while *buffers*
  ;;    do (release-mem-object (pop *buffers*)))
  ;; (loop while *command-queues*
  ;;       do (release-command-queue (pop *command-queues*)))
  ;; (format t "context: ~a" *context*)
  ;; (when *context* (release-context *context*))
  ;; (setf *context* nil)
  )

(defparameter *win* nil)
(defparameter *queue* nil)

(defun boid-window (device &key pos-x pos-y (width 1600) (height 900)
                             (gl-width 1600) (gl-height 900))
  (let ((win (make-instance 'opencl-boids-window :device device :width width :height height
                                                 :gl-width gl-width :gl-height gl-height
                                                 :gl-aspect (/ gl-width gl-height)
                                                 :tick-interval 16)))
    (unwind-protect
         (setf *win* win)
      (format t "~&displaying window...~%")
      (setf (glut:pos-x win) pos-x)
      (setf (glut:pos-y win) pos-y)
      (glut:display-window win)
      (format t "~&clearing systems...~%")
      (clear-systems win))))

(defun ensure-platform ()
  "ensure that platform with gl sharing exists and return it."
  (or (loop for platform in (get-platform-ids)
            if (loop for device in (get-device-ids platform :all)
                     if (or (and (not *sharing*)
                                 (member :gpu (get-device-info device :type)))
                            (device-extension-present-p device "cl_APPLE_gl_sharing")
                            (device-extension-present-p device "cl_khr_gl_sharing"))
                       return t)
              return platform)
      (error "no openCL platform with cl_khr_gl_sharing found")))

#|
(elt (get-platform-ids) 1)
(loop for device in
     (loop for platform in (get-platform-ids)
        append (get-device-ids platform :all))
   collect
     (or (device-extension-present-p device "cl_APPLE_gl_sharing")
         (device-extension-present-p device "cl_khr_gl_sharing")))

(ensure-platform)

(member :gpu (get-device-info (first (get-device-ids (second (get-platform-ids)) :all)) :type))

(get-platform-info (second (get-platform-ids)) :vendor)

(let ((device (first (get-device-ids (second (get-platform-ids)) :all))))
   (list (device-extension-present-p device "cl_khr_gl_sharing")
(get-device-info (first (get-device-ids (second (get-platform-ids)) :all)) :vendor)))

(gl:get-string :vendor)

(member :gpu (get-device-info (first (get-device-ids (second (get-platform-ids)) :all)) :type))

|#  

(defun boids (&key (width 1600) (height 900) (pos-x 0) (pos-y 0)
                (gl-width 1600) (gl-height 900))
  (setf *platform* (ensure-platform))
  (let* ((device (car (get-device-ids *platform* :all))))
    (format t "using ~s / ~s, version ~s~% GL context sharing extension available.~%"
            (get-platform-info *platform* :vendor)
            (get-platform-info *platform* :name)
            (get-platform-info *platform* :version))
    (format t "device id = ~s (~s)~%" device (get-device-info device :type))
    (let ((*programs* nil)
          (*context* nil)
          (*kernels* nil)
          (*command-queues* nil)
          (*buffers* nil))
      (with-fps-vars ()
        (unwind-protect
             (boid-window device :width width :height height
                          :gl-width gl-width :gl-height gl-height
                                 :pos-x pos-x :pos-y pos-y)
          (mapc 'release-kernel *kernels*)
          (mapc 'release-program *programs*)
          (mapc 'release-command-queue *command-queues*)
          (mapc 'release-mem-object *buffers*)
          (when *context*
            (release-context *context*)
            (setf *context* nil))))
      (format t "done...~%"))))

(defun show-vecs (a)
  (loop
     for count from 0
     for vec in (ou:group (coerce a 'list) 4)
     do (format t "~4,' d: ~a~%" count vec)))

(defun show-vals (a)
  (loop
     for count from 0
     for vec in (coerce a 'list)
     do (format t "~4,' d: ~a~%" count vec)))

(defun show-positions (a &key (pixelsize 5))
  (loop
     for count from 0
     for vec in (ou:group (coerce a 'list) 4) by #'cddddr
     do (format t "~&~4,' d: ~a ~a~%" count vec (list (floor (first vec) pixelsize)
                                                 (floor (second vec) pixelsize)))))

(defun toggle-update ()
  (setf *update* (not *update*)))



#|
#++
(boids :width 1280 :height 960)
#++
(boids :width 1200 :height 900)

#++
(glut:main-loop)
|#

