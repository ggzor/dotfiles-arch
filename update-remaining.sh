#!/usr/bin/env bash

set -euo pipefail

# Frequently overridden
if ! diff ~/.config/mimeapps.list xdg/mimeapps.list; then
  rm ~/.config/mimeapps.list
  echo "^^^ Diff from mimeapps.list"
fi

# Re-install links
./install.sh

# Update neovim dependencies
echo "Updating neovim..."
nvim --headless +silent +PlugInstall +PlugUpdate +qall
nvim --headless +silent +CocUpdateSync +qall

# Update zinit
zsh -ic 'zinit update --all'

