# vim:fdm=marker

# Global variables
export EDITOR=nvim

# Alias
alias vi=nvim

# Extras {{{

# Load fnm
command -v fnm> /dev/null 2>&1 && eval `fnm env`

#}}}


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/ggzor/.sdkman"
[[ -s "/home/ggzor/.sdkman/bin/sdkman-init.sh" ]] \
  && source "/home/ggzor/.sdkman/bin/sdkman-init.sh"
