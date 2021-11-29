#!/usr/bin/env bash

set -euo pipefail

CMD_REGEX='^([^:]+):(.*)$'

case "$ROFI_RETV" in
    0)
        echo -en "\x00prompt\x1f<span fgcolor='#6c7a89'>command</span>\n"
        echo -en "\x00markup-rows\x1ftrue\n"

        awesome-client <<< "return require'commands'.get_list()" | {
            while read LINE; do
                if [[ "$LINE" =~ $CMD_REGEX ]]; then
                    name=${BASH_REMATCH[1]}
                    title=${BASH_REMATCH[2]}

                    echo -en "$title\x00info\x1f$name\n"
                fi
            done
        }
    ;;
    1)
        awesome-client <<< "return require'commands'.run_command('$ROFI_INFO')" \
            &>/dev/null &
    ;;
esac

