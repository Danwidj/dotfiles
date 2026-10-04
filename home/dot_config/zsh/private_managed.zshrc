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

# ==============================================================================
# Modular configuration
# ==============================================================================
for file in "$ZDOTDIR"/conf.d/*.zsh; do
  [[ -r "$file" ]] && source "$file"
done
