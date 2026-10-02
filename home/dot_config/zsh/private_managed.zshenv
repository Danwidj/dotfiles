# ==============================================================================
# XDG Base Directory Fallbacks
# ==============================================================================
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}/xdg_runtime}"

# Ensure runtime directory exists silently
[[ -d "$XDG_RUNTIME_DIR" ]] || mkdir -p "$XDG_RUNTIME_DIR"

# Colorize legacy ls output (fallback for tools that don't use eza)
export CLICOLOR=1
export LSCOLORS="ExFxBxDxCxegedabagacad"

# ==============================================================================
# Tool Directory Redirects (XDG-Compliant)
# ==============================================================================
# AI & Editors
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME/pi/agent"
export COPILOT_HOME="$XDG_DATA_HOME/copilot"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export VSCODE_CLI_DATA_DIR="$XDG_STATE_HOME/vscode-cli"

# Package Managers & Build Tools
export HOMEBREW_BUNDLE_FILE_GLOBAL="$XDG_CONFIG_HOME/homebrew/Brewfile"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export MPLCONFIGDIR="$XDG_CONFIG_HOME/matplotlib"
export HF_HOME="$XDG_CACHE_HOME/huggingface"
export STREAMLIT_BROWSER_GATHER_USAGE_STATS=false

# NPM
export npm_config_userconfig="$XDG_CONFIG_HOME/npm/npmrc"
export npm_config_cache="$XDG_CACHE_HOME/npm"
export npm_config_logs_dir="$XDG_CACHE_HOME/npm/_logs"

# Go
export GOPATH="$XDG_DATA_HOME/go"
export GOCACHE="$XDG_CACHE_HOME/go-build"

# Safe Maven Opts handling
if [[ -n "${MAVEN_OPTS:-}" ]]; then
  export MAVEN_OPTS="-Dmaven.repo.local=$XDG_DATA_HOME/maven/repository $MAVEN_OPTS"
else
  export MAVEN_OPTS="-Dmaven.repo.local=$XDG_DATA_HOME/maven/repository"
fi

# ==============================================================================
# PATH Deduplication & Export
# ==============================================================================
typeset -U path PATH
path=(
  $GOPATH/bin
  $HOME/.local/bin
  $path
)
