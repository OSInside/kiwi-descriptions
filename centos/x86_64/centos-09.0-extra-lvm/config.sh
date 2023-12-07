#!/bin/bash
test -f /.kconfig && . /.kconfig

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Activate services
#--------------------------------------
baseInsertService sshd
baseInsertService resize_lvm

#======================================
# Setup default target, multi-user
#--------------------------------------
baseSetRunlevel 3

#======================================
# Mountpoint for extra nova volume
#--------------------------------------
mkdir -p /var/lib/nova
