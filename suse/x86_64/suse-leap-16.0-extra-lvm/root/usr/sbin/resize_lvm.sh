#!/bin/bash
# Grow the last partition, holding the Nova volume group,
# to the end of the disk and resize the physical volume
set -ex

root_device=$(
    lsblk -p -n -r -s -o NAME,MOUNTPOINT |\
    grep -E ' /$' | cut -f1 -d ' '
)

disk_device=$(
    lsblk -p -n -r -s -o NAME,TYPE "${root_device}" |\
    grep -E "disk|raid" | cut -f1 -d ' '
)

lvm_device=$(
    lsblk -p -n -r -o NAME,TYPE "${disk_device}" |\
    grep part | tail -n 1 | cut -f1 -d ' '
)

lvm_id=$(cat /sys/class/block/"$(basename "${lvm_device}")"/partition)

mountpoint -q /var/lib/nova && umount /var/lib/nova

vgchange -an Nova

# delete last partition and re-create it using the rest of the disk
sgdisk --delete="${lvm_id}" "${disk_device}"
sgdisk --new="${lvm_id}":0:0 --typecode="${lvm_id}":8e00 "${disk_device}"

# let the kernel know about the new partition size
partx --update --nr "${lvm_id}" "${disk_device}"

# resize pv's
pvresize "${lvm_device}"

vgchange -ay Nova

mount -a
