;;;; -*- Mode: lisp; indent-tabs-mode: nil -*-
;;;;
;;;; This file is part of Sheeple

;;;; utils.lisp
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :sheeple)

(def-suite utils :in sheeple)
(in-suite sheeple)

(test flatten
  (is (null (flatten ())))
  (is (null (flatten '(() (()) ((()))))))
  (is (equal '(a b c) (flatten '(a b c))))
  (is (equal '(a b c) (flatten '((a b c)))))
  (is (equal '(a b c) (flatten '((a) (b) (c)))))
  (is (equal '(a b c) (flatten '((a . b) . c)))))

(test proper-list-of-length-p
  (signals type-error (proper-list-of-length-p 5 0))
  (is (not (null (proper-list-of-length-p () 0))))
  (is (null (proper-list-of-length-p '() 1)))
  (is (null (proper-list-of-length-p '(1) 0)))
  (is (not (null (proper-list-of-length-p '(1 2 3) 0 4))))
  (is (null (proper-list-of-length-p '(1 2 3) 1 2)))
  (5am:finishes (proper-list-of-length-p #1='(:P . #1#) 0 2)))

(test topological-sort)
(test once-only)
(test memq)
(test collect-normal-expander)
(test collect-list-expander)
(test maybe-weak-pointer-value)
