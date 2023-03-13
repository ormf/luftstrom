;;;; package.lisp
;;;;
;;;; Copyright (c) 2017 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>

(defpackage #:cl-boids-gpu
  (:use #:cl #:cl-opencl #:safe-queue #:cellctl)
  (:export #:boids #:*speed* #:*positions* #:*board* #:*board-align*
           #:*board-x* #:*board-y* #:*board-dist* #:*board-sep* #:*board-coh*
           #:*board-weight* #:*bidx* #:*velocities* #:*forces* #:*update* #:*fg-color*
           #:*first-boid-color* #:*maxspeed* #:*maxforce* #:*maxidx* #:*length*
           #:*sepmult* #:*alignmult* #:*cohmult* #:*width* #:*height*
           #:*gl-width* #:*gl-height* #:*gl-scale* #:*boids-per-click*
           #:*curr-kernel* #:*boids-maxcount* #:*obstacle-tracked*
           #:*max-obstacles*
           #:set-zoom #:*zoom* #:*positions* #:*obstacle-board* #:*obstacles* #:*obstacles-type*
           #:*obstacles-pos* #:*obstacles-radius* #:*board* #:*colors* #:*align-board*
           #:*board-dx* #:*board-dy* #:*board-dist* #:*board-sep* #:*board-coh*
           #:*weight-board* #:*bidx* #:*velocities* #:*forces* #:*life* #:*retrig*
           #:*update* #:*fg-color* #:*first-boid-color*
           #:boid-system-state2 #:start-time
           #:bs-num-boids #:bs-positions #:bs-velocities #:bs-life #:bs-retrig #:bs-pixelsize #:bs-preset
           #:last-update #:note-states #:bs-obstacles
           #:midi-cc-state #:midi-cc-fns #:audio-args
           #:load-audio #:load-boids #:load-obstacles
           #:*bp*
#|
           #:*num-boids* #:*boids-per-click* #:*obstacles-lookahead*
           #:*speed* #:*maxspeed* #:*maxforce* #:*maxidx* #:*length* #:*sepmult* #:*alignmult* #:*cohmult* #:*predmult*
           #:*maxlife* #:*lifemult*
           |#
           #:*bp*
           #:num-boids #:alignmult #:boids-per-click #:clockinterv #:cohmult #:len #:lifemult #:maxidx #:maxlife #:obstacles-lookahead #:boids-add-time #:boids-per-click #:clock-interval
           #:predmult #:sepmult #:speed #:bs-preset-change-subscribers
           #:*width* #:*height*
           #:*max-events-per-tick* #:*show-fps* #:*platform* #:*context*
           #:*programs* #:*kernels* #:*command-queues* #:*buffers* #:*width* #:*height*
           #:*platform*
           #:*pixelsize*
           #:*clock*
           #:clear-obstacles
           #:new-obstacle
           #:new-predator
           #:new-attractor
           #:gl-set-obstacles
           #:*active-obstacles*
           #:move-obstacle
           #:move-obstacle-rel
           #:*active-obstacles*
           #:make-obstacle-mask
           #:move-obstacle-rel-xy
           #:get-obstacles
           #:get-obstacle-pos
           #:set-obstacle-dx
           #:set-obstacle-dy
           #:*trig*))


