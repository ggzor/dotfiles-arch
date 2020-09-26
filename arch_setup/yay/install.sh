#!/usr/bin/env bash

set -euo pipefail

YAY_PATH="$HOME/.yay"

# Load packages from list
PACKAGES=$(cat './arch_setup/yay/packages.txt' \
          | sed '/^$/d' | grep -v '^#' | tr '\n' ' ')

if ! which yay &> /dev/null; then
  echo "Installing yay..."
  git clone https://yay.archlinux.org/yay.git "$YAY_PATH"
  cd "$YAY_PATH"
  makepkg -si
  cd -
else
  echo "Yay is already installed."
fi

# Install packages
# Update system before installing a new package
sudo pacman -Syu --noconfirm
yay -S --norebuild --nodiffmenu --batchinstall $PACKAGES

# Run extra install commands
./arch_setup/yay/config.sh

