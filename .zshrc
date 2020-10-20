# vim:fdm=marker

# Global variables
export USE_PLUGINS=true # Load plugins or not
export EDITOR=nvim

# Required by some plugins
setopt promptsubst

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

# Powerlevel10k prompt
zinit ice depth=1
zinit light romkatv/powerlevel10k

fi
# }}}

# Alias {{{

alias vi=nvim

# }}}

# Extras {{{

# Load fnm
command -v fnm> /dev/null 2>&1 && eval `fnm env`

#}}}

# sdkman
export SDKMAN_DIR="/home/ggzor/.sdkman"
[[ -s "/home/ggzor/.sdkman/bin/sdkman-init.sh" ]] \
  && source "/home/ggzor/.sdkman/bin/sdkman-init.sh"

# Powerlevel10k prompt configuration
# OS name prompt segment
function prompt_os_name() {
  p10k segment -f white -t archlinux
}
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

