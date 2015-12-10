(in-package #:riga)

(define-constant +html5-doctype+ "<!DOCTYPE html>"
  :test #'string-equal)

(defvar *page-output* (make-broadcast-stream)
  "A stream variable that will be bound to a string output stream in the dynamic
extent of a page-emitting macro such as standard-page.")

(defmacro standard-page ((&key title (stream '*page-output*)) &body body)
  "Render a full page to string.  TITLE will be appended to the app name if
given.  Establishes the stream to be used by the HTML macro."
  `(with-html-output-to-string (,stream
                                nil
                                :prologue ,+html5-doctype+)
     (:html
      (:head
       (:title "Riga" ,@(when title
                              `((str ": ")
                                (str ,title)))))
      (:body ,@body))))

(defmacro html ((&optional (stream '*page-output*)) &body body)
  "Render to stream.  This is a simple wrapper around CL-WHO."
  `(with-html-output (,stream)
     ,@body))
