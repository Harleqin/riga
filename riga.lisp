(in-package #:riga)

;;; App

(defvar *app* (make-instance 'ningle:<app>))

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

(defmacro defroute (route-spec (&rest parameters) &body body)
  "Sets the ningle handler given by ROUTE-SPEC to a function with body BODY that
has PARAMETERS bound to the query parameters by case insensitive string
comparison."
  (with-gensyms (args)
    `(setf ,(cons 'ningle:route route-spec)
           (lambda (,args)
             (assoc-bind (,parameters ,args
                                      :var-transform #'string
                                      :test #'equalp)
               ,@body)))))

(defroute (*app* "/hello") (foo)
  (cl-who:with-html-output-to-string (*standard-output*)
    (:h1 "hello!" (cl-who:str foo))))

;;; Server

(defvar *handler* nil)

(defun server-start ()
  (setf *handler* (clack:clackup *app*)))

(defun server-stop ()
  (when *handler*
    (clack:stop *handler*)))

;;; DB

(defun db-start (&key ensure-tables-p migrate-tables-p)
  (integral:connect-toplevel :postgres
                             :database-name "riga"
                             :username "riga"
                             :password "22eWuBVxRW")
  (when ensure-tables-p
    (dolist (table (find-all-table-classes))
      (integral:ensure-table-exists table)))
  (when migrate-tables-p
    (dolist (table (find-all-table-classes))
      (integral:migrate-table table))))

(defun find-all-table-classes ()
  (list 'liga)) ; FIXME: use the CLOS!
