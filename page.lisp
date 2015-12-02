(in-package #:riga)

(define-constant +html5-doctype+ "<!DOCTYPE html>"
  :test #'string-equal)

(defmacro standard-page ((&key title) &body body)
  "Render a full page to string.  TITLE will be appended to the app name if
given."
  `(with-html-output-to-string (*standard-output*
                                nil
                                :prologue +html5-doctype+)
     (:html
      (:head
       (:title "Riga" ,@(when title
                              `((str ": ")
                                (str ,title)))))
      (:body ,@body))))

(defmacro html ((&optional (stream '*standard-output*)) &body body)
  "Render to stream.  This is a simple wrapper around CL-WHO."
  `(with-html-output (,stream)
     ,@body))
