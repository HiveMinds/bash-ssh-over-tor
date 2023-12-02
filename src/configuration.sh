#!/bin/bash

function check_if_is_ran_on_follower() {
  local is_on_follower="$1"
  if [ "$is_on_follower" == "true" ]; then
    ensure_ssh_is_started_at_boot
    exit 0
  fi
}

function ensure_ssh_port_is_got() {
  local arg_ssh_port="$1"
  if [ "$arg_ssh_port" == "" ]; then
    arg_ssh_port="22"
    echo "22"
  else
    echo "$arg_ssh_port"
  fi

}
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
  local ssh_port="${parsed_args[3]}"
  local is_on_follower="${parsed_args[4]}"

  # Ensure the Follower Ubuntu password is available.
  if [ -z "$follower_ubuntu_password" ]; then
    echo "Please enter the Ubuntu password of your Follower machine, to log into it through ssh, and press enter."
    read -rs follower_ubuntu_password
    echo "Password entered."
  fi

  check_if_is_ran_on_follower "$is_on_follower"
  local final_ssh_port
  final_ssh_port=$(ensure_ssh_port_is_got "$ssh_port")

  # Assert the user can SSH into Follower using username and ip-address.
  ensure_apt_pkg "sshpass" 1
  assert_can_locally_ssh "$follower_ubuntu_username" "$follower_local_ip" "$final_ssh_port" "$follower_ubuntu_password"

  local device_name
  local follower_auth_keys_storage_filename_with_ext
  follower_auth_keys_storage_filename_with_ext="$device_name-$(whoami)-$DEVICE_SSH_PRIVATE_KEY_FILENAME.pub"
  # SSH into Follower and copy the public key from Leader into Follower.
  copy_public_key_to_follower "$follower_ubuntu_username" "$follower_local_ip" "$final_ssh_port" "$PATH_TO_LOCAL_LEADER_PUBLIC_KEY" "$follower_ubuntu_password" "$PATH_TO_LOCAL_FOLLOWER_AUTHORIZED_KEYS_DIR" "$follower_auth_keys_storage_filename_with_ext"

  # Add the Leader public key to the authorized_keys file on Follower.
  add_public_key_from_leader_into_follower_authorized_keys "$follower_ubuntu_username" "$follower_local_ip" "$final_ssh_port" "$PATH_TO_LOCAL_LEADER_PUBLIC_KEY" "$follower_ubuntu_password" "$PATH_TO_LOCAL_FOLLOWER_AUTHORIZED_KEYS_DIR" "$follower_auth_keys_storage_filename_with_ext"

  # TODO: Start the Tor service at boot on Follower.

  # TODO: Return the onion domain of Follower back into Leader.
  echo "Hello World."
}
