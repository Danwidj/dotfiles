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
