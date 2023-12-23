# lockdown.sh
#!/bin/bash

version=1.0

echo "

    __    ____  ________ __ ____  ____ _       ___   __
   / /   / __ \/ ____/ //_// __ \/ __ \ |     / / | / /
  / /   / / / / /   / ,<  / / / / / / / | /| / /  |/ / 
 / /___/ /_/ / /___/ /| |/ /_/ / /_/ /| |/ |/ / /|  /  
/_____/\____/\____/_/ |_/_____/\____/ |__/|__/_/ |_/   
                                        version $version                 
"

# Function to display usage information
function show_usage {
    echo "Usage: $0 (--encrypt|--decrypt) -m <mount_point>"
    exit 1
}

# Function to install required packages
function install_packages {
    # Add your package installation commands here
    echo "Installing packages..."
    sudo ./scripts/install.sh
}

# Install packages in the background
install_packages &

# Function to perform encryption
function encrypt {
    if [ -z "$MOUNT_POINT" ]; then
        echo "Error: Mount point not specified."
        show_usage
    fi

    ./scripts/encrypt.sh $MOUNT_POINT

    echo
    echo -e "Encryption completed for $MOUNT_POINT\n"
    read -p "Do you wish to keep $MOUNT_POINT visible [Y/N] " choice
    if [[$choice == [Yy] ]]; then
        sudo umount $MOUNT_POINT

}

# Function to perform decryption
function decrypt {
    if [ -z "$MOUNT_POINT" ]; then
        echo "Error: Mount point not specified."
        show_usage
    fi

    ./scripts/decrypt.sh $MOUNT_POINT

    echo
    echo -e "Decryption completed for $MOUNT_POINT\n"
    read -p "Do you wish to keep $MOUNT_POINT visible [Y/N] " choice
    if [[$choice == [Yy] ]]; then
        sudo umount $MOUNT_POINT

}

# Parse command line arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --encrypt)
            MODE="encrypt"
            ;;
        --decrypt)
            MODE="decrypt"
            ;;
        -m)
            shift
            MOUNT_POINT="$1"
            ;;
        *)
            echo "Error: Unknown option: $1"
            show_usage
            ;;
    esac
    shift
done

# Check for required parameters
if [ -z "$MODE" ]; then
    echo "Error: Mode not specified."
    show_usage
fi

# Perform the requested operation
if [ "$MODE" == "encrypt" ]; then
    encrypt
elif [ "$MODE" == "decrypt" ]; then
    decrypt
else
    echo "Error: Unknown mode: $MODE"
    show_usage
fi