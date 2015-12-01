(in-package #:riga)

(defmacro assoc-bind ((vars alist
                       &key (var-transform '#'identity)
                            (key '#'identity)
                            (test '#'eql))
                      &body body)
  "Binds the given VARS to the values found \(by ASSOC with the given :KEY
and :TEST arguments\) under their name \(optionally transformed by
VAR-TRANSFORM\) in ALIST."
  (once-only (alist)
    `(let ,(mapcar (lambda (var)
                     `(,var (cdr (assoc (funcall ,var-transform ',var) ,alist
                                        :key ,key
                                        :test ,test))))
                   vars)
       ,@body)))
