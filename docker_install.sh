#!/bin/bash
set -e

DOMAIN_NAME="safandri.42.fr"

# Uninstall old versions
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# Update package index
sudo apt update -y

# Install required packages
sudo apt install -y \
    wget gpg apt-transport-https \
    ca-certificates \
    curl gnupg lsb-release \
    make net-tools

# Install Microsoft GPG key and VS Code repository
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again
sudo apt update -y

# Install Docker Engine, CLI, containerd, and plugins
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin code

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add current user to docker group (so you can run docker without sudo)
sudo usermod -aG docker $USER
newgrp docker

sudo systemctl start docker
sudo systemctl enable docker

sudo docker --version

sudo docker run hello-world

echo "Docker installation completed!"
echo "You may need to log out and back in for group changes to take effect."
# Check if domain already exists in /etc/hosts
if grep -q "$DOMAIN_NAME" /etc/hosts; then
    echo "Domain $DOMAIN_NAME already exists in /etc/hosts"
else
    echo "Adding $DOMAIN_NAME to /etc/hosts..."
    echo "127.0.0.1 $DOMAIN_NAME" | sudo tee -a /etc/hosts
    echo "Domain added successfully!"
fi

echo "Current /etc/hosts entries for the domain:"
grep -i "$DOMAIN_NAME" /etc/hosts || echo "No entries found"

# make