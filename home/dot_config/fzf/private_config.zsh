# fzf appearance and interactive picker behavior
if [[ "$commands[fzf]" ]]; then
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
