
#!/bin/bash

# Function to prompt user for input
function prompt_user {
    read -p "Enter the path to the local file: " LOCAL_FILE
    read -p "Enter the path to the local backup zip file: " LOCAL_ZIP
    read -p "Enter the username for remote server: " REMOTE_USER
    read -p "Enter the hostname or IP address of the remote server: " REMOTE_HOST
    read -p "Enter the path to the remote location: " REMOTE_FILE
}

# Function to perform backup
function perform_backup {
    # Zip the local file
    echo "Zipping the local file..."
    zip -r $LOCAL_ZIP $LOCAL_FILE >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Backup file created successfully"
    else
        echo "Failed to create backup file"
        exit 1
    fi
}

# Function to transfer backup file to remote server
function transfer_to_remote {
    # Transfer file using SCP
    echo "Transferring backup file to remote server..."
    scp -i /path/to/identity_file $LOCAL_ZIP $REMOTE_USER@$REMOTE_HOST:$REMOTE_FILE
    if [ $? -eq 0 ]; then
        echo "Backup file transferred successfully"
    else
        echo "Failed to transfer backup file"
    fi
}

# Prompt user for input
prompt_user

# Perform backup
perform_backup

# Transfer backup file to remote server
transfer_to_remote

# Clean up
echo "Cleaning up..."
rm -f $LOCAL_ZIP


# Define local and remote file paths
LOCAL_FILE="/path/to/local/file"
LOCAL_ZIP="/path/to/local/backup.zip"
REMOTE_USER="username"
REMOTE_HOST="remote_host"
REMOTE_FILE="/path/to/remote/location"
