#!/bin/bash
set -e

USER_NAME=$(whoami)

sudo apt remove -y docker docker-engine docker.io containerd runc || true
sudo apt update -y

sudo apt install -y \
    ca-certificates curl gnupg lsb-release wget gpg git zsh npm make gcc clang valgrind

# Microsoft key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | \
sudo gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg

# node sources
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y

echo "deb [signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] \
https://packages.microsoft.com/repos/vscode stable main" | \
sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

# Docker repo
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin code

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER_NAME

echo "Logout and login again to use Docker without sudo."

sudo docker --version

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl https://raw.githubusercontent.com/trabdlkarim/parrot-zsh-theme/main/parrot.zsh-theme > /home/safandri/.oh-my-zsh/themes/parrot.zsh-theme
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/safandri/.oh-my-zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/safandri/.oh-my-zsh/plugins/zsh-autosuggestions

echo 'export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="parrot"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh' > ~/.zshrc
