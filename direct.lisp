(in-package #:riga)

;;;; This file presents a direct convenience interface to the data, for use at
;;;; the REPL.

(defun create-liga (kurzname name runden)
  (integral:create-dao 'liga
                       :kurzname kurzname
                       :name name
                       :runden runden))

(defgeneric find-liga (key-name key-value)
  (:documentation "Retrieves a Liga from the data base by one of the unique
keys."))

(defmethod find-liga ((key-name (eql :id)) (key-value integer))
  (integral:find-dao 'liga key-value))

(defmethod find-liga ((key-name (eql :kurzname)) (key-value string))
  (first (integral:select-dao 'liga
                              (sxql:where (:= :kurzname key-value)))))
