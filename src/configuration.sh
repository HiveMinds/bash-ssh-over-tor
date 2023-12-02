#!/bin/bash

function start_config_at_leader() {
  local device_ssh_key_filename="client_ssh"
  local device_ssh_dir
  device_ssh_dir="/home/$(whoami)/.ssh/"

  ensure_ssh_is_started_at_boot
  # Ensure ssh is installed on Leader.
  # Generates the private and public key pair on Leader.
  # Adds the SSH key to the ssh-agent on Leader.
  setup_ssh_on_this_device "$device_ssh_dir" "$device_ssh_key_filename"

  local follower_ubuntu_password
  declare -a parsed_args
  mapfile -t parsed_args < <(parse_bash_ssh_over_tor_args "$@")
  local follower_username="${parsed_args[0]}"
  local follower_local_ip_address="${parsed_args[1]}"
  local follower_ubuntu_password="${parsed_args[2]}"
  local is_on_follower="${parsed_args[3]}"
  if [ "$is_on_follower" == "true" ]; then
    ERROR "This script is running on the Follower machine."
    exit 0
  fi
  if [ -z "$follower_ubuntu_password" ]; then
    echo "Please enter the Ubuntu password of your Follower machine, to log into it through ssh, and press enter."
    read -rs follower_ubuntu_password
    echo "Password entered."
  fi

  # Assert the user can SSH into Follower using username and ip-address.
  ensure_apt_pkg "sshpass" 1
  assert_can_locally_ssh "$follower_username" "$follower_local_ip_address" "$follower_ubuntu_password"

  # SSH into Follower and copy the public key from Leader into Follower.
  copy_public_key_to_follower

  # Add the Leader public key to the authorized_keys file on Follower.
  add_public_key_from_leader_into_follower_authorized_keys

  # TODO: Start the Tor service at boot on Follower.

  # TODO: Return the onion domain of Follower back into Leader.
  echo "Hello World."
}
