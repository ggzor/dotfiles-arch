#!/usr/bin/env bash

set -euo pipefail

# Load packages from list
PACKAGES=$(cat './arch_setup/pacman/packages.txt' \
          | sed '/^$/d' | grep -v '^#' | awk '{print $1}' \
          | tr '\n' ' ')

# Install packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed $PACKAGES

# Run extra install commands
sudo ./arch_setup/pacman/config.sh

