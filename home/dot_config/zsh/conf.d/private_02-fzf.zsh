# ==============================================================================
# fzf & fzf-tab Configuration
# ==============================================================================

# fzf shell integration
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
  [[ -f "$XDG_CONFIG_HOME/fzf/config.zsh" ]] && source "$XDG_CONFIG_HOME/fzf/config.zsh"
fi

# fzf-tab layout and previews
zstyle ':fzf-tab:*' fzf-flags --height=100% --layout=reverse
zstyle ':fzf-tab:*' fzf-bindings 'tab:down' 'btab:up'
zstyle ':fzf-tab:*' continuous-trigger '/'

# Preserve Zsh completion ordering (directories first) on the left list
zstyle ':fzf-tab:*' sort false

# Directory previews using eza
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons=always --git --grid --all --group-directories-first --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --icons=always --git --grid --all --group-directories-first --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza --icons=always --git --grid --all --group-directories-first --color=always $realpath'

# File previews using bat (with ANSI theme to respect terminal light/dark palette)
zstyle ':fzf-tab:complete:vim:*' fzf-preview 'bat --theme=ansi --style=numbers --color=always --line-range :500 $realpath'
zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'bat --theme=ansi --style=numbers --color=always --line-range :500 $realpath'
zstyle ':fzf-tab:complete:cat:*' fzf-preview 'bat --theme=ansi --style=numbers --color=always --line-range :500 $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --theme=ansi --style=numbers --color=always --line-range :500 $realpath'
