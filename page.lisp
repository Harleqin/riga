(in-package #:riga)

(defmacro standard-page ((&key (title "Riga")) &body body)
  `(with-html-output-to-string (*standard-output*
                                nil
                                :prologue "<!DOCTYPE html>")
     (:html
      (:head
       (:title ,title))
      (:body ,@body))))
