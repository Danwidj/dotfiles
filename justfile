set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

test:
    bats tests/files/*.bats

lint:
    scripts/lint.sh

check: lint test

init:
    chezmoi init Danwidj/dotfiles

apply:
    chezmoi apply

diff:
    chezmoi diff
