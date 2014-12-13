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

