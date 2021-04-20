#!/usr/bin/env bash

set -euo pipefail
export USER_NAME=${USER_NAME:-$SUDO_USER}

# Systemd commands
systemctl enable sshd.service

# firewalld
systemctl enable firewalld
systemctl start firewalld

