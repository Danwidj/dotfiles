# Homebrew Bundle Configuration (`dot_config/homebrew/`)

Houses the declarative package specification for [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle).

### Files

- **`private_Brewfile.tmpl`**: Maps to `~/.Brewfile`. A parameterized template listing CLI formulae (e.g. `zsh`, `tmux`, `fzf`, `starship`, `atuin`, `ripgrep`, `fd`, `bat`, `delta`), GUI casks (e.g. `ghostty`, `raycast`, `aerospace`, `visual-studio-code`), and fonts. Conditionally includes work-specific or personal-specific casks based on `machine_type`.
