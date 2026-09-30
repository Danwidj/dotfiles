#!/usr/bin/env bats

load '../test_helper.bats'

setup() {
    export TEST_HOME="${BATS_TEST_TMPDIR}/home"
    export ETC_ZSHENV="${TEST_HOME}/etc/zshenv"
    export XDG_DATA_HOME="${TEST_HOME}/.local/share"
    export XDG_CONFIG_HOME="${TEST_HOME}/.config"
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
    # below (e.g. the run_zsh-setup.sh tests) and, end-to-end on the
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

@test "~/.config/zsh/managed.zshrc exists after apply" {
    assert_file_exist "${TEST_HOME}/.config/zsh/managed.zshrc"
}

@test "~/.config/zsh/managed.zshrc is zsh parse-clean" {
    run zsh -n "${TEST_HOME}/.config/zsh/managed.zshrc"
    assert_success
}

@test "~/.config/zsh/managed.zshenv exists after apply" {
    assert_file_exist "${TEST_HOME}/.config/zsh/managed.zshenv"
}

@test "~/.config/zsh/managed.zshenv is zsh parse-clean" {
    run zsh -n "${TEST_HOME}/.config/zsh/managed.zshenv"
    assert_success
}

@test "~/.config/zsh/managed.zshrc sets expected quality-of-life setopts" {
    MANAGED="${TEST_HOME}/.config/zsh/managed.zshrc"
    for opt in HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY HIST_VERIFY \
               EXTENDED_GLOB GLOB_DOTS NUMERIC_GLOB_SORT AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS \
               CORRECT NO_CLOBBER; do
        run grep -E "^setopt[[:space:]]+$opt" "${MANAGED}"
        assert_success
    done
}

@test "~/.config/zsh/managed.zshrc enforces plugin load order: compinit -> fzf-tab -> autosuggestions -> syntax-highlighting" {
    MANAGED="${TEST_HOME}/.config/zsh/managed.zshrc"
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

@test "~/.config/vim/vimrc exists after apply" {
    assert_file_exist "${TEST_HOME}/.config/vim/vimrc"
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

@test "run_zsh-setup.sh exists and is executable" {
    SCRIPT="${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_zsh-setup.sh"
    assert_file_exist "${SCRIPT}"
    assert_file_executable "${SCRIPT}"
}

@test "run_zsh-setup.sh is bash parse-clean" {
    run bash -n "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_zsh-setup.sh"
    assert_success
}

@test "run_zsh-setup.sh creates .zshrc and .zshenv shims when missing" {
    ZSHRC="${TEST_HOME}/.config/zsh/.zshrc"
    ZSHENV="${TEST_HOME}/.config/zsh/.zshenv"
    rm -f "${ZSHRC}" "${ZSHENV}"

    HOME="${TEST_HOME}" ETC_ZSHENV="${TEST_HOME}/etc/zshenv" run bash "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_zsh-setup.sh"
    assert_success

    assert_file_exist "${ZSHRC}"
    run cat "${ZSHRC}"
    assert_success
    assert_output 'source "$ZDOTDIR/managed.zshrc"'

    assert_file_exist "${ZSHENV}"
    run cat "${ZSHENV}"
    assert_success
    assert_output 'source "$ZDOTDIR/managed.zshenv"'

    [ -d "${TEST_HOME}/.local/share/zsh" ]
}

@test "run_zsh-setup.sh leaves shims untouched when source line is already first line" {
    ZSHRC="${TEST_HOME}/.config/zsh/.zshrc"
    ZSHENV="${TEST_HOME}/.config/zsh/.zshenv"
    mkdir -p "${TEST_HOME}/.config/zsh"

    cat <<'EOF' > "${ZSHRC}"
source "$ZDOTDIR/managed.zshrc"
# User config
export FOO="bar"
EOF

    cat <<'EOF' > "${ZSHENV}"
source "$ZDOTDIR/managed.zshenv"
# User env
export BAR="baz"
EOF

    touch -t 202001010000 "${ZSHRC}"
    touch -t 202001010000 "${ZSHENV}"

    mtime_zshrc_before=$(stat -c "%Y" "${ZSHRC}" 2>/dev/null || stat -f "%m" "${ZSHRC}")
    mtime_zshenv_before=$(stat -c "%Y" "${ZSHENV}" 2>/dev/null || stat -f "%m" "${ZSHENV}")

    HOME="${TEST_HOME}" ETC_ZSHENV="${TEST_HOME}/etc/zshenv" run bash "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_zsh-setup.sh"
    assert_success

    mtime_zshrc_after=$(stat -c "%Y" "${ZSHRC}" 2>/dev/null || stat -f "%m" "${ZSHRC}")
    mtime_zshenv_after=$(stat -c "%Y" "${ZSHENV}" 2>/dev/null || stat -f "%m" "${ZSHENV}")

    [ "${mtime_zshrc_before}" -eq "${mtime_zshrc_after}" ]
    [ "${mtime_zshenv_before}" -eq "${mtime_zshenv_after}" ]
}

@test "run_zsh-setup.sh moves source line to line 1, removes duplicates, and preserves other lines in order" {
    ZSHRC="${TEST_HOME}/.config/zsh/.zshrc"
    ZSHENV="${TEST_HOME}/.config/zsh/.zshenv"
    mkdir -p "${TEST_HOME}/.config/zsh"

    cat <<'EOF' > "${ZSHRC}"
# Header comment
export BEFORE="1"
source "$ZDOTDIR/managed.zshrc"
alias ll="ls -la"
source "$ZDOTDIR/managed.zshrc"
export AFTER="2"
EOF

    cat <<'EOF' > "${ZSHENV}"
export ENV_FIRST="a"
source "$ZDOTDIR/managed.zshenv"
export ENV_SECOND="b"
EOF

    HOME="${TEST_HOME}" ETC_ZSHENV="${TEST_HOME}/etc/zshenv" run bash "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_zsh-setup.sh"
    assert_success

    run cat "${ZSHRC}"
    assert_success
    expected_zshrc=$(cat <<'EOF'
source "$ZDOTDIR/managed.zshrc"
# Header comment
export BEFORE="1"
alias ll="ls -la"
export AFTER="2"
EOF
)
    assert_output "${expected_zshrc}"

    run cat "${ZSHENV}"
    assert_success
    expected_zshenv=$(cat <<'EOF'
source "$ZDOTDIR/managed.zshenv"
export ENV_FIRST="a"
export ENV_SECOND="b"
EOF
)
    assert_output "${expected_zshenv}"
}

@test "run_zsh-setup.sh does not special-case legacy managed.zsh" {
    ZSHRC="${TEST_HOME}/.config/zsh/.zshrc"
    mkdir -p "${TEST_HOME}/.config/zsh"

    cat <<'EOF' > "${ZSHRC}"
source "$ZDOTDIR/managed.zsh"
export SOME_VAR="val"
EOF

    HOME="${TEST_HOME}" ETC_ZSHENV="${TEST_HOME}/etc/zshenv" run bash "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_zsh-setup.sh"
    assert_success

    run cat "${ZSHRC}"
    assert_success
    expected_zshrc=$(cat <<'EOF'
source "$ZDOTDIR/managed.zshrc"
source "$ZDOTDIR/managed.zsh"
export SOME_VAR="val"
EOF
)
    assert_output "${expected_zshrc}"
}

@test "run_after_setup-ssh.sh exists and is executable" {
    SCRIPT="${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_after_setup-ssh.sh"
    assert_file_exist "${SCRIPT}"
    assert_file_executable "${SCRIPT}"
}

@test "run_after_setup-ssh.sh is bash parse-clean" {
    run bash -n "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_after_setup-ssh.sh"
    assert_success
}

@test "run_after_setup-ssh.sh creates ~/.ssh/config with mode 600 and Include directive when missing" {
    SSH_DIR="${TEST_HOME}/.ssh"
    SSH_CONFIG="${SSH_DIR}/config"
    rm -rf "${SSH_DIR}"

    HOME="${TEST_HOME}" run bash "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_after_setup-ssh.sh"
    assert_success
    assert_file_exist "${SSH_CONFIG}"

    run cat "${SSH_CONFIG}"
    assert_success
    assert_output "Include ~/.config/ssh/config"

    run python3 -c "import os, stat; print(oct(stat.S_IMODE(os.stat('${SSH_CONFIG}').st_mode)))"
    assert_success
    assert_output "0o600"
}

@test "run_after_setup-ssh.sh appends Include directive without duplicating or overwriting existing config" {
    SSH_DIR="${TEST_HOME}/.ssh"
    SSH_CONFIG="${SSH_DIR}/config"
    mkdir -p "${SSH_DIR}"
    cat <<'EOF' > "${SSH_CONFIG}"
Host github.com
    User git
EOF
    chmod 644 "${SSH_CONFIG}"

    HOME="${TEST_HOME}" run bash "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_after_setup-ssh.sh"
    assert_success

    run cat "${SSH_CONFIG}"
    assert_success
    expected=$(cat <<'EOF'
Host github.com
    User git
Include ~/.config/ssh/config
EOF
)
    assert_output "${expected}"

    run python3 -c "import os, stat; print(oct(stat.S_IMODE(os.stat('${SSH_CONFIG}').st_mode)))"
    assert_success
    assert_output "0o600"

    # Re-run to verify idempotency
    HOME="${TEST_HOME}" run bash "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_after_setup-ssh.sh"
    assert_success
    run cat "${SSH_CONFIG}"
    assert_success
    assert_output "${expected}"
}

@test "run_zsh-setup.sh configures ZDOTDIR in ETC_ZSHENV when missing" {
    TEST_ETC="${TEST_HOME}/etc/zshenv"
    rm -f "${TEST_ETC}"

    HOME="${TEST_HOME}" ETC_ZSHENV="${TEST_ETC}" run bash "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_zsh-setup.sh"
    assert_success

    assert_file_exist "${TEST_ETC}"
    run cat "${TEST_ETC}"
    assert_success
    assert_output 'export ZDOTDIR="$HOME/.config/zsh"'
}

@test "run_zsh-setup.sh does not duplicate ZDOTDIR in ETC_ZSHENV if already present" {
    TEST_ETC="${TEST_HOME}/etc/zshenv"
    mkdir -p "$(dirname "${TEST_ETC}")"
    cat <<'EOF' > "${TEST_ETC}"
# System zshenv
export ZDOTDIR="$HOME/.config/zsh"
export FOO=1
EOF

    HOME="${TEST_HOME}" ETC_ZSHENV="${TEST_ETC}" run bash "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_zsh-setup.sh"
    assert_success

    run grep -cF 'export ZDOTDIR="$HOME/.config/zsh"' "${TEST_ETC}"
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

@test "mise.toml defines the required repo tasks" {
    MISE_TOML="${BATS_TEST_DIRNAME}/../../mise.toml"
    assert_file_exist "${MISE_TOML}"
    for task in test lint check init apply diff; do
        run grep -E "^\[tasks\.${task}\]" "${MISE_TOML}"
        assert_success
    done
}

@test "repo-root mise.toml pins chezmoi, bats, and shellcheck tools" {
    MISE_TOML="${BATS_TEST_DIRNAME}/../../mise.toml"
    assert_file_exist "${MISE_TOML}"
    for tool in chezmoi bats shellcheck; do
        run grep -E "^${tool}[[:space:]]*=" "${MISE_TOML}"
        assert_success
    done
}

@test "mise-tasks files exist, are executable, and are bash parse-clean" {
    for task in lint ci/apply ci/install-homebrew ci/write-chezmoi-config; do
        TASK_PATH="${BATS_TEST_DIRNAME}/../../mise-tasks/${task}"
        assert_file_exist "${TASK_PATH}"
        assert_file_executable "${TASK_PATH}"
        run bash -n "${TASK_PATH}"
        assert_success
    done
}

@test "global mise config tracks required python cli tools" {
    CONFIG="${BATS_TEST_DIRNAME}/../../home/dot_config/mise/config.toml"
    assert_file_exist "${CONFIG}"
    for tool in ruff pre-commit pyrefly; do
        run grep -E "\"(pypi|pipx):${tool}\"[[:space:]]*=" "${CONFIG}"
        assert_success
    done
}

@test "run_once_setup-chezmoi-git-identity.sh.tmpl exists and is executable" {
    SCRIPT="${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_once_setup-chezmoi-git-identity.sh.tmpl"
    assert_file_exist "${SCRIPT}"
    assert_file_executable "${SCRIPT}"
}

@test "run_once_setup-chezmoi-git-identity.sh.tmpl rendered is bash parse-clean" {
    RENDERED="${BATS_TEST_TMPDIR}/rendered_git_identity.sh"
    chezmoi execute-template --source="${BATS_TEST_DIRNAME}/../.." --override-data '{"email": "test@example.com"}' < "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_once_setup-chezmoi-git-identity.sh.tmpl" > "${RENDERED}"
    run bash -n "${RENDERED}"
    assert_success
}

@test "run_once_setup-chezmoi-git-identity.sh.tmpl fails when CHEZMOI_SOURCE_DIR is unset" {
    RENDERED="${BATS_TEST_TMPDIR}/rendered_git_identity.sh"
    chezmoi execute-template --source="${BATS_TEST_DIRNAME}/../.." --override-data '{"email": "test@example.com"}' < "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_once_setup-chezmoi-git-identity.sh.tmpl" > "${RENDERED}"
    run env -u CHEZMOI_SOURCE_DIR bash "${RENDERED}"
    assert_failure
    assert_output_partial "CHEZMOI_SOURCE_DIR environment variable is not set"
}

@test "run_once_setup-chezmoi-git-identity.sh.tmpl configures local git identity on target repo" {
    TMP_REPO="${BATS_TEST_TMPDIR}/throwaway-git-repo"
    git init "${TMP_REPO}"
    RENDERED="${BATS_TEST_TMPDIR}/rendered_git_identity.sh"
    chezmoi execute-template --source="${BATS_TEST_DIRNAME}/../.." --override-data '{"email": "custom-dev@example.org"}' < "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_once_setup-chezmoi-git-identity.sh.tmpl" > "${RENDERED}"

    CHEZMOI_SOURCE_DIR="${TMP_REPO}" run bash "${RENDERED}"
    assert_success

    run git -C "${TMP_REPO}" config --local user.name
    assert_success
    assert_output "Daniel"

    run git -C "${TMP_REPO}" config --local user.email
    assert_success
    assert_output "custom-dev@example.org"

    run git -C "${TMP_REPO}" config --local commit.gpgsign
    assert_success
    assert_output "false"
}

@test "~/.config/zsh/managed.zshrc does not invoke fastfetch at startup" {
    run grep "fastfetch" "${TEST_HOME}/.config/zsh/managed.zshrc"
    assert_failure
}

@test "~/.config/zsh/managed.zshrc atuin init syntax is valid with single closing parenthesis" {
    run grep 'atuin init zsh' "${TEST_HOME}/.config/zsh/managed.zshrc"
    assert_success
    assert_output_partial 'eval "$(atuin init zsh --disable-up-arrow)"'
    refute_output_partial '))'
}

@test "~/.config/git/ignore does not ignore Cargo.lock" {
    run grep -E "^Cargo\.lock" "${TEST_HOME}/.config/git/ignore"
    assert_failure
}

@test "~/.config/zsh/managed.zshenv does not export VIMINIT" {
    run grep "VIMINIT" "${TEST_HOME}/.config/zsh/managed.zshenv"
    assert_failure
}

@test "~/.config/vim/vimrc relocates viminfo to XDG state directory" {
    run grep "viminfofile" "${TEST_HOME}/.config/vim/vimrc"
    assert_success
    assert_output_partial "s:vim_state_dir . '/viminfo'"
}

@test "~/.config/zsh/managed.zshrc initializes zoxide with --cmd cd" {
    run grep 'zoxide init zsh' "${TEST_HOME}/.config/zsh/managed.zshrc"
    assert_success
    assert_output_partial '--cmd cd'
}

@test "~/.config/zsh/managed.zshrc does not define find, grep, or cd aliases" {
    run grep -E "alias cd=" "${TEST_HOME}/.config/zsh/managed.zshrc"
    assert_failure

    run grep -E "alias find=" "${TEST_HOME}/.config/zsh/managed.zshrc"
    assert_failure

    run grep -E "alias grep=" "${TEST_HOME}/.config/zsh/managed.zshrc"
    assert_failure
}

@test "~/.config/zsh/managed.zshrc preserves cat and ls aliases" {
    run grep "alias cat='bat'" "${TEST_HOME}/.config/zsh/managed.zshrc"
    assert_success

    run grep "alias ls=" "${TEST_HOME}/.config/zsh/managed.zshrc"
    assert_success
}

@test "~/.config/agents/AGENTS.md exists with mode 600 and personal instructions content" {
    AGENTS_FILE="${TEST_HOME}/.config/agents/AGENTS.md"
    assert_file_exist "${AGENTS_FILE}"

    run head -n 1 "${AGENTS_FILE}"
    assert_success
    assert_output '# Personal instructions for coding agents'

    run python3 -c "import os, stat; print(oct(stat.S_IMODE(os.stat('${AGENTS_FILE}').st_mode)))"
    assert_success
    assert_output "0o600"
}

@test "~/.config/claude/CLAUDE.md exists and imports shared AGENTS.md" {
    CLAUDE_FILE="${TEST_HOME}/.config/claude/CLAUDE.md"
    assert_file_exist "${CLAUDE_FILE}"

    run python3 -c "import os, stat; print(oct(stat.S_IMODE(os.stat('${TEST_HOME}/.config/claude').st_mode)))"
    assert_success
    assert_output "0o700"

    run cat "${CLAUDE_FILE}"
    assert_success
    assert_output '@~/.config/agents/AGENTS.md'
}

@test "all agent harness instructions symlinks point to shared AGENTS.md" {
    TARGET="${TEST_HOME}/.config/agents/AGENTS.md"
    assert_file_exist "${TARGET}"

    # opencode
    OPENCODE_LINK="${TEST_HOME}/.config/opencode/AGENTS.md"
    [ -L "${OPENCODE_LINK}" ]
    [ "$(readlink "${OPENCODE_LINK}")" = "../agents/AGENTS.md" ]
    assert_file_exist "${OPENCODE_LINK}"
    run head -n 1 "${OPENCODE_LINK}"
    assert_success
    assert_output '# Personal instructions for coding agents'

    # pi
    PI_LINK="${TEST_HOME}/.config/pi/agent/AGENTS.md"
    [ -L "${PI_LINK}" ]
    [ "$(readlink "${PI_LINK}")" = "../../agents/AGENTS.md" ]
    assert_file_exist "${PI_LINK}"
    run head -n 1 "${PI_LINK}"
    assert_success
    assert_output '# Personal instructions for coding agents'

    # agy (Antigravity CLI)
    AGY_LINK="${TEST_HOME}/.gemini/AGENTS.md"
    [ -L "${AGY_LINK}" ]
    [ "$(readlink "${AGY_LINK}")" = "../.config/agents/AGENTS.md" ]
    assert_file_exist "${AGY_LINK}"
    run head -n 1 "${AGY_LINK}"
    assert_success
    assert_output '# Personal instructions for coding agents'

    # GitHub Copilot CLI
    COPILOT_LINK="${TEST_HOME}/.local/share/copilot/copilot-instructions.md"
    run python3 -c "import os, stat; print(oct(stat.S_IMODE(os.stat('${TEST_HOME}/.local/share/copilot').st_mode)))"
    assert_success
    assert_output "0o700"
    [ -L "${COPILOT_LINK}" ]
    [ "$(readlink "${COPILOT_LINK}")" = "../../../.config/agents/AGENTS.md" ]
    assert_file_exist "${COPILOT_LINK}"
    run head -n 1 "${COPILOT_LINK}"
    assert_success
    assert_output '# Personal instructions for coding agents'

    # Verify canonical path resolution
    run python3 -c "import os; t=os.path.realpath('${TARGET}'); assert all(os.path.realpath(p) == t for p in ['${OPENCODE_LINK}', '${PI_LINK}', '${AGY_LINK}', '${COPILOT_LINK}'])"
    assert_success
}

@test "Claude settings modify script updates statusLine and preserves other keys" {
    SETTINGS_FILE="${TEST_HOME}/.config/claude/settings.json"
    assert_file_exist "${SETTINGS_FILE}"

    run jq -r '.statusLine.type' "${SETTINGS_FILE}"
    assert_success
    assert_output "command"

    run jq -r '.statusLine.command' "${SETTINGS_FILE}"
    assert_success
    assert_output "~/.config/statusline/statusline.sh"

    run jq -r '.statusLine.padding' "${SETTINGS_FILE}"
    assert_success
    assert_output "0"

    # Test modify script preserves existing keys
    MOD_SCRIPT="${BATS_TEST_DIRNAME}/../../home/dot_config/private_claude/modify_private_settings.json"
    assert_file_exist "${MOD_SCRIPT}"
    assert_file_executable "${MOD_SCRIPT}"

    TEST_JSON='{"existing_key": "val", "hooks": [1, 2], "statusLine": {"old": true}}'
    MOD_OUTPUT=$(echo "${TEST_JSON}" | sh "${MOD_SCRIPT}")
    [ "$(echo "${MOD_OUTPUT}" | jq -r .existing_key)" = "val" ]
    [ "$(echo "${MOD_OUTPUT}" | jq -r '.hooks | length')" = "2" ]
    [ "$(echo "${MOD_OUTPUT}" | jq -r .statusLine.command)" = "~/.config/statusline/statusline.sh" ]
    [ "$(echo "${MOD_OUTPUT}" | jq -r .statusLine.padding)" = "0" ]
}

@test "~/.config/statusline/statusline.sh exists, is executable, and is bash parse-clean" {
    STATUS_SCRIPT="${TEST_HOME}/.config/statusline/statusline.sh"
    assert_file_exist "${STATUS_SCRIPT}"
    assert_file_executable "${STATUS_SCRIPT}"

    run bash -n "${STATUS_SCRIPT}"
    assert_success
}

@test "statusline.sh formats full Claude-shaped input" {
    STATUS_SCRIPT="${TEST_HOME}/.config/statusline/statusline.sh"
    INPUT='{"model": {"display_name": "Opus 5.5"}, "context_window": {"total_input_tokens": 400000}, "rate_limits": {"five_hour": {"used_percentage": 62, "resets_at": 1738424400}, "seven_day": {"used_percentage": 14, "resets_at": 1738424400}}}'

    run env TZ=UTC "${STATUS_SCRIPT}" <<< "${INPUT}"
    assert_success
    assert_output "Opus 5.5 | ctx 400k | 5h 62% resets 15:40 | week 14% resets Sat 15:40"
}

@test "statusline.sh handles missing 5h rate limit" {
    STATUS_SCRIPT="${TEST_HOME}/.config/statusline/statusline.sh"
    INPUT='{"model": {"display_name": "Opus 5.5"}, "context_window": {"total_input_tokens": 400000}, "rate_limits": {"seven_day": {"used_percentage": 14, "resets_at": 1738424400}}}'

    run env TZ=UTC "${STATUS_SCRIPT}" <<< "${INPUT}"
    assert_success
    assert_output "Opus 5.5 | ctx 400k | week 14% resets Sat 15:40"
}

@test "statusline.sh handles missing week rate limit" {
    STATUS_SCRIPT="${TEST_HOME}/.config/statusline/statusline.sh"
    INPUT='{"model": {"display_name": "Opus 5.5"}, "context_window": {"total_input_tokens": 400000}, "rate_limits": {"five_hour": {"used_percentage": 62, "resets_at": 1738424400}}}'

    run env TZ=UTC "${STATUS_SCRIPT}" <<< "${INPUT}"
    assert_success
    assert_output "Opus 5.5 | ctx 400k | 5h 62% resets 15:40"
}

@test "statusline.sh handles missing reset times" {
    STATUS_SCRIPT="${TEST_HOME}/.config/statusline/statusline.sh"
    INPUT='{"model": {"display_name": "Opus 5.5"}, "context_window": {"total_input_tokens": 400000}, "rate_limits": {"five_hour": {"used_percentage": 62}, "seven_day": {"used_percentage": 14}}}'

    run env TZ=UTC "${STATUS_SCRIPT}" <<< "${INPUT}"
    assert_success
    assert_output "Opus 5.5 | ctx 400k | 5h 62% | week 14%"
}

@test "statusline.sh handles only model and ctx" {
    STATUS_SCRIPT="${TEST_HOME}/.config/statusline/statusline.sh"
    INPUT='{"model": {"display_name": "Opus 5.5"}, "context_window": {"total_input_tokens": 400000}}'

    run env TZ=UTC "${STATUS_SCRIPT}" <<< "${INPUT}"
    assert_success
    assert_output "Opus 5.5 | ctx 400k"
}

@test "statusline.sh formats token counts correctly (0, 400000, 1234567)" {
    STATUS_SCRIPT="${TEST_HOME}/.config/statusline/statusline.sh"

    run env TZ=UTC "${STATUS_SCRIPT}" <<< '{"model": {"display_name": "Opus 5.5"}, "context_window": {"total_input_tokens": 0}}'
    assert_success
    assert_output "Opus 5.5 | ctx 0k"

    run env TZ=UTC "${STATUS_SCRIPT}" <<< '{"model": {"display_name": "Opus 5.5"}, "context_window": {"total_input_tokens": 400000}}'
    assert_success
    assert_output "Opus 5.5 | ctx 400k"

    run env TZ=UTC "${STATUS_SCRIPT}" <<< '{"model": {"display_name": "Opus 5.5"}, "context_window": {"total_input_tokens": 1234567}}'
    assert_success
    assert_output "Opus 5.5 | ctx 1.2M"
}
