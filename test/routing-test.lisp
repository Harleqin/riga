(in-package #:riga-test)

(deftest (test-defroute :in riga-tests) ()
  (let ((app (make-instance 'ningle:<app>))
        (visited nil))
    (riga::defroute (app "/foo" :method :post) (bar)
      (setf visited t)
      (format nil "OK: ~a" bar))
    (let ((handler (clack:clackup app :port 5001)))
      (unwind-protect
           (multiple-value-bind (body status)
               (drakma:http-request "http://localhost:5001/foo"
                                    :method :post
                                    :parameters '(("bar" . "baz")))
             (is (= status 200))
             (is (string= body "OK: baz"))
             (is visited))
        (when handler
          (clack:stop handler))))))
