# Generated automatically from Makefile.in by configure.
# Makefile.in generated automatically by automake 1.4 from Makefile.am

# Copyright (C) 1994, 1995-8, 1999 Free Software Foundation, Inc.
# This Makefile.in is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

# Copyright (C) 2000 Andreas Heger <heger@ebi.ac.uk>
#  
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without 
# modifications, as long as this notice is preserved.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# Install m4 macros in this directory


SHELL = /bin/sh

srcdir = .
top_srcdir = ..
prefix = /usr/local
exec_prefix = ${prefix}

bindir = ${exec_prefix}/bin
sbindir = ${exec_prefix}/sbin
libexecdir = ${exec_prefix}/libexec
datadir = ${prefix}/share
sysconfdir = ${prefix}/etc
sharedstatedir = ${prefix}/com
localstatedir = ${prefix}/var
libdir = ${exec_prefix}/lib
infodir = ${prefix}/info
mandir = ${prefix}/man
includedir = ${prefix}/include
oldincludedir = /usr/include

DESTDIR =

pkgdatadir = $(datadir)/adda
pkglibdir = $(libdir)/adda
pkgincludedir = $(includedir)/adda

top_builddir = ..

ACLOCAL = /home/lee/1_Experiments/2017_05_30_TestAdda/WuHelp/adda-0.1.0/missing aclocal
AUTOCONF = /home/lee/1_Experiments/2017_05_30_TestAdda/WuHelp/adda-0.1.0/missing autoconf
AUTOMAKE = /home/lee/1_Experiments/2017_05_30_TestAdda/WuHelp/adda-0.1.0/missing automake
AUTOHEADER = /home/lee/1_Experiments/2017_05_30_TestAdda/WuHelp/adda-0.1.0/missing autoheader

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL} $(AM_INSTALL_PROGRAM_FLAGS)
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_SCRIPT = ${INSTALL_PROGRAM}
transform = s,x,x,

NORMAL_INSTALL = :
PRE_INSTALL = :
POST_INSTALL = :
NORMAL_UNINSTALL = :
PRE_UNINSTALL = :
POST_UNINSTALL = :
build_alias = x86_64-unknown-linux-gnu
build_triplet = x86_64-unknown-linux-gnu
host_alias = x86_64-unknown-linux-gnu
host_triplet = x86_64-unknown-linux-gnu
target_alias = x86_64-unknown-linux-gnu
target_triplet = x86_64-unknown-linux-gnu
ADDA_BINARY_AGE = 0
ADDA_INTERFACE_AGE = 0
ADDA_MAJOR_VERSION = 0
ADDA_MICRO_VERSION = 0
ADDA_MINOR_VERSION = 1
ADDA_VERSION = 0.1.0
AS = @AS@
CC = gcc
CPP = gcc -E
CXX = c++
CXXFLAGS = -g -O2
DLLTOOL = @DLLTOOL@
LIBTOOL = $(SHELL) $(top_builddir)/libtool
LN_S = ln -s
MACHINE_TYPE = x86_64
MAKEINFO = /home/lee/1_Experiments/2017_05_30_TestAdda/WuHelp/adda-0.1.0/missing makeinfo
OBJDUMP = @OBJDUMP@
PACKAGE = adda
RANLIB = ranlib
SYSTEM_TYPE = unknown-linux-gnu
VERSION = 0.1.0
alignlib_includedir = @alignlib_includedir@
alignlib_libdir = @alignlib_libdir@
mysql_includedir = @mysql_includedir@
mysql_libdir = @mysql_libdir@

m4datadir = $(datadir)/aclocal

# List your m4 macros here
m4macros = 

# The following is boilerplate
m4data_DATA = $(m4macros) 
EXTRA_DIST = $(m4data_DATA) 
mkinstalldirs = $(SHELL) $(top_srcdir)/mkinstalldirs
CONFIG_HEADER = ../config.h
CONFIG_CLEAN_FILES = 
DATA =  $(m4data_DATA)

DIST_COMMON =  Makefile.am Makefile.in


DISTFILES = $(DIST_COMMON) $(SOURCES) $(HEADERS) $(TEXINFOS) $(EXTRA_DIST)

TAR = gtar
GZIP_ENV = --best
all: all-redirect
.SUFFIXES:
$(srcdir)/Makefile.in: Makefile.am $(top_srcdir)/configure.in $(ACLOCAL_M4) 
	cd $(top_srcdir) && $(AUTOMAKE) --gnu --include-deps m4/Makefile

Makefile: $(srcdir)/Makefile.in  $(top_builddir)/config.status
	cd $(top_builddir) \
	  && CONFIG_FILES=$(subdir)/$@ CONFIG_HEADERS= $(SHELL) ./config.status


install-m4dataDATA: $(m4data_DATA)
	@$(NORMAL_INSTALL)
	$(mkinstalldirs) $(DESTDIR)$(m4datadir)
	@list='$(m4data_DATA)'; for p in $$list; do \
	  if test -f $(srcdir)/$$p; then \
	    echo " $(INSTALL_DATA) $(srcdir)/$$p $(DESTDIR)$(m4datadir)/$$p"; \
	    $(INSTALL_DATA) $(srcdir)/$$p $(DESTDIR)$(m4datadir)/$$p; \
	  else if test -f $$p; then \
	    echo " $(INSTALL_DATA) $$p $(DESTDIR)$(m4datadir)/$$p"; \
	    $(INSTALL_DATA) $$p $(DESTDIR)$(m4datadir)/$$p; \
	  fi; fi; \
	done

uninstall-m4dataDATA:
	@$(NORMAL_UNINSTALL)
	list='$(m4data_DATA)'; for p in $$list; do \
	  rm -f $(DESTDIR)$(m4datadir)/$$p; \
	done
tags: TAGS
TAGS:


distdir = $(top_builddir)/$(PACKAGE)-$(VERSION)/$(subdir)

subdir = m4

distdir: $(DISTFILES)
	@for file in $(DISTFILES); do \
	  d=$(srcdir); \
	  if test -d $$d/$$file; then \
	    cp -pr $$d/$$file $(distdir)/$$file; \
	  else \
	    test -f $(distdir)/$$file \
	    || ln $$d/$$file $(distdir)/$$file 2> /dev/null \
	    || cp -p $$d/$$file $(distdir)/$$file || :; \
	  fi; \
	done
info-am:
info: info-am
dvi-am:
dvi: dvi-am
check-am: all-am
check: check-am
installcheck-am:
installcheck: installcheck-am
install-exec-am:
install-exec: install-exec-am

install-data-am: install-m4dataDATA
install-data: install-data-am

install-am: all-am
	@$(MAKE) $(AM_MAKEFLAGS) install-exec-am install-data-am
install: install-am
uninstall-am: uninstall-m4dataDATA
uninstall: uninstall-am
all-am: Makefile $(DATA)
all-redirect: all-am
install-strip:
	$(MAKE) $(AM_MAKEFLAGS) AM_INSTALL_PROGRAM_FLAGS=-s install
installdirs:
	$(mkinstalldirs)  $(DESTDIR)$(m4datadir)


mostlyclean-generic:

clean-generic:

distclean-generic:
	-rm -f Makefile $(CONFIG_CLEAN_FILES)
	-rm -f config.cache config.log stamp-h stamp-h[0-9]*

maintainer-clean-generic:
mostlyclean-am:  mostlyclean-generic

mostlyclean: mostlyclean-am

clean-am:  clean-generic mostlyclean-am

clean: clean-am

distclean-am:  distclean-generic clean-am
	-rm -f libtool

distclean: distclean-am

maintainer-clean-am:  maintainer-clean-generic distclean-am
	@echo "This command is intended for maintainers to use;"
	@echo "it deletes files that may require special tools to rebuild."

maintainer-clean: maintainer-clean-am

.PHONY: uninstall-m4dataDATA install-m4dataDATA tags distdir info-am \
info dvi-am dvi check check-am installcheck-am installcheck \
install-exec-am install-exec install-data-am install-data install-am \
install uninstall-am uninstall all-redirect all-am all installdirs \
mostlyclean-generic distclean-generic clean-generic \
maintainer-clean-generic clean mostlyclean distclean maintainer-clean


# Tell versions [3.59,3.63) of GNU make to not export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
