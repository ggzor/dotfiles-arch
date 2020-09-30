#!/usr/bin/env bash

set -euo pipefail

# Load packages from list
PACKAGES=$(cat './arch_setup/pacman/packages.txt' \
          | sed '/^$/d' | grep -v '^#' | awk '{print $1}' \
          | tr '\n' ' ')

# Install packages
pacman -Syu --noconfirm
pacman -S --noconfirm --needed $PACKAGES

# Run extra install commands
./arch_setup/pacman/config.sh

