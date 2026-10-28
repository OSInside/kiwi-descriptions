#!/bin/bash
set -ex

#======================================
# Activate services
#--------------------------------------
systemctl enable sshd
systemctl enable NetworkManager
systemctl enable chronyd

#======================================
# Setup default target, multi-user
#--------------------------------------
systemctl set-default multi-user.target
