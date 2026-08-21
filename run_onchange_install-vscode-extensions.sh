#!/bin/sh
# Installs VSCode extensions. Re-runs whenever this file changes.

extensions="
aaron-bond.better-comments
oderwat.indent-rainbow
yzhang.markdown-all-in-one
shd101wyy.markdown-preview-enhanced
bierner.markdown-mermaid
pkief.material-icon-theme
esbenp.prettier-vscode
"

for ext in $extensions; do
    code --install-extension "$ext" --force
done
