(in-package #:riga-test)

(deftest (test-defroute :in riga-tests) ()
  (let ((app (make-instance 'ningle:<app>))
        (visited nil))
    (riga::defroute (app "/foo" :method :post) (bar)
                    (setf visited t)
                    (format nil "OK: ~a" bar))
    (let ((handler (clack:clackup app
                                  :port 5001
                                  :silent t)))
      (unwind-protect
           (multiple-value-bind (body status)
               ;; There is a race condition between the app starting to listen
               ;; and the following http request, which can trigger an
               ;; usocket:connection-refused-error.  This has only happened when
               ;; the system was under load from unrelated processes.
               (block nil
                 (tagbody
                  start
                    (restart-case
                        (return (drakma:http-request "http://localhost:5001/foo"
                                                     :method :post
                                                     :parameters '(("bar" . "baz"))))
                      (retry ()
                        :report (lambda (stream)
                                  (format stream "Retry HTTP request"))
                        (go start)))))
             (is (= status 200))
             (is (string= body "OK: baz"))
             (is visited))
        (when handler
          (clack:stop handler))))))

#|
  0: (USOCKET::HANDLE-CONDITION #<SB-BSD-SOCKETS:CONNECTION-REFUSED-ERROR {1006FC6693}> #<USOCKET:STREAM-USOCKET {1006FC5B13}>)
  1: (SIGNAL #<SB-BSD-SOCKETS:CONNECTION-REFUSED-ERROR {1006FC6693}>)
  2: (ERROR SB-BSD-SOCKETS:CONNECTION-REFUSED-ERROR :ERRNO 111 :SYSCALL "connect")
  3: (SB-BSD-SOCKETS:SOCKET-ERROR "connect" 111)
  4: (SB-BSD-SOCKETS::CALL-WITH-SOCKET-ADDR #<SB-BSD-SOCKETS:INET-SOCKET 0.0.0.0:57503, fd: 8 {1006FC58F3}> (#(127 0 0 1) 5001) #<CLOSURE (FLET SB-BSD-SOCKETS::WITH-SOCKET-ADDR-THUNK :IN SB-BSD-SOCKETS:SOC..
  5: ((:METHOD SB-BSD-SOCKETS:SOCKET-CONNECT (SB-BSD-SOCKETS:SOCKET)) #<SB-BSD-SOCKETS:INET-SOCKET 0.0.0.0:57503, fd: 8 {1006FC58F3}> #(127 0 0 1) 5001) [fast-method]
  6: ((FLET #:WITHOUT-INTERRUPTS-BODY-139 :IN USOCKET:SOCKET-CONNECT))
  7: (USOCKET:SOCKET-CONNECT "localhost" 5001 :PROTOCOL :STREAM :ELEMENT-TYPE FLEXI-STREAMS:OCTET :TIMEOUT 20 :DEADLINE NIL :NODELAY :IF-SUPPORTED :LOCAL-HOST NIL :LOCAL-PORT NIL)
  8: (DRAKMA:HTTP-REQUEST #<PURI:URI http://localhost:5001/foo> :METHOD :POST :PARAMETERS (("bar" . "baz")))
  9: ((LABELS RIGA-TEST::TEST-DEFROUTE :IN RIGA-TEST::TEST-DEFROUTE))
|#
