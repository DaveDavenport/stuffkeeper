#!/bin/sh

 valac  --vapidir=../vala/ --pkg=gtk+-2.0 --pkg=glib-2.0 --pkg=gmodule-2.0 --pkg=stuffkeeper  -C  stuffkeeper-data-boolean-config.vala
