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

(crane:setup :migrations-directory
             (asdf:system-relative-pathname '#:riga #p"migrations/")
             :databases '(:main (:type :postgres
                                 :name "riga"
                                 :user "riga"
                                 :pass "22eWuBVxRW"))
             :debug nil)

(defun db-start ()
  (crane:connect))

(crane:deftable liga ()
  (name :type text)
  (runden :type integer))
