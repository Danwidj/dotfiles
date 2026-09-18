#!/usr/bin/env bats

# Simple assertion functions for Bats (replaces bats-assert)

assert_success() {
    if [ "$status" -ne 0 ]; then
        echo "assert_success failed: expected exit code 0, got $status" >&2
        if [ -n "$output" ]; then
            echo "Output: $output" >&2
        fi
        return 1
    fi
}

assert_failure() {
    if [ "$status" -eq 0 ]; then
        echo "assert_failure expected non-zero exit code, got 0" >&2
        return 1
    fi
}

assert_output() {
    local expected="$1"
    if [ "$output" != "$expected" ]; then
        echo "assert_output failed: expected '$expected', got '$output'" >&2
        return 1
    fi
}

assert_output_partial() {
    local expected="$1"
    if [[ "$output" != *"$expected"* ]]; then
        echo "assert_output_partial failed: expected to find '$expected' in output" >&2
        echo "Output: $output" >&2
        return 1
    fi
}

refute_output() {
    local unexpected="$1"
    if [[ "$output" == *"$unexpected"* ]]; then
        echo "refute_output failed: expected NOT to find '$unexpected' in output" >&2
        echo "Output: $output" >&2
        return 1
    fi
}

refute_output_partial() {
    local unexpected="$1"
    if [[ "$output" == *"$unexpected"* ]]; then
        echo "refute_output_partial failed: expected NOT to find '$unexpected' in output" >&2
        echo "Output: $output" >&2
        return 1
    fi
}

assert_file_exist() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "assert_file_exist failed: file '$file' does not exist" >&2
        return 1
    fi
}

assert_file_executable() {
    local file="$1"
    if [ ! -x "$file" ]; then
        echo "assert_file_executable failed: file '$file' is not executable" >&2
        return 1
    fi
}

setup() {
    export HOME="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${HOME}/.config/chezmoi"
    cat > "${HOME}/.config/chezmoi/chezmoi.toml" <<'EOF'
[data]
    machine_type = "personal"
    email = "test@example.com"
EOF
}

teardown() {
    rm -rf "${BATS_TEST_TMPDIR}"
}