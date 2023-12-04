#!/bin/bash

assert_is_non_empty_string() {
  local string="$1"
  if [ "${string}" == "" ]; then
    ERROR "Error, the incoming string was empty."
    exit 70
  fi
}

# Function to assert file content
assert_file_content_equal() {
  local file_path="$1"
  local expected_content="$2"

  # Read the content of the file into a variable
  local file_content
  file_content=$(<"$file_path")

  # Compare the content of the file with the expected content
  if [ "$file_content" != "$expected_content" ]; then
    ERROR "File content does not match the expected content."
    exit 1 # Or perform any other action as needed
  fi
}
