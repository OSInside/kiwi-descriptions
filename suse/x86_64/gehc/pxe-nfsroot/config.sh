#!/bin/bash

set -ex

# Allow nfs module to load for NFS boot
cat > /usr/lib/modprobe.d/10-unsupported-modules.conf <<- EOF
allow_unsupported_modules 1
EOF

# Include NFS root required modules to initrd
cat > /etc/dracut.conf.d/50-enable-net.conf <<- EOF
add_dracutmodules+=" systemd-network-management nfs engage-nfs "
EOF
