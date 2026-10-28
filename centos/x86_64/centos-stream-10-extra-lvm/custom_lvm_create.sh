#!/bin/bash
# editbootconfig hook, called by kiwi with:
#   $1: boot filesystem name
#   $2: partition number of the boot partition
#
# Turns the spare partition, which is configured to be the
# last partition on the disk, into an LVM volume group named
# Nova with one logical volume used for /var/lib/nova
set -ex

boot_partnum=$2

# kiwi maps the disk partitions either via kpartx (/dev/mapper/loopXpN)
# or via partx (/dev/loopXpN). Find the boot partition device to learn
# the name of the loop device holding the disk
boot_device=$(
    ls /dev/mapper/loop*p"${boot_partnum}" /dev/loop*p"${boot_partnum}" \
    2>/dev/null | head -n 1
)
part_prefix=${boot_device%"${boot_partnum}"}
loop_name=$(basename "${part_prefix%p}")
disk_device=/dev/${loop_name}

# the spare partition is the last partition
lvm_partnum=$(
    sgdisk -p "${disk_device}" | awk '/^ +[0-9]+ /{nr=$1} END{print nr}'
)
lvm_part=${part_prefix}${lvm_partnum}

sgdisk -t "${lvm_partnum}":8e00 "${disk_device}"

pvcreate "${lvm_part}"

vgcreate Nova "${lvm_part}"

lvcreate -Zn -L 200 -n nova Nova

mkfs.xfs /dev/Nova/nova

vgchange -an Nova
