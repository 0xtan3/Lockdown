#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <mount_point>"
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

# creating direcory for db
new_dbpath=/data/db
if [ ! -d "$new_dbpath" ]; then
    sudo mkdir -p "$new_dbpath"
fi

# assign a loop device to the file
losetup -f /backup/archive.img

# get the loop device
loop_device=$(losetup -a | grep archive.img | awk '{print $1}' | tr -d ':')

# execute luksOpen
echo "executing luksOpen"
(echo -n "$KEY") | cryptsetup luksOpen --key-file /opt/lockdown/key.txt $loop_device $dev_node

# mount the luks device to /data/db
echo "mount device..."
mount /dev/mapper/$dev_node $MOUNT_POINT

#FIXME: --decrypt needs to know the encrypted image
