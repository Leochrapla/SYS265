#!/bin/bash

# secure-ssh.sh
# author leo
# creates a new ssh user using $1 parameter
# adds a public key from the local repo

# Check if username parameter is provided
if [ $# -eq 0 ]; then
    echo "Usage: ./secure-ssh.sh <username>"
    exit 1
fi

USERNAME=$1
PUBLIC_KEY_PATH="/docker01/linux/public-keys/id_rsa.pub"

# Create the new user
sudo useradd -m -s /bin/bash "$USERNAME"

# Create .ssh directory for the new user
sudo mkdir -p /home/$USERNAME/.ssh
sudo chmod 700 /home/$USERNAME/.ssh

# Copy the public key to the user's authorized_keys file
sudo cp $PUBLIC_KEY_PATH /home/$USERNAME/.ssh/authorized_keys
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Disable password authentication for the new user
sudo usermod -p '*' $USERNAME

echo "User $USERNAME created with SSH key access."
echo "Passwordless SSH login has been set up for $USERNAME."

# Optional: Add user to sudo group (uncomment if needed)
 sudo usermod -aG sudo $USERNAME

# Restart SSH service to apply changes
sudo systemctl restart sshd

echo "SSH service restarted. Setup complete."
