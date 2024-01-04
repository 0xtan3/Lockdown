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

# install python3
apt install python3

# install python3
apt install sqlite

# make a tool directory
mkdir /opt/lockdown