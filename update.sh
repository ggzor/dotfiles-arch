#!/usr/bin/env bash

set -euo pipefail

sudo -v

# Nice sudo loop
# https://gist.github.com/cowboy/3118588
while true; do
  sudo -v
  sleep 30
  kill -0 "$$" || exit
done &>/dev/null &

# Update dotfiles
git pull

# Update packages
./arch_setup/pacman/install.sh
./arch_setup/yay/install.sh unattended

# Update all the dependent components
./update-remaining.sh

