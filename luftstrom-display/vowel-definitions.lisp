;;; 
;;; vowel-definitions.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2019 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
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

(in-package :sc)

(defparameter *vowel-definitions*
  '(:bass
    (:a
     ((:freq 600 :ampdb 0 :bwidth 60 :rq 0.1)
      (:freq 1040 :ampdb -7 :bwidth 70 :rq 0.067)
      (:freq 2250 :ampdb -9 :bwidth 110 :rq 0.049)
      (:freq 2450 :ampdb -9 :bwidth 120 :rq 0.049)
      (:freq 2750 :ampdb -20 :bwidth 130 :rq 0.047))
     :e
     ((:freq 400 :ampdb 0 :bwidth 40 :rq 0.1)
      (:freq 1620 :ampdb -12 :bwidth 80 :rq 0.049)
      (:freq 2400 :ampdb -9 :bwidth 100 :rq 0.042)
      (:freq 2800 :ampdb -12 :bwidth 120 :rq 0.043)
      (:freq 3100 :ampdb -18 :bwidth 120 :rq 0.039))
     :i
     ((:freq 350 :ampdb 0 :bwidth 60 :rq 0.171)
      (:freq 1700 :ampdb -20 :bwidth 90 :rq 0.053)
      (:freq 2700 :ampdb -30 :bwidth 100 :rq 0.037)
      (:freq 3700 :ampdb -22 :bwidth 120 :rq 0.032)
      (:freq 4950 :ampdb -28 :bwidth 120 :rq 0.024))
     :o
     ((:freq 450 :ampdb 0 :bwidth 40 :rq 0.089)
      (:freq 800 :ampdb -11 :bwidth 80 :rq 0.1)
      (:freq 2830 :ampdb -21 :bwidth 100 :rq 0.035)
      (:freq 3500 :ampdb -20 :bwidth 120 :rq 0.034)
      (:freq 4950 :ampdb -40 :bwidth 120 :rq 0.024))
     :u
     ((:freq 325 :ampdb 0 :bwidth 40 :rq 0.123)
      (:freq 700 :ampdb -20 :bwidth 80 :rq 0.114)
      (:freq 2530 :ampdb -32 :bwidth 100 :rq 0.04)
      (:freq 3500 :ampdb -28 :bwidth 120 :rq 0.034)
      (:freq 4950 :ampdb -36 :bwidth 120 :rq 0.024)))
    :tenor
    (:a
     ((:freq 650 :ampdb 0 :bwidth 80 :rq 0.123)
      (:freq 1080 :ampdb -6 :bwidth 90 :rq 0.083)
      (:freq 2650 :ampdb -7 :bwidth 120 :rq 0.045)
      (:freq 2900 :ampdb -8 :bwidth 130 :rq 0.045)
      (:freq 3250 :ampdb -22 :bwidth 140 :rq 0.043))
     :e
     ((:freq 400 :ampdb 0 :bwidth 70 :rq 0.175)
      (:freq 1700 :ampdb -14 :bwidth 80 :rq 0.047)
      (:freq 2600 :ampdb -12 :bwidth 100 :rq 0.038)
      (:freq 3200 :ampdb -14 :bwidth 120 :rq 0.038)
      (:freq 3580 :ampdb -20 :bwidth 120 :rq 0.034))
     :i
     ((:freq 290 :ampdb 0 :bwidth 40 :rq 0.138)
      (:freq 1870 :ampdb -15 :bwidth 90 :rq 0.048)
      (:freq 2800 :ampdb -18 :bwidth 100 :rq 0.036)
      (:freq 3250 :ampdb -20 :bwidth 120 :rq 0.037)
      (:freq 3540 :ampdb -30 :bwidth 120 :rq 0.034))
     :o
     ((:freq 400 :ampdb 0 :bwidth 70 :rq 0.175)
      (:freq 800 :ampdb -10 :bwidth 80 :rq 0.1)
      (:freq 2600 :ampdb -12 :bwidth 100 :rq 0.038)
      (:freq 2800 :ampdb -12 :bwidth 130 :rq 0.046)
      (:freq 3000 :ampdb -26 :bwidth 135 :rq 0.045))
     :u
     ((:freq 350 :ampdb 0 :bwidth 40 :rq 0.114)
      (:freq 600 :ampdb -20 :bwidth 60 :rq 0.1)
      (:freq 2700 :ampdb -17 :bwidth 100 :rq 0.037)
      (:freq 2900 :ampdb -14 :bwidth 120 :rq 0.041)
      (:freq 3300 :ampdb -26 :bwidth 120 :rq 0.036)))
    :countertenor
    (:a
     ((:freq 660 :ampdb 0 :bwidth 80 :rq 0.121)
      (:freq 1120 :ampdb -6 :bwidth 90 :rq 0.08)
      (:freq 2750 :ampdb -23 :bwidth 120 :rq 0.044)
      (:freq 3000 :ampdb -24 :bwidth 130 :rq 0.043)
      (:freq 3350 :ampdb -38 :bwidth 140 :rq 0.042))
     :e
     ((:freq 440 :ampdb 0 :bwidth 70 :rq 0.159)
      (:freq 1800 :ampdb -14 :bwidth 80 :rq 0.044)
      (:freq 2700 :ampdb -18 :bwidth 100 :rq 0.037)
      (:freq 3000 :ampdb -20 :bwidth 120 :rq 0.04)
      (:freq 3300 :ampdb -20 :bwidth 120 :rq 0.036))
     :i
     ((:freq 270 :ampdb 0 :bwidth 40 :rq 0.148)
      (:freq 1850 :ampdb -24 :bwidth 90 :rq 0.049)
      (:freq 2900 :ampdb -24 :bwidth 100 :rq 0.034)
      (:freq 3350 :ampdb -36 :bwidth 120 :rq 0.036)
      (:freq 3590 :ampdb -36 :bwidth 120 :rq 0.033))
     :o
     ((:freq 430 :ampdb 0 :bwidth 40 :rq 0.093)
      (:freq 820 :ampdb -10 :bwidth 80 :rq 0.098)
      (:freq 2700 :ampdb -26 :bwidth 100 :rq 0.037)
      (:freq 3000 :ampdb -22 :bwidth 120 :rq 0.04)
      (:freq 3300 :ampdb -34 :bwidth 120 :rq 0.036))
     :u
     ((:freq 370 :ampdb 0 :bwidth 40 :rq 0.108)
      (:freq 630 :ampdb -20 :bwidth 60 :rq 0.095)
      (:freq 2750 :ampdb -23 :bwidth 100 :rq 0.036)
      (:freq 3000 :ampdb -30 :bwidth 120 :rq 0.04)
      (:freq 3400 :ampdb -34 :bwidth 120 :rq 0.035)))
    :alto
    (:a
     ((:freq 800 :ampdb 0 :bwidth 80 :rq 0.1)
      (:freq 1150 :ampdb -4 :bwidth 90 :rq 0.078)
      (:freq 2800 :ampdb -20 :bwidth 120 :rq 0.043)
      (:freq 3500 :ampdb -36 :bwidth 130 :rq 0.037)
      (:freq 4950 :ampdb -60 :bwidth 140 :rq 0.028))
     :e
     ((:freq 400 :ampdb 0 :bwidth 60 :rq 0.15)
      (:freq 1600 :ampdb -24 :bwidth 80 :rq 0.05)
      (:freq 2700 :ampdb -30 :bwidth 120 :rq 0.044)
      (:freq 3300 :ampdb -35 :bwidth 150 :rq 0.045)
      (:freq 4950 :ampdb -60 :bwidth 200 :rq 0.04))
     :i
     ((:freq 350 :ampdb 0 :bwidth 50 :rq 0.143)
      (:freq 1700 :ampdb -20 :bwidth 100 :rq 0.059)
      (:freq 2700 :ampdb -30 :bwidth 120 :rq 0.044)
      (:freq 3700 :ampdb -36 :bwidth 150 :rq 0.041)
      (:freq 4950 :ampdb -60 :bwidth 200 :rq 0.04))
     :o
     ((:freq 450 :ampdb 0 :bwidth 70 :rq 0.156)
      (:freq 800 :ampdb -9 :bwidth 80 :rq 0.1)
      (:freq 2830 :ampdb -16 :bwidth 100 :rq 0.035)
      (:freq 3500 :ampdb -28 :bwidth 130 :rq 0.037)
      (:freq 4950 :ampdb -55 :bwidth 135 :rq 0.027))
     :u
     ((:freq 325 :ampdb 0 :bwidth 50 :rq 0.154)
      (:freq 700 :ampdb -12 :bwidth 60 :rq 0.086)
      (:freq 2530 :ampdb -30 :bwidth 170 :rq 0.067)
      (:freq 3500 :ampdb -40 :bwidth 180 :rq 0.051)
      (:freq 4950 :ampdb -64 :bwidth 200 :rq 0.04)))
    :soprano
    (:a
     ((:freq 800 :ampdb 0 :bwidth 80 :rq 0.1)
      (:freq 1150 :ampdb -6 :bwidth 90 :rq 0.078)
      (:freq 2900 :ampdb -32 :bwidth 120 :rq 0.041)
      (:freq 3900 :ampdb -20 :bwidth 130 :rq 0.033)
      (:freq 4950 :ampdb -50 :bwidth 140 :rq 0.028))
     :e
     ((:freq 350 :ampdb 0 :bwidth 60 :rq 0.171)
      (:freq 2000 :ampdb -20 :bwidth 100 :rq 0.05)
      (:freq 2800 :ampdb -15 :bwidth 120 :rq 0.043)
      (:freq 3600 :ampdb -40 :bwidth 150 :rq 0.042)
      (:freq 4950 :ampdb -56 :bwidth 200 :rq 0.04))
     :i
     ((:freq 270 :ampdb 0 :bwidth 60 :rq 0.222)
      (:freq 2140 :ampdb -12 :bwidth 90 :rq 0.042)
      (:freq 2950 :ampdb -26 :bwidth 100 :rq 0.034)
      (:freq 3900 :ampdb -26 :bwidth 120 :rq 0.031)
      (:freq 4950 :ampdb -44 :bwidth 120 :rq 0.024))
     :o
     ((:freq 450 :ampdb 0 :bwidth 40 :rq 0.089)
      (:freq 800 :ampdb -11 :bwidth 80 :rq 0.1)
      (:freq 2830 :ampdb -22 :bwidth 100 :rq 0.035)
      (:freq 3800 :ampdb -22 :bwidth 120 :rq 0.032)
      (:freq 4950 :ampdb -50 :bwidth 120 :rq 0.024))
     :u
     ((:freq 325 :ampdb 0 :bwidth 50 :rq 0.154)
      (:freq 700 :ampdb -16 :bwidth 60 :rq 0.086)
      (:freq 2700 :ampdb -35 :bwidth 170 :rq 0.063)
      (:freq 3800 :ampdb -40 :bwidth 180 :rq 0.047)
      (:freq 4950 :ampdb -60 :bwidth 200 :rq 0.04)))))

(getf (getf *vowel-definitions* :bass) :a)
