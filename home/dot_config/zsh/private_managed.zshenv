# ==============================================================================
# XDG Base Directory (core vars set in .zshenv for all zsh invocations)
# ==============================================================================
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME/pi/agent"

# ==============================================================================
# Tool cache/config redirects (XDG-compliant, safe even if tool isn't installed)
# ==============================================================================
export HOMEBREW_BUNDLE_FILE_GLOBAL="$XDG_CONFIG_HOME/homebrew/Brewfile"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export MAVEN_OPTS="-Dmaven.repo.local=$XDG_DATA_HOME/maven/repository $MAVEN_OPTS"
export npm_config_userconfig="$XDG_CONFIG_HOME/npm/npmrc"
export npm_config_cache="$XDG_CACHE_HOME/npm"
export npm_config_logs_dir="$XDG_CACHE_HOME/npm/_logs"
export HF_HOME="$XDG_CACHE_HOME/huggingface"
export MPLCONFIGDIR="$XDG_CONFIG_HOME/matplotlib"
export STREAMLIT_BROWSER_GATHER_USAGE_STATS=false
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export COPILOT_HOME="$XDG_DATA_HOME/copilot"

export GOPATH="$XDG_DATA_HOME/go"
export GOCACHE="$XDG_CACHE_HOME/go-build"

# no-mistakes home / config directory
export NM_HOME="$XDG_CONFIG_HOME/no-mistakes"

# lavish-axi state directory
export LAVISH_AXI_STATE_DIR="$XDG_CONFIG_HOME/lavish-axi"
