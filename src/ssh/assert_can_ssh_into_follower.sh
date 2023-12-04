#!/bin/bash

can_locally_ssh_into_follower_over_wan_or_lan_with_pwd() {
  local follower_ubuntu_username="$1"
  local follower_local_ip="$2"
  local ssh_port="$3"
  local follower_ubuntu_password="$4"
  local status
  # Try SSH connection using sshpass and capture the exit status
  sshpass -p "$follower_ubuntu_password" ssh -p "$ssh_port" -o ConnectTimeout=5 "$follower_ubuntu_username@$follower_local_ip" echo "SSH test connection" >/dev/null 2>&1
  status="$?"
  return "$status" # 0 on success, 1 on failure
}

can_locally_ssh_into_follower_over_wan_or_lan_with_public_key() {
  local follower_ubuntu_username="$1"
  local follower_local_ip="$2"
  local ssh_port="$3"
  local follower_ubuntu_password="$4"
  local status

  # Re-add the private key to the ssh-agent within this function.
  eval "$(ssh-agent -s)"
  ssh-add "$PATH_TO_LOCAL_LEADER_PRIVATE_KEY"
  # Try SSH connection using sshpass and capture the exit status
  ssh -p "$ssh_port" -o ConnectTimeout=5 "$follower_ubuntu_username@$follower_local_ip" echo "SSH test connection" >/dev/null 2>&1
  status="$?"
  return "$status" # 0 on success, 1 on failure
}

can_ssh_into_follower_over_tor_with_public_key() {
  local follower_ubuntu_username="$1"
  local onion_domain="$2"
  local ssh_port="$3"
  local follower_ubuntu_password="$4"
  local status

  # Re-add the private key to the ssh-agent within this function.
  eval "$(ssh-agent -s)"
  ssh-add "$PATH_TO_LOCAL_LEADER_PRIVATE_KEY"
  # Try SSH connection using sshpass and capture the exit status
  #torify ssh -p "$ssh_port" -o ConnectTimeout=25 "$follower_ubuntu_username@$onion_domain" echo "SSH test connection" >/dev/null 2>&1
  torsocks ssh -p "$ssh_port" -o ConnectTimeout=25 "$follower_ubuntu_username@$onion_domain" echo "SSH test connection"

  status="$?"
  return "$status" # 0 on success, 1 on failure
}

assert_can_locally_ssh_with_pwd() {
  local follower_ubuntu_username="$1"
  local follower_local_ip="$2"
  local ssh_port="$3"
  local follower_ubuntu_password="$4"

  can_locally_ssh_into_follower_over_wan_or_lan_with_pwd "$follower_ubuntu_username" "$follower_local_ip" "$ssh_port" "$follower_ubuntu_password"

  # Check the output of the previous command to see if it was successful.
  # shellcheck disable=SC2181
  if [ "$?" -eq 0 ]; then
    NOTICE "Accessing Follower over local WiFi or Lan via SSH with password was successful"
  else
    command="sshpass -p <your Follower Ubuntu password> ssh -p $ssh_port -o ConnectTimeout=5 $follower_ubuntu_username@$follower_local_ip echo \"SSH test connection\""
    ERROR "Accessing Follower over local WiFi or Lan via SSH with password failed on command:"
    NOTICE "$command"

    exit 1
  fi
}

assert_can_locally_ssh_with_public_key() {
  local follower_ubuntu_username="$1"
  local follower_local_ip="$2"
  local ssh_port="$3"
  local follower_ubuntu_password="$4"
  #add_public_client_key_to_ssh_agent_of_this_device "$DEVICE_SSH_DIR" "$DEVICE_SSH_PRIVATE_KEY_FILENAME"

  can_locally_ssh_into_follower_over_wan_or_lan_with_public_key "$follower_ubuntu_username" "$follower_local_ip" "$ssh_port" "$follower_ubuntu_password"

  # Check the output of the previous command to see if it was successful.
  # shellcheck disable=SC2181
  if [ "$?" -eq 0 ]; then
    NOTICE "Accessing Follower over local WiFi or Lan via SSH with public key was successful"
  else
    command="ssh -p $ssh_port -o ConnectTimeout=5 $follower_ubuntu_username@$follower_local_ip echo \"SSH test connection\""
    ERROR "Accessing Follower over local WiFi or Lan via SSH with public key failed on command:"
    NOTICE "$command"

    exit 1
  fi
}

assert_can_ssh_into_follower_with_public_key_over_tor() {
  local follower_ubuntu_username="$1"
  local onion_domain="$2"
  local ssh_port="$3"
  local follower_ubuntu_password="$4"
  assert_is_non_empty_string "$follower_ubuntu_username"
  assert_is_non_empty_string "$onion_domain"
  assert_is_non_empty_string "$ssh_port"
  assert_is_non_empty_string "$follower_ubuntu_password"

  can_ssh_into_follower_over_tor_with_public_key "$follower_ubuntu_username" "$onion_domain" "$ssh_port" "$follower_ubuntu_password"

  # Check the output of the previous command to see if it was successful.
  # shellcheck disable=SC2181
  if [ "$?" -eq 0 ]; then
    NOTICE "Accessing Follower over tor via SSH with public key was successful"
  else
    command="torsocks ssh -p $ssh_port -o ConnectTimeout=25 $follower_ubuntu_username@$onion_domain echo \"SSH test connection\""
    ERROR "Accessing Follower over local WiFi or Lan via SSH with public key failed on command:"
    NOTICE "$command"
    exit 1
  fi
}

create_private_public_ssh_key_on_this_device() {
  local device_ssh_dir="$1"
  local device_ssh_private_key_filename="$2"

  # Delete ssh keys if they already exist.
  rm -f "$device_ssh_dir/$device_ssh_private_key_filename"
  rm -f "$device_ssh_dir/$device_ssh_private_key_filename.pub"
  # TODO: files do not exist.

  NOTICE "Creating a private and public key on this device."
  # TODO: redirect output to proper logging tool.
  ssh-keygen -b 4096 -t rsa -f "$device_ssh_dir/$device_ssh_private_key_filename" -q -N "" >>/dev/null 2>&1
  NOTICE "Done creating a private and public key on this device."

  manual_assert_file_exists "$device_ssh_dir/$device_ssh_private_key_filename"
}
