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
alias ls='eza --icons --git'
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

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"

  _update_fzf_theme() {
    local appearance
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
      appearance="dark"
    else
      appearance="light"
    fi

    if [[ "$appearance" == "${_fzf_theme_current:-}" ]]; then
      return
    fi
    _fzf_theme_current="$appearance"

    if [[ "$appearance" == "dark" ]]; then
      # Catppuccin Mocha (dark)
      export FZF_DEFAULT_OPTS="--style=full \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4 \
--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    else
      # Catppuccin Latte (light)
      export FZF_DEFAULT_OPTS="--style=full \
--color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
--color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
--color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
--color=selected-bg:#BCC0CC \
--color=border:#9CA0B0,label:#4C4F69 \
--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    fi
  }
  _update_fzf_theme

  if (( $+functions[__fzf_defaults] )); then
    functions[_fzf_orig_defaults]=$functions[__fzf_defaults]
    __fzf_defaults() {
      _update_fzf_theme
      _fzf_orig_defaults "$@"
    }
  fi

  fzf() {
    _update_fzf_theme
    command fzf "$@"
  }

  autoload -Uz add-zsh-hook 2>/dev/null && add-zsh-hook precmd _update_fzf_theme

  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
fi

# fzf-tab
if [[ -f "$(brew --prefix)/share/fzf-tab/fzf-tab.zsh" ]]; then
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
# Local/machine-specific overrides (not tracked by chezmoi)
# ==============================================================================
[[ -f "$ZDOTDIR/custom.zsh" ]] && source "$ZDOTDIR/custom.zsh"

# ==============================================================================
# Syntax highlighting (must be sourced last)
# ==============================================================================
if [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
