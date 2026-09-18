#!/bin/bash
# Set ZDOTDIR so zsh picks up ~/.config/zsh/.zshrc
if ! grep -q "ZDOTDIR" /etc/zshenv 2>/dev/null; then
    # shellcheck disable=SC2016  # literal string with variable ref intended for file
    echo 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee -a /etc/zshenv
fi
