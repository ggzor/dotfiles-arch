#!/usr/bin/env bash

set -euo pipefail

# Load packages from list
PACKAGES=$(cat './arch_setup/aur_packages.txt' | sed '/^$/d' | grep -v '^#' | tr '\n' ' ')

if ! which yay &> /dev/null; then
  cd "$HOME/.yay"
  makepkg -si
  cd -
else
  echo "Yay is already installed."
fi

# Install packages
yay -S $PACKAGES

# Run extra install commands
./arch_setup/aur_packages.sh

