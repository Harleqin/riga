(in-package #:riga-test)

(deftest (test-assoc-bind :in riga-tests) ()
  (let ((alist '(("foo" . "bar") ("baz" . "quux"))))
    (riga::assoc-bind ((foo baz) alist
                       :var-transform #'string
                       :test #'equalp)
      (is (string= "bar" foo))
      (is (string= "quux" baz)))))
