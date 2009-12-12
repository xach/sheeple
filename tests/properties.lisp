;;;; -*- Mode: lisp; indent-tabs-mode: nil -*-
;;;;
;;;; This file is part of Sheeple.

;;;; tests/properties.lisp
;;;;
;;;; Unit tests for src/properties.lisp
;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :sheeple)

;;;
;;; Properties
;;;
(def-suite properties :in sheeple)

(def-suite existential :in properties)
(in-suite existential)

(test direct-property-p
  (let* ((object (object))
         (property 'test))
    (setf (property-value object property) 'value)
    (is (direct-property-p object 'test))
    (is (not (direct-property-p object 'something-else))))
  (let* ((a (object))
         (b (object :parents (list a))))
    (setf (property-value a 'test) 'value)
    (is (direct-property-p a 'test))
    (is (not (direct-property-p b 'test)))))

(test available-property-p
  (let* ((a (object))
         (b (object :parents (list a))))
    (setf (property-value a 'test) 'value)
    (is (direct-property-p a 'test))
    (is (not (direct-property-p a 'something-else)))
    (is (not (direct-property-p b 'test)))
    (is (not (direct-property-p b 'something-else)))))

#+nil
(test add-property
  (let ((object (object)))
    (is (eq object (add-property object 'test 'value)))
    (is (direct-property-p object 'test))
    (is (eq 'value (direct-property-value object 'test)))
    (signals error (add-property object "foo" "uh oh"))
    (is (not (direct-property-p object "foo")))
    ;; todo - check that the restart works properly.
    ))

(test remove-property
  (let ((object (object)))
    (signals error (remove-property object 'something))
    (setf (property-value object 'test) 'value)
    (is (eq object (remove-property object 'test)))
    (is (not (direct-property-p object 'test)))
    (signals error (remove-property object 'test))))

(test remove-all-direct-properties
  (let ((object (object)))
    (setf (property-value object 'test1) 'value)
    (setf (property-value object 'test2) 'value)
    (setf (property-value object 'test3) 'value)
    (is (eq object (remove-all-direct-properties object)))
    (is (not (or (direct-property-p object 'test1)
                 (direct-property-p object 'test2)
                 (direct-property-p object 'test3))))
    (signals unbound-property (property-value object 'test1))
    (signals unbound-property (property-value object 'test2))
    (signals unbound-property (property-value object 'test3))))

(def-suite values :in properties)
(in-suite values)

(test direct-property-value
  (let* ((a (object))
         (b (object :parents (list a))))
    (setf (property-value a 'test) 'value)
    (is (eq 'value (direct-property-value a 'test)))
    (signals unbound-property (direct-property-value a 'something-else))
    (signals unbound-property (direct-property-value b 'test))))

(test property-value
  (let* ((a (object))
         (b (object :parents (list a)))
         (c (object)))
    (setf (property-value a 'test) 'value)
    (is (eq 'value (property-value a 'test)))
    (is (eq 'value (property-value b 'test)))
    (signals unbound-property (property-value a 'something-else))
    (signals unbound-property (property-value c 'test))))

(test setf-property-value
  ;; (setf property-value) should add the property directly if it does not already exist,
  ;; then it should set the value. It will add the property regardless of whether it already
  ;; exists in the hierarchy list or not.
  (let* ((a (object))
         (b (object :parents (list a))))
    (is (eq 'new-value (setf (property-value a 'test) 'new-value)))
    (is (eq 'new-value (direct-property-value a 'test)))
    (is (eq 'new-value (property-value b 'test)))
    (is (eq 'foo (setf (property-value b 'test) 'foo)))
    (is (eq 'foo (property-value b 'test)))
    (is (eq 'new-value (property-value a 'test)))))

(test hashprops
  (let ((properties (loop repeat 20 collect (list (gensym) (gensym))))
        (object (object)))
    (symbol-macrolet ((verify-properties
                       (loop for (pname value) in properties do
                            (is (eq value (property-value object pname))))))
      (loop for (var value) in properties
         do (setf (property-value object var) value))
      verify-properties
      (loop for new-name = (gensym) and pair in properties do
           (setf (property-value object (car pair)) new-name
                 (cadr pair) new-name))
      verify-properties
      (loop repeat 10 for (pname nil) in properties do
           (remove-property object pname)
           (pop properties))
      verify-properties)))

(def-suite reflection :in properties)
(in-suite reflection)

(test property-owner
  (let* ((parent (defobject () ((var "value"))))
         (child (defobject (parent) ((child-var "child-value")))))
    (is (eq parent (property-owner parent 'var)))
    (is (eq parent (property-owner child 'var)))
    (is (eq child (property-owner child 'child-var)))
    (is (null (property-owner parent 'some-other-property nil)))
    (is (null (property-owner parent 'some-other-property)))
    (signals unbound-property (property-owner parent 'some-other-property t))))

(test direct-properties
  (let ((object (defobject () ((var1 'val) (var2 'val) (var3 'val)))))
    (is (= 3 (length (direct-properties object))))
    (is (every 'symbolp (direct-properties object)))))

(test available-properties
  (let* ((a (defobject () ((var1 'val))))
         (b (defobject (a) ((var2 'val))))
         (c (defobject (b) ((var3 'val)))))
    (is (= 4 (length (available-properties c))))
    (is (every 'symbolp (available-properties c)))))

;; ugh. I don't want to write tests for these.
(test property-summary)
(test direct-property-summary)
