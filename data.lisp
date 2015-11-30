(in-package #:riga)

(defclass liga ()
  ((id :type integer
       :primary-key t
       :reader liga-id)
   (kurzname :type (varchar 16)
             :initarg :kurzname
             :accessor liga-kurzname)
   (name :type (varchar 128)
         :initarg :name
         :accessor liga-name)
   (runden :type integer
           :initarg :runden
           :accessor liga-runden))
  (:metaclass integral:<dao-table-class>)
  (:table-name "ligen"))
