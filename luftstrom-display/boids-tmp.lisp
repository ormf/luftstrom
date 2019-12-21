(in-package :luftstrom-display)

;;; preset: 3

(progn
  (setf *curr-preset*
        `(:boid-params
          (nil nil
               )
          :audio-args
          (nil nil
               )
          :midi-cc-fns
          ()
          :midi-note-fns
          ()
          :midi-cc-state ,*cc-state*))
  (load-preset *curr-preset*))

(state-store-curr-preset 3)

(save-presets)
