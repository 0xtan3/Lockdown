#!/bin/bash

# update the package information
apt update

# Set noninteractive mode and provide answers for keyboard-configuration and console-setup
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && echo 'keyboard-configuration keyboard-configuration/layout select USA' | debconf-set-selections \
    && echo 'console-setup console-setup/charmap47 select UTF-8' | debconf-set-selections \
    && echo 'console-setup console-setup/codesetcode select Guess optimal character set' | debconf-set-selections
    
# install the cryptsetup package
apt install cryptsetup -y

# install python
apt install python3