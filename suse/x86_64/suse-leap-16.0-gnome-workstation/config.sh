#!/bin/bash
set -ex

#======================================
# Activate services
#--------------------------------------
# gdm is started through display-manager.service which
# is already enabled by the package installation
systemctl enable NetworkManager

#======================================
# Setup default target, graphical
#--------------------------------------
systemctl set-default graphical.target
