#!/bin/bash

# Globals are loaded using an import, hence, they do not need to be exported.
# shellcheck disable=SC2034
PATH_TO_LOCAL_LEADER_PUBLIC_KEY="$HOME/.ssh/client_ssh.pub"
PATH_TO_LOCAL_LEADER_PRIVATE_KEY="$HOME/.ssh/client_ssh"
RELATIVE_PATH_TO_EXTERNAL_FOLLOWER_AUTHORIZED_KEYS_DIR=".ssh/authorized_keys_storage"
DEVICE_SSH_PRIVATE_KEY_FILENAME="client_ssh"
DEVICE_SSH_DIR="$HOME/.ssh"
