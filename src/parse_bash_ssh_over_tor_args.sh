#!/bin/bash

#!/bin/bash

parse_bash_ssh_over_tor_args() {
  local follower="false"
  local follower_password
  local follower_username
  local follower_local_ip_address

  # Parse long options using getopt
  OPTS=$(getopt -o f:i:u:p: --long follower:,follower-local-ip:,follower-username:,follower-password: -n 'parse-options' -- "$@")
  # shellcheck disable=SC2181
  if [ $? != 0 ]; then
    echo "Failed parsing options." >&2
    exit 1
  fi

  eval set -- "$OPTS"

  while true; do
    case "$1" in
      -f | --follower)
        follower="true"
        shift 2
        ;;
      -i | --follower-local-ip)
        follower_local_ip_address="$2"
        shift 2
        ;;
      -u | --follower-username)
        follower_username="$2"
        shift 2
        ;;
      -p | --follower-password)
        follower_password="$2"
        shift 2
        ;;
      --)
        shift
        break
        ;;
      *)
        echo "Invalid option: $1" >&2
        exit 1
        ;;
    esac
  done

  # Return values into a map.
  echo "$follower_username"
  echo "$follower_local_ip_address"
  echo "$follower_password"
  echo "$follower"
}
