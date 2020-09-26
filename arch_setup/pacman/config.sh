#!/usr/bin/env bash

set -euo pipefail
export USER_NAME=${USER_NAME:-$SUDO_USER}

# Systemd commands
systemctl enable sshd.service

# Pulseaudio
systemctl --user enable pulseaudio
systemctl --user start pulseaudio

## Docker
# Enable docker service
systemctl enable docker.service
# Start docker
systemctl start docker.service
# Add user to docker group
usermod -a -G docker "$USER_NAME"

# Set xorg keyboard layout
[ -v "XORG_KEYMAP" ] && localectl set-x11-keymap "$XORG_KEYMAP"

# Set user shell
chsh -s "`which zsh`" "$USER_NAME"

# Install stable rust toolchain
sudo -u "$USER_NAME" rustup default stable

# Install nodejs version and make the default
sudo -u "$USER_NAME" bash -c 'fnm install 14.10.1 && fnm default 14.10.1'
