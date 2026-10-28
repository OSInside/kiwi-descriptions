#!/bin/bash
set -ex

#======================================
# Activate services
#--------------------------------------
systemctl enable sshd
systemctl enable systemd-resolved

#======================================
# Enable lan0 interface
#--------------------------------------
netctl enable ethernet-dhcp

#======================================
# Setup default target, multi-user
#--------------------------------------
systemctl set-default multi-user.target

#======================================
# Enable first mirror in mirrorlist
#--------------------------------------
sed -i -e '0,/#Server/s/#Server/Server/' /etc/pacman.d/mirrorlist

#======================================
# Generate system locale and configure it
#--------------------------------------
sed -i -e '0,/#en_US.UTF-8/s/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
