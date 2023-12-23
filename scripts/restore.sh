#!/bin/bash

# update the package information
apt update

# check whether cryptsetup is installed 
if cryptsetup_version=$(cryptsetup --version 2>/dev/null); then
    echo "cryptsetup is installed. Version: $cryptsetup_version"
else
    echo "cryptsetup is not installed. Installing now...."
    # Set noninteractive mode and provide answers for keyboard-configuration and console-setup
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
        && echo 'keyboard-configuration keyboard-configuration/layout select USA' | debconf-set-selections \
        && echo 'console-setup console-setup/charmap47 select UTF-8' | debconf-set-selections \
        && echo 'console-setup console-setup/codesetcode select Guess optimal character set' | debconf-set-selections
    
    # install the cryptsetup package
    apt install cryptsetup -y
fi

# variable representing the device node
dev_node=luks_backup

# creating directory for mount
mnt_point=/data/mount
if [ ! -d "$mnt_point" ]; then
    sudo mkdir -p "$mnt_point"
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
cryptsetup luksOpen --key-file /data/passwd.txt $loop_device $dev_node

# mount the luks device to /data/db
echo "mount device..."
mount /dev/mapper/$dev_node $mnt_point

# change the dbPath inside /etc/mongod.conf
sudo sed -i "s|dbPath: /var/lib/mongodb/|dbPath: $new_dbpath|" /etc/mongos.conf

# copy files from mount point to db path
sudo cp -r $mnt_point/* $new_dbpath

# take backup of .bson file
sudo cp storage.bson storage.bson_backup

# remove .bson file
sudo rm storage.bson

# remove .lock file
sudo rm $new_dbpath/mongod.lock

# remove .log file
sudo rm /var/log/mongodb/mongod.log

# remove .sock file
sudo rm /tmp/mongodb-27017.sock

# give respective file permissions
sudo chown -R mongodb:mongodb $new_dbpath/*
sudo chmod -R u+rwX,g+rwX,o-rwx $new_dbpath/*
sudo chown -R mongodb:mongodb $new_dbpath
sudo chmod -R u+rwX,g+rwX,o-rwx $new_dbpath

# restore the deleted files
sudo mongod --dbpath $new_dbpath --repair

# run mongod 
sudo mongod --dbpath $new_dbpath