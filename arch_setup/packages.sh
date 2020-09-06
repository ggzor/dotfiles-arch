#!/usr/bin/env bash

set -euo pipefail

# Systemd commands
systemctl enable dhcpcd.service iwd.service \
                 sshd.service wpa_supplicant.service

