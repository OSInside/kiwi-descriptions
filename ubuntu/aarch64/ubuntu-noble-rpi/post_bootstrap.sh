#!/bin/dash

set -ex

# Use zstd as the default compression tool for dracut initrd images to speed up
# the build. Need to do it here so that it's picked up during the initial
# package install process.

mkdir -p /etc/dracut.conf.d/
cat > /etc/dracut.conf.d/50-use-zstd-compression.conf << EOF
compress="zstd"
EOF
