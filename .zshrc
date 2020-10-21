# vim:fdm=marker

# Global variables
export USE_PLUGINS=true # Load plugins or not
export {EDITOR,VISUAL}=nvim

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

# better vim keybindings
# TODO: Check if doesn't break anything important
# Remove all keybindings starting with Esc Esc to allow faster
# switching to normal mode
VIM_MODE_ESC_PREFIXED_WANTED=''
zinit wait lucid for \
  atload"bindkey -rpM viins '^[^['" \
  @softmoth/zsh-vim-mode

zinit wait lucid for \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    @ael-code/zsh-colored-man-pages \
    @le0me55i/zsh-extract

# fzf integration
zinit silent wait light-mode for \
  multisrc:'shell/*.zsh' @junegunn/fzf \
  @Aloxaf/fzf-tab
# get fzf ripgrep preview script
zplugin ice as"program" mv"bin/preview.sh -> fzf_rg_preview" \
            pick"fzf_rg_preview" atpull"!git reset --hard"
zinit light junegunn/fzf.vim

# fzf git complement
zinit wait lucid for \
  wfxr/forgit

# vim easymotion and command highlighting
zinit lucid for \
    @IngoHeimbach/zsh-easy-motion \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting
fi

## Completions
zinit wait lucid for \
  blockf \
    zsh-users/zsh-completions

zinit wait lucid as"completion" for \
  OMZP::docker-compose \
  OMZP::docker/_docker \
  OMZP::cargo/_cargo \
  OMZP::nvm/_nvm

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

# }}}

# Keybindings {{{
# Missing bindings for underscore
bindkey -M vicmd '_' beginning-of-line
bindkey -M visual '_' beginning-of-line
bindkey -M viopp '_' beginning-of-line

bindkey -M vicmd 'ñi' add-surround
bindkey -M vicmd 'ñc' change-surround
bindkey -M vicmd 'ñd' delete-surround

bindkey "^[[H"    beginning-of-line
bindkey "^[[F"    end-of-line
bindkey "^[[3~"   delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[l"     vi-forward-char
# }}}

# Bottom setup {{{

# fnm
command -v fnm> /dev/null 2>&1 && eval `fnm env`

# sdkman
[[ -s "/home/ggzor/.sdkman/bin/sdkman-init.sh" ]] \
  && source "/home/ggzor/.sdkman/bin/sdkman-init.sh"

# Powerlevel10k prompt configuration
# OS name prompt segment
function prompt_os_name() {
  p10k segment -f white -t archlinux
}
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# }}}
