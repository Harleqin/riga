;;;; riga.asd

(asdf:defsystem #:riga
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
               (:file "riga")))

