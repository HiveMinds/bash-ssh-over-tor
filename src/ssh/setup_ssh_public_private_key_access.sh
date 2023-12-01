#!/bin/bash

# Naming conventions:
# server - The pc that you access and control.
# client - The pc that you use to control the server.

# By default ssh access happens through password. This is unsafe. Instead,
# Generate a private and public key on your client. Then send that public key
# to your server (the one with the onion domain). Then add that public key
# to the ssh-agent of/in the client.
#
# (Such that when the server sees your client trying to ssh access the server
# with the client private key, and the server asks the ssh-agent in your
#client: "solve this prime with your private key"), the ssh-agent in your
# client knows where to find the private key.

export_public_client_key_into_server() {
  local server_username="$1"
  local server_onion_domain="$2"

  assert_is_non_empty_string "${server_username}"
  assert_is_non_empty_string "${server_onion_domain}"

  manual_assert_file_exists "$CLIENT_SSH_DIR$CLIENT_SSH_KEY_NAME"

  # TODO: Assert the private key is in the client ssh-agent.

  # Install the client public key into the server.
  torsocks ssh-copy-id -i "$CLIENT_SSH_DIR$CLIENT_SSH_KEY_NAME" "$server_username@$server_onion_domain"
}
