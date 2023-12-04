#!/bin/bash

add_public_key_from_leader_into_follower_authorized_keys() {
  local follower_ubuntu_username="$1"
  local follower_local_ip="$2"
  local ssh_port="$3"
  local path_to_local_leader_public_key="$4"
  local follower_ubuntu_password="$5"
  # Assert "$6" is empty meaning no space that erroneously split the args.
  if [ "$6" != "" ]; then
    ERROR "Some of the arguments got split, probably because of a space in $ 3,4 or 5."
    exit 1
  fi
  if [ "$path_to_local_leader_public_key" == "" ]; then
    ERROR "The path to the local leader public key is empty."
    exit 1
  fi
  NOTICE "Asserting the file:$path_to_local_leader_public_key exists."
  manual_assert_file_exists "$path_to_local_leader_public_key"

  # Add the public key from Leader into Follower.
  # TODO: do not add it if it already is in there.
  sshpass -p "$follower_ubuntu_password" ssh-copy-id -p "$ssh_port" -i "$path_to_local_leader_public_key" -o ConnectTimeout=5 "$follower_ubuntu_username@$follower_local_ip"
  NOTICE "After copying the public key from Leader into the authorized public keys dir in Follower, the status is:$?"

  # Assert can ssh into Follower using the public key.
  assert_can_locally_ssh_with_public_key "$follower_ubuntu_username" "$follower_local_ip" "$ssh_port" "$follower_ubuntu_password"
}
