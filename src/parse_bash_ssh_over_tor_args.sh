#!/bin/bash

#!/bin/bash

parse_bash_ssh_over_tor_args() {
  local follower="false"
  local follower_password
  local follower_ubuntu_username
  local ssh_port
  local follower_local_ip

  # Parse long options using getopt
  OPTS=$(getopt -o f:i:u:pw:po --long follower,follower-local-ip:,follower-username:,follower-password:,port: -n 'parse-options' -- "$@")
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
        shift 1
        ;;
      -i | --follower-local-ip)
        follower_local_ip="$2"
        shift 2
        ;;
      -u | --follower-username)
        follower_ubuntu_username="$2"
        shift 2
        ;;
      -pw | --follower-password)
        follower_password="$2"
        shift 2
        ;;
      -po | --port)
        ssh_port="$2"
        shift 2
        ;;
      --)
        shift
        break
        ;;
      *)
        echo "Invalid option: $1." >&2
        exit 1
        ;;
    esac
  done

  # Return values into a map.
  echo "$follower_ubuntu_username"
  echo "$follower_local_ip"
  echo "$follower_password"
  echo "$ssh_port"
  echo "$follower"
}
