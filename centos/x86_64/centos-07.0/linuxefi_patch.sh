#!/bin/bash -x

set -e

disk_img=$1
mapped_dev=$2
tmp_mount=$(mktemp -d disk_XXXXX)

mount "${mapped_dev}" "${tmp_mount}"

grub_config="${tmp_mount}/boot/grub/grub.cfg"

if [ -f  "${grub_config}" ]; then
    echo "Patching grub configuration file: ${grub_config}"
    sed -i "s|linuxefi|linux|g" "${grub_config}"
    sed -i "s|initrdefi|initrd|g" "${grub_config}"
fi
umount "${tmp_mount}" && rm -r ${tmp_mount}
