#!/bin/bash

setup_ssh_on_this_device() {
  local device_ssh_dir="$1"
  local device_ssh_key_filename="$2"

  # TODO: Assert SSH is installed on this device.
  # TODO: Assert SSH is running on this device.

  create_private_public_ssh_key_on_this_device "$device_ssh_dir" "$device_ssh_key_filename"

  add_public_client_key_to_ssh_agent_of_this_device "$device_ssh_dir" "$device_ssh_key_filename"

}

create_private_public_ssh_key_on_this_device() {
  local device_ssh_dir="$1"
  local device_ssh_key_filename="$2"

  # Delete ssh keys if they already exist.
  rm -f "$device_ssh_dir$device_ssh_key_filename"
  rm -f "$device_ssh_dir$device_ssh_key_filename.pub"
  # TODO: files do not exist.

  NOTICE "Creating a private and public key on this device."
  # TODO: redirect output to proper logging tool.
  ssh-keygen -b 4096 -t rsa -f "$device_ssh_dir$device_ssh_key_filename" -q -N "" >>/dev/null 2>&1
  NOTICE "Done creating a private and public key on this device."

  manual_assert_file_exists "$device_ssh_dir$device_ssh_key_filename"
}

# This makes sure your client can show the server it should get access.
add_public_client_key_to_ssh_agent_of_this_device() {
  local device_ssh_dir="$1"
  local device_ssh_key_filename="$2"

  # Assert the private and public ssh key are created on client.
  manual_assert_file_exists "$device_ssh_dir$device_ssh_key_filename"

  NOTICE "Starting SSH agent on this device."
  # Start the ssh-agent in the background and prepare it for receiving
  # your client's ssh private key.
  eval "$(ssh-agent -s)"
  NOTICE "Adding private and public key pair:$device_ssh_dir$device_ssh_key_filename to ssh agent of this device."

  # Add your client's ssh private key to the client ssh-agent.
  # TODO: redirect output to proper logging tool.
  ssh-add "$CLIENT_SSH_DIR$CLIENT_SSH_KEY_NAME" >>/dev/null 2>&1
  NOTICE "Done adding public key: to ssh agent of this device"
  # TODO: Assert the ssh-key is added to the agent on this device.
}
