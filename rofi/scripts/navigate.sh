#!/usr/bin/env bash

declare -A SITES
SITES=(
  [" github"]="https://github.com"
  [" instagram"]="https://instagram.com"
  [" google"]="https://google.com"
  [" facebook"]="https://facebook.com"
  [" reddit"]="https://reddit.com"
  [" hackernews"]="https://news.ycombinator.com"
  [" twitter"]="https://twitter.com"
  [" whatsapp"]="https://web.whatsapp.com"
)

if [ "$@" ]
then
    xdg-open "${SITES["$*"]}" &> /dev/null &
else
    echo -en "\x00prompt\x1fgo to\n"

    for SITE in "${!SITES[@]}"; do
      echo "$SITE"
    done
fi

