#!/usr/bin/env bash

set -euo pipefail

# Load packages from list
read -ra PACKAGES <<< "$(sed '/^$/d' './arch_setup/pacman/packages.txt' | \
                         grep -v '^#' | awk '{print $1}' | tr '\n' ' ')"

# Install packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed "${PACKAGES[@]}"

# Run extra install commands
sudo ./arch_setup/pacman/config.sh

