GTK_LIBS=`pkg-config --libs gtk+-2.0 libglade-2.0 gmodule-2.0`
GTK_CFLAGS=`pkg-config --cflags gtk+-2.0 libglade-2.0 gmodule-2.0`


SOURCE=\
	main.c\
	interface.c\
	stuffkeeper-data-backend.c\
	stuffkeeper-data-item.c
	
%.c %.h %-private.h: %.gob
	gob2 --no-touch-headers --always-private-header $<



all: $(SOURCE)
	$(CC) -o stuffkeeper $(SOURCE) $(GTK_LIBS) $(GTK_CFLAGS)

clean:
	@rm stuffkeeper
