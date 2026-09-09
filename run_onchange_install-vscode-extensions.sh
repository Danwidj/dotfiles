#!/bin/sh
# Installs VSCode extensions. Re-runs whenever this file changes.

# Homebrew's visual-studio-code cask doesn't symlink `code` onto PATH —
# that only happens if VSCode itself runs "Shell Command: Install 'code' command in PATH".
# Fall back to the app bundle's own CLI binary if `code` isn't found yet.
if command -v code >/dev/null 2>&1; then
    CODE_BIN="code"
elif [ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
    CODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
else
    echo "VSCode 'code' CLI not found (checked PATH and /Applications). Skipping extension install."
    exit 0
fi

extensions="
aaron-bond.better-comments
oderwat.indent-rainbow
yzhang.markdown-all-in-one
shd101wyy.markdown-preview-enhanced
bierner.markdown-mermaid
pkief.material-icon-theme
esbenp.prettier-vscode
mechatroner.rainbow-csv
redhat.vscode-yaml
typescriptteam.native-preview
"

for ext in $extensions; do
    "$CODE_BIN" --install-extension "$ext" --force
done

# Optional machine-local overlay for extensions not tracked in the public
# dotfiles repo (mirrors the ~/.config/zsh/custom.zsh pattern). Untracked and
# ignored by chezmoi (see .chezmoiignore), one extension ID per line, blank
# lines and #-comments allowed. May not exist yet — skip silently if so.
#
# NOTE: this script is run_onchange, which re-triggers based on hashing this
# SOURCE file's content. extensions.local is untracked/unhashed by chezmoi,
# so editing it alone will NOT re-trigger this script via `chezmoi apply`.
# Re-run this script manually after adding entries to extensions.local.
LOCAL_EXTENSIONS="$HOME/.config/vscode/extensions.local"
if [ -f "$LOCAL_EXTENSIONS" ]; then
    while IFS= read -r ext || [ -n "$ext" ]; do
        case "$ext" in
            ''|'#'*) continue ;;
        esac
        "$CODE_BIN" --install-extension "$ext" --force
    done < "$LOCAL_EXTENSIONS"
fi
