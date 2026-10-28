#!/bin/sh
set -ex

#======================================
# Activate services (OpenRC)
#--------------------------------------
rc-update add devfs sysinit
rc-update add dmesg sysinit
rc-update add hwdrivers sysinit
rc-update add modules boot
rc-update add hostname boot
rc-update add networking boot
rc-update add sshd default
