#! /usr/bin/env python
# encoding: utf-8
# Qball Cow, 2008

import os
import Params, intltool,gnome
# the following two variables are used by the target "waf dist"
VERSION='0.02'
APPNAME='stuffkeeper'
WEBSITE='http://sarine.nl/stuffkeeper/'

# these variables are mandatory ('/' are converted automatically)
srcdir = '.'
blddir = 'build'

def set_options(opt):
    opt.tool_options('compiler_cc')
    opt.tool_options('gnu_dirs')

def configure(conf):
    conf.check_tool('compiler_cc gnome gob2 intltool ')
    conf.check_tool('gnu_dirs', 'waf-tools')


    conf.check_pkg('glib-2.0', destvar='GLIB', vnum='2.10.0', mandatory=True)
    conf.check_pkg('gtk+-2.0', destvar='GTK', vnum='2.10.0', mandatory=True)
    conf.check_pkg('libglade-2.0', destvar='GLADE', vnum='2.6.0', mandatory=True)
    conf.check_pkg('gmodule-2.0', destvar='GMODULE', vnum='2.10.0', mandatory=True)
    conf.check_pkg('gtkspell-2.0', destvar='GTKSPELL', vnum='2.0', mandatory=False)
    conf.check_pkg('sqlite3', destvar='SQLITE', vnum='3.4.0', mandatory=True)

    conf.define('PACKAGE', APPNAME)
    conf.define('PACKAGE_DATADIR', conf.env['DATADIR']+'/'+APPNAME)
    conf.define('PROGRAM_NAME', APPNAME)
    conf.define('PROGRAM_VERSION', VERSION)
    conf.define('PROGRAM_WEBSITE', WEBSITE)
    conf.define('GETTEXT_PACKAGE',APPNAME)

    # finally, write the configuration header
    conf.write_config_header('config.h')

def build(bld):
    bld.add_subdirs('src')
    bld.add_subdirs('glade')
    bld.add_subdirs('data')
    bld.add_subdirs('po')
    bld.add_subdirs('pixmaps')

def shutdown():
    gnome.postinstall_icons()
