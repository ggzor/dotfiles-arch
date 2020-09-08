#!/usr/bin/env bash

set -euo pipefail

# Systemd commands
systemctl enable sshd.service

## Docker
# Enable docker service
systemctl enable docker.service
# Start docker
systemctl start docker.service
# Add user to docker group
usermod -a -G docker "${USER_NAME:-$SUDO_USER}"

# Set xorg keyboard layout
[ -v "XORG_KEYMAP" ] && localectl set-x11-keymap "$XORG_KEYMAP"

# Set user shell
chsh -s "`which zsh`" "${USER_NAME:-$SUDO_USER}"

# Install stable rust toolchain
sudo -u "${USER_NAME:-$SUDO_USER}" rustup default stable

