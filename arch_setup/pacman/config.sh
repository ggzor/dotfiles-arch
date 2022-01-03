#!/usr/bin/env bash

set -euo pipefail
export USER_NAME=${USER_NAME:-${SUDO_USER:-${USER}}}

# Add user to docker group
sudo usermod -aG docker "$USER_NAME"

# Systemd commands
sudo systemctl enable --now \
	acpid.service \
	docker.service \
	firewalld.service \
	sshd.service

# Install stable and nightly rust toolchain
sudo -u "$USER_NAME" rustup install stable nightly

# Use stable by default
sudo -u "$USER_NAME" rustup default stable

# Remove previous python venvs
rm -rf ~/.local/pipx

# Install useful python executables
sudo -u "$USER_NAME" bash -c '
	pipx install -f \
		mathlibtools
	pipx install -f \
		poetry
	pipx install -f \
		black
	pipx install -f \
		pprofile
'

