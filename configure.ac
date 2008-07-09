# Process this file with autoconf to produce a configure script.

##
# Set some static information used throughout the program.
##
m4_define([stuffkeeper_name],       "stuffkeeper")
m4_define([stuffkeeper_website],    "http://stuffkeeper.org/")
m4_define([stuffkeeper_bugtracker], "http://bugtracker.sarine.nl/")
m4_define([stuffkeeper_email],      "qball@stuffkeeper.org");

# Version
m4_define([stuffkeeper_major_version], [0])
m4_define([stuffkeeper_minor_version], [11])
m4_define([stuffkeeper_micro_version], [1])

# generate needed values in f.e. header files
m4_define([stuffkeeper_version], [stuffkeeper_major_version.stuffkeeper_minor_version.stuffkeeper_micro_version])

AC_INIT(src)

AM_CONFIG_HEADER([config.h])
AM_INIT_AUTOMAKE([stuffkeeper], [stuffkeeper_version],  stuffkeeper_email)

AC_DEFINE(PROGRAM_WEBSITE,      stuffkeeper_website,    ["Program website"])
AC_DEFINE(PROGRAM_NAME,         stuffkeeper_name,       ["Program name"])
AC_DEFINE(PROGRAM_BUGTRACKER,   stuffkeeper_bugtracker, ["Program bugtracker"])

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

##
# Parse extra command line options
##

# Debug output 
AC_ARG_ENABLE(debug, 
              [ --enable-debug           Print extra debug output.], 
              [ if test "x$enableval" = "xyes"; then 
                    enable_debug=yes 
                else 
                    enable_debug=no 
                fi],enable_debug=no)

if test x${enable_debug} = xyes; 
then
    AC_DEFINE(DEBUG, 1, [Enable debug output])
fi

# Timing output
AC_ARG_ENABLE(timing, 
              [ --enable-timing Print timing debug output.], 
              [ if test "x$enableval" = "xyes"; then 
                    enable_timing=yes 
                else 
                    enable_timing=no 
                fi],enable_timing=no)

if test x${enable_timing} = xyes; 
then
    AC_DEFINE(DEBUG_TIMING, 1, [Enable timing output])
fi



# Checks for libraries.

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([stdlib.h string.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST

AC_SUBST(GLIB_REQUIRED)
AC_SUBST(GTK_REQUIRED)

# Split this out, because pkgconfig macro doesn't return nicely what is missing

# glib
PKG_CHECK_MODULES([glib], glib-2.0 >= 2.16)
AC_SUBST(glib_LIBS)
AC_SUBST(glib_CFLAGS)

# gobject
PKG_CHECK_MODULES([gobject], gobject-2.0 >= 2.4)
AC_SUBST(gobject_LIBS)
AC_SUBST(gobject_CFLAGS)

#gtk
PKG_CHECK_MODULES([gtk], gtk+-2.0 >= 2.12)
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

# libgio
PKG_CHECK_MODULES([gio], gio-2.0)
AC_SUBST(gio_LIBS)
AC_SUBST(gio_CFLAGS)

PKG_CHECK_MODULES([gthread], gthread-2.0)
AC_SUBST(gthread_LIBS)
AC_SUBST(gthread_CFLAGS)

# Check for gtk-doc
AC_ARG_ENABLE(documentation, 
              [ --enable-doc Enable documentation.], 
              [case "${enableval}" in
               	yes)	enable_documentation=true;;
		no)	enable_documentation=false;;
		*) AC_MSG_ERROR([bad value ${enableval} for --enable-documentation]);
		esac],[enable_documentation=false])

AM_CONDITIONAL([DOC], [test x$enable_documentation = xtrue])

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
ALL_LINGUAS="de nl uk"

GETTEXT_PACKAGE=stuffkeeper
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE, "$GETTEXT_PACKAGE",[STUFFKEEPER gettext package])
AM_GLIB_GNU_GETTEXT


#AM_GNU_GETTEXT([external])
# setting correct paths
PACKAGE_LOCALE_DIR="${PACKAGE_PREFIX}/${DATADIRNAME}/locale"
AC_DEFINE_UNQUOTED(PACKAGE_LOCALE_DIR,"$PACKAGE_LOCALE_DIR",[The package's locale path for gettext])


AC_SUBST(PACKAGE_LOCALE_DIR)
AC_SUBST(PACKAGE_LIBS)

GOB2_CHECK(2.0.10)

STUFFKEEPER_PLUGIN_DIR="${PACKAGE_PREFIX}/lib/stuffkeeper_name/"
AC_DEFINE_UNQUOTED(STUFFKEEPER_PLUGIN_DIR,"$STUFFKEEPER_PLUGIN_DIR",[The directory the plugins are installed]) 


AC_OUTPUT([
Makefile 
src/Makefile 
po/Makefile.in
po/Makefile
glade/Makefile
pixmaps/Makefile
data/Makefile
data/stuffkeeper.pc
doc/Makefile
types/Makefile
html/Makefile
])

echo "Now type make to build"
if test x${enable_timing} = xyes; 
then
    echo "Timing output enabled";
fi
if test x${enable_debug} = xyes; 
then
    echo "Debug output enabled";
fi
