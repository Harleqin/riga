;;;; riga.asd

(in-package #:cl-user)

(defpackage #:riga-asdf
  (:use #:cl #:asdf))

(in-package #:riga-asdf)

(defsystem #:riga
  :description "A web based league management system"
  :author "Svante von Erichsen <svante.v.erichsen@web.de>"
  :license "public domain"
  :depends-on (#:alexandria
               #:cl-who
               #:clack
               #:dbd-postgres
               #:integral
               #:ningle)
  :serial t
  :components ((:file "package")
               (:file "util")
               (:file "routing")
               (:file "page")
               (:file "data")
               (:file "direct")
               (:file "riga"))
  :in-order-to ((test-op (test-op #:riga-test))))

(defsystem #:riga-test
  :description "Tests for riga"
  :author "Svante von Erichsen <svante.v.erichsen@web.de>"
  :license "public domain"
  :depends-on (#:riga #:hu.dwim.stefil)
  :serial t
  :components ((:module "test"
                        :serial t
                        :components
                        ((:file "package")
                         (:file "test-suite")
                         (:file "util-test"))))
  :perform (test-op (o c) (uiop:symbol-call 'riga-test 'riga-tests)))
