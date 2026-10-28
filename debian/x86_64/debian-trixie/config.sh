#!/bin/bash
set -ex

#======================================
# Activate services
#--------------------------------------
systemctl enable ssh

#======================================
# Setup default target, multi-user
#--------------------------------------
systemctl set-default multi-user.target

#======================================
# Clear apt-get data
#--------------------------------------
apt-get clean
rm -rf /var/lib/apt/lists/*
