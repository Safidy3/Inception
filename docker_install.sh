#!/bin/bash
set -e

USER_NAME=$(whoami)

# Detect Distribution (Ubuntu/Debian/Fedora)
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
fi

# Remove old docker versions if they exist
if [ "$DISTRO" == "ubuntu" ] || [ "$DISTRO" == "debian" ]; then
    sudo apt remove -y docker docker-engine docker.io containerd runc || true
    sudo apt update -y
elif [ "$DISTRO" == "fedora" ] || [ "$DISTRO" == "nobara" ]; then
    sudo dnf remove -y docker docker-engine docker.io containerd runc || true
    sudo dnf update -y
fi

# Install essential tools
if [ "$DISTRO" == "ubuntu" ] || [ "$DISTRO" == "debian" ]; then
    sudo apt install -y \
        ca-certificates curl gnupg lsb-release wget gpg git zsh npm make gcc clang valgrind
elif [ "$DISTRO" == "fedora" ] || [ "$DISTRO" == "nobara" ]; then
    sudo dnf install -y \
        ca-certificates curl gnupg lsb-release wget gpg git zsh npm make gcc clang valgrind
fi

# Install Microsoft key for VS Code (Works for Ubuntu, Debian, Fedora, Nobara)
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | \
sudo gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg

# Install Node.js (Version 20)
if [ "$DISTRO" == "ubuntu" ] || [ "$DISTRO" == "debian" ]; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
elif [ "$DISTRO" == "fedora" ] || [ "$DISTRO" == "nobara" ]; then
    sudo dnf install -y nodejs
fi

# Add VS Code Repository for Ubuntu/Debian
if [ "$DISTRO" == "ubuntu" ] || [ "$DISTRO" == "debian" ]; then
    echo "deb [signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] \
    https://packages.microsoft.com/repos/vscode stable main" | \
    sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    sudo apt update -y
    sudo apt install -y code
fi

# Add Docker Repository
if [ "$DISTRO" == "ubuntu" ] || [ "$DISTRO" == "debian" ]; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin readline-devel readline gcc-c++ clang make
elif [ "$DISTRO" == "fedora" ] || [ "$DISTRO" == "nobara" ]; then
    sudo dnf config-manager --add-repo=https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin readline clang make libreadline-dev g++
fi

# Start Docker service and add user to docker group
if [ "$DISTRO" == "ubuntu" ] || [ "$DISTRO" == "debian" ]; then
    sudo systemctl enable docker
    sudo systemctl start docker
elif [ "$DISTRO" == "fedora" ] || [ "$DISTRO" == "nobara" ]; then
    sudo systemctl enable --now docker
fi

sudo usermod -aG docker $USER_NAME

echo "Logout and login again to use Docker without sudo."

# Verify Docker installation
sudo docker --version

# Install Oh-My-Zsh and custom Zsh theme
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl https://raw.githubusercontent.com/trabdlkarim/parrot-zsh-theme/main/parrot.zsh-theme > /home/$USER_NAME/.oh-my-zsh/themes/parrot.zsh-theme
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$USER_NAME/.oh-my-zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/$USER_NAME/.oh-my-zsh/plugins/zsh-autosuggestions

echo 'export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="parrot"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh' > ~/.zshrc

echo "Setup Complete!"
