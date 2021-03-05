export EXCLUDE_DIRS="
.git .fnm .cargo .vscode virtualenvs node_modules .cache __pycache__
.fzf-vim-history .rustup .vscode-insiders .zinit .local .vim .nv .config
.sdkman .npm .yay .mysql .yay .pki .gnome cache .nix .nix-profile jsm build
.nv .venv debug release .stack .stack-work .cabal dist dist-newstyle .gradle
.java .tooling .nix-defexpr mod .yarn .ipython .ghc pkg"

export EXCLUDE_STRING=$(printf $EXCLUDE_DIRS | tr ' ' '\n' | \
                        sed 's/^/--exclude /' | paste -sd' ')

# fzf
export FZF_DEFAULT_COMMAND="fd --type f $EXCLUDE_STRING --hidden --follow"
export FZF_BINDINGS="
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
"

export FZF_BINDINGS_STRING=$(printf "$FZF_BINDINGS" | grep -e "^[^#]" |
                             tr "\n" "," | sed -E "s/.$//")

export FZF_DEFAULT_OPTS="
  --exit-0 --multi --info=inline
  --no-border --layout=reverse
  --height 99% --no-mouse
  --preview-window='right:95:wrap:noborder'
  --bind='$FZF_BINDINGS_STRING'
"

# fzf-tab
zstyle ':fzf-tab:*' fzf-bindings \
  $(printf "%s" "$FZF_BINDINGS" | grep -e '^[^#]' | xargs -d'\n' echo)
zstyle ':fzf-tab:*' fzf-flags --height 50%
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --icons --color=always $realpath'

# fzf utilities
# open files
ñf() {
  local out file key preview_command
  preview_command="
    [[ \$(file --mime {}) =~ binary ]] \
        && echo {} is a binary file \
        || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null"

  IFS=$'\n'
  out=("$(
      fzf --query="$1" --preview="$preview_command"  \
       --history="$HOME/.fzf-open-file-history")")

  if [[ -n "$out" ]]; then
    xargs -d'\n' ${EDITOR:-nvim} <<< "$out"
  fi
}

export ZD_FD_COMMAND_ARGS="--type d $EXCLUDE_STRING --hidden"
# go to folder
zd() {
  local dir preview_command
  preview_command="exa --color always --tree --level=2 --icons --git-ignore {}"

  out=$(xargs fd <<< "$ZD_FD_COMMAND_ARGS" 2> /dev/null)

  if [[ -n $out ]]; then
    dir=$(fzf +m --preview="$preview_command" \
              --history="$HOME/.fzf-zd-history" <<< "$out")

    if [[ -n $dir ]]; then
      cd "$dir"
    fi
  fi
}

# search regex
ñg() {
  command_fmt='rg --column --line-number --no-heading --color=always --smart-case %b || true'
  initial_command=$(printf $command_fmt "'$1'")
  reload_command="$(printf $command_fmt "{q}")"

  result=$(
    eval "$initial_command" \
      | fzf --disabled --ansi --query "$1" --bind "change:reload:$reload_command" \
            --preview='fzf_rg_preview {}')

  if [[ ! -z "$result" ]]; then
    if [[ $(echo -n "$result" | wc -l) > 1 ]]; then
      vim -q <(echo -n $result)
    else
      vim "$(echo "$result" | cut -d: -f1-3)"
    fi
  fi
}

# forgit
forgit_log=gitl
forgit_diff=gitd
forgit_add=gita
forgit_restore=gitr
forgit_reset_head=gitu

forgit_ignore=gitignore
forgit_stash_show=gitstash

# vim easymotion
bindkey -M vicmd ' ' vi-easy-motion
export EASY_MOTION_TARGET_KEYS='fasjuirwzmkhdoe'

