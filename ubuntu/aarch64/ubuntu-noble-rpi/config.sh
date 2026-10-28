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
systemctl enable systemd-networkd
systemctl enable symlink-resolvconf
systemctl enable rpi-eeprom-update
systemctl enable systemd-timesyncd

#======================================
# Setup default target, multi-user
#--------------------------------------
systemctl set-default multi-user.target

#======================================
# Configure Raspberry Pi specifics
#--------------------------------------
# Add necessary kernel modules to initrd
echo 'add_drivers+=" bcm2835_dma dwc2 "' \
    > /etc/dracut.conf.d/raspberrypi_modules.conf

# Work around HDMI connector bug and network issues
# No HDMI hotplug available
# Prevent too many page allocations (bsc#1012449)
cat > /etc/modprobe.d/50-rpi3.conf <<-EOF
	options drm_kms_helper poll=0
	options smsc95xx turbo_mode=N
EOF

# Avoid running out of DMA pages for smsc95xx (bsc#1012449)
cat > /usr/lib/sysctl.d/50-rpi3.conf <<-EOF
	vm.min_free_kbytes = 2048
EOF
