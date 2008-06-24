AUTOMAKE_OPTIONS = foreign 1.6

#check if we want to build doc's
if DOC
MAYBE_DIR=doc
else
MAYBE_DIR=
endif

SUBDIRS = src glade po pixmaps data types html doc

EXTRA_DIST=	intltool-extract.in\
		intltool-update.in\
		intltool-merge.in


DISTCLEANFILES=\
	       intltool-update\
	       intltool-extract\
	       intltool-merge

