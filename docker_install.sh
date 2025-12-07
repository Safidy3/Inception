#!/bin/bash
set -e

# Uninstall old versions of Docker (if any)
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# Update package index
sudo apt update -y

# Install required packages
sudo apt install -y \
    wget gpg apt-transport-https software-properties-common \
    ca-certificates curl gnupg lsb-release \
    git make net-tools

# Install Microsoft GPG key and VS Code repository
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# Install Docker GPG key and repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again after adding repositories
sudo apt update -y

# Install Docker and VS Code
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin code

# Enable and start Docker service
sudo systemctl enable --now docker

# Add current user to the Docker group to run Docker without sudo
sudo usermod -aG docker "$USER"
newgrp docker

# Verify Docker installation
sudo docker --version
sudo docker run hello-world

# Notify the user
echo "Docker installation completed!"
echo "You may need to log out and back in for group changes to take effect."

# Clone the repository and launch app
git clone https://github.com/Safidy3/Inception.git
cd Inception/docker_setup
make up
