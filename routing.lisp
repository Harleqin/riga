(in-package #:riga)

(defmacro defroute (route-spec (&rest parameters) &body body)
  "Sets the ningle handler given by ROUTE-SPEC to a function with body BODY that
has PARAMETERS bound to the query parameters by case insensitive string
comparison."
  (with-gensyms (args)
    `(setf ,(cons 'ningle:route route-spec)
           (lambda (,args)
             (declare (ignorable ,args))
             (assoc-bind (,parameters ,args
                                      :var-transform #'string
                                      :test #'equalp)
               ,@body)))))
