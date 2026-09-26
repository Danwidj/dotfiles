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

@test "~/.config/zsh/managed.zsh is zsh parse-clean" {
    run zsh -n "${TEST_HOME}/.config/zsh/managed.zsh"
    assert_success
}

@test "~/.config/zsh/managed.zshenv exists after apply" {
    assert_file_exist "${TEST_HOME}/.config/zsh/managed.zshenv"
}

@test "~/.config/zsh/managed.zshenv is zsh parse-clean" {
    run zsh -n "${TEST_HOME}/.config/zsh/managed.zshenv"
    assert_success
}

@test "~/.config/zsh/managed.zsh sets expected quality-of-life setopts" {
    MANAGED="${TEST_HOME}/.config/zsh/managed.zsh"
    for opt in HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY HIST_VERIFY \
               EXTENDED_GLOB GLOB_DOTS NUMERIC_GLOB_SORT AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS \
               CORRECT NO_CLOBBER; do
        run grep -E "^setopt[[:space:]]+$opt" "${MANAGED}"
        assert_success
    done
}

@test "~/.config/zsh/managed.zsh enforces plugin load order: compinit -> fzf-tab -> autosuggestions -> syntax-highlighting" {
    MANAGED="${TEST_HOME}/.config/zsh/managed.zsh"
    compinit_line=$(grep -n "compinit" "${MANAGED}" | head -n 1 | cut -d: -f1)
    fzftab_line=$(grep -n "fzf-tab.zsh" "${MANAGED}" | head -n 1 | cut -d: -f1)
    autosuggest_line=$(grep -n "zsh-autosuggestions.zsh" "${MANAGED}" | head -n 1 | cut -d: -f1)
    syntax_line=$(grep -n "zsh-syntax-highlighting.zsh" "${MANAGED}" | head -n 1 | cut -d: -f1)

    [ -n "$compinit_line" ]
    [ -n "$fzftab_line" ]
    [ -n "$autosuggest_line" ]
    [ -n "$syntax_line" ]

    [ "$compinit_line" -lt "$fzftab_line" ]
    [ "$fzftab_line" -lt "$autosuggest_line" ]
    [ "$autosuggest_line" -lt "$syntax_line" ]
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

@test "~/.config/ssh/config exists after apply" {
    assert_file_exist "${TEST_HOME}/.config/ssh/config"
}

@test "~/.config/zsh/managed.zshenv exports XDG redirect for copilot" {
    MANAGED="${TEST_HOME}/.config/zsh/managed.zshenv"
    run grep -F 'export COPILOT_HOME="$XDG_DATA_HOME/copilot"' "${MANAGED}"
    assert_success
}

@test "git config --list runs successfully" {
    run git config --list
    assert_success
}

@test "run_once_zshrc.sh creates .zshrc shim sourcing managed.zsh" {
    ZSHRC="${TEST_HOME}/.config/zsh/.zshrc"
    MANAGED="${TEST_HOME}/.config/zsh/managed.zsh"

    echo "source managed content" > "${MANAGED}"
    HOME="${TEST_HOME}" run bash "${BATS_TEST_DIRNAME}/../../home/run_once_zshrc.sh"
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

    HOME="${TEST_HOME}" run bash "${BATS_TEST_DIRNAME}/../../home/run_once_zshrc.sh"
    assert_success

    run grep -cF 'source "$ZDOTDIR/managed.zsh"' "${ZSHRC}"
    assert_success
    assert_output "1"
}

@test "fzf configures Catppuccin Mocha and Latte themes" {
    MANAGED="${BATS_TEST_DIRNAME}/../../home/dot_config/fzf/private_config.zsh"
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

@test "uv tool manifest tracks required tools" {
    TOOLS="${BATS_TEST_DIRNAME}/../../home/dot_config/uv/private_tools.txt"
    run grep -Fx "pyrefly" "${TOOLS}"
    assert_success
    run grep -Fx "pre-commit" "${TOOLS}"
    assert_success
    run grep -Fx "ruff" "${TOOLS}"
    assert_success
}
