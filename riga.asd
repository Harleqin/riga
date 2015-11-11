;;;; riga.asd

(asdf:defsystem #:riga
  :description "A web based league management system"
  :author "Svante von Erichsen <svante.v.erichsen@web.de>"
  :license "public domain"
  :depends-on (#:cl-who
               #:clack
               #:dbd-postgres
               #:integral
               #:ningle)
  :serial t
  :components ((:file "package")
               (:file "data")
               (:file "riga")))

