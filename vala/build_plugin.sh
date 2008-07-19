#!/bin/sh
valac  --vapidir=../stuffkeeper/vala/ --pkg=gtk+-2.0 --pkg=glib-2.0 --pkg=gmodule-2.0 --pkg=stuffkeeper test.vala   --Xcc="-Wl,--export-dynamic" --Xcc="-Wl,-soname" --Xcc="-shared" --Xcc="-Wl,--module" --Xcc="-fPIC" --debug --save-temps
