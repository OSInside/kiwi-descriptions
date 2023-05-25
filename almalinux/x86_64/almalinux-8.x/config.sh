#!/bin/bash
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Setup default target, multi-user
#--------------------------------------
baseSetRunlevel 3
