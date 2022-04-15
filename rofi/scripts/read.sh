#!/usr/bin/env bash

shopt -s nullglob

READ_DIR="$HOME/Documents/Books"

if [ "$@" ]
then
    zathura "$ROFI_INFO" &> /dev/null &
else
    echo -en "\x00prompt\x1f<span fgcolor='#6c7a89'>read</span>\n"
    echo -en "\x00markup-rows\x1ftrue\n"

    find "$READ_DIR" -type f \
             \(  -name '*.pdf' \
             -or -name '*.epub' \
             -or -name '*.djvu' \
             \) -printf '%p\0%P\0' | \
    while IFS= read -r -d '' FULL_PATH; do
        IFS= read -r -d '' REL_PATH
        printf "%s\x00info\x1f%s\n" "$REL_PATH" "$FULL_PATH"
    done
fi

