;;; luftstrom-display.lisp

(in-package #:cl-boids-gpu)

(defparameter *change-boid-num* nil)
(defparameter *switch-to-preset* nil)
(defparameter *bs* nil)
(setf *print-case* :downcase)

(defparameter *gl-queue* (make-mailbox))

(defparameter *nan-error* nil)


(defun gl-enqueue (fn)
  (mailbox-send-message *gl-queue* fn))

(defun gl-dequeue (win bs)
  (multiple-value-bind (fn ok) (mailbox-receive-message-no-hang *gl-queue*)
    (when ok
;;;      (format t "dequeuing... ~a~%" bs)
      (let ((*win* win) (*bs* bs))
        (declare (ignorable *win* *bs*))
        (funcall fn)
        (gl-dequeue win bs)))))

;;; (gl-enqueue (lambda () (restore-bs-from-preset 40)))

;;; (gl-dequeue)
(export '(gl-enqueue restore-bs-from-preset) 'cl-boids-gpu)

(defun show-positions (win)
  (let* ((command-queue (first (cl-boids-gpu::command-queues win)))
         (bs (first (cl-boids-gpu::systems win)))
         (pos (cl-boids-gpu::boid-coords-buffer bs))
         (num-boids (boid-count bs))
         tmpbuf)
    (setf tmpbuf (enqueue-read-buffer command-queue pos (* 16 num-boids)))
    (finish command-queue)
    (break "tmpbuf: ~a, num-boids: ~a" (subseq tmpbuf 0 64) num-boids)))

;;; (gl-enqueue (lambda () (show-positions *win*)))

(defmacro format-state ()
  `(progn
     (format t "bs-preset-state: ~&~{~&~{~a: ~a~}~%~}"
             `(("pos" ,pos)
               ("vel" ,vel)
               ("forces" ,forces)
               ("bidx" ,bidx)
               ("life" ,life)
               ("color" ,color)
               ("weight-board" ,weight-board)
               ("align-board" ,align-board)
               ("board-dx" ,board-dx)
               ("board-dy" ,board-dy)
               ("dist" ,dist)
               ("coh" ,coh)
               ("sep" ,sep)
               ("obstacle-board" ,obstacle-board)
               ("obstacles-pos" ,obstacles-pos)
               ("obstacles-radius" ,obstacles-radius)
               ("obstacles-boardoffs-maxidx" ,obstacles-boardoffs-maxidx)
               ("num-obstacles" ,num-obstacles)                  
               ("num-boids" ,num-boids)
               ("(round maxidx)" ,(round maxidx))
               ("(float length 1.0)" ,(float length 1.0))
               ("(float speed 1.0)" ,(float speed 1.0))
               ("(x bs)" ,(x bs))
               ("(y bs)" ,(y bs))
               ("(z bs)" ,(z bs))
               ("(float maxspeed 1.0)" ,(float maxspeed 1.0))
               ("(float maxforce 1.0)" ,(float maxforce 1.0))
               ("(float alignmult 1.0)" ,(float alignmult 1.0))
               ("(float sepmult 1.0)" ,(float sepmult 1.0))
               ("(float cohmult 1.0)" ,(float cohmult 1.0))
               ("(float maxlife 1.0)" ,(float maxlife 1.0))
               ("(float lifemult 1.0)" ,(float lifemult 1.0))
               ("(round count)" ,(round count))
               ("(round pixelsize)" ,(round pixelsize))
               ("(round width)" ,(round width))
               ("(round height)" ,(round height))))
     (setf *check-state* nil)))

;;; (setf *check-state* t)

(defparameter *bs-retrig* t)
;;; (setf *bs-retrig* nil)

(defun speed->maxspeed (speed)
  (* speed 1.05))

(defun speed->maxforce (speed)
  (* speed 0.09))

;;;(speed->maxforce 200)
(defun cp-pos-to-gl-buf (pos gl-buffer count)
     (dotimes (i count)
       (setf (gl:glaref gl-buffer i) (float (elt pos i) 1.0)))  )

(defparameter *test* nil)
#|

|#

(defmethod glut:tick ((window opencl-boids-window))
  (glut:post-redisplay))

#|
(defmethod glut:idle ((window opencl-boids-window))
  (glut:post-redisplay))
;;; (glut:post-redisplay)
|#

(defun get-gl-data (gl-buffer elt-size count &key (offset 0) (bytes-per-element 4) (element-type 'single-float))
  (let ((array (make-array (* elt-size count) :element-type element-type)))
    (with-bound-buffer (:array-buffer gl-buffer)
                       (cffi:with-pointer-to-vector-data (p array)
                         (%gl:get-buffer-sub-data :array-buffer offset (* elt-size bytes-per-element count) p)
                         array))))

(defun vel-array-max (l)
  (loop for i from 0 below (length l) by 4
        with max = 0
        for x = (aref l i)
        for y = (aref l (1+ i))
        do (let ((len (sqrt (+ (* x x) (* y y)))))
             (when (> len max) (setf max len)))
        finally (return max)))

(defparameter *curr-max-velo* 0)

(defparameter *pd-out*
  (incudine.osc:open
   :direction :output
   :host "127.0.0.1" :port 3002))

(defun %update-system (window bs)
  (let (
;;;        (update-start-time (get-internal-real-time))
        )
    (if (and bs (not *nan-error*))
        (let ((command-queue (car (command-queues window)))
              (pixelsize (pixelsize bs))
              (width *gl-width*)
              (height *gl-height*)
;;;              (vel2 (velocity-buffer2 bs))
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
              (calc-boid-kernel (find-kernel *curr-kernel*))
              (count (boid-count bs)))
          (gl-dequeue window bs)
          (if (> count 0)
              (with-model-slots (speed maxidx length alignmult sepmult cohmult maxlife lifemult num-boids) *bp*
                (let
                    ((maxspeed (speed->maxspeed speed))
                     (maxforce (speed->maxforce speed)))
                  (set-kernel-args
                   cb-kernel
                   (weight-board align-board obstacle-board obstacles-pos
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
                  (enqueue-nd-range-kernel command-queue cw-kernel count)
                  (finish command-queue)
                  (set-kernel-args calc-boid-kernel
                                   (pos vel forces bidx life retrig color weight-board align-board
                                        board-dx board-dy dist coh sep obstacle-board obstacles-pos
                                        obstacles-radius obstacles-type
                                        obstacles-boardoffs-maxidx obstacles-lookahead obstacles-multiplier
                                        ((round num-obstacles) :int)
                                        ((if (<= *clock* 0) 1 0) :int)
                                        ((round maxidx) :int)
                                        ((float length 1.0) :float)
                                        ((float speed 1.0) :float)
                                        ((x bs) :float)
                                        ((y bs) :float)
                                        ((z bs) :float)
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
                  (enqueue-nd-range-kernel command-queue calc-boid-kernel count)
                  (finish command-queue)
                  (if (<= *clock* 0)
                      (setf *clock* (val (cl-boids-gpu::clockinterv *bp*)))
                      (decf *clock*))
                  (with-slots (bs-num-boids bs-positions bs-velocities bs-life bs-retrig
                               bs-color bs-obstacles)
                      luftstrom-display::*curr-boid-state*
;;; *obstacles* (ou:ucopy *obstacles*)
                    (setf bs-num-boids (boid-count bs))
                    (if *check-state* (format-state))
                    (if (and (> (val (num-boids *bp*)) 0)
                             (> (boid-count bs) 0))
                        (get-all-gpu-data bs command-queue luftstrom-display::*curr-boid-state*))
                    (setf bs-obstacles *obstacles*)
                    (if *check-state* (format-state))
                    (luftstrom-display::send-to-audio bs-retrig bs-positions bs-velocities)))))
          (setf *check-state* nil)
          (if *change-boid-num*
              (apply #'add-boids window (pop *change-boid-num*))))
        (format t "no bs!"))))

(setf *check-state* t)

(defparameter *tnum* 0)
(defparameter *retrig* nil)
(defparameter *triggers* nil)
;;; (setf *check-state* nil)
;;; (push 400 *change-boid-num*)

;;; (setf *lifemult* 200)

;;; (setf *change-boid-num* nil)



;;; (gl-enqueue (lambda ()(reshuffle-life *win* :regular nil)))

(defun reset-life (win mode &optional (max 15000))
  (let* ((bs (first (systems win)))
         (command-queue (first (command-queues win)))
         (life-buffer (life-buffer bs))
         (pos-buffer (boid-coords-buffer bs))
         (count (boid-count bs)))
    (ocl:with-mapped-buffer (p-life command-queue life-buffer count :write t)
      (ocl:with-mapped-buffer (p-pos command-queue pos-buffer (* 16 count) :read t)
        (loop
          for k below count
          for x = (cffi:mem-aref p-pos :float (* k 16))
          for y = (cffi:mem-aref p-pos :float (1+ (* k 16)))
          with width = *gl-width*
          with height = *gl-height*
          do (progn
               (format t "(~a ~a ~a ~a ~a ~a ~a ~a ~a ~a ~a ~a ~a ~a ~a ~a)~%"
                       (cffi:mem-aref p-pos :float (* k 16))
                       (cffi:mem-aref p-pos :float (+ 1 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 2 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 3 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 4 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 5 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 6 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 7 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 8 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 9 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 10 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 11 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 12 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 13 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 14 (* k 16)))
                       (cffi:mem-aref p-pos :float (+ 15 (* k 16))))
               (setf (cffi:mem-aref p-life :float k)
                     (float
                      (case mode
                        (0 (ou:n-lin (/ (mod x width) width) 0 max))
                        (1 (ou:n-lin (/ (mod x width) width) max 0))
                        (2 (ou:n-lin (/ (mod y height) height) 0 max))
                        (3 (ou:n-lin (/ (mod y height) height) max 0))
                        (4 (ou:n-lin (/ (+ (/ (mod x width) width)
                                           (/ (mod y height) height))
                                        2)
                                     0 max))
                        (5 (ou:n-lin (/ (+ (/ (mod x width) width)
                                           (/ (mod y height) height))
                                        2)
                                     max 0))
                        (6 (ou:n-lin (/ (- (/ (mod x width) width)
                                           (- (/ (mod y height) height) 1))
                                        2)
                                     0 max))
                        (otherwise (ou:n-lin (/ (- (/ (mod x width) width)
                                                   (- (/ (mod y height) height) 1))
                                                2)
                                             max 0)))
                      1.0))))))
    (finish command-queue)))

;; (reset-life *win* 1 10000)

(defmethod glut:display-window :after ((w opencl-boids-window))
  (push (make-boid-system `(,(/ *gl-width* 2.0) ,(/ *gl-height* -2.0) 0.0 0.0) 1 w) (systems w))
  (continuable
    (dolist (bs (systems w))
      (setf (boid-count bs) 0))
    (luftstrom-display::at (+ (luftstrom-display::now) 0.5)
      (lambda ()
        (with-slots (cl-glut:width cl-glut:height) w
          (luftstrom-display::bp-set-value :num-boids 0)
          (luftstrom-display::gui-set-preset 0)
          (luftstrom-display::load-current-preset)

          ;; (luftstrom-display::handle-midi-in ;;; press leftmost "R" of nk2 (Luftstrom-display::ensure-controller :nk2) :cc 64 127)
;;;        (glut:reshape w 1280 720)
           (format t "~&reshape to ~ax~a" cl-glut:width cl-glut:height)
          (gl-enqueue (lambda () (glut:reshape w cl-glut:width cl-glut:height)))
           (format t "~&initialized!~%~%"))))))

(defun unbound (preset)
  (not (bs-num-boids preset)))

(defun copy-vector (vector p &optional (type :float))
  "copy the contents of vector to a foreign array at pointer p."
    (loop
      for x across vector
      for i from 0
      do (setf (cffi:mem-aref p type i) x)))

(defun restore-values-from-preset (obj &rest vals)
  (loop for val in vals
        do (luftstrom-display::bp-set-value val (slot-value obj val))))

;;; (luftstrom-display::bp-set-value :maxspeed 1.65)
;;; (setf *trig* nil)

(defmacro obstacle-refcopy (src target)
  `(setf (luftstrom-display::obstacle-ref (luftstrom-display::obstacle ,target))
         (luftstrom-display::obstacle-ref (luftstrom-display::obstacle ,src))))

(defmacro set-mouse-ref (player)
  `(setf luftstrom-display::*mouse-ref* ,(luftstrom-display::player-aref player)))

(defun get-mouse-ref ()
  luftstrom-display::*mouse-ref*)

(defmacro clear-mouse-ref ()
  `(setf luftstrom-display::*mouse-ref* nil))

(defmacro get-obstacle-ref (player)
  `(luftstrom-display::obstacle-ref (luftstrom-display::obstacle ,player)))

(defun get-mouse-player-ref ()
  luftstrom-display::*mouse-ref*)

(defmethod glut:passive-motion ((window opencl-boids-window) x y)
  (let* (;; (bs (first (systems window)))
         (mouse-player-ref (get-mouse-player-ref))
         ;; (mouse-obstacle (and mouse-player-ref
         ;;                      (luftstrom-display::obstacle mouse-player-ref)))
;;         (local-x (float (/ x (glut:width window))))
         ;; (local-y (float (/ (- (glut:height window) y) (glut:height window))))
         )
    (destructuring-bind (gl-x gl-y) (mouse->gl window x y)
      (when (and (<= 0 gl-x (gl-width window))
                 (<= 0 gl-y (gl-height window)))
        (let ((local-x (/ gl-x (gl-width window)))
              (local-y (/ gl-y (gl-height window))))
;;;          (format t "~a, ~a, ~a, ~a ~%" gl-x gl-y local-x local-y)
          (setf (val (boids-add-x *bp*)) local-x)
          (setf (val (boids-add-y *bp*)) local-y)
          (gl-enqueue (lambda () (set-obstacle-position window mouse-player-ref gl-x gl-y)))
          (setf (mouse-x window) x)
          (setf (mouse-y window) y)
          )))))

;;; (untrace)

;;; (deftype obstacle-type () '(member :predator :obstacle :react :attractor :nointeract))

(defconstant +nointeract+ 0)
(defconstant +obstacle+ 1)
(defconstant +trigger+ 2)
(defconstant +predator+ 3)
(defconstant +attractor+ 4)

(export '(+nointeract+ +obstacle+ +trigger+ +predator+ +attractor+) 'cl-boids-gpu)

(defun gl-set-obstacle-type (ref type)
  (when ref
    (setf (luftstrom-display::obstacle-type (luftstrom-display::obstacle ref)) type)
    (luftstrom-display::reset-obstacles)))

(defmethod glut:keyboard ((window opencl-boids-window) key x y)
  (declare (ignore x y))
  (when (eql key #\Esc)
    (glut:destroy-current-window))
  (when (eql key #\p)
    (continuable
      (reload-programs window)))
  (when (eql key #\q)
    (gl-set-obstacle-type (get-mouse-ref) +nointeract+))
  (when (eql key #\w)
    (gl-set-obstacle-type (get-mouse-ref) +trigger+))
  (when (eql key #\e)
    (gl-set-obstacle-type (get-mouse-ref) +obstacle+))
  (when (eql key #\r)
    (gl-set-obstacle-type (get-mouse-ref) +attractor+))
  (when (eql key #\t)
    (gl-set-obstacle-type (get-mouse-ref) +predator+))
  (when (eql key #\0)
    (clear-mouse-ref))
  (when (eql key #\1)
    (set-mouse-ref 0))
  (when (eql key #\2)
    (set-mouse-ref 1))
  (when (eql key #\3)
    (set-mouse-ref 2))
  (when (eql key #\4)
    (set-mouse-ref 3))
  (when (eql key #\5)
    (set-mouse-ref 4))
  (when (eql key #\f)
    (setf (show-fps window) (not (show-fps window))))
  (when (eql key #\#)
    (setf (show-frame window) (not (show-frame window))))
  (when (eql key #\a)
    (luftstrom-display::toggle-obstacle (get-mouse-ref)))
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
      (luftstrom-display::bp-set-value :num-boids 0)))
  (when (eql key #\^f)
    (setf (show-frame window) (not (show-frame window))))
  (when (eql key #\R)
    (continuable
      (reload-programs window)))
  (when (eql key #\^c)
    (glut:set-window 1)
    (format t "setting cursor in window: ~a...~%" (glut:get-window))
    (format t "cursor: ~a...~%" (glut:get-window-cursor))
    (glut:set-cursor :cursor-none)))

(defun is-active? (idx)
  (loop for o across *obstacles*
     until (= (luftstrom-display::obstacle-ref o) idx)
     finally (return (luftstrom-display::obstacle-active o))))

;;; (is-active? 0)


;; (update-get-active-obstacles *win*)

(defun draw-obstacles (window)
  (let ((obstacles (update-get-active-obstacles window)))
;;;    (format t "~a" (length obstacles))
    (dolist
        (obstacle obstacles)
      (case (first obstacle)
        (0 (apply #'no-interact-circle (rest obstacle)))
        (1 (apply #'obstacle-circle (rest obstacle)))
        (2 (apply #'plucker-circle  (rest obstacle)))
        (3 (apply #'attractor-circle (rest obstacle)))
        (4 (apply #'predator-circle  (rest obstacle)))))))

;;; (draw-obstacles *win*)

(defun draw-frame (window)
  (let ((line-width 2))
    (with-slots (gl-width gl-height) window
      (gl:push-matrix)
      (gl:load-identity)
      (gl:line-width line-width)
      (gl:color 0.5 0.5 0.5 1.0)
      (gl:polygon-mode :front-and-back :line)
      (gl:with-primitives :polygon   ; start drawing a polygon
        (gl:vertex 0.0 0.0 0.0)
        (gl:vertex 0.0 (float gl-height) 0.0)
        (gl:vertex (float (- gl-width line-width)) (float gl-height) 0.0)
        (gl:vertex (float (- gl-width line-width)) 0.0 0.0))
      (gl:with-primitives :lines   ; start drawing lines
        (gl:vertex 0.0 0.0 0.0)
        (gl:vertex (float gl-width) (float gl-height) 0.0))
      (gl:with-primitives :lines   ; start drawing lines
        (gl:vertex 0.0 (float (1- gl-height)) 0.0)
        (gl:vertex (float (- gl-width line-width)) 0.0 0.0))

      (gl:polygon-mode :front-and-back :fill)
      (gl:pop-matrix))))

(defun draw-rectangle (window)
  (let ((line-width 2))
    (with-slots (gl-width gl-height) window
      (gl:push-matrix)
      (gl:load-identity)
      (gl:line-width line-width)
      (gl:color 1 1 1 1.0)
      (gl:polygon-mode :front-and-back :fill)
      (gl:with-primitives :polygon   ; start drawing a polygon
        (gl:vertex 0.0 0.0 0.0)
        (gl:vertex 0.0 (float gl-height) 0.0)
        (gl:vertex (float (- gl-width line-width)) (float gl-height) 0.0)
        (gl:vertex (float (- gl-width line-width)) 0.0 0.0))
      (gl:color 0.5 0.5 0.5 0.0)
      (gl:polygon-mode :front-and-back :fill)
      (gl:pop-matrix))))


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
          (setf (cffi:mem-aref p1 :float 1) (float (- *gl-width* y) 1.0))))))


(defun move-obstacle-norm-x (x player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 0) (float (* x *gl-width*) 1.0))))))

(defun move-obstacle-norm-y (y player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 1) (float (* y *gl-height*) 1.0))))))

(defun move-obstacle-rel-y (dy player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 1)
                (float (clip (+ (cffi:mem-aref p1 :float 1) dy) 0 *gl-height*)))))))

(defun move-obstacle-rel-x (dx player)
  (let* ((window cl-boids-gpu::*win*)
         (bs (first (systems window))))
    (if bs
        (ocl:with-mapped-buffer (p1 (car (command-queues window)) (obstacles-pos bs) 4
                                    :offset (* +float4-octets+ (get-obstacle-ref player)) :write t)
          (setf (cffi:mem-aref p1 :float 0)
                (float (clip (+ (cffi:mem-aref p1 :float 0) dx) 0 *gl-width*)))))))

(defun clip (val vmin vmax)
  (min vmax (max val vmin)))

(defun add-remove-boids (&optional (add nil add-supplied-p))
  (let ((fadetime (val (boids-add-time *bp*)))
        (origin (list
                 (float (* (gl-width *win*) (val (boids-add-x *bp*))))
                 (float (* (gl-height *win*) (val (boids-add-y *bp*)))))))
    (if (or add (and (not add-supplied-p) (zerop (round (val (boids-add-remove *bp*))))))
        (timer-add-boids
         (val (boids-per-click *bp*)) 1 :origin origin :fadetime fadetime)
        (timer-remove-boids
         (val (boids-per-click *bp*)) 1 :origin origin :fadetime fadetime))))

(defun timer-add-boids (total-num boids-per-click  &key (origin '(0.0 0.0)) (fadetime 0.5))
  (let* ((num-pict-frames (round (* fadetime 60)))
         (real-boids-per-click (if (or (zerop fadetime) (zerop num-pict-frames))
                                   total-num
                                   (max 1 (round (/ total-num num-pict-frames))))))
    (cm::sprout
     (cm::process
       cm::with remain = total-num 
       cm::while (> remain boids-per-click)
       cm::do (progn
                (push (list real-boids-per-click origin) *change-boid-num*)
                (decf remain real-boids-per-click))
       cm::finally (if (> remain 0)
                       (push (list remain origin) *change-boid-num*))
       cm::wait (float (/ num-pict-frames total-num 60))))))

(defun add-boids (win num &optional origin)
  (with-slots (gl-scale gl-width gl-height) win
    (add-to-boid-system
     (if origin `(,@origin 0.0 0.0)
         `(,(float (random gl-width)) ,(float (random gl-height) 1.0) 0.0 0.0))
     num
     win
     :maxcount *boids-maxcount*
     :length (val (len *bp*))
     :trig *trig*))
  (set-num-boids (reduce #'+ (systems *win*) :key 'boid-count)))

(defun timer-remove-boids (total-num boids-per-click &key (fadetime 0.5) (origin '(0.0 0.0)))
  (declare (ignore origin))
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

;;; (cl-opengl::gl-array-pointer (gl-array (first (systems *win*))))

;;; (gl:glaref (gl-array (first (systems *win*))) 1)
