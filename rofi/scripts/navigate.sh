#!/usr/bin/env bash

declare -A SITES
SITES=(
  [" calendar"]="https://calendar.google.com"
  [" new meeting"]="https://meet.google.com/new"
  [" github"]="https://github.com"
  [" instagram"]="https://instagram.com"
  [" google"]="https://google.com"
  [" google docs"]="https://docs.google.com/document/u/0/"
  [" facebook"]="https://facebook.com"
  [" reddit"]="https://reddit.com"
  [" hackernews"]="https://news.ycombinator.com"
  [" twitter"]="https://twitter.com"
  [" whatsapp"]="https://web.whatsapp.com"
  [" teams"]="https://teams.microsoft.com"
  [" youtube"]="https://youtube.com"
  [" youtube music"]="https://music.youtube.com"
  [" coolors"]="https://coolors.co"
  [" figma"]="https://figma.com"
  [" outlook mail"]="https://outlook.live.com"
  [" office outlook mail"]="https://outlook.office.com/"
  [" nerd fonts cheat sheet"]="https://www.nerdfonts.com/cheat-sheet"
)

CHECK_BROWSER=$(cat <<EOF
for _, x in ipairs(mouse.screen.selected_tag:clients()) do
  if x.role == 'browser' then
    return 'browser'
  end
end
return 'nobrowser'
EOF
)

# Check if any browser is visible
EXTRA_PARAMS=""
if [[ $(awesome-client <<< "$CHECK_BROWSER") == *"nobrowser"* ]]; then
  EXTRA_PARAMS+='--new-window'
fi

if [ "$@" ]
then
  firefox $EXTRA_PARAMS "${SITES["$@"]}" &> /dev/null &
else
  echo -en "\x00prompt\x1f<span fgcolor='#6c7a89'>go to</span>\n"
  echo -en "\x00markup-rows\x1ftrue\n"

  for SITE in "${!SITES[@]}"; do
    echo "$SITE"
  done
fi

