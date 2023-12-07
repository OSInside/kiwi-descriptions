#!/bin/bash

set -x

root_partnum=$2

root_device=/dev/mapper/loop*p${root_partnum}

loop_name=$(basename $root_device | cut -f 1-2 -d'p')

disk_device=/dev/${loop_name}

lvm_part=/dev/mapper/${loop_name}p6

sgdisk -t 6:8e00 ${disk_device}

pvcreate ${lvm_part}

vgcreate Nova ${lvm_part}

lvcreate -Zn -L 200 -n nova Nova

mkfs.xfs /dev/Nova/nova

vgchange -an Nova
