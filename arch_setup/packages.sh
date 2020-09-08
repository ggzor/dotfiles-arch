#!/usr/bin/env bash

set -euo pipefail

# Systemd commands
systemctl enable sshd.service

# Set xorg keyboard layout
[ -v "XORG_KEYMAP" ] && localectl set-x11-keymap "$XORG_KEYMAP"

