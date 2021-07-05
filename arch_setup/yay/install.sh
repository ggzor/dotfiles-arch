#!/usr/bin/env bash

set -euo pipefail

YAY_PATH="$HOME/.yay"

# Load packages from list
read -ra PACKAGES <<< "$(sed '/^$/d' './arch_setup/yay/packages.txt' | \
                         grep -v '^#' | awk '{print $1}' | tr '\n' ' ')"

# FIXME: Avoid using which, prefer command, hash or type
if ! which yay &> /dev/null; then
  echo "Installing yay..."
  git clone https://aur.archlinux.org/yay.git "$YAY_PATH"
  cd "$YAY_PATH"
  makepkg -si
  cd -
else
  echo "Yay is already installed."
fi

# Install packages
# Update system before installing a new package
sudo pacman -Syu --noconfirm
yay -S --norebuild --nodiffmenu --editmenu --batchinstall "${PACKAGES[@]}"

# Run extra install commands
./arch_setup/yay/config.sh

