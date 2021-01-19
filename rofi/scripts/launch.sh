#!/usr/bin/env bash

declare -A PROGRAMS
PROGRAMS=(
  [" arandr"]="arandr"
  [" chrome"]="google-chrome-stable"
  ["﴾ nvidia settings"]="nvidia-settings"
  [" inkscape"]="inkscape"
  [" blender"]="blender"
  [" vscode"]="code"
  [" vscode insiders"]="code-insiders"
)

if [ "$@" ]
then
    "${PROGRAMS["$*"]}" &> /dev/null &
else
    echo -en "\x00prompt\x1flaunch\n"

    for PROGRAM in "${!PROGRAMS[@]}"; do
        command -v "${PROGRAMS[$PROGRAM]}" &> /dev/null && \
            echo "$PROGRAM"
    done
fi

