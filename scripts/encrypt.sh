#!/bin/bash

function encrypt {
    # create a 15GB image file
    fallocate -l 10G $root_path/encrypted_img/archive.img

    # assign a loop device to the file
    losetup -f $root_path/encrypted_img/archive.img

    # get the loop device
    loop_device=$(losetup -a | grep archive.img | awk '{print $1}' | tr -d ':')

    # format the LUKS device with luksFormat
    (echo -n "$KEY") | cryptsetup luksFormat --batch-mode $loop_device

    # assign the device node to a variable
    dev_node=luks

    # execute luksOpen
    echo "executing luksOpen"
    (echo -n "$KEY") | cryptsetup luksOpen $loop_device $dev_node
    # cryptsetup luksOpen --key-file <(echo -n "$KEY") $loop_device $dev_node  

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
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <mount_point>"
    exit 1
fi

MOUNT_POINT="$1"

root_path=./data

mkdir $root_path

# Call the key_gen.py script and capture the output
KEY=$(python3 ./scripts/key_gen.py)

# make a directory named encrypted_img
mkdir -p $root_path/encrypted_img

# function call
encrypt

