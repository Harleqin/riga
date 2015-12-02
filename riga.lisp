(in-package #:riga)

;;; App

(defvar *app* (make-instance 'ningle:<app>))

(defroute (*app* "/ligen") ()
  (standard-page (:title "Hello")
    (:h2 "Ligen")
    (display-ligen)))

(defun display-ligen ()
  (html ()
    (:ul (mapc #'display-liga-line (all-ligen)))))

(defun display-liga-line (liga)
  (html ()
    (:li (esc (liga-name liga)))))

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
