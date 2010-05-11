plugindir=${libdir}/stuffkeeper/

plugin_LTLIBRARIES =\
	libgenericinput.la\
	libtagcloud.la

EXTRA_DIST=stuffkeeper.vapi

libgenericinput_la_SOURCES=\
	genericinput.c

libtagcloud_la_SOURCES=\
	tagcloud.c

BUILT_SOURCES=\
    genericinput.vala.stamp\
    tagcloud.vala.stamp

LIBS= \
	@glib_LIBS@\
	@LIBS@ \
	@gobject_LIBS@\
	@gtk_LIBS@\
	@gmodule_LIBS@\
	@libglade_LIBS@\
	@gthread_LIBS@


AM_CFLAGS = \
	@CFLAGS@ \
	@glib_CFLAGS@ \
	@gobject_CFLAGS@ \
	@gtk_CFLAGS@ \
	@gmodule_CFLAGS@ \
	@libglade_CFLAGS@ \
	@gthread_CFLAGS@ \
	-DPACKAGE_LIB_DIR=\""$(pkglibdir)"\" \
	-Wall\
	-DPIXMAP_PATH=\""$(pkgdatadir)"\" \
	-DGLADE_PATH=\""$(pkgdatadir)"\" \
	-DVERSION=\"@VERSION@\" \
	-I $(top_srcdir)/src/

%.vala.stamp: %.vala
	$(VALAC) -b $(top_builddir)/vala/ -C --vapidir=$(top_srcdir)/vala/ --pkg=gtk+-2.0 --pkg=glib-2.0 --pkg=gmodule-2.0 --pkg=stuffkeeper $^ 
	@touch -f $@
