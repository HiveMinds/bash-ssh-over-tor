#!/bin/bash

function start_config_at_leader() {
  # Ensure ssh is installed on Leader.
  # Assert the user can SSH into Follower using username and ip-address.

  # Generate the private and public key pair on Leader.
  # Add the SSH key to the ssh-agent on Leader.
  # SSH into Follower and copy the public key from Leader into Follower.

  # Start the Tor service at boot on Follower.

  # Return the onion domain of Follower back into Leader.
  echo "Hello World."
}

function configure_ssh_over_tor_at_boot() {
  local server_username="$1"
  local server_onion_domain="$2"
  ensure_tor_starts_at_boot

  # Now that tor is started, generate an onion domain.

  # TODO: include arg flag that can distinguish between running this code on
  # server or client. Use this flag to ask the server_username if it is on client.
  inject_ssh_creds_from_controller_into_tor_server_machine "$server_username" "$server_onion_domain"

}

function ensure_tor_starts_at_boot() {
  # Execute prerequisites installation.
  install_tor_and_ssh_requirements

  configure_tor_to_start_at_boot
}

function process_get_onion_domain_flag() {
  local process_get_onion_domain="$1"
  local services="$2"

  if [ "$process_get_onion_domain" == "true" ]; then
    echo "" # Create newline
    nr_of_services=$(get_nr_of_services "$services")
    start=0
    for ((project_nr = start; project_nr < nr_of_services; project_nr++)); do
      local project_name
      local public_port_to_access_onion

      project_name="$(get_project_property_by_index "$services" "$project_nr" "project_name")"
      public_port_to_access_onion="$(get_project_property_by_index "$services" "$project_nr" "external_port")"

      # Override global verbosity setting to show onion domains.
      if [[ "$project_name" == "ssh" ]]; then
        local onion_domain
        onion_domain=$(get_onion_domain "$project_name")

        echo "You can ssh into this server with command:"
        green_msg "torsocks ssh $(whoami)@$onion_domain" "true"
      else
        local onion_address
        onion_address="$(get_onion_address "$project_name" "true" "$public_port_to_access_onion")"
        echo "Your onion domain for:$project_name, is:"
        green_msg "$onion_address" "true"
      fi
    done
  fi
}
