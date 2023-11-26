#!/bin/bash
start_tor_in_background() {
  local wait_time_sec=260

  sudo tor | tee "$TOR_LOG_FILEPATH" >/dev/null &
  start_time=$(date +%s)

  while true; do
    error_substring='\[err\]'
    if [ "$(file_contains_string "$error_substring" "$TOR_LOG_FILEPATH")" == "FOUND" ]; then
      INFO "$TOR_LOG_FILEPATH contained: $error_substring, so we are stopping it and restarting it."
      kill_tor_if_already_running
      sleep 5
      INFO "Tor is stopped, starting it again."
      sudo tor | tee "$TOR_LOG_FILEPATH" >/dev/null &
    else
      NOTICE "The $TOR_LOG_FILEPATH did not contain: $error_substring, so we are checking the tor status."
      local tor_status
      tor_status="$(tor_is_connected)"
      INFO "tor_status=$tor_status"
      if [[ "$(tor_is_connected)" == "FOUND" ]]; then
        NOTICE "Successfully setup tor connection."
        return 0
      else
        INFO "Tor was not found to be connected. Re-starting the loop."
        sleep 1
      fi
    fi
    sleep 1

    # Calculate the elapsed time from the start of the function
    elapsed_time=$(($(date +%s) - start_time))

    # If wait_time_sec seconds have passed, raise an exception and return 6.
    if ((elapsed_time > wait_time_sec)); then
      kill_tor_if_already_running
      ERROR "Error: a tor connection was not created after $wait_time_sec seconds."
      exit 6
    fi
    INFO "Waiting another 5 seconds before checking the tor status again."

    # Wait for 5 seconds before checking again.
    sleep 5
  done

}
