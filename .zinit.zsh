#!/usr/bin/env bash

EXCLUDE_DIRS='
.git .fnm .cargo .vscode virtualenvs node_modules .cache __pycache__
.fzf-vim-history .rustup .vscode-insiders .zinit .local .vim .nv .config
.sdkman .npm .yay .mysql .yay .pki .gnome cache .nix .nix-profile jsm build
.nv .venv debug release .stack .stack-work .cabal dist dist-newstyle .gradle
.java .tooling .nix-defexpr mod .yarn .ipython .ghc pkg .emscripten_cache
.mozilla __MACOSX nltk_data .nvim'

EXCLUDE_STRING=$(echo -n "$EXCLUDE_DIRS" | tr ' ' '\n' | \
                   sed 's/^/--exclude /' | paste -sd' ')

# fzf
export FZF_DEFAULT_COMMAND="fd --type f $EXCLUDE_STRING --hidden --follow"
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
?:toggle-preview

# History
alt-p:previous-history
alt-n:next-history
'

FZF_BINDINGS_STRING=$(echo -n "$FZF_BINDINGS" | grep -e "^[^#]" |
                        tr "\n" "," | sed -E "s/.$//")

export FZF_DEFAULT_OPTS="
  --exit-0 --multi --info=inline
  --no-border --layout=reverse
  --height 99% --no-mouse
  --preview-window='down:70%:wrap'
  --bind='$FZF_BINDINGS_STRING'
"

# fzf-tab
zstyle ':fzf-tab:*' fzf-bindings \
  "$FZF_BINDINGS_STRING"
zstyle ':fzf-tab:*' fzf-flags --height 50%
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-flags --height 70%

fzf_preview_params() {
  TARGET_PREV_WIDTH="${1:-95}"
  SWITCH_LAYOUT_WIDTH="${2:-100}"

  PREV_WIDTH=$(( TARGET_PREV_WIDTH > COLUMNS / 2 ? COLUMNS / 2 : TARGET_WIDTH ))
  RIGHT_PREV="right:${TARGET_PREV_WIDTH}:noborder:nowrap"

  if (( COLUMNS <= SWITCH_LAYOUT_WIDTH )); then
    echo "up:61%:border:nowrap"
  else
    echo "$RIGHT_PREV"
  fi
}

# fzf utilities
# open files
ñf() {
  PREVIEW_COMMAND="
    [[ \$(file --mime {}) =~ binary ]] \
        && echo {} is a binary file \
        || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null"

  OUT=("$(
      fzf --query="$1" --preview="$PREVIEW_COMMAND" \
        --preview-window="$(fzf_preview_params)"  \
        --history="$HOME/.fzf-open-file-history")")

  # shellcheck disable=SC2128
  if [[ -n "$OUT" ]]; then
    xargs -d'\n' "${EDITOR:-nvim}" <<< "$OUT"
  fi
}

export ZD_FD_COMMAND_ARGS="--type d $EXCLUDE_STRING --hidden"
# go to folder
zd() {
  PREVIEW_COMMAND='exa --color always --tree --level=2 --icons --git-ignore {}'

  OUT="$(xargs fd <<< "$ZD_FD_COMMAND_ARGS" 2> /dev/null)"

  # zsh specific
  # shellcheck disable=SC2128
  if [[ -n "$OUT" ]]; then
    DIR="$(fzf +m \
            --preview="$PREVIEW_COMMAND" \
            --preview-window="$(fzf_preview_params 50)" \
            --history="$HOME/.fzf-zd-history" <<< "$OUT")"

    if [[ -n "$DIR" ]]; then
      cd "$DIR" || exit
    fi
  fi
}

# search regex
ñg() {
  COMMAND_FMT='rg --column --line-number --no-heading --color=always --smart-case -- %b || true'
  # shellcheck disable=SC2059
  INITIAL_COMMAND=$(printf "$COMMAND_FMT" "'$1'")
  # shellcheck disable=SC2059
  RELOAD_COMMAND="$(printf "$COMMAND_FMT" "{q}")"

  RESULT=$(
    eval "$INITIAL_COMMAND" \
      | fzf --disabled --ansi --query "$1" --bind "change:reload:$RELOAD_COMMAND" \
            --preview='fzf_rg_preview {}' \
            --delimiter ':' \
            --preview-window="$(fzf_preview_params 100 180):+{2}-/2" \
            --history="$HOME/.fzf-rg-history")

  if [[ -n "$RESULT" ]]; then
    if (( $(echo -n "$RESULT" | wc -l) > 1 )); then
      ${EDITOR:-nvim} -q <(echo -n "$RESULT")
    else
      ${EDITOR:-nvim} "$(echo "$RESULT" | cut -d: -f1-3)"
    fi
  fi
}

# forgit
export forgit_log=gitl
export forgit_diff=gitd
export forgit_add=gita
export forgit_checkout_file=gitr
export forgit_reset_head=gitu
export forgit_ignore=gitignore
export forgit_stash_show=gitstash

# vim easymotion
bindkey -M vicmd 'ñ' vi-easy-motion
export EASY_MOTION_TARGET_KEYS='fasjuirwzmkhdoe'

