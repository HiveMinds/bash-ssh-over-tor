#!/bin/bash

# Load the installer dependency.
source dependencies/bash-package-installer/src/main.sh
source dependencies/bash-log/src/main.sh
source dependencies/bash-start-tor-at-boot/src/main.sh
source dependencies/bash-start-tor-at-boot/src/GLOBAL_VARS.sh # Superfluous
LOG_LEVEL_ALL                                                 # set log level to all, otherwise, NOTICE, INFO, DEBUG, TRACE will not be logged.

# Load prerequisites installation.
function load_functions() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # shellcheck disable=SC1091
  source "$script_dir/installation.sh"
  # shellcheck disable=SC1091
  source "$script_dir/configuration.sh"

}
load_functions

# Execute prerequisites installation.
install_ssh_requirements

configure_tor
