(in-package :luftstrom-display)

;;; preset: 0

(progn
  (setf *curr-preset*
        (copy-list
         (append
          '(:boid-params
            (:num-boids 0
             :boids-per-click 5
              :clockinterv 2
             :speed 10.0
             :obstacles-lookahead 2.5
             :obstacles ((4 45)(4 60)(4 25)(4 15))
             :curr-kernel "boids"
             :bg-amp (m-exp (aref *nk2* 0 21) 0 1)
             :maxspeed 0.85690904
             :maxforce 0.07344935
             :maxidx 317
             :length 5
             :sepmult 1.32
             :alignmult 2.7
             :cohmult 1.93
             :predmult 1
             :maxlife 60000.0
             :lifemult 1000.0
             :max-events-per-tick 10)
            :audio-args
            (:pitchfn (n-exp y 0.4 1.08)
             :ampfn (* (sign) 3)
             :durfn (n-exp y 0.001 5.0e-4)
             :suswidthfn 0.1
             :suspanfn 0
             :decay-startfn 0.001
             :decay-endfn 0.2
             :lfo-freqfn 1
             :x-posfn x
             :y-posfn y
             :wetfn 1
             :filt-freqfn 20000)
            :midi-cc-fns
            (((0 0)
              (with-exp-midi (0.1 20)
                (let ((speedf (float (funcall ipfn d2))))
                  (set-value :maxspeed (* speedf 1.05))
                  (set-value :maxforce (* speedf 0.09)))))
             ((0 1)
              (with-lin-midi (1 8)
                (set-value :sepmult (float (funcall ipfn d2)))))
             ((0 2) 
              (with-lin-midi (1 8)
                (set-value :cohmult (float (funcall ipfn d2)))))
             ((0 3)
              (with-lin-midi (1 8)
                (set-value :alignmult (float (funcall ipfn d2)))))
             ((0 4)
              (with-lin-midi (1 10000)
                (set-value :lifemult (float (funcall ipfn d2)))))
             ((0 21)
              (with-exp-midi (0.001 1.0)
                (set-value :bg-amp (float (funcall ipfn d2)))))
             ((0 40)
              (make-retrig-move-fn 0 :dir :right :ref 100 :clip nil))
             ((0 50)
              (make-retrig-move-fn 0 :dir :left :ref 100 :clip nil))
             ((0 60)
              (make-retrig-move-fn 0 :dir :up :ref 100 :clip nil))
             ((0 70)
              (make-retrig-move-fn 0 :dir :down :ref 100 :clip nil))
             ((0 100)
              (lambda (d2)
                (setf (aref *ewi-states* 0 100) d2)))))
          `(:midi-cc-state ,(alexandria:copy-array *nk2*)))))
  (load-preset *curr-preset*))

(state-store-curr-preset 0)

(let ((speedf (float 5)))
  (set-value :maxspeed (* speedf 1.05))
  (set-value :maxforce (* speedf 0.09)))

(incudine:rt-start)




*obstacles*

(loop for o across *obstacles* do (setf (obstacle-active o) nil))

(cl-boids-gpu::%update-system cl-boids-gpu::*win* (first (cl-boids-gpu::systems cl-boids-gpu::*win*)))

(cl-boids-gpu::update-systems cl-boids-gpu::*win*)

(cl-boids-gpu::systems cl-boids-gpu::*win*)

(cl-boids-gpu close)

(glut:destroy-current-window)

glut::current-window
