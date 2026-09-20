# Test Suite

This directory contains automated integration tests for the dotfiles using [Bats (Bash Automated Testing System)](https://github.com/bats-core/bats-core).

- **`test_helper.bats`**: Loads shared assertions and helpers from `bats-support` and `bats-assert`.
- **`files/`**: Contains individual Bats test suites asserting on applied state, template rendering, and script validity.

Run tests locally with:

```sh
make test
```
