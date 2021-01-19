#!/usr/bin/env bash

declare -A DIRECTORIES
DIRECTORIES=(
  [" dotfiles"]="$HOME/dotfiles"
  [" scratch"]="$HOME/Scratch"
)

DIR_COMMAND="
    echo '\033[1mDirectory contents:\033[0m'
    exa --icons
    echo ''
    zsh -i"

if [ "$@" ]
then
    kitty --directory "${DIRECTORIES["$*"]}" zsh -c "$DIR_COMMAND" l &> /dev/null &
else
    echo -en "\x00prompt\x1f<span fgcolor='#6c7a89'>terminal in</span>\n"
    echo -en "\0markup-rows\x1ftrue\n"

    for DIRECTORY in "${!DIRECTORIES[@]}"; do
         [[ -d "${DIRECTORIES[$DIRECTORY]}" ]] && \
            echo "$DIRECTORY"
    done
fi

