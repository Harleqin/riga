(in-package #:riga)

;;; App

(defvar *app* (make-instance 'ningle:<app>))

(setf (ningle:route *app* "/hello")
      (cl-who:with-html-output (*standard-output*)
        (:h1 "hello!")))

;;; Server

(defvar *handler* nil)

(defun server-start ()
  (setf *handler* (clack:clackup *app*)))

(defun server-stop ()
  (when *handler*
    (clack:stop *handler*)))

;;; DB

(defclass liga ()
  ((id :type integer
       :primary-key t
       :auto-increment t
       :reader liga-id)
   (name :type (varchar 128)
         :initarg :name
         :accessor liga-name)
   (runden :type integer
           :initarg :runden
           :accessor liga-runden))
  (:metaclass integral:<dao-table-class>)
  (:table-name "ligen"))

(defun db-start ()
  (integral:connect-toplevel :postgresql
                             :database-name "riga"
                             :username "riga"
                             :password "22eWuBVxRW"))

