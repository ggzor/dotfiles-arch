#!/usr/bin/env bash

declare -A PROGRAMS
PROGRAMS=(
  [" arandr"]="arandr"
  ["﴾ nvidia settings"]="nvidia-settings"
  [" inkscape"]="inkscape"
  [" blender"]="blender"
  [" chrome"]="google-chrome-stable"
  [" firefox"]="firefox"
  [" screenkey"]="screenkey"
  [" thunar"]="thunar"
  ["墳 pavucontrol"]="pavucontrol"
  [" obs studio"]="obs"
  [" obs resize"]="obs-slop"
  [" virtualbox"]="virtualbox"
  [" vscode"]="code"
  [" vscode insiders"]="code-insiders"
)

if [ "$@" ]
then
    "${PROGRAMS["$*"]}" &> /dev/null &
else
    echo -en "\x00prompt\x1f<span fgcolor='#6c7a89'>launch</span>\n"
    echo -en "\x00markup-rows\x1ftrue\n"

    for PROGRAM in "${!PROGRAMS[@]}"; do
        command -v "${PROGRAMS[$PROGRAM]}" &> /dev/null && \
            echo "$PROGRAM"
    done
fi

