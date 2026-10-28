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

#==========================================
# Remove package docs
#------------------------------------------
rm -rf /usr/share/doc/packages/*
rm -rf /usr/share/doc/manual/*

#==========================================
# Preparations for Vagrant
#------------------------------------------
# the default shared folder
mkdir -p /vagrant
chown vagrant:vagrant /vagrant

# the insecure vagrant ssh key and passwordless sudo
chmod 0700 /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 0440 /etc/sudoers.d/vagrant

# start vboxsf only if the guest tools are present
if rpm -q virtualbox-guest-tools &>/dev/null; then
    echo vboxsf > /etc/modules-load.d/vboxsf.conf
fi
