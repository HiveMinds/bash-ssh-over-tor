#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

# Load the script under test
load ../src/main.sh

@test "Verify log output of apt install function." {
  LOG_LEVEL_ALL # set log level to all, otherwise, NOTICE, INFO, DEBUG, TRACE will not be logged.

  local log_output=$(ensure_apt_pkg "pacman")
  echo "log_output=$log_output"
  local is_installed_msg="[NOTICE][ensure_apt_pkg:16 ]  pacman is installed"
  # Assert log output contains substring.
  [[ "$log_output" == *"$is_installed_msgsubstring"* ]]

  local verified_is_installed_msg="[NOTICE][verify_apt_installed:42 ] Verified apt package pacman is installed."
  # Assert log output contains substring.
  [[ "$log_output" == *"$is_installed_msgsubstring"* ]]

  local log_output=$(apt_remove "pacman")
  echo "log_output=$log_output"
  local substring="[NOTICE][verify_apt_removed:38 ] Verified the apt package pacman is removed."
  # Assert log output contains substring.
  [[ "$log_output" == *"$substring"* ]]
}
