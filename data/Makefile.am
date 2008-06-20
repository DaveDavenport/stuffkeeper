desktopdir 	= $(datadir)/applications
desktop_in_files = stuffkeeper.desktop.in
desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)
@INTLTOOL_DESKTOP_RULE@

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = stuffkeeper.pc

EXTRA_DIST = 		\
	stuffkeeper.pc.in\
	stuffkeeper.desktop.in 	

DISTCLEANFILES=$(desktop_DATA)
