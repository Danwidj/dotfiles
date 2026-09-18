.PHONY: test lint init apply diff

test:
	bats tests/files/*.bats

lint:
	scripts/lint.sh

init:
	chezmoi init Danwidj/dotfiles

apply:
	chezmoi apply

diff:
	chezmoi diff