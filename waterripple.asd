;;;; waterripple.asd

(asdf:defsystem #:waterripple
  :description "A implementation of Coding Trains Coding Challenge 102"
  :author "Timo 'eXodiquas' Netzer <exodiquas@gmail.com>"
  :license  ""
  :version "0.0.1"
  :serial t
  :depends-on ("trivial-gamekit")
  :components ((:file "package")
               (:file "waterripple")))
