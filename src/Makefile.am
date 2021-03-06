NULL=

REVISION=$(shell git rev-parse --short master)
CONF_VERSION=0
-include Makefile.config

bin_PROGRAMS=stuffkeeper

stuffkeeper_GOBFILES=\
   	stuffkeeper-data-backend.gob \
	stuffkeeper-data-boolean.gob \
	stuffkeeper-data-date2.gob \
	stuffkeeper-data-entry-config.gob \
	stuffkeeper-data-entry.gob \
	stuffkeeper-data-expander.gob \
	stuffkeeper-data-image.gob \
	stuffkeeper-data-item.gob \
	stuffkeeper-data-item-search.gob \
	stuffkeeper-data-label.gob \
	stuffkeeper-data-link.gob \
	stuffkeeper-data-list2.gob \
	stuffkeeper-data-rating.gob \
	stuffkeeper-data-schema.gob \
	stuffkeeper-data-spinbutton-config.gob \
	stuffkeeper-data-spinbutton.gob \
	stuffkeeper-data-tag.gob \
	stuffkeeper-data-taglist2.gob \
	stuffkeeper-data-text.gob \
	stuffkeeper-edit-schema.gob \
	stuffkeeper-export-html.gob \
	stuffkeeper-interface.gob \
	stuffkeeper-item-view.gob \
	stuffkeeper-item-window.gob \
	stuffkeeper-plugin.gob \
	stuffkeeper-plugin-manager.gob \
	stuffkeeper-show-item.gob \
	$(NULL)

stuffkeeper_GOBSOURCES=\
	$(stuffkeeper_GOBFILES:.gob=.c) \
	$(stuffkeeper_GOBFILES:.gob=.h) \
	$(stuffkeeper_GOBFILES:.gob=-private.h) \
	$(NULL)

stuffkeeper_GOBSTAMPS=\
	$(stuffkeeper_GOBFILES:.gob=.gob.stamp) \
	$(NULL)
stuffkeeper_VALAFILES=\
    stuffkeeper-data-files.vala\
	stuffkeeper-data-boolean-config.vala \
	stuffkeeper-data-rating-config.vala \
    stuffkeeper-multiple-item-view.vala \
    stuffkeeper-data-image-config.vala \
	$(NULL)

stuffkeeper_VALASOURCES=\
	$(stuffkeeper_VALAFILES:.vala=.c) \
	$(stuffkeeper_VALAFILES:.vala=.h) \
	$(NULL)

stuffkeeper_VALASTAMPS=\
	$(stuffkeeper_VALAFILES:.vala=.vala.stamp) \
	$(NULL)
##
# These files should be compiled, but may _not_ be
# in the dist
##
nodist_stuffkeeper_SOURCES=\
	$(stuffkeeper_GOBSOURCES) \
	$(stuffkeeper_VALASOURCES) \
	$(NULL)
##
# Sources that should be in the distribution 
##
stuffkeeper_SOURCES=\
	main.c \
	misc.c \
	misc.h \
	stuffkeeperglue.h \
	$(NULL)

##
# Generated sources
##
BUILT_SOURCES=\
	revision.h \
	revisiont.h \
	$(stuffkeeper_VALASTAMPS) \
	$(stuffkeeper_GOBSTAMPS) \
	$(NULL)

%.gob.stamp: %.gob
	@GOB2@ --always-private-header $<
	@touch $(top_builddir)/src/$@

#stuffkeeper.vala.stamp: $(stuffkeeper_VALAFILES)
#	@rm -f stuffkeeper.vala.tmp
#	@touch -f stuffkeeper.vala.tmp
#	@VALAC@ -C --vapidir=$(top_srcdir)/vala/ --pkg=gtk+-2.0 --pkg=glib-2.0 \
#		--pkg=gmodule-2.0 --pkg=stuffkeeper $^
#	@mv -f stuffkeeper.vala.tmp $@

%.vala.stamp: %.vala
	$(info Building $^)
	@VALAC@ -b $(top_builddir)/src/ -C --vapidir=$(top_srcdir)/vala/ --pkg=gtk+-2.0 --pkg=glib-2.0 --pkg=gio-2.0 \
	--pkg=gmodule-2.0 --pkg=stuffkeeper --use-header $^ -H $(notdir $(^:.vala=.h))
	@touch -f $@



# Handle the case where a vala file was deleted but not the stamp file
# This code avoids problems with parallel compilation by using an empty 
# directory as a lock mechanism
#$(stuffkeeper_VALASOURCES): stuffkeeper.vala.stamp
#	@if test -f $@; then :; else \
#		trap 'rm -rf $<.lock $<' 1 2 13 15; \
#		if mkdir $<.lock 2>/dev/null; then \
#			rm -f $<; \
#			$(MAKE) $(AM_MAKEFLAGS) $<; \
#			rmdir $<.lock; \
#		else ;
#			while test -d $<.lock; do sleep 1; done; \
#			test -f $<; exit $$?; \
#		fi; \
#	fi

.PHONY: revisiont.h
revisiont.h:
	@if test '$(REVISION)' != '$(CONF_VERSION)'; then\
		echo "Writing new Makefile.config file";\
		echo "CONF_VERSION=$(REVISION)" > Makefile.config;\
	fi;

revision.h:
		echo "static char *revision = \"$(REVISION)""\"; "> revision.h;

LIBS= \
	@glib_LIBS@\
	@LIBS@ \
	@gobject_LIBS@\
	@gtk_LIBS@\
	@gmodule_LIBS@\
	@sqlite3_LIBS@\
	@libxml_LIBS@\
	@gthread_LIBS@\
	@gio_LIBS@\
    @unique_LIBS@\
	$(NULL)


AM_LDFLAGS = \
	@LDFLAGS@ \
	$(NULL)

AM_CFLAGS = \
	@CFLAGS@ \
	@glib_CFLAGS@ \
	@gobject_CFLAGS@ \
	@gtk_CFLAGS@ \
	@gmodule_CFLAGS@ \
	@sqlite3_CFLAGS@ \
	@libxml_CFLAGS@\
	@gthread_CFLAGS@ \
	@gio_CFLAGS@ \
    @unique_CFLAGS@\
	-DLOG_DOMAIN="\"StuffKeeper\""
	-DPACKAGE_LIB_DIR=\""$(pkglibdir)"\" \
	-Wall\
	-DPIXMAP_PATH=\""$(pkgdatadir)"\" \
	-DGLADE_PATH=\""$(pkgdatadir)"\" \
	-DVERSION=\"@VERSION@\" \
	$(NULL)

##
# Should be installed so plugins can be compiled
##
nodist_stuffkeeperinclude_HEADERS = \
	stuffkeeperglue.h\
	stuffkeeper-data-item.h\
	stuffkeeper-data-schema.h\
	stuffkeeper-data-backend.h\
	stuffkeeper-data-tag.h\
    stuffkeeper-item-window.h\
	stuffkeeper-plugin.h\
	stuffkeeper-interface.h\
	stuffkeeper-data-item-search.h\
	$(NULL)

stuffkeeperincludedir =$(includedir)/stuffkeeper/

##
# Extra files that should be shipped with the distributions.
# This include gob files and vala files 
##
EXTRA_DIST=\
	$(stuffkeeper_GOBFILES)\
	$(stuffkeeper_VALAFILES)\
	$(NULL)

##
# Cleanup generated files
##
CLEANFILES=\
	stuffkeeper.vala.stamp \
	revision.h\
	Makefile.config\
	$(stuffkeeper_GOBSOURCES) \
	$(stuffkeeper_VALASOURCES) \
	$(stuffkeeper_GOBSTAMPS) \
	$(stuffkeeper_VALASTAMPS)\
	$(NULL)
