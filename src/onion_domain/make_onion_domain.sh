#!/bin/bash

kill_tor_if_already_running() {
  local output
  local normal_tor_closed
  local sudo_tor_closed
  while true; do
    output=$(netstat -ano | grep LISTEN | grep 9050)
    INFO "netstat output=$output"
    if [[ "$output" != "" ]]; then
      sudo killall tor
      # TODO: move into stopping equivalent of ensure_service_is_started.
      sudo systemctl stop tor
      normal_tor_closed="false"
      INFO "Killed and stopped tor, because there was a non-sudo tor instance running."
      sleep 2

    else
      NOTICE "non-sudo tor is killed and stopped."
      normal_tor_closed="true"
    fi

    sudo_output=$(sudo netstat -ano | grep LISTEN | grep 9050)
    INFO "SUDO netstat output=$output"
    if [[ "$sudo_output" != "" ]]; then
      # sudo kill -9 `pidof tor`
      sudo killall tor
      sudo systemctl stop tor
      sudo_tor_closed="false"
      INFO "Killed and stopped tor, because there was a sudo tor instance running."
      sleep 2
    else
      NOTICE "SUDO tor is killed and stopped."
      sudo_tor_closed="true"
    fi
    if [[ "$normal_tor_closed" == "true" ]] && [[ "$sudo_tor_closed" == "true" ]]; then
      NOTICE "Both non-sudo and sudo tor are stopped."
      return 0
    fi
  done
}
