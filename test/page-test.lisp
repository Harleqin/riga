(in-package #:riga-test)

(deftest (test-standard-page :in riga-tests) ()
  (is (string= (riga::standard-page (:title "Test")
                 (:h1 "Ein Test"))
               "<!DOCTYPE html>
<html><head><title>Riga: Test</title></head><body><h1>Ein Test</h1></body></html>")))
