#!/bin/bash

#######################################
#
# Local variables:
#
# Globals:
#  None.
# Arguments:
#
# Returns:
#  0 if
#  7 if
# Outputs:
#  None.
#######################################
# Structure:Parsing
# allows a string with spaces, hence allows a line
file_contains_string() {
  local some_string="$1"
  local relative_filepath="$2"
  local use_sudo="$3"

  if [[ "$use_sudo" == "true" ]]; then
    if sudo grep -q "$some_string" "$relative_filepath"; then
      echo "FOUND"
    else
      echo "NOTFOUND"
    fi
  else
    if grep -q "$some_string" "$relative_filepath"; then
      echo "FOUND"
    else
      echo "NOTFOUND"
    fi
  fi
}
