#!/usr/bin/env bash

pip_remove() {
  local pip_package_name="$1"

  INFO "Removing ${pip_package_name} if it is installed."

  pip uninstall "$pip_package_name" -y >>/dev/null 2>&1

  assert_pip_removed "$pip_package_name"
}

# Verifies pip package is installed.
assert_pip_removed() {
  local pip_package_name="$1"

  # Determine if pip package is installed or not.
  local pip_pckg_exists
  pip_pckg_exists=$(
    pip list | grep -F "$pip_package_name"
    echo $?
  )

  # Throw error if pip package is not yet installed.
  if [ "$pip_pckg_exists" == "1" ]; then
    NOTICE "Verified pip package ${pip_package_name} is removed."

  else
    ERROR "Error, the pip package ${pip_package_name} is still installed."
    exit 3 # TODO: update exit status.
  fi
}
