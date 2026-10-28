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

#======================================
# Console font, systemd controls it
#--------------------------------------
echo 'FONT=eurlatgr.psfu' >> /etc/vconsole.conf

#======================================
# Configure Raspberry Pi specifics
#--------------------------------------
# Add necessary kernel modules to initrd
echo 'add_drivers+=" bcm2835_dma dwc2 "' \
    > /etc/dracut.conf.d/raspberrypi_modules.conf

# Work around HDMI connector bug and network issues
cat > /etc/modprobe.d/50-rpi3.conf <<-EOF
	# No HDMI hotplug available
	options drm_kms_helper poll=0
	# Prevent too many page allocations (bsc#1012449)
	options smsc95xx turbo_mode=N
EOF

cat > /usr/lib/sysctl.d/50-rpi3.conf <<-EOF
	# Avoid running out of DMA pages for smsc95xx (bsc#1012449)
	vm.min_free_kbytes = 2048
EOF
