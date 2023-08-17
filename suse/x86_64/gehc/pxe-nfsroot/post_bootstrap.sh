#!/bin/bash

set -ex

mkdir -p /etc/dracut.conf.d

# Set gzip as the default compression tool for NFS boot
cat > /etc/dracut.conf.d/50-enable-gzip-compression.conf <<- EOF
compress="gzip"
EOF
