#!/bin/bash

# Globals are loaded using an import, hence, they do not need to be exported.
# shellcheck disable=SC2034
PATH_TO_LOCAL_LEADER_PUBLIC_KEY="$HOME/.ssh/client_ssh.pub"
PATH_TO_LOCAL_LEADER_PRIVATE_KEY="$HOME/.ssh/client_ssh"
PATH_TO_LOCAL_FOLLOWER_AUTHORIZED_KEYS_DIR="$HOME/.ssh/authorized_keys"
DEVICE_SSH_PRIVATE_KEY_FILENAME="client_ssh"
DEVICE_SSH_DIR="$HOME/.ssh"
