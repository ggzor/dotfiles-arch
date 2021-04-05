#!/usr/bin/env bash

set -euo pipefail

# These variables will be defined externally
# shellcheck disable=SC2154
xrandr --delmonitor "$name"

