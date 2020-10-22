export EXCLUDE_DIRS='.git virtualenvs node_modules .cache __pycache__'
export EXCLUDE_STRING=$(printf $EXCLUDE_DIRS | tr ' ' '\n' | \
                        sed 's/^/--exclude /' | paste -sd' ')

# fzf
export FZF_DEFAULT_COMMAND="fd --type f $EXCLUDE_STRING --hidden --follow"
# FIXME: Choose what is better by default: abort on escape or just cancel
export FZF_BINDINGS="
# Global
esc:abort
ctrl-y:execute-silent(echo {+} | xclip)

# Navigation
ctrl-g:top
ctrl-u:half-page-up
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
alt-bs:unix-line-discard
ctrl-w:unix-word-rubout

# Selection
alt-c:clear-selection
alt-e:select-all
alt-t:toggle-all

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
  --exit-0
  --multi --info=inline
   --height 99% --layout=reverse  --no-mouse
  --bind='$FZF_BINDINGS_STRING'
"

# fzf-tab

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

