#!/bin/bash
set -ex

#======================================
# Enable the CachyOS repository
#--------------------------------------
# The repository is configured above the Arch Linux repositories,
# in the same way as the CachyOS repository setup does it
if ! grep -q '^\[cachyos\]' /etc/pacman.conf; then
    sed -i -e \
        's|^\[core\]$|[cachyos]\nInclude = /etc/pacman.d/cachyos-mirrorlist\n\n[core]|' \
        /etc/pacman.conf
fi

#======================================
# Arch Linux mirror
#--------------------------------------
# $repo and $arch are pacman variables, not shell variables
# shellcheck disable=SC2016
echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch' \
    > /etc/pacman.d/mirrorlist

#======================================
# pacman keyring
#--------------------------------------
# The keyring is initialized on first boot by the
# pacman-keyring-init service, such that each installed
# system gets its own keyring master key
rm -rf /etc/pacman.d/gnupg

#======================================
# Generate system locale and configure it
#--------------------------------------
sed -i -e 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

#======================================
# Allow members of the wheel group to use sudo
#--------------------------------------
# The user created by GNOME Initial Setup is an administrator
# in the wheel group, as the users created by the CachyOS installer
chmod 0440 /etc/sudoers.d/10-wheel

#======================================
# Firewall, deny incoming and allow outgoing
#--------------------------------------
# These are the defaults of /etc/default/ufw, ufw is
# activated through its config as ufw enable requires
# the running system
sed -i -e 's/^ENABLED=no/ENABLED=yes/' /etc/ufw/ufw.conf

#======================================
# Activate services
#--------------------------------------
systemctl enable pacman-keyring-init.service
systemctl enable gdm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
systemctl enable avahi-daemon.service
systemctl enable systemd-timesyncd.service
systemctl enable ufw.service
systemctl enable fstrim.timer

#======================================
# Setup default target, graphical
#--------------------------------------
systemctl set-default graphical.target
