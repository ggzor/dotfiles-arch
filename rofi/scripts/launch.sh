#!/usr/bin/env bash

declare -A PROGRAMS
PROGRAMS=(
  [" arandr"]="arandr"
  ["﴾ nvidia settings"]="nvidia-settings"
  [" inkscape"]="inkscape"
  [" blender"]="blender"
  [" chrome"]="google-chrome-stable"
  [" firefox"]="firefox"
  [" gimp"]="gimp"
  ["漣 lxappearance"]="lxappearance"
  [" scrcpy"]="scrcpy"
  [" deluge"]="deluge-gtk"
  [" screenkey"]="screenkey"
  [" thunar"]="thunar"
  ["墳 pavucontrol"]="pavucontrol"
  [" obs studio"]="obs"
  [" obs resize"]="obs-slop"
  [" virtualbox"]="virtualbox"
  [" vscode"]="code"
  [" vscode insiders"]="code-insiders"
  [" pick color"]="xcolor -P 80 -S 4 -s"
)

if [ "$@" ]
then
    ${PROGRAMS["$*"]} &> /dev/null &
else
    echo -en "\x00prompt\x1f<span fgcolor='#6c7a89'>launch</span>\n"
    echo -en "\x00markup-rows\x1ftrue\n"

    for PROGRAM in "${!PROGRAMS[@]}"; do
      if command -v "${PROGRAMS[$PROGRAM]}" &> /dev/null; then
        echo "$PROGRAM"
      elif [[ "$PROGRAM" == *color* ]]; then
        echo "$PROGRAM"
      fi
    done
fi

