plugindir=${libdir}/stuffkeeper/

plugin_LTLIBRARIES = libgenericinput.la

EXTRA_DIST=stuffkeeper.vapi

libgenericinput_la_SOURCES=genericinput.c

BUILT_SOURCES=\
    genericinput.vala.stamp

libgenericinput_la_LIBS= \
	@glib_LIBS@\
	@LIBS@ \
	@gobject_LIBS@\
	@gtk_LIBS@\
	@gmodule_LIBS@\
	@libglade_LIBS@\
	@sqlite3_LIBS@\
	@gthread_LIBS@\
	@gio_LIBS@\
	@GPGME_LIBS@ \
	$(NULL)


libgenericinput_la_LDFLAGS = \
	@LDFLAGS@ \
	$(NULL)

libgenericinput_la_CFLAGS = \
	@CFLAGS@ \
	@glib_CFLAGS@ \
	@gobject_CFLAGS@ \
	@gtk_CFLAGS@ \
	@gmodule_CFLAGS@ \
	@libglade_CFLAGS@ \
	@sqlite3_CFLAGS@ \
	@gthread_CFLAGS@ \
	@gio_CFLAGS@ \
	@GPGME_CFLAGS@ \
	-DPACKAGE_LIB_DIR=\""$(pkglibdir)"\" \
	-Wall\
	-DPIXMAP_PATH=\""$(pkgdatadir)"\" \
	-DGLADE_PATH=\""$(pkgdatadir)"\" \
	-DVERSION=\"@VERSION@\" \
	-I $(top_srcdir)/src/\
	$(NULL)

genericinput.vala.stamp: genericinput.vala
	$(VALAC) -b $(top_builddir)/vala/ -C --vapidir=$(top_srcdir)/vala/ --pkg=gtk+-2.0 --pkg=glib-2.0 --pkg=gmodule-2.0 --pkg=stuffkeeper $^ 
	@touch -f $@
