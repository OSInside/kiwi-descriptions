#!/bin/bash
set -ex

# On Debian based distributions the kiwi built in way
# to setup locale, keyboard and timezone via systemd tools
# does not work because not(yet) provided by the distribution.
# Thus the following manual steps to make the values provided
# in the image description effective needs to be done.
#
#=======================================
# Setup system locale
#---------------------------------------
echo "LANG=${kiwi_language}" > /etc/locale.conf

#=======================================
# Setup system keymap
#---------------------------------------
{
    echo "KEYMAP=${kiwi_keytable:-us}"
    echo "FONT=eurlatgr.psfu"
    echo "FONT_MAP="
    echo "FONT_UNIMAP="
} > /etc/vconsole.conf

#=======================================
# Setup system timezone
#---------------------------------------
ln -sf /usr/share/zoneinfo/"${kiwi_timezone}" /etc/localtime

#=======================================
# Setup HW clock to UTC
#---------------------------------------
{
    echo "0.0 0 0.0"
    echo "0"
    echo "UTC"
} > /etc/adjtime

#======================================
# Activate services
#--------------------------------------
systemctl enable ssh
systemctl enable symlink-resolvconf

#======================================
# Setup default target, multi-user
#--------------------------------------
systemctl set-default multi-user.target

#======================================
# Clear apt-get data
#--------------------------------------
apt-get clean
rm -rf /var/lib/apt/lists/*
