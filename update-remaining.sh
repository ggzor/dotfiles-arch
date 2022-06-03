#!/usr/bin/env bash

set -euo pipefail

# Frequently overridden
if ! diff ~/.config/mimeapps.list xdg/mimeapps.list; then
  echo "^^^ Diff from mimeapps.list"
fi
rm ~/.config/mimeapps.list

# Re-install links
./install.sh

# Update neovim dependencies
echo "Updating neovim..."
nvim --headless +silent +PlugInstall +PlugUpdate +qall
nvim --headless +silent +CocUpdateSync +qall

# Update bat cache
bat cache --clear && bat cache --build

# Update zinit
zsh -ic 'zinit update --all'

