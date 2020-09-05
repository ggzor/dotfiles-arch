#!/usr/bin/env bash

set -euo pipefail

# Systemd commands
systemctl enable dhcpcd.service iwd.service \
                 sshd.service wpa_supplicant.service

# Configure supplicant
wpa_supplicant -B -i wlan0 \
               -c <(echo "ctrl_interface=/run/wpa_supplicant\nupdate_config=1") \
               || echo "No wireless interface found. Omitting setup."

