#!/usr/bin/env bash

set -euo pipefail

screen=${screen:=0}

xrandr --listmonitors | grep "$screen": | grep -oP '/\K(\d+)'
xrandr --listmonitors | grep "$screen": | grep -oP '\S+$'

