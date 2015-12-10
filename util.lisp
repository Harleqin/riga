(in-package #:riga)

(defmacro assoc-bind ((vars alist
                       &key (var-transform '#'identity)
                            (key '#'identity)
                            (test '#'eql))
                      &body body)
  "Binds the given VARS to the values found \(by ASSOC with the given :KEY
and :TEST arguments\) under their name \(optionally transformed by
VAR-TRANSFORM\) in ALIST."
  (if vars
      (once-only (alist)
        `(let ,(mapcar (lambda (var)
                         `(,var (cdr (assoc (funcall ,var-transform ',var) ,alist
                                            :key ,key
                                            :test ,test))))
                       vars)
           ,@body))
      `(let () ; ignore alist
         ,@body)))

(defmacro with-retry-restart ((&key (description "Retry")) &body forms)
  "Establishes a block named NIL in which FORMS are executed in an implicit
PROGN.  FORMS will be reexecuted when the RETRY restart is invoked."
  (with-gensyms (start-tag stream)
    `(block nil
       (tagbody
        ,start-tag
          (restart-case
              (return (progn ,@forms))
            (retry ()
              :report (lambda (,stream)
                        (princ ,description ,stream))
              (go ,start-tag)))))))
