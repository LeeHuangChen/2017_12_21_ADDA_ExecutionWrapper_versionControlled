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


