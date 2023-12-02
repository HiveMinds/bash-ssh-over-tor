#!/bin/bash

#can_locally_ssh_into_follower_over_wan_or_lan() {
#  local follower_ubuntu_username="$1"
#  local follower_local_ip="$2"
#  local follower_ubuntu_password="$3"
#
#  ssh "$follower_ubuntu_username"@"$follower_local_ip"
#
#}

can_locally_ssh_into_follower_over_wan_or_lan() {
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

assert_can_locally_ssh() {
  local follower_ubuntu_username="$1"
  local follower_local_ip="$2"
  local ssh_port="$3"
  local follower_ubuntu_password="$4"

  can_locally_ssh_into_follower_over_wan_or_lan "$follower_ubuntu_username" "$follower_local_ip" "$ssh_port" "$follower_ubuntu_password"

  # Check the output of the previous command to see if it was successful.
  # shellcheck disable=SC2181
  if [ "$?" -eq 0 ]; then
    NOTICE "Accessing Follower over local WiFi or Lan via SSH was successful"
  else
    ERROR "Accessing Follower over local WiFi or Lan via SSH failed."
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

# This makes sure your client can show the server it should get access.
add_public_client_key_to_ssh_agent_of_this_device() {
  local device_ssh_dir="$1"
  local device_ssh_private_key_filename="$2"

  # Assert the private and public ssh key are created on client.
  manual_assert_file_exists "$device_ssh_dir/$device_ssh_private_key_filename"

  NOTICE "Starting SSH agent on this device."
  # Start the ssh-agent in the background and prepare it for receiving
  # your client's ssh private key.
  eval "$(ssh-agent -s)"
  NOTICE "Adding private and public key pair:$device_ssh_dir/$device_ssh_private_key_filename to ssh agent of this device."

  # Add your client's ssh private key to the client ssh-agent.
  # TODO: redirect output to proper logging tool.
  ssh-add "$CLIENT_SSH_DIR$CLIENT_SSH_KEY_NAME" >>/dev/null 2>&1
  NOTICE "Done adding public key: to ssh agent of this device"
  # TODO: Assert the ssh-key is added to the agent on this device.
}
