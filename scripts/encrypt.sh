#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <mount_point>"
    exit 1
fi

MOUNT_POINT="$1"


# Call the key_gen.py script and capture the output
KEY=$(python3 key_gen.py)

# make a directory named encrypted_img
mkdir /encrypted_img

# create a 15GB image file
fallocate -l 10G /encrypted_img/archive.img

# assign a loop device to the file
losetup -f /encrypted_img/archive.img

# get the loop device
loop_device=$(losetup -a | grep archive.img | awk '{print $1}' | tr -d ':')

# format the LUKS device with luksFormat
cryptsetup luksFormat --batch-mode --key-file /data/passwd.txt $loop_device

# assign the device node to a variable
dev_node=luks

# execute luksOpen
echo "executing luksOpen"
cryptsetup luksOpen --key-file <(echo -n "$KEY") $loop_device $dev_node

# check whether the luksOpen has run properly
if [[ -e "/dev/mapper/$dev_node" ]]; then
    echo "The device /dev/mapper/$dev_node exists. Executing mkfs.ext4..."
    mkfs.ext4 "/dev/mapper/$dev_node" -L "$dev_node"
else
    echo "The device /dev/mapper/$dev_node does not exist."
fi

# mount the luks device to /data/db
echo "mount device..."
mount /dev/mapper/$dev_node $MOUNT_POINT

#Note => the mount point should be given by the user and the dev_node name should be also given by the user. Or else dev_node not needed for this. And there is db connectivity