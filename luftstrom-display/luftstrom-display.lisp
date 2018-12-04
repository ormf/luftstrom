;;;; luftstrom-display.lisp

(in-package #:cl-boids-gpu)

;;; (boids :width 1200 :height 900)
;;; (incudine:rt-stop)

(defparameter *change-boid-num* nil)

;;; (setf *boids-per-click* 1000)
(setf *print-case* :downcase)

(defun %update-system (window bs)
  (let ((command-queue (car (command-queues window)))
        (pixelsize (pixelsize bs))
        (width (glut:width window))
        (height (glut:height window))
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
    (if (> count 0)
        (let
            ((pos (boid-coords-buffer bs)))
          (set-kernel-args cb-kernel (weight-board align-board obstacle-board obstacles-pos
                                                   obstacles-radius obstacles-lookahead
                                                   ((make-obstacle-mask) :uint)
                                                   ((round num-obstacles) :int)
                                                   ((round pixelsize) :int) ((round (/ width pixelsize)) :int)
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

                              (round *maxidx*) (float *length* 1.0) (float *speed* 1.0)
                              (x bs) (y bs) (z bs) (float *maxspeed* 1.0) (float *maxforce* 1.0)
                              (float *alignmult* 1.0) (float *sepmult* 1.0)
                              (float *cohmult* 1.0) (float *maxlife* 1.0) (float *lifemult* 1.0)
                              (round count) (round pixelsize) (round width)(round height)))
                (setf *test* nil)))
          (decf *clock*)
          (set-kernel-args kernel
                           (pos vel forces bidx life retrig color weight-board align-board
                                board-dx board-dy dist coh sep obstacle-board obstacles-pos obstacles-radius obstacles-type
                                obstacles-boardoffs-maxidx obstacles-lookahead obstacles-multiplier
                                ((round num-obstacles) :int)
                                ((if (<= *clock* 0) 1 0) :int)
                                ((round *maxidx*) :int) ((float *length* 1.0) :float) ((float *speed* 1.0) :float)
                                ((x bs) :float) ((y bs) :float) ((z bs) :float)
                                ((float *maxspeed* 1.0) :float)
                                ((float *maxforce* 1.0) :float)
                                ((float *alignmult* 1.0) :float)
                                ((float *sepmult* 1.0) :float)
                                ((float *cohmult* 1.0) :float)
                                ((float *maxlife* 1.0) :float)
                                ((float *lifemult* 1.0) :float)
                                ((round count) :int)
                                ((round pixelsize) :int)
                                ((round width) :int)
                                ((round height) :int)))
          (enqueue-nd-range-kernel command-queue kernel count)
          (finish command-queue)

          (setf *num-boids* (boid-count bs))
          ;;    (setf *positions* (boid-coords-buffer bs))
          (setf *positions* (if (> *num-boids* 0)
                                (enqueue-read-buffer command-queue pos
                                                     (* 16 (boid-count bs)))))
          (setf *velocities* (if (> *num-boids* 0)
                                 (enqueue-read-buffer command-queue vel
                                                      (* 4 (boid-count bs)))))
          (setf *obstacle-board* (if (> *num-boids* 0)
                                     (enqueue-read-buffer command-queue obstacle-board
                                                          (round (* (/ width pixelsize) (/ height pixelsize)))
                                                          :element-type '(unsigned-byte 32))))
          (setf *forces* (if (> *num-boids* 0)
                             (enqueue-read-buffer command-queue forces
                                                  (* 4 (boid-count bs)))))
          (setf *life* (if (> *num-boids* 0)
                           (enqueue-read-buffer command-queue life
                                                (boid-count bs))))
          (setf *retrig* (if (> *num-boids* 0)
                             (enqueue-read-buffer command-queue retrig
                                                  (* 4 (boid-count bs))
                                                  :element-type '(signed-byte 32))))
          (setf *bidx* (if (> *num-boids* 0)
                           (enqueue-read-buffer command-queue bidx
                                                (boid-count bs)
                                                :element-type '(signed-byte 32))))
          (setf *colors* (if (> *num-boids* 0)
                             (enqueue-read-buffer command-queue color
                                                  (* 4 (boid-count bs)))))
          (setf *obstacles-pos* (if (> num-obstacles 0)
                                    (enqueue-read-buffer command-queue obstacles-pos
                                                         (* 4 num-obstacles))))
          (setf *obstacles-radius* (if  (> num-obstacles 0)
                                        (enqueue-read-buffer command-queue obstacles-radius
                                                             num-obstacles
                                                             :element-type '(signed-byte 32))))
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
          (finish command-queue)
          (luftstrom-display::send-to-audio *retrig* *positions* *velocities*)
          ))
    (if *change-boid-num*
        (apply #'add-boids (pop *change-boid-num*)))))

;;; (push 400 *change-boid-num*)

;;; (setf *change-boid-num* nil)

(defun reshuffle-life (win &key (regular nil))
  (let* ((bs (first (systems win)))
         (command-queue (first (command-queues win)))
         (life-buffer (life-buffer bs))
         (count (boid-count bs)))
    (ocl:with-mapped-buffer (p3 command-queue life-buffer count :write t)
      (loop
        for k below count
        do (setf (cffi:mem-aref p3 :float k)
                 (float
                  (if regular
                      (max 0.01 (* *maxlife* (/ k count)))
                      (max 0.01 (* (random 1.0) *maxlife*)))
                   1.0))))))

;;; (reshuffle-life *win* :regular nil)

(defun add-to-boid-system (origin count win
                           &key (maxcount *boids-maxcount*) (length *length*)
                             (trig *trig*))
  (let* ((bs (first (systems win)))
         (vbo (vbo bs))
         (vel (velocity-buffer bs))
         (life-buffer (life-buffer bs))
         (retrig-buffer (retrig-buffer bs))
         (boid-count (boid-count bs))
         (vertex-size 2)  ;;; size of boid-coords
         (command-queue (first (command-queues win))))
    (setf count (min count (- maxcount (boid-count bs))))
;;;    (break "vbo: ~a" vbo)
    (unless (or (zerop vbo) (zerop count))
      (progn
        (gl:bind-buffer :array-buffer vbo)
        (gl:with-mapped-buffer (p1 :array-buffer :read-write)
          (ocl:with-mapped-buffer (p2 command-queue vel (* 4 (+ boid-count count)) :write t)
            (ocl:with-mapped-buffer (p3 command-queue life-buffer (+ boid-count count) :write t)
              (ocl:with-mapped-buffer (p4 command-queue retrig-buffer (+ boid-count count) :write t)
                (loop repeat count
                   for i from (* 4 (* 2 vertex-size) boid-count) by (* 4 (* 2 vertex-size))
                   for j from (* 4 boid-count) by 4
                   for k from boid-count
                   for a = (float (random +twopi+) 1.0)
                   for v = (float (+ 0.1 (random 0.8)) 1.0) ;; 1.0
                   do (let ()
                        (set-array-vals p2 j (* v *maxspeed* (sin a)) (* v *maxspeed* (cos a)) 0.0 0.0)
                        (apply #'set-array-vals p1 (+ i 0) origin)
                        (apply #'set-array-vals p1 (+ i 8) (mapcar #'+ origin
                                                                   (list (* -1 length (sin a))
                                                                         (* -1 length (cos a)) 0.0 1.0)))
                        (let ((color (if (zerop i) *first-boid-color* *fg-color*)))
                          (apply #'set-array-vals p1 (+ i 4) color)
                          (apply #'set-array-vals p1 (+ i 12) color))
                        (setf (cffi:mem-aref p3 :float k)
                              (float (if trig
                                         (max 0.01 (* (random (max 0.01 *lifemult*)) 8))
                                         (max 0.01 (* (+ 0.7 (random 0.2)) *maxlife*))
                                         )
                                     1.0))
                        (setf (cffi:mem-aref p4 :int (* k 4)) 0) ;;; retrig
                        (setf (cffi:mem-aref p4 :int (+ (* k 4) 1)) -2) ;;; obstacle-idx for next trig
                        (setf (cffi:mem-aref p4 :int (+ (* k 4) 2))
                              (if trig 0 20)) ;;; frames since last trig
                        (setf (cffi:mem-aref p4 :int (+ (* k 4) 3)) 0) ;;; time since last obstacle-induced trigger
                        ))))))
        (incf (boid-count bs) count)
        (setf *num-boids* (boid-count bs))
        (luftstrom-display::set-value :num-boids *num-boids*)))
    bs))

;;; (setf *trig* nil)

(defmacro obstacle-refcopy (src target)
  `(setf (luftstrom-display::obstacle-ref (luftstrom-display::obstacle ,target))
         (luftstrom-display::obstacle-ref (luftstrom-display::obstacle ,src))))

(defmacro set-mouse-ref (player)
  `(setf luftstrom-display::*mouse-ref* ,player))

(defmacro clear-mouse-ref ()
  `(setf luftstrom-display::*mouse-ref* nil))

(defmacro get-obstacle-ref (player)
  `(luftstrom-display::obstacle-ref (luftstrom-display::obstacle ,player)))

(defun get-mouse-player-ref ()
  luftstrom-display::*mouse-ref*)

(defmethod glut:passive-motion ((window opencl-boids-window) x y)
  (let* ((bs (first (systems window)))
         (mouse-player-ref (get-mouse-player-ref))
         (mouse-obstacle (and mouse-player-ref (luftstrom-display::obstacle mouse-player-ref))))
    (setf (mouse-x window) x)
    (setf (mouse-y window) y)
;;       (format t "~a ~a ~a~%" x y mouse-obstacle)
    (if (and bs mouse-obstacle (luftstrom-display::obstacle-active mouse-obstacle))
        (progn
          (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                      :offset (* +float4-octets+
                                                 (luftstrom-display::obstacle-ref mouse-obstacle))
                                      :write t)
            (ocl:with-mapped-buffer (p2 (car (command-queues window)) (obstacles-type bs) 1 :read t)
              (setf (cffi:mem-aref p1 :float 0) (float x 1.0))
              (setf (cffi:mem-aref p1 :float 1) (float (- (glut:height window) y) 1.0))))))))

(defmethod glut:keyboard ((window opencl-boids-window) key x y)
  (declare (ignore x y))
  (when (eql key #\Esc)
    (glut:destroy-current-window))
  (when (eql key #\r)
    (continuable
      (reload-programs window)))
  (when (eql key #\1)
    (set-mouse-ref 0))
  (when (eql key #\2)
    (set-mouse-ref 1))
  (when (eql key #\3)
    (set-mouse-ref 2))
  (when (eql key #\4)
    (set-mouse-ref 3))
  (when (eql key #\0)
    (clear-mouse-ref))
  (when (eql key #\f)
    (setf *show-fps* (not *show-fps*)))
  (when (eql key #\a)
    (luftstrom-display::toggle-obstacle luftstrom-display::*mouse-ref*))
  (when (eql key #\k)
    (continuable
      (set-kernel window)))
  (when (eql key #\space)
    (continuable
      (toggle-update)))
  (when (eql key #\c)
    (continuable
      (dolist (bs (systems window))
        (setf (boid-count bs) 0))
      (luftstrom-display::set-value :num-boids 0))))

(defun is-active? (idx)
  (loop for o across *obstacles*
     until (= (luftstrom-display::obstacle-ref o) idx)
     finally (return (luftstrom-display::obstacle-active o))))

;;; (is-active? 0)

;; (update-get-obstacles *win*)

(defun draw-obstacles (window)
  (dolist
      (obstacle (update-get-obstacles window))
     ;;          (format t "~a" (first obstacle))
    (case (first obstacle)
      (0 (apply #'no-interact-circle (rest obstacle)))
      (1 (apply #'obstacle-circle (rest obstacle)))
      (2 (apply #'plucker-circle  (rest obstacle)))
      (3 (apply #'attractor-circle (rest obstacle)))
      (4 (apply #'predator-circle  (rest obstacle))))))

;;; (get-mouse-player-ref)

;;; (luftstrom-display::netconnect)
;;;      (luftstrom-display::set-obstacles *obstacles*)

#|

(setf *test* t)
 (format t "~&display~%")
|#


(defun move-obstacle-abs (x y player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player))
                                    :write t)
          (setf (cffi:mem-aref p1 :float 0) (float x 1.0))
          (setf (cffi:mem-aref p1 :float 1) (float (- (glut:height window) y) 1.0))))))


(defun move-obstacle-norm-x (x player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 0) (float (* x *width*) 1.0))))))

(defun move-obstacle-norm-y (y player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 1) (float (* y *height*) 1.0))))))

(defun move-obstacle-rel-y (dy player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 1)
                (float (clip (+ (cffi:mem-aref p1 :float 1) dy) 0 *height*)))))))

(defun move-obstacle-rel-x (dx player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 0)
                (float (clip (+ (cffi:mem-aref p1 :float 0) dx) 0 *width*)))))))

(defun clip (val vmin vmax)
  (min vmax (max val vmin)))

(defun timer-add-boids (total-num boids-per-click  &optional origin)
  (let ((dtime (/ 0.5 (/ total-num boids-per-click))))
    (cm::sprout
     (cm::process
       cm::with remain = total-num 
       cm::while (> remain boids-per-click)
       cm::do (progn
                (push (cons boids-per-click origin) *change-boid-num*)
                (decf remain boids-per-click))
       cm::finally (if (> remain 0)
                       (push (cons remain origin) *change-boid-num*))
       cm::wait dtime))))

(defun add-boids (num &optional origin)
  (add-to-boid-system
   (if origin (append origin '(0.0 0.0))
       `(,(float (random *width*)) ,(float (* -1 (random *height*)) 1.0) 0.0 0.0))
   num
   *win*
   :maxcount *boids-maxcount*
   :length *length*)
  (set-num-boids (reduce #'+ (systems *win*) :key 'boid-count)))

(defun timer-remove-boids (total-num boids-per-click &key (fadetime 0.5))
  (let ((dtime (/ fadetime (/ total-num boids-per-click))))
    (cm::sprout
     (cm::process
       cm::with remain = total-num 
       cm::while (> remain boids-per-click)
       cm::do (progn
                (remove-boids boids-per-click)
                (decf remain boids-per-click))
       cm::finally (if (> remain 0)
                       (remove-boids remain))
       cm::wait dtime))))

(defun remove-boids (num)
  (let* ((bs (first (systems *win*)))
         (count (boid-count bs)))
    (setf (boid-count bs) (max 0 (- count num)))
    (set-num-boids (reduce #'+ (systems *win*) :key 'boid-count))))

#|
(defparameter *bs* (first (systems *win*)))


(setf *trig* nil)
(setf *trig* t)
(timer-add-boids 500 1)

(timer-remove-boids 300 100)

(timer-add-boids 300 100)
                                      ;

(remove-boids 100)
|#
