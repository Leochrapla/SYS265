#!/bin/bash

# secure-ssh.sh
# author leo
# creates a new ssh user using $1 parameter
# adds a public key from the local repo


if [ $# -eq 0 ]; then
    echo "Usage: ./secure-ssh.sh <username>"
    exit 1
fi

USERNAME=$1
PUBLIC_KEY_PATH="docker01/linux/public-keys/id_rsa.pub"
sudo useradd -m -s /bin/bash "$USERNAME"

sudo mkdir -p /home/$USERNAME/.ssh
sudo chmod 700 /home/$USERNAME/.ssh


sudo cp $PUBLIC_KEY_PATH /home/$USERNAME/.ssh/authorized_keys
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh


sudo usermod -p '*' $USERNAME

echo "User $USERNAME created with SSH key access."
echo "Passwordless SSH login has been set up for $USERNAME."


 sudo usermod -aG sudo $USERNAME

sudo systemctl restart sshd

echo "SSH service restarted. Setup complete."
