#!/bin/bash

function encrypt {

    # Check if key is empty
    if [ -z "$KEY" ]; then
        echo "Error: Encryption key is empty."
        exit 1
    fi

    # Create a 10GB image file
    fallocate -l 10G "$root_path/encrypted_img/archive.img"

    # Assign a loop device to the file
    loop_device=$(losetup -f "$root_path/encrypted_img/archive.img")

    # Check if loop device assignment was successful
    if [ -z "$loop_device" ]; then
        echo "Error: Failed to assign loop device to '$root_path/encrypted_img/archive.img'."
        exit 1
    fi

    # Format the LUKS device with luksFormat
    echo -n "$KEY" | sudo -S cryptsetup luksFormat --batch-mode "$loop_device"

    # Assign the device node to a variable
    dev_node=luks

    # Execute luksOpen
    echo "Executing luksOpen..."
    echo -n "$KEY" | sudo -S cryptsetup luksOpen "$loop_device" "$dev_node"

    # Check if luksOpen was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to open LUKS device."
        exit 1
    fi

    # Check whether the luksOpen has run properly
    if [ -e "/dev/mapper/$dev_node" ]; then
        echo "The device /dev/mapper/$dev_node exists. Executing mkfs.ext4..."
        mkfs.ext4 "/dev/mapper/$dev_node" -L "$dev_node"
    else
        echo "Error: The device /dev/mapper/$dev_node does not exist."
        exit 1
    fi

    # Mount the LUKS device to /data/db
    echo "Mounting device..."
    sudo mount "/dev/mapper/$dev_node" "$MOUNT_POINT"

    # Check if mounting was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to mount device."
        exit 1
    fi
}

# Check if mount point argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <mount_point>"
    exit 1
fi

MOUNT_POINT="$1"

# Create directory for mount if it doesn't exist
if [ ! -d "$MOUNT_POINT" ]; then
    sudo mkdir -p "$MOUNT_POINT"
fi

# Root path for script
root_path="./data"

# Create root directory if it doesn't exist
if [ ! -d "$root_path" ]; then
    mkdir "$root_path"
fi

# Call the key_gen.py script and capture the output
KEY=$(python3 scripts/key_gen.py)

# Check if key generation was successful
if [ -z "$KEY" ]; then
    echo "Error: Failed to generate encryption key."
    exit 1
fi

# Create directory for encrypted_img if it doesn't exist
mkdir -p "$root_path/encrypted_img"

# Function call to encrypt
encrypt
