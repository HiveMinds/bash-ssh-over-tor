#!/bin/bash

# Store arguments and then consume them to prevent the $@ argument from being
# parsed in the wrong parser that is loaded through another main.sh file.
CLI_ARGS_SSH_OVER_TOR=("$@")
while [ "$#" -gt 0 ]; do
  shift # Shift the arguments to move to the next one
done

# This module is a dependency for:
# - bash-create-onion-domains
# This module has dependencies:
# - bash-log
# - bash-package-installer
# - bash-start-tor-at-boot
# - bash-create-onion-domains

SSH_OVER_TOR_SRC_PATH=$(dirname "$(readlink -f "$0")")
SSH_OVER_TOR_PATH=$(readlink -f "$SSH_OVER_TOR_SRC_PATH/../")

function load_dependencies() {
  local dependency_or_parent_path
  # The path of this repo ends in /bash-create-onion-domains. If it follows:
  # /dependencies/bash-create-onion-domains, then it is a dependency of
  #another module.
  echo "SSH_OVER_TOR_PATH=$SSH_OVER_TOR_PATH"
  if [[ "$SSH_OVER_TOR_PATH" == *"/dependencies/bash-create-onion-domains" ]]; then
    # This module is a dependency of another module.
    dependency_or_parent_path=".."
  else
    dependency_or_parent_path="dependencies"
  fi
  echo "dependency_or_parent_path=$dependency_or_parent_path"
  load_required_dependencies "$dependency_or_parent_path"
  load_parent_dependencies "$dependency_or_parent_path"
}

function load_required_dependency() {
  local dependency_or_parent_path="$1"
  local dependency_name="$2"
  local dependency_dir="$SSH_OVER_TOR_PATH/$dependency_or_parent_path/$dependency_name"
  echo "dependency_dir=$dependency_dir"
  if [ ! -d "$dependency_dir" ]; then
    echo "ERROR: $dependency_dir is not found in required dependencies."
    exit 1
  fi
  source "$dependency_dir/src/main.sh"
}

function load_required_dependencies() {
  local dependency_or_parent_path="$1"
  local required_dependencies=("bash-log" "bash-package-installer" "bash-start-tor-at-boot")
  # Iterate through dependencies and check if they exist and load them.
  for required_dependency in "${required_dependencies[@]}"; do
    load_required_dependency "$dependency_or_parent_path" "$required_dependency"
  done
}

function load_parent_dependencies() {
  local dependency_or_parent_path="$1"
  local parent_dependencies=("bash-create-onion-domains")
  # Iterate through dependencies and check if they exist and load them.
  for parent_dep in "${parent_dependencies[@]}"; do
    local parent_dep_dir="$SSH_OVER_TOR_PATH/../$parent_dep"
    echo "parent_dep_dir=$parent_dep_dir"
    # Check if the parent repo above the dependency dir is the parent dependency.
    if [ ! -d "$SSH_OVER_TOR_PATH/../$parent_dep" ]; then
      # Must load the dependency as any other fellow dependency if it is not
      # a parent dependency.
      load_required_dependency "$dependency_or_parent_path" "$required_dependency"
    else
      # Load the parent dependency.
      # shellcheck disable=SC1090
      source "$SSH_OVER_TOR_PATH/../$parent_dep/src/main.sh"
    fi

  done
}

load_dependencies
LOG_LEVEL_ALL # set log level to all, otherwise, NOTICE, INFO, DEBUG, TRACE will not be logged.
B_LOG --file log/multiple-outputs.txt --file-prefix-enable --file-suffix-enable

# Load prerequisites installation.
function load_functions() {

  # shellcheck disable=SC1091
  source "$SSH_OVER_TOR_SRC_PATH/GLOBAL_VARS.sh"

  # shellcheck disable=SC1091
  source "$SSH_OVER_TOR_SRC_PATH/ssh/setup_ssh_on_leader.sh"

  # shellcheck disable=SC1091
  source "$SSH_OVER_TOR_SRC_PATH/configuration.sh"

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
