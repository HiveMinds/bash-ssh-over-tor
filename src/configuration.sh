#!/bin/bash

function start_config_at_leader() {
  ensure_ssh_is_started_at_boot
  # Ensure ssh is installed on Leader.
  # Generates the private and public key pair on Leader.
  # Adds the SSH key to the ssh-agent on Leader.
  setup_ssh_on_this_device "$DEVICE_SSH_DIR" "$DEVICE_SSH_PRIVATE_KEY_FILENAME"

  local follower_ubuntu_password
  declare -a parsed_args
  mapfile -t parsed_args < <(parse_bash_ssh_over_tor_args "$@")
  local follower_ubuntu_username="${parsed_args[0]}"
  local follower_local_ip="${parsed_args[1]}"
  local follower_ubuntu_password="${parsed_args[2]}"
  local ssh_port="${ssh_port[3]}"
  local is_on_follower="${parsed_args[4]}"
  if [ "$is_on_follower" == "true" ]; then
    ERROR "This script is running on the Follower machine."
    exit 0
  fi
  if [ -z "$follower_ubuntu_password" ]; then
    echo "Please enter the Ubuntu password of your Follower machine, to log into it through ssh, and press enter."
    read -rs follower_ubuntu_password
    echo "Password entered."
  fi
  if [ "$ssh_port" == "" ]; then
    ssh_port="22"
  fi

  # Assert the user can SSH into Follower using username and ip-address.
  ensure_apt_pkg "sshpass" 1
  assert_can_locally_ssh "$follower_ubuntu_username" "$follower_local_ip" "$ssh_port" "$follower_ubuntu_password"

  local device_name
  local follower_auth_keys_storage_filename_with_ext
  follower_auth_keys_storage_filename_with_ext="$device_name-$(whoami)-$DEVICE_SSH_PRIVATE_KEY_FILENAME.pub"
  # SSH into Follower and copy the public key from Leader into Follower.
  copy_public_key_to_follower "$follower_ubuntu_username" "$follower_local_ip" "$ssh_port" "$PATH_TO_LOCAL_LEADER_PUBLIC_KEY" "$follower_ubuntu_password" "$PATH_TO_LOCAL_FOLLOWER_AUTHORIZED_KEYS_DIR" "$follower_auth_keys_storage_filename_with_ext"

  # Add the Leader public key to the authorized_keys file on Follower.
  add_public_key_from_leader_into_follower_authorized_keys "$follower_ubuntu_username" "$follower_local_ip" "$ssh_port" "$PATH_TO_LOCAL_LEADER_PUBLIC_KEY" "$follower_ubuntu_password" "$PATH_TO_LOCAL_FOLLOWER_AUTHORIZED_KEYS_DIR" "$follower_auth_keys_storage_filename_with_ext"

  # TODO: Start the Tor service at boot on Follower.

  # TODO: Return the onion domain of Follower back into Leader.
  echo "Hello World."
}
