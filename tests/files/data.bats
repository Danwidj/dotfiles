#!/usr/bin/env bats

load '../test_helper.bats'

setup() {
    export TEST_HOME="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${TEST_HOME}/.config/chezmoi"
}

@test "dot_config/git/private_config.tmpl renders with email substitution" {
    cat > "${TEST_HOME}/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine_type = "personal"
    email = "test@example.com"
EOF

    run chezmoi execute-template -f "${BATS_TEST_DIRNAME}/../../home/dot_config/git/private_config.tmpl" --config="${TEST_HOME}/.config/chezmoi/chezmoi.toml"
    assert_success
    assert_output_partial "email = test@example.com"
}

@test "dot_config/git/private_config.tmpl renders with different emails" {
    cat > "${TEST_HOME}/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine_type = "personal"
    email = "another@domain.org"
EOF

    run chezmoi execute-template -f "${BATS_TEST_DIRNAME}/../../home/dot_config/git/private_config.tmpl" --config="${TEST_HOME}/.config/chezmoi/chezmoi.toml"
    assert_success
    assert_output_partial "email = another@domain.org"
}

@test "dot_config/homebrew/private_Brewfile.tmpl renders without error for machine_type=personal" {
    cat > "${TEST_HOME}/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine_type = "personal"
    email = "test@example.com"
EOF

    run chezmoi execute-template -f "${BATS_TEST_DIRNAME}/../../home/dot_config/homebrew/private_Brewfile.tmpl" --config="${TEST_HOME}/.config/chezmoi/chezmoi.toml"
    assert_success
    assert_output_partial 'brew "gh"'
    assert_output_partial 'cask "claude"'
    assert_output_partial 'cask "claude-code@latest"'
}

@test "dot_config/homebrew/private_Brewfile.tmpl renders without error for machine_type=work" {
    cat > "${TEST_HOME}/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine_type = "work"
    email = "test@example.com"
EOF

    run chezmoi execute-template -f "${BATS_TEST_DIRNAME}/../../home/dot_config/homebrew/private_Brewfile.tmpl" --config="${TEST_HOME}/.config/chezmoi/chezmoi.toml"
    assert_success
    refute_output_partial 'brew "gh"'
    refute_output_partial 'cask "claude"'
    refute_output_partial 'cask "claude-code@latest"'
}

@test "dot_config/homebrew/private_Brewfile.tmpl always includes core packages regardless of machine_type" {
    cat > "${TEST_HOME}/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine_type = "personal"
    email = "test@example.com"
EOF

    run chezmoi execute-template -f "${BATS_TEST_DIRNAME}/../../home/dot_config/homebrew/private_Brewfile.tmpl" --config="${TEST_HOME}/.config/chezmoi/chezmoi.toml"
    assert_success
    assert_output_partial 'brew "git"'
    assert_output_partial 'brew "chezmoi"'
    assert_output_partial 'brew "neovim"'
    assert_output_partial 'brew "tmux"'
    assert_output_partial 'brew "fzf-tab"'
    assert_output_partial 'brew "zsh-syntax-highlighting"'

    cat > "${TEST_HOME}/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine_type = "work"
    email = "test@example.com"
EOF

    run chezmoi execute-template -f "${BATS_TEST_DIRNAME}/../../home/dot_config/homebrew/private_Brewfile.tmpl" --config="${TEST_HOME}/.config/chezmoi/chezmoi.toml"
    assert_success
    assert_output_partial 'brew "git"'
    assert_output_partial 'brew "chezmoi"'
    assert_output_partial 'brew "neovim"'
    assert_output_partial 'brew "tmux"'
    assert_output_partial 'brew "fzf-tab"'
    assert_output_partial 'brew "zsh-syntax-highlighting"'
}

@test "run_onchange_after_brew-bundle.sh.tmpl renders without error and contains Brewfile hash" {
    cat > "${TEST_HOME}/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine_type = "personal"
    email = "test@example.com"
EOF

    run chezmoi execute-template --source="${BATS_TEST_DIRNAME}/../.." -f "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_onchange_after_brew-bundle.sh.tmpl" --config="${TEST_HOME}/.config/chezmoi/chezmoi.toml"
    assert_success
    assert_output_partial "# Brewfile hash: "
}

@test "run_onchange_after_brew-bundle.sh.tmpl hash changes when machine_type changes" {
    cat > "${TEST_HOME}/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine_type = "personal"
    email = "test@example.com"
EOF

    run chezmoi execute-template --source="${BATS_TEST_DIRNAME}/../.." -f "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_onchange_after_brew-bundle.sh.tmpl" --config="${TEST_HOME}/.config/chezmoi/chezmoi.toml"
    assert_success
    personal_output="$output"

    cat > "${TEST_HOME}/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine_type = "work"
    email = "test@example.com"
EOF

    run chezmoi execute-template --source="${BATS_TEST_DIRNAME}/../.." -f "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_onchange_after_brew-bundle.sh.tmpl" --config="${TEST_HOME}/.config/chezmoi/chezmoi.toml"
    assert_success
    refute_output "$personal_output"
}
