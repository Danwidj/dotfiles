# uv Tool Configuration (`dot_config/uv/`)

This directory contains the tracked manifest for globally installed Python CLI
tools managed by [uv](https://docs.astral.sh/uv/).

- **`private_tools.txt`**: Maps to `~/.config/uv/tools.txt`. Each non-empty,
  non-comment line is installed with `uv tool install`.

The chezmoi `home/.chezmoiscripts/run_onchange_after_install-uv-tools.sh.tmpl` script installs the manifest
after it changes. Add a package name or version constraint, then run:

```sh
chezmoi apply
```
