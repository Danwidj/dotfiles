# ==============================================================================
# Zinit Bootstrap & Plugins
# ==============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zinit cache and dump paths under XDG dirs
zstyle ':zinit:config' zcompdump-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

# 1. zsh-completions (Must be added to fpath before compinit)
zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# 2. compinit caching
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

# 3. zsh-vi-mode (Must load before custom bindings and fzf)
ZVM_INIT_MODE=sourcing
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# Keybindings (Applied after ZVM to ensure persistence)
bindkey -v
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# 4. fzf-tab (Must load after compinit, synchronously)
zinit light Aloxaf/fzf-tab

# Replay compdefs recorded before/during compinit
zinit cdreplay -q

# 5. zsh-autopair
zinit light hlissner/zsh-autopair

# 6. Turbo-loaded plugins: autosuggestions and syntax-highlighting (syntax last)
zinit wait lucid for \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting
