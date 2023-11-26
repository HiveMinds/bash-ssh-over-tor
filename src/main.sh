#!/bin/bash

source "dependencies/bash-log/src/main.sh"

function load_functions() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # shellcheck disable=SC1091
  source "$script_dir/parsing_helper.sh"

  # Get the path towards this src dir.
  # script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # shellcheck disable=SC1091
  source "$script_dir/installation/install_apt.sh"
  # shellcheck disable=SC1091
  source "$script_dir/installation/install_pip.sh"
  # shellcheck disable=SC1091
  source "$script_dir/installation/install_snap.sh"

  # shellcheck disable=SC1091
  source "$script_dir/uninstallation/uninstall_apt.sh"
  # shellcheck disable=SC1091
  source "$script_dir/uninstallation/uninstall_pip.sh"
  # shellcheck disable=SC1091
  source "$script_dir/uninstallation/uninstall_snap.sh"
}
load_functions
