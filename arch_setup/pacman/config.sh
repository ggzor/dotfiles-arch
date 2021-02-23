#!/usr/bin/env bash

set -euo pipefail
export USER_NAME=${USER_NAME:-$SUDO_USER}

# Systemd commands
systemctl enable sshd.service

# Pulseaudio
systemctl --user enable pulseaudio
systemctl --user start pulseaudio

# firewalld
systemctl enable firewalld
systemctl start firewalld

## Docker
# Enable docker service
systemctl enable docker.service
# Start docker
systemctl start docker.service
# Add user to docker group
usermod -a -G docker "$USER_NAME"

# Install stable rust toolchain
sudo -u "$USER_NAME" rustup default stable

