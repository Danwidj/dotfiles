#!/usr/bin/env bats

load '../test_helper.bats'

@test "run_once_after_macos.sh exists" {
    assert_file_exist "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_once_after_macos.sh"
}

@test "run_once_before_install-homebrew.sh exists" {
    assert_file_exist "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_once_before_install-homebrew.sh"
}

@test "run_onchange_after_brew-bundle.sh.tmpl exists" {
    assert_file_exist "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_onchange_after_brew-bundle.sh.tmpl"
}

@test "run_once_after_macos.sh is bash parse-clean" {
    run bash -n "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_once_after_macos.sh"
    assert_success
}

@test "run_once_before_install-homebrew.sh is bash parse-clean" {
    run bash -n "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_once_before_install-homebrew.sh"
    assert_success
}

@test "run_once_after_macos.sh has executable permissions" {
    assert_file_executable "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_once_after_macos.sh"
}

@test "run_once_before_install-homebrew.sh has executable permissions" {
    assert_file_executable "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_once_before_install-homebrew.sh"
}

@test "run_onchange_after_brew-bundle.sh.tmpl has executable permissions" {
    assert_file_executable "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_onchange_after_brew-bundle.sh.tmpl"
}

@test "run_once_after_macos.sh maps Caps Lock to Control on built-in keyboard" {
    run grep -F "com.apple.keyboard.modifiermapping.0-0-0" "${BATS_TEST_DIRNAME}/../../home/.chezmoiscripts/run_once_after_macos.sh"
    assert_success
    assert_output_partial "30064771129"
    assert_output_partial "30064771300"
}

@test "Loop keybinds and settings are valid JSON and settings carry no state" {
    LOOP_DIR="${BATS_TEST_DIRNAME}/../../home/dot_config/loop"
    assert_file_exist "${LOOP_DIR}/loop-keybinds.json"
    assert_file_exist "${LOOP_DIR}/loop-settings.json"
    run python3 -c '
import json, sys
keybinds = json.load(open(sys.argv[1] + "/loop-keybinds.json"))
settings = json.load(open(sys.argv[1] + "/loop-settings.json"))
assert keybinds["actions"] and keybinds["triggerKey"]
state = {"keybinds", "trigger", "stashManagerStashed", "timesLooped"}
bad = [k for k in settings if k in state or k.startswith("NS") or k.endswith("synchronizeTimestamp")]
assert not bad, bad
' "${LOOP_DIR}"
    assert_success
}
