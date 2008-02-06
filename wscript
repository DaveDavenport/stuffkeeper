#! /usr/bin/env python
# encoding: utf-8
# Qball Cow, 2008

import os
import Params

# the following two variables are used by the target "waf dist"
VERSION='0.0.1'
APPNAME='stuffkeeper'

# these variables are mandatory ('/' are converted automatically)
srcdir = '.'
blddir = 'build'

def set_options(opt):
    opt.tool_options('compiler_cc')

def configure(conf):
    conf.check_tool('compiler_cc gob2')
    conf.check_pkg('glib-2.0', destvar='GLIB', vnum='2.10.0', mandatory=True)
    conf.check_pkg('gtk+-2.0', destvar='GTK', vnum='2.10.0', mandatory=True)
    conf.check_pkg('libglade-2.0', destvar='GLADE', vnum='2.6.0', mandatory=True)
    conf.check_pkg('gmodule-2.0', destvar='GMODULE', vnum='2.10.0', mandatory=True)

    conf.env['DATADIR'] = conf.env['PREFIX']+'/share/'+APPNAME

    conf.define('PACKAGE_DATADIR', conf.env['DATADIR'])
    # finally, write the configuration header
    conf.write_config_header('config.h')



def build(bld):
    bld.add_subdirs('src')

def shutdown():
    pass
