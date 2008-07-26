REVISION=$(shell git rev-parse --short master)
CONF_VERSION=0
-include Makefile.config

bin_PROGRAMS=stuffkeeper

##
# These files should be compiled, but may _not_ be
# in the dist
##
nodist_stuffkeeper_SOURCES=\
	stuffkeeper-data-backend.c\
	stuffkeeper-data-schema.c\
	stuffkeeper-data-boolean.c\
	stuffkeeper-data-boolean-config.c\
	stuffkeeper-data-spinbutton.c\
	stuffkeeper-data-spinbutton-config.c\
	stuffkeeper-data-date2.c\
	stuffkeeper-data-tag.c\
	stuffkeeper-data-entry.c\
	stuffkeeper-data-entry-config.c\
	stuffkeeper-data-taglist2.c\
	stuffkeeper-data-expander.c\
	stuffkeeper-data-text.c\
	stuffkeeper-data-image.c\
	stuffkeeper-edit-schema.c\
	stuffkeeper-data-item-search.c\
	stuffkeeper-export-html.c\
	stuffkeeper-data-item.c\
	stuffkeeper-interface.c\
	stuffkeeper-data-label.c\
	stuffkeeper-item-view.c\
	stuffkeeper-data-link.c\
	stuffkeeper-item-window.c\
	stuffkeeper-data-list2.c\
	stuffkeeper-show-item.c\
	stuffkeeper-data-rating.c\
	stuffkeeper-data-rating-config.c\
	stuffkeeper-plugin.c\
	stuffkeeper-plugin-manager.c
##
# Sources that should be in the distribution 
##
stuffkeeper_SOURCES=\
	misc.c\
	main.c\
	debug.c\
	sexy-icon-entry.c\
	bacon-message-connection.c


##
# Generated sources
##
BUILT_SOURCES= revisiont.h\
	stuffkeeper-data-backend.c\
	stuffkeeper-data-schema.c\
	stuffkeeper-data-boolean.c\
	stuffkeeper-data-boolean-config.c\
	stuffkeeper-data-spinbutton.c\
	stuffkeeper-data-spinbutton-config.c\
	stuffkeeper-data-date2.c\
	stuffkeeper-data-tag.c\
	stuffkeeper-data-entry.c\
	stuffkeeper-data-entry-config.c\
	stuffkeeper-data-taglist2.c\
	stuffkeeper-data-expander.c\
	stuffkeeper-data-text.c\
	stuffkeeper-data-image.c\
	stuffkeeper-edit-schema.c\
	stuffkeeper-data-item-search.c\
	stuffkeeper-export-html.c\
	stuffkeeper-data-item.c\
	stuffkeeper-interface.c\
	stuffkeeper-data-label.c\
	stuffkeeper-item-view.c\
	stuffkeeper-data-link.c\
	stuffkeeper-item-window.c\
	stuffkeeper-data-list2.c\
	stuffkeeper-show-item.c\
	stuffkeeper-data-rating.c\
	stuffkeeper-data-rating-config.c\
	stuffkeeper-plugin.c\
	stuffkeeper-plugin-manager.c

%.c: %.gob
	@GOB2@ --no-touch-headers --always-private-header $<

%.c: %.vala
	@VALAC@ -C --vapidir=../vala/ --pkg=gtk+-2.0 --pkg=glib-2.0 --pkg=gmodule-2.0 --pkg=stuffkeeper $<

revisiont.h:
	@if test '$(REVISION)' != '$(CONF_VERSION)'; then\
		echo "Writing new Makefile.config file";\
		echo "static char *revision = \"$(REVISION)""\"; "> revision.h;\
		echo "CONF_VERSION=$(REVISION)" > Makefile.config;\
	fi;

INCLUDES= -Wall\
	-DPIXMAP_PATH=\""$(pkgdatadir)"\" \
	-DGLADE_PATH=\""$(pkgdatadir)"\" \
	-DVERSION=\"@VERSION@\"

LIBS= \
	@glib_LIBS@\
	@LIBS@ \
	@gobject_LIBS@\
	@gtk_LIBS@\
	@gmodule_LIBS@\
	@libglade_LIBS@\
	@sqlite3_LIBS@\
	@gthread_LIBS@\
	@gio_LIBS@


AM_LDFLAGS = \
	@LDFLAGS@

AM_CFLAGS = @CFLAGS@\
	@glib_CFLAGS@\
	@gobject_CFLAGS@\
	@gtk_CFLAGS@\
	@gmodule_CFLAGS@\
	@libglade_CFLAGS@\
	@sqlite3_CFLAGS@\
	@gthread_CFLAGS@\
	@gio_CFLAGS@\
	-DPACKAGE_LIB_DIR=\""$(pkglibdir)"\"

##
# Should be installed so plugins can be compiled
##
nodist_stuffkeeperinclude_HEADERS = \
    stuffkeeperglue.h\
	stuffkeeper-data-item.h\
	stuffkeeper-data-schema.h\
	stuffkeeper-data-backend.h\
	stuffkeeper-data-tag.h\
	stuffkeeper-plugin.h\
	stuffkeeper-interface.h\
	stuffkeeper-data-item-search.h

stuffkeeperincludedir =$(includedir)/stuffkeeper/

##
# Extra files that should be shipped with the distributions.
# This include gob files and header files 
##
EXTRA_DIST=\
		   bacon-message-connection.h\
		   debug.h\
		   misc.h\
		   sexy-icon-entry.h\
		   stuffkeeperglue.h\
		   stuffkeeper-data-backend.gob\
		   stuffkeeper-data-boolean.gob\
		   stuffkeeper-data-boolean-config.vala\
		   stuffkeeper-data-date2.gob\
		   stuffkeeper-data-entry.gob\
		   stuffkeeper-data-entry-config.gob\
		   stuffkeeper-data-expander.gob\
		   stuffkeeper-data-image.gob\
		   stuffkeeper-data-item.gob\
		   stuffkeeper-data-item-search.gob\
		   stuffkeeper-data-label.gob\
		   stuffkeeper-data-link.gob\
		   stuffkeeper-data-list2.gob\
		   stuffkeeper-data-rating.gob\
		   stuffkeeper-data-rating-config.vala\
		   stuffkeeper-data-schema.gob\
		   stuffkeeper-data-spinbutton.gob\
	stuffkeeper-data-spinbutton-config.gob\
		   stuffkeeper-data-tag.gob\
		   stuffkeeper-data-taglist2.gob\
		   stuffkeeper-data-text.gob\
		   stuffkeeper-edit-schema.gob\
		   stuffkeeper-export-html.gob\
		   stuffkeeper-interface.gob\
		   stuffkeeper-item-view.gob\
		   stuffkeeper-item-window.gob\
		   stuffkeeper-plugin.gob\
		   stuffkeeper-plugin-manager.gob\
		   stuffkeeper-show-item.gob

##
# Removes all generated files, use DISTCLEANFILES for this?
##
clean-local:
	-rm stuffkeeper-*.h
	-rm stuffkeeper-*.c revision.h
	-rm Makefile.config
	-rm revision.h
