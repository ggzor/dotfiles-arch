#!/usr/bin/env bash

declare -A SITES
SITES=(
  [" calendar"]="https://calendar.google.com"
  [" github"]="https://github.com"
  [" instagram"]="https://instagram.com"
  [" google"]="https://google.com"
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
)

if [ "$@" ]
then
    xdg-open "${SITES["$*"]}" &> /dev/null &
else
    echo -en "\x00prompt\x1f<span fgcolor='#6c7a89'>go to</span>\n"
    echo -en "\x00markup-rows\x1ftrue\n"

    for SITE in "${!SITES[@]}"; do
      echo "$SITE"
    done
fi

