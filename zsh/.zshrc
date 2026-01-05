source "${HOME}/.zprofile"

source "${HOME}/.local/share/scripts/ensure.zsh"

# Initialize zinit with automatic installation
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing zinit...%f"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit snippet OMZL::git.zsh              # Git aliases and functions
zinit snippet OMZL::history.zsh          # Better history management
zinit snippet OMZL::key-bindings.zsh     # Standard key bindings
zinit snippet OMZL::theme-and-appearance.zsh  # Terminal colors
zinit snippet OMZL::completion.zsh       # Completion tweaks
zinit snippet OMZL::directories.zsh      # Directory navigation helpers

HISTFILE="${HOME}/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

# Smart history options
setopt EXTENDED_HISTORY          # Save timestamp and duration
setopt SHARE_HISTORY             # Share between sessions
setopt HIST_IGNORE_ALL_DUPS      # No duplicates
setopt HIST_REDUCE_BLANKS        # Clean up commands

# Configure zsh-vi-mode before loading (keep block cursor always)
function zvm_config() {
  ZVM_CURSOR_STYLE_ENABLED=false
}
zinit light jeffreytse/zsh-vi-mode

# Fast syntax highlighting and suggestions
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions



autoload -Uz compinit && compinit

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose yes
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':fzf-tab:complete:*' fzf-preview 'bat --color=always --line-range :50 {}'

source <(jj util completion zsh)

# All in one extraction
function extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.tar.xz)    tar xJf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Fuzzy find history
function fzf_history_search() {
  local selected
  selected=$(fc -rl 1 | awk '{$1=""; print substr($0,2)}' | 
    fzf --height 40% --layout=reverse --border --color=border:blue \
        --preview='echo {}' --preview-window=down:3:wrap)
  LBUFFER=$selected
  zle reset-prompt
}
zle -N fzf_history_search
bindkey '^R' fzf_history_search

# Jump to directory
function fcd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git . "${1:-.}" | 
    fzf --preview 'eza --tree --level=1 --color=always {}' --preview-window=right:50%) &&
    cd "$dir"
}

function update() {
    sudo snapper -c root create --command "zsh $HOME/.local/share/scripts/update.zsh"
}
