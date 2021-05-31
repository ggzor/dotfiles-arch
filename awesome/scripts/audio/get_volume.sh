#!/usr/bin/env bash

set -euo pipefail

DEFAULT_SINK="$(pacmd stat | grep 'Default sink name' | cut -d' ' -f 4)"

VOLUME="$(pacmd list-sinks | awk -v sink="$DEFAULT_SINK" '
$2 == sink { number = NR }
NR > number && $1 ~ "volume" { print $5; exit }
')"

printf '%d' "${VOLUME::-1}"

