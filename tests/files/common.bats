#!/usr/bin/env bats

load '../test_helper.bats'

setup() {
    export TEST_HOME="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${TEST_HOME}/.config/chezmoi"
    cat > "${TEST_HOME}/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine_type = "personal"
    email = "test@example.com"
EOF

    # Apply chezmoi configs for tests that need them. --exclude=scripts skips
    # run_once_*/run_onchange_* scripts: this file's tests only assert on
    # applied file state, and unconditionally running scripts here would
    # execute macOS-only commands (Homebrew, `defaults`, `osascript`, ...)
    # for real, on whichever OS this bats file runs on (Ubuntu via ci.yaml,
    # macOS via macos-ci.yaml). Script behavior itself is exercised directly
    # below (e.g. the run_once_zshrc.sh tests) and, end-to-end on the
    # correct OS, by macos-ci.yaml's own top-level chezmoi apply step.
    chezmoi init --apply --source="${BATS_TEST_DIRNAME}/../.." --destination="${TEST_HOME}" --config="${TEST_HOME}/.config/chezmoi/chezmoi.toml" --exclude=scripts >/dev/null 2>&1
}

teardown() {
    rm -rf "${BATS_TEST_TMPDIR}"
}

@test "chezmoi init --apply applies cross-platform configs successfully" {
    # This is verified by setup() succeeding
    assert_success
}

@test "~/.config/zsh/managed.zsh exists after apply" {
    assert_file_exist "${TEST_HOME}/.config/zsh/managed.zsh"
}

@test "~/.config/nvim/init.lua exists after apply" {
    assert_file_exist "${TEST_HOME}/.config/nvim/init.lua"
}

@test "~/.config/tmux/tmux.conf exists after apply" {
    assert_file_exist "${TEST_HOME}/.config/tmux/tmux.conf"
}

@test "~/.config/ghostty/config.ghostty exists after apply" {
    assert_file_exist "${TEST_HOME}/.config/ghostty/config.ghostty"
}

@test "~/.config/starship.toml exists after apply" {
    assert_file_exist "${TEST_HOME}/.config/starship.toml"
}

@test "~/.config/git/config exists after apply (git config rendered from template)" {
    assert_file_exist "${TEST_HOME}/.config/git/config"
}

@test "git config --list runs successfully" {
    run git config --list
    assert_success
}

@test "run_once_zshrc.sh creates .zshrc shim sourcing managed.zsh" {
    ZSHRC="${TEST_HOME}/.config/zsh/.zshrc"
    MANAGED="${TEST_HOME}/.config/zsh/managed.zsh"

    echo "source managed content" > "${MANAGED}"
    HOME="${TEST_HOME}" run bash "${BATS_TEST_DIRNAME}/../../run_once_zshrc.sh"
    assert_success

    assert_file_exist "${ZSHRC}"
    run grep -F 'source "$ZDOTDIR/managed.zsh"' "${ZSHRC}"
    assert_success
    assert_output_partial 'source "$ZDOTDIR/managed.zsh"'
}

@test "run_once_zshrc.sh is idempotent when .zshrc already has source line" {
    ZSHRC="${TEST_HOME}/.config/zsh/.zshrc"
    MANAGED="${TEST_HOME}/.config/zsh/managed.zsh"

    echo "source managed content" > "${MANAGED}"
    printf '%s\n' 'source "$ZDOTDIR/managed.zsh"' > "${ZSHRC}"

    HOME="${TEST_HOME}" run bash "${BATS_TEST_DIRNAME}/../../run_once_zshrc.sh"
    assert_success

    run grep -cF 'source "$ZDOTDIR/managed.zsh"' "${ZSHRC}"
    assert_success
    assert_output "1"
}

@test "managed.zsh configures Catppuccin Mocha and Latte fzf themes" {
    MANAGED="${BATS_TEST_DIRNAME}/../../dot_config/zsh/private_managed.zsh"
    run grep -F "Catppuccin Mocha" "${MANAGED}"
    assert_success
    run grep -F "Catppuccin Latte" "${MANAGED}"
    assert_success
    run grep -F "bg+:#313244,bg:#1E1E2E" "${MANAGED}"
    assert_success
    run grep -F "bg+:#CCD0DA,bg:#EFF1F5" "${MANAGED}"
    assert_success
    run grep -F -e "--style=full" "${MANAGED}"
    assert_success
}
