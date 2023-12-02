#!/bin/bash

copy_public_key_to_follower() {

  local follower_username="$1"
  local follower_ip="$2"
  local path_to_local_leader_public_key="$3"
  local follower_password="$4"
  local path_to_remote_follower_storage_of_authorized_keys_folder="$5"
  # TODO: assert "$6" is empty meaning no space that erroneously split the args.

  # TODO: Assert file exists locally.

  # TODO: Create the remote directory in Follower that stores the authorized_keys files.

  # TODO: delete target file if it already exists.

  # TODO: assert the target file does not exist in the Follower.

  # TODO: Assert the remote directory exists in Follower.

  # Copy the public SSH key from Leader into Follower.
  # If from local to remote, start with local filepath.
  # If from remote to local, end with local directory
  sshpass -p "$follower_password" scp "$path_to_local_leader_public_key" "$follower_username@$follower_ip:$path_to_remote_follower_storage_of_authorized_keys_folder"

  # TODO: Assert Leader public key file exists remote.
}

function add_public_key_from_leader_into_follower_authorized_keys() {
  local follower_username="$1"
  local follower_ip="$2"
  local path_to_local_leader_public_key="$3"
  local follower_password="$4"

  # TODO: Assert Leader public key file exists remote.

  # TODO: Add the Leader public key to the authorized_keys file on Follower.

  # TODO: Assert the Leader public key is in the authorized_keys file on Follower.

}
