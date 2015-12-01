(in-package #:riga)

;;; App

(defvar *app* (make-instance 'ningle:<app>))

(defroute (*app* "/hello") (foo)
  (standard-page ()
    (:h1 "hello!" (str foo))))

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
