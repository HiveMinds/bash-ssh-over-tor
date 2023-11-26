#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

# Load the script under test
load ../src/main.sh

@test "Verify log output of pip install function." {
  LOG_LEVEL_ALL # set log level to all, otherwise, NOTICE, INFO, DEBUG, TRACE will not be logged.

  local log_output=$(ensure_pip_pkg "twine")
  echo "log_output=$log_output"
  local is_installed_msg="[NOTICE][ensure_pip_pkg:24 ]  twine is installed"
  # Assert log output contains substring.
  [[ "$log_output" == *"$is_installed_msgsubstring"* ]]

  local verified_is_installed_msg="[NOTICE][verify_pip_installed:51 ] Verified pip package twine is installed."
  # Assert log output contains substring.
  [[ "$log_output" == *"$is_installed_msgsubstring"* ]]

  local log_output=$(pip_remove "twine")
  echo "log_output=$log_output"
  local substring="[NOTICE][assert_pip_removed:26 ] Verified pip package twine is removed."
  # Assert log output contains substring.
  [[ "$log_output" == *"$substring"* ]]
}
