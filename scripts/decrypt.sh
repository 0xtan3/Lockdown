#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <mount_point> <dumped_files>"
    exit 1
fi

MOUNT_POINT="$1"
DUMP="$2"
dev_node=luks

# Check if the mount point exists
if [ ! -d "$MOUNT_POINT" ]; then
    echo "Error: Mount point '$MOUNT_POINT' does not exist or is not a directory."
    exit 1
fi

# Check if the dumped files directory exists
if [ ! -d "$DUMP" ]; then
    echo "Error: Dumped files directory '$DUMP' does not exist or is not a directory."
    exit 1
fi

# Prompt for the key
read -rsp "Enter the key: " KEY

# Assign a loop device to the file
losetup -f "$DUMP"

loop_device=$(losetup -a | grep "$DUMP" | awk '{print $1}' | tr -d ':')

# Check if loop device assignment was successful
if [ -z "$loop_device" ]; then
    echo "Error: Failed to assign loop device to '$DUMP'."
    exit 1
fi

# Execute luksOpen
echo "Executing luksOpen..."
(echo -n "$KEY") | sudo -S cryptsetup luksOpen "$loop_device" $dev_node

# Check if luksOpen was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to open LUKS device."
    exit 1
fi

# Mount the LUKS device
echo "Mounting device..."
sudo mount "/dev/mapper/$dev_node" "$MOUNT_POINT"

# Check if mounting was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to mount device."
    exit 1
fi

echo "Decryption completed successfully."

