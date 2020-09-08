#!/usr/bin/env bash

set -euo pipefail

# Load packages from list
PACKAGES=$(cat './arch_setup/packages.txt' | sed '/^$/d' | grep -v '^#' | tr '\n' ' ')

# Install packages
pacman -Syu --noconfirm
pacman -S --noconfirm --needed $PACKAGES

# Run extra install commands
./arch_setup/packages.sh

