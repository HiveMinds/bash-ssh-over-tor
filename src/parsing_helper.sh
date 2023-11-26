#!/bin/bash

# Description:
# Verifies whether a specified substring is present within the output of a given command.
# Parameters:
#   substring (string): The substring to be checked within the command output.
#   command_output (string): Output from the executed command to search for the substring.
# Returns:
#   FOUND (string): If the substring is found within the command output.
#   NOTFOUND (string): If the substring is not found within the command output.
# Usage Example:
#   command_output_contains "search_string" "$(some_command)"
# Notes:
# - Ensure proper quoting of parameters to handle spaces and special characters.
# - This function aids in checking specific patterns or strings within command outputs.
# Considerations:
# - Avoid using this function in performance-critical scenarios due to potential overhead from command output buffering.
# TODO: move into separate submodule repo for parsing.
function command_output_contains() {
  local substring="$1"
  shift
  local command_output

  # shellcheck disable=SC2124 # TODO: remove need for this shellcheck disable.
  command_output="$@" # Capture command output securely

  if grep -q "$substring" <<<"$command_output"; then
    echo "FOUND"
  else
    echo "NOTFOUND"
  fi
}
