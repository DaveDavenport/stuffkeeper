# vala.m4 serial 1 (vala @VERSION@)
dnl Autoconf scripts for the Vala compiler
dnl Copyright (C) 2007  Mathias Hasselmann
dnl
dnl This library is free software; you can redistribute it and/or
dnl modify it under the terms of the GNU Lesser General Public
dnl License as published by the Free Software Foundation; either
dnl version 2 of the License, or (at your option) any later version.

dnl This library is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
dnl Lesser General Public License for more details.

dnl You should have received a copy of the GNU Lesser General Public
dnl License along with this library; if not, write to the Free Software
dnl Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
dnl
dnl Author:
dnl 	Mathias Hasselmann <mathias.hasselmann@gmx.de>
dnl --------------------------------------------------------------------------

dnl VALA_PROG_VALAC([MINIMUM-VERSION])
dnl
dnl Check whether the Vala compiler exists in `PATH'. If it is found the
dnl variable VALAC is set. Optionally a minimum release number of the compiler
dnl can be requested.
dnl --------------------------------------------------------------------------
AC_DEFUN([VALA_PROG_VALAC],[
  AC_PATH_PROG([VALAC], [valac], [])
  AC_SUBST(VALAC)

  if test -z "x${VALAC}"; then
    AC_MSG_WARN([No Vala compiler found. You will not be able to recompile .vala source files.])
  elif test -n "x$1"; then
    AC_REQUIRE([AC_PROG_AWK])
    AC_MSG_CHECKING([valac is at least version $1])

    if "${VALAC}" --version | "${AWK}" -v r='$1' 'function vn(s) { if (3 == split(s,v,".")) return (v[1]*1000+v[2])*1000+v[3]; else exit 2; } /^Vala / { exit vn(r) > vn($[2]) }'; then
      AC_MSG_RESULT([yes])
    else
      AC_MSG_RESULT([no])
      AC_MSG_ERROR([Vala $1 not found.])
    fi
  fi
])

dnl Autoconf macros for libgpgme
dnl $Id: gpgme.m4,v 1.1 2004/02/17 08:53:12 twb Exp $

# Configure paths for GPGME
# Shamelessly stolen from the one of XDELTA by Owen Taylor
# Werner Koch  2000-11-17

dnl AM_PATH_GPGME([MINIMUM-VERSION,
dnl               [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND ]]])
dnl Test for gpgme, and define GPGME_CFLAGS and GPGME_LIBS
dnl
AC_DEFUN([AM_PATH_GPGME],
[dnl
dnl Get the cflags and libraries from the gpgme-config script
dnl
  AC_ARG_WITH(gpgme-prefix,
   [  --with-gpgme-prefix=PFX   Prefix where gpgme is installed (optional)],
          gpgme_config_prefix="$withval", gpgme_config_prefix="")
  AC_ARG_ENABLE(gpgmetest,
   [  --disable-gpgmetest    Do not try to compile and run a test gpgme program],
          , enable_gpgmetest=yes)

  if test x$gpgme_config_prefix != x ; then
     gpgme_config_args="$gpgme_config_args --prefix=$gpgme_config_prefix"
     if test x${GPGME_CONFIG+set} != xset ; then
        GPGME_CONFIG=$gpgme_config_prefix/bin/gpgme-config
     fi
  fi

  AC_PATH_PROG(GPGME_CONFIG, gpgme-config, no)
  min_gpgme_version=ifelse([$1], ,1.0.0,$1)
  AC_MSG_CHECKING(for GPGME - version >= $min_gpgme_version)
  no_gpgme=""
  if test "$GPGME_CONFIG" = "no" ; then
    no_gpgme=yes
  else
    GPGME_CFLAGS=`$GPGME_CONFIG $gpgme_config_args --cflags`
    GPGME_LIBS=`$GPGME_CONFIG $gpgme_config_args --libs`
    gpgme_config_version=`$GPGME_CONFIG $gpgme_config_args --version`
    if test "x$enable_gpgmetest" = "xyes" ; then
      ac_save_CFLAGS="$CFLAGS"
      ac_save_LIBS="$LIBS"
      CFLAGS="$CFLAGS $GPGME_CFLAGS"
      LIBS="$LIBS $GPGME_LIBS"
dnl
dnl Now check if the installed gpgme is sufficiently new. Also sanity
dnl checks the results of gpgme-config to some extent
dnl
      rm -f conf.gpgmetest
      AC_TRY_RUN([
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gpgme.h>

int
main ()
{
 system ("touch conf.gpgmetest");

 if( strcmp( gpgme_check_version(NULL), "$gpgme_config_version" ) )
 {
   printf("\n"
"*** 'gpgme-config --version' returned %s, but GPGME (%s) was found!\n",
              "$gpgme_config_version", gpgme_check_version(NULL) );
   printf(
"*** If gpgme-config was correct, then it is best to remove the old\n"
"*** version of GPGME.  You may also be able to fix the error\n"
"*** by modifying your LD_LIBRARY_PATH enviroment variable, or by editing\n"
"*** /etc/ld.so.conf.  Make sure you have run ldconfig if that is\n"
"*** required on your system.\n"
"*** If gpgme-config was wrong, set the environment variable GPGME_CONFIG\n"
"*** to point to the correct copy of gpgme-config, \n"
"*** and remove the file config.cache before re-running configure\n"
        );
 }
 else if ( strcmp(gpgme_check_version(NULL), GPGME_VERSION ) )
 {
   printf("\n*** GPGME header file (version %s) does not match\n",
            GPGME_VERSION);
   printf("*** library (version %s)\n", gpgme_check_version(NULL) );
 }
 else
 {
        if ( gpgme_check_version( "$min_gpgme_version" ) )
             return 0;
  printf("no\n"
"*** An old version of GPGME (%s) was found.\n", gpgme_check_version(NULL) );
  printf(
"*** You need a version of GPGME newer than %s.\n", "$min_gpgme_version" );
  printf(
"*** The latest version of GPGME is always available at\n"
"***      ftp://ftp.gnupg.org/pub/gcrypt/alpha/gpgme/\n"
"*** \n"
"*** If you have already installed a sufficiently new version, this error\n"
"*** probably means that the wrong copy of the gpgme-config shell script is\n"
"*** being found. The easiest way to fix this is to remove the old version\n"
"*** of GPGME, but you can also set the GPGME_CONFIG environment to point to\n"
"*** the correct copy of gpgme-config. (In this case, you will have to\n"
"*** modify your LD_LIBRARY_PATH enviroment variable, or edit /etc/ld.so.conf\n"
"*** so that the correct libraries are found at run-time).\n"
      );
    }
  return 1;
}
],, no_gpgme=yes,[echo $ac_n "cross compiling; assumed OK... $ac_c"])
       CFLAGS="$ac_save_CFLAGS"
       LIBS="$ac_save_LIBS"
     fi
  fi
  if test "x$no_gpgme" = x ; then
     AC_MSG_RESULT(yes)
     ifelse([$2], , :, [$2])
  else
     if test -f conf.gpgmetest ; then
        :
     else
        AC_MSG_RESULT(no)
     fi
     if test "$GPGME_CONFIG" = "no" ; then
       echo "*** The gpgme-config script installed by GPGME could not be found"
       echo "*** If GPGME was installed in PREFIX, make sure PREFIX/bin is in"
       echo "*** your path, or set the GPGME_CONFIG environment variable to the"
       echo "*** full path to gpgme-config."
     else
       if test -f conf.gpgmetest ; then
        :
       else
          echo "*** Could not run gpgme test program, checking why..."
          CFLAGS="$CFLAGS $GPGME_CFLAGS"
          LIBS="$LIBS $GPGME_LIBS"
          AC_TRY_LINK([
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gpgme.h>
],      [ gpgme_check_version(NULL); return 0 ],
        [
echo "*** The test program compiled, but did not run. This usually means"
echo "*** that the run-time linker is not finding GPGME or finding the wrong"
echo "*** version of GPGME. If it is not finding GPGME, you'll need to set your"
echo "*** LD_LIBRARY_PATH environment variable, or edit /etc/ld.so.conf to point"
echo "*** to the installed location  Also, make sure you have run ldconfig if"
echo "*** that is required on your system"
echo "***"
echo "*** If you have an old version installed, it is best to remove it,"
echo "*** although you may also be able to get things to work by"
echo "*** modifying LD_LIBRARY_PATH"
echo "***"
        ],
        [
echo "*** The test program failed to compile or link. See the file config.log"
echo "*** for the exact error that occured. This usually means GPGME was"
echo "*** incorrectly installed or that you have moved GPGME since it was"
echo "*** installed. In the latter case, you may want to edit the"
echo "*** gpgme-config script: $GPGME_CONFIG"
        ])
          CFLAGS="$ac_save_CFLAGS"
          LIBS="$ac_save_LIBS"
       fi
     fi
     GPGME_CFLAGS=""
     GPGME_LIBS=""
     ifelse([$3], , :, [$3])
  fi
  AC_SUBST(GPGME_CFLAGS)
  AC_SUBST(GPGME_LIBS)
  rm -f conf.gpgmetest
])

dnl Make automake/libtool output more friendly to humans
dnl
dnl Copyright (c) 2009, Damien Lespiau <damien.lespiau@gmail.com>
dnl
dnl Permission is hereby granted, free of charge, to any person
dnl obtaining a copy of this software and associated documentation
dnl files (the "Software"), to deal in the Software without
dnl restriction, including without limitation the rights to use,
dnl copy, modify, merge, publish, distribute, sublicense, and/or sell
dnl copies of the Software, and to permit persons to whom the
dnl Software is furnished to do so, subject to the following
dnl conditions:
dnl
dnl The above copyright notice and this permission notice shall be
dnl included in all copies or substantial portions of the Software.
dnl
dnl THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
dnl EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
dnl OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
dnl NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
dnl HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
dnl WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
dnl FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
dnl OTHER DEALINGS IN THE SOFTWARE.
dnl
dnl SHAVE_INIT([shavedir],[default_mode])
dnl
dnl shavedir: the directory where the shave scripts are, it defaults to
dnl           $(top_builddir)
dnl default_mode: (enable|disable) default shave mode.  This parameter
dnl               controls shave's behaviour when no option has been
dnl               given to configure.  It defaults to disable.
dnl
dnl * SHAVE_INIT should be called late in your configure.(ac|in) file (just
dnl   before AC_CONFIG_FILE/AC_OUTPUT is perfect.  This macro rewrites CC and
dnl   LIBTOOL, you don't want the configure tests to have these variables
dnl   re-defined.
dnl * This macro requires GNU make's -s option.

AC_DEFUN([_SHAVE_ARG_ENABLE],
[
  AC_ARG_ENABLE([shave],
    AS_HELP_STRING(
      [--enable-shave],
      [use shave to make the build pretty [[default=$1]]]),,
      [enable_shave=$1]
    )
])

AC_DEFUN([SHAVE_INIT],
[
  dnl you can tweak the default value of enable_shave
  m4_if([$2], [enable], [_SHAVE_ARG_ENABLE(yes)], [_SHAVE_ARG_ENABLE(no)])

  if test x"$enable_shave" = xyes; then
    dnl where can we find the shave scripts?
    m4_if([$1],,
      [shavedir="$ac_pwd"],
      [shavedir="$ac_pwd/$1"])
    AC_SUBST(shavedir)

    dnl make is now quiet
    AC_SUBST([MAKEFLAGS], [-s])
    AC_SUBST([AM_MAKEFLAGS], ['`test -z $V && echo -s`'])

    dnl we need sed
    AC_CHECK_PROG(SED,sed,sed,false)

    dnl substitute libtool
    SHAVE_SAVED_LIBTOOL=$LIBTOOL
    LIBTOOL="${SHELL} ${shavedir}/shave-libtool '${SHAVE_SAVED_LIBTOOL}'"
    AC_SUBST(LIBTOOL)

    dnl substitute cc/cxx
    SHAVE_SAVED_CC=$CC
    SHAVE_SAVED_CXX=$CXX
    SHAVE_SAVED_FC=$FC
    SHAVE_SAVED_F77=$F77
    SHAVE_SAVED_OBJC=$OBJC
    CC="${SHELL} ${shavedir}/shave cc ${SHAVE_SAVED_CC}"
    CXX="${SHELL} ${shavedir}/shave cxx ${SHAVE_SAVED_CXX}"
    FC="${SHELL} ${shavedir}/shave fc ${SHAVE_SAVED_FC}"
    F77="${SHELL} ${shavedir}/shave f77 ${SHAVE_SAVED_F77}"
    OBJC="${SHELL} ${shavedir}/shave objc ${SHAVE_SAVED_OBJC}"
    AC_SUBST(CC)
    AC_SUBST(CXX)
    AC_SUBST(FC)
    AC_SUBST(F77)
    AC_SUBST(OBJC)

    V=@
  else
    V=1
  fi
  Q='$(V:1=)'
  AC_SUBST(V)
  AC_SUBST(Q)
])

