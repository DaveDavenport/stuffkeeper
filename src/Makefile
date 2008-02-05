#load previous found deps
-include Makefile.config 

OUTPUT			= stuffkeeper
EMPTY 			= 
EXTRA_CFLAGS	= -g -Os -Wall -D_GNU_SOURCE 
EXTRA_LIBS		= -lm
Q				= @
GOB2			= $(shell which gob2)

ifeq ($(GOB2), $(EMPTY))
$(error **ERROR** Gob2 not found)
endif

HEADERS=\
	stuffkeeper-data-backend.h\
	stuffkeeper-data-schema.h\
	stuffkeeper-data-item.h\
	stuffkeeper-data-tag.h\
	stuffkeeper-data-label.h\
	stuffkeeper-data-taglist.h\
	stuffkeeper-data-entry.h\
	stuffkeeper-data-text.h\
	stuffkeeper-data-boolean.h\
	stuffkeeper-data-rating.h\
	stuffkeeper-data-spinbutton.h\
	stuffkeeper-data-list.h\
	stuffkeeper-interface.h\
	stuffkeeper-show-item.h\
	stuffkeeper-item-window.h\
	stuffkeeper-edit-schema.h
SOURCE=\
	stuffkeeper-data-backend.h\
	stuffkeeper-data-schema.h\
	stuffkeeper-data-item.h\
	stuffkeeper-data-tag.h\
	stuffkeeper-data-label.h\
	stuffkeeper-data-taglist.h\
	stuffkeeper-data-entry.h\
	stuffkeeper-data-text.h\
	stuffkeeper-data-boolean.h\
	stuffkeeper-data-spinbutton.h\
	stuffkeeper-data-rating.h\
	stuffkeeper-data-list.h\
	stuffkeeper-interface.h\
	stuffkeeper-show-item.h\
	stuffkeeper-edit-schema.h\
	stuffkeeper-item-window.h\
	stuffkeeper-interface.c\
	stuffkeeper-edit-schema.c\
	stuffkeeper-data-backend.c\
	stuffkeeper-data-schema.c\
	stuffkeeper-data-item.c\
	stuffkeeper-data-tag.c\
	stuffkeeper-data-label.c\
	stuffkeeper-data-taglist.c\
	stuffkeeper-data-entry.c\
	stuffkeeper-data-text.c\
	stuffkeeper-data-boolean.c\
	stuffkeeper-data-spinbutton.c\
	stuffkeeper-data-rating.c\
	stuffkeeper-data-list.c\
	stuffkeeper-show-item.c\
	stuffkeeper-item-window.c\
	main.c\

OBJECTS=$(patsubst %.c, %.o, $(SOURCE))

##
# Checking dependencies
###

# Check for gtk
ifeq ($(GTK_LIBS), $(EMPTY))
$(info *** Checking gtk dependency)
GTK_LIBS=$(shell pkg-config --silence-errors --libs gtk+-2.0)
GTK_CFLAGS=	$(shell pkg-config --silence-errors --cflags gtk+-2.0)
ifeq ($(GTK_LIBS), $(EMPTY))
$(error **ERROR** gtk not found)
else
$(info ==> Gtk found)
$(shell echo "GTK_LIBS=$(GTK_LIBS)" >> Makefile.config)
$(shell echo "GTK_CFLAGS=$(GTK_CFLAGS)" >> Makefile.config)
endif
endif
# Check for glib
ifeq ($(GLIB_LIBS), $(EMPTY))
$(info *** Checking glib dependency)
GLIB_LIBS=$(shell pkg-config --silence-errors --libs glib-2.0)
GLIB_CFLAGS=	$(shell pkg-config --silence-errors --cflags glib-2.0)
ifeq ($(GLIB_LIBS), $(EMPTY))
$(error **ERROR** glib not found)
else
$(info ==> glib found)
$(shell echo "GLIB_LIBS=$(GLIB_LIBS)" >> Makefile.config)
$(shell echo "GLIB_CFLAGS=$(GLIB_CFLAGS)" >> Makefile.config)
endif
endif

# Check for glade
ifeq ($(GLADE_LIBS), $(EMPTY))
$(info *** Checking libglade dependency)
GLADE_LIBS=$(shell pkg-config --silence-errors --libs libglade-2.0)
GLADE_CFLAGS=	$(shell pkg-config --silence-errors --cflags libglade-2.0)
ifeq ($(GLADE_LIBS), $(EMPTY))
$(error **ERROR** libglade not found)
else
$(info ==> libglade found)
$(shell echo "GLADE_LIBS=$(GLADE_LIBS)" >> Makefile.config)
$(shell echo "GLADE_CFLAGS=$(GLADE_CFLAGS)" >> Makefile.config)
endif
endif
# Check for gmodule
ifeq ($(GMODULE_LIBS), $(EMPTY))
$(info *** Checking gmodule dependency)
GMODULE_LIBS=$(shell pkg-config --silence-errors --libs gmodule-2.0)
GMODULE_CFLAGS=	$(shell pkg-config --silence-errors --cflags gmodule-2.0)
ifeq ($(GMODULE_LIBS), $(EMPTY))
$(error **ERROR** gmodule not found)
else
$(info ==> gmodule found)
$(shell echo "GMODULE_LIBS=$(GMODULE_LIBS)" >> Makefile.config)
$(shell echo "GMODULE_CFLAGS=$(GMODULE_CFLAGS)" >> Makefile.config)
endif
endif



SK_LIBS=$(GTK_LIBS) $(GLIB_LIBS) $(GLADE_LIBS) $(GMODULE_LIBS) $(EXTRA_LIBS)
SK_CFLAGS=$(GTK_CFLAGS) $(GLIB_CFLAGS) $(GLADE_CFLAGS) $(EXTRA_CFLAGS) $(GMODULE_CFLAGS)

%.c %.h %-private.h: %.gob
	$(info ==> Processing: $<)
	$(Q)gob2 --no-touch --always-private-header $<

%.o: %.c $(HEADERS)
	$(info ==> Building:   $@)
	$(Q)$(CC) -c $< -o $@ $(SK_CFLAGS)

$(OUTPUT): $(OBJECTS)
	$(info ==> Linking:    $@)
	$(Q)$(CC) $(OBJECTS) -o $@ $(SK_LIBS) $(SK_CFLAGS)


clean:
	@rm *.o
	@rm stuffkeeper-*.c stuffkeeper-*.h
	@rm stuffkeeper
