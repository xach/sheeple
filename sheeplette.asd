(asdf:defsystem sheeplette
  :version "Baahh"
  :description "Closette:CLOS::Sheeplette:Sheeple"
  :author "Kat Marchan <kzm@sykosomatic.org>"
  :licence "MIT"
  :depends-on ()
  :serial t
  :components 
  ((:module src
	    :serial t
	    :components
	    ((:file "trivial-garbage")
	     (:file "packages")
	     (:file "utils")
	     (:file "sheeplette")))))