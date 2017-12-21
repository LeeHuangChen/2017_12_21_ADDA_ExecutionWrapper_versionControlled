dnl aclocal.m4 generated automatically by aclocal 1.4

dnl Copyright (C) 1994, 1995-8, 1999 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY, to the extent permitted by law; without
dnl even the implied warranty of MERCHANTABILITY or FITNESS FOR A
dnl PARTICULAR PURPOSE.

dnl ------------------------------------------------------------------------------------
dnl adl_SEARCH_LIB_PATH_NOFUNC(HEADERS, PROGRAM BODY, LIB [, PATH [, VARIABLE-TO-SET
dnl            [, ACTION-IF-NOT-FOUND [, OTHER-LIBRARIES [, variable-name]]]]])
dnl variable-name: hack for mysql++, the ++ cause problems in filename
dnl Find the path for the library defining FUNC, if it's not already available.
dnl use a whole program to check if linking succeeds
AC_DEFUN(adl_SEARCH_LIB_PATH_NOFUNC,
[
AC_PREREQ([2.13])
AC_CACHE_CHECK(
	[for library path for $3], 
	[ac_cv_ldflags_$3],
	[	ac_ldflags_search_save_LIBS="$LIBS"
		ac_cv_ldflags_$3="no"

		dnl Try if library is needed
		AC_TRY_LINK([$1], [$2], [ac_cv_ldflags_$3="none required"])

		dnl Try if library is already on path
		LIBS="$7 $ac_ldflags_search_save_LIBS"	
		AC_TRY_LINK([$1], [$2], [ac_cv_ldflags_$3="none required"])

		test "$ac_cv_ldflags_$3" = "no" && for i in $4; do
			dnl echo Trying "$i"
			LIBS="-L$i -l$3 $7 $ac_ldflags_search_save_LIBS"
			AC_TRY_LINK([$1], [$2], [ac_cv_ldflags_$3="-L$i -l$3"; break])
		done
		LIBS="$ac_ldflags_search_save_LIBS"
	]
)

if test "$ac_cv_ldflags_$3" != "no"; then
	if test "$ac_cv_ldflags_$3" = "none required"; then
		$5="" 
	else :
		LIBS="$ac_cv_ldflags_$3 $LIBS"
		$5="$ac_cv_ldflags_$3"
	fi
	AC_SUBST($5)
else :
  	$6
fi
]
)  

dnl for some reason, this subroutine should not be the first?
dnl -> bus error in aclocal
dnl ------------------------------------------------------------------------------------
dnl AC_SEARCH_LIB_PATH(FUNCTION, LIB [, PATH [, VARIABLE-TO-SET
dnl            [, ACTION-IF-NOT-FOUND [, OTHER-LIBRARIES]]]])
dnl Find the path for the library defining FUNC, if it's not already available.
AC_DEFUN(adl_SEARCH_LIB_PATH,
[
AC_PREREQ([2.13])
AC_CACHE_CHECK(
		[for library path for $2], 
		[ac_cv_ldflags_$2],
		[	ac_ldflags_search_save_LIBS="$LIBS"
			ac_cv_ldflags_$2="no"
			AC_TRY_LINK_FUNC([$1], [ac_cv_ldflags_$2="none required"])
			test "$ac_cv_ldflags_$2" = "no" && for i in $3; do
				dnl echo Trying "$i"
				LIBS="-L$i -l$2 $6 $ac_ldflags_search_save_LIBS"
				AC_TRY_LINK_FUNC([$1],[ac_cv_ldflags_$2="-L$i -l$2"; break])
			done
			LIBS="$ac_ldflags_search_save_LIBS"
		]
)

if test "$ac_cv_ldflags_$2" != "no"; then
	if test "$ac_cv_ldflags_$2" = "none required"; then
		$4=""
	else :
		LIBS="$ac_cv_ldflags_$2 $LIBS"
		$4="$ac_cv_ldflags_$2"
	fi
	AC_SUBST($4)
else :
	$5
fi
]
)  

dnl ------------------------------------------------------------------------------------
dnl AC_SEARCH_INCLUDE_PATH(HEADER-FILE [, PATH [, VARIABLE-TO-SET
dnl            [, ACTION-IF-NOT-FOUND ]]])
dnl Find the path for the HEADER-FILE, if it's not already available.
AC_DEFUN(adl_SEARCH_INCLUDE_PATH,
[
AC_PREREQ([2.13])
ac_include_search_save_CPPFLAGS="$CPPFLAGS"
ac_safe=`echo "$1" | sed 'y%./+-%__p_%'`

eval "ac_cv_header_$ac_safe=\"no\""

dnl check whether header is in system headers
AC_CHECK_HEADER($1, eval "ac_cv_header_$ac_safe=\"none required\"")

dnl check whether header already found by current CPPFLAGS
AC_TRY_CPP(
	[#include <$1>],
	[eval "ac_cv_header_$ac_safe=\"none required\""],
	[]
)	

dnl check list of possible locations
eval "test \"`echo '$ac_cv_header_'$ac_safe`\" = \"no\"" && for i in $2; do
	AC_MSG_CHECKING([for $1 in $i])
	CPPFLAGS="-I$i $ac_include_search_save_CPPFLAGS"

	AC_TRY_CPP(
		[#include <$1>],
		[eval "ac_cv_header_$ac_safe=\"-I$i\""
		AC_MSG_RESULT("-I$i")
		break],
		AC_MSG_RESULT(no)
		)	
	done

CPPFLAGS="$ac_include_search_save_CPPFLAGS"
eval "ac_include_search_result=`echo \\\$ac_cv_header_$ac_safe`"

dnl append to CPPFLAGS
if test "$ac_include_search_result" != "no"; then
	if test "$ac_include_search_result" = "none required"; then
	 	$3=""
	else
		CPPFLAGS="$ac_include_search_result $CPPFLAGS"
	 	$3="$ac_include_search_result"
	fi
	AC_SUBST($3)
else :
  	$4
fi
])      

dnl ------------------------------------------------------------------------------------
dnl adl_SEARCH_LIB_PATH_NOFUNC_NOLIBS(HEADERS, PROGRAM BODY, LIB [, PATH [, VARIABLE-TO-SET
dnl            [, ACTION-IF-NOT-FOUND [, OTHER-LIBRARIES ]]]])
dnl Search for library in different paths. Put path into variable, but do not add to
dnl LIBS. You have to run AC_SUBST again for some reason.
AC_DEFUN(adl_SEARCH_LIB_PATH_NOFUNC_NOLIBS,
[
AC_PREREQ([2.13])
AC_CACHE_CHECK(
	[for library path for $3], 
	[ac_cv_ldflags_$3],
	[	ac_ldflags_search_save_LIBS="$LIBS"
		ac_cv_ldflags_$3="no"
		AC_TRY_LINK([$1], [$2], [ac_cv_ldflags_$3="none required"])
		test "$ac_cv_ldflags_$3" = "no" && for i in $4; do
			LIBS="-L$i -l$3 $7 $ac_ldflags_search_save_LIBS"
			AC_TRY_LINK([$1], [$2], [ac_cv_ldflags_$3="$i"])
		done
		LIBS="$ac_ldflags_search_save_LIBS"
	]
)

if test "$ac_cv_ldflags_$3" != "no"; then
	if test "$ac_cv_ldflags_$3" = "none required"; then
		$5="" 
	else :
		$5="$ac_cv_ldflags_$3"
	fi
	AC_SUBST($5)
else :
  	$6
fi
]
)  

dnl I do not check if it actually works, just if the files are present
dnl todo: use ./share/mysql.m4 and ./share/mysql++.m4

dnl #########################################################################
dnl Check for MySQL headers and libraries
dnl #########################################################################
dnl A macro for setting up mysql (ripped from Scott Barron's
dnl <sbarron@vvm.com> mysqltutor package)
AC_DEFUN(AC_PACKAGE_MYSQL,
[
AC_PROVIDE([$0])
AC_REQUIRE_CPP
 
ac_cv_with_mysql_dir=""
ac_cv_with_mysql_lib=""
ac_cv_with_mysql_inc=""
MYSQL_CFLAGS=""
MYSQL_LIBS=""
 
dnl command line options and --help descriptions
AC_ARG_WITH(mysql-dir,
    [  --with-mysql-dir           where the root of mysql is installed (/usr/local/mysql)],
    [  ac_cv_with_mysql_dir="$withval" ])
 
AC_ARG_WITH(mysql-include,
    [  --with-mysql-include       where the mysql headers are. (/usr/local/mysql/include) ],
    [  ac_cv_with_mysql_inc="$withval" ])
 
AC_ARG_WITH(mysql-lib,
    [  --with-mysql-lib           where the mysql library is installed. (/usr/local/mysql/lib)],
    [  ac_cv_with_mysql_lib="$withval" ])
 
dnl find some paths
 
AC_MSG_CHECKING("for MySQL directory")
 
for ac_dir in                   \
        ${ac_cv_with_mysql_dir} \
        /usr/mysql              \
        /usr/local/mysql        \
        /usr/share/mysql        \
        ;                       \
do
        if test -n "$ac_dir" && test -d "$ac_dir"; then
        ac_cv_with_mysql_dir="$ac_dir"
                break;
        fi
done
 
if test ! -n "$ac_cv_with_mysql_dir"; then
        AC_MSG_RESULT("Nonstandard")
else
        AC_MSG_RESULT("$ac_cv_with_mysql_dir")
fi                                                 

dnl check for libraries and includes
adl_SEARCH_INCLUDE_PATH([mysql.h],
[   $ac_cv_with_mysql_dir/include       \
    $ac_cv_with_mysql_dir/include/mysql \
    $ac_cv_with_mysql_inc               \
    /usr/include/mysql                  \
    /usr/local/include/mysql            \
    /usr/local/mysql/include            \
    /usr/local/mysql/include/mysql      \
    /usr/share/mysql/include            \
    /usr/share/include/mysql            \
],
[MYSQL_CFLAGS],
AC_MSG_ERROR([Can\'t find the MySQL headers])
)
 
adl_SEARCH_LIB_PATH_NOFUNC(
	[ 
#include <mysql.h>
MYSQL *m;
	],
	[ mysql_store_result(m) ], 
	mysqlclient,
[   $ac_cv_with_mysql_dir/lib   \
    $ac_cv_with_mysql_dir/lib/mysql   \
    $ac_cv_with_mysql_lib       \
    /usr/lib/mysql \
    /usr/local/lib/mysql \
    /usr/local/mysql/lib \
    /usr/local/mysql/lib/mysql \
    /usr/share/mysql/lib \
    /usr/share/lib/mysql \
],
[MYSQL_LIBS],
AC_MSG_ERROR([Can\'t find the libmysqlclient]),
-lm )

dnl Substitute some variables for use with SWIG
mysql_includedir="$MYSQL_CFLAGS"
AC_SUBST(mysql_includedir)
mysql_libdir="$MYSQL_LIBS"
AC_SUBST(mysql_libdir)

]
)  

dnl #########################################################################
dnl Check for alignlib headers and libraries
AC_DEFUN(AC_PACKAGE_ALIGNLIB,
[
AC_PROVIDE([$0])
AC_REQUIRE_CPP

dnl Save the compile language (restored later)
AC_LANG_SAVE
dnl Use C++ for compiling
AC_LANG_CPLUSPLUS
 
ac_cv_with_alignlib_dir=""
ac_cv_with_alignlib_lib=""
ac_cv_with_alignlib_inc=""

ALIGNLIB_CFLAGS=""
ALIGNLIB_LIBS=""

dnl command line options and --help descriptions
 AC_ARG_WITH(alignlib-dir,
    [  --with-alignlib-dir           where the root of alignlib is installed (/usr/local)],
    [  ac_cv_with_alignlib_dir="$withval" ]
)
AC_ARG_WITH(alignlib-include,
    [  --with-alignlib-include       where the alignlib headers are. (/usr/local/include) ],
    [  ac_cv_with_alignlib_inc="$withval" ]
)
AC_ARG_WITH(alignlib-lib,
    [  --with-alignlib-lib           where the alignlib library is installed. (/usr/local/lib)],
    [  ac_cv_with_alignlib_lib="$withval" ]
)
 
dnl 1. Check for include path:
adl_SEARCH_INCLUDE_PATH([alignlib.h],
[   $ac_cv_with_alignlib_inc \
    $ac_cv_with_alignlib_dir/include \
    $ac_cv_with_alignlib_dir/include/alignlib \
    /usr/include/alignlib                  \
    /usr/local/include/alignlib            \
    /usr/local/alignlib/include            \
    /usr/local/alignlib/include/alignlib      \
    /usr/share/alignlib/include            \
    /usr/share/include/alignlib            \
],
[ALIGNLIB_CFLAGS],
AC_MSG_ERROR([Can\'t find the alignlib headers])
)


adl_SEARCH_LIB_PATH_NOFUNC(
	[ 
#include <alignlib/HelpersSequence.h>
	],
	[ AlignLib::makeSequence("AAA") ], 
	alignlib,
	[  $ac_cv_with_alignlib_dir/lib   \
 	   $ac_cv_with_alignlib_lib       \
	   /usr/local/lib \
    	   /usr/lib/alignlib \
	   /usr/local/lib/alignlib \
    	   /usr/local/alignlib/lib \
    	   /usr/local/alignlib/lib/alignlib \
    	   /usr/share/alignlib/lib \
    	   /usr/share/lib/alignlib \
	],
	[ALIGNLIB_LIBS],
	AC_MSG_ERROR([Can\'t find libalignlib]),
	-lm
)

dnl Substitute some variables for use with SWIG
alignlib_includedir="$ALIGNLIB_CFLAGS"
AC_SUBST(alignlib_includedir)
alignlib_libdir="$ALIGNLIB_LIBS"
AC_SUBST(alignlib_libdir)

# LIBS="-lalignlib $LIBS"

dnl Restore the compile language
AC_LANG_RESTORE 

]
)

dnl #########################################################################
dnl Check command line option --enable-LFS
AC_DEFUN(adl_ENABLE_LFS,
[
AC_PROVIDE([$0])
 
ac_cv_enable_lfs=no
 
dnl command line options and --help descriptions
AC_ARG_ENABLE( lfs,
[  --enable-lfs		compile with large file system support \[default=no\] ],
ac_cv_enable_lfs=$enableval,	
ac_cv_enable_lfs=no	
)

if test x"$ac_cv_enable_lfs" = xyes; then
	CXXFLAGS="$CXXFLAGS -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE"
	AC_SUBST(CXXFLAGS)

	AC_MSG_CHECKING("Enable large file system support")
	AC_MSG_RESULT(yes)
fi
]
)



# Like AC_CONFIG_HEADER, but automatically create stamp file.

AC_DEFUN(AM_CONFIG_HEADER,
[AC_PREREQ([2.12])
AC_CONFIG_HEADER([$1])
dnl When config.status generates a header, we must update the stamp-h file.
dnl This file resides in the same directory as the config header
dnl that is generated.  We must strip everything past the first ":",
dnl and everything past the last "/".
AC_OUTPUT_COMMANDS(changequote(<<,>>)dnl
ifelse(patsubst(<<$1>>, <<[^ ]>>, <<>>), <<>>,
<<test -z "<<$>>CONFIG_HEADERS" || echo timestamp > patsubst(<<$1>>, <<^\([^:]*/\)?.*>>, <<\1>>)stamp-h<<>>dnl>>,
<<am_indx=1
for am_file in <<$1>>; do
  case " <<$>>CONFIG_HEADERS " in
  *" <<$>>am_file "*<<)>>
    echo timestamp > `echo <<$>>am_file | sed -e 's%:.*%%' -e 's%[^/]*$%%'`stamp-h$am_indx
    ;;
  esac
  am_indx=`expr "<<$>>am_indx" + 1`
done<<>>dnl>>)
changequote([,]))])

# Do all the work for Automake.  This macro actually does too much --
# some checks are only needed if your package does certain things.
# But this isn't really a big deal.

# serial 1

dnl Usage:
dnl AM_INIT_AUTOMAKE(package,version, [no-define])

AC_DEFUN(AM_INIT_AUTOMAKE,
[AC_REQUIRE([AC_PROG_INSTALL])
PACKAGE=[$1]
AC_SUBST(PACKAGE)
VERSION=[$2]
AC_SUBST(VERSION)
dnl test to see if srcdir already configured
if test "`cd $srcdir && pwd`" != "`pwd`" && test -f $srcdir/config.status; then
  AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
fi
ifelse([$3],,
AC_DEFINE_UNQUOTED(PACKAGE, "$PACKAGE", [Name of package])
AC_DEFINE_UNQUOTED(VERSION, "$VERSION", [Version number of package]))
AC_REQUIRE([AM_SANITY_CHECK])
AC_REQUIRE([AC_ARG_PROGRAM])
dnl FIXME This is truly gross.
missing_dir=`cd $ac_aux_dir && pwd`
AM_MISSING_PROG(ACLOCAL, aclocal, $missing_dir)
AM_MISSING_PROG(AUTOCONF, autoconf, $missing_dir)
AM_MISSING_PROG(AUTOMAKE, automake, $missing_dir)
AM_MISSING_PROG(AUTOHEADER, autoheader, $missing_dir)
AM_MISSING_PROG(MAKEINFO, makeinfo, $missing_dir)
AC_REQUIRE([AC_PROG_MAKE_SET])])

#
# Check to make sure that the build environment is sane.
#

AC_DEFUN(AM_SANITY_CHECK,
[AC_MSG_CHECKING([whether build environment is sane])
# Just in case
sleep 1
echo timestamp > conftestfile
# Do `set' in a subshell so we don't clobber the current shell's
# arguments.  Must try -L first in case configure is actually a
# symlink; some systems play weird games with the mod time of symlinks
# (eg FreeBSD returns the mod time of the symlink's containing
# directory).
if (
   set X `ls -Lt $srcdir/configure conftestfile 2> /dev/null`
   if test "[$]*" = "X"; then
      # -L didn't work.
      set X `ls -t $srcdir/configure conftestfile`
   fi
   if test "[$]*" != "X $srcdir/configure conftestfile" \
      && test "[$]*" != "X conftestfile $srcdir/configure"; then

      # If neither matched, then we have a broken ls.  This can happen
      # if, for instance, CONFIG_SHELL is bash and it inherits a
      # broken ls alias from the environment.  This has actually
      # happened.  Such a system could not be considered "sane".
      AC_MSG_ERROR([ls -t appears to fail.  Make sure there is not a broken
alias in your environment])
   fi

   test "[$]2" = conftestfile
   )
then
   # Ok.
   :
else
   AC_MSG_ERROR([newly created file is older than distributed files!
Check your system clock])
fi
rm -f conftest*
AC_MSG_RESULT(yes)])

dnl AM_MISSING_PROG(NAME, PROGRAM, DIRECTORY)
dnl The program must properly implement --version.
AC_DEFUN(AM_MISSING_PROG,
[AC_MSG_CHECKING(for working $2)
# Run test in a subshell; some versions of sh will print an error if
# an executable is not found, even if stderr is redirected.
# Redirect stdin to placate older versions of autoconf.  Sigh.
if ($2 --version) < /dev/null > /dev/null 2>&1; then
   $1=$2
   AC_MSG_RESULT(found)
else
   $1="$3/missing $2"
   AC_MSG_RESULT(missing)
fi
AC_SUBST($1)])


# serial 40 AC_PROG_LIBTOOL
AC_DEFUN(AC_PROG_LIBTOOL,
[AC_REQUIRE([AC_LIBTOOL_SETUP])dnl

# Save cache, so that ltconfig can load it
AC_CACHE_SAVE

# Actually configure libtool.  ac_aux_dir is where install-sh is found.
CC="$CC" CFLAGS="$CFLAGS" CPPFLAGS="$CPPFLAGS" \
LD="$LD" LDFLAGS="$LDFLAGS" LIBS="$LIBS" \
LN_S="$LN_S" NM="$NM" RANLIB="$RANLIB" \
DLLTOOL="$DLLTOOL" AS="$AS" OBJDUMP="$OBJDUMP" \
${CONFIG_SHELL-/bin/sh} $ac_aux_dir/ltconfig --no-reexec \
$libtool_flags --no-verify $ac_aux_dir/ltmain.sh $lt_target \
|| AC_MSG_ERROR([libtool configure failed])

# Reload cache, that may have been modified by ltconfig
AC_CACHE_LOAD

# This can be used to rebuild libtool when needed
LIBTOOL_DEPS="$ac_aux_dir/ltconfig $ac_aux_dir/ltmain.sh"

# Always use our own libtool.
LIBTOOL='$(SHELL) $(top_builddir)/libtool'
AC_SUBST(LIBTOOL)dnl

# Redirect the config.log output again, so that the ltconfig log is not
# clobbered by the next message.
exec 5>>./config.log
])

AC_DEFUN(AC_LIBTOOL_SETUP,
[AC_PREREQ(2.13)dnl
AC_REQUIRE([AC_ENABLE_SHARED])dnl
AC_REQUIRE([AC_ENABLE_STATIC])dnl
AC_REQUIRE([AC_ENABLE_FAST_INSTALL])dnl
AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_REQUIRE([AC_CANONICAL_BUILD])dnl
AC_REQUIRE([AC_PROG_RANLIB])dnl
AC_REQUIRE([AC_PROG_CC])dnl
AC_REQUIRE([AC_PROG_LD])dnl
AC_REQUIRE([AC_PROG_NM])dnl
AC_REQUIRE([AC_PROG_LN_S])dnl
dnl

case "$target" in
NONE) lt_target="$host" ;;
*) lt_target="$target" ;;
esac

# Check for any special flags to pass to ltconfig.
#
# the following will cause an existing older ltconfig to fail, so
# we ignore this at the expense of the cache file... Checking this 
# will just take longer ... bummer!
#libtool_flags="--cache-file=$cache_file"
#
test "$enable_shared" = no && libtool_flags="$libtool_flags --disable-shared"
test "$enable_static" = no && libtool_flags="$libtool_flags --disable-static"
test "$enable_fast_install" = no && libtool_flags="$libtool_flags --disable-fast-install"
test "$ac_cv_prog_gcc" = yes && libtool_flags="$libtool_flags --with-gcc"
test "$ac_cv_prog_gnu_ld" = yes && libtool_flags="$libtool_flags --with-gnu-ld"
ifdef([AC_PROVIDE_AC_LIBTOOL_DLOPEN],
[libtool_flags="$libtool_flags --enable-dlopen"])
ifdef([AC_PROVIDE_AC_LIBTOOL_WIN32_DLL],
[libtool_flags="$libtool_flags --enable-win32-dll"])
AC_ARG_ENABLE(libtool-lock,
  [  --disable-libtool-lock  avoid locking (might break parallel builds)])
test "x$enable_libtool_lock" = xno && libtool_flags="$libtool_flags --disable-lock"
test x"$silent" = xyes && libtool_flags="$libtool_flags --silent"

# Some flags need to be propagated to the compiler or linker for good
# libtool support.
case "$lt_target" in
*-*-irix6*)
  # Find out which ABI we are using.
  echo '[#]line __oline__ "configure"' > conftest.$ac_ext
  if AC_TRY_EVAL(ac_compile); then
    case "`/usr/bin/file conftest.o`" in
    *32-bit*)
      LD="${LD-ld} -32"
      ;;
    *N32*)
      LD="${LD-ld} -n32"
      ;;
    *64-bit*)
      LD="${LD-ld} -64"
      ;;
    esac
  fi
  rm -rf conftest*
  ;;

*-*-sco3.2v5*)
  # On SCO OpenServer 5, we need -belf to get full-featured binaries.
  SAVE_CFLAGS="$CFLAGS"
  CFLAGS="$CFLAGS -belf"
  AC_CACHE_CHECK([whether the C compiler needs -belf], lt_cv_cc_needs_belf,
    [AC_TRY_LINK([],[],[lt_cv_cc_needs_belf=yes],[lt_cv_cc_needs_belf=no])])
  if test x"$lt_cv_cc_needs_belf" != x"yes"; then
    # this is probably gcc 2.8.0, egcs 1.0 or newer; no need for -belf
    CFLAGS="$SAVE_CFLAGS"
  fi
  ;;

ifdef([AC_PROVIDE_AC_LIBTOOL_WIN32_DLL],
[*-*-cygwin* | *-*-mingw*)
  AC_CHECK_TOOL(DLLTOOL, dlltool, false)
  AC_CHECK_TOOL(AS, as, false)
  AC_CHECK_TOOL(OBJDUMP, objdump, false)
  ;;
])
esac
])

# AC_LIBTOOL_DLOPEN - enable checks for dlopen support
AC_DEFUN(AC_LIBTOOL_DLOPEN, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])])

# AC_LIBTOOL_WIN32_DLL - declare package support for building win32 dll's
AC_DEFUN(AC_LIBTOOL_WIN32_DLL, [AC_BEFORE([$0], [AC_LIBTOOL_SETUP])])

# AC_ENABLE_SHARED - implement the --enable-shared flag
# Usage: AC_ENABLE_SHARED[(DEFAULT)]
#   Where DEFAULT is either `yes' or `no'.  If omitted, it defaults to
#   `yes'.
AC_DEFUN(AC_ENABLE_SHARED, [dnl
define([AC_ENABLE_SHARED_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE(shared,
changequote(<<, >>)dnl
<<  --enable-shared[=PKGS]  build shared libraries [default=>>AC_ENABLE_SHARED_DEFAULT],
changequote([, ])dnl
[p=${PACKAGE-default}
case "$enableval" in
yes) enable_shared=yes ;;
no) enable_shared=no ;;
*)
  enable_shared=no
  # Look at the argument we got.  We use all the common list separators.
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:,"
  for pkg in $enableval; do
    if test "X$pkg" = "X$p"; then
      enable_shared=yes
    fi
  done
  IFS="$ac_save_ifs"
  ;;
esac],
enable_shared=AC_ENABLE_SHARED_DEFAULT)dnl
])

# AC_DISABLE_SHARED - set the default shared flag to --disable-shared
AC_DEFUN(AC_DISABLE_SHARED, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
AC_ENABLE_SHARED(no)])

# AC_ENABLE_STATIC - implement the --enable-static flag
# Usage: AC_ENABLE_STATIC[(DEFAULT)]
#   Where DEFAULT is either `yes' or `no'.  If omitted, it defaults to
#   `yes'.
AC_DEFUN(AC_ENABLE_STATIC, [dnl
define([AC_ENABLE_STATIC_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE(static,
changequote(<<, >>)dnl
<<  --enable-static[=PKGS]  build static libraries [default=>>AC_ENABLE_STATIC_DEFAULT],
changequote([, ])dnl
[p=${PACKAGE-default}
case "$enableval" in
yes) enable_static=yes ;;
no) enable_static=no ;;
*)
  enable_static=no
  # Look at the argument we got.  We use all the common list separators.
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:,"
  for pkg in $enableval; do
    if test "X$pkg" = "X$p"; then
      enable_static=yes
    fi
  done
  IFS="$ac_save_ifs"
  ;;
esac],
enable_static=AC_ENABLE_STATIC_DEFAULT)dnl
])

# AC_DISABLE_STATIC - set the default static flag to --disable-static
AC_DEFUN(AC_DISABLE_STATIC, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
AC_ENABLE_STATIC(no)])


# AC_ENABLE_FAST_INSTALL - implement the --enable-fast-install flag
# Usage: AC_ENABLE_FAST_INSTALL[(DEFAULT)]
#   Where DEFAULT is either `yes' or `no'.  If omitted, it defaults to
#   `yes'.
AC_DEFUN(AC_ENABLE_FAST_INSTALL, [dnl
define([AC_ENABLE_FAST_INSTALL_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE(fast-install,
changequote(<<, >>)dnl
<<  --enable-fast-install[=PKGS]  optimize for fast installation [default=>>AC_ENABLE_FAST_INSTALL_DEFAULT],
changequote([, ])dnl
[p=${PACKAGE-default}
case "$enableval" in
yes) enable_fast_install=yes ;;
no) enable_fast_install=no ;;
*)
  enable_fast_install=no
  # Look at the argument we got.  We use all the common list separators.
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:,"
  for pkg in $enableval; do
    if test "X$pkg" = "X$p"; then
      enable_fast_install=yes
    fi
  done
  IFS="$ac_save_ifs"
  ;;
esac],
enable_fast_install=AC_ENABLE_FAST_INSTALL_DEFAULT)dnl
])

# AC_ENABLE_FAST_INSTALL - set the default to --disable-fast-install
AC_DEFUN(AC_DISABLE_FAST_INSTALL, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
AC_ENABLE_FAST_INSTALL(no)])

# AC_PROG_LD - find the path to the GNU or non-GNU linker
AC_DEFUN(AC_PROG_LD,
[AC_ARG_WITH(gnu-ld,
[  --with-gnu-ld           assume the C compiler uses GNU ld [default=no]],
test "$withval" = no || with_gnu_ld=yes, with_gnu_ld=no)
AC_REQUIRE([AC_PROG_CC])dnl
AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_REQUIRE([AC_CANONICAL_BUILD])dnl
ac_prog=ld
if test "$ac_cv_prog_gcc" = yes; then
  # Check if gcc -print-prog-name=ld gives a path.
  AC_MSG_CHECKING([for ld used by GCC])
  ac_prog=`($CC -print-prog-name=ld) 2>&5`
  case "$ac_prog" in
    # Accept absolute paths.
changequote(,)dnl
    [\\/]* | [A-Za-z]:[\\/]*)
      re_direlt='/[^/][^/]*/\.\./'
changequote([,])dnl
      # Canonicalize the path of ld
      ac_prog=`echo $ac_prog| sed 's%\\\\%/%g'`
      while echo $ac_prog | grep "$re_direlt" > /dev/null 2>&1; do
	ac_prog=`echo $ac_prog| sed "s%$re_direlt%/%"`
      done
      test -z "$LD" && LD="$ac_prog"
      ;;
  "")
    # If it fails, then pretend we aren't using GCC.
    ac_prog=ld
    ;;
  *)
    # If it is relative, then search for the first ld in PATH.
    with_gnu_ld=unknown
    ;;
  esac
elif test "$with_gnu_ld" = yes; then
  AC_MSG_CHECKING([for GNU ld])
else
  AC_MSG_CHECKING([for non-GNU ld])
fi
AC_CACHE_VAL(ac_cv_path_LD,
[if test -z "$LD"; then
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}${PATH_SEPARATOR-:}"
  for ac_dir in $PATH; do
    test -z "$ac_dir" && ac_dir=.
    if test -f "$ac_dir/$ac_prog" || test -f "$ac_dir/$ac_prog$ac_exeext"; then
      ac_cv_path_LD="$ac_dir/$ac_prog"
      # Check to see if the program is GNU ld.  I'd rather use --version,
      # but apparently some GNU ld's only accept -v.
      # Break only if it was the GNU/non-GNU ld that we prefer.
      if "$ac_cv_path_LD" -v 2>&1 < /dev/null | egrep '(GNU|with BFD)' > /dev/null; then
	test "$with_gnu_ld" != no && break
      else
	test "$with_gnu_ld" != yes && break
      fi
    fi
  done
  IFS="$ac_save_ifs"
else
  ac_cv_path_LD="$LD" # Let the user override the test with a path.
fi])
LD="$ac_cv_path_LD"
if test -n "$LD"; then
  AC_MSG_RESULT($LD)
else
  AC_MSG_RESULT(no)
fi
test -z "$LD" && AC_MSG_ERROR([no acceptable ld found in \$PATH])
AC_PROG_LD_GNU
])

AC_DEFUN(AC_PROG_LD_GNU,
[AC_CACHE_CHECK([if the linker ($LD) is GNU ld], ac_cv_prog_gnu_ld,
[# I'd rather use --version here, but apparently some GNU ld's only accept -v.
if $LD -v 2>&1 </dev/null | egrep '(GNU|with BFD)' 1>&5; then
  ac_cv_prog_gnu_ld=yes
else
  ac_cv_prog_gnu_ld=no
fi])
])

# AC_PROG_NM - find the path to a BSD-compatible name lister
AC_DEFUN(AC_PROG_NM,
[AC_MSG_CHECKING([for BSD-compatible nm])
AC_CACHE_VAL(ac_cv_path_NM,
[if test -n "$NM"; then
  # Let the user override the test.
  ac_cv_path_NM="$NM"
else
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}${PATH_SEPARATOR-:}"
  for ac_dir in $PATH /usr/ccs/bin /usr/ucb /bin; do
    test -z "$ac_dir" && ac_dir=.
    if test -f $ac_dir/nm || test -f $ac_dir/nm$ac_exeext ; then
      # Check to see if the nm accepts a BSD-compat flag.
      # Adding the `sed 1q' prevents false positives on HP-UX, which says:
      #   nm: unknown option "B" ignored
      if ($ac_dir/nm -B /dev/null 2>&1 | sed '1q'; exit 0) | egrep /dev/null >/dev/null; then
	ac_cv_path_NM="$ac_dir/nm -B"
	break
      elif ($ac_dir/nm -p /dev/null 2>&1 | sed '1q'; exit 0) | egrep /dev/null >/dev/null; then
	ac_cv_path_NM="$ac_dir/nm -p"
	break
      else
	ac_cv_path_NM=${ac_cv_path_NM="$ac_dir/nm"} # keep the first match, but
	continue # so that we can try to find one that supports BSD flags
      fi
    fi
  done
  IFS="$ac_save_ifs"
  test -z "$ac_cv_path_NM" && ac_cv_path_NM=nm
fi])
NM="$ac_cv_path_NM"
AC_MSG_RESULT([$NM])
])

# AC_CHECK_LIBM - check for math library
AC_DEFUN(AC_CHECK_LIBM,
[AC_REQUIRE([AC_CANONICAL_HOST])dnl
LIBM=
case "$lt_target" in
*-*-beos* | *-*-cygwin*)
  # These system don't have libm
  ;;
*-ncr-sysv4.3*)
  AC_CHECK_LIB(mw, _mwvalidcheckl, LIBM="-lmw")
  AC_CHECK_LIB(m, main, LIBM="$LIBM -lm")
  ;;
*)
  AC_CHECK_LIB(m, main, LIBM="-lm")
  ;;
esac
])

# AC_LIBLTDL_CONVENIENCE[(dir)] - sets LIBLTDL to the link flags for
# the libltdl convenience library, adds --enable-ltdl-convenience to
# the configure arguments.  Note that LIBLTDL is not AC_SUBSTed, nor
# is AC_CONFIG_SUBDIRS called.  If DIR is not provided, it is assumed
# to be `${top_builddir}/libltdl'.  Make sure you start DIR with
# '${top_builddir}/' (note the single quotes!) if your package is not
# flat, and, if you're not using automake, define top_builddir as
# appropriate in the Makefiles.
AC_DEFUN(AC_LIBLTDL_CONVENIENCE, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
  case "$enable_ltdl_convenience" in
  no) AC_MSG_ERROR([this package needs a convenience libltdl]) ;;
  "") enable_ltdl_convenience=yes
      ac_configure_args="$ac_configure_args --enable-ltdl-convenience" ;;
  esac
  LIBLTDL=ifelse($#,1,$1,['${top_builddir}/libltdl'])/libltdlc.la
  INCLTDL=ifelse($#,1,-I$1,['-I${top_builddir}/libltdl'])
])

# AC_LIBLTDL_INSTALLABLE[(dir)] - sets LIBLTDL to the link flags for
# the libltdl installable library, and adds --enable-ltdl-install to
# the configure arguments.  Note that LIBLTDL is not AC_SUBSTed, nor
# is AC_CONFIG_SUBDIRS called.  If DIR is not provided, it is assumed
# to be `${top_builddir}/libltdl'.  Make sure you start DIR with
# '${top_builddir}/' (note the single quotes!) if your package is not
# flat, and, if you're not using automake, define top_builddir as
# appropriate in the Makefiles.
# In the future, this macro may have to be called after AC_PROG_LIBTOOL.
AC_DEFUN(AC_LIBLTDL_INSTALLABLE, [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
  AC_CHECK_LIB(ltdl, main,
  [test x"$enable_ltdl_install" != xyes && enable_ltdl_install=no],
  [if test x"$enable_ltdl_install" = xno; then
     AC_MSG_WARN([libltdl not installed, but installation disabled])
   else
     enable_ltdl_install=yes
   fi
  ])
  if test x"$enable_ltdl_install" = x"yes"; then
    ac_configure_args="$ac_configure_args --enable-ltdl-install"
    LIBLTDL=ifelse($#,1,$1,['${top_builddir}/libltdl'])/libltdl.la
    INCLTDL=ifelse($#,1,-I$1,['-I${top_builddir}/libltdl'])
  else
    ac_configure_args="$ac_configure_args --enable-ltdl-install=no"
    LIBLTDL="-lltdl"
    INCLTDL=
  fi
])

dnl old names
AC_DEFUN(AM_PROG_LIBTOOL, [indir([AC_PROG_LIBTOOL])])dnl
AC_DEFUN(AM_ENABLE_SHARED, [indir([AC_ENABLE_SHARED], $@)])dnl
AC_DEFUN(AM_ENABLE_STATIC, [indir([AC_ENABLE_STATIC], $@)])dnl
AC_DEFUN(AM_DISABLE_SHARED, [indir([AC_DISABLE_SHARED], $@)])dnl
AC_DEFUN(AM_DISABLE_STATIC, [indir([AC_DISABLE_STATIC], $@)])dnl
AC_DEFUN(AM_PROG_LD, [indir([AC_PROG_LD])])dnl
AC_DEFUN(AM_PROG_NM, [indir([AC_PROG_NM])])dnl

dnl This is just to silence aclocal about the macro not being used
ifelse([AC_DISABLE_FAST_INSTALL])dnl

