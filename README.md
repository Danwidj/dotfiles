# ⚙️ dotfiles

[![CI](https://github.com/Danwidj/dotfiles/actions/workflows/ci.yaml/badge.svg)](https://github.com/Danwidj/dotfiles/actions/workflows/ci.yaml)
[![macOS CI](https://github.com/Danwidj/dotfiles/actions/workflows/macos-ci.yaml/badge.svg)](https://github.com/Danwidj/dotfiles/actions/workflows/macos-ci.yaml)
[![Lint](https://github.com/Danwidj/dotfiles/actions/workflows/lint.yaml/badge.svg)](https://github.com/Danwidj/dotfiles/actions/workflows/lint.yaml)
[![Managed by chezmoi](https://img.shields.io/badge/managed%20by-chezmoi-blue.svg?logo=chezmoi&color=4c4f69)](https://chezmoi.io/)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20OS--agnostic%20ready-333333.svg?logo=apple)](README.md)
[![Theme: Catppuccin](https://img.shields.io/badge/theme-Catppuccin%20Mocha%20%2F%20Latte-b4befe.svg)](https://github.com/catppuccin/catppuccin)

> Declarative, reproducible, and keyboard-driven developer environment managed with [chezmoi](https://www.chezmoi.io/).

---

## 📑 Table of Contents

- [Overview & Philosophy](#-overview--philosophy)
- [Why chezmoi?](#-why-chezmoi)
- [Tooling & Ecosystem](#-tooling--ecosystem)
- [Repository Structure](#-repository-structure)
- [Installation & Bootstrap](#-installation--bootstrap)
- [Post-Installation Setup](#-post-installation-setup-macOS)
- [Day-to-Day Workflow](#-day-to-day-workflow)
- [Testing & Quality Assurance](#-testing--quality-assurance)

---

## 💡 Overview & Philosophy

This repository contains my personal dotfiles and machine provisioning state. The setup is built around a few core tenets:

- **Declarative & Reproducible**: A fresh machine should reach an identical, ready-to-code state with a single bootstrap command.
- **Fast & Minimal Friction**: Relocated `$ZDOTDIR` to keep `$HOME` clean, strict plugin load ordering for instant shell startup, and zero visual lag.
- **Work vs. Personal Coexistence**: Seamless configuration parameterization (different git emails, scoped packages, and excluded configs) without maintaining separate branches.
- **Keyboard-Centric Navigation**: Consistent keybindings across AeroSpace tiling window management, tmux session multiplexing, Neovim, and terminal workflows.
- **OS-Agnostic Vision**: While these dotfiles are **currently tailored and tested daily for macOS (Apple Silicon)**, the repository is actively designed to become fully OS-agnostic (supporting Linux and containerized dev environments). The cross-platform CI suite already tests non-macOS application on Ubuntu runners.

---

## 🧰 Why chezmoi?

Managing dotfiles with plain Git symlink trees or GNU Stow quickly runs into limitations when moving across machines or dealing with sensitive configurations. This setup relies on [chezmoi](https://www.chezmoi.io/) for several distinct advantages:

1. **Declarative State Management**: chezmoi manages files, permissions, and directory structures directly, eliminating broken symlinks and ambiguous sync states.
2. **Single Static Binary**: chezmoi is a self-contained Go binary. Bootstrapping requires zero external runtimes (no Python, Ruby, or Node dependencies needed upfront).
3. **Powerful Templating (Go Templates)**: A single codebase adapts dynamically to personal vs. work machines, different git author emails, and conditional package manifests via `.chezmoi.toml.tmpl`.
4. **Security & Secret Handling**: Sensitive configuration files are managed with restricted permissions (`0600` via `private_`), encrypted state exports are supported natively, and secrets stay out of plaintext version control.
5. **Granular Lifecycle Tracking**: Automated execution scripts (`run_once_*`, `run_onchange_*`, `run_after_*`) only fire when needed—such as installing VS Code extensions only when the extension manifest changes, or running package provisioning once per machine.
6. **Seamless Git Integration & Diffing**: Built-in diffing allows full inspection of changes between your source state and live target state before applying anything to disk.

---

## ✨ Tooling & Ecosystem

| Category | Tool | Description | Config Path |
|---|---|---|---|
| **Terminal** | [Ghostty](https://ghostty.org/) | GPU-accelerated, native terminal emulator | `~/.config/ghostty/config.ghostty` |
| **Multiplexer** | [tmux](https://github.com/tmux/tmux) | Terminal multiplexer with Catppuccin Mocha/Latte themes | `~/.config/tmux/tmux.conf` |
| **Shell** | [Zsh](https://www.zsh.org/) | Relocated `$ZDOTDIR`, optimized plugin order, clean `$HOME` | `~/.config/zsh/managed.zsh` |
| **Prompt** | [Starship](https://starship.rs/) | Minimalist, fast, and customizable cross-shell prompt | `~/.config/starship.toml` |
| **History & Search** | [Atuin](https://atuin.sh/) & [fzf](https://github.com/junegunn/fzf) | SQLite-backed shell history search + interactive fuzzy completion | `~/.config/zsh/managed.zsh` |
| **Editor** | [Neovim](https://neovim.io/) | [LazyVim](https://lazyvim.github.io/)-based IDE configuration with Python/Bash LSPs, Oil, and Snacks | `~/.config/nvim/` |
| **GUI Editor** | [VS Code](https://code.visualstudio.com/) | Synchronized user settings, keybindings, and declarative extension bundle | `~/Library/Application Support/Code/User/` |
| **Window Manager** | [AeroSpace](https://github.com/nikitabobko/AeroSpace) | i3-like tiling window manager for macOS | `~/.config/aerospace/aerospace.toml` |
| **Launcher** | [Raycast](https://www.raycast.com/) | Extensible launcher & productivity platform (replaces Spotlight) | `~/.config/raycast/` |
| **Package Manager** | [Homebrew](https://brew.sh/) | Declarative `Brewfile` bundle, daily automated updates | `~/.Brewfile` |
| **Runtime Manager** | [mise](https://mise.jdx.dev/) | Polyglot runtime version manager (Node, Python, Go, etc.) | `~/.config/mise/config.toml` |
| **Agent Sessions** | [herdr](https://github.com/Danwidj/dotfiles) | Workspace agent orchestrator & session restorer | `~/.config/herdr/config.toml` |
| **VCS & Diffing** | [Git](https://git-scm.com/) & [delta](https://github.com/dandavison/delta) | Templated git identity, global ignores, and syntax-highlighted diffs | `~/.config/git/` |

---

## 📁 Repository Structure

The repository maintains a strict separation between chezmoi-managed configurations and repository tooling:

```text
Danwidj/dotfiles/
├── .github/          # CI/CD workflows (multi-platform tests, ShellCheck linting)
├── home/             # chezmoi managed source root (defined by .chezmoiroot)
├── scripts/          # Standalone CI and repository tooling scripts
├── tests/            # Automated Bats test suite
├── .chezmoiroot      # Instructs chezmoi that 'home/' is the target source root
├── AGENTS.md         # Durable project memory and instructions for AI agents
├── justfile          # Convenient command shortcuts (lint, test, apply, diff)
└── README.md         # Repository documentation
```

### High-Level Directories

- **[`.github/`](.github/workflows/README.md)**: GitHub Actions workflows validating linting (ShellCheck), Ubuntu cross-platform provisioning, and macOS end-to-end applications.
- **[`home/`](home/README.md)**: The chezmoi managed source root (configured via `.chezmoiroot`). Everything in this directory targets `$HOME` (e.g. `dot_config/` maps to `~/.config/`, `private_Library/` maps to `~/Library/`). Lifecycle scripts (`run_once_*`, `run_onchange_*`, `run_after_*`) and templates also reside here.
- **[`scripts/`](scripts/README.md)**: Helper scripts for CI runner installation, test configuration generation, and script linting. Kept outside `home/` so they are never copied to `$HOME`.
- **[`tests/`](tests/README.md)**: Integration test suite built with Bats (`bats-core`), asserting on template substitution, file generation, idempotency, and script syntax.

> ℹ️ *Each subfolder contains its own localized `README.md` detailing its specific files and purpose.*

---

## 🚀 Installation & Bootstrap

To bootstrap a new machine from scratch:

```sh
chezmoi init --apply Danwidj/dotfiles
```

### What Happens During First Apply

1. **Interactive Prompt**: Prompts for machine context (`machine_type`: `personal` or `work`) and Git email address. Responses are cached in `~/.config/chezmoi/chezmoi.toml`.
2. **`run_once_install-packages.sh`**: Installs Xcode Command Line Tools and Homebrew if missing, then provisions formulae and casks via `brew bundle --global`.
3. **`run_once_macos.sh`**: Configures curated macOS system preferences, turns off non-essential shortcuts, configures screenshot keybindings, and registers default application handlers (browser, PDF, mail, images, text, archives) using `duti`.
4. **`run_once_zshenv.sh`**: Configures `/etc/zshenv` to point `ZDOTDIR` to `~/.config/zsh`, keeping `$HOME` clean of `.zshrc` and history files.
5. **`run_onchange_install-vscode-extensions.sh`**: Declaratively installs VS Code extensions (runs on initial setup and whenever the extension manifest is updated).
6. **`run_after_install-herdr-integrations.sh`**: Verifies and updates herdr agent integrations (Claude, Pi).
7. **`run_once_zzz-manual-steps.sh`**: Prompts the user through non-scriptable macOS settings and launches Ghostty.

---

## ⚙️ Post-Installation Setup (macOS)

Certain macOS settings cannot be automated via `defaults` because of sandboxing or binary plist formats. The setup script pauses on these during initial bootstrap:

- **Finder Sidebar**:
  - Open **Finder Settings (Cmd + ,) → Sidebar**.
  - Enable: *Recents*, *Locations* (iCloud Drive, Cloud Storage, Home, External Disks), *Bin*.
  - Disable: *Shared*.
  - Set *Favourites* to Desktop only, then drag `~/workspace` into the sidebar below Desktop.
- **Finder Recents View**:
  - Press `Cmd + J` in the Recents folder and change default view to **List**.
- **Raycast Settings Import**:
  - Open **Raycast → Settings → Advanced → Import**.
  - Select the tracked snapshot file: `~/.config/raycast/raycast-export.rayconfig`.
  - Enter the export passphrase (stored securely in your password manager).
- **Ghostty**:
  - Launched automatically at the conclusion of the setup script.

---

## 🔄 Day-to-Day Workflow

chezmoi maintains two separate states:
- **Source state**: This Git repository (`~/.local/share/chezmoi/home`)
- **Target state**: The actual destination files in `$HOME` (e.g. `~/.config/starship.toml`)

### Common Operations

#### Preview Pending Changes
```sh
# Inspect differences across all managed files
chezmoi diff

# Inspect differences for a specific target
chezmoi diff ~/.config/starship.toml
```

#### Modifying Tracked Configurations
```sh
# Option A: Edit the source file directly, then apply
chezmoi edit ~/.config/starship.toml
chezmoi apply

# Option B: Edit the target file directly in $HOME, then pull into source
$EDITOR ~/.config/starship.toml
chezmoi re-add ~/.config/starship.toml
```

#### Adding or Removing Tracked Files
```sh
# Add a new file to tracking
chezmoi add ~/.config/foo.conf

# Stop tracking a file (preserves target on disk)
chezmoi forget ~/.config/foo.conf
```

### Understanding `autoCommit` and `autoPush`

`git.autoCommit` and `git.autoPush` are enabled in this setup. They trigger **only** when commands modify the **source state** (`chezmoi add`, `chezmoi re-add`, `chezmoi edit`, `chezmoi forget`).

> ⚠️ **Important**: Running `chezmoi apply` does **not** create a Git commit. `apply` syncs source &rarr; target (writing to `$HOME`). If you modify a live file on disk, you must run `chezmoi re-add <file>` to pull it into the source state and trigger the automatic commit.

### Untracked Local Overlays

To allow local installer scripts (like `nvm`, `sdkman`, or corporate tooling) to inject shell lines without polluting the tracked dotfiles repository, `~/.config/zsh/.zshrc` is an **untracked shim**. It is created by `run_once_zshrc.sh` on fresh installs and simply sources `managed.zsh`. External tools can append to `.zshrc` without causing Git merge conflicts with chezmoi.

---

## 🧪 Testing & Quality Assurance

This repository includes a comprehensive local test harness and CI pipeline:

```sh
# Run ShellCheck across all scripts
just lint

# Run the Bats test suite
just test
```

- **ShellCheck Linting**: Ensures all provisioning shell scripts adhere to strict POSIX / Bash standards and error-handling best practices.
- **Bats Test Suite**: Simulates isolated installations in temporary directories, verifies Zsh parse cleanliness, plugin loading orders, and tests dynamic Go template rendering with varied machine types.

---

## 📄 License

Personal dotfiles are licensed under the [MIT License](LICENSE). Feel free to fork, borrow, and adapt for your own setup.
