#!/bin/bash
# Set ZDOTDIR so zsh picks up ~/.config/zsh/.zshrc
if ! grep -q "ZDOTDIR" /etc/zshenv 2>/dev/null; then
    echo 'export ZDOTDIR=$HOME/.config/zsh' | sudo tee -a /etc/zshenv
fi
