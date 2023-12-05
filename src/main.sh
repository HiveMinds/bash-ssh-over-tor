#!/bin/bash

export bash_ssh_over_tor_is_loaded=true

# Store arguments and then consume them to prevent the $@ argument from being
# parsed in the wrong parser that is loaded through another main.sh file.
CLI_ARGS_SSH_OVER_TOR=("$@")
while [ "$#" -gt 0 ]; do
  shift # Shift the arguments to move to the next one
done

# This module is a dependency for:
SSH_OVER_TOR_PARENT_DEPS=("bash-create-onion-domains")
# This module has dependencies:
SSH_OVER_TOR_REQUIRED_DEPS=("bash-log" "bash-package-installer" "bash-start-tor-at-boot")

SSH_OVER_TOR_SRC_PATH=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
SSH_OVER_TOR_PATH=$(readlink -f "$SSH_OVER_TOR_SRC_PATH/../")

# Loads the bash log dependency, and the dependency loader.
function load_dependency_manager() {
  if [ -d "$SSH_OVER_TOR_PATH/dependencies/bash-log" ]; then
    # shellcheck disable=SC1091
    source "$SSH_OVER_TOR_PATH/dependencies/bash-log/src/dependency_manager.sh"
  elif [ -d "$SSH_OVER_TOR_PATH/../bash-log" ]; then
    # shellcheck disable=SC1091
    source "$SSH_OVER_TOR_PATH/../bash-log/src/main.sh"
  else
    echo "ERROR: bash-log dependency is not found."
    exit 1
  fi
}
load_dependency_manager
# Load required dependencies.
for required_dependency in "${SSH_OVER_TOR_REQUIRED_DEPS[@]}"; do
  load_required_dependency "$SSH_OVER_TOR_PATH" "$required_dependency"
done

# Load dependencies that can be a parent dependency (=this module is a
# dependency of that module/dependency).
for parent_dep in "${SSH_OVER_TOR_PARENT_DEPS[@]}"; do
  load_parent_dependency "$SSH_OVER_TOR_PATH" "$parent_dep"
done

LOG_LEVEL_ALL # set log level to all, otherwise, NOTICE, INFO, DEBUG, TRACE will not be logged.
B_LOG --file log/multiple-outputs.txt --file-prefix-enable --file-suffix-enable

NOTICE "Loading from:$SSH_OVER_TOR_SRC_PATH"
# Load prerequisites installation.
function load_functions() {

  # shellcheck disable=SC1091
  source "$SSH_OVER_TOR_SRC_PATH/GLOBAL_VARS.sh"

  # shellcheck disable=SC1091
  source "$SSH_OVER_TOR_SRC_PATH/ssh/setup_ssh_on_leader.sh"

  # shellcheck disable=SC1091
  source "$SSH_OVER_TOR_SRC_PATH/configuration.sh"

  NOTICE "LOADING:$SSH_OVER_TOR_SRC_PATH/helper_parsing.sh"
  # shellcheck disable=SC1091
  source "$SSH_OVER_TOR_SRC_PATH/helper_parsing.sh"

  # shellcheck disable=SC1091
  source "$SSH_OVER_TOR_SRC_PATH/ssh/setup_ssh_public_private_key_access.sh"

  # shellcheck disable=SC1091
  source "$SSH_OVER_TOR_SRC_PATH/ssh/assert_can_ssh_into_follower.sh"

  # shellcheck disable=SC1091
  source "$SSH_OVER_TOR_SRC_PATH/parse_bash_ssh_over_tor_args.sh"

  # shellcheck disable=SC1091
  source "$SSH_OVER_TOR_SRC_PATH/ssh/add_public_key_from_leader_into_follower_authorized_keys.sh"

}
load_functions
start_config_at_leader "${CLI_ARGS_SSH_OVER_TOR[@]}"
