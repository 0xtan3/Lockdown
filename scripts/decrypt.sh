#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <mount_point>"
    exit 1
fi

MOUNT_POINT="$1"


# Call the key_gen.py script and capture the output
KEY=$(python3 key_gen.py)

# variable representing the device node
dev_node=luks_backup

# creating directory for mount
mnt_point=/data/mount
if [ ! -d "$MOUNT_POINT" ]; then
    sudo mkdir -p "$MOUNT_POINT"
fi

# creating direcory for db
new_dbpath=/data/db
if [ ! -d "$new_dbpath" ]; then
    sudo mkdir -p "$new_dbpath"
fi

# assign a loop device to the file
losetup -f /backup/archive.img

# get the loop device
loop_device=$(losetup -a | grep archive.img | awk '{print $1}' | tr -d ':')

# assign the device node to a variable
dev_node=luks_backup

# execute luksOpen
echo "executing luksOpen"
cryptsetup luksOpen --key-file <(echo -n "$KEY") $loop_device $dev_node

# mount the luks device to /data/db
echo "mount device..."
mount /dev/mapper/$dev_node $MOUNT_POINT

