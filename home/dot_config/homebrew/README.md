# Homebrew Bundle Configuration (`dot_config/homebrew/`)

Houses the declarative package specification for [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle).

### Files

- **`private_Brewfile.tmpl`**: Maps to `~/.config/homebrew/Brewfile`. A parameterized template listing CLI formulae (e.g. `zsh`, `tmux`, `fzf`, `starship`, `atuin`, `ripgrep`, `fd`, `bat`, `delta`), GUI casks (e.g. `ghostty`, `raycast`, `aerospace`, `visual-studio-code`), and fonts. Conditionally includes work-specific or personal-specific casks based on `machine_type`.
  Provisioned via `home/.chezmoiscripts/run_onchange_after_brew-bundle.sh.tmpl` (`brew bundle --global`), which re-runs whenever the rendered `Brewfile` changes. Homebrew itself and Xcode Command Line Tools are bootstrapped beforehand by `home/.chezmoiscripts/run_once_before_install-homebrew.sh`.
- **`brew.env`**: Maps to `~/.config/homebrew/brew.env`, Homebrew's user-level settings file (read for every `brew` run, including scripts; no shell expansion). Sets `HOMEBREW_NO_ENV_HINTS` (hide settings tips) and `HOMEBREW_NO_ANALYTICS` (no usage data sent to Homebrew).
