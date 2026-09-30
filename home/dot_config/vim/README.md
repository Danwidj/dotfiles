# Vim Configuration (`dot_config/vim/`)

Houses the Vim configuration loaded via Vim's native XDG support.

### Background

Starting in Vim 9.1 (patch 9.1.0327), Vim natively looks for its configuration file at `$XDG_CONFIG_HOME/vim/vimrc` on Unix systems when `~/.vimrc` and `~/.vim/vimrc` are absent. This allows full XDG Base Directory specification compliance without defining `$VIMINIT` in the shell environment (which would interfere with Neovim and break LazyVim initialization).

### Files

- **`private_vimrc`**: Maps to `~/.config/vim/vimrc`. Relocates the `viminfo` file to `$XDG_STATE_HOME/vim/viminfo` (ensuring the target directory exists) so `$HOME` remains clean of `~/.viminfo`.
