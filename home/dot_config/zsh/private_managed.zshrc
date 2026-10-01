# ==============================================================================
# Interactive shell configuration (environment exports live in managed.zshenv)
# ==============================================================================

# ==============================================================================
# PATH
# ==============================================================================
# Kept in managed.zshrc: macOS /etc/zprofile path_helper reorders PATH set in .zshenv
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
bindkey -v
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

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

# zsh-completions: extra completion definitions (must be on fpath before compinit)
if [[ -n "${HOMEBREW_PREFIX:-}" && -d "${HOMEBREW_PREFIX}/share/zsh-completions" ]]; then
  fpath=("${HOMEBREW_PREFIX}/share/zsh-completions" $fpath)
fi

# Cache compinit dump file under XDG_CACHE_HOME and regenerate at most once a day
zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
[[ -d "${zcompdump:h}" ]] || mkdir -p "${zcompdump:h}"
autoload -Uz compinit
if [[ -n ${zcompdump}(#qN.mh+24) || ! -f "$zcompdump" ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi
unset zcompdump

# Completion styling & matching rules (case-insensitive & fuzzy matching)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'

# zsh-vi-mode: initialise on source (not lazily) so the fzf, atuin and autopair
# bindings loaded after it are not reset
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "${HOMEBREW_PREFIX}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]]; then
  ZVM_INIT_MODE=sourcing
  source "${HOMEBREW_PREFIX}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
  bindkey '^[[A' history-search-backward
  bindkey '^[[B' history-search-forward
fi

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
  source "$XDG_CONFIG_HOME/fzf/config.zsh"
fi

# fzf-tab
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "${HOMEBREW_PREFIX}/share/fzf-tab/fzf-tab.zsh" ]]; then
  # Make Tab and Shift-Tab cycle through completion candidates
  zstyle ':fzf-tab:*' fzf-bindings 'tab:down' 'btab:up'
  # Continuous directory completion (hitting / or Tab steps into next directory)
  zstyle ':fzf-tab:*' continuous-trigger '/'
  # Preview directories with eza when using cd
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
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

# zsh-autopair: auto-close brackets and quotes
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "${HOMEBREW_PREFIX}/share/zsh-autopair/autopair.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-autopair/autopair.zsh"
fi


# ==============================================================================
# Syntax highlighting (must be sourced last)
# ==============================================================================
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
