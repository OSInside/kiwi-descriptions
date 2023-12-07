#!/bin/bash

set -x

root_device=$(
    lsblk -p -n -r -s -o NAME,MOUNTPOINT |\
    grep -E ' /$' | cut -f1 -d ' '
)

lvm_device=$(
    lsblk -p -n -r -s -o NAME,TYPE |\
    grep part | tail -n 1 | cut -f1 -d ' '
)

disk_device=$(
    lsblk -p -n -r -s -o NAME,TYPE ${root_device} |\
    grep -E "disk|raid" | cut -f1 -d ' '
)

lvm_id=6

mountpoint -q /var/lib/nova && umount /var/lib/nova

vgchange -an Nova

# delete last partition and re-create with rest space
sgdisk --delete=${lvm_id} ${disk_device}
sgdisk --new=6:0:0 ${disk_device}

# let the kernel now about the partition table change
partprobe ${disk_device}

# resize pv's
pvresize ${lvm_device}

vgchange -ay

mount -a
