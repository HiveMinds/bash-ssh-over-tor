#!/bin/bash

# Load the installer dependency.
source dependencies/bash-package-installer/src/main.sh
source dependencies/bash-log/src/main.sh
LOG_LEVEL_ALL # set log level to all, otherwise, NOTICE, INFO, DEBUG, TRACE will not be logged.

# Load prerequisites installation.
function load_functions() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # shellcheck disable=SC1091
  source "$script_dir/GLOBAL_VARS.sh"

  # shellcheck disable=SC1091
  source "$script_dir/configuration/activate_systemct_services.sh"
  # shellcheck disable=SC1091
  source "$script_dir/configuration/uwf_status.sh"
  # shellcheck disable=SC1091
  source "$script_dir/installation.sh"
  # shellcheck disable=SC1091
  source "$script_dir/configuration.sh"

  # Load tor helper functions.
  # shellcheck disable=SC1091
  source "$script_dir/tor_status/create_tor_connection.sh"
  # shellcheck disable=SC1091
  source "$script_dir/tor_status/tor_status.sh"
  # shellcheck disable=SC1091
  source "$script_dir/tor_status/verify_https_onion_is_available.sh"

  # Load onion domain helper functions.
  # shellcheck disable=SC1091
  source "$script_dir/onion_domain/make_onion_domain.sh"
  # shellcheck disable=SC1091
  source "$script_dir/onion_domain/onion_domain_exists.sh"

  # Load parsing helper functions.
  # shellcheck disable=SC1091
  source "$script_dir/parsing/file_editing.sh"

  # Load file_editing helper functions.
  # shellcheck disable=SC1091
  source "$script_dir/verification/assert_not_exist.sh"
  # shellcheck disable=SC1091
  source "$script_dir/verification/assert_exists.sh"

  # shellcheck disable=SC1091
  source "$script_dir/configuration.sh"

}
load_functions

# Execute prerequisites installation.
install_ssh_requirements

configure_tor
