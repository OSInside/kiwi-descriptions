#!/bin/bash
set -ex

#======================================
# Activate services
#--------------------------------------
systemctl enable sshd
systemctl enable NetworkManager
systemctl enable resize_lvm

#======================================
# Setup default target, multi-user
#--------------------------------------
systemctl set-default multi-user.target

#======================================
# Mountpoint for extra nova volume
#--------------------------------------
mkdir -p /var/lib/nova
