(in-package #:riga-test)

(deftest (test-assoc-bind :in riga-tests) ()
  (let ((alist '((a . "uiae") (b . "lcl") (c . 34))))
    (riga::assoc-bind ((a c) alist)
      (is (string= a "uiae"))
      (is (= c 34))))
  (let ((alist '(("foo" . "bar") ("baz" . "quux"))))
    (riga::assoc-bind ((foo baz) alist
                       :var-transform #'string
                       :test #'equalp)
      (is (string= "bar" foo))
      (is (string= "quux" baz))))
  (let ((alist '((2 . 3) (4 . "foo"))))
    (riga::assoc-bind ((|2| |3|) alist
                       :var-transform (lambda (var)
                                        (parse-integer (string var)))
                       :test #'=)
      (is (= |2| 3))
      (is (null |3|)))))
