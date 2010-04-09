#!/bin/sh
valac  -C --vapidir=. --pkg=gtk+-2.0 --pkg=glib-2.0 --pkg=gmodule-2.0 --pkg=stuffkeeper test.vala 
gcc -fPIC --shared -Wl,-soname -Wl,--export-dynamic test.c  -I ../src/ `pkg-config --libs --cflags glib-2.0 gtk+-2.0` -o tagcloud.so

