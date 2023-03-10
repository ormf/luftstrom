;;; 
;;; classes-intel-beignet.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2022 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
;;;
;;; Revision history: See git repository.
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the Gnu Public License, version 2 or
;;; later. See https://www.gnu.org/licenses/gpl-2.0.html for the text
;;; of this agreement.
;;; 
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;; GNU General Public License for more details.
;;;
;;; **********************************************************************

(in-package :cl-boids-gpu)

(defclass boid-system ()
  ((gl-coords :initarg :gl-coords :accessor gl-coords) ;;; vbo of lines :array-buffer
   (boid-coords-buffer :initarg :boid-coords-buffer :accessor boid-coords-buffer)
   (velocity-buffer :initarg :velocity-buffer :accessor velocity-buffer)
   (force-buffer :initarg :force-buffer :accessor force-buffer)
   (bidx-buffer :initarg :bidx-buffer :accessor bidx-buffer) ;;; board-idx of boid-pos (+ (/ x pixelsize) (* (/ y pixelsize) board-width))
   (life-buffer :initarg :life-buffer :accessor life-buffer)
   (retrig-buffer :initarg :retrig-buffer :accessor retrig-buffer)
   (color-buffer :initarg :color-buffer :accessor color-buffer)
   (weight-board :initarg :weight-board :initform nil :accessor weight-board)
   (align-board :initarg :align-board :initform nil :accessor align-board)
   (board-dx :initarg :board-dx :initform nil :accessor board-dx)
   (board-dy :initarg :board-dy :initform nil :accessor board-dy)
   (board-dist :initarg :board-dist :initform nil :accessor board-dist)
   (board-sep :initarg :board-sep :initform nil :accessor board-sep)
   (board-coh :initarg :board-coh :initform nil :accessor board-coh)
   (obstacle-board :initarg :obstacle-board :initform nil :accessor obstacle-board)
   (num-obstacles :initarg :num-obstacles :initform 0 :accessor num-obstacles)
   (obstacle-target-posns :initarg :obstacle-target-posns :initform nil :accessor obstacle-target-posns)
   (obstacles-pos :initarg :obstacles-pos :initform nil :accessor obstacles-pos)
   (obstacles-type :initarg :obstacles-type :initform nil :accessor obstacles-type)
   (obstacles-radius :initarg :obstacles-radius :initform nil :accessor obstacles-radius)
   (obstacles-lookahead :initarg :obstacles-lookahead :initform 1.0 :accessor obstacles-lookahead)
   (obstacles-multiplier :initarg :obstacles-multiplier :initform 1.0 :accessor obstacles-multiplier)
   (obstacles-boardoffs-maxidx :initarg :obstacles-boardoffs-maxidx :initform nil :accessor obstacles-boardoffs-maxidx)
   (maxobstacles :initarg :maxobstacles :initform 0 :accessor obstacles)
   (pixelsize :initarg :pixelsize :initform 5 :accessor pixelsize)
   (count :initarg :count :accessor boid-count)
   (start-time :initform (now) :reader start-time)
   (last-update :initform () :reader last-update-time)
   (x :initform 0.0 :initarg :x :reader x)
   (y :initform 0.0 :initarg :y :reader y)
   (z :initform 0.0 :initarg :z :reader z)))
