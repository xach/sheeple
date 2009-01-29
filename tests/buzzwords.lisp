;; Copyright 2008 Kat Marchan

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use,
;; copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the
;; Software is furnished to do so, subject to the following
;; conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
;; OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;; OTHER DEALINGS IN THE SOFTWARE.

;; tests/buzzwords.lisp
;;
;; Unit tests for src/buzzwords.lisp
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :sheeple-tests)

(def-suite buzzword-tests :in sheeple)

(in-suite buzzword-tests)

(test buzzword-definition
  (defbuzzword test-buzz "This is a test")
  (is (buzzword-p (find-buzzword 'test-buzz)))
  (signals no-such-buzzword (find-buzzword 'another-buzzword))
  (undefbuzzword test-buzz))

(test buzzword-undefinition
  (defbuzzword test-buzz)
  (undefbuzzword test-buzz)
  (signals no-such-buzzword (find-buzzword 'test-buzz))
  (signals undefined-function (test-buzz))
  (is (not (sheeple::participant-p =dolly= 'test-buzz)))
  (defmessage another-buzzer (foo) foo)
  (defmessage another-buzzer ((foo =string=)) (declare (ignore foo)) "String returned!")
  (undefmessage another-buzzer ((foo =string=)))
  (is (equal "hei-ho!" (another-buzzer "hei-ho!")))
  (undefmessage another-buzzer (foo))
  (signals sheeple::no-most-specific-message (another-buzzer =dolly=)) ; this package bs pisses me off
  (is (not (sheeple::participant-p =dolly= 'test-buzz)))
  (is (not (sheeple::participant-p =string= 'test-buzz)))
  (undefbuzzword another-buzzer)
  (signals no-such-buzzword (find-buzzword 'another-buzzer))
  (signals undefined-function (another-buzzer "WHAT ARE YOU GONNA DO, BLEED ON ME?!")))

(test basic-message-definition
  (signals warning (defmessage test-message (foo) (print foo)))
  (undefbuzzword test-buzz)
  (defmessage test-message (foo) (print foo))
  (is (buzzword-p (find-buzzword 'test-message)))
  (is (message-p (car (buzzword-messages (find-buzzword 'test-message)))))
  (undefbuzzword test-message))

(test more-message-definition
  (defmessage test-message (foo bar) (print foo) (print bar))
  (undefbuzzword test-message))