#!/bin/bash

# Function: ufw_is_enabled
#
# Checks if the Uncomplicated Firewall (UFW) is enabled.
# Returns 0 if UFW is enabled, 1 otherwise.
function ufw_is_enabled() {
  if sudo ufw status | grep -q "Status: active"; then
    return 0 # UFW is enabled
  else
    return 1 # UFW is not enabled
  fi
}

# Started is for services when the computer is running, enabled is for boot.
function assert_uwf_is_activated() {

  # Checking if the service is started.
  ufw_is_enabled

  local status_code=$?
  if [ $status_code -eq 0 ]; then
    NOTICE "Uncomplicated Firewal (UWF) is enabled."
  else
    ERROR "Uncomplicated Firewal (UWF) is not enabled."
    exit 1
  fi
}

# Started is for services when the computer is running, enabled is for boot.
function assert_uwf_is_not_activated() {

  # Checking if the service is started.
  ufw_is_enabled

  local status_code=$?
  if [ $status_code -eq 0 ]; then
    ERROR "Uncomplicated Firewal (UWF) is activated."
    exit 1
  else
    NOTICE "Uncomplicated Firewal (UWF) is not activated."
  fi
}

# TODO: Instead of testing the UFW is not active, test if SSH is allowed.
function ensure_uwf_is_enabled() {

  # Checking if the service is running using systemctl_status_is_running function
  ufw_is_enabled

  local status_code=$?
  INFO "ufw_is_enabled status_code=$status_code"
  if [ $status_code -eq 0 ]; then
    # The firewall is still active, allow ssh.
    sudo ufw allow ssh
    assert_uwf_is_not_activated
  else
    # The firewall is still active, to be sure, allow ssh.
    sudo ufw allow ssh
    assert_uwf_is_not_activated
  fi
}
