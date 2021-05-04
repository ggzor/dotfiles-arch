#!/usr/bin/env bash

declare -A ACTIONS
ACTIONS=(
  [" open clipboard image"]=clipboard_image
)

clipboard_image() {
    xclip -selection clipboard -o -t image/png | feh -
}

if [ "$@" ]
then
    "${ACTIONS["$*"]}" &> /dev/null &
else
    echo -en "\x00prompt\x1f<span fgcolor='#6c7a89'>action</span>\n"
    echo -en "\x00markup-rows\x1ftrue\n"

    for ACTION in "${!ACTIONS[@]}"; do
        echo "$ACTION"
    done
fi

