# ==============================================================================
# Atuin Configuration
# ==============================================================================
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
  bindkey -M vicmd '^r' atuin-search
  zvm_after_init_commands+=('eval "$(atuin init zsh --disable-up-arrow)" && bindkey -M vicmd "^r" atuin-search')
fi
