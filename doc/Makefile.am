all: doc
doc: stuffkeeper.doxy
	doxygen $<
clean:
	rm -rf html

EXTRA_DIST=\
		stuffkeeper.doxy.in

DISTCLEANFILES=\
		stuffkeeper.doxy

.PHONY: all doc
