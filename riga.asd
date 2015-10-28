;;;; riga.asd

(asdf:defsystem #:riga
  :description "A web based league management system"
  :author "Svante von Erichsen <svante.v.erichsen@web.de>"
  :license "public domain"
  :depends-on (#:clack #:cl-who #:crane #:ningle)
  :serial t
  :components ((:file "package")
               (:file "riga")))

