# SSH Configuration (`dot_config/ssh/`)

Houses user-managed SSH host aliases and configurations for OpenSSH.

### Architecture

OpenSSH natively reads configuration from `~/.ssh/config`. To adhere to the XDG Base Directory specification while respecting OpenSSH's upstream security design (keeping keys, `known_hosts`, and `authorized_keys` in `~/.ssh/`), this repository uses a managed-and-shim split pattern:

- **`~/.ssh/config`**: Live, untracked one-line shim:
  ```ssh
  Include ~/.config/ssh/config
  ```
- **`private_config`**: Maps to `~/.config/ssh/config` (mode 0600). Contains deliberate `Host` definitions and tool-managed include paths (`colima`, `brev`).
