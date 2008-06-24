all: doc
doc:
	gtkdoc-scan --module=$(PACKAGE) --source-dir=../src --output-dir=.
	gtkdoc-mktmpl --module=$(PACKAGE)
	gtkdoc-mkdb --module=$(PACKAGE) --source-dir=../src --tmpl-dir=tmpl --output-format=xml --main-sgml-file=$(PACKAGE)-docs.sgml --sgml-mode
	gtkdoc-mkhtml $(PACKAGE) $(PACKAGE)-docs.sgml
clean:
	rm -f *.html sgml/* xml/* *.stamp


