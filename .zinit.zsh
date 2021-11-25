#!/usr/bin/env bash

EXCLUDE_DIRS='
.git go virtualenvs node_modules __pycache__ cache jsm build debug release
dist dist-newstyle mod pkg __MACOSX nltk_data wekafiles libchart fpdf16'

EXCLUDE_STRING=$(echo -n "$EXCLUDE_DIRS" | tr ' ' '\n' | \
                   sed 's/^/--exclude /' | paste -sd' ')

# fzf
export FZF_DEFAULT_COMMAND="fd --type f $EXCLUDE_STRING --follow"
FZF_BINDINGS='
# Global
esc:abort
ctrl-y:execute-silent(echo {+} | xclip)

# Navigation
ctrl-g:top
ctrl-b:half-page-up
ctrl-d:half-page-down
ctrl-k:up
ctrl-j:down
ctrl-space:jump

# Prompt
alt-h:backward-char
alt-l:forward-char
alt-b:backward-word
alt-f:forward-word
ctrl-a:beginning-of-line
ctrl-e:end-of-line
ctrl-u:unix-line-discard
ctrl-w:unix-word-rubout

# Selection
alt-c:clear-selection
alt-e:select-all
alt-t:toggle-all
tab:toggle+down
shift-tab:toggle+up

# Preview
alt-u:preview-page-up
alt-d:preview-page-down
alt-j:preview-down+preview-down+preview-down
alt-k:preview-up+preview-up+preview-up
alt-g:preview-top
alt-c:toggle-preview

# History
alt-p:previous-history
alt-n:next-history
'

FZF_BINDINGS_STRING=$(echo -n "$FZF_BINDINGS" | grep -e '^[^#]' |
                        tr '\n' ',' | sed -E 's/.$//')

FZF_COLORS="
dark
hl:$col_lime
fg+:$col_fg
bg+:$col_blue20
hl+:$col_lime
info:$col_fg
border:$col_fg10
prompt:$col_blue
pointer:$col_red
marker:$col_red
header:$col_fg50
gutter:-1
spinner:$col_blue
"
FZF_COLORS_STRING="$( echo -n "$FZF_COLORS" | grep -e '^[^#]' | paste -sd',' )"

export FZF_DEFAULT_OPTS="
  --exit-0 --multi --info=inline
  --no-border --layout=reverse
  --height 99% --no-mouse
  --preview-window='down:70%:wrap'
  --bind='$FZF_BINDINGS_STRING'
  --color='$FZF_COLORS_STRING'
"

# fzf-tab
zstyle ':fzf-tab:*' fzf-bindings \
  "$FZF_BINDINGS_STRING"
zstyle ':fzf-tab:*' fzf-flags --height 50%
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-flags --height 70%

FZF_DEFAULT_PREV_WIDTH=95
FZF_DEFAULT_SWITCH_LAYOUT_WIDTH=105

fzf_preview_params() {
  TARGET_PREV_WIDTH="${1:-$FZF_DEFAULT_PREV_WIDTH}"
  SWITCH_LAYOUT_WIDTH="${2:-$FZF_DEFAULT_SWITCH_LAYOUT_WIDTH}"
  HEADER_LINES="${3:-0}"

  MAX_WIDTH=$(( 3 * COLUMNS / 5 ))
  PREV_WIDTH=$(( TARGET_PREV_WIDTH > MAX_WIDTH ? MAX_WIDTH : TARGET_PREV_WIDTH ))
  RIGHT_PREV="right:${PREV_WIDTH}:noborder:nowrap"

  HEADER_STR=$((( $HEADER_LINES != 0 )) && printf ":~%d" "$HEADER_LINES" || printf "")

  if (( COLUMNS <= SWITCH_LAYOUT_WIDTH )); then
    echo "up:71%:border:nowrap$HEADER_STR"
  else
    echo "${RIGHT_PREV}${HEADER_STR}"
  fi
}

# fzf utilities
# open files
ñf() {
  # No function export for zsh to clean this up :(

  PREVIEW_COMMAND=$(cat <<-EOF
cat <<< $'\
     \e[2mCtr-f to go to containing folder\e[0m\
'

if [[ \$(file --mime {}) =~ binary ]]; then
  FILE_NAME=\$(exa --icons {} 2>/dev/null || echo {})
  echo "\
     \e[33;1mBinary file:\e[0m
       \$FILE_NAME\
"
else
  bat {} --style=numbers --color=always 2>/dev/null || cat {}
fi
EOF
)

  OUT=("$(
      fzf --query="$1" --preview="$PREVIEW_COMMAND" \
        --preview-window="$(
              fzf_preview_params \
                "$FZF_DEFAULT_PREV_WIDTH" \
                "$FZF_DEFAULT_SWITCH_LAYOUT_WIDTH" \
                1
        )"  \
        --expect=ctrl-f \
        --history="$HOME/.fzf-open-file-history"
      )")

  read -r KEY <<< "$OUT"
  OUT=$(tail -n +2 <<< "$OUT")
  read -r FIRST <<< "$OUT"

  # shellcheck disable=SC2128
  if [[ -n "$OUT" ]]; then
    if [[ "$KEY" == 'ctrl-f' ]]; then
      cd "$(dirname "$FIRST")"
    else
      xargs -d'\n' "${EDITOR:-nvim}" <<< "$OUT"
    fi
  fi
}

# go to folder
zd() {
  PREVIEW_COMMAND='exa --color always --tree --level=2 --icons --git-ignore {}'
  cd "$(\
    FZF_DEFAULT_COMMAND="fd --type d $EXCLUDE_STRING" \
    fzf --no-multi \
        --exit-0 \
        --preview="$PREVIEW_COMMAND" \
        --preview-window="$(fzf_preview_params 50)" \
        --history="$HOME/.fzf-zd-history")"
}

# search regex
ñg() {
  FUZZY=0

  if [[ "$1" =~ 'fuzzy' ]]; then
    FUZZY=1
    shift
  fi

  COMMAND_FMT='rg --column --line-number --no-heading --color=always --smart-case -- %b || true'
  # shellcheck disable=SC2059
  INITIAL_COMMAND=$(printf "$COMMAND_FMT" "'$1'")
  # shellcheck disable=SC2059
  RELOAD_COMMAND="$(printf "$COMMAND_FMT" "{q}")"

  ARGS=(
    --ansi
    --query "$1"
    '--preview=fzf_rg_preview {}'
    --delimiter :
    "--preview-window=$(fzf_preview_params 100 180):+{2}-/2"
    "--history=$HOME/.fzf-rg-history"
  )

  if (( $FUZZY == 0 )); then
    ARGS+=(
      --disabled
      --bind "change:reload:$RELOAD_COMMAND"
    )
  fi

  RESULT=$(eval "$INITIAL_COMMAND" | fzf "${ARGS[@]}")

  if [[ -n "$RESULT" ]]; then
    if (( $(echo -E "$RESULT" | wc -l) > 1 )); then
      ${EDITOR:-nvim} -q <(echo -E "$RESULT")
    else
      ${EDITOR:-nvim} "$(echo -E "$RESULT" | cut -d: -f1-3)"
    fi
  fi
}

alias ñG='ñg --fuzzy'

# forgit
FORGIT_ADD_FZF_OPTS=$(cat <<EOF
--bind='ctrl-f:execute(printf "%s\n" {+} \
                      | grep -v "D\]" \
                      | grep -oP "\] +\K.*" \
                      | xargs -d"\n" bash -c "$EDITOR \\\$@ \
                                                 < /dev/tty \
                                                 > /dev/tty" _)+abort'
EOF
)

export forgit_log=gitl
export forgit_diff=gitd
export forgit_add=gita
export forgit_checkout_file=gitr
export forgit_reset_head=gitu
export forgit_ignore=gitignore
export forgit_stash_show=gitstash

# vim easymotion
bindkey -M vicmd 'ñ' vi-easy-motion
export EASY_MOTION_TARGET_KEYS='aeiousdfjl'

