# ==============================================================================
# Interactive shell configuration (environment exports live in managed.zshenv)
# ==============================================================================

# ==============================================================================
# PATH & FPATH
# ==============================================================================
# Deduplicate arrays to prevent redundant paths on shell reloads
typeset -U path PATH
typeset -U fpath FPATH
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

# ==============================================================================
# Options
# ==============================================================================
# History
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
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
# Shell tools
# ==============================================================================
command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v mise &>/dev/null && eval "$(mise activate zsh)"
command -v zoxide &>/dev/null && eval "$(zoxide init zsh --cmd cd)"

alias vim="nvim"
alias ls='eza --icons=always --git --grid --all --group-directories-first'
alias top='btop'
alias cat='bat'

# ==============================================================================
# Completion & Plugins
# ==============================================================================
# Cache Homebrew prefix to avoid repeated slow $(brew --prefix) subshells
if [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
  if [[ -d "/opt/homebrew" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
  elif command -v brew >/dev/null 2>&1; then
    HOMEBREW_PREFIX="$(brew --prefix)"
  fi
fi

# zsh-completions
if [[ -n "${HOMEBREW_PREFIX:-}" && -d "${HOMEBREW_PREFIX}/share/zsh-completions" ]]; then
  fpath=("${HOMEBREW_PREFIX}/share/zsh-completions" $fpath)
fi

# compinit caching
zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
[[ -d "${zcompdump:h}" ]] || mkdir -p "${zcompdump:h}"
autoload -Uz compinit
if [[ -n ${zcompdump}(#qN.mh+24) || ! -f "$zcompdump" ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi
unset zcompdump

# Define default LS_COLORS for macOS so fzf-tab can colorize the left menu
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;43:tw=30;42:ow=34;42"

# Completion styling & matching rules
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'

# Group completion candidates so directories sort before files
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*' group-order aliases builtins functions commands
zstyle ':completion:*:*:*:*:*' group-order directories files

# zsh-vi-mode (Must load before custom bindings and fzf)
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "${HOMEBREW_PREFIX}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]]; then
  ZVM_INIT_MODE=sourcing
  source "${HOMEBREW_PREFIX}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
fi

# Keybindings (Applied after ZVM to ensure persistence)
bindkey -v
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
  source "$XDG_CONFIG_HOME/fzf/config.zsh"
fi

# fzf-tab
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "${HOMEBREW_PREFIX}/share/fzf-tab/fzf-tab.zsh" ]]; then
  zstyle ':fzf-tab:*' fzf-bindings 'tab:down' 'btab:up'
  zstyle ':fzf-tab:*' continuous-trigger '/'

  # Preserve Zsh completion ordering (directories first) on the left list
  zstyle ':fzf-tab:*' sort false

  # Clean directory previews using eza for directory-based commands
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons=always --git --grid --all --group-directories-first --color=always $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --icons=always --git --grid --all --group-directories-first --color=always $realpath'

  source "${HOMEBREW_PREFIX}/share/fzf-tab/fzf-tab.zsh"
fi



# zsh-autosuggestions
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# atuin
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# zsh-autopair
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "${HOMEBREW_PREFIX}/share/zsh-autopair/autopair.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-autopair/autopair.zsh"
fi

# ==============================================================================
# Syntax highlighting (must be sourced last)
# ==============================================================================
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
