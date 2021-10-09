# vim:fdm=marker

# Global variables
export USE_PLUGINS=true # Load plugins or not
export {EDITOR,VISUAL}=nvim
export QT_QPA_PLATFORMTHEME=gtk2
export MANPAGER='nvim +Man!'
export BAT_THEME='NightOwl'

# Load theme colors
source "$HOME/.theme.zsh"

# Required by some plugins
setopt promptsubst

# General configuration {{{

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history
setopt no_hist_allow_clobber
setopt no_hist_beep

# }}}

# zinit installation {{{
if [ "$USE_PLUGINS" = true ]; then
  SKIP_COMPILE=false
  if [[ ! -d "$HOME/.zinit" ]]; then
    echo "Installing zinit..."
    mkdir "$HOME/.zinit"
    git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin"

    # Create lock to compile zinit next time
    touch "$HOME/.zinit-lock"
    SKIP_COMPILE=true
  fi

  source "$HOME/.zinit/bin/zinit.zsh"

  # Compile zinit if not compiled yet
  if [[ "$SKIP_COMPILE" == false ]] \
  && [[ -f "$HOME/.zinit-lock" ]]; then
    echo "Compiling zinit..."
    zinit self-update
    rm "$HOME/.zinit-lock"
  fi
fi
# }}}
# zinit plugins {{{
if [[ "$USE_PLUGINS" = true ]]; then

if [[ -f "$HOME/.zinit.zsh" ]]; then
  source "$HOME/.zinit.zsh"
fi

# Powerlevel10k prompt
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Utilities to defer execution of slow scripts
zinit light romkatv/zsh-defer

# command highlighting
zinit wait'1' silent for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# better vim keybindings
VIM_MODE_ESC_PREFIXED_WANTED=''
zinit wait lucid for \
  atload"bindkey -rpM viins '^[^['" \
  @softmoth/zsh-vim-mode

# fzf integration
zinit wait lucid light-mode for \
  @Aloxaf/fzf-tab \
  multisrc:'shell/*.zsh' @junegunn/fzf

# get fzf ripgrep preview script
zinit wait lucid for \
  as'program' mv'bin/preview.sh -> fzf_rg_preview' \
  pick'fzf_rg_preview' \
    junegunn/fzf.vim

# fzf git complement
zinit wait'1' lucid for \
  @IngoHeimbach/zsh-easy-motion \
  wfxr/forgit

zinit wait lucid for \
    @le0me55i/zsh-extract

## Completions
zinit lucid for \
  blockf \
    zsh-users/zsh-completions

zinit wait lucid as"completion" for \
  OMZP::docker-compose \
  OMZP::docker/_docker \
  OMZP::cargo \
  @spwhitt/nix-zsh-completions

fi
# }}}

# Functions {{{

# Set keyboard to latam and remap escape
kb_lat() {
  setxkbmap -option caps:swapescape -layout latam
}

# Set keyboard to esp
kb_esp() {
  setxkbmap -option -layout es
}

# }}}

# Alias {{{

alias v=nvim
alias vi=nvim
alias xclip="xclip -selection c"
alias xo="xdg-open"
alias ls="ls --color=auto"

alias l="exa --icons"
alias ll="exa -l --icons"
alias la="exa -la --icons"
alias lt="exa --tree --level=2 --icons"

alias gitc="git commit -m"
alias gits="git status"

alias z=zathura
alias idris2="rlwrap idris2"

# Fix white flash before startup
emacs() {
  /usr/bin/env emacsclient -cnqua '' "$@"
}

# }}}

# Keybindings {{{
# Missing bindings for underscore
bindkey -M vicmd '_' beginning-of-line
bindkey -M visual '_' beginning-of-line
bindkey -M viopp '_' beginning-of-line

bindkey "^[[H"    beginning-of-line
bindkey "^[[F"    end-of-line
bindkey "^[[3~"   delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# }}}

# Cursor style {{{

function _set_cursor() {
  echo -ne $1
}

function _set_block_cursor() { _set_cursor '\e[2 q' }
function _set_line_cursor() { _set_cursor '\e[6 q' }

function zle-keymap-select {
  if [[ ${KEYMAP} = vicmd || $1 = 'block' ]]; then
    _set_block_cursor
  else
    _set_line_cursor
  fi
}

zle -N zle-keymap-select
precmd_functions+=(_set_line_cursor)
function zle-line-init() { zle -K viins; _set_line_cursor }
function zle-line-finish() { _set_block_cursor }
zle -N zle-line-finish

# }}}

# Path {{{

path+=( $HOME/.local/bin )
path+=( /usr/lib/emscripten )
path+=( $HOME/dotfiles/scripts )

# }}}

# Bottom setup {{{

# Disable annoying Ctrl-S
if [[ -t 0 && $- = *i* ]]; then
  stty -ixon
fi

# fnm
command -v fnm> /dev/null 2>&1 && \
  zsh-defer -c 'eval `fnm env`'

# sdkman
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && \
  zsh-defer -t1 source "$HOME/.sdkman/bin/sdkman-init.sh"

# nix
[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && \
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"

# direnv
direnv version &>/dev/null && eval "$(direnv hook zsh)"

# Load aws-cli completion
function load_aws_cli() {
  if type aws_completer &> /dev/null; then
    autoload bashcompinit && bashcompinit
    autoload -Uz compinit && compinit
    compinit
    complete -C '/usr/local/bin/aws_completer' aws
  fi
}

zsh-defer load_aws_cli

type keychain &> /dev/null \
  && eval "$(keychain --eval --quiet)"

# Powerlevel10k prompt configuration
# OS name prompt segment
function prompt_os_name() {
  p10k segment -f white -t archlinux
}
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# }}}
