stuffkeepericon16dir= $(datadir)/icons/hicolor/16x16/apps
stuffkeepericon16_DATA =\
			16/stuffkeeper.png

stuffkeepericon48dir= $(datadir)/icons/hicolor/48x48/apps
stuffkeepericon48_DATA =\
			48/stuffkeeper.png

stuffkeepericon64dir= $(datadir)/icons/hicolor/64x64/apps
stuffkeepericon64_DATA =\
			64/stuffkeeper.png

stuffkeepericonscalabledir= $(datadir)/icons/hicolor/scalable/apps
stuffkeepericonscalable_DATA =\
			      scalable/stuffkeeper.svg


stuffkeepericon162dir= $(datadir)/stuffkeeper/icons/hicolor/16x16/apps
stuffkeepericon162_DATA =\
			16/stuffkeeper.png

stuffkeepericon482dir= $(datadir)/stuffkeeper/icons/hicolor/48x48/apps
stuffkeepericon482_DATA =\
			48/stuffkeeper.png

stuffkeepericon642dir= $(datadir)/stuffkeeper/icons/hicolor/64x64/apps
stuffkeepericon642_DATA =\
			64/stuffkeeper.png

stuffkeepericonscalable2dir= $(datadir)/stuffkeeper/icons/hicolor/scalable/apps
stuffkeepericonscalable2_DATA =\
			      scalable/stuffkeeper.svg

stuffkeepericoninterndir= $(datadir)/stuffkeeper/icons/hicolor/16x16/actions
stuffkeepericonintern_DATA =\
			    internet-mail.png\
			    internet-web-browser.png

EXTRA_DIST=\
		   $(stuffkeepericonintern_DATA)\
		   $(stuffkeepericonscalable_DATA)\
		   $(stuffkeepericon64_DATA)\
		   $(stuffkeepericon48_DATA)\
		   $(stuffkeepericon16_DATA)

gtk_update_icon_cache = gtk-update-icon-cache -f -t $(datadir)/icons/hicolor
install-data-hook: update-icon-cache
uninstall-hook: update-icon-cache
update-icon-cache:
	@-if test -z "$(DESTDIR)"; then \
		echo "Updating Gtk icon cache."; \
		$(gtk_update_icon_cache); \
		else \
		echo "*** Icon cache not updated.  After (un)install, run this:"; \
		echo "***   $(gtk_update_icon_cache)"; \
		fi

