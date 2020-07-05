;;; luftstrom-display.lisp

(in-package #:cl-boids-gpu)

;;; (boids :width 1200 :height 900)
;;; (incudine:rt-stop)

(defparameter *change-boid-num* nil)
(defparameter *switch-to-preset* nil)
(defparameter *bs* nil)

;;; (setf *boids-per-click* 1000)
(setf *print-case* :downcase)

(defparameter *gl-queue* (make-mailbox))

(defun gl-enqueue (fn)
  (mailbox-send-message *gl-queue* fn))

(defun gl-dequeue (win bs)
  (multiple-value-bind (fn ok) (mailbox-receive-message-no-hang *gl-queue*)
    (when ok
      (let ((*win* win) (*bs* bs))
        (declare (ignorable *win* *bs*))
        (funcall fn)
        (gl-dequeue win bs)))))

;;; (gl-enqueue (lambda () (restore-bs-from-preset 40)))

;;; (gl-dequeue)
(export '(gl-enqueue restore-bs-from-preset) 'cl-boids-gpu)


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

(defun %update-system (window bs)
  (if bs
      (let ((command-queue (car (command-queues window)))
            (pixelsize (pixelsize bs))
            (width *gl-width*)
            (height *gl-height*)
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
        ;; (if *switch-to-preset*
        ;;     (progn
        ;;       (restore-bs-from-preset window bs *switch-to-preset*)
        ;;       (setf *switch-to-preset* nil)))
        (gl-dequeue window bs)
        (if (> count 0)
            (with-model-slots (speed maxidx length alignmult sepmult cohmult maxlife lifemult) *bp*
              (let
                  ((pos (boid-coords-buffer bs))
                   (maxspeed (speed->maxspeed speed))
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
                (if *check-state* (format-state))
                (set-kernel-args kernel
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
                (enqueue-nd-range-kernel command-queue kernel count)
                (finish command-queue)
                (if (<= *clock* 0)
                    (setf *clock* (val (cl-boids-gpu::clockinterv *bp*)))
                    (decf *clock*))
                (with-slots (bs-num-boids bs-positions bs-velocities bs-life bs-retrig
                             bs-color bs-obstacles)
                    luftstrom-display::*curr-boid-state*
;;; *obstacles* (ou:ucopy *obstacles*)
                  (setf bs-num-boids (boid-count bs))
                  ;;    (setf *positions* (boid-coords-buffer bs))
                  (setf bs-positions (if (and (> (val (num-boids *bp*)) 0)
                                              (> (boid-count bs) 0))
                                         (enqueue-read-buffer command-queue pos
                                                              (* 16 (boid-count bs)))))
                  (setf bs-velocities (if (and (> (val (num-boids *bp*)) 0)
                                               (> (boid-count bs) 0))
                                          (enqueue-read-buffer command-queue vel
                                                               (* 4 (boid-count bs)))))
                  (setf bs-life (if (and (> (val (num-boids *bp*)) 0)
                                         (> (boid-count bs) 0))
                                    (enqueue-read-buffer command-queue life
                                                         (boid-count bs))))

                  (if *bs-retrig*
                      (setf bs-retrig (if (and (> (val (num-boids *bp*)) 0)
                                               (> (boid-count bs) 0))
                                          (enqueue-read-buffer command-queue retrig
                                                               (* 4 (boid-count bs))
                                                               :element-type '(signed-byte 32)))))
                  (setf bs-obstacles *obstacles*)

                  (finish command-queue)
                  (luftstrom-display::send-to-audio bs-retrig bs-positions bs-velocities)))))
        (if *change-boid-num*
            (apply #'add-boids (pop *change-boid-num*))))
      (format t "no bs!")))

;;; (setf *check-state* t)
;;; (push 400 *change-boid-num*)

;;; (setf *lifemult* 200)

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
                      (max 0.01 (* (val (maxlife *bp*)) (/ k count)))
                      (max 0.01 (* (random 1.0) (val (maxlife *bp*)))))
                   1.0))))))

;;; (reshuffle-life *win* :regular nil)

(defun add-to-boid-system (origin count win
                           &key (maxcount *boids-maxcount*) (length (val (len *bp*)))
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
      (with-model-slots (num-boids lifemult speed maxlife) *bp*
        (let ((maxspeed (speed->maxspeed speed)))
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
                             (set-array-vals p2 j (* v maxspeed (sin a)) (* v maxspeed (cos a)) 0.0 0.0)
                             (apply #'set-array-vals p1 (+ i 0) origin)
                             (apply #'set-array-vals p1 (+ i 8) (mapcar #'+ origin
                                                                        (list (* -1 length (sin a))
                                                                              (* -1 length (cos a)) 0.0 1.0)))
                             (let ((color (if (zerop i) *first-boid-color* *fg-color*)))
                               (apply #'set-array-vals p1 (+ i 4) color)
                               (apply #'set-array-vals p1 (+ i 12) color))
                             (setf (cffi:mem-aref p3 :float k)
                                   (float (if trig ;;; do we trigger on creation of a boid?
                                              (max 0.01 (* (random (max 0.01 (float lifemult))) (* count 0.12)))
                                              (max 0.01 (* (+ 0.7 (random 0.2)) maxlife))
                                              )
                                          1.0))
                             (setf (cffi:mem-aref p4 :int (* k 4)) 0) ;;; retrig
                             (setf (cffi:mem-aref p4 :int (+ (* k 4) 1)) -1) ;;; obstacle-idx for next trig
                             (setf (cffi:mem-aref p4 :int (+ (* k 4) 2))
                                   (if trig 0 20)) ;;; frames since last trig
                             (setf (cffi:mem-aref p4 :int (+ (* k 4) 3)) 0) ;;; time since last obstacle-induced trigger
                             ))))))
          (incf (boid-count bs) count)
          (setf num-boids (boid-count bs))
          (luftstrom-display::bp-set-value :num-boids num-boids))))
    bs))

(defmethod glut:display-window :after ((w opencl-boids-window))
  (push (make-boid-system '(800.0 -450.0 0.0 0.0) 1 w) (systems w))
  (continuable
    (dolist (bs (systems w))
      (setf (boid-count bs) 0))
    (luftstrom-display::at (+ (luftstrom-display::now) 0.5)
      (lambda ()
        (format t "~&initializing...")
        (luftstrom-display::bp-set-value :num-boids 0)
        (luftstrom-display::gui-set-preset 0)
        (luftstrom-display::load-current-preset)
        (luftstrom-display::handle-midi-in ;;; press leftmost "R" of nk2
         (Luftstrom-display::ensure-controller :nk2) :cc 64 127)
        (glut:reshape w 1280 720)
        (format t "~&initialized!~%~%")))))

(defun unbound (preset)
  (not (bs-num-boids preset)))

(defun copy-vector (vector p)
  "copy the contents of vector to a foreign array at pointer p."
    (loop
      for x across vector
      for i from 0
      do (setf (cffi:mem-aref p :float i) x)))

(defun restore-values-from-preset (obj &rest vals)
  (loop for val in vals
        do (luftstrom-display::bp-set-value val (slot-value obj val))))

(defun restore-bs-from-preset (idx)
  (let* (;;; (bs (first (systems win)))
         (win *win*)
         (bs *bs*)
         (vbo (vbo bs))
         (vel (velocity-buffer bs))
         (life-buffer (life-buffer bs))
         (retrig-buffer (retrig-buffer bs))
         (command-queue (first (command-queues win))))
;;;    (break "vbo: ~a" vbo)
    (unless (or (zerop vbo) (unbound (elt luftstrom-display::*bs-presets* idx)))
      (with-slots (bs-num-boids bs-positions bs-velocities bs-life bs-retrig)
          (elt luftstrom-display::*bs-presets* idx)
        (gl:bind-buffer :array-buffer vbo)
        (gl:with-mapped-buffer (p-pos :array-buffer :read-write)
          (copy-vector bs-positions p-pos))
        (ocl:enqueue-write-buffer command-queue vel bs-velocities)
        (ocl:enqueue-write-buffer command-queue life-buffer bs-life)
        (ocl:enqueue-write-buffer command-queue retrig-buffer bs-retrig)
        (finish command-queue)
        (setf (boid-count bs) bs-num-boids)))))

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
         (local-x (float (/ x (glut:width window))))
         (local-y (float (/ (- (glut:height window) y) (glut:height window)))))
    (setf (val (boids-add-x *bp*)) local-x)
    (setf (val (boids-add-y *bp*)) (- 1 local-y))
    (set-obstacle-position window mouse-player-ref local-x local-y)
    (setf (mouse-x window) x)
    (setf (mouse-y window) y)))

(defun set-obstacle-position (window player x y)
  (let* ((bs (first (systems window)))
         (mouse-obstacle (and player (luftstrom-display::obstacle player))))
    (if (and bs mouse-obstacle)
        (progn
          (ocl:with-mapped-buffer
              (p1 (car (command-queues window)) (obstacles-pos bs) 4
                  :offset (* +float4-octets+
                             (luftstrom-display::obstacle-ref mouse-obstacle))
                  :write t)
            (setf (cffi:mem-aref p1 :float 0) (float (* *gl-width* x) 1.0))
;;;              (format t "~&~a, ~a, ~a~%" x y (luftstrom-display::obstacle-ref mouse-obstacle))
            (setf (cffi:mem-aref p1 :float 1) (float (* *gl-height* y) 1.0)))
          (list (float (* *gl-width* x) 1.0)
                (float (* *gl-height* y) 1.0))))))
;;; (untrace)

;;; (deftype obstacle-type () '(member :predator :obstacle :react :attractor :nointeract))

(defconstant +nointeract+ 0)
(defconstant +obstacle+ 1)
(defconstant +trigger+ 2)
(defconstant +predator+ 3)
(defconstant +attractor+ 4)

(export '(+nointeract+ +obstacle+ +trigger+ +predator+ +attractor+) 'cl-boids-gpu)

(defun gl-set-obstacle-type (ref type)
  (if ref
      (progn
        (setf (luftstrom-display::obstacle-type (luftstrom-display::obstacle ref)) type))))

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
    (setf *show-fps* (not *show-fps*)))
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
      (luftstrom-display::bp-set-value :num-boids 0))))

(defun is-active? (idx)
  (loop for o across *obstacles*
     until (= (luftstrom-display::obstacle-ref o) idx)
     finally (return (luftstrom-display::obstacle-active o))))

;;; (is-active? 0)

;; (update-get-active-obstacles *win*)

(defun draw-obstacles (window)
  (dolist
      (obstacle (update-get-active-obstacles window))
     ;;          (format t "~a" (first obstacle))
    (case (first obstacle)
      (0 (apply #'no-interact-circle (rest obstacle)))
      (1 (apply #'obstacle-circle (rest obstacle)))
      (2 (apply #'plucker-circle  (rest obstacle)))
      (3 (apply #'attractor-circle (rest obstacle)))
      (4 (apply #'predator-circle  (rest obstacle))))))

;;; (draw-obstacles *win*)

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

(defun recalc-coords (coords)
  (list (round (* (* *gl-width* (first coords)) *gl-scale*))
        (round (* (* -1 *gl-height* (second coords)) *gl-scale*))))

(defun add-remove-boids (&optional (add nil add-supplied-p))
  (let ((fadetime (val (boids-add-time *bp*)))
        (origin (list
                  (* *real-width* (val (boids-add-x *bp*)))
                  (* -1 *real-height* (val (boids-add-y *bp*))))))
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
;;;    (format t "num-pict-frames: ~a, boids-per-click: ~a" num-pict-frames real-boids-per-click)
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

(defun add-boids (num &optional origin)
  (add-to-boid-system
   (if origin (append (mapcar (lambda (x) (/ x *gl-scale*)) origin) '(0.0 0.0))
       `(,(float (random *gl-width*)) ,(float (* -1 (random *gl-height*)) 1.0) 0.0 0.0))
   num
   *win*
   :maxcount *boids-maxcount*
   :length (val (len *bp*))
   :trig *trig*)
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
