#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <mount_point> <dumped_files>"
    exit 1
fi

MOUNT_POINT="$1"

# pass location of the dump
DUMP="$2"

# variable representing the device node
dev_node=luks

read -sp "Enter the key: " KEY

# creating directory for mount
if [ ! -d "$MOUNT_POINT" ]; then
    sudo mkdir -p "$MOUNT_POINT"
fi

# assign a loop device to the file
loop_device=$(losetup -f $DUMP/archive.img)

# execute luksOpen
echo "executing luksOpen"
(echo -n "$KEY") | sudo -S cryptsetup luksOpen $loop_device $dev_node

# mount the luks device to /data/db
echo "mount device..."
mount /dev/mapper/$dev_node $MOUNT_POINT

