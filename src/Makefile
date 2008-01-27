OUTPUT=stuffkeeper
Q=@

GTK_LIBS=`pkg-config --libs gtk+-2.0 libglade-2.0 gmodule-2.0`
GTK_CFLAGS=`pkg-config --cflags gtk+-2.0 libglade-2.0 gmodule-2.0`

SOURCE=\
	stuffkeeper-data-backend.h\
	stuffkeeper-data-item.h\
	stuffkeeper-data-tag.h\
	stuffkeeper-data-backend.c\
	stuffkeeper-data-item.c\
	stuffkeeper-data-tag.c\
	main.c\
	interface.c

OBJECTS=$(patsubst %.c, %.o, $(SOURCE))

%.c %.h %-private.h: %.gob
	$(info ==> Processing: $<)
	$(Q)gob2 --no-touch-headers --always-private-header $<

%.o: %.c
	$(info ==> Building:   $@)
	$(Q)$(CC) -c $< -o $@ $(GTK_CFLAGS)

$(OUTPUT): $(OBJECTS)
	$(info ==> Linking:    $@)
	$(Q)$(CC) $(OBJECTS) -o $@ $(GTK_LIBS) $(GTK_CFLAGS)


clean:
	@rm *.o
	@rm stuffkeeper-data-*.c stuffkeeper-data-*.h
	@rm stuffkeeper
