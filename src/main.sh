#!/bin/bash

# Load the installer dependency.
source dependencies/bash-package-installer/src/main.sh
source dependencies/bash-log/src/main.sh
source dependencies/bash-start-tor-at-boot/src/main.sh
source dependencies/bash-create-onion-domains/src/main.sh
source dependencies/bash-start-tor-at-boot/src/GLOBAL_VARS.sh # Superfluous
LOG_LEVEL_ALL                                                 # set log level to all, otherwise, NOTICE, INFO, DEBUG, TRACE will not be logged.
B_LOG --file log/multiple-outputs.txt --file-prefix-enable --file-suffix-enable

# Load prerequisites installation.
function load_functions() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # shellcheck disable=SC1091
  source "$script_dir/GLOBAL_VARS.sh"

  # shellcheck disable=SC1091
  source "$script_dir/ssh/setup_ssh_on_leader.sh"

  # shellcheck disable=SC1091
  source "$script_dir/configuration.sh"

  # shellcheck disable=SC1091
  source "$script_dir/helper_parsing.sh"

  # shellcheck disable=SC1091
  source "$script_dir/ssh/setup_ssh_public_private_key_access.sh"

  # shellcheck disable=SC1091
  source "$script_dir/ssh/assert_can_ssh_into_follower.sh"

  # shellcheck disable=SC1091
  source "$script_dir/parse_bash_ssh_over_tor_args.sh"

  # shellcheck disable=SC1091
  source "$script_dir/ssh/add_public_key_from_leader_into_follower_authorized_keys.sh"

}
load_functions
start_config_at_leader "$@"
