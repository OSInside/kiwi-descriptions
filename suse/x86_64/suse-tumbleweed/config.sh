#!/bin/bash
set -ex

#======================================
# Activate services
#--------------------------------------
systemctl enable sshd
systemctl enable NetworkManager

#======================================
# Setup default target, multi-user
#--------------------------------------
systemctl set-default multi-user.target
