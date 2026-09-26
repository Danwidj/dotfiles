echo
# ==============================================================================
# Interactive shell configuration (environment exports live in managed.zshenv)
# ==============================================================================

# ==============================================================================
# PATH
# ==============================================================================
# Kept in managed.zsh: macOS /etc/zprofile path_helper reorders PATH set in .zshenv
# Deduplicate PATH entries (drops duplicates added by macOS path_helper via /etc/paths.d)
typeset -U path PATH
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

# ==============================================================================
# Options
# ==============================================================================
# History
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000
export HISTDUP=erase
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Globbing
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt NUMERIC_GLOB_SORT

# Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Correction
setopt CORRECT
setopt NO_CLOBBER

# ==============================================================================
# Key bindings
# ==============================================================================
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ==============================================================================
# Shell tools
# ==============================================================================
command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
command -v mise &>/dev/null && eval "$(mise activate zsh)"
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

alias vim="nvim"
alias ls='eza --icons=always --git --grid --all --group-directories-first'
alias cd='z'
alias top='btop'
alias find='fd'
alias cat='bat'
alias grep='rg'

# ==============================================================================
# Completion & Plugins
# ==============================================================================
autoload -Uz compinit
compinit

# Completion styling & matching rules (case-insensitive & fuzzy matching)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
  source "$XDG_CONFIG_HOME/fzf/config.zsh"
fi

# fzf-tab
if [[ -f "$(brew --prefix)/share/fzf-tab/fzf-tab.zsh" ]]; then
  # Make Tab and Shift-Tab cycle through completion candidates
  zstyle ':fzf-tab:*' fzf-bindings 'tab:down' 'btab:up'
  # Continuous directory completion (hitting / or Tab steps into next directory)
  zstyle ':fzf-tab:*' continuous-trigger '/'
  # Preview directories with eza when using cd
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
  source "$(brew --prefix)/share/fzf-tab/fzf-tab.zsh"
fi

# zsh-autosuggestions
if [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# atuin
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi


# ==============================================================================
# Syntax highlighting (must be sourced last)
# ==============================================================================
if [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
