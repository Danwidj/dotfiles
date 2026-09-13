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
export STREAMLIT_BROWSER_GATHER_USAGE_STATS=false

export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$GOPATH/pkg/mod"
export GOCACHE="$XDG_CACHE_HOME/go-build"

# ==============================================================================
# Shell tools
# ==============================================================================
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
alias vim="nvim"
alias ls='eza --icons --git'
alias cd='z'
alias top='btop'
alias find='fd'
alias cat='bat'
alias grep='rg'

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
  export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
fi

# ==============================================================================
# Local/machine-specific overrides (not tracked by chezmoi)
# ==============================================================================
[[ -f "$ZDOTDIR/custom.zsh" ]] && source "$ZDOTDIR/custom.zsh"
