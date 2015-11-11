(in-package #:riga)

(defclass liga ()
  ((id :type serial
       :primary-key t
       :reader liga-id)
   (name :type (varchar 128)
         :initarg :name
         :accessor liga-name)
   (runden :type integer
           :initarg :runden
           :accessor liga-runden))
  (:metaclass integral:<dao-table-class>)
  (:table-name "ligen"))
