;;;; package.lisp

(defpackage #:luftstrom-display
  (:shadowing-import-from #:cm
                          :at :now :tuning :*tempo* :play :rescale-envelope :quantize :stop :group :range)
    (:shadowing-import-from #:ou
                          :n-exp :m-exp :n-lin :m-lin :r-exp :r-lin)
  (:use #:cl #:cl-boids-gpu #:incudine #:cm #:orm-utils #:cl-coroutine #:incudine-gui #:simple-tk))
