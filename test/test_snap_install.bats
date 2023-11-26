#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

# Load the script under test
load ../src/main.sh

@test "Verify log output of snap install function." {
  LOG_LEVEL_ALL # set log level to all, otherwise, NOTICE, INFO, DEBUG, TRACE will not be logged.

  local log_output=$(ensure_snap_pkg "hello-world")
  echo "log_output=$log_output"
  local is_installed_msg="[INFO  ][ensure_snap_pkg:12 ]  hello-world is not installed. Installing now."
  # Assert log output contains substring.
  [[ "$log_output" == *"$is_installed_msgsubstring"* ]]

  local verified_is_installed_msg="[NOTICE][verify_snap_installed:30 ] Verified snap package hello-world is installed."
  # Assert log output contains substring.
  [[ "$log_output" == *"$is_installed_msgsubstring"* ]]

  local log_output=$(snap_remove "hello-world")
  echo "log_output=$log_output"
  local substring="[INFO  ][snap_remove:8  ] Removing hello-world if it is installed."
  # Assert log output contains substring.
  [[ "$log_output" == *"$substring"* ]]

  echo "log_output=$log_output"
  local substring="[verify_snap_removed:29 ] Verified the snap package hello-world is removed."
  # Assert log output contains substring.
  [[ "$log_output" == *"$substring"* ]]
}
