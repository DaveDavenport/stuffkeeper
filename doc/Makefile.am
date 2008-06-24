AUTOMAKE_OPTIONS = 1.6

## Process this file with automake to produce Makefile.in
# The name of the module.
DOC_MODULE="stuffkeeper"

# Extra content files
content_files=version.xml


HTML_IMAGES=

# The top-level SGML file.
DOC_MAIN_SGML_FILE = stuffkeeper.sgml 

#SCANGOBJ_OPTIONS =
SCAN_OPTIONS = --deprecated-guards="STUFFKEEPER_DISABLE_DEPRECATED"

DOC_SOURCE_DIR = ../src/
HFILE_GLOB = $(top_srcdir)/src/*.h
CFILE_GLOB = $(top_srcdir)/src/*.c
IGNORE_HFILES = *-private.h

# Extra options to supply to gtkdoc-mkdb
MKDB_OPTIONS=--sgml-mode --output-format=xml


INCLUDES=\
	-I$(top_srcdir)\
	@CFLAGS@\
	@glib_CFLAGS@\
	@gobject_CFLAGS@\
	@gtk_CFLAGS@\
	@gmodule_CFLAGS@\
	@libglade_CFLAGS@\
	@sqlite3_CFLAGS@\
	@gthread_CFLAGS@\
	@gio_CFLAGS@

GTKDOC_LIBS=\
	@glib_LIBS@\
	@LIBS@ \
	@gobject_LIBS@\
	@gtk_LIBS@\
	@gmodule_LIBS@\
	@libglade_LIBS@\
	@sqlite3_LIBS@\
	@gthread_LIBS@\
	@gio_LIBS@




include $(top_srcdir)/gtk-doc.make

# Other files to distribute
EXTRA_DIST += version.xml.in

