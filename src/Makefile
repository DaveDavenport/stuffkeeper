#!/usr/bin/make -f
# Waf Makefile wrapper
WAF_HOME=/home/qball/Programming/Sarine/stuffkeeper

all:
	@/home/qball/Programming/Sarine/stuffkeeper/waf build

all-debug:
	@/home/qball/Programming/Sarine/stuffkeeper/waf -v build

all-progress:
	@/home/qball/Programming/Sarine/stuffkeeper/waf -p build

install:
	@if test -n "$(DESTDIR)"; then \
	    /home/qball/Programming/Sarine/stuffkeeper/waf install --destdir="$(DESTDIR)"; \
	else \
	    /home/qball/Programming/Sarine/stuffkeeper/waf install; \
	fi;

uninstall:
	@if test -n "$(DESTDIR)"; then \
	    /home/qball/Programming/Sarine/stuffkeeper/waf uninstall --destdir="$(DESTDIR)"; \
	else \
	    /home/qball/Programming/Sarine/stuffkeeper/waf uninstall; \
	fi;

clean:
	@/home/qball/Programming/Sarine/stuffkeeper/waf clean

distclean:
	@/home/qball/Programming/Sarine/stuffkeeper/waf distclean
	@-rm -rf _build_
	@-rm -f Makefile

check:
	@/home/qball/Programming/Sarine/stuffkeeper/waf check

dist:
	@/home/qball/Programming/Sarine/stuffkeeper/waf dist

