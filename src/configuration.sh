#!/bin/bash

function run_follower_setup() {

  # Also ensures SSH is started at boot on Follower.
  configure_tor_to_start_at_boot

  # # Also ensures SSH is started at boot on Follower.
  # ensure_service_is_started "tor"

  # Create onion domain on Follower.
  setup_onion_domain "--ssh" "--random"

  # Also ensures SSH is started at boot on Follower.
  configure_tor_to_start_at_boot

  NOTICE "You can reach this machine via SSH at onion domain: \n\n"
  setup_onion_domain "--ssh" "--get-onion"
  echo ""
  echo ""
}

function run_leader_setup() {
  local follower_ubuntu_username="$1"
  local follower_local_ip="$2"
  local follower_ubuntu_password="$3"
  local ssh_port="$4"
  # Ensure the Follower Ubuntu password is available.
  if [ -z "$follower_ubuntu_password" ]; then
    echo "Please enter the Ubuntu password of your Follower machine, to log into it through ssh, and press enter."
    read -rs follower_ubuntu_password
    echo "Password entered."
  fi

  local final_ssh_port
  final_ssh_port=$(ensure_ssh_port_is_got "$ssh_port")

  # Satisfy prerequisites
  ensure_ssh_is_started_at_boot

  # Ensure ssh is installed on Leader.
  # Generates the private and public key pair on Leader.
  # Adds the SSH key to the ssh-agent on Leader.
  setup_ssh_on_this_device "$DEVICE_SSH_DIR" "$DEVICE_SSH_PRIVATE_KEY_FILENAME"

  # Assert the user can SSH into Follower using username and ip-address.
  ensure_apt_pkg "sshpass" 1
  assert_can_locally_ssh_with_pwd "$follower_ubuntu_username" "$follower_local_ip" "$final_ssh_port" "$follower_ubuntu_password"

  # Add the public key from Leader into authorised SSH public keys in Follower.
  add_public_key_from_leader_into_follower_authorized_keys "$follower_ubuntu_username" "$follower_local_ip" "$final_ssh_port" "$PATH_TO_LOCAL_LEADER_PUBLIC_KEY" "$follower_ubuntu_password"

  # TODO: Start the Tor service at boot on Follower.

  # TODO: Return the onion domain of Follower back into Leader.
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
  # Parse the CLI arguments for this module.
  local follower_ubuntu_password
  declare -a parsed_args
  mapfile -t parsed_args < <(parse_bash_ssh_over_tor_args "$@")
  local follower_ubuntu_username="${parsed_args[0]}"
  local follower_local_ip="${parsed_args[1]}"
  local follower_ubuntu_password="${parsed_args[2]}"
  local ssh_port="${parsed_args[3]}"
  local is_on_follower="${parsed_args[4]}"
  local is_on_leader="${parsed_args[5]}"

  if [ "$is_on_follower" == "true" ]; then
    run_follower_setup
  elif [ "$is_on_leader" == "true" ]; then
    run_leader_setup "$follower_ubuntu_username" "$follower_local_ip" "$follower_ubuntu_password" "$ssh_port"
  fi
}
