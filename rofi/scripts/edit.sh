#!/usr/bin/env bash

declare -A FILES
FILES=(
  [" Palabras.md"]="$HOME/Palabras.md"
  [" Notas.md"]="$HOME/Notas.md"
)

if [ "$@" ]
then
    kitty --title '<floating>' nvim "${FILES["$*"]}" &> /dev/null &
else
    # The label color is intentional, because it allows to fade the
    # type of command, the tradeoff is that a non-combi mode has to be
    # specified as a combi mode to allow to change the prompt.
    echo -en "\x00prompt\x1f<span fgcolor='#6c7a89'>edit</span>\n"
    echo -en "\x00markup-rows\x1ftrue\n"

    for FILE in "${!FILES[@]}"; do
        [[ -f "${FILES["$FILE"]}" ]] && \
            echo "$FILE"
    done
fi

