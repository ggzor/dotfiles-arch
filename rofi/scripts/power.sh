#!/usr/bin/env bash

if [ "$*" = "quit" ]
then
    exit 0
fi

if [ "$@" ]
then
    case "$*" in
        *shutdown)
            poweroff
            ;;
        *reboot)
            reboot
            ;;
        *suspend)
            systemctl suspend
            ;;
        *hibernate)
            systemctl hibernate
            ;;
    esac
else
    echo -en "\x00prompt\x1fpower\n"
    echo -en "\0markup-rows\x1ftrue\n"
    echo -en "\0message\x1fSpecial <b>bold</b>message\n"

    echo " shutdown"
    echo ﰇ" reboot"
    echo " suspend"
    echo ﰕ" hibernate"
fi
