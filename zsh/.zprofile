# XDG environment variables
typeset -x XDG_CACHE_HOME="$HOME/.cache"
typeset -x XDG_CONFIG_HOME="$HOME/.config"
typeset -x XDG_DATA_HOME="$HOME/.local/share"
typeset -x XDG_STATE_HOME="$HOME/.local/state"

# Default applications
export EDITOR='nvim'      # Neovim for everything
export VISUAL='nvim'      # GUI editors? No thanks
export PAGER='less'       # For viewing long outputs

# Language settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
