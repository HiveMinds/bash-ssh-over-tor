#!/bin/bash

# Started is for services when the computer is running, enabled is for boot.
function systemctl_status_is_started() {
  local service_name="$1"
  local systemctl_status
  systemctl_status=$(systemctl is-active "$service_name".service)
  INFO "active systemctl_status=$systemctl_status"
  if [ "$systemctl_status" = "active" ]; then
    return 0 # Service is active/started
  else
    return 1 # Service is not active/started
  fi
}

# Started is for services when the computer is running, enabled is for boot.
function systemctl_status_is_enabled() {
  local service_name="$1"
  local systemctl_status
  systemctl_status=$(systemctl is-enabled "$service_name".service)
  if [ "$systemctl_status" = "enabled" ]; then
    return 0 # Service is enabled
  else
    return 1 # Service is not enabled
  fi
}

# Started is for services when the computer is running, enabled is for boot.
function assert_is_started() {
  local service_name="$1"

  # Checking if the service is started.
  systemctl_status_is_started "$service_name"

  local status_code=$?
  if [ $status_code -eq 0 ]; then
    NOTICE "Service $service_name is started."
  else
    ERROR "Service $service_name is not started."
    exit 1
  fi
}

# Started is for services when the computer is running, enabled is for boot.
function assert_is_enabled() {
  local service_name="$1"

  # Checking if the service is enabled.
  systemctl_status_is_enabled "$service_name"

  local status_code=$?
  if [ $status_code -eq 0 ]; then
    NOTICE "Service $service_name is enabled (running at boot)."
  else
    ERROR "Service $service_name is not enabled (not running at boot)."
    exit 1
  fi
}

function ensure_service_is_started() {
  local service_name="$1"

  # Checking if the service is running using systemctl_status_is_running function
  systemctl_status_is_started "$service_name"

  local status_code=$?
  INFO "systemctl_status_is_started status_code=$status_code"
  if [ $status_code -eq 0 ]; then
    # Service is started, assert it is.
    assert_is_started "$service_name"
  else
    # Service is not started, start it.
    sudo systemctl start "$service_name".service
    assert_is_started "$service_name"
  fi
}

function ensure_service_starts_at_boot() {
  local service_name="$1"

  # Checking if the service is running using systemctl_status_is_running function
  systemctl_status_is_enabled "$service_name"

  local status_code=$?
  if [ $status_code -eq 0 ]; then
    # Service is enabled, assert it is.
    assert_is_enabled "$service_name"
  else
    # Service is not yet enabled, enable it, then assert it is enabled.
    sudo systemctl enable "$service_name".service
    assert_is_enabled "$service_name"
  fi
}
