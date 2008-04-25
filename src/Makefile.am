REVISION=$(shell git rev-parse --short master)
CONF_VERSION=0
-include Makefile.config

bin_PROGRAMS=stuffkeeper
stuffkeeper_SOURCES=\
	misc.c\
	main.c\
	debug.c\
	sexy-icon-entry.c\
	egg-datetime.c\
	bacon-message-connection.c\
	stuffkeeper-data-backend.c\
	stuffkeeper-data-schema.c\
	stuffkeeper-data-boolean.c\
	stuffkeeper-data-spinbutton.c\
	stuffkeeper-data-date.c\
	stuffkeeper-data-tag.c\
	stuffkeeper-data-entry.c\
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
	stuffkeeper-plugin.c\
	stuffkeeper-plugin-manager.c

BUILT_SOURCES= revisiont.h\
	stuffkeeper-data-backend.c\
	stuffkeeper-data-schema.c\
	stuffkeeper-data-boolean.c\
	stuffkeeper-data-spinbutton.c\
	stuffkeeper-data-date.c\
	stuffkeeper-data-tag.c\
	stuffkeeper-data-entry.c\
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
	stuffkeeper-plugin.c\
	stuffkeeper-plugin-manager.c

%.c %.h %-private.h: %.gob
	@GOB2@ --no-touch-headers --always-private-header $<
	@touch $@

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
	@sqlite3_LIBS@


AM_LDFLAGS = \
	@LDFLAGS@

AM_CFLAGS = @CFLAGS@\
	@glib_CFLAGS@\
	@gobject_CFLAGS@\
	@gtk_CFLAGS@\
	@gmodule_CFLAGS@\
	@libglade_CFLAGS@\
	@sqlite3_CFLAGS@\
	-DPACKAGE_LIB_DIR=\""$(pkglibdir)"\"

stuffkeeperinclude_HEADERS = \
	stuffkeeper-data-item.h\
	stuffkeeper-data-schema.h\
	stuffkeeper-data-backend.h\
	stuffkeeper-data-tag.h\
	stuffkeeper-plugin.h\
	stuffkeeper-data-item-search.h

stuffkeeperincludedir =$(includedir)/stuffkeeper/

EXTRA_DIST=\
		   bacon-message-connection.h\
		   egg-datetime.h\
		   debug.h\
		   misc.h\
		   sexy-icon-entry.h\
		   stuffkeeper-data-backend.h\
		   stuffkeeper-data-schema.h\
		   stuffkeeper-data-boolean.h\
		   stuffkeeper-data-spinbutton.h\
		   stuffkeeper-data-date.h\
		   stuffkeeper-data-tag.h\
		   stuffkeeper-data-entry.h\
		   stuffkeeper-data-taglist2.h\
		   stuffkeeper-data-expander.h\
		   stuffkeeper-data-text.h\
		   stuffkeeper-data-image.h\
		   stuffkeeper-edit-schema.h\
		   stuffkeeper-data-item-search.h\
		   stuffkeeper-export-html.h\
		   stuffkeeper-data-item.h\
		   stuffkeeper-interface.h\
		   stuffkeeper-data-label.h\
		   stuffkeeper-item-view.h\
		   stuffkeeper-data-link.h\
		   stuffkeeper-item-window.h\
		   stuffkeeper-data-list2.h\
		   stuffkeeper-show-item.h\
		   stuffkeeper-data-rating.h\
		   stuffkeeper-plugin.h\
		   stuffkeeper-plugin-manager.h\
		   stuffkeeper-data-backend-private.h\
		   stuffkeeper-data-schema-private.h\
		   stuffkeeper-data-boolean-private.h\
		   stuffkeeper-data-spinbutton-private.h\
		   stuffkeeper-data-date-private.h\
		   stuffkeeper-data-tag-private.h\
		   stuffkeeper-data-entry-private.h\
		   stuffkeeper-data-taglist2-private.h\
		   stuffkeeper-data-expander-private.h\
		   stuffkeeper-data-text-private.h\
		   stuffkeeper-data-image-private.h\
		   stuffkeeper-edit-schema-private.h\
		   stuffkeeper-data-item-search-private.h\
		   stuffkeeper-export-html-private.h\
		   stuffkeeper-data-item-private.h\
		   stuffkeeper-interface-private.h\
		   stuffkeeper-data-label-private.h\
		   stuffkeeper-item-view-private.h\
		   stuffkeeper-data-link-private.h\
		   stuffkeeper-item-window-private.h\
		   stuffkeeper-data-list2-private.h\
		   stuffkeeper-show-item-private.h\
		   stuffkeeper-data-rating-private.h\
		   stuffkeeper-plugin-private.h\
		   stuffkeeper-plugin-manager-private.h

clean-local:
	-rm stuffkeeper-*.h
	-rm stuffkeeper-*.c revision.h
	-rm Makefile.config
