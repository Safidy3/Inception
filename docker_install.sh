#!/bin/bash
set -e

# Uninstall old versions
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# Update package index
sudo apt update -y

# Install required packages
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg


# Set up the Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# Update package index again
sudo apt update -y

# Install Docker Engine, CLI, containerd, and plugins
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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

make