# Process this file with autoconf to produce a configure script.

# Generate version.
m4_define([stuffkeeper_major_version], [0])
m4_define([stuffkeeper_minor_version], [10])
m4_define([stuffkeeper_micro_version], [0])
m4_define([stuffkeeper_version], [stuffkeeper_major_version.stuffkeeper_minor_version.stuffkeeper_micro_version])

AC_INIT(src)
AM_CONFIG_HEADER([config.h])
AM_INIT_AUTOMAKE([stuffkeeper], [stuffkeeper_version],qball@sarine.nl)


m4_define([stuffkeeper_name], "stuffkeeper")
AC_DEFINE(PROGRAM_NAME, stuffkeeper_name,["Program name"])
m4_define([stuffkeeper_website], "http://stuffkeeper.org/")
AC_DEFINE(PROGRAM_WEBSITE, stuffkeeper_website,["Program website "])
m4_define([stuffkeeper_bugtracker], "http://bugtracker.sarine.nl/")
AC_DEFINE(PROGRAM_BUGTRACKER, stuffkeeper_bugtracker,["Program bugtracker "])

##
# Versioning
##

STUFFKEEPER_MAJOR_VERSION=stuffkeeper_major_version
STUFFKEEPER_MINOR_VERSION=stuffkeeper_minor_version
STUFFKEEPER_MICRO_VERSION=stuffkeeper_micro_version
AC_DEFINE(STUFFKEEPER_MAJOR_VERSION, stuffkeeper_major_version, ["Major version of stuffkeeper"])
AC_DEFINE(STUFFKEEPER_MINOR_VERSION, stuffkeeper_minor_version, ["Minor version of stuffkeeper"])
AC_DEFINE(STUFFKEEPER_MICRO_VERSION, stuffkeeper_micro_version, ["Micro version of stuffkeeper"])
AC_DEFINE(PROGRAM_VERSION, "stuffkeeper_version", ["Combined version of stuffkeeper"]) 


# Checks for programs.

AC_PREREQ(2.59)
AC_PROG_INTLTOOL([0.21])
AC_PROG_LIBTOOL
AC_PROG_CC

# Checks for libraries.

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([stdlib.h string.h unistd.h])
AC_CHECK_HEADER([regex.h], [],
                [AC_MSG_ERROR([Required header regex.h not found.])])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST

AC_SUBST(GLIB_REQUIRED)
AC_SUBST(GTK_REQUIRED)

# Split this out, because pkgconfig macro doesn't return nicely what is missing

# glib
PKG_CHECK_MODULES([glib], glib-2.0 >= 2.10)
AC_SUBST(glib_LIBS)
AC_SUBST(glib_CFLAGS)

# gobject
PKG_CHECK_MODULES([gobject], gobject-2.0 >= 2.4)
AC_SUBST(gobject_LIBS)
AC_SUBST(gobject_CFLAGS)

#gtk
PKG_CHECK_MODULES([gtk], gtk+-2.0 >= 2.10)
AC_SUBST(gtk_LIBS)
AC_SUBST(gtk_CFLAGS)

#gmodule
PKG_CHECK_MODULES([gmodule], gmodule-2.0 >= 2.4)
AC_SUBST(gmodule_LIBS)
AC_SUBST(gmodule_CFLAGS)

# libglade
PKG_CHECK_MODULES([libglade], libglade-2.0)
AC_SUBST(libglade_LIBS)
AC_SUBST(libglade_CFLAGS)

# sqlite3
PKG_CHECK_MODULES([sqlite3], sqlite3)
AC_SUBST(sqlite3_LIBS)
AC_SUBST(sqlite3_CFLAGS)


# installation paths
AC_MSG_CHECKING(prefix)

if test "x${prefix}" = "xNONE"; then
	PACKAGE_PREFIX="${ac_default_prefix}"
else
	PACKAGE_PREFIX="${prefix}"
fi
AC_MSG_RESULT($PACKAGE_PREFIX)


eval PACKAGE_DATADIR="${PACKAGE_PREFIX}/share/${PACKAGE}"
AC_DEFINE_UNQUOTED(PACKAGE_DATADIR, "$PACKAGE_DATADIR", [Stuffkeeper datadir])

# i18n support
dnl please keep them in alphabetical order
ALL_LINGUAS=""

GETTEXT_PACKAGE=stuffkeeper_name
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE, "$GETTEXT_PACKAGE",[STUFFKEEPER gettext package])
AM_GLIB_GNU_GETTEXT


#AM_GNU_GETTEXT([external])
# setting correct paths
PACKAGE_LOCALE_DIR="${PACKAGE_PREFIX}/${DATADIRNAME}/locale"
AC_DEFINE_UNQUOTED(PACKAGE_LOCALE_DIR,"$PACKAGE_LOCALE_DIR",[The package's locale path for gettext])


AC_SUBST(PACKAGE_LOCALE_DIR)
AC_SUBST(PACKAGE_LIBS)

GOB2_CHECK(2.0.0)


AC_OUTPUT([
Makefile 
src/Makefile 
po/Makefile.in
po/Makefile
glade/Makefile
pixmaps/Makefile
data/Makefile
data/stuffkeeper.pc
types/Makefile
html/Makefile
])

echo "Now type make to build"
