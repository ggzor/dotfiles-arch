#!/usr/bin/env bash

declare -A FILES
FILES=(
  [" Now.md"]="$HOME/Now.md"
  [" Palabras.md"]="$HOME/Palabras.md"
)

if [ "$@" ]
then
    kitty --title '<floating>' nvim "${FILES["$*"]}" &> /dev/null &
else
    echo -en "\x00prompt\x1f<span fgcolor='#6c7a89'>edit</span>\n"
    echo -en "\x00markup-rows\x1ftrue\n"

    for FILE in "${!FILES[@]}"; do
        [[ -f "${FILES["$FILE"]}" ]] && \
            echo "$FILE"
    done
fi

