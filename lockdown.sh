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

function show_help {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --encrypt        Encrypt a database"
    echo "  --decrypt        Decrypt a database"
    echo "  -m <mount_point> Specify the mount point for the database"
    echo "  -d <dump_point>  Specify the location of file dumps"
    echo "  --install        Install required packages"
    echo "  --help           Show this help message"   
}

# Function to install required packages
function install_packages {
    # Add your package installation commands here
    echo "Installing packages..."
    sudo ./scripts/install.sh
}

function clean_all {
    sudo umount $MOUNT_POINT
    sudo cryptsetup luksClose luks 
    sudo losetup -D
    echo "Luks device has been removed successfully"
}

# Function to perform encryption
function encrypt {
    if [ -z "$MOUNT_POINT" ]; then
        echo "Error: Mount point not specified."
        show_usage
    fi

    ./scripts/encrypt.sh $MOUNT_POINT

    echo
    echo -e "Encryption completed for $MOUNT_POINT\n"
    # Get the key to the user
    show_key=$(python3 -c 'from scripts.db_operations import get_latest_key; print(get_latest_key())')
    echo "key: $show_key"
    
    read -p "Do you wish to keep $MOUNT_POINT visible [Y/N] " choice
    if [[ $choice == [Yy] ]]; then
        sudo umount $MOUNT_POINT
    fi
}

# Function to perform decryption
function decrypt {
    if [ -z "$MOUNT_POINT" ]; then
        echo "Error: Mount point not specified."
        show_usage
    fi

    if [ -z "$DUMP" ]; then
        echo "Error: File dumps cannot be found."

    ./scripts/decrypt.sh $MOUNT_POINT $DUMP

    echo
    echo -e "Decryption completed for $MOUNT_POINT\n"
    read -p "Do you wish to keep $MOUNT_POINT visible [Y/N] " choice
    if [[$choice == [Yy] ]]; then
        sudo umount $MOUNT_POINT
    fi
}

# Parse command line arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --install)
            MODE="install"
            install_packages 
            exit 0
            ;;
        --clean)
            MODE="clean"
            clean_all
            exit 0
            ;;
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
        -d)
            shift
            DUMP="$2"
            ;;
        --help)
            MODE="help"
            show_help
            exit 0
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
elif [ "$MODE" == "install" ]; then
    install_packages
elif [ "$MODE" == "clean" ]; then
    clean_all
elif [ "$MODE" == "help" ]; then
    show_help
else
    echo "Error: Unknown mode: $MODE"
    show_usage
fi