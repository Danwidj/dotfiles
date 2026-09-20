echo
# ==============================================================================
# XDG Base Directory
# ==============================================================================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# ==============================================================================
# Tool cache/config redirects (XDG-compliant, safe even if tool isn't installed)
# ==============================================================================
export HOMEBREW_BUNDLE_FILE_GLOBAL="$XDG_CONFIG_HOME/homebrew/Brewfile"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export MAVEN_OPTS="-Dmaven.repo.local=$XDG_DATA_HOME/maven/repository $MAVEN_OPTS"
export npm_config_userconfig="$XDG_CONFIG_HOME/npm/npmrc"
export npm_config_cache="$XDG_CACHE_HOME/npm"
export npm_config_logs_dir="$XDG_CACHE_HOME/npm/_logs"
export STREAMLIT_BROWSER_GATHER_USAGE_STATS=false

export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$GOPATH/pkg/mod"
export GOCACHE="$XDG_CACHE_HOME/go-build"

# ==============================================================================
# PATH
# ==============================================================================
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

# ==============================================================================
# Options
# ==============================================================================
# History
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
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
# Shell tools
# ==============================================================================
command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
command -v mise &>/dev/null && eval "$(mise activate zsh)"
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

alias vim="nvim"
alias ls='eza --icons --git --grid --all'
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
