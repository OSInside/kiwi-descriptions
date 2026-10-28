#!/bin/bash
set -ex

#======================================
# Activate services
#--------------------------------------
systemctl enable dbus-broker
systemctl enable NetworkManager
systemctl enable sshd

#======================================
# Setup default target, multi-user
#--------------------------------------
systemctl set-default multi-user.target
