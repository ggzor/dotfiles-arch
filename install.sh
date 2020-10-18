#!/bin/bash

set -euo pipefail

source './utils.sh'

# Link configuration files and folders using utils.sh
link_same        "$(pwd)/awesome"      "$HOME/.config/awesome"
link_same        "$(pwd)/kitty"        "$HOME/.config/kitty"
link_same_files  "$(pwd)/nvim"         "$HOME/.config/nvim"
link_same_files  "$(pwd)/vscode"       "$HOME/.config/Code - Insiders/User"
link_same_single "$(pwd)" 'picom.conf' "$HOME/.config/picom"
link_same_single "$(pwd)" '.xinitrc'   "$HOME"
link_same_single "$(pwd)" '.zshrc'     "$HOME"

echo -e "\033[0;32mLinked all configuration files\033[0m"

