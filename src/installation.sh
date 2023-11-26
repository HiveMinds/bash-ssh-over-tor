#!/bin/bash

function install_ssh_requirements() {
  ensure_apt_pkg "openssh-server" 0
  ensure_apt_pkg "openssh-server" 0
  ensure_apt_pkg "curl" 0
  ensure_apt_pkg "net-tools" 0
  ensure_apt_pkg "openssh-client" 0
  ensure_apt_pkg "torsocks" 0
  ensure_apt_pkg "tor" 1
  ensure_pip_pkg "dash" 0
}
