#!/usr/bin/env bats

load '../test_helper.bats'

@test "run_once_macos.sh exists" {
    assert_file_exist "${BATS_TEST_DIRNAME}/../../run_once_macos.sh"
}

@test "run_once_install-packages.sh exists" {
    assert_file_exist "${BATS_TEST_DIRNAME}/../../run_once_install-packages.sh"
}

@test "run_once_macos.sh is bash parse-clean" {
    run bash -n "${BATS_TEST_DIRNAME}/../../run_once_macos.sh"
    assert_success
}

@test "run_once_install-packages.sh is bash parse-clean" {
    run bash -n "${BATS_TEST_DIRNAME}/../../run_once_install-packages.sh"
    assert_success
}

@test "run_once_macos.sh has executable permissions" {
    assert_file_executable "${BATS_TEST_DIRNAME}/../../run_once_macos.sh"
}

@test "run_once_install-packages.sh has executable permissions" {
    assert_file_executable "${BATS_TEST_DIRNAME}/../../run_once_install-packages.sh"
}