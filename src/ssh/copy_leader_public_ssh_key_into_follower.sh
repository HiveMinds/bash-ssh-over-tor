#!/bin/bash

copy_public_key_to_follower() {
  local follower_ubuntu_username="$1"
  local follower_local_ip="$2"
  local ssh_port="$3"
  local path_to_local_leader_public_key="$4"
  local follower_ubuntu_password="$5"
  local path_to_local_follower_authorized_keys_dir="$6"
  local follower_auth_keys_storage_filename_with_ext="$7"
  # Assert "$8" is empty meaning no space that erroneously split the args.
  if [ "$8" != "" ]; then
    ERROR "Some of the arguments got split, probably because of a space in $ 3,4 or 5."
    exit 1
  fi

  # TODO: Assert file exists locally.
  manual_assert_file_exists "$path_to_local_leader_public_key"

  # TODO: Create the remote directory in Follower that stores the authorized_keys files.
  sshpass -p "$follower_ubuntu_password" ssh -p "$ssh_port" -o ConnectTimeout=5 "$follower_ubuntu_username@$follower_local_ip" mkdir -p "$path_to_local_follower_authorized_keys_dir" >/dev/null 2>&1
  NOTICE "After creating authorized public keys dir in Follower, the status is:$?"

  # TODO: assert target directory exists in follower.

  # TODO: delete target file if it already exists.
  sshpass -p "$follower_ubuntu_password" ssh -o ConnectTimeout=5 "$follower_ubuntu_username@$follower_local_ip" rm "$path_to_local_follower_authorized_keys_dir/$follower_auth_keys_storage_filename_with_ext" >/dev/null 2>&1
  NOTICE "After removing target public key from Follower, the status is:$?"
  # TODO: assert the target file does not exist in the Follower.

  # Copy the public SSH key from Leader into Follower.
  # If from local to remote, start with local filepath.
  # If from remote to local, end with local directory
  sshpass -p "$follower_ubuntu_password" scp "$path_to_local_leader_public_key" "$follower_ubuntu_username@$follower_local_ip:$path_to_local_follower_authorized_keys_dir/$follower_auth_keys_storage_filename_with_ext"
  NOTICE "After copying the public key from Leader into the authorized public keys dir in Follower, the status is:$?"

  # TODO: Assert Leader public key file exists remote.
}

function add_public_key_from_leader_into_follower_authorized_keys() {
  local follower_ubuntu_username="$1"
  local follower_local_ip="$2"
  local path_to_local_leader_public_key="$3"
  local follower_password="$4"
  echo "temporary filler:$follower_password"
  # TODO: Assert Leader public key file exists remote.

  # TODO: Add the Leader public key to the authorized_keys file on Follower.

  # TODO: Assert the Leader public key is in the authorized_keys file on Follower.
  NOTICE "TODO: add keys to authorized list in Follower."
}
